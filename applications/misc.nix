{ pkgs, ... }: {

  programs = {
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
}
