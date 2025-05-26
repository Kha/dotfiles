{ config, pkgs, unstable, lean4, inputs, ... }:

{
  home.packages = with pkgs; [
    # editing
    ispell vim_configurable unstable.vscode
    # dev
    gitAndTools.gh gitAndTools.tig gdb meld python3 binutils jq unstable.elan hyperfine samply unstable.jujutsu
    # other cli apps
    fasd htop mpv file unzip psmisc libnotify
    # Rust all the things
    fd ripgrep gitAndTools.delta
  ];

  home.file = {
    bin.source = ../bin;
  };

  programs.direnv.enable = true;
  #programs.fzf.enable = true;
  programs.fzf.package = unstable.fzf;  # https://github.com/junegunn/fzf/issues/1472

  programs.atuin = {
    enable = true;
    enableZshIntegration = true;
    flags = ["--disable-up-arrow"];
    settings.filter_mode = "directory";
  };
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
      github.user = "Kha";
      push.autoSetupRemote = "true";
    };
  };
  programs.alacritty = {
    enable = true;
    settings = {
      terminal.shell.program = "${pkgs.zsh}/bin/zsh";
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

  #programs.vscode = {
  #  enable = true;
  #  extensions = with pkgs.vscode-extensions; [ vscodevim.vim bbenoist.Nix ms-vsliveshare.vsliveshare ];
  #};

  programs.zsh = {
    enable = true;
    oh-my-zsh = {
      enable = true;
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
    plugins = [{
      name = "auto-notify";
      src = inputs.zsh-auto-notify;
    }];
  };

  programs.nix-index.enable = true;

  home.stateVersion = "20.09";
}
