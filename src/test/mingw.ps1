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
    $private:script = ".\_build\mingw\$env:ARCH\$package\$version\install.ps1"
    cat $script | PowerShell -Command -
    CheckExitCode_ "$script"
}

Install "ocaml" $env:COMPILER

Install "opam" "1.2"

# Install "camlp4" "4.03"

echo "opam init -y --auto-setup"
& $bash "-lc", "opam init -y --auto-setup"
echo "opam install -y ocamlfind"
& $bash "-lc", "opam install -y ocamlfind"
CheckExitCode_ "OPAM test"

& $bash "-lc", "opam install -y type_conv"
CheckExitCode_ "OPAM+Camlp4 test"
