# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running `nixos-help`).

{ config, pkgs, ... }:

{
  environment.systemPackages = # let
  #   unstable = import <nixos-unstable> { config = { allowUnfree = true; }; };
  # in 
  with pkgs; [
    microsoft-edge
    spotify
    vim
    discord
    slack
    #steam
    #steam-run
    #openssl
    #opendrop
    #owl
    #firefox
    tree
    dig
    neofetch
    vscode
    git
    python3
    gcc
    onedrive
    mtr
    #mtr-gui
    traceroute
    zoom-us
    mission-center
    wget
    ookla-speedtest
    #powertop
    #thermald
    #tlp
    #auto-cpufreq
    caprine-bin
    displaylink
    geekbench
    #quartus-prime-lite
    #sqldeveloper
    cpuid
    pinta
    tetex
    latexrun
    #virt-manager
    #libvirt
    #teams
    #wpsoffice
    softmaker-office
    onlyoffice-bin
    #gsound
    #libgda
    gnome.gnome-tweaks
    winetricks
    wineWowPackages.stable
    parsec-bin
    #intel-media-driver
    #intel-gpu-tools
    #auto-cpufreq
    p3x-onenote
    blackbox-terminal
    plex-media-player
    refind
    #electron
    #mesa
    gparted
    #wgnord
    super-slicer-latest
    gh
  ];

  nixpkgs.config.allowUnfree = true; 

  #home-manager.sharedModules = [{
  #  home.stateVersion = "23.11";
  #}];

  #home-manager.users.jonathan

  #systemd.packages = [ pkgs.auto-cpufreq ];
  #systemd.services.auto-cpufreq.path = with pkgs; [ bash coreutils ];

  imports =
    [ 
      <nixos-hardware/framework/13th-gen-intel>
      # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./nixfiles/nixos
    ];

  #services.tlp.settings = {
    #START_CHARGE_THRESH_BAT1=80;
    #STOP_CHARGE_THRESH_BAT1=95;
    #CPU_DRIVER_OPMODE_ON_AC="active";
    #CPU_DRIVER_OPMODE_ON_BAT="active";
    #CPU_SCALING_GOVERNOR_ON_AC="performance";
    #CPU_SCALING_GOVERNOR_ON_BAT="powersave";
    #CPU_ENERGY_PERF_POLICY_ON_AC="performance";
    #CPU_ENERGY_PERF_POLICY_ON_BAT="balance_power";
    #CPU_BOOST_ON_AC=1;
    #CPU_BOOST_ON_BAT=0;
    #CPU_HWP_DYN_BOOST_ON_AC=1;
    #CPU_HWP_DYN_BOOST_ON_BAT=1;
    #RESTORE_DEVICE_STATE_ON_STARTUP=1;
    #DEVICES_TO_DISABLE_ON_STARTUP="bluetooth";
    #PCIE_ASPM_ON_BAT="powersupersave";
  #};

  virtualisation.libvirtd.enable = true;
  programs.dconf.enable = true;

  system.autoUpgrade.enable = false;
  system.autoUpgrade.allowReboot = false;
  services.fwupd.enable = false;

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  #boot.kernelPackages = pkgs.linuxPackages_zen;
  boot.kernelPackages = pkgs.linuxPackages_latest;

  boot.kernel.sysctl."kernel.sysrq" = 246;
  boot.swraid.enable = false;

  networking.hostName = "Framework-NixOS"; # Define your hostname.
  # Pick only one of the below networking options.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.

  # Set your time zone.
  time.timeZone = "Australia/Melbourne";

  services.tlp.enable = true;
  services.power-profiles-daemon.enable = false;
  services.auto-cpufreq.enable = true;
  powerManagement.powertop.enable = true;

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_AU.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  #   useXkbConfig = true; # use xkbOptions in tty.
  # };

  # Enable the X11 windowing system.
  services.xserver.enable = true;


  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  services.xserver.videoDrivers = [ "displaylink" "modesetting" ];

  environment.shellAliases = {
    config-nix = "sudo vim /etc/nixos/configuration.nix";
    saltbox = "ssh seed@plex.jchin.au -p 2222";
  };

  environment.variables = {
    NIX_AUTO_RUN = "1";
    NIX_AUTO_RUN_INTERACTIVE = "1";
    NIXPKGS_ALLOW_UNFREE="1";
    EDITOR = "vim";
    #GDK_FONT_SCALE = "2.0";
    #NIXOS_OZONE_WL = "1";
  };

  # Configure keymap in X11
  # services.xserver.layout = "us";
  # services.xserver.xkbOptions = "eurosign:e,caps:escape";

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound.
  sound.enable = true;
  # hardware.pulseaudio.enable = true;

  # Enable touchpad support (enabled default in most desktopManager).
  services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.jonathan = {
    isNormalUser = true;
    description = "Jonathan";
    hashedPassword = "$y$j9T$otF6L1SMHV/S369j4mDkF1$.bg10QdpXbKGMlXo5i1HcR2Jzb5TafdIdbnCfSCjFq2";
    extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
    packages = with pkgs; [
      ];
  };

  users.mutableUsers = false;

  security.polkit.extraConfig = ''
  polkit.addRule(function (action, subject) {
    if (action.id === 'org.freedesktop.policykit.exec' && action.lookup('program') === '${pkgs.dmidecode}/bin/dmidecode' && subject.isInGroup('wheel')) {
      return polkit.Result.YES;
    }
  })
  '';

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  # environment.systemPackages = with pkgs; [
  #   vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
  #   wget
  # ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  system.copySystemConfiguration = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.05"; # Did you read the comment?

  home-manager.sharedModules = [{
    home.stateVersion = "23.05";
  }];

  nova.profile = "personal";
  # "personal" aims to be flexible for use on regular NixOS installations.
  # Use "shared" to enable all the things on a team device - branding, the
  # standard user and desktop environment, etc.
  # These things can all be enabled manually even on "personal" configurations,
  # e.g. with nova.desktop.enable = true.

  nova.substituters.nova.password = "tFH6J!#HhrYc3&^m";
  nova.users.jonathan.enable = true;

  home-manager.users.jonathan = {
    programs.bash.enable = true;
    nova.macros.enable = true;
  };
}

