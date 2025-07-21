{ pkgs, config, lib, ...}: {
  environment.systemPackages = with pkgs.jetbrains; [
    clion
    pycharm-professional
    webstorm

  ];
}
