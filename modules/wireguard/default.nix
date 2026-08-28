{ config, ... }:
{
  age.secrets.wireguard-newyork-key = {
    file = ./secrets/wireguard-newyork-key.age;
    mode = "0400";
  };

  networking.wg-quick.interfaces.wg0 = {
    address = [ "172.16.0.3/24" ];
    # Installed via a PostUp `wg set ... private-key` hook, so the key is
    # never copied into the world-readable /nix/store config file.
    privateKeyFile = config.age.secrets.wireguard-newyork-key.path;

    peers = [
      {
        # newyork, derived from the privateKey in
        # hosts/newyork/modules/services/wireguard.nix
        publicKey = "JshdBxlRRgNBuxtQDjmDcUmFpZfH5RoZV5wHGHk46CY=";
        endpoint = "grimaldifamily.org:51820";
        # Route the WireGuard mesh and the whole homelab LAN through the
        # tunnel; everything else (paris's normal internet traffic) stays
        # split off the tunnel. wg-quick derives the routes from these
        # prefixes, so no hand-written `ip route` calls are needed.
        allowedIPs = [
          "172.16.0.0/24"
          "10.0.0.0/8"
        ];
        # paris roams between networks/NATs; keep the NAT mapping on
        # newyork's side alive so it can still reach paris unprompted.
        persistentKeepalive = 25;
      }
    ];
  };

  # The endpoint is a DNS name, and neither wg-quick nor `wg` retries a failed
  # lookup. A boot that wins the race against DNS therefore leaves the tunnel
  # down permanently and silently, which is exactly what happened on
  # 2026-08-25. Retry until the name resolves.
  systemd.services.wg-quick-wg0 = {
    serviceConfig = {
      Restart = "on-failure";
      RestartSec = 5;
    };
    # Without this, systemd's default start-rate limit (5 attempts per 10s)
    # gives up and leaves the unit failed, reintroducing the same silent
    # failure for any DNS outage lasting more than a few seconds.
    startLimitIntervalSec = 0;
  };
}
