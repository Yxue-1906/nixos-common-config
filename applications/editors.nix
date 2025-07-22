{ pkgs, ... }: {
  # GH-14: Add clipboard support
  environment.systemPackages = [
    pkgs.xclip
  ];
  programs = {
    nano.enable = false;
    neovim = {
      enable = true;
      defaultEditor = true;
      vimAlias = true;
      viAlias = true;
    };
  };
}
