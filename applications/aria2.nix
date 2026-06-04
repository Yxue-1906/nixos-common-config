{ self, pkgs, ... }: {
  # upstream has issue about ariang package, waiting for update
  # see: https://github.com/NixOS/nixpkgs/issues/523144
  nixpkgs.overlays = [
    (final: prev: let 
      old-pkgs = import self.inputs.nixos-25-11 {inherit (pkgs) system;};
    in
      { ariang = old-pkgs.ariang;}
    )
  ];
  # Enable local ariang server
  services.nginx.virtualHosts.localhost = {
    locations."/ariang/" = {
      alias = "${pkgs.ariang}/share/ariang/";
      index = "index.html";
    };
  };
}
