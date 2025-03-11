# { ... }:
{
  virtualisation.docker.enable = true;
  services.flatpak.enable = true;
  services.openssh.enable = true;
  services.openssh.settings.PasswordAuthentication = true;
  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
  };
  # services.xserver.desktopManager.openbox.enable = true;
  # services.displayManager.ly.enable = true;
}
