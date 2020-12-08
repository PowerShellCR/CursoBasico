<#
.SYNOPSIS
   Script that creates testing Active Directory OUs and users.
.DESCRIPTION
   Script that creates OUs and users in Active Directory for testing purposes.
.EXAMPLE
   ./Add-TestDomainUsers.ps1
   Run the script without any parameters.
.NOTES
   Authors:
   Luis Vargas (https://www.linkedin.com/in/vluis/)
   Cristopher Robles (https://www.linkedin.com/in/crisrc012/)
#>

#OU array
$OUs = @(
    "Sales",
    "Development",
    "IT",
    "Managers",
    "Marketing",
    "Research"
)

#Create the OUs
foreach ($OU in $OUs) {
    New-ADOrganizationalUnit -Name $OU
}

#Get the distinguished name from the current domain
$DomainDistinguishedName = (Get-ADDomain).DistinguishedName

#Create a default user password as a secure string
$DefaultUserPassword = ConvertTo-SecureString -AsPlainText "Pa55w.rd" -Force

#Import the CSV user list
$UserList = Import-Csv -Delimiter ',' -Path .\UserList.csv

#Iterate through the user list to get it's properties and then create the user in AD
foreach ($User in $UserList) {
    $UserProperties = @{
        Enabled = $true
        Name = "$($User.FirstName) $($User.LastName)"
        SamAccountName = "$(($User.FirstName)[0])$($User.LastName)" #First letter of the name plus last name
        AccountPassword = $DefaultUserPassword
        Path = "OU=$($User.OU),$DomainDistinguishedName"
    }

    New-ADUser @UserProperties
}
