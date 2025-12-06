{ self, pkgs, config, lib, secrets, ...}: {

  networking.firewall = {
    trustedInterfaces = [ "singbox_tun" ];
    checkReversePath = "loose";
  };

  systemd.services.sing-box = {
    overrideStrategy = "asDropin";
    # TODO: use CREDIENTIAL to secure token and config url
    serviceConfig = {
      User = lib.mkForce "";
      Group = lib.mkForce "";
      ExecStartPre = with pkgs; 
        let
          python-with-package = lib.getExe (python3.withPackages (pypkgs: with pypkgs; [requests]));
	  script = pkgs.writeShellScript "sing-box-pre-start" ''
            ${python-with-package} ${./sing-box-prestart.py} \
              --token ${secrets.sing-box.github-token} \
              --configuration_url "${secrets.sing-box.configuration-url}" \
              --save_to "/etc/sing-box/config.json"
          '';
        in
          lib.mkForce "${script}";
      ExecStart = lib.mkForce [];
    };
    requires = [ "network.target" "nss-lookup.target" "network-online.target" ];
  };

  services.sing-box = 
    let
      sing-box-pkgs = (import self.inputs.nixpkgs-sing-box { inherit (pkgs) system config; });
    in
    {
      enable = true;
      package = sing-box-pkgs.sing-box;
    };

  services.nginx.virtualHosts.localhost = {
    locations."/sing-box/" = {
      alias = "${pkgs.metacubexd}/";
      index = "index.html";
    };
  };
} 
