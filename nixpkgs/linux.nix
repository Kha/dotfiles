{ config, lib, pkgs, unstable, ... }:

{
  home.packages = with pkgs; [
    # window manager
    sway xwayland dmenu i3status grim slurp wl-clipboard
    fuzzel waybar font-awesome
    # system
    pavucontrol playerctl xdg-utils (adwaita-icon-theme.override { gnome = null; })
    # fonts!
    iosevka
    # editing
    libreoffice
    # dev
    rr
    # other desktop apps
    firefox-beta chromium evince thunderbird
  ];

  gtk.enable = true;
  fonts.fontconfig.enable = true;

  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "application/pdf" = [ "org.gnome.Evince.desktop" ];
      "x-scheme-handler/http" = [ "firefox-beta.desktop" ];
      "x-scheme-handler/https" = [ "firefox-beta.desktop" ];
    };
  };

  programs.zsh = {
    sessionVariables = {
      # fix Java programs on sway
      _JAVA_AWT_WM_NONREPARENTING = 1;
      # fix locales for Nix on Ubuntu
      LOCALE_ARCHIVE_2_27 = "${pkgs.glibcLocales}/lib/locale/locale-archive";
    };
  };

  services.mako = {
    enable = true;
    defaultTimeout = 5000;
  };
}
