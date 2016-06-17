#! /bin/bash

set -e
set -x

wget https://s3-us-west-2.amazonaws.com/ocaml-binaries/67d992e78d0235967e76074d8698901056eddf53/ocaml-camlp4-4.03-1.pkg
sudo installer -pkg ocaml-camlp4-4.03-1.pkg -target /

camlp4 -version | grep '4\.03'
