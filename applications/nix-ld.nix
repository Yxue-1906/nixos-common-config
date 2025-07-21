{ self, pkgs, ... }: {
  # enable executing unpatched applications
  # see: https://github.com/nix-community/nix-ld
  # see: https://github.com/thiagokokada/nix-alien?tab=readme-ov-file#usage
  # nixpkgs.overlays = [
  #   self.inputs.nix-alien.overlays.default
  # ];
  # environment.systemPackages = with pkgs; [
  #   nix-alien
  # ];
  programs.nix-ld.enable = true;
}
