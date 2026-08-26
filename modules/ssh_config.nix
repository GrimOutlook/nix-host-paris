{
  host.home-manager.config = {
    programs.ssh.settings = {
      "Host Newyork" = {
        HostName = "grimaldifamily.org";
        Port = 49999;
        User = "grim";
      };
      "Host Berlin" = {
        HostName = "berlin";
        User = "grim";
        ProxyJump = "Newyork";
      };
      "Host Dubai" = {
        HostName = "dubai";
        User = "pi";
        ProxyJump = "Newyork";
      };
      "Host Pyongyang" = {
        HostName = "pyongyang";
        User = "grim";
        ProxyJump = "Newyork";
      };
      "Host Amsterdam" = {
        HostName = "amsterdam";
        User = "grim";
        ProxyJump = "Newyork";
      };
      # Only speaks SHA-1 era crypto, which OpenSSH disables by default.
      "Host cisco-switch" = {
        User = "admin";
        KexAlgorithms = "+diffie-hellman-group14-sha1";
        HostKeyAlgorithms = "+ssh-rsa";
        PubkeyAcceptedAlgorithms = "+ssh-rsa";
      };
    };
  };
}
