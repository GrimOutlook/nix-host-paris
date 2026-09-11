# Ported from this host's old hyprpanel layout: menu/workspaces/window title on
# the left, nothing in the middle, system stats and status on the right.
# hyprpanel's separate cputemp/cpu/ram/netstat widgets are all one Noctalia
# SystemMonitor widget.
{
  host.noctalia.settings = {
    bar.widgets = {
      left = [
        { id = "ControlCenter"; }
        { id = "Workspace"; }
        { id = "ActiveWindow"; }
      ];
      center = [ ];
      right = [
        { id = "Volume"; }
        {
          id = "SystemMonitor";
          showNetworkStats = true;
        }
        { id = "Battery"; }
        { id = "Tray"; }
        { id = "Clock"; }
        { id = "NotificationHistory"; }
      ];
    };
  };

  # The Hyprland package exposes both direct and UWSM-managed sessions. Keep
  # the greeter from restoring the stale UWSM selection after it is disabled.
  host.display-manager.settings = {
    keyboard.layout = "us";
    cursor.size = 24;
    session.default = "Hyprland";
  };
}
