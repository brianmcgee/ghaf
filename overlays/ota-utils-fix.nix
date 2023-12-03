# Copyright 2022-2023 TII (SSRC) and the Ghaf contributors
# SPDX-License-Identifier: Apache-2.0
#
# This overlay is for fixing ota-utils.
#
# There is upstream PR waiting for review:
# https://github.com/anduril/jetpack-nixos/pull/162
#
(final: prev: {
  nvidia-jetpack =
    prev.nvidia-jetpack
    // {
      otaUtils = prev.nvidia-jetpack.otaUtils.overrideAttrs (_finalAttrs: prevAttrs: {
        depsBuildHost = [final.bash];
        installPhase =
          prevAttrs.installPhase
          + ''
            substituteInPlace $out/bin/* --replace '#!/usr/bin/env bash' '#!${final.bash}/bin/bash'
          '';
      });
    };
})
