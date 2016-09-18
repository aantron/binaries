set -e

# Download and extract Camlp4.
wget https://github.com/ocaml/camlp4/archive/4.03+1.tar.gz
tar -xf 4.03+1.tar.gz
cd camlp4-4.03-1

# Build and install Camlp4.
./configure --bindir="C:/PROGRA~1/OCaml/bin"
make all
make install

cat config.sh
