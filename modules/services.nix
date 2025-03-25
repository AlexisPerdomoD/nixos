# { ... }:
{
  virtualisation.docker.enable = true;
  services.flatpak.enable = true;
  services.openssh.enable = true;
  services.openssh.settings.PasswordAuthentication = true;

  services.xserver = {
    enable = true;
    displayManager.defaultSession = "hyprland";
    displayManager.lightdm.greeters.mini = {
      enable = true;
      user = "sixela";
      extraConfig = ''
        [greeter]
        show-password-label = true;
        [greeter-theme]
        background-image = ""
      '';
    };
    windowManager = {
      hypr.enable = true;
    };
  };
}
