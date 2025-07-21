{ pkgs, ... }: {
  # fix GH-42
  # see: https://nixos.wiki/wiki/Man_pages
  environment.systemPackages = with pkgs; [
    man-pages
    man-pages-posix
  ];

  documentation = {
    enable = true;
    dev.enable = true;
  };

}
