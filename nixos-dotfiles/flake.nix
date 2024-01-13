{
  description = "Meow :3";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixpkgs-unstable";
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-23.11";
    plasma6.url = "github:nix-community/kde2nix";
  };

  outputs = {self, nixpkgs, nixpkgs-stable, plasma6} @ inputs: let
    system = "x86_64-linux";
    overlay-stable = final: prev: {
      stable = import nixpkgs-stable { inherit system; config.allowUnfree = true; };  # unfree needed for unity....
    };
  in {
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      inherit system;
      specialArgs = { inherit inputs; };
      modules = [
        ({ config, pkgs, ... }: { nixpkgs.overlays = [ overlay-stable ]; })
         ./configuration.nix plasma6.nixosModules.default
      ];
    };

    formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.alejandra;
  };
}
