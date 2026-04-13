{ inputs, pkgs, ... }:
{

  host = {
    bluetooth.enable = true;
    build-arm.enable = true;
    dev.enable = true;
    lang.rust.enable = true;
    lang.typescript.enable = true;
    network-diag.enable = true;
    type.laptop.enable = true;
    virtualization.enable = true;
  };

  environment.systemPackages = with pkgs; [
    chromium
    keepassxc
    qmk
    qmk_hid
  ];
  services.udev.packages = with pkgs; [
    qmk-udev-rules
  ];

  host.home-manager.config = {
    imports = [
      inputs.homelab.homeManagerModules.default
    ];
    homelab.ssh_config.enable = true;
    home = {
      packages = with pkgs; [
        prusa-slicer
        orca-slicer
      ];
    };
  };
}
