{ config, pkgs, ... }:

# ### Workstation ls groups
# 
# ### Group 0 ###
#     00:00.0 Host bridge [0600]: Intel Corporation 4th Gen Core
#     Processor DRAM Controller [8086:0c00] (rev 06)
# ### Group 1 ###
#     00:01.0 PCI bridge [0604]: Intel Corporation Xeon E3-1200 v3/4th
#     Gen Core Processor PCI Express x16 Controller [8086:0c01] (rev 06)
#     00:01.1 PCI bridge [0604]: Intel Corporation Xeon E3-1200 v3/4th
#     Gen Core Processor PCI Express x8 Controller [8086:0c05] (rev 06)
#     01:00.0 VGA compatible controller [0300]: NVIDIA Corporation GM204
#     [GeForce GTX 970] [10de:13c2] (rev a1)
#     01:00.1 Audio device [0403]: NVIDIA Corporation GM204 High
#     Definition Audio Controller [10de:0fbb] (rev a1)
# ### Group 2 ###
#     00:14.0 USB controller [0c03]: Intel Corporation 9 Series Chipset
#     Family USB xHCI Controller [8086:8cb1]
# ### Group 3 ###
#     00:16.0 Communication controller [0780]: Intel Corporation 9
#     Series Chipset Family ME Interface #1 [8086:8cba]
# ### Group 4 ###
#     00:19.0 Ethernet controller [0200]: Intel Corporation Ethernet
#     Connection (2) I218-V [8086:15a1]
# ### Group 5 ###
#     00:1a.0 USB controller [0c03]: Intel Corporation 9 Series Chipset
#     Family USB EHCI Controller #2 [8086:8cad]
# ### Group 6 ###
#     00:1b.0 Audio device [0403]: Intel Corporation 9 Series Chipset
#     Family HD Audio Controller [8086:8ca0]
# ### Group 7 ###
#     00:1c.0 PCI bridge [0604]: Intel Corporation 9 Series Chipset
#     Family PCI Express Root Port 1 [8086:8c90] (rev d0)
# ### Group 8 ###
#     00:1c.3 PCI bridge [0604]: Intel Corporation 9 Series Chipset
#     Family PCI Express Root Port 4 [8086:8c96] (rev d0)
# ### Group 9 ###
#     00:1c.4 PCI bridge [0604]: Intel Corporation 9 Series Chipset
#     Family PCI Express Root Port 5 [8086:8c98] (rev d0)
# ### Group 10 ###
#     00:1c.7 PCI bridge [0604]: Intel Corporation 9 Series Chipset
#     Family PCI Express Root Port 8 [8086:8c9e] (rev d0)
# ### Group 11 ###
#     00:1d.0 USB controller [0c03]: Intel Corporation 9 Series Chipset
#     Family USB EHCI Controller #1 [8086:8ca6]
# ### Group 12 ###
#     00:1f.0 ISA bridge [0601]: Intel Corporation 9 Series Chipset
#     Family Z97 LPC Controller [8086:8cc4]
#     00:1f.2 SATA controller [0106]: Intel Corporation 9 Series Chipset
#     Family SATA Controller [AHCI Mode] [8086:8c82]
#     00:1f.3 SMBus [0c05]: Intel Corporation 9 Series Chipset Family
#     SMBus Controller [8086:8ca2]
# ### Group 13 ###
#     04:00.0 PCI bridge [0604]: ASMedia Technology Inc. Device
#     [1b21:1184]
# ### Group 14 ###
#     05:01.0 PCI bridge [0604]: ASMedia Technology Inc. Device
#     [1b21:1184]
# ### Group 15 ###
#     05:03.0 PCI bridge [0604]: ASMedia Technology Inc. Device
#     [1b21:1184]
#     07:00.0 Ethernet controller [0200]: Realtek Semiconductor Co.,
#     Ltd. RTL8111/8168/8411 PCI Express Gigabit Ethernet Controller
#     [10ec:8168] (rev 11)
# ### Group 16 ###
#     05:05.0 PCI bridge [0604]: ASMedia Technology Inc. Device
#     [1b21:1184]
# ### Group 17 ###
#     05:07.0 PCI bridge [0604]: ASMedia Technology Inc. Device
#     [1b21:1184]
#     09:00.0 SATA controller [0106]: ASMedia Technology Inc. ASM1062
#     Serial ATA Controller [1b21:0612] (rev 02)
# ### Group 18 ###
#     0a:00.0 USB controller [0c03]: ASMedia Technology Inc. ASM1042A
#     USB 3.0 Host Controller [1b21:1142]
# ### Group 19 ###
#     0b:00.0 VGA compatible controller [0300]: NVIDIA Corporation GM107
#     [GeForce GTX 750] [10de:1381] (rev a2)
#     0b:00.1 Audio device [0403]: NVIDIA Corporation Device [10de:0fbc]
#     (rev a1)

{
  environment.systemPackages = with pkgs; [
    #linuxPackages.virtualbox
    qemu # A generic and open source machine emulator and virtualizer
    virtmanager # Desktop user interface for managing virtual machines
    vde2 # Virtual Distributed Ethernet, an Ethernet compliant virtual network
  ];

  virtualisation.virtualbox = {
    host.enable = true;
  };

  virtualisation.libvirtd = {
    enable = true;
    enableKVM = true;
  };
  
  boot.kernelModules = [
    "vfio" "vfio_pci" "vfio_iommu_type1"
    "tun" "virtio" "coretemp"
  ];

  boot.kernelParams = [
    # Use IOMMU
    "intel_iommu=on"
    "i915.preliminary_hw_support=1"
    "vfio_iommu_type1.allow_unsafe_interrupts=1"
    "kvm.allow_unsafe_assigned_interrupts=1"
  
    # Assign devices to vfio
    "vfio-pci.ids=10de:0fbc,10de:0fbc,10ec:8168,8086:8cb1"
  
    # Needed by OS X
    "kvm.ignore_msrs=1"
  
    # Only schedule cpus 0,1
    # "isolcpus=1-3,5-7"
  ];
}
