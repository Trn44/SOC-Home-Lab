# SOC Home Lab Guide

---
## VMWare | Windows 10/11 | Kali Linux VMs  
[VMware](https://www.techpowerup.com/download/vmware-workstation-pro/)  
[Windows 10](https://www.microsoft.com/en-gb/software-download/windows10)
[Windows 11](https://www.microsoft.com/en-gb/software-download/windows11)  
[Kali Linux](https://cdimage.kali.org/kali-2026.1/kali-linux-2026.1-vmware-amd64.7z)

---
## Download Sysmon | Splunk Enterprise
[Sysmon](https://download.sysinternals.com/files/Sysmon.zip)  
[Sysmon Config](https://github.com/olafhartong/sysmon-modular/blob/master/sysmonconfig.xml)  
[Splunk](https://www.splunk.com/en_us/download/splunk-enterprise.html)

---
## Installing VMs
- Download and Install Windows VM from created ISO file. 
- Extract Kali Linux Zip and Import VM.

---
## Sysmon | Splunk Setup
- Copy & Paste Sysmon, Sysmon Config and Splunk Installer to Windows VM.
- Install Splunk from MSI installer to VM.
- Unzip Sysmon folder, copy and paste sysmonconfig.xml into directory where Sysmon64.exe is located.
- Download provided PowerShell Script and copy, paste into Sysmon root folder to 1 click install Sysmon.
