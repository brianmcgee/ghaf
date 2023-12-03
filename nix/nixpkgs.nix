# Copyright 2022-2023 TII (SSRC) and the Ghaf contributors
# SPDX-License-Identifier: Apache-2.0
{
  lib,
  self,
  inputs,
  ...
}: {
  perSystem = {system, ...}: {
    # create a custom instance of nixpkgs with all our overlays and custom config
    # and make it available to all perSystem functions
    _module.args.pkgs = import inputs.nixpkgs {
      inherit system;
      overlays = import ../overlays;
      config = {
        allowUnfree = true;
      };
      specialArgs = {
        inherit self inputs lib system;
      };
    };
  };
}
