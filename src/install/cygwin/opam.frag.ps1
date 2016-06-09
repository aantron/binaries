Install-Package

echo "Checking $package..."

& $bash "-lc", "opam --version | grep $version"
CheckExitCode "sanity check"
