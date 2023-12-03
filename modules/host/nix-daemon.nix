# Copyright 2022-2023 TII (SSRC) and the Ghaf contributors
# SPDX-License-Identifier: Apache-2.0
{
  pkgs,
  inputs,
  ...
}: {
  nix = {
    nixPath = [
      "nixpkgs=${pkgs.path}"
    ];
    registry = {
      nixpkgs.to = {
        type = "path";
        path = inputs.nixpkgs;
      };
    };
  };
}
