{
  host.home-manager.config = {
    programs.ssh.settings = {
      "Host Newyork" = {
        HostName = "video.grimaldifamily.org";
        Port = 49999;
        User = "root";
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
    };
  };
}
