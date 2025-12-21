{ pkgs, lib, ... }: {

  # Disable ssh-agent
  programs.ssh.startAgent = false;
  security.pam.sshAgentAuth.enable = false;
  # disable ssh-agent from gnome-keyring
  # - starting from 25.11
  # see: https://github.com/NixOS/nixpkgs/pull/379731
  services.gnome.gcr-ssh-agent.enable = false;

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
