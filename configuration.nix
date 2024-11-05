# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, inputs, ... }:
let
  unstablePkgs = inputs.unstableNixPkgs.legacyPackages.x86_64-linux;
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
    shell = unstablePkgs.zsh;
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

  environment.systemPackages = [
    pkgs.pavucontrol # audio mixer
    pkgs.chromium
    pkgs.file
    pkgs.ranger
    pkgs.git
    pkgs.fzf
    pkgs.bat
    # zsh enviroment
    unstablePkgs.alacritty
    pkgs.kitty
    unstablePkgs.starship
    pkgs.fastfetch
    pkgs.wget
    pkgs.curl
    pkgs.zellij
    pkgs.unzip
    pkgs.gnumake
    # lenguajes requeridos por el sistema nvim
    unstablePkgs.neovim
    pkgs.xclip
    pkgs.wl-clipboard
    pkgs.cargo
    pkgs.lua
    pkgs.lua-language-server
    pkgs.stylua
    pkgs.go
    pkgs.gcc
    pkgs.nodejs
    pkgs.prettierd
    pkgs.python3
    pkgs.dotnet-sdk
    # Nix language sudo text editing setup
    pkgs.nixd
    pkgs.nixpkgs-fmt
    # para hyprland
    pkgs.hyprpaper
    pkgs.hyprshot # para capturar pantalla
    pkgs.slurp # para capturar pantalla 
    pkgs.wf-recorder # para grabar pantalla
    pkgs.waybar
    pkgs.wofi
    (pkgs.waybar.overrideAttrs (oldAttrs: {
      mesonFlags = oldAttrs.mesonFlags ++ [ "-Dexperimental=true" ];
    })
    )
    pkgs.mako # notification deamon
    pkgs.libnotify # notification platform
  ];

  fonts.packages = with pkgs; [
    (nerdfonts.override { fonts = [ "Agave" ]; })
    (nerdfonts.override { fonts = [ "Iosevka" ]; })
    (nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
    source-code-pro
  ];
  fonts.fontconfig = {
    defaultFonts = {
      serif = [ "Iosevka" ];
      sansSerif = [ "DejaVu Sans" ];
      monospace = [ "Source Code Pro" ];
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
