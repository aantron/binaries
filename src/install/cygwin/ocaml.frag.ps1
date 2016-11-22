if ($arch -eq "x86") {
    $flexdll_archive = "https://ci.appveyor.com/api/buildjobs/c3doinoqjyl0twgp/artifacts/packages-flexdll.zip"
}
else {
    $flexdll_archive = "https://ci.appveyor.com/api/buildjobs/40iew40mqnygd3gh/artifacts/packages-flexdll.zip"
}

Install-Package "flexdll" $flexdll_archive
Run-Bash "flexlink -help | grep `"version 0\\.35`""

Install-Package
Run-Bash "ocaml -version | grep $version"
