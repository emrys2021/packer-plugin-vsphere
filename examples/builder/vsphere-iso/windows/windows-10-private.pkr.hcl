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
  ## 定义前提条件
  // vcenter_server = "vcenter.example.com"
  vcenter_server = "10.15.17.123" # 指定vcenter server地址及凭据
  // username       = "root"
  username = "administrator@vsphere.local"
  // password = "jetbrains"
  password = "Qwerty123$"
  insecure_connection = "true"  # 允许不安全的连接，不验证vcenter server的证书
  
  datacenter = "DC01" # 指定datacenter, vcenter server上不止一个datacenter时必须要指定
  folder = "/Templates/Windows"  # 理论上是指定虚拟机的保存目录，虚拟机转换成虚拟机模板后和虚拟机一个目录，所以也可以理解为虚拟机模板的保存目录，此目录是相对于datacenter根目录的相对路径
  // host                 = "esxi-01.example.com"
  host                = "10.15.17.13" # 指定datacenter下哪个esxi节点
  datastore           = "datastore3-2" # 指定哪个数据存储

  // floppy_img_path      = "[datastore1] ISO/VMware Tools/10.2.0/pvscsi-Windows8.flp"
  // floppy_img_path = "[datastore3-2] iso/pvscsi-Windows8.flp"
  floppy_files         = ["${path.root}/setup/"]  # 指定自定义的目录，将目录内的文件拷贝到虚拟软盘供构建时使用，${path.root}表示packer配置文件所在目录
  // iso_paths            = ["[datastore1] ISO/en_windows_10_multi-edition_vl_version_1709_updated_dec_2017_x64_dvd_100406172.iso", "[datastore1] ISO/VMware Tools/10.2.0/windows.iso"]
  iso_paths = ["[datastore3-2] iso/Windows10_21H2.iso", "[datastore3-2] iso/vmtools_10.2.1.iso"]  # 指定要加载的iso文件及其路径，iso按顺序加载，按顺序分配盘符，比如本示例只有一个系统盘分配盘符C:，第一个iso分配盘符D:，第二个iso分配盘符E:

  ## 定义虚拟机配置和规格
  vm_name        = "example-windows"
  guest_os_type = "windows9_64Guest"

  CPUs            = 1
  RAM             = 4096
  RAM_reserve_all = true
  // disk_controller_type = ["pvscsi"]
  disk_controller_type = ["lsilogic-sas"]
  storage {
    disk_size             = 32768
    disk_thin_provisioned = true
  }
  network_adapters {
    network      = "DPortGroup" # 指定虚拟机网卡连接到哪个虚拟网络
    network_card = "vmxnet3"
  }

  ## 虚拟机操作系统安装完成后，使用communicator进行连接配置
  // communicator = "none" # 可以设置不连接
  communicator         = "winrm"
  winrm_password = "jetbrains"
  winrm_username = "jetbrains"

  ## 虚拟机构建阶段需要等待的一些时间点，将超时时间设置长点，防止系统安装过程读写比较慢导致超时
  ip_wait_timeout = "120m"  # Waiting for ip... 设置等待获取到ip超时时间
  ip_wait_address = "0.0.0.0/0"  # 表示等待任何 IPv4 地址
  winrm_timeout = "30m" # Waiting for WinRM to become available...
  shutdown_timeout = "600m" # please shutdown virtual machine within... 设置等待关机超时时间，这个是因为之前设置communicator="none"后，导致packer不会自动发送shutdown命令，虚拟机不关机导致的，现在可以自动关机，应该可以不用再设置此超时时间

  ## 虚拟机构建完成后，转换成模板，保存在清单中，和folder指定的虚拟机保存目录一个目录
  convert_to_template = true

  ## 后续...
  # 不将虚拟机转换成模板，测试创建内容库，将构建后的虚拟机导入内容库
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
