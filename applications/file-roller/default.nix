{ pkgs, lib, ... }: {
  environment.systemPackages = with pkgs; [
    # provide rar support
    rar
  ];
  nixpkgs.overlays = [
    (final: prev: {
      file-roller = prev.file-roller.overrideAttrs (finalAttrs: prevAttrs: {
        mesonFlags = [
	  # disable libarchive
	  (lib.mesonEnable "libarchive" false)
	];
        patches = (prevAttrs.patches or []) ++ [
	  ./restore-extract-button-behavior.patch
	  # original implement cant read filename correctly if size to long
	  # ./fix-read-name-incorrectly-when-size-too-long.patch
	];
      });
    })
  ];
}
