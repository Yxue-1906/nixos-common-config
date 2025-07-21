{ ... }: {
  nix = {
    settings = {
      # Enable flakes
      experimental-features = [ "nix-command" "flakes" ];

      # Grabage collect settings
      auto-optimise-store = true;

      # Use tsinghua binary cache mirror
      substituters = [
        "https://mirrors.tuna.tsinghua.edu.cn/nix-channels/store"
	"https://cache.nixos.org"
      ];
    };
    # collect garbage everyday
    gc = {
      automatic = true;
      dates = "daily";
      options = "--delete-older-than 7d";
    };
  };
}
