{ config, pkgs, ... }:

let nixGL = pkgs.callPackage (import (builtins.fetchGit { url = "https://github.com/guibou/nixGL"; ref = "main"; rev = "c4aa5aa15af5d75e2f614a70063a2d341e8e3461"; })) { inherit pkgs; };
in {
  imports = [ ./common.nix ./linux.nix ];

  home.packages = with pkgs; [
    nixGL.nixGLIntel
    thunderbird
  ];
  programs.home-manager.enable = true;
  targets.genericLinux.enable = true;
}
