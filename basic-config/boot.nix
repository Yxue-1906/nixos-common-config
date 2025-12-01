{ pkgs, ... }: {

  boot.kernelPackages = pkgs.linuxPackages_6_6;
  
  # Use the systemd boot loader.
  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };
}
