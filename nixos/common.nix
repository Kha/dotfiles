{ name, config, pkgs, inputs, lib, ... }:

{
  hardware.enableRedistributableFirmware = true;
  nix.maxJobs = lib.mkDefault 16;

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.tmpOnTmpfs = true;

  boot.kernel.sysctl."kernel.sysrq" = 1;  # enable all sysrqs

  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.networkmanager.enable = true;

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  # i18n.defaultLocale = "en_US.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  # };

  # Set your time zone.
  # time.timeZone = "Europe/Amsterdam";

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    wget vim man-pages
    alsaUtils pamixer
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  #   pinentryFlavor = "gnome3";
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  krb5.enable = true;
  krb5.config = ''
[libdefaults]
    default_realm = INFO.UNI-KARLSRUHE.DE
    clockskew = 300

    kdc_timesync = 1
    ccache_type = 4
    forwardable = true
    proxiable = true

[realms]
    INFO.UNI-KARLSRUHE.DE = {
        kdc = kdc1.info.uni-karlsruhe.de.
        kdc = kdc2.info.uni-karlsruhe.de.
        default_domain = info.uni-karlsruhe.de
    }

[domain_realm]
    .info.uni-karlsruhe.de = INFO.UNI-KARLSRUHE.DE
    info.uni-karlsruhe.de = INFO.UNI-KARLSRUHE.DE
'';

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  # sound.enable = true;
  #hardware.pulseaudio = {
  #  enable = true;
  #  extraModules = [ pkgs.pulseaudio-modules-bt ];
  #  package = pkgs.pulseaudioFull;
  #};
  # rtkit is optional but recommended
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # for Steam
  # hardware.opengl = {
  #   enable = true;
  #   driSupport32Bit = true;
  # };
  # hardware.pulseaudio.support32Bit = true;
  # services.xserver = {
  #   enable = true;
  #   videoDrivers = [ "amdgpu" ];
  # };
  # services.xserver.displayManager.startx.enable = true;

  # Enable the X11 windowing system.
  # services.xserver.enable = true;
  # services.xserver.layout = "us";
  # services.xserver.xkbOptions = "eurosign:e";

  programs.sway.enable = true;
  programs.light.enable = true;
  # necessary to get `nix` completion
  programs.zsh.enable = true;

  services.fwupd.enable = true;

  # Enable touchpad support.
  # services.xserver.libinput.enable = true;

  # Enable the KDE Desktop Environment.
  # services.xserver.displayManager.sddm.enable = true;
  # services.xserver.desktopManager.plasma5.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.sebastian = {
    isNormalUser = true;
    shell = pkgs.zsh;
    extraGroups = [ "wheel" "networkmanager" "video" ];
  };

  documentation.dev.enable = true;

  home-manager = {
    useUserPackages = true;
    useGlobalPkgs = true;
    users.sebastian = inputs.self.homeManagerConfigurations."${name}";
  };
}
