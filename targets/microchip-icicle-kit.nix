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
          inherit system pkgs;
          specialArgs = {inherit lib self system inputs;};
          modules =
            [
              inputs.nixos-hardware.nixosModules.microchip-icicle-kit
              ../modules/hardware/polarfire/mpfs-nixos-sdimage.nix
              ../modules/host
              {
                appstream.enable = false;
                boot = {
                  enableContainers = false;
                  loader = {
                    grub.enable = false;
                    generic-extlinux-compatible.enable = true;
                  };
                };

                # Disable all the default UI applications
                ghaf = {
                  profiles = {
                    applications.enable = false;
                    graphics.enable = false;
                    #TODO clean this up when the microvm is updated to latest
                    release.enable = variant == "release";
                    debug.enable = variant == "debug";
                  };
                  development = {
                    debug.tools.enable = variant == "debug";
                    ssh.daemon.enable = true;
                  };
                  windows-launcher.enable = false;
                };
                nixpkgs = {
                  buildPlatform.system = "x86_64-linux";
                  hostPlatform.system = "riscv64-linux";
                };
                boot.kernelParams = ["root=/dev/mmcblk0p2" "rootdelay=5"];
                disabledModules = ["profiles/all-hardware.nix"];
              }
            ]
            ++ (import ../modules/module-list.nix)
            ++ extraModules;
        };
    in
      # todo this target doesn't expost a nixos-generators based image
      # it was using `hostConfiguration.config.system.build.sdImage;`
      lib.mkIf (system == "riscv64-linux") {
        microchip-icicle-kit-debug = mkNixosConfig {variant = "debug";};
        microchip-icicle-kit-release = mkNixosConfig {variant = "release";};
      };
  };
}
