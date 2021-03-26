{
  description = "NodeJS Packages built for NixOS automatically updated every day!";

  inputs.flake-utils.url = "github:numtide/flake-utils";

  outputs = { self
  , nixpkgs
  , flake-utils
  }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        lib = pkgs.lib;
        nodejsPackages = builtins.listToAttrs (builtins.map (
          val:
          lib.nameValuePair "${builtins.elemAt (lib.splitString "." val.version) 0}" val
        ) [
          pkgs.nodejs-15_x
          pkgs.nodejs-14_x
          pkgs.nodejs-12_x
          pkgs.nodejs-10_x
        ]);
        nodejsPackages_ = builtins.trace "nodejsPackages is ${builtins.toJSON nodejsPackages}" nodejsPackages;
      in rec {
        packages_ = lib.mapAttrs(
          name:
          nodejsPkg:
          (import ./default.nix {
            inherit pkgs;
            stdenv = pkgs.stdenv;
            nodejs = nodejsPkg;
          })
        ) nodejsPackages_;
        # packages = builtins.trace "packages are ${builtins.toJSON packages_}" (flake-utils.lib.flattenTree packages_);
        packages = import ./default.nix {
          inherit pkgs;
          stdenv = pkgs.stdenv;
          lib = pkgs.lib;
          nodejs = pkgs.nodejs-12_x;
        };
        devShell = pkgs.mkShell {
          buildInputs = [
            pkgs.nodePackages.node2nix
          ];
        };
      }
    );
}
