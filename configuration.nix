# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, nixpkgs-unstable, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./cosmic.nix
      ./fonts.nix
      #./flatpak.nix
      ./zsh.nix
      ./openaudible.nix
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  # Limit number of generations
  boot.loader.systemd-boot.configurationLimit = 10;

  # Zen Kernel
  # boot.kernelPackages = pkgs.linuxPackagesFor (pkgs.linux_zen);

  networking.hostName = "jrd-t490"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "America/New_York";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  programs.openaudible.enable = true;

  # Enable the GNOME Desktop Environment.
  #services.xserver.displayManager.gdm.enable = true;
  #services.xserver.desktopManager.gnome.enable = true;

  # cosmic
  #services.desktopManager.cosmic.enable = true;
  #services.displayManager.cosmic-greeter.enable = true;


  # Add flatpak
  #
  # external file does not work yet
  #   #
  #put the below in terminal to use COSMIC stor for flatpaks
  # flatpak remote-add --user flathub https://dl.flathub.org/repo/flathub.flatpakrepo
  services.flatpak.enable = true;

  # smb stuff
  services.gvfs.enable = true;

  # Tailscale
  #
  services.tailscale = {
    enable = true;
    useRoutingFeatures = "client";  # or "both" if you're subnet routing
  };
  # services.tailscale.enable = true;
  # networking.firewall.checkReversePath = "loose";

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  #hardware.pulseaudio.enable = false;
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.jeremy = {
    isNormalUser = true;
    description = "Jeremy";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
    #  thunderbird
    ];
  };

  # Install firefox.
  programs.firefox.enable = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # ZFS support
  boot.supportedFilesystems = [ "zfs" "cifs" ];
  networking.hostId = "6760176b"; # Replace with unique 8-character hex string

#  environment.systemPackages = with pkgs; let
  # Import unstable nixpkgs for any that need to be the newest
  # see last entry for syntax on how to make sure they are running on unstable
#  unstablePkgs = import (fetchTarball {
#      url = "https://github.com/NixOS/nixpkgs/archive/nixos-unstable.tar.gz";
      #sha256 = "09nmwsahc0zsylyk5vf6i62x4jfvwq4r2mk8j0lmr3zzk723dwj3";
#      sha256 = "1krzkmqdpv2w5hq9nvq4q91i0x7mhpn3fx32rg0p1yyq7zsj61w8";
#  }) {
#      system = pkgs.system;
#      config.allowUnfree = true;
#  };
#  in [
 environment.systemPackages = with pkgs; let
   # Use the flake input instead of fetchTarball
   unstablePkgs = import nixpkgs-unstable {
       system = pkgs.system;
       config.allowUnfree = true;
   };
  in [
      networkmanager
      gearlever
      neovim
      gcc # c compiler for neovim/lazynvim
      fastfetch
      gparted
      appimage-run
      # countryfetch # only in unstable
      wget
      curl
      eget  #binary package manager
      #               Terminals
      #warp-terminal
      zellij #terminal multiplexer
      #               Terminal tools
      git
      xan #csv tool
      bat
      eza
      tlrc
      fd
      dysk # tui for the filesystem
      #lsd
      btop
      fselect
      zoxide # better cd command
      fzf # Fuzzy finder
      ripgrep
      ripgrep-all
      igrep # interactive grep
      ffmpeg # (yazi)
      poppler # pdf rendering (yazi)
      chezmoi # dotfile manager
      #gowall #wallpaper convert to match a theme
      # libreoffice-fresh
      starship
      serpl # search and replace tool
      #               Editors
      zed-editor-fhs
      micro
      #               File Managers
      yazi
      superfile
      #              Browsers
      chromium
      chawan # Terminal Browser
      #              Database
      #rainfrog
      pgcli
      gobang #tui database manangement in Rust
      #              Nix Tools
      nh
      nix-output-monitor
      nvd
      bitwarden-desktop
      #              SMB/CIFS support
      samba
      cifs-utils
      atuin
      #               Undtable versions of software
      unstablePkgs.ghostty
      unstablePkgs.countryfetch
      unstablePkgs.warp-terminal
      unstablePkgs.lazygit
      unstablePkgs.uutils-coreutils
      #unstablePkgs.tellico

      # regname # not in nix yet - file renamere
      # caps-log # not in nix yet Captian's Log small markdown journal

  ];

  #  coreutils, findutils, diffutils and sudo with Rust reimplementations

  # Optional: Create a system-wide override
    nixpkgs.config.packageOverrides = pkgs: {
      coreutils = pkgs.uutils-coreutils;
      # Override tailscale to disable failing tests in sandbox
      tailscale = pkgs.tailscale.overrideAttrs (oldAttrs: {
        doCheck = false;
      });
    };

  # Replace sudo with sudo-rs using the proper NixOS module
   security.sudo-rs.enable = true;
   security.sudo.enable = false;  # Disable regular sudo

  # Your existing sudo configuration will work the same way
  # security.sudo-rs.wheelNeedsPassword = false; # example config

  # set default editor
  # environment.variables.EDITOR = "micro";

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
  programs.ssh.startAgent = true;

  networking.firewall = {
    enable = true;
    trustedInterfaces = [ "tailscale0" ];  # Trust the Tailscale interface
    allowedUDPPorts = [ 41641 ];  # Tailscale's default port
  };

  boot.kernel.sysctl."net.ipv4.ip_forward" = 1;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05"; # Did you read the comment?

  nix.gc = {
    automatic = true;
    #dates = "weekly";
    dates = "*:00";  # Shorter syntax, same effect - runs hourly
    options = "--delete-older-than 10d";
    };

  nix.settings.auto-optimise-store = true;


}
