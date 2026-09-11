{ lib, ... }:
{
  # NixOS activation reexecutes active user managers. UWSM tears down its
  # compositor session during that reexec, so use a direct Hyprland session.
  programs.hyprland.withUWSM = lib.mkForce false;
}
