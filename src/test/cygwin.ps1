# Error handling.
$ErrorActionPreference = "Stop"

function CheckExitCode_ {
    if ($LastExitCode -ne 0) {
        throw "$args exited with $LastExitCode"
    }
}

# Cygwin shell.
if ($env:ARCH -eq "x86") {
    $private:bash = "C:\Cygwin\bin\bash"
}
else {
    $private:bash = "C:\Cygwin64\bin\bash"
}

# Install OCaml, OPAM, and try to build ocamlfind with them.

function Install($package, $version) {
    $private:script = ".\_build\cygwin\$env:ARCH\$package\$version\install.ps1"
    cat $script | PowerShell -Command -
    CheckExitCode_ "$script"
}

Install "ocaml" $env:COMPILER

# No OPAM for Cygwin64 yet.
if ($env:ARCH -ne "x86_64") {
    Install "opam" "1.2"

    echo "opam init -y --auto-setup"
    & $bash "-lc", "opam init -y --auto-setup"
    echo "opam install --verbose -y ocamlfind"
    & $bash "-lc", "opam install --verbose -y ocamlfind"
    CheckExitCode_ "OPAM test"

    Install "camlp4" $env:COMPILER

    & $bash "-lc", "opam install --verbose -y type_conv"
    CheckExitCode_ "OPAM+Camlp4 test"
}
