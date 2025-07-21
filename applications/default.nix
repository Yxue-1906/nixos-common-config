{ ... }: {
  imports = [
    ./nix-ld.nix
    ./git.nix
    ./aria2.nix
    ./IDEs.nix
    ./editors.nix
    ./browsers.nix
    ./misc.nix
    ./nautilus
    # ./mutter
    ./file-roller
  ];


  # Allow Unfree
  nixpkgs.config.allowUnfree = true;
  
  # Enable local Nginx
  services.nginx.enable = true;
}
