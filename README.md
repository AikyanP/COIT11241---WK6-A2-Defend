# COIT11241---WK6-A2-Defend (HT2, 2023)

Implementing safeguard CIS 9.2 Use DNS Filtering Services to block malicious domains.

This powershell script will use DNS filtering to block access to malicious sites.
To ensure script runs, always double check Execution Policy and change it if required (e.g. Set-ExecutionPolicy RemoteSigned or Set-ExecutionPolicy Unrestricted)

If ScriptAnalyzer is not yet installed, open powershell and input "Install-Module -Name PSScriptAnalyzer -Force"
After it is installed, every session of powershell, the Script Analyzer must be imported by: "Import-Module PSScriptAnalyzer" and now it can be ran.
