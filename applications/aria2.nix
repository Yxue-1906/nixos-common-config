{ pkgs, ... }: {
  nixpkgs.overlays = [
    (final: prev: {
      # disable bittorrent and metalink
      aria2 = prev.aria2.overrideAttrs (old: {
        configureFlags = (old.configureFlags or []) ++ [
	  "--disable-bittorrent"
	  "--disable-metalink"
	];
      });
    })
  ];
  # Enable local ariang server
  services.nginx.virtualHosts.localhost = {
    locations."/ariang/" = {
      alias = "${pkgs.ariang}/share/ariang/";
      index = "index.html";
    };
  };
}
