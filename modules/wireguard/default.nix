{ config, ... }:
{
  age.secrets.wireguard-newyork-key = {
    file = ./secrets/wireguard-newyork-key.age;
    mode = "0400";
  };

  networking.wg-quick.interfaces.wg0 = {
    # Brought up on demand only (`systemctl start wg-quick-wg0`), not at boot.
    # Note that `systemctl disable` would not survive the next activation --
    # this option is what actually drops the unit's [Install] section.
    autostart = false;
    address = [ "172.16.0.3/24" ];
    # Point at newyork's dnsmasq (it listens on the wg0 address) so LAN
    # hostnames resolve while roaming; the routes below are useless without a
    # resolver that knows `home.arpa`. On the home LAN this is redundant --
    # DHCP already hands out the same server -- but off-LAN the foreign
    # network's resolver knows nothing about these names. The bare domain
    # entry becomes a search domain, so `dubai` works as well as
    # `dubai.home.arpa`.
    #
    # Note this replaces the system resolver outright for as long as wg0 is
    # up, rather than routing only `home.arpa` to newyork -- acceptable
    # because the interface is started by hand, but it does mean a captive
    # portal has to be dealt with before bringing the tunnel up.
    dns = [
      "172.16.0.1"
      "home.arpa"
    ];
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
  # lookup: a single failure leaves wg0 up with no peer and no routes, and
  # nothing ever tries again. paris sat in exactly that state, unnoticed, for
  # nearly two days in August 2026. Since the interface is started by hand on a
  # laptop that roams between networks, a start issued before the new network's
  # DNS is usable is the common case. Retry until the name resolves.
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
