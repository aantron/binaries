#! /bin/bash

set -e
set -x

echo "Camlp4 for OCaml 4.01 should be included in the OCaml distribution"
ocaml -version || ( echo "Please install OCaml 4.01" 1>&2 ; exit 1 )

camlp4 -version | grep '4\.01'
