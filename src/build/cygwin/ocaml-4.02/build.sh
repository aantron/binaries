set -e

# Download and build OCaml, and package the source and binaries for Cygwin. The
# .cygport file also applies any needed patches.
cygport ocaml.cygport download prep compile install package

# Generate a small Cygwin release tree, including the package.
mkdir -p packages/mirror/$ARCH/release
mv ocaml-99-1.*/dist/ocaml packages/mirror/$ARCH/release/
wget -O genini "https://cygwin.com/git/?p=cygwin-apps/genini.git;a=blob_plain;f=genini;hb=HEAD"
cd packages/mirror
perl ../../genini --recursive $ARCH > $ARCH/setup.ini
