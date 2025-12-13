{ pkgs, ... }: {

  programs = {
    file-roller.enable = true;
    tmux.enable = true;
  };

  environment.systemPackages = with pkgs; [
    busybox # for common useful tools like nslookup and so on

    git-crypt
    home-manager
    _7zz
  ];

  # make GVFS happy
  services.samba-wsdd = {
    enable = true;
  };

  # let adb access devices
  # see: https://nixos.wiki/wiki/Android#adb_setup
  services.udev.packages = [
    pkgs.android-udev-rules
  ];
}
