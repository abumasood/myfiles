#!/bin/bash
set -e

##################################################################################################################
# Author 	: 	Marco Obaid
# GitHub    :   https://github.com/abumasood
##################################################################################################################
#
#   Script to Create Single VirtualBox VM
#
##################################################################################################################
# This script will create a single "Arch Linux 64-bit" virtualbox machine. The user will be asked to input a
# desired name for the VM. The script will then create the VM as follows:
# 		- Location of VM is the default $HOME/VirtualBox VMs/ 
#		- Main Specs of the VM are as follows (parameters can be adjusted to your liking):
#					- 2 CPUs, 4GB RAM, 20GB Hard Drive
#					- vboxvga display controller with 128MB video memory
# 		- After the virtual machine is created, attach the desired iso and start the VM. 
# 
# To automate attachment of iso and starting the VM, do the following:
#		- Adjust Location of the bootable iso, uncomment myisopath variable and adjust iso path 
#				   	(i.e. $HOME/Downloads/Arco-ISOs-Beta)
#		- Uncomment and adjust "Attached Bootable ISO to CD/DVD Drive" section
#		- uncomment the last line to start virtual machine immediately after creation
##################################################################################################################

echo "#############################################################"
echo "# This script will create a virtualbox vm and auto-start it #"
echo "#############################################################"

echo -n "Enter vm name: "

read myvmname

myvmhome="$HOME/VirtualBox VMs/$myvmname"

# Enter path to your iso here
#myisopath="$HOME/Downloads/Arco-ISOs-Beta/arcolinux-v19.01.3.iso"

# Create and register VM
VBoxManage createvm --name $myvmname --ostype ArchLinux_64 --register

# Add Description
VBoxManage modifyvm $myvmname --description "Created by Marco Obaid"

# Set RTC to UTC
VBoxManage modifyvm $myvmname --rtcuseutc on

# Set Bio Menu
VBoxManage modifyvm $myvmname --biosbootmenu messageandmenu

# Set Boot Order to DVD -> Disk
VBoxManage modifyvm $myvmname --boot1 dvd --boot2 disk --boot3 none --boot4 none

# Assign CPUs, Memory, Display, and Video Memory
VBoxManage modifyvm $myvmname --graphicscontroller vboxvga
VBoxManage modifyvm $myvmname --cpus 2 --memory 4096 --vram 128 
VBoxManage modifyvm $myvmname --pae on
VBoxManage modifyvm $myvmname --accelerate3d on

# Assign Pointing Device
VBoxManage modifyvm $myvmname --mouse usbtablet

# Enable Audio
VBoxManage modifyvm $myvmname --audiocodec ad1980
VBoxManage modifyvm $myvmname --audioout on 

# Enable Clipboard/Drag'n'Drop 
VBoxManage modifyvm $myvmname --clipboard bidirectional
VBoxManage modifyvm $myvmname --draganddrop bidirectional
 
# Create CD/DVD Controller
VBoxManage storagectl $myvmname --name "IDE Controller" --add ide

# Attached Bootable ISO to CD/DVD Drive
#VBoxManage storageattach $myvmname --storagectl "IDE Controller" --port 1  --device 0 --type dvddrive --medium $myisopath
VBoxManage storageattach $myvmname --storagectl "IDE Controller" --port 1  --device 0 --type dvddrive --medium emptydrive

# Create Disk File size 20GB Dynamic Allocation (Standard vs. Fixed)
VBoxManage createhd --filename "$myvmhome/$myvmname.vdi" --size 20480 --variant Standard 

# Create Storage Controller for Disk and Make Bootable
VBoxManage storagectl $myvmname --name "SATA Controller" --add sata --bootable on

# Attach Disk to Controller
VBoxManage storageattach $myvmname --storagectl "SATA Controller" --port 0 --device 0 --type hdd --medium "$myvmhome/$myvmname.vdi"

# Turn on USB 2.0 Controller
VBoxManage modifyvm $myvmname --usbehci on

# Now Start VM 
#VBoxManage startvm $myvmname
