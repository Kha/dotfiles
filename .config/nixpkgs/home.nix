{ config, pkgs, ... }:

let
  lorri-src = builtins.fetchGit { url = https://github.com/target/lorri.git; rev = "8224dfb57e508ec87d38a4ce7b9ce27bbf7c2a81"; };
  lorri = import lorri-src { src = lorri-src; };
  xdg_utils = pkgs.xdg_utils.overrideAttrs (attrs: {
    postInstall = attrs.postInstall + ''
      sed  '3s#.#\
      mimetype() { false; }\
      &#' -i "$out"/bin/*
    '' + attrs.postInstall;
  });
in {
  home.packages = with pkgs; [
    # window manager
    sway xwayland i3status mako grim slurp wl-clipboard
    # system
    pavucontrol xdg_utils gnome3.adwaita-icon-theme
    # fonts!
    iosevka-ss09
    # editing
    emacs ispell vim_configurable
    # dev
    jetbrains.clion elan gitAndTools.hub gitAndTools.tig python3Packages.ipython lorri
    # other desktop apps
    firefox evince
    # other cli apps
    fasd htop mpv file python3Packages.howdoi
    # Rust all the things
    alacritty exa fd ripgrep
  ];

  programs.direnv.enable = true;
  programs.fzf.enable = true;
  programs.git.enable = true;

  gtk.enable = true;
  fonts.fontconfig.enable = true;
  xdg.mimeApps.enable = true;

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
    };
    initExtra = ''
      export PATH=$PATH:bin
      # https://github.com/NixOS/nixpkgs/issues/30121
      setopt prompt_sp
    '';
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  home.stateVersion = "18.09";
}
