# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

# source blocks are generated from your builders; a source can be referenced in
# build blocks. A build block runs provisioner and post-processors on a
# source. Read the documentation for source blocks here:
# https://www.packer.io/docs/templates/hcl_templates/blocks/source
// packer {
//   required_version = ">= 1.7.0"
//   required_plugins {
//     vsphere = {
//       version = ">= 1.4.0"
//       source  = "github.com/hashicorp/vsphere"
//     }
//   }
// }

source "vsphere-iso" "example_windows" {
  CPUs            = 1
  RAM             = 4096
  RAM_reserve_all = true
  communicator         = "winrm"
  // communicator = "none"
  // disk_controller_type = ["pvscsi"]
  disk_controller_type = ["lsilogic-sas"]
  floppy_files         = ["${path.root}/setup/"]
  // floppy_img_path      = "[datastore1] ISO/VMware Tools/10.2.0/pvscsi-Windows8.flp"
  // floppy_img_path = "[datastore3-2] iso/pvscsi-Windows8.flp"
  guest_os_type = "windows9_64Guest"
  // host                 = "esxi-01.example.com"
  host                = "10.15.17.13"
  datastore           = "datastore3-2" #? 显式指定数据存储
  insecure_connection = "true"
  // iso_paths            = ["[datastore1] ISO/en_windows_10_multi-edition_vl_version_1709_updated_dec_2017_x64_dvd_100406172.iso", "[datastore1] ISO/VMware Tools/10.2.0/windows.iso"]
  iso_paths = ["[datastore3-2] iso/Windows10_21H2.iso", "[datastore3-2] iso/vmtools_10.2.1.iso"]
  network_adapters {
    network      = "DPortGroup" # 在这里指定网络名称，替换为你环境中的具体网络名称
    network_card = "vmxnet3"
  }
  // password = "jetbrains"
  password = "Qwerty123$"
  storage {
    disk_size             = 32768
    disk_thin_provisioned = true
  }
  // username       = "root"
  username = "administrator@vsphere.local"
  // vcenter_server = "vcenter.example.com"
  vcenter_server = "10.15.17.123"
  vm_name        = "example-windows"
  winrm_password = "jetbrains"
  winrm_username = "jetbrains"

  ip_wait_timeout = "120m"  # waiting for ip... 设置等待获取到ip超时时间
  ip_wait_address = "0.0.0.0/0"  # 表示等待任何 IPv4 地址
  winrm_timeout = "30m"
  shutdown_timeout = "600m" # please shutdown virtual machine within... 设置等待关机超时时间
}

# a build block invokes sources and runs provisioning steps on them. The
# documentation for build blocks can be found here:
# https://www.packer.io/docs/templates/hcl_templates/blocks/build
build {
  sources = ["source.vsphere-iso.example_windows"]

  provisioner "windows-shell" {
    inline = ["dir c:\\"]
  }
}
