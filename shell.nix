{pkgs}:
#let
#  defaultPackage = callPackage ./default.nix { };
#in
pkgs.mkShellNoCC {
  #inputsFrom = [ defaultPackage ];
  #
  env = {
    RUST_SRC_PATH = pkgs.rustPlatform.rustLibSrc;
  };

  packages = with pkgs; [
    bun

    gleam
    beam28Packages.erlang
    beam28Packages.rebar3

    elixir

    rustc
    cargo
    clippy
    rustfmt
    rust-analyzer
    gcc

    hyperfine
    fish
  ];
}
