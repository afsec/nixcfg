{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      # NixOs Hardware
      "${fetchTarball "https://github.com/NixOS/nixos-hardware/archive/429f232fe1dc398c5afea19a51aad6931ee0fb89.tar.gz" }/raspberry-pi/4"
    ];

  boot = {
    kernelPackages = pkgs.linuxPackages_rpi4;
    tmpOnTmpfs = true;
    kernelParams = [
      "8250.nr_uarts=1"
      "console=ttyAMA0,115200"
      "console=tty1"
      "boot.shell_on_fail"
    ];
    initrd.availableKernelModules = [
      # Allows early (earlier) modesetting for the Raspberry Pi
      "vc4"
      "bcm2835_dma"
      "i2c_bcm2835"
    ];
    loader = {
      grub.enable = false;
      raspberryPi = {
        enable = true;
        version = 4;
        firmwareConfig = ''
          gpu_mem=192
        '';
      };
      generic-extlinux-compatible.enable = false;
    };
  };

  # Hardware Raspberry Pi 4
  hardware.enableRedistributableFirmware = true;
  ## Enable GPU acceleration
  # hardware.raspberry-pi."4".fkms-3d.enable = true;

  # Networking
  networking.hostName = "kepler-452_b"; # Define your hostname.
  # Pick only one of the below networking options.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.

  # Set your time zone.
  time.timeZone = "America/Sao_Paulo";

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  #   useXkbConfig = true; # use xkbOptions in tty.
  # };

  # Enable the X11 windowing system.
  # services.xserver.enable = true;
  services.xserver = {
    enable = true;
    displayManager.lightdm.enable = true;
    desktopManager.xfce.enable = true;
    videoDrivers = [ "fbdev" ];
    #videoDrivers = [ "modesetting" ];
  };

  

  # Configure keymap in X11
  services.xserver.layout = "us";
  services.xserver.xkbOptions = "altgr-intl";

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  # sound.enable = true;
  # hardware.pulseaudio.enable = true;

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  # users.users.alice = {
  #   isNormalUser = true;
  #   extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
  #   packages = with pkgs; [
  #     firefox
  #     tree
  #   ];
  # };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    tmux git curl btop
    helix
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?

}

