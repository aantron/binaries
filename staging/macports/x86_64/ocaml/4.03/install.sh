#! /bin/bash

set -e
set -x

wget https://s3-us-west-2.amazonaws.com/ocaml-binaries/07d4aa3a0afc331387785fc785c53c0e0f8de1d1/ocaml-4.03.0.pkg
sudo installer -pkg ocaml-4.03.0.pkg -target /

ocaml -version | grep '4\.03'
