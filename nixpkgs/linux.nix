{ config, lib, pkgs, unstable, inputs, ... }:

{
  home.packages = with pkgs; [
    # window manager
    wofi dmenu grim slurp wl-clipboard
    # system
    pavucontrol xdg_utils (gnome3.adwaita-icon-theme.override { gnome = null; })
    # fonts!
    iosevka
    # editing
    libreoffice
    # dev
    rr
    # other desktop apps
    firefox chromium evince thunderbird
    # Rust all the things
    exa
  ];

  wayland.windowManager.hyprland = {
    enable = true;
    extraConfig = builtins.readFile ../hypr/hyprland.conf.extra;
    plugins = [ inputs.hy3.packages.x86_64-linux.hy3 ];
  };

  programs.waybar = {
    package = unstable.waybar;
    enable = true;
    systemd.enable = true;
  };
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

  services.mako = {
    enable = true;
    defaultTimeout = 5000;
  };
}
