<#
.SYNOPSIS
    Builds the specified Packer image
.DESCRIPTION
   Using the given type and image name, runs the Packer build process. The final
   call is similar to:
       packer build <args> -var-file $Image/config.pkrvars.hcl $Type.pkr.hcl
.PARAMETER Type
    The type of build to run: iso or clone
.PARAMETER Image
    The name of the image to build. Should match the directory name.
.PARAMETER Variables
    Additional variables to pass to the Packer configuration
.PARAMETER PackerPath
    Path to the packer binary; defaults to 'packer'
.PARAMETER OnError
    What action to take on an error; defaults to 'cleanup'
.EXAMPLE
    .\build.ps1 -Type clone -Image ubagent
.OUTPUTS
    None
#>
[cmdletbinding()]
param(
    [string] $Type,
    [string] $Image,
    [hashtable] $Variables = @{},
    [string] $PackerPath = 'packer',
    [string] $OnError = 'cleanup'
)

$ErrorActionPreference = 'Stop'
$varFile = Join-Path $PSScriptRoot ('{0}/config.pkrvars.hcl' -f $Image)
$configFile = Join-Path $PSScriptRoot ('{0}.pkr.hcl' -f $Type)

# Validate file locations
if (!(Test-Path $varFile)) {
    throw 'Cannot find variable file at {0}' -f $varFile
}
elseif (!(Test-Path $configFile)) {
    throw 'Cannot find config file at {0}' -f $configFile
}

# Collect Packer variables
$packerVariables = @{
    vsphere_username = $env:VCENTER_USER
    vsphere_password = $env:VCENTER_PASS
    admin_password   = $env:ADMIN_PASS
}
$packerVariables += $Variables

# Build Packer arguments
$packerArgs = [System.Collections.ArrayList]@(
    'build',
    '--force',
    ('-on-error={0}' -f $OnError),
    ('-var-file "{0}"' -f $varFile)
)

# Add variables to arguments
foreach ($var in $packerVariables.GetEnumerator()) {
    $packerArgs.Add(('-var {0}="{1}"' -f $var.Name, $var.Value)) | Out-Null
}

# Run Packer
$packerArgs.Add($configFile) | Out-Null
$exitCode = Start-Process $PackerPath -ArgumentList $packerArgs -NoNewWindow -Wait
if ($exitCode -ne 0) {
    Write-Host '##vso[task.complete result=Failed;]Failed'
}
else {
    Write-Host '##vso[task.complete result=Succeeded;]Done'
}