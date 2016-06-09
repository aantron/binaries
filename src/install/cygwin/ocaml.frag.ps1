echo "Installing flexdll..."
Start-Process $setup @("-W", "-q", "-P", "flexdll") -Wait

Install-Package

echo "Checking $package..."

& $bash "-lc", "ocaml -version | grep $version"
CheckExitCode "sanity check"
