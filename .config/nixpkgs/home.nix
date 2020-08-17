{ config, pkgs, ... }:

let unstable = import <unstable> {};
in {
  imports = if builtins.pathExists ./local.nix then [ ./local.nix ] else [];

  home.packages = with pkgs; [
    # window manager
    sway xwayland i3status mako grim slurp wl-clipboard
    # system
    pavucontrol xdg_utils gnome3.adwaita-icon-theme
    # fonts!
    iosevka
    # editing
    emacs ispell vim_configurable libreoffice
    # dev
    jetbrains.clion elan gitAndTools.hub gitAndTools.tig gdb meld rr
    # other desktop apps
    firefox chromium evince
    # other cli apps
    fasd htop mpv file unzip
    # Rust all the things
    # magit-delta needs delta >= 0.0.18
    exa fd ripgrep unstable.gitAndTools.delta
  ];

  programs.direnv.enable = true;
  programs.fzf.enable = true;
  programs.git.enable = true;
  programs.alacritty = {
    enable = true;
    settings = {
      font = {
        size = 11;
        normal.family = "Iosevka";
      };
      colors = {
        primary = {
          background = "0x3f3f3f";
          foreground = "0xeaeaea";
        };
        normal = {
          black =   "0x000000";
          red =     "0xd54e53";
          green =   "0xb9ca4a";
          yellow =  "0xe6c547";
          blue =    "0x7aa6da";
          magenta = "0xc397d8";
          cyan =    "0x70c0ba";
          white =   "0xeaeaea";
        };
        bright = {
          black =   "0x666666";
          red =     "0xff3334";
          green =   "0x9ec400";
          yellow =  "0xe7c547";
          blue =    "0x7aa6da";
          magenta = "0xb77ee0";
          cyan =    "0x54ced6";
          white =   "0xffffff";
        };
      };
    };
  };

  services.lorri.enable = true;

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
