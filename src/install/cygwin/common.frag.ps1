# Settle on a package name.
if (-not (Test-Path variable:script:package)) {
    $package = $inferred_package
}

# Package installation.
function Install-Package {
    $archive_name = "$working_directory\packages-$package.zip"
    $packages_path = "$working_directory\packages-$package"

    Run "Invoke-WebRequest '$archive' -OutFile '$archive_name'"
    Run "Expand-Archive '$archive_name' '$packages_path'"

    Run-CygwinSetup -L -l $packages_path -P $package
}
