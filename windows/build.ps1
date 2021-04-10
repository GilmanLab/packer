param(
    [string] $Username,
    [string] $Password,
    [string] $Image
)

& packer build `
    -force `
    -var "vsphere_username=$Username" `
    -var "vsphere_password=$Password" `
    -var-file "$Image/config.pkrvars.hcl" `
    iso.pkr.hcl