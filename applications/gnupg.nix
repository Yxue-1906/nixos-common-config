{ pkgs, lib, ... }: {

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
	  mesonFlags = final.lib.lists.remove "-Dssh-agent=true" prevAttrs.mesonFlags;
	}
      );
    })
  ];

  services.pcscd.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };
  # Disable ccid
  environment.etc."gnupg/scdaemon.conf".text = lib.generators.toKeyValue {
    mkKeyValue = (key: value: if lib.isString value then "${key} ${value}" else lib.optionalString value key);
    listsAsDuplicateKeys = true;
  } {
    disable-ccid = true;
  };
}
