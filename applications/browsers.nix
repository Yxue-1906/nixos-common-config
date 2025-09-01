{ pkgs, ... }: {
  environment.gnome.excludePackages = with pkgs; [
    epiphany
  ];
}
