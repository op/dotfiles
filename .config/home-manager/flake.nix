{
  description = "CLI tooling for the dotfiles in this repo";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    { nixpkgs, home-manager, ... }:
    let
      mkHome =
        system: username:
        home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.${system};
          modules = [ ./home.nix ];
          extraSpecialArgs = { inherit username; };
        };
    in
    {
      # `home-manager switch` picks the entry matching $USER.
      homeConfigurations = {
        ec2-user = mkHome "x86_64-linux" "ec2-user";
      };
    };
}
