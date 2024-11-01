# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

# source blocks are analogous to the "builders" in json templates. They are used
# in build blocks. A build block runs provisioners and post-processors on a
# source. Read the documentation for source blocks here:
# https://www.packer.io/docs/templates/hcl_templates/blocks/source
source "vsphere-iso" "example" {
  vcenter_server = "10.15.17.123"
  username       = "administrator@vsphere.local"
  password     = "Qwerty123$"
  insecure_connection  = true

  host                 = "10.15.17.13"
  datastore           = "datastore3-2" # 指定哪个数据存储

  floppy_files         = ["${path.root}/preseed.cfg"]
  // iso_paths            = ["[datastore3-2] ISO/ubuntu-16.04.7-desktop-amd64.iso"]
  iso_paths            = ["[datastore3-2] ISO/ubuntu-16.04.7-server-amd64.iso"]

  vm_name        = "example-ubuntu"
  guest_os_type        = "ubuntu64Guest"

  boot_command = [
    // This waits for 3 seconds, sends the "c" key, and then waits for another 3 seconds. In the GRUB boot loader, this is used to enter command line mode.
    "<wait3s>c<wait3s>",
    // This types a command to load the Linux kernel from the specified path with the 'autoinstall' option and the value of the 'data_source_command' local variable.
    // The 'autoinstall' option is used to automate the installation process.
    // The 'data_source_command' local variable is used to specify the kickstart data source configured in the common variables.
    "linux /casper/vmlinuz --- autoinstall ds=\"nocloud\"",
    // This sends the "enter" key and then waits. This is typically used to execute the command and give the system time to process it.
    "<enter><wait>",
    // This types a command to load the initial RAM disk from the specified path.
    "initrd /casper/initrd",
    // This sends the "enter" key and then waits. This is typically used to execute the command and give the system time to process it.
    "<enter><wait>",
    // This types the "boot" command. This starts the boot process using the loaded kernel and initial RAM disk.
    "boot",
    // This sends the "enter" key. This is typically used to execute the command.
    "<enter>"
  ]

  CPUs                 = 2
  RAM                  = 1024
  RAM_reserve_all      = true
  disk_controller_type = ["pvscsi"]
  // disk_controller_type = ["lsilogic-sas"]
  network_adapters {
    network      = "DPortGroup" # 指定虚拟机网卡连接到哪个虚拟网络
    network_card = "vmxnet3"
  }
  storage {
    disk_size             = 32768
    disk_thin_provisioned = true
  }

  ssh_password = "jetbrains"
  ssh_username = "jetbrains"
}

# a build block invokes sources and runs provisioning steps on them. The
# documentation for build blocks can be found here:
# https://www.packer.io/docs/templates/hcl_templates/blocks/build
build {
  sources = ["source.vsphere-iso.example"]

  provisioner "shell" {
    inline = ["ls /"]
  }
}
