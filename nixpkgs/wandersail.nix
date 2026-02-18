{ config, pkgs, ... }:

{
  imports = [ ./common.nix ./linux.nix ];

  home.packages = with pkgs; [
    networkmanager_dmenu
    pdfpc
    perf
  ];
}
