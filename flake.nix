{
  description = "NixOS configuration for paris";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";

    nix-config = {
      url = "github:GrimOutlook/nix-config";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{ self, nix-config, ... }:
    let
      pkgs = import inputs.nixpkgs {
        system = "x86_64-linux";
        config.allowUnfree = true;
      };
    in
    nix-config.inputs.flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [
        nix-config.modules.flake.hosts
        nix-config.modules.flake.host-info
        (nix-config + "/flakes/systems.nix")
      ];

      modules = [
        "bluetooth"
        "dev"
        "laptop"
        "networking"
        "virtualization"
      ];

      host-info = rec {
        name = "paris";
        flake = "github:GrimOutlook/nix-host-${name}";
      };

      nixos = {
        modules = [ ./hardware.nix ];
        environment.systemPackages = with pkgs; [
          chromium
          qmk
          qmk_hid
        ];
        services.udev.packages = with pkgs; [
          qmk-udev-rules
        ];
        system = {
          autoUpgrade.enable = true;
          stateVersion = "25.05";
        };
      };

      home = {
        home = {
          packages = with pkgs; [
            prusa-slicer
            orca-slicer
          ];
          stateVersion = "25.11";
        };
      };
    };
}
