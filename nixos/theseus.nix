{ name, config, pkgs, inputs, lib, ... }:

{
  imports = [
    ./common.nix
    inputs.home-manager.nixosModules.home-manager
    inputs.nixos-hardware.nixosModules.framework-13-7040-amd
  ];

  hardware.cpu.amd.updateMicrocode = true;

  # from hardware-config
  boot.initrd.availableKernelModules = [ "nvme" "xhci_pci" "thunderbolt" "usb_storage" "sd_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-amd" ];
  boot.extraModulePackages = [ ];

  boot.kernelPackages = pkgs.linuxPackages_latest;  # for a while?

  fileSystems."/" =
    { device = "/dev/disk/by-label/nixos";
      fsType = "btrfs";
    };

  fileSystems."/boot" =
    { device = "/dev/disk/by-label/boot";
      fsType = "vfat";
    };

  swapDevices =
    [ { device = "/dev/disk/by-label/swap"; }
    ];

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking.useDHCP = false;
  networking.interfaces.wlp1s0.useDHCP = true;

  services.upower.enable = true;
  services.upower.criticalPowerAction = "Hibernate";
  services.logind.lidSwitch = "suspend-then-hibernate";
  services.logind.powerKey = "suspend-then-hibernate";
  systemd.sleep.extraConfig = "HibernateDelaySec=4h";

  services.udev.extraRules = ''
    ACTION=="add", SUBSYSTEM=="serio", DRIVERS=="atkbd", ATTR{power/wakeup}="disabled"
  '';

  hardware.opengl.extraPackages = with pkgs; [
    amdvlk
    # encoding/decoding acceleration
    libvdpau-va-gl vaapiVdpau
  ];

  xdg.portal = {
    enable = true;
    config.common.default = ["gnome"];
    extraPortals = [pkgs.xdg-desktop-portal-gnome];
  };

  programs.niri.enable = true;
  programs.niri.package = pkgs.niri-unstable;

  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  #systemd.user.services.niri = {
  #  unitConfig = {
  #    BindsTo = "graphical-session.target";
  #    Before = "graphical-session.target";
  #    Wants = ["graphical-session-pre.target" "xdg-desktop-autostart.target"];
  #    After = ["graphical-session-pre.target" "xdg-desktop-autostart.target"];
  #  };
  #  serviceConfig = {
  #    Type = "notify";
  #    ExecStart = "/home/sebastian/lib/niri/result/bin/niri";
  #  };
  #  path = ["/run/wrappers/bin:/home/sebastian/.nix-profile/bin:/nix/profile/bin:/home/sebastian/.local/state/nix/profile/bin:/etc/profiles/per-user/sebastian/bin:/nix/var/nix/profiles/default/bin:/run/current-system/sw/bin:/home/sebastian/.zsh/plugins/auto-notify:/home/sebastian/bin"];
  #};

  hardware.bluetooth.enable = true; # enables support for Bluetooth
  hardware.bluetooth.powerOnBoot = true; # powers up the default Bluetooth controller on boot
  services.blueman.enable = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.05"; # Did you read the comment?

}
