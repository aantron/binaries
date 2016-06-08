# Error handling.
$ErrorActionPreference = "Stop"

function CheckExitCode {
    if ($LastExitCode -ne 0) {
        throw "$args exited with $LastExitCode"
    }
}

# Cygwin shell.
if ($env:ARCH -eq "x86") {
    $bash = "C:\Cygwin\bin\bash"
}
else {
    $bash = "C:\Cygwin64\bin\bash"
}

# Install OCaml, OPAM, and try to build ocamlfind with them.

function Install {
    $package = $args[0]
    $version = $args[1]
    $script = ".\_build\cygwin\$env:ARCH\$package\$version\install.ps1"
    & $script
    CheckExitCode "install.ps1"
}

Install "ocaml" $env:COMPILER

# No OPAM for Cygwin64 yet.
if ($env:ARCH -ne "x86_64") {
    Install "opam" "1.2.2"

    $ErrorActionPreference = "Continue"

    echo "opam init -y"
    & $bash "-lc", "opam init -y"
    echo "opam install -y ocamlfind"
    & $bash "-lc", "opam install -y ocamlfind"
    CheckExitCode "OPAM test"
}
