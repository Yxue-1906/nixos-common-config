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
    sfd-nix.url = "git+https://forge.asnk.io/sugar/sfd-nix";
    nixos-shared-flakes.url = "github:Yxue-1906/nixos-shared-flake";
    nix-direnv = {
      url = "github:nix-community/nix-direnv/e6e7b3537c3c08650c5bfb3de480118ed62e5de5";
      inputs.nixpkgs.follows = "nixos-shared-flakes/nixpkgs";
    };
    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixos-shared-flakes/nixpkgs";
    };
    # nix-alien.url = "github:thiagokokada/nix-alien";
  };
  outputs =
    { self, nixos-shared-flakes, ... }@inputs:
    with nixos-shared-flakes.nixpkgs.lib;
    {
      build-host =
        {
          profile,
          secrets,
          extra-args ? { },
          ...
        }:
        {
          nixosConfigurations."unrelated" = nixosSystem rec {
            # now set system manually is work around, find if can use nixpkgs.hostPlatform
            system = "x86_64-linux";
            specialArgs = {
              inherit self secrets extra-args;
            };
            modules = [
              ./networking
              ./applications
              ./filesystem
              ./basic-config
              ./security
              profile
              inputs.sfd-nix.nixosModules.default
              inputs.nix-index-database.nixosModules.default
              ({ ... }: { nixpkgs.overlays = [ inputs.nix-direnv.overlays.default ]; })
            ];
          };
        };
    };
}
