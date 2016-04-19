with (import <nixpkgs> {}).pkgs;
let ros = (import ./default.nix).indigo.perception;
in stdenv.mkDerivation {
  name = "ros-indigo-perception-shell";
  buildInputs = [ ros ];
  shellHook = "source ${ros}/setup.bash";
}
