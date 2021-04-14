param(
    [string] $Type,
    [string] $Image
)

switch ($Type) {
    iso {
        & packer build `
            -force `
            -var "vsphere_username=$env:VCENTER_USER" `
            -var "vsphere_password=$env:VCENTER_PASS" `
            -var "admin_password=$env:ADMIN_PASS" `
            -var-file "$Image/config.pkrvars.hcl" `
            iso.pkr.hcl
    }
    clone {
        & packer build `
            -force `
            -var "vsphere_username=$env:VCENTER_USER" `
            -var "vsphere_password=$env:VCENTER_PASS" `
            -var "admin_password=$env:ADMIN_PASS" `
            -var-file "$Image/config.pkrvars.hcl" `
            clone.pkr.hcl
    }
}

if ($lastExitCode -ne 0) {
    Write-Host '##vso[task.complete result=Failed;]Failed'
}
else {
    Write-Host '##vso[task.complete result=Succeeded;]Done'
}