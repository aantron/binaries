echo "Camlp4: checking for compatible OCaml version"
& $bash "-lc", "ocaml -version | grep $version"
CheckExitCode "OCaml version check"

echo "Checking for Camlp4 distributed with OCaml"
& $bash "-lc", "camlp4o -version | grep $version"
CheckExitCode "Pre-installed Camlp4 check"
