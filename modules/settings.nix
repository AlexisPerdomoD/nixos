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
  # gtk.enable = true;

  qt.platformTheme = "qt5ct";

}
