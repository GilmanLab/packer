param(
    [string] $Type,
    [string] $Username,
    [string] $Password,
    [string] $Image
)

switch ($Type) {
    iso {
        & packer build `
            -force `
            -var "vsphere_username=$Username" `
            -var "vsphere_password=$Password" `
            -var-file "$Image/config.pkrvars.hcl" `
            iso.pkr.hcl
    }
    clone {
        & packer build `
            -force `
            -var "vsphere_username=$Username" `
            -var "vsphere_password=$Password" `
            -var-file "$Image/config.pkrvars.hcl" `
            clone.pkr.hcl
    }
}