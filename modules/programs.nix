{ inputs, ... }:
let
  UnstablePkgs = inputs.unstableNixPkgs.legacyPackages.x86_64-linux;
  pkgs = inputs.nixpkgs.legacyPackages.x86_64-linux;
in
{

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
    UnstablePkgs.kitty
    UnstablePkgs.starship
    fastfetch
    wget
    curl
    zellij
    unzip
    gnumake
    xclip
    wl-clipboard
    # lenguajes requeridos por el sistema nvim
    cargo
    lua
    lua-language-server
    stylua
    go
    gcc
    nodejs
    prettierd
    python3
    # dotnet-sdk
    # dotnet-sdk_7
    dotnet-sdk_8
    # dotnet-runtime
    # dotnet-runtime_7
    dotnet-runtime_8
    # dotnet-aspnetcore
    # dotnet-aspnetcore_7
    dotnet-aspnetcore_8
    csharpier
    csharp-ls
    UnstablePkgs.emacsPackages.omnisharp
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

  programs = {
    zsh = {
      enable = true;
      autosuggestions.enable = true;
      enableBashCompletion = true;
    };
    neovim = {
      enable = true;
      defaultEditor = true;
      package = UnstablePkgs.neovim-unwrapped;
    };

  };
  # hyperland setup
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };
  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
  };
  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk pkgs.xdg-desktop-portal-hyprland ];
  };

}
