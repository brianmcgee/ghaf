# Copyright 2022-2023 TII (SSRC) and the Ghaf contributors
# SPDX-License-Identifier: Apache-2.0
{
  self,
  inputs,
  ...
}: {
  perSystem = {
    lib,
    pkgs,
    system,
    ...
  }: {
    nixosConfigurations = let
      mkNixosConfig = {
        variant,
        extraModules ? [],
      }:
        lib.nixosSystem {
          inherit system;
          specialArgs = {inherit lib pkgs self system inputs;};
          modules =
            [
              inputs.microvm.nixosModules.host
              inputs.nixos-hardware.nixosModules.nxp-imx8qm-mek
              inputs.nixos-generators.nixosModules.raw-efi

              ../modules/host
              ../modules/virtualization/microvm/microvm-host.nix
              ../modules/virtualization/microvm/netvm.nix
              {
                ghaf = {
                  virtualization.microvm-host.enable = true;
                  host.networking.enable = true;
                  # TODO: NetVM enabled, but it does not include anything specific
                  #       for iMX8
                  virtualization.microvm.netvm.enable = true;

                  # Enable all the default UI applications
                  profiles = {
                    applications.enable = true;
                    #TODO clean this up when the microvm is updated to latest
                    release.enable = variant == "release";
                    debug.enable = variant == "debug";
                  };
                };
              }
            ]
            ++ (import ../modules/module-list.nix)
            ++ extraModules;
        };
    in
      lib.mkIf (system == "aarch64-linux") {
        imx8qm-mek-debug = mkNixosConfig {variant = "debug";};
        imx8qm-mek-release = mkNixosConfig {variant = "release";};
      };
  };
}
