{ ... }: {
  imports = [
    ./yubikey.nix
  ];

  security.sudo.wheelNeedsPassword = false;
}
