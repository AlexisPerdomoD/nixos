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
    unstablePkgs.ghostty
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
    postman
    slack
    telegram-desktop
    # NVIM
    lua-language-server
    unstablePkgs.postgres-lsp
    nodePackages.typescript-language-server
    nodePackages.bash-language-server
    vscode-langservers-extracted # JSON , css , html eslint
    marksman
    markdown-oxide
    omnisharp-roslyn
    yaml-language-server
    postgres-lsp
    gopls
    vim-language-server
    nixd
    sqls
    csharp-ls
    tailwindcss-language-server
    neovide
    pnpm
    bun
    python3
    cargo
    lua
    go
    gcc
    libstdcxx5
    typescript
    nodejs
    htmlhint
    stylua
    shfmt
    prettierd
    nixpkgs-fmt
    (with dotnetCorePackages; combinePackages [ sdk_6_0 sdk_7_0 sdk_8_0 sdk_9_0 ])
    csharpier
    netcoredbg

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
    gtk3-x11
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
    # hyperland setup
    hyprland = {
      enable = true;
      xwayland.enable = true;
    };

    hyprlock.enable = true;
  };
  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk pkgs.xdg-desktop-portal-hyprland ];
  };

  environment.variables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
    GIT_EDITOR = "nvim";
  };
  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1"; # necesario para hyprland
  };
}
