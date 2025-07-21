{ pkgs, ... }: {

  programs = {
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };
    file-roller = {
      enable = true;
    };
    tmux.enable = true;
  };

  environment.systemPackages = with pkgs; [
    git-crypt
    home-manager
    _7zz
    zotero
  ];

  # make GVFS happy
  services.samba-wsdd = {
    enable = true;
  };
}
