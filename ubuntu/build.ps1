param(
    [string] $Type,
    [string] $Image
)

switch ($Type) {
    iso {
        & packer build `
            -force `
            -var "vsphere_username=$env:VSPHERE_USER" `
            -var "vsphere_password=$env:VSPHERE_PASS" `
            -var "admin_password=$env:ADMIN_PASS" `
            -var-file "$Image/config.pkrvars.hcl" `
            iso.pkr.hcl
    }
    clone {
        & packer build `
            -force `
            -var "vsphere_username=$env:VSPHERE_USER" `
            -var "vsphere_password=$env:VSPHERE_PASS" `
            -var "admin_password=$env:ADMIN_PASS" `
            -var-file "$Image/config.pkrvars.hcl" `
            clone.pkr.hcl
    }
}