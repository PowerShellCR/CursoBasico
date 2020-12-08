<#
.SYNOPSIS
   Script that creates a testing Active Directory domain.
.DESCRIPTION
   Script that installs the AD DS server role and the AD DS and AD LDS server administration tools,
   and sets up a testing Active Directory domain.
.EXAMPLE
   ./New-TestDomain.ps1
   Run the script without any parameters.
.NOTES
   Author:
   Luis Vargas (https://www.linkedin.com/in/vluis/)
.LINK
   Sources:
   https://docs.microsoft.com/en-us/windows-server/identity/ad-ds/deploy/install-active-directory-domain-services--level-100-
   https://cloudblogs.microsoft.com/industry-blog/en-gb/technetuk/2016/06/08/setting-up-active-directory-via-powershell/
#>

#Install the AD DS server role and the AD DS and AD LDS server administration tools
Install-WindowsFeature -Name AD-Domain-Services -IncludeManagementTools

#Get the Safe Mode Administrator Password from the user
$Credentials = Get-Credential

#Splatted domain options
$DomainOptions = @{
    CreateDNSDelegation = $false
    DatabasePath = "C:\Windows\NTDS"
    DomainMode = "WinThreshold"
    DomainName = "PowerShellCR.org"
    DomainNetbiosName = "PowerShellCR"
    ForestMode = "WinThreshold"
    InstallDNS = $true
    LogPath = "C:\Windows\NTDS\Logs"
    NoRebootOnCompletion = $false
    SYSVOLPath = "C:\Windows\SYSVOL"
    Force = $true
    SafeModeAdministratorPassword = $Credentials.Password
}

#Create the domain using the above options
Install-ADDSForest @DomainOptions
