{ ... }: {
  imports = [
    ./nix-ld.nix
    ./git.nix
    ./aria2.nix
    ./gnupg.nix
    # ./IDEs.nix
    ./editors.nix
    ./browsers.nix
    ./misc.nix
    ./nautilus
    # ./mutter
    # File Roller's issue should have been fixed in https://gitlab.gnome.org/GNOME/file-roller/-/commit/5aaa8c8227d820b3490e9ea406031d5dd5eddce5
    # ./file-roller
  ];

  # suggest command when not found
  programs.command-not-found.enable = true;

  # Allow Unfree
  nixpkgs.config.allowUnfree = true;
  
  # Enable local Nginx
  services.nginx.enable = true;
}
