{ name, config, pkgs, inputs, lib, ... }:

{
  imports = [
    ./common.nix
    inputs.home-manager.nixosModules.home-manager
    inputs.nixos-hardware.nixosModules.lenovo-thinkpad-t14-amd-gen1
    inputs.nix-ld.nixosModules.nix-ld
  ];

  hardware.cpu.amd.updateMicrocode = true;

  # from hardware-config
  boot.initrd.availableKernelModules = [ "nvme" "ehci_pci" "xhci_pci" "usb_storage" "sd_mod" "rtsx_pci_sdmmc" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-amd" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" =
    { device = "/dev/disk/by-uuid/8756ffaf-6da6-4fb8-b8d4-cf1fa8dd1792";
      fsType = "btrfs";
    };

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/3412-BAB8";
      fsType = "vfat";
    };

  swapDevices = [ ];

  # tlp enabled by nixos-hardware
  services.tlp.settings.START_CHARGE_THRESH_BAT0 = 75;
  services.tlp.settings.STOP_CHARGE_THRESH_BAT0 = 80;

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking.useDHCP = false;
  networking.interfaces.enp2s0f0.useDHCP = true;
  networking.interfaces.enp5s0.useDHCP = true;
  networking.interfaces.wlp3s0.useDHCP = true;


  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "20.03"; # Did you read the comment?

}

