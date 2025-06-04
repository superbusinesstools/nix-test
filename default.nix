{ config, pkgs, ... }:

{
  nixpkgs.config.allowUnfree = true;

  system.stateVersion = "25.05";

  # Enable user
  users.users.user = {
    isNormalUser = true;
    shell = pkgs.zsh;
    extraGroups = [ "wheel" ]; # sudo access
    home = "/home/user";
  };

  # Zsh shell
  programs.zsh.enable = true;

  # X11 with i3
  services.xserver = {
    enable = true;
    windowManager.i3.enable = true;
    displayManager.startx.enable = true;
    xkb.layout = "us";
  };

  # OpenSSH server
  services.openssh.enable = true;

  # Fonts
  fonts.fonts = with pkgs; [
    dejavu_fonts
    liberation_ttf
    noto-fonts
  ];

  # Terminal
  programs.alacritty.enable = true;

  # NVM + Node.js 22
  programs.nvm = {
    enable = true;
    nodejsVersion = "22";
  };
  programs.npm.enable = true;

  # Samba server
  services.samba = {
    enable = true;
    securityType = "user";
    extraConfig = ''
      workgroup = WORKGROUP
      server string = NixOS Samba Server
      map to guest = Bad User
    '';
    shares = {
      public = {
        path = "/home/user/Public";
        browseable = true;
        "read only" = false;
        "guest ok" = true;
      };
    };
  };

  # Open firewall ports for Samba
  networking.firewall.allowedTCPPorts = [ 139 445 ];
  networking.firewall.allowedUDPPorts = [ 137 138 ];

  # Ensure Samba share directory exists
  system.activationScripts.ensureShareDir.text = ''
    mkdir -p /home/user/Public
    chown user:users /home/user/Public
  '';

  # Global system packages
  environment.systemPackages = with pkgs; [
    git
    wget
    curl
    firefox
    pnpm
    jetbrains.webstorm
    phpPackages.composer
    (php.buildEnv {
      extensions = { enabled, all }: with all; [
        curl
        mbstring
        mysqli
        pdo
        pdo_mysql
        xml
        zip
        opcache
        gd
        intl
      ];
    })
    nodejs_22
  ];
}
