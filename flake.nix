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
    nixpkgs.url = "github:NixOs/nixpkgs/nixos-26.05";
    rust-overlay.url = "github:oxalica/rust-overlay";

  };

  outputs = { self, nixpkgs, rust-overlay, ...}@inputs:
    let 
      system = "aarch64-linux";
      pkgs = import nixpkgs {inherit system; overlays = [ rust-overlay.overlay ];};
    in
    {
      
      formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.nixfmt-tree;
      formatter.aarch64-linux = nixpkgs.legacyPackages.aarch64-linux.nixfmt-tree;

      nixosConfigurations.callisto = {
        specialArgs = { inherit inputs; };
        modules = [
          ./modules/packages/default.nix
          {
            development-packages = true;
            jupiter-packages = true;
          }
        ];
      };

      nixosConfigurations.ursa = {
        specialArgs = { inherit inputs; };
        modules = [ ./modules/packages/default.nix
          {
            development-packages = true;
            ursa-packages = true;
          }];
      };

      nixosConfigurations.flight-callisto = {
        specialArgs = { inherit inputs; };
        modules = [
           ./modules/packages/default.nix
          {
            jupiter-packages = true;}
        ];
      };
  
      nixosConfigurations.flight-ursa = {
        specialArgs = { inherit inputs; };
        modules = [
           ./modules/packages/default.nix
          {
            ursa-packages = true;
      }];
      };
    };
}