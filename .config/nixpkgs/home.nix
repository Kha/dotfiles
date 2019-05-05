{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    # window manager
    sway i3status
    # system
    pavucontrol
    # fonts!
    iosevka-ss09
    # editing
    emacs ispell vim_configurable
    # dev
    gitAndTools.tig elan
    # other desktop apps
    firefox chromium evince
    # other cli apps
    fasd htop
    # Rust all the things
    alacritty exa fd ripgrep
  ];

  programs.direnv.enable = true;
  programs.fzf.enable = true;
  programs.git.enable = true;

  # on second thought, just use spacemacs
  #programs.emacs = {
  #  enable = true;
  #  extraPackages = epkgs: [ epkgs.magit ];
  #};

  programs.zsh = {
    enable = true;
    oh-my-zsh = {
      enable = true;
      plugins = [ "fasd" "per-directory-history" ];
      theme = "agnoster";
    };
    shellAliases = {
      ls = "exa";
      ssh = "TERM=xterm-256color ssh";
    };
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
