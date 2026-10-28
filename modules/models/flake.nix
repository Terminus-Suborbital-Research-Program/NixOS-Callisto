{
  description = "";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
  };
  
  outputs =
    inputs:
    let
      supportedSystems = [
        "x86_64-linux"
        "aarch64-linux"
      ];

      forEachSupportedSystem =
        f:
        inputs.nixpkgs.lib.genAttrs supportedSystems (
          system:
          f {
            pkgs = import inputs.nixpkgs { inherit system; };
            inherit system;
          }
        );
    in
    {
      devShells = forEachSupportedSystem (
        { pkgs, system }:
        let
          pythonEnv = [
            pkgs.python312Packages.tensorflow
            pkgs.python312Packages.pandas
            pkgs.python312Packages.ultralytics
            pkgs.python312Packages.matplotlib
            pkgs.python312Packages.scipy
            pkgs.python312Packages.onnxruntime
            pkgs.python312Packages.tf2onnx
            pkgs.python312Packages.sympy
            pkgs.python312Packages.tensorflow-probability
            pkgs.python312Packages.typeguard
            #pkgs.python312Packages.numpy
          ];
        in
        {
          default = pkgs.mkShell {
            buildInputs = [
              pythonEnv
              pkgs.python312
              pkgs.stdenv.cc.cc.lib
              pkgs.python312Packages.pip
              pkgs.python312Packages.virtualenv
              pkgs.gnumake
              pkgs.gcc
              pkgs.pkg-config
            ];
            shellHook = ''python3 -m venv .venv
                         source .venv/bin/activate
                         pip install -r requirements.txt'';
          };

        }
      );
    };
}