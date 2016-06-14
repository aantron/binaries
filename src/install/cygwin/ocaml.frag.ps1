Run-CygwinSetup -P flexdll
Run-Bash "flexlink -help | grep `"version 0\\.34`""

Install-Package

Run-Bash "ocaml -version | grep $version"
