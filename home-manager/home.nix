{ config, pkgs, ... }:


let
user = "onigiribyte";
userHome = "/home/${user}";
in
{
# Home Manager needs a bit of information about you and the paths it should
# manage.
  home.username = "onigiribyte";
  home.homeDirectory = "/home/onigiribyte";

# This value determines the Home Manager release that your configuration is
# compatible with. This helps avoid breakage when a new Home Manager release
# introduces backwards incompatible changes.
#
# You should not change this value, even if you update Home Manager. If you do
# want to update the value, then make sure to first check the Home Manager
# release notes.
  home.stateVersion = "23.05"; # Please read the comment before changing.

    nix = {
      package = pkgs.nix;
      settings.experimental-features = [ "nix-command" "flakes" ];
    };

  nixpkgs = {
    config = {
      allowUnfree = true;
    };
  };

# The home.packages option allows you to install Nix packages into your
# environment.
  home.packages = with pkgs; [
# # Adds the 'hello' command to your environment. It prints a friendly
# # "Hello, world!" when run.
# pkgs.hello

    bun
      go
      unzip
      nodejs_18
      zoxide
      fzf
      xclip
      cht-sh
      bat
      discord
      gcc
      zig

      (pkgs.rofi.override { plugins = [ pkgs.rofi-emoji ]; })

# # It is sometimes useful to fine-tune packages, for example, by applying
# # overrides. You can do that directly here, just don't forget the
# # parentheses. Maybe you want to install Nerd Fonts with a limited number of
# # fonts?
# (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })


# # You can also create simple shell scripts directly inside your
# # configuration. For example, this adds a command 'my-hello' to your
# # environment:
# (pkgs.writeShellScriptBin "my-hello" ''
#   echo "Hello, ${config.home.username}!"
# '')
      ];

# Home Manager is pretty good at managing dotfiles. The primary way to manage
# plain files is through 'home.file'.
  home.file = {
# # Building this configuration will create a copy of 'dotfiles/screenrc' in
# # the Nix store. Activating the configuration will then make '~/.screenrc' a
# # symlink to the Nix store copy.
# ".screenrc".source = dotfiles/screenrc;

# # You can also set the file content immediately.
# ".gradle/gradle.properties".text = ''
#   org.gradle.console=verbose
#   org.gradle.daemon.idletimeout=3600000
# '';
  };

# You can also manage environment variables but you will have to manually
# source
#
#  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
#
# or
#
#  /etc/profiles/per-user/onigiribyte/etc/profile.d/hm-session-vars.sh
#
# if you don't want to manage your shell through Home Manager.
  home.sessionVariables = {
    EDITOR = "nvim";
  };

# Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
  programs.zsh = {
    enable = true;
    enableAutosuggestions = true;
    enableCompletion = true;
    defaultKeymap = "vicmd";
    shellAliases = {
      update = "sudo nixos-rebuild switch";
    };
    completionInit = ''
      autoload -U compinit && compinit
      eval "$(zoxide init zsh)"
      '';

  };

  programs.chromium = {
    enable = true;
    package = pkgs.brave;
    extensions = [
    {id = "gfbliohnnapiefjpjlpjnehglfpaknnc";}
    ];
  };

  xdg.configFile = {
    "qtile" = {
      source = "${userHome}"/dotfiles/qtile;
# recursive = true;
      target = "qtile/";
    };

    "rofi" = {
      source = "${userHome}"/dotfiles/rofi;
      target = "rofi/";
    };

    "nvim" = {
      source = config.lib.file.mkOutOfStoreSymlink "${userHome}"/dotfiles/nvim;
# recursive = true;
    };
  };

  home.file = {
    ".wezterm.lua" = {
      source = /home/onigiribyte/dotfiles/.wezterm.lua;
    };
  };
}
