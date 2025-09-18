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
    nixpkgs-sing-box.url = "github:NixOS/nixpkgs/0ae51d2e8e7fbb16046111569a5b0378aa85a129";
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
