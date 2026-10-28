{lib, config, pkgs, ...} : {
  imports = [ ./dev-packages.nix ] ;

  options = {
    development-packages = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable development packages";
    };

    jupiter-packages = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable JUPITER's packages";
    };

    ursa-packages = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable URSA's packages";
    };
  };

config = lib.mkMerge [
#      ( lib.mkIf (config.development-packages) {
#  imports = [ ./dev-packages.nix ] ;
#} )
#( lib.mkIf (config.jupiter-packages) {
#  imports = [ ./jupiter-packages.nix ] ;
#} )
#( lib.mkIf (config.ursa-packages) {
#  imports = [ ./ursa-packages.nix ] ;
#} )
((lib.mkIf (true)) {
  environment.systemPackages = with pkgs; [
    iw

    libgpiod
    i2c-tools
    v4l-utils
    ffmpeg 
  ];
}) 
];


  

}