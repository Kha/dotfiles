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

  # tlp enabled by nixos-hardware
  services.tlp.settings.START_CHARGE_THRESH_BAT0 = 75;
  services.tlp.settings.STOP_CHARGE_THRESH_BAT0 = 80;

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking.useDHCP = false;
  networking.interfaces.wlp1s0.useDHCP = true;

  services.upower.enable = true;
  services.upower.criticalPowerAction = "Hibernate";
  services.logind.lidSwitch = "suspend-then-hibernate";
  services.logind.extraConfig = "HandlePowerKey=suspend-then-hibernate";

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.05"; # Did you read the comment?

}
