{
  inputs = {
    homelab.url = "git+ssh://git@github.com/GrimOutlook/nix-homelab";
    nix-config.url = "github:GrimOutlook/nix-config";
    nixpkgs.follows = "nix-config/nixpkgs";
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
