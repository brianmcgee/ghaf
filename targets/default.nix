# Copyright 2022-2023 TII (SSRC) and the Ghaf contributors
# SPDX-License-Identifier: Apache-2.0
#
# List of target configurations
{...}: {
  imports = [
    ./vm.nix
  ];

  perSystem = {
    lib,
    config,
    ...
  }: {
    # for each nixos configuration we capture it's package based on the
    # configured format of the image
    packages =
      lib.mapAttrs
      (_: v: v.config.system.build.${v.config.formatAttr})
      config.nixosConfigurations;
  };
}
#lib.foldr lib.recursiveUpdate {} [
#  #    (import ./nvidia-jetson-orin {inherit lib nixpkgs nixos-generators microvm jetpack-nixos;})
#  #    (import ./vm.nix {inherit lib nixos-generators microvm;})
#  #    (import ./generic-x86_64.nix {inherit lib nixos-generators microvm;})
#  #    (import ./lenovo-x1-carbon.nix {inherit lib nixos-generators microvm lanzaboote;})
#  #    (import ./imx8qm-mek.nix {inherit lib nixos-generators nixos-hardware microvm;})
#  #    (import ./microchip-icicle-kit.nix {inherit lib nixpkgs nixos-hardware;})
#]

