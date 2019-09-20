let
  rev = "b5650cd1c50dff382b2995e569235ecc6a3eaa89";
  sha256 = "1hz2qrqzzfk41hhsiakailhl830a4q01xw9gr9ffql020qcq6ms0";
in
import (fetchTarball {
  inherit sha256;
  url = "https://github.com/flokli/nixpkgs/archive/${rev}.tar.gz";
})
