let
  # paris's own SSH host key, used so the running system can decrypt secrets
  # at boot. Get it with `cat /etc/ssh/ssh_host_ed25519_key.pub` on paris.
  paris = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIISBaMUBkrHUa1Mglwy9pT9+PT4lk+cRL7c/cUoz2Gko root@paris";
in
{
  "wireguard-newyork-key.age" = {
    publicKeys = [ paris ];
    armor = true; # More readable diffs
  };
}
