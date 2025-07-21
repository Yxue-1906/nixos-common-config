{ pkgs, ... }: {
  nixpkgs.overlays = [
    (final: prev: {
      nautilus = prev.nautilus.overrideAttrs (finalAttrs: prevAttrs: {
        patches = prevAttrs.patches ++ [
          (
            let 
              ubuntu-nautilus-source = pkgs.fetchgit {
                url = "https://git.launchpad.net/ubuntu/+source/nautilus";
                sparseCheckout = [
                  "debian/patches/ubuntu"
        	];
        	rev = "48f1cec8fcbcadadd49f1edc9d54eeb3b5515ed5";
        	hash = "sha256-IbCliKEFIeDXxsxXgISn5OxrfF0FBA/tOeKhnFHgBAM=";
              };
            in
              "${ubuntu-nautilus-source}/debian/patches/ubuntu/ubuntu_backspace_behaviour.patch"
          )
        ];
      });
    })
  ];
}
