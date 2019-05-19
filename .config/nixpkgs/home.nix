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
    jetbrains.clion elan gitAndTools.hub gitAndTools.tig python3
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
    sessionVariables = {
      # hide user in shell prompt
      DEFAULT_USER = "sebastian";
      # disable default rprompt...?
      RPROMPT = "";
      # fix Java programs on sway
      _JAVA_AWT_WM_NONREPARENTING = 1;
    };
    shellAliases = {
      ls = "exa";
      ssh = "TERM=xterm-256color ssh";
    };
    initExtra = ''
      # https://github.com/NixOS/nixpkgs/issues/30121
      setopt prompt_sp
    '';
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
