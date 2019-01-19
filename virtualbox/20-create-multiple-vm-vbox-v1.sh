#!/bin/bash
set -e
##################################################################################################################
# Author 	: 	Marco Obaid
# GitHub    :   https://github.com/abumasood
##################################################################################################################
#
#   Script to Create Multiple VirtualBox VMs 
#  
##################################################################################################################

# Generate a List of VM Names to be Created
ls $HOME/Downloads/ISOs | sed 's/.iso//g' > input.txt

# Read Input File and Assig a VM Name
cat input.txt | while read myvmname; do

myvmhome="$HOME/VirtualBox VMs/$myvmname"
myisopath="$HOME/Downloads/ISOs/$myvmname.iso"

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
VBoxManage storageattach $myvmname --storagectl "IDE Controller" --port 1  --device 0 --type dvddrive --medium $myisopath

# Create Disk File size 20GB Dynamic Allocation (Standard vs. Fixed)
VBoxManage createhd --filename "$myvmhome/$myvmname.vdi" --size 20480 --variant Standard 

# Create Storage Controller for Disk and Make Bootable
VBoxManage storagectl $myvmname --name "SATA Controller" --add sata --bootable on

# Attach Disk to Controller
VBoxManage storageattach $myvmname --storagectl "SATA Controller" --port 0 --device 0 --type hdd --medium "$myvmhome/$myvmname.vdi"

# Turn off USB 2.0 Controller
VBoxManage modifyvm $myvmname --usbehci on

# Start VM (if needed) 
#VBoxManage startvm $myvmname

done

# Clean up 
rm -f input.txt