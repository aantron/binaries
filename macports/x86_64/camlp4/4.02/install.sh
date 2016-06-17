#! /bin/bash

set -e
set -x

wget https://s3-us-west-2.amazonaws.com/ocaml-binaries/556c27247dbe2b14c9d3d0979eb2d0b9671e7e72/ocaml-camlp4-4.02-7.pkg
sudo installer -pkg ocaml-camlp4-4.02-7.pkg -target /

camlp4 -version | grep '4\.02'
