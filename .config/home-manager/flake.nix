{
  description = "CLI tooling for the dotfiles in this repo";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # single python script, packaged in home.nix
    dolly = {
      url = "github:op/dolly";
      flake = false;
    };
  };

  outputs =
    { nixpkgs, home-manager, dolly, ... }:
    let
      mkHome =
        system: username:
        home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.${system};
          modules = [ ./home.nix ];
          extraSpecialArgs = { inherit username dolly; };
        };
    in
    {
      # `home-manager switch` picks the entry matching $USER.
      homeConfigurations = {
        ec2-user = mkHome "x86_64-linux" "ec2-user";
      };
    };
}
