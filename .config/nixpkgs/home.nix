{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    # window manager
    sway xwayland i3status mako grim slurp wl-clipboard
    # system
    pavucontrol xdg_utils gnome3.adwaita-icon-theme
    # fonts!
    iosevka
    # editing
    emacs ispell vim_configurable
    # dev
    jetbrains.clion elan gitAndTools.hub gitAndTools.tig python3Packages.ipython lorri
    # other desktop apps
    firefox chromium evince
    # other cli apps
    fasd htop mpv file
    # Rust all the things
    alacritty exa fd ripgrep
  ];

  programs.direnv.enable = true;
  programs.fzf.enable = true;
  programs.git.enable = true;

  gtk.enable = true;
  fonts.fontconfig.enable = true;
  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "application/pdf" = [ "org.gnome.Evince.desktop" ];
      "x-scheme-handler/http" = [ "firefox.desktop" ];
      "x-scheme-handler/https" = [ "firefox.desktop" ];
    };
  };

  # on second thought, just use spacemacs
  #programs.emacs = {
  #  enable = true;
  #  extraPackages = epkgs: [ epkgs.magit ];
  #};

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    oh-my-zsh = {
      enable = true;
      plugins = [ "fasd" "per-directory-history" ];
      theme = "agnoster";
    };
    sessionVariables = {
      # vim is the default editor
      EDITOR = "vim";
      # hide user in shell prompt
      DEFAULT_USER = "sebastian";
      # disable default rprompt...?
      RPROMPT = "";
      # fix Java programs on sway
      _JAVA_AWT_WM_NONREPARENTING = 1;
      # fix locales for Nix on Ubuntu
      LOCALE_ARCHIVE_2_27 = "${pkgs.glibcLocales}/lib/locale/locale-archive";
      XDG_DATA_DIRS = "$XDG_DATA_DIRS:$HOME/.nix-profile/share";
    };
    shellAliases = {
      ls = "exa";
      ssh = "TERM=xterm-256color ssh";
      p = "noglob p";
    };
    initExtra = ''
      p() ${pkgs.python}/bin/python -c "from math import *; print($*);"
      export PATH=$PATH:~/bin
      # https://github.com/NixOS/nixpkgs/issues/30121
      setopt prompt_sp
    '';
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  home.stateVersion = "18.09";
}
