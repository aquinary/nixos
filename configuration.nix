# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, file, ... }:

let 
  home-manager = builtins.fetchTarball "https://github.com/nix-community/home-manager/archive/master.tar.gz";
in
{
  imports =
    [ 
      (import "${home-manager}/nixos")
      ./hardware-configuration.nix
    ];
  nix.settings.experimental-features = ["nix-command" "flakes"];
  # Bootloader.
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/vda";
  boot.loader.grub.useOSProber = true;
 
  networking.hostName = "nixos"; # Define your hostname.

  security.polkit.enable = true;

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Moscow";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "ru_RU.UTF-8";
    LC_IDENTIFICATION = "ru_RU.UTF-8";
    LC_MEASUREMENT = "ru_RU.UTF-8";
    LC_MONETARY = "ru_RU.UTF-8";
    LC_NAME = "ru_RU.UTF-8";
    LC_NUMERIC = "ru_RU.UTF-8";
    LC_PAPER = "ru_RU.UTF-8";
    LC_TELEPHONE = "ru_RU.UTF-8";
    LC_TIME = "ru_RU.UTF-8";
  };

  programs = { 
    fish.enable = true;
    dconf.enable = true;
  };

  users = {
    defaultUserShell = pkgs.fish;
    users.q = {
      isNormalUser = true;
      description = "q";
      extraGroups = [ "networkmanager" "wheel" "libvirtd" ];
    };
  };


  virtualisation.libvirtd.enable = true;
  nixpkgs.config.allowUnfree = true;

  qt5 = {
    enable = true;
    platformTheme = "qt5ct";
  };

  environment.systemPackages = with pkgs; [
    dex
    qemu
    gnome.gucharmap
    gnome.gnome-font-viewer
    wget
    material-icons
    git
    nix-output-monitor
    ranger
    gtk3
    gnome.seahorse
    (pkgs.callPackage ./pkgs/caja-extensions { })
    unzip
    unrar
    feh
    neofetch
    virt-manager
    mate.engrampa
    btop
    lm_sensors
    copyq
    crow-translate
    sakura
    vscode
    tdesktop
    vivaldi
    rofi
    lxappearance
    lua
    sublime4
    gparted
    xfce.catfish
    libsForQt5.qtstyleplugin-kvantum
  ];

  
  fonts.fonts = with pkgs; [
    material-icons
  ];
  services = {
    xserver = {
      enable = true;
      windowManager.awesome.enable = true;
      
      displayManager = {  
        defaultSession = "none+awesome";
        autoLogin = {
          enable = true;
          user = "q"; 
         };
      };
    };
    gnome.gnome-keyring.enable = true;
    vnstat.enable = true;
  };

  home-manager.users = {
    root = {
      home.username = "root";
      home.homeDirectory = "/root";
      home.stateVersion = "22.11";
      home = {
        file = {
          ".config/gtk-3.0/settings.ini".source = ./configs/gtk-3.0/settings-dark.ini;
         
          ".config/sakura/sakura.conf".source = ./configs/sakura/sakura.conf;
          ".config/Kvantum".source = ./configs/Kvantum; 
          ".config/qt5ct".source = ./configs/qt5ct;
          ".config/omf".source = ./configs/omf;
          ".config/fish".source = ./configs/fish;
          ".config/dconf".source = ./configs/dconf;

           ".themes/Seventeen-Dark".source = ./themes/Seventeen-Dark;
          ".icons".source = ./icons;

          ".local/share/fonts".source = ./locals/fonts;
          ".local/share/fish".source = ./locals/fish;
          ".local/share/omf".source = ./locals/omf;
        }; 
      };
    };
    q = {config, pkgs, ...}: {
      home.username = "q";
      home.homeDirectory = "/home/q";
      home.stateVersion = "22.11";
      home.packages = with pkgs; [
        mate.mate-polkit
      ];

      programs = {
        home-manager.enable = true;
        git = {
          enable = true;
          userName = "aquinary";
          userEmail = "git@aquinary.ru";
        };
      }; 
      home = {
        file = {
          ".config/awesome".source = ./configs/awesome;

          ".config/gtk-3.0/settings.ini".source = ./configs/gtk-3.0/settings-light.ini;
          ".config/gtk-3.0/colors.css".source = ./configs/gtk-3.0/colors.css;
          ".config/gtk-3.0/gtk.css".source = ./configs/gtk-3.0/gtk.css;

          ".config/sakura/sakura.conf".source = ./configs/sakura/sakura.conf;
          ".config/Kvantum".source = ./configs/Kvantum; 
          ".config/qt5ct".source = ./configs/qt5ct;
          ".config/omf".source = ./configs/omf;
          ".config/fish".source = ./configs/fish;
          ".config/dconf".source = config.lib.file.mkOutOfStoreSymlink ./configs/dconf;
          
          ".themes/Seventeen-Light".source = ./themes/Seventeen-Light;
          ".icons".source = ./icons; 

          ".local/share/fonts".source = ./locals/fonts;
          ".local/share/fish".source = ./locals/fish;
          ".local/share/omf".source = ./locals/omf;
        };
      };
    };    
  };
  system.stateVersion = "22.11"; # Did you read the comment?

}
