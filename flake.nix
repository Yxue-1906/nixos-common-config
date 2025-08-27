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
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    nixpkgs-sing-box.url = "github:NixOS/nixpkgs/d416416015943eb0b191fbe37b3e7e4046f5cc60";
    # nix-alien.url = "github:thiagokokada/nix-alien";
  };
  outputs = { self, nixpkgs, ... }@inputs: with nixpkgs.lib; {
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
