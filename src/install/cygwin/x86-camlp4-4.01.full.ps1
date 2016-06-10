# Error handling.
$ErrorActionPreference = "Stop"

function CheckExitCode {
    if ($LastExitCode -ne 0) {
        throw "$args exited with $LastExitCode"
    }
}

# Cygwin.
$bash = "C:\Cygwin\bin\bash.exe"

echo "Camlp4: checking for compatible OCaml version"
& $bash "-lc", "ocaml -version | grep 4.01"
CheckExitCode "OCaml version check"

echo "Checking for Camlp4 distributed with OCaml"
& $bash "-lc", "camlp4o -version | grep 4.01"
CheckExitCode "Pre-installed Camlp4 check"
