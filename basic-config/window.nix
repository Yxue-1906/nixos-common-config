{ pkgs, ... }: {

  services.displayManager.gdm.enable = true;
  services.desktopManager.gnome.enable = true;

  # Enable the X11 windowing system.
  services.xserver = {
    enable = true;
    xkb = {
      layout = "cn";
      variant = "";
      options = "";
    };
  };
}
