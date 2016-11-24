set -e
set -x

# Install Ocamlbuild.
wget https://github.com/ocaml/ocamlbuild/archive/0.9.3.tar.gz
tar xvf 0.9.3.tar.gz
make -C ocamlbuild-0.9.3 configure all install

# Download and build Camlp4, and package the source and binaries for Cygwin.
cygport ocaml-camlp4.cygport download prep compile install package

# Generate a small Cygwin release tree, including the package.
mkdir -p packages/mirror/$ARCH/release
mv ocaml-camlp4-99-1.*/dist/ocaml-camlp4 packages/mirror/$ARCH/release/

# Generate setup.ini using genini.
wget -O genini "https://cygwin.com/git/?p=cygwin-apps/genini.git;a=blob_plain;f=genini;hb=HEAD"
cd packages/mirror

# cygport now appears to name setup.hint after the package name, but genini
# still expects setup.hint.
mv $ARCH/release/ocaml-camlp4/ocaml-camlp4-99-1.hint $ARCH/release/ocaml-camlp4/setup.hint

perl ../../genini --recursive $ARCH > $ARCH/setup.ini

# Make sure setup.ini has the ocaml-camlp4 package.
grep '^@ ocaml-camlp4' $ARCH/setup.ini
