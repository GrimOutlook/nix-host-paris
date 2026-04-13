{
  inputs = {
    homelab.url = "git+ssh://git@github.com/GrimOutlook/nix-homelab";

    nix-config = {
      url = "github:GrimOutlook/nix-config";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";

  };

  outputs =
    inputs@{
      self,
      nix-config,
      nixpkgs,
      ...
    }:
    {
      nixosConfigurations.paris = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {
          inherit inputs;
        };
        modules = [
          nix-config.nixosModules.default
        ]
        ++ builtins.map (f: ./modules + "/${f}") (builtins.attrNames (builtins.readDir ./modules));
      };
    };
}
