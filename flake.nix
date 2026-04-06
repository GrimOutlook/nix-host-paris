{
  description = "NixOS configuration for paris";

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
      homelab,
      nix-config,
      ...
    }:
    let
      pkgs = import inputs.nixpkgs {
        system = "x86_64-linux";
        config.allowUnfree = true;
      };
      host-info = rec {
        name = "paris";
        flake = "github:GrimOutlook/nix-host-${name}";
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
        "build-arm"
        "dev"
        "laptop"
        "lang_rust"
        "lang_toml"
        "lang_yaml"
        "network-diag"
        "virtualization"
      ];

      inherit host-info;

      nixos = {
        imports = [
          ./modules/hardware.nix
        ];
        environment.systemPackages = with pkgs; [
          chromium
          keepassxc
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
        imports = [
          homelab.homeManagerModules.default

          ./modules/hyprpanel.nix
        ];
        homelab.ssh_config.enable = true;
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
