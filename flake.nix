{
  description = "OnigiriByte's Flake Config";

  inputs = {
    nixpkgs.url = github:nixos/nixpkgs/nixos-23.05;
    home-manager = {
      url = github:nix-community/home-manager/release-23.05;
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # dotfiles.url = "github:OnigiriByte/dotfiles"
    dotfiles = {
        url = "github:OnigiriByte/dotfiles";
        flake = false;
    };
  };

  outputs = inputs@{self, nixpkgs, home-manager,  ... }:
  let
    username = "onigiribyte";
    system = "x86_64-linux";
    # pkgs = nixpkgs.legacyPackages.${system};
    pkgs = import nixpkgs {
        inherit system;
        config = {
            allowUnfree = true;
        };
    };

    lib = nixpkgs.lib;
  in
  {
    nixosConfigurations = {
      "nixos" = nixpkgs.lib.nixosSystem {
        inherit system;
        # specialArgs = attrs;
        modules = [
          ./nixos/configuration.nix
        ];
      };
    };

    homeConfigurations = {
        ${username} = home-manager.lib.homeManagerConfiguration {
            inherit system pkgs;
            homeDirectory = "/home/${username}";
            inherit username;
            modules = [
                ./home-manager/home.nix
            ];
        };
    };
  };
}
