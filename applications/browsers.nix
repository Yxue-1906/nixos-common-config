{ pkgs, ... }: {
  programs = {
    firefox.enable = true;
  };

  environment.gnome.excludePackages = with pkgs; [
    epiphany
  ];
}
