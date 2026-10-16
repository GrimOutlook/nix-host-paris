{
  inputs = {
    homelab.url = "git+ssh://git@github.com/GrimOutlook/nix-homelab";
    nix-config.url = "github:GrimOutlook/nix-config";
    nix-config.inputs.opencode-permission-reviewer.url = "git+https://github.com/GrimOutlook/opencode-permission-reviewer.git?ref=review-history&rev=4ff8858a6f6eb88f9d4ce799cf237729d4304e6f";
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
