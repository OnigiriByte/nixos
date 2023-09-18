{ config, pkgs,pkgs-stable, lib, ... }:


let
user = "onigiribyte";
# userHome = "/home/${user}";
userHome =config.home.homeDirectory;
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
          discord

#INFO: Langs
      bun 
          go
          nodejs_18
          gcc
          # rustup
          rustc
          cargo
          zig

#INFO: Archive utils
          zip
          xz
          unzip
          p7zip

#INFO: utils
          fzf
          ripgrep
          aria2
          jq
          zoxide
          bat
          xclip
          cht-sh
          glow

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
    {id = "nngceckbapebfimnlniiiahkandclblb";}
    ];
  };


xresources.properties = {
    "Xcursor.size" = 32;
};

programs.git = {
    enable = true;
    userName = "OnigiriByte";
    userEmail = "OnigiriByte@proton.me";
    # diff-so-fancy = {
    #     enable = true;
    # };

    difftastic = {
        enable = true;

    };
};

# NOTE: Dotfiles linking
  xdg.configFile = {
    "qtile" = {
      source = "${userHome}/dotfiles/qtile";
# recursive = true;
      target = "qtile/";
    };

    "rofi" = {
      source = "${userHome}/dotfiles/rofi";
      target = "rofi/";
    };

     "nvim" = {
       source = config.lib.file.mkOutOfStoreSymlink "${userHome}/dotfiles/nvim";
 # recursive = true;
     };
   };

  home.file = {
    ".wezterm.lua" = {
      source = /home/onigiribyte/dotfiles/.wezterm.lua;
    };
  };


  home.file = {
    ".xinitrc" = {
      source = /home/onigiribyte/dotfiles/.xinitrc;
    };
  };


}
