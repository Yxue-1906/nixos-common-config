{
  description = "Nanashi's flake.nix";
  nixConfig = {
    substituters = [ 
      "https://mirrors.sjtug.sjtu.edu.cn/nix-channels/store"
      "https://mirrors.tuna.tsinghua.edu.cn/nix-channels/store"
      "https://cache.nixos.org"
    ];
  };
  inputs = {
    nixos-shared-flakes.url = "github:Yxue-1906/nixos-shared-flake";
    nixpkgs-sing-box.url = "github:NixOS/nixpkgs/1a24b14b4fd3adfa79751a3445fb2e0e74eefaf1";
    # nix-alien.url = "github:thiagokokada/nix-alien";
  };
  outputs = { self, nixos-shared-flakes, ... }@inputs: with nixos-shared-flakes.nixpkgs.lib; {
    build-host = { profile, secrets, ... }: {
      nixosConfigurations."unrelated" = nixosSystem rec {
	# now set system manually is work around, find if can use nixpkgs.hostPlatform
	system = "x86_64-linux";
        specialArgs = {
	  inherit self secrets;
        };
        modules = [
          ./networking
          ./applications
	  ./filesystem
          ./basic-config
	  ./security
	  profile
        ];
      };
    };
  };
}
