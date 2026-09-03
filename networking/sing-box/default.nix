{ pkgs, ... }: {
  imports = [
    # ./sing-box.nix
  ];

  programs.sing-box-for-desktop.enable = true;

  services.nginx.virtualHosts.localhost = {
    locations."/sing-box/" = {
      alias = "${pkgs.metacubexd}/";
      index = "index.html";
    };
  };
}
