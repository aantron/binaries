# Error handling.
$ErrorActionPreference = "Stop"

function CheckExitCode_ {
    if ($LastExitCode -ne 0) {
        throw "$args exited with $LastExitCode"
    }
}

# Cygwin shell.
$private:bash = "C:\Cygwin\bin\bash"

function Install($package, $version) {
    $private:script =
        ".\_build\$env:SYSTEM\$env:ARCH\$package\$version\install.ps1"
    . $script
    CheckExitCode_ "$script"
}

Install "ocaml" $env:COMPILER

Install "opam" "1.2"

# Install "camlp4" "4.03"

& $bash "-lc" 'opam init -y --auto-setup'
& $bash "-lc" 'opam install -y ocamlfind'
