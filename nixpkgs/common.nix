{ config, pkgs, unstable, lean4, inputs, ... }:

{
  home.packages = with pkgs; [
    # editing
    ispell vim-full unstable.vscode
    # dev
    gh tig gdb meld python3 binutils jq unstable.elan hyperfine samply unstable.jujutsu
    # for jj
    watchman
    # other cli apps
    fasd htop mpv file unzip psmisc libnotify
    # Rust all the things
    fd ripgrep
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
  programs.delta.enable = true;
  programs.gh = {
    enable = true;
    settings.aliases.co = "pr checkout";
  };
  programs.git = {
    enable = true;
    settings = {
      user.name = "Sebastian Ullrich";
      user.email = "sebasti@nullri.ch";
      alias = {
        "co" = "checkout";
        "st" = "status -s";
      };
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
      general.import = [ "~/.config/alacritty/dank-theme.toml" ];
      terminal.shell.program = "${pkgs.zsh}/bin/zsh";
      font = {
        size = 11;
        normal.family = "Iosevka";
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
