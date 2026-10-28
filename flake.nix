{
  description = "Nixos config flake";

  nixConfig = {
    substituters = [
      "https://nix-community.cachix.org"
      "https://cache.nixos.org"
      "https://nixos-raspberrypi.cachix.org"
    ];
    
    extra-trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "nixos-raspberrypi.cachix.org-1:4iMO9LXa8BqhU+Rpg6LQKiGa2lsNh/j2oiYLNOQ5sPI="
    ];
  };

  inputs = {
    nixpkgs.url = "github:NixOs/nixpkgs/nixos-unstable";
    rust-overlay.url = "github:oxalica/rust-overlay";
    nixos-anywhere.url = "github:nix-community/nixos-anywhere";
    nixos-hardware = {
      url = "github:NixOS/nixos-hardware/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    #config-install = {
    #  url = "github.com:Tonez3D/nix-system-install";
    #};
  };

  outputs = { self, nixpkgs, rust-overlay, nixos-hardware, ...}@inputs:
  let 
    hostSystem = "aarch64-linux";
    pkgs = import nixpkgs { system = hostSystem; overlays = [ rust-overlay.overlays.default ]; };
  in
  {
      
    formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.nixfmt-tree;
    formatter.aarch64-linux = nixpkgs.legacyPackages.aarch64-linux.nixfmt-tree;

    nixosConfigurations."base" = nixpkgs.lib.nixosSystem {
      system = hostSystem;
      specialArgs = { inherit  inputs; };
      modules = [ 
        ./modules/packages/default.nix
        {
          development-packages = true;
        }
        nixos-hardware.nixosModules.raspberry-pi-5
      ];
    };

    nixosConfigurations."base-image" = nixpkgs.lib.nixosSystem {
      specialArgs = { inherit inputs; };
      modules = [ 
        ./modules/packages/default.nix
        {
          nixpkgs.buildPlatform = "x86_64-linux";
          nixpkgs.hostPlatform = "aarch64-linux";
          development-packages = true;
        }
        ./configuration.nix
        nixos-hardware.nixosModules.raspberry-pi-5
        "${nixpkgs}/nixos/modules/installer/sd-card/sd-image-aarch64.nix"
      ];
    };

    nixosConfigurations."callisto" = nixpkgs.lib.nixosSystem {
      system = hostSystem;
      specialArgs = { inherit inputs; };
      modules = [
        nixos-hardware.nixosModules.raspberry-pi-5
        ./modules/packages/default.nix
        {
          development-packages = true;
          jupiter-packages = true;
        }
      ];
    };

    nixosConfigurations."callisto-image" = nixpkgs.lib.nixosSystem {
      system = hostSystem;
      specialArgs = { inherit inputs; };
      modules = [
        ./modules/packages/default.nix
        nixos-hardware.nixosModules.raspberry-pi-5
        "${nixpkgs}/nixos/modules/installer/sd-card/sd-image-aarch64.nix"
        {
          development-packages = true;
          jupiter-packages = true;
        }
      ];
    };

    nixosConfigurations."ursa" = nixpkgs.lib.nixosSystem {
      system = hostSystem;
      specialArgs = { inherit inputs; };
      modules = [ ./modules/packages/default.nix
        {
          development-packages = true;
          ursa-packages = true;
        }      
        nixos-hardware.nixosModules.raspberry-pi-5

      ];
    };

    nixosConfigurations."ursa-image" = nixpkgs.lib.nixosSystem {
      system = hostSystem;
      specialArgs = { inherit inputs; };
      modules = [ ./modules/packages/default.nix       
       "${nixpkgs}/nixos/modules/installer/sd-card/sd-image-aarch64.nix"
        nixos-hardware.nixosModules.raspberry-pi-5
        {
          development-packages = true;
          ursa-packages = true;
        }
      ];
    };

    nixosConfigurations."flight-callisto" = nixpkgs.lib.nixosSystem {
      system = hostSystem;
      specialArgs = { inherit inputs; };
      modules = [
        nixos-hardware.nixosModules.raspberry-pi-5
        ./modules/packages/default.nix
        "${nixpkgs}/nixos/modules/installer/sd-card/sd-image-aarch64.nix"
        {
          jupiter-packages = true;
        }
      ];
    };

    nixosConfigurations."flight-callisto-image" = nixpkgs.lib.nixosSystem {
      system = hostSystem;
      specialArgs = { inherit inputs; };
      modules = [
        "${nixpkgs}/nixos/modules/installer/sd-card/sd-image-aarch64.nix"
          nixos-hardware.nixosModules.raspberry-pi-5
         ./modules/packages/default.nix
        {
          jupiter-packages = true;
        }
      ];
    };
  
    nixosConfigurations."flight-ursa" = nixpkgs.lib.nixosSystem {
      system = hostSystem;
      specialArgs = { inherit inputs; };
      modules = [
        ./modules/packages/default.nix
        {
          ursa-packages = true;
        }
        nixos-hardware.nixosModules.raspberry-pi-5
      ];
    };

    nixosConfigurations."flight-ursa-image" = nixpkgs.lib.nixosSystem {
      system = hostSystem;
      specialArgs = { inherit inputs; };
      modules = [
        "${nixpkgs}/nixos/modules/installer/sd-card/sd-image-aarch64.nix"
        nixos-hardware.nixosModules.raspberry-pi-5
        ./modules/packages/default.nix
        {
          ursa-packages = true;
        }
      ];
    };
  };
}