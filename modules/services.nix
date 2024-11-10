{ config, pkgs, ... }:
{
  services.flatpak.enable = true;

  virtualisation.docker.enable = true;
}
