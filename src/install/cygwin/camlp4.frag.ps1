echo "Camlp4: checking for compatible OCaml version"
Run-Bash "ocaml -version | grep $version"

Install-Package
Run-Bash "camlp4o -version | grep $version"
