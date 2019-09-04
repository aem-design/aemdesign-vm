# AEM Design - VM Kickstarter

[![build_status](https://travis-ci.org/aem-design/aemdesign-vm.svg?branch=master)](https://travis-ci.org/aem-design/aemdesign-vm) 
[![github license](https://img.shields.io/github/license/aem-design/aemdesign-vm)](https://github.com/aem-design/aemdesign-vm) 
[![github issues](https://img.shields.io/github/issues/aem-design/aemdesign-vm)](https://github.com/aem-design/aemdesign-vm) 
[![github last commit](https://img.shields.io/github/last-commit/aem-design/aemdesign-vm)](https://github.com/aem-design/aemdesign-vm) 
[![github repo size](https://img.shields.io/github/repo-size/aem-design/aemdesign-vm)](https://github.com/aem-design/aemdesign-vm) 
[![docker stars](https://img.shields.io/docker/stars/aemdesign/aemdesign-vm)](https://hub.docker.com/r/aemdesign/aemdesign-vm) 
[![docker pulls](https://img.shields.io/docker/pulls/aemdesign/aemdesign-vm)](https://hub.docker.com/r/aemdesign/aemdesign-vm) 
[![github release](https://img.shields.io/github/release/aem-design/aemdesign-vm)](https://github.com/aem-design/aemdesign-vm)


This folder contains all of the VM Kickstarter scripts that will be used form creating VM.

## BuildLocal Dev Process Overview


1. Setup Variables
2. Verify VM Appliance
    * Verify Appliance has been built successfully [if OVF does not exists] then delete build folder
3. Check Configurations
    * Check if dependencies are installed
    * init and get repos
    * secure ssh keys
4. Update VirtualBox Settings and Network Adapters
    * Check if hostonlyif exists and create if not
    * update VM networks
    * update extra params
5. Build VM Appliance
    * build vm using packer
6. Configure VM
    * import VM Appliance
    * update VM network config
    * update VM config
    * udpate VM lan
7. Start VM
    * start and wait
8. Local Dev Setup
    * test VM is configured
    * run LocalDev playbook
    * update VM lan
    * verify VM lan has been updated
    * optional build docker containers

## Getting Started


1. clone repo
2. run dependencies install

```bash
mvn clean install -Pdependencies
```

2.1 generate ssh keys
```bash
mvn clean install -Pgeneratekeys
```

3.1 Run build of VMware

```bash
mvn verify -PverifyTemplate -PcreateVM -Dpacker.var-file=settings/variables-online-dev1.json -Dpacker.template=template-rhel-build.json 
```

3.2 Run build of Virtual Box

offline:
```bash
mvn verify -PverifyTemplate -PcreateVM -Dpacker.var-file=settings/variables-offline.json -Dpacker.template=template-centos-atomic-virtualbox.json
```

online:
```bash
mvn verify -PverifyTemplate -PcreateVM -Dpacker.var-file=settings/variables-online-dev1.json -Dpacker.template=template-rhel-build-virtualbox.json > log/rhel-build-dev1-`date +%Y-%m-%d.%H:%M:%S`.log &
```

4.1 Run build of OVA from VMX

```bash
mvn verify -PcreateOVA -Dvm.ovftool="/Applications/VMware Fusion.app/Contents/Library/VMware OVF Tool/ovftool" -Dvm.vmx="./builds/aemdesign_2017-01-07_13-52-05/aemdesign.vmx"
```

4.2 Run build of OVA from Virtual Box

```bash
mvn verify -PcreateVboxOVA -Dvmbox.path="./builds/aemdesign/" -Dvmbox.name="aemdesign" > log/ova-build-dev1-`date +%Y-%m-%d.%H:%M:%S`.log &
```

5.1 Run verify of VM Template VMWARE

```bash
mvn verify -PverifyTemplate -Dpacker.var-file=settings/variables-online-dev1.json -Dpacker.template=template-rhel-build.json 
```

5.2 Run verify of VM Template Virtual Box

```bash
mvn verify -PverifyTemplate -Dpacker.var-file=settings/variables-online-localdev.json -Dpacker.template=template-rhel-build-virtualbox.json
```

## DEV Kickstarter Setup


[Kickstart Options](https://access.redhat.com/documentation/en-US/Red_Hat_Enterprise_Linux/7/html/Installation_Guide/sect-kickstart-syntax.html)

### Vmware Fusion



### Template Settings

"headless": false,

### Prerequisites


* Install ```Intel x86 Emulator Accelerator (HAXM)```

```bash
echo y | android update sdk --no-ui --all --force --filter extra-intel-Hardware_Accelerated_Execution_Manager
```

* Reboot.

To verify that Intel HAXM is running, open a terminal window and execute the following command:
```bash
kextstat | grep intel
```

To stop or start Intel HAXM, use the following commands:

Stop:
```bash
sudo kextunload –b com.intel.kext.intelhaxm
```

Start:
```bash
sudo kextload –b com.intel.kext.intelhaxm
```

To uninstall Intel HAXM, open a terminal window and execute this command:
```bash
sudo /System/Library/Extensions/intelhaxm.kext/Contents/Resources/uninstall.sh
```

## Errors

When you get errors check here

Error:
Could not open /dev/vmmon: No such file or directory.

Install:
Intel x86 Emulator Accelerator (HAXM)

In terminal: 
> android

https://software.intel.com/en-us/android/articles/installation-instructions-for-intel-hardware-accelerated-execution-manager-mac-os-x


## Folders & Files


* keys - private keys
* builds - final output of build process
* http - config folder that is used by Packer to into a webserver to be used during build
* scripts - post installation scripts to be ran on the vms
* settings - additional setting for diffrent modes
* template-rhel.json - Packer template for RHEL build

## Hot to generate new SHA1 hash of a file

When you change ISO files you need to specify the checksum to generate a new one run this command

```bash
openssl sha1 path/to/file
```


## Kickstarter File

create encrypted password for kickstarter file
```bash
# md5
openssl passwd -1 "password here"
```
or
```bash
# sha512
echo "password here" | openssl dgst -sha512
```

## Monitor Headless VM Creation


Default VRDP port is 5901, while build is running you can watch the process by use any RDP tool, ex [CoRD](http://cord.sourceforge.net/), by connecting to ```127.0.0.1:5901```.

OR

Video record for creation is enabled and files are stored in ```build/sessions``` directory, you can watch the .webm file for your headless installation process


