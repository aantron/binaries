# Error handling.
$ErrorActionPreference = "Stop"

function CheckExitCode_ {
    if ($LastExitCode -ne 0) {
        throw "$args exited with $LastExitCode"
    }
}

# Cygwin shell.
$private:bash = "C:\Cygwin64\bin\bash"

function Install($package, $version) {
    $private:script =
        ".\_build\$env:SYSTEM\$env:ARCH\$package\$version\install.ps1"
    . $script
    CheckExitCode_ "$script"
}

Install "ocaml" $env:COMPILER

Install "opam" "1.2"

# Install "camlp4" "4.03"

echo "PATH:"
& $bash "-lc" "echo `$PATH"
echo "LIB:"
& $bash "-lc" "echo `$LIB"
echo "LIBPATH:"
& $bash "-lc" "echo `$LIBPATH"

& $bash "-lc" 'opam install -y ocamlfind --verbose'
