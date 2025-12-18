{ pkgs, ... }: {
  # Enable the X11 windowing system.
  services.xserver = {
    enable = true;
    displayManager.gdm = {
      enable = true;
      wayland = true;
    };
    desktopManager.gnome = {
      enable = true;
      # extraGSettingsOverridePackages = [ pkgs.mutter ];
      # extraGSettingsOverrides = ''
      #   [org.gnome.mutter]
      #   experimental-features=['scale-monitor-framebuffer']
      # '';
    };
    xkb = {
      layout = "cn";
      variant = "";
      options = "";
    };
  };
}
