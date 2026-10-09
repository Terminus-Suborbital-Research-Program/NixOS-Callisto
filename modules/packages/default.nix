{pkgs, ...} : {

  options = {
    development-packages = mkOption {
      type = types.bool;
      default = false;
      description = "Enable development packages";
    };

    jupiter-packages = mkOption {
      type = types.bool;
      default = false;
      description = "Enable JUPITER's packages";
    };

    ursa-packages = mkOption {
      type = types.bool;
      default = false;
      description = "Enable URSA's packages";
    };
  };

config = mkIf config.development-packages {
  imports = [ ./dev-packages.nix ] ;
};

config = mkIf config.jupiter-packages {
  imports = [ ./jupiter-packages.nix ];
};

config = mkIf config.ursa-packages {
  imports = [ ./ursa-packages.nix ];
};

  environment.systemPackages = with pkgs; [
    iw

    libgpiod
    i2c-tools
    v4l-utils
    ffmpeg 
  ];
}