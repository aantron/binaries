echo "Camlp4: checking for compatible OCaml version"
& $bash "-lc", "ocaml -version | grep $version"
CheckExitCode "OCaml version check"

Install-Package

echo "Checking $package..."
& $bash "-lc", "camlp4o -version | grep $version"
CheckExitCode "sanity check"
