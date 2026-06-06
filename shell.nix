with import <nixpkgs> { };
mkShell rec {
  packages = [
    python3
    nixfmt
  ];
}
