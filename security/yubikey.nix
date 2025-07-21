{ pkgs, config, lib, ... }: {

  # Disable ssh-agent
  programs.ssh.startAgent = false;
  security.pam.sshAgentAuth.enable = false;
  nixpkgs.overlays = [
    # https://github.com/NixOS/nixpkgs/blob/nixos-24.11/pkgs/by-name/gn/gnome-keyring/package.nix
    # To disable SSH_AUTH_SOCK by gnome-keyring.
    #
    # And it should be override the package it self, the module is not configurable for the package. https://github.com/NixOS/nixpkgs/blob/nixos-24.11/nixos/modules/services/desktops/gnome/gnome-keyring.nix
    (final: prev: {
      gnome-keyring = prev.gnome-keyring.overrideAttrs (
        finalAttrs: prevAttrs: {
	  configureFlags = final.lib.lists.remove "--enable-ssh-agent" prevAttrs.configureFlags;
	}
      );
    })
  ];

  # Enable hardware key support
  services.udev.packages = [ pkgs.yubikey-personalization ];
  services.pcscd.enable = true;

  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  # Allow login/sudo by yubikey (via u2f method)
  security.pam.services = {
    login.u2fAuth = true;
    sudo.u2fAuth = true;
  };
}
