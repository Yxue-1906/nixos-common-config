{ pkgs, ... }: {
  # Enable local ariang server
  services.nginx.virtualHosts.localhost = {
    locations."/ariang/" = {
      alias = "${pkgs.ariang}/share/ariang/";
      index = "index.html";
    };
  };
}
