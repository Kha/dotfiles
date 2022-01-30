{ config, pkgs, unstable, ... }:

let
  meld = pkgs.runCommand "${pkgs.meld.name}-wrapped" { buildInputs = [ pkgs.makeWrapper ]; } ''
    cp -r ${pkgs.meld} $out
    chmod u+w $out/bin $out/bin/meld
    makeWrapper ${pkgs.meld}/bin/meld \
      $out/bin/meld \
      --set GDK_PIXBUF_MODULE_FILE "${pkgs.librsvg.out}/lib/gdk-pixbuf-2.0/2.10.0/loaders.cache"
  '';
in {
  home.packages = with pkgs; [
    # fonts!
    emacs-all-the-icons-fonts
    # editing
    emacs ispell vim_configurable
    # dev
    gitAndTools.gh gitAndTools.tig gdb meld python3 binutils jq
    # other cli apps
    fasd htop mpv file unzip psmisc
    # Rust all the things
    fd ripgrep gitAndTools.delta
  ];

  home.file = {
    bin.source = ../bin;
  };

  programs.direnv.enable = true;
  programs.fzf.enable = true;
  programs.gh = {
    enable = true;
    settings.aliases.co = "pr checkout";
  };
  programs.git = {
    delta.enable = true;
    enable = true;
    userName = "Sebastian Ullrich";
    userEmail = "sebasti@nullri.ch";
    aliases = {
      "co" = "checkout";
      "st" = "status -s";
    };
    extraConfig = {
      merge.conflictStyle = "diff3";
      pull.rebase = "true";
      rebase.autoStash = "true";
    };
  };
  programs.alacritty = {
    enable = true;
    settings = {
      shell.program = "${pkgs.zsh}/bin/zsh";
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

  # on second thought, just use spacemacs
  #programs.emacs = {
  #  enable = true;
  #  extraPackages = epkgs: [ epkgs.magit ];
  #};

  #programs.vscode = {
  #  enable = true;
  #  extensions = with pkgs.vscode-extensions; [ vscodevim.vim bbenoist.Nix ms-vsliveshare.vsliveshare ];
  #};

  programs.zsh = {
    enable = true;
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
    };
    shellAliases = {
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

  home.stateVersion = "20.09";
}
