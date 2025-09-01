{ pkgs, ... }: {

  programs = {
    # some gnupg settings moved to /security/
    file-roller = {
      enable = true;
    };
    tmux.enable = true;
  };

  environment.systemPackages = with pkgs; [
    git-crypt
    home-manager
    _7zz
  ];

  # make GVFS happy
  services.samba-wsdd = {
    enable = true;
  };
}
