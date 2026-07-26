{
  inputs = {
    homelab.url = "git+ssh://git@github.com/GrimOutlook/nix-homelab";
    nix-config.url = "github:GrimOutlook/nix-config";
    nixpkgs.follows = "nix-config/nixpkgs";
  };

  outputs =
    inputs@{
      nix-config,
      ...
    }:
    nix-config.lib.mkHost {
      hostname = "paris";
      system = "x86_64-linux";
      specialArgs = { inherit inputs; };
      modules = builtins.map (f: ./modules + "/${f}") (
        builtins.attrNames (builtins.readDir ./modules)
      );
    };
}
