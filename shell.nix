{pkgs}:
#let
#  defaultPackage = callPackage ./default.nix { };
#in
pkgs.mkShellNoCC {
  #inputsFrom = [ defaultPackage ];

  packages = with pkgs; [
    bun

    gleam
    beam28Packages.erlang
    beam28Packages.rebar3
  ];
}
