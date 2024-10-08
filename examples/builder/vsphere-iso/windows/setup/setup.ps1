# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

$ErrorActionPreference = "Stop"

# Switch network connection to private mode
# Required for WinRM firewall rules
# The Variable 'profile' is an automatic variable that is built into PowerShell, assigning to it might have undesired side effects. If assignment is not by design, please use a different name.
$network_profile = Get-NetConnectionProfile
Set-NetConnectionProfile -Name $network_profile.Name -NetworkCategory Private

# Enable WinRM service
winrm quickconfig -quiet
winrm set winrm/config/service '@{AllowUnencrypted="true"}'
winrm set winrm/config/service/auth '@{Basic="true"}'

# Reset auto logon count
# https://docs.microsoft.com/en-us/windows-hardware/customize/desktop/unattend/microsoft-windows-shell-setup-autologon-logoncount#logoncount-known-issue
Set-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon' -Name AutoLogonCount -Value 0
