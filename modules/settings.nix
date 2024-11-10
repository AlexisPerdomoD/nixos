{ inputs, ... }:
let
  pkgs = inputs.nixpkgs.legacyPackages.x86_64-linux;
in
{
  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = false;
  boot.postBootCommands = ''
    kbdrate -r 50 -d 140
  '';
  boot.initrd.kernelModules = [ "amdgpu" ];
  boot.loader = {
    efi.canTouchEfiVariables = true;
    grub = {
      enable = true;
      default = "saved";
      efiSupport = true;
      devices = [ "nodev" ];
      useOSProber = true;
    };
    grub2-theme = {
      enable = true;
      theme = "vimix";
      footer = true;
      customResolution = "2560x1440";
    };
  };
  console = {
    earlySetup = true;
    font = "${pkgs.terminus_font}/share/consolefonts/ter-u14n.psf.gz";
    packages = with pkgs; [ terminus_font ];
  };
  hardware.opengl.enable = true;

  time.timeZone = "America/Lima";
  services.ntp.enable = true; # sincroniza hora 

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
  # system.stateVersion = "24.05"; # Did you read the comment?
  # nix.settings.experimental-features = [ "nix-command" "flakes" ];
}
