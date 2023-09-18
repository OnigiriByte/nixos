# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config,lib, pkgs, pkgs-stable, ... }:

let 
user = "onigiribyte";
in

{
    imports =
        [ # Include the results of the hardware scan.
        ./hardware-configuration.nix
        ];

# Bootloader.
    boot.loader.grub.enable = true;
    boot.loader.grub.device = "/dev/sda";
    boot.loader.grub.useOSProber = true;
    boot.kernelPackages = pkgs.linuxPackages_5_4;
    boot.kernelModules = ["vmw_balloon" "vmw-pvscsi" "vsock" "vmw_vmci" "vmwgfx" "vmw_vsock_vmci_transport" ];

    networking.hostName = "nixos"; # Define your hostname.
# networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

# Configure network proxy if necessary
# networking.proxy.default = "http://user:password@proxy:port/";
# networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

# Enable networking
        networking.networkmanager.enable = true;

# Set your time zone.
    time.timeZone = "America/Chicago";

    hardware.opengl.driSupport32Bit = true;

# Select internationalisation properties.
    i18n.defaultLocale = "en_US.UTF-8";

    i18n.extraLocaleSettings = {
        LC_ADDRESS = "en_US.UTF-8";
        LC_IDENTIFICATION = "en_US.UTF-8";
        LC_MEASUREMENT = "en_US.UTF-8";
        LC_MONETARY = "en_US.UTF-8";
        LC_NAME = "en_US.UTF-8";
        LC_NUMERIC = "en_US.UTF-8";
        LC_PAPER = "en_US.UTF-8";
        LC_TELEPHONE = "en_US.UTF-8";
        LC_TIME = "en_US.UTF-8";
    };


# Define a user account. Don't forget to set a password with ‘passwd’.
    users.users.${user} = {
        isNormalUser = true;
        description = "OnigiriByte";
        extraGroups = [ "networkmanager" "wheel" "docker" ];
        packages = with pkgs; [];
        shell = pkgs.zsh;
    };


# Allow unfree packages
    nixpkgs.config.allowUnfree = true;

# Enable command shell
    programs.zsh.enable = true;
    environment.shells = with pkgs; [ zsh ];


# List packages installed in system profile. To search, run:
# $ nix search wget
    environment.systemPackages = with pkgs; [
            wget
	    curl
            brave
            wezterm
            git
            zsh
            open-vm-tools
            neovim
            xcb-util-cursor
            gtkmm4
            gtk2
            xdg-user-dirs
            xdg-utils

#
#  vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
#  wget
    ];


# Some programs need SUID wrappers, can be configured further or are
# started in user sessions.
# programs.mtr.enable = true;
# programs.gnupg.agent = {
#   enable = true;
#   enableSSHSupport = true;
# };



#vmware
    virtualisation.vmware.guest.enable = true;
# Open ports in the firewall.
# networking.firewall.allowedTCPPorts = [ ... ];
# networking.firewall.allowedUDPPorts = [ ... ];
# Or disable the firewall altogether.
# networking.firewall.enable = false;

# This value determines the NixOS release from which the default
# settings for stateful data, like file locations and database versions
# on your system were taken. It‘s perfectly fine and recommended to leave
# this value at the release version of the first install of this system.
# Before changing this value read the documentation for this option
# (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
    system.stateVersion = "23.05"; # Did you read the comment?

#enable docker
        virtualisation.docker.enable = true;

    security.rtkit.enable = true;
# List services that you want to enable:

    services = {
# Enable the OpenSSH daemon.
        openssh.enable = true;
#Enabling Pipewire
        pipewire = {
            enable = true;
            alsa.enable = true;
            alsa.support32Bit = true;
            audio.enable = true;
            pulse.enable = true;
            jack.enable = true;
        };

	picom = {
		enable = true;
		backend = "glx";
		menuOpacity = 0.8;
		fade = true;
		shadow = true;
		fadeDelta = 4;
	};

# Configure keymap in X11
       xserver = {
            enable = true;
            autorun = false;
            layout = "us";
            xkbVariant = "";
            windowManager = {
                qtile = {
                    enable = true;
                    backend = "x11";
                    package = pkgs-stable.qtile;
                };
            };
            displayManager = {
                startx.enable = true;
            };
            videoDrivers = [
                "vmware"
            ];
        };
    };


    nix.settings.experimental-features = ["nix-command" "flakes"];
    environment.variables.EDITOR = "nvim";

# nix = {
# 	package = pkgs.nixFlakes;
# 	extraOptions = "Experimental-features = nix-command flakes";
# 
# };


}

