variable "vsphere_username" {
    type = string
}

variable "vsphere_password" {
    type = string
    sensitive = true
}

variable "vsphere_server" {
    type = object({
        address = string
        insecure = bool
    })
}

variable "vsphere_vcenter" {
    type = object({
        datacenter = string
        cluster = string
        datastore = string
    })
}

variable "vsphere_vm" {
    type = object({
        name = string
        template = string
        cpus = number
        memory = number
        disks = list(object({
            size = number
            thin = bool
        }))
        network = string
    })
}

variable "vsphere_media" {
    type = object({
        floppy_files = list(string)
        sysprep = string
    })
}

variable "winrm" {
    type = object({
        username = string
        password = string
    })
    sensitive = true
}

source "vsphere-clone" "agent_base" {
  vcenter_server      = var.vsphere_server.address
  username            = var.vsphere_username
  password            = var.vsphere_password
  insecure_connection = var.vsphere_server.insecure

  datacenter = var.vsphere_vcenter.datacenter
  cluster    = var.vsphere_vcenter.cluster
  datastore  = var.vsphere_vcenter.datastore

  floppy_files = var.vsphere_media.floppy_files

  communicator   = "winrm"
  winrm_username = var.winrm.username
  winrm_password = var.winrm.password

  vm_name = var.vsphere_vm.name
  template = var.vsphere_vm.template
  network = var.vsphere_vm.network
  CPUs    = var.vsphere_vm.cpus
  RAM     = var.vsphere_vm.memory

  customize {
      windows_sysprep_file = var.vsphere_media.sysprep
      network_interface {

      }
  }

  disk_controller_type = ["lsilogic-sas"]
  dynamic "storage" {
      for_each = var.vsphere_vm.disks
      content {
          disk_size = storage.value.size
          disk_thin_provisioned = storage.value.thin
      }
  }
}

build {
  sources = ["source.vsphere-clone.agent_base"]
}