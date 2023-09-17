{
  description = "A very basic flake";

  inputs = {
    # Specify the source of Home Manager and Nixpkgs.
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.05";
    home-manager = {
      url = "github:nix-community/home-manager/release-23.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ self, nixpkgs, home-manager, ... }: let
  	system = "x86_64-linux";
	# pkgs = nixpkgs.legacyPackages.${system};
	pkgs = import nixpkgs {
	inherit system;
	config.allowUnfree = true;
	};

  in
  {
  	nixosConfigurations = {
	nixos = nixpkgs.lib.nixosSystem {
	inherit system;
	modules = [./configuration.nix];
	};
	};

	homeConfigurations = {
onigiribyte = home-manager.lib.homeManagerConfiguration {
	inherit pkgs;
	extraSpecialArgs = inputs;
	modules = [./home.nix];
};
	};
  };
}
