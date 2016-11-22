# Settle on a package name.
if (-not (Test-Path variable:script:package)) {
    $package = $inferred_package
}

# Package installation.
function Install-Package($package_override, $archive_override) {
    if ($package_override -eq $null) {
        $package_name = $package
    }
    else {
        $package_name = $package_override
    }

    if ($archive_override -eq $null) {
        $remote_archive = $archive
    }
    else {
        $remote_archive = $archive_override
    }

    $archive_name = "$working_directory\packages-$package_name.zip"
    $packages_path = "$working_directory\packages-$package_name"

    Run "Invoke-WebRequest '$remote_archive' -OutFile '$archive_name'"
    Run "Expand-Archive '$archive_name' '$packages_path'"

    Run-CygwinSetup -L -l $packages_path -P $package_name
}
