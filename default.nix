{ pkgs ? <nixpkgs>, nodejs ? pkgs.nodejs-12_x, stdenv ? pkgs.stdenv, lib ? pkgs.lib }:

let
  since = (version: pkgs.lib.versionAtLeast nodejs.version version);
  before = (version: pkgs.lib.versionOlder nodejs.version version);
  super = import ./composition.nix {
    inherit pkgs nodejs;
    inherit (stdenv.hostPlatform) system;
  };
  self = super // {
    balena-cli = super.balena-cli.override {
      buildInputs = [ self.node-pre-gyp self.node-gyp-build ];
      meta = super.balena-cli.meta // {
        maintainers = with lib.maintainers; [ doronbehar ];
      };
    };
  };
in self
