if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole(544)) 
{Start-Process powershell -Args "-File `"$PSCommandPath`"" -Verb RunAs; exit}

$Host.UI.RawUI.WindowTitle = "Sysmon Install & Config"
$Host.UI.RawUI.BackgroundColor = "Black"
Clear-Host

cd $PSScriptRoot
.\Sysmon64.exe -accepteula -i sysmonconfig.xml
Write-Host "`nPress any key to exit"
$Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")