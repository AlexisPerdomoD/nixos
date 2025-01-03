{ inputs, ... }:
let
  unstablePkgs = inputs.unstableNixPkgs.legacyPackages.x86_64-linux;
  pkgs = import inputs.nixpkgs { system = "x86_64-linux"; config.allowUnfree = true; };
in
{

  environment.systemPackages = with pkgs;[
    gnome.nautilus
    lxqt.pavucontrol-qt
    blueman
    google-chrome
    file
    ranger
    git
    ripgrep
    fzf
    bat
    imv
    notes
    killall
    vlc
    wpsoffice
    unstablePkgs.alacritty
    unstablePkgs.kitty
    starship
    fastfetch
    wget
    curl
    zellij
    unzip
    gnumake
    xclip
    wl-clipboard
    insomnia
    slack
    telegram-desktop
    # NVIM
    neovide
    cargo
    lua
    lua-language-server
    stylua
    go
    gcc
    nodejs
    python3
    prettierd
    (with dotnetCorePackages; combinePackages [ sdk_6_0 sdk_7_0 sdk_8_0 sdk_9_0 ])
    csharpier
    netcoredbg
    omnisharp-roslyn
    # Nix language sudo text editing setup
    nixd
    nixpkgs-fmt
    # para hyprland
    hyprpaper
    hyprshot
    slurp
    wf-recorder
    waybar
    wofi
    (waybar.overrideAttrs (oldAttrs: {
      mesonFlags = oldAttrs.mesonFlags ++ [ "-Dexperimental=true" ];
    })
    )
    # notification platform
    mako
    libnotify
    # THEMING 
    arc-theme
    gtk2
    gtk3
    gtk4
    xorg.xrandr
    papirus-icon-theme
    lxappearance
    qt5ct
  ];

  programs = {
    zsh = {
      enable = true;
      autosuggestions.enable = true;
      enableBashCompletion = true;
    };
    neovim = {
      enable = true;
      withNodeJs = true;
      withPython3 = true;
      withRuby = true;
      package = unstablePkgs.neovim-unwrapped;
    };
  };
  # hyperland setup
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk pkgs.xdg-desktop-portal-hyprland ];
  };

  environment.variables = {
    EDITOR = "neovide";
    VISUAL = "neovide";
  };
  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1"; # necesario para hyprland
  };
}
