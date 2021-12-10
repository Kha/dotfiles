{ config, pkgs, unstable, ... }:

{
  home.packages = with pkgs; [
    # window manager
    sway xwayland i3status mako grim slurp wl-clipboard
    # system
    pavucontrol xdg_utils gnome3.adwaita-icon-theme
    # fonts!
    iosevka
    # editing
    libreoffice
    # dev
    rr
    # other desktop apps
    firefox-wayland chromium evince thunderbird
    # Rust all the things
    exa
  ];

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

  programs.zsh = {
    shellAliases = {
      ls = "exa";
    };
    sessionVariables = {
      # fix Java programs on sway
      _JAVA_AWT_WM_NONREPARENTING = 1;
      # fix locales for Nix on Ubuntu
      LOCALE_ARCHIVE_2_27 = "${pkgs.glibcLocales}/lib/locale/locale-archive";
    };
  };

  # For compatibility with nix-shell, nix-build, etc.
  home.file.".nixpkgs".source = inputs.nixpkgs;
  systemd.user.sessionVariables."NIX_PATH" =
    mkForce "nixpkgs=$HOME/.nixpkgs\${NIX_PATH:+:}$NIX_PATH";
}
