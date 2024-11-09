{
  description = "My personal nixos configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-24.05-small";
    unstableNixPkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable-small";
    grub2Themes.url = "github:vinceliuice/grub2-themes";
  };

  outputs = { nixpkgs, unstableNixPkgs, grub2Themes, ... }@ inputs:
    let
      pkgs = nixpkgs.legacyPackages.x86_64-linux;
      unstablePkgs = unstableNixPkgs.legacyPackages.x86_64-linux;
    in
    {

      # nixos modules setup
      # configuracion por defecto de nixos 
      # nixos-rebuild switch --flake ~/.config/nixos/flake.nix 
      nixosConfigurations.default = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./configuration.nix
          grub2Themes.nixosModules.default
        ];
        # system = "x86_64-linux";
        specialArgs = { inherit inputs; };
      };


      # shells setup  
      # nix develop .#devShells.x86_64-linux.default .config/nixos/flake.nix
      devShells.x86_64-linux.default = pkgs.mkShell {
        buildInputs = [
          # posible setup for neovim here 
          pkgs.neovim
        ];
      };
    };
}
