{
    description = "A very basic flake";

# NOTE: inputs are the dependencies of the flake
# each item in 'inputs' will be passed as a parameter to the 'outputs function'
    inputs = {
# Specify the source of Home Manager and Nixpkgs.
        nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
        nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-23.05";
        home-manager = {
            url = "github:nix-community/home-manager/master";
            inputs.nixpkgs.follows = "nixpkgs";
        };
    };

# NOTE: Outputs function will return all the build results of the flake.
# A flake can have many use cases and different types of outputs.
# The parameters are defined from the inputs and can be referred by their names.

# INFO: 
# 'self'  refers to  'outputs' itself
# inputs@ is at syntax that aliases the attribute set (arguments), making it
# conventient to use inside the function.

    outputs = inputs@{ self, nixpkgs, nixpkgs-stable, home-manager, ... }: let

        system = "x86_64-linux";
# pkgs = nixpkgs.legacyPackages.${system};
# pkgs = import nixpkgs {
# inherit system;
# config.allowUnfree = true;
# };

    # pkgs = nixpkgs.legacyPackages.${system};
    pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
    };

    # pkgs-stable = nixpkgs-stable.legacyPackages.${system};
    pkgs-stable = import nixpkgs-stable {
        inherit system;
        config.allowUnfree = true;
    };

    in
    {
        nixosConfigurations = {
            nixos = nixpkgs.lib.nixosSystem {
                inherit system;
# The Nix module system can modularize configuration,
# improving the maintainability of configuration.
#
# Each parameter in the `modules` is a Nix Module, and
# there is a partial introduction to it in the nixpkgs manual:
#    <https://nixos.org/manual/nixpkgs/unstable/#module-system-introduction>
# It is said to be partial because the documentation is not
# complete, only some simple introductions.
# such is the current state of Nix documentation...
#
# A Nix Module can be an attribute set, or a function that
# returns an attribute set. By default, if a Nix Module is a
# function, this function can only have the following parameters:
#
#  lib:     the nixpkgs function library, which provides many
#             useful functions for operating Nix expressions:
#             https://nixos.org/manual/nixpkgs/stable/#id-1.4
#  config:  all config options of the current flake, every useful
#  options: all options defined in all NixOS Modules
#             in the current flake
#  pkgs:   a collection of all packages defined in nixpkgs,
#            plus a set of functions related to packaging.
#            you can assume its default value is
#            `nixpkgs.legacyPackages."${system}"` for now.
#            can be customed by `nixpkgs.pkgs` option
#  modulesPath: the default path of nixpkgs's modules folder,
#               used to import some extra modules from nixpkgs.
#               this parameter is rarely used,
#               you can ignore it for now.
#
# Only these parameters can be passed by default.
# If you need to pass other parameters,
# you must use `specialArgs` by uncomment the following line:
#
# specialArgs = {...}  # pass custom arguments into all sub module.
                specialArgs = {
                    inherit pkgs-stable;
                };
                modules = [./configuration.nix];
            };
        };

        homeConfigurations = {
            onigiribyte = home-manager.lib.homeManagerConfiguration {
                inherit pkgs;
                extraSpecialArgs = {
                    inherit pkgs-stable;
                };
                modules = [./home.nix];
            };
        };
    };
}
