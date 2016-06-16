#! /bin/bash

set -e
set -x

wget https://s3-us-west-2.amazonaws.com/ocaml-binaries/c64689d77d61deabd4a6a1127cb0c773cd102f45/ocaml-4.02.3.pkg
sudo installer -pkg ocaml-4.02.3.pkg -target /

ocaml -version | grep '4\.02'
