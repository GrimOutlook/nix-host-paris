{
  description = "NixOS configuration for hongkong";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";

    nix-config = {
      url = "path:/home/grim/nix-config";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{ nix-config, ... }:
    nix-config.inputs.flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [
        nix-config.modules.flake.hosts
        (nix-config + "/modules/flake/systems.nix")
      ];
      host.hongkong = {
        nixos = {
          modules = with nix-config.modules.nixos; [
            dev
            wsl
          ];
          system = {
            autoUpgrade.enable = false;
            stateVersion = "25.05";
          };
        };
        home = {
          modules = with nix-config.modules.homeManager; [
            dev
          ];
          home.stateVersion = "25.11";
        };
      };
    };
}
