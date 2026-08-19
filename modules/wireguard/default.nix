{ config, ... }:
{
  age.secrets.wireguard-newyork-key = {
    file = ./secrets/wireguard-newyork-key.age;
    mode = "0400";
  };

  networking.wireguard.interfaces.wg0 = {
    privateKeyFile = config.age.secrets.wireguard-newyork-key.path;

    peers = [
      {
        # newyork, derived from the privateKey in
        # hosts/newyork/modules/services/wireguard.nix
        publicKey = "JshdBxlRRgNBuxtQDjmDcUmFpZfH5RoZV5wHGHk46CY=";
        endpoint = "grimaldifamily.org:51820";
        # Route the WireGuard mesh and the whole homelab LAN through the
        # tunnel; everything else (paris's normal internet traffic) stays
        # split off the tunnel.
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

  networking.interfaces.wg0.ipv4.addresses = [
    {
      address = "172.16.0.3";
      prefixLength = 24;
    }
  ];
}
