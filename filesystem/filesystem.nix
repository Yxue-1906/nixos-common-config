{ ... }: {
  # Enable udisks, allow mount internal disks without authentication
  services.udisks2 = {
    enable = true;
    mountOnMedia = true;
  };

  services.udev.extraRules = ''
    # fix GH-23
    # see: https://storaged.org/doc/udisks2-api/latest/mount_options.html#id-1.2.8.12
    ACTION=="add", SUBSYSTEMS=="usb", ENV{UDISKS_MOUNT_OPTIONS_DEFAULTS}+="sync"

    # see: https://storaged.org/doc/udisks2-api/latest/udisks.8.html#id-1.2.4.7
    ACTION=="add", ENV{ID_FS_USAGE}=="filesystem", ENV{UDISKS_AUTO}="1"
  '';

  security.polkit = {
    enable = true;
    # Allow user in group wheel mount drives without authentication
    extraConfig = ''
      polkit.addRule(function(action, subject) {
        if ((action.id == "org.freedesktop.udisks2.filesystem-mount-system" ||
           action.id == "org.freedesktop.udisks2.filesystem-mount") &&
          subject.isInGroup("wheel")) {
          return polkit.Result.YES;
        }
      });
    '';
  };
}
