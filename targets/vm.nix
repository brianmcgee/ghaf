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
      mkNixosConfig = variant:
        lib.nixosSystem {
          inherit system pkgs;
          specialArgs = {inherit lib self system inputs;};
          modules =
            [
              inputs.microvm.nixosModules.host
              inputs.nixos-generators.nixosModules.vm
              ../modules/host
              ../modules/virtualization/microvm/microvm-host.nix
              ../modules/virtualization/microvm/netvm.nix

              {
                ghaf = {
                  hardware.x86_64.common.enable = true;

                  virtualization.microvm-host.enable = true;
                  host.networking.enable = true;
                  # TODO: NetVM enabled, but it does not include anything specific
                  #       for this Virtual Machine target
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
            ++ (import ../modules/module-list.nix);
        };
    in
      lib.mkIf (system == "x86_64-linux") {
        vm-debug = mkNixosConfig "debug";
        vm-release = mkNixosConfig "release";
      };
  };
}
