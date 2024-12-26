{ inputs, ... }:
let
  UnstablePkgs = inputs.unstableNixPkgs.legacyPackages.x86_64-linux;
  pkgs = inputs.nixpkgs.legacyPackages.x86_64-linux;
in
{
  users.users.sixela = {
    isNormalUser = true;
    shell = UnstablePkgs.zsh;
    home = "/home/sixela";
    extraGroups = [ "wheel" "networkmanager" "docker" ]; # Enable ‘sudo’ for the user.
    packages = with pkgs; [
      firefox
      tree
    ];
  };

}
