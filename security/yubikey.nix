{ pkgs, config, lib, ... }: {

  # Enable hardware key support
  services.udev.packages = [ pkgs.yubikey-personalization ];

  # Allow login/sudo by yubikey (via u2f method)
  security.pam.services = {
    login.u2fAuth = true;
    sudo.u2fAuth = true;
  };
}
