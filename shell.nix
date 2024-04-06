{ pkgs ? import (fetchTarball
  "https://github.com/NixOS/nixpkgs/archive/d60c18c5d952bee043cc0aa1d0d1144bdee9e695.tar.gz")
  { } }:

pkgs.mkShell {
  buildInputs = [
    pkgs.erlang_26
    pkgs.gleam
  ];
}
