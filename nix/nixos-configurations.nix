# Copyright 2022-2023 TII (SSRC) and the Ghaf contributors
# SPDX-License-Identifier: Apache-2.0
{
  lib,
  config,
  flake-parts-lib,
  ...
}: let
  inherit (config) systems allSystems;
in {
  options.perSystem = flake-parts-lib.mkPerSystemOption {
    options.nixosConfigurations = with lib;
      mkOption {
        description = ''tbd'';
        type = types.lazyAttrsOf types.unspecified;
        default = {};
      };
  };

  config = {
    flake = {
      nixosConfigurations = with lib;
        builtins.foldl'
        (x: y: x // y) {}
        (attrValues (genAttrs systems (system: allSystems.${system}.nixosConfigurations)));
    };

    perSystem = {config, ...}: {
      # Add all the nixos configurations to the checks
      checks =
        lib.mapAttrs'
        (name: value: {
          name = "nixos-toplevel-${name}";
          value = value.config.system.build.toplevel;
        })
        config.nixosConfigurations;
    };
  };
}
