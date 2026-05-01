{
  boot = {
    initrd.kernelModules = [
      "nvidia"
      "nvidia_modeset"
      "nvidia_uvm"
      "nvidia_drm"
    ];
    # Also ensure DRM modesetting is enabled
    kernelParams = [ "nvidia-drm.modeset=1" ];
  };
}
