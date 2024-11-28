{ config, pkgs, ... }:

in {
  imports = [ ./common.nix ./linux.nix ];

  programs.home-manager.enable = true;
  targets.genericLinux.enable = true;
}
