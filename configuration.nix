# Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, inputs, ... }:
let
  UnstablePkgs = inputs.unstableNixPkgs.legacyPackages.x86_64-linux;
  pkgs = inputs.nixpkgs.legacyPackages.x86_64-linux;
in
{
  imports =
    [
      # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = false;

  boot.initrd.kernelModules = [ "amdgpu" ];
  boot.loader = {
    efi.canTouchEfiVariables = true;
    grub = {
      enable = true;
      efiSupport = true;
      devices = [ "nodev" ];
      useOSProber = true;
    };
  };
  hardware.opengl.enable = true;
  # networking.hostName = "nixos"; # Define your hostname.
  # Pick only one of the below networking options.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.networkmanager.enable = true; # Easiest to use and most distros use this by default.

  # Set your time zone.
  time.timeZone = "America/Lima";
  services.ntp.enable = true; # sincroniza hora 

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  # i18n.defaultLocale = "en_US.UTF-8";
  #  console = {
  #  font = "Lat2-Terminus16";
  #  keyMap = "us";
  #  useXkbConfig = true; # use xkb.options in tty.
  #};

  # Enable the X11 windowing system.
  # services.xserver.enable = true;
  # Configure keymap in X11
  # services.xserver.xkb.layout = "us";
  # services.xserver.xkb.options = "eurosign:e,caps:escape";
  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  # hardware.pulseaudio.enable = true;
  # OR
  sound.enable = true;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    pulse.enable = true;
    jack.enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
  };
  programs = {
    zsh = {
      enable = true;
    };
    hyprland = {
      enable = true;
      xwayland.enable = true;
    };
  };
  users.users.sixela = {
    isNormalUser = true;
    shell = UnstablePkgs.zsh;
    home = "/home/sixela";
    extraGroups = [ "wheel" "networkmanager" ]; # Enable ‘sudo’ for the user.
    packages = with pkgs; [
      firefox
      tree
      spotube
    ];
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget

  environment.systemPackages = with pkgs; [
    gnome.nautilus
    pavucontrol # audio mixer
    chromium
    file
    ranger
    git
    fzf
    bat
    # zsh enviroment
    UnstablePkgs.alacritty
    kitty
    UnstablePkgs.starship
    fastfetch
    wget
    curl
    zellij
    unzip
    gnumake
    # lenguajes requeridos por el sistema nvim
    UnstablePkgs.neovim
    xclip
    wl-clipboard
    cargo
    lua
    lua-language-server
    stylua
    go
    gcc
    nodejs
    prettierd
    python3
    dotnet-sdk
    # Nix language sudo text editing setup
    nixd
    nixpkgs-fmt
    # para hyprland
    hyprpaper
    hyprshot # para capturar pantalla
    slurp # para capturar pantalla 
    wf-recorder # para grabar pantalla
    waybar
    wofi
    (waybar.overrideAttrs (oldAttrs: {
      mesonFlags = oldAttrs.mesonFlags ++ [ "-Dexperimental=true" ];
    })
    )
    mako # notification deamon
    libnotify # notification platform
  ];
  console = {
    earlySetup = true;
    # font = "ter-v12n";
    font = "${pkgs.terminus_font}/share/consolefonts/ter-u12n.psf.gz";
    packages = with pkgs; [ terminus_font ];
  };
  fonts.packages = with pkgs; [
    (nerdfonts.override { fonts = [ "Agave" ]; })
    (nerdfonts.override { fonts = [ "Iosevka" ]; })
    (nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
  ];
  fonts.fontconfig = {
    defaultFonts = {
      serif = [ "Iosevka" ];
      sansSerif = [ "DejaVu Sans" ];
      monospace = [ "Jetbrains Mono" ];
    };
  };

  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
  };
  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk pkgs.xdg-desktop-portal-hyprland ];
  };
  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:
  services.openssh.enable = true;
  services.openssh.settings.PasswordAuthentication = true;
  services.flatpak.enable = true;
  # Open ports in the firewall.
  networking.firewall.allowedTCPPorts = [ 6000 ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Hardware settings 
  hardware = {
    bluetooth.enable = true;
    bluetooth.powerOnBoot = true;
    bluetooth.settings.General.Experimental = true;
  };


  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  #  system.copySystemConfiguration = true;

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
  # to actually do that.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "24.05"; # Did you read the comment?
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
}
