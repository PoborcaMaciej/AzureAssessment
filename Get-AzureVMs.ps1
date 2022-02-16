<#
.SYNOPSIS
Get-AzureVMs.ps1 - Create a report of the Azure VM
.DESCRIPTION
Script to prepare a report
.NOTES
Written By: Maciej Poborca
Website:	https://maciejpoborca.pl

Change Log
V1.00, 15/02/2022 - Initial version - VM assessment
#>
<# Declaring classes #>

Class AzureVM
{
    [string]$Type
    [string]$Name
    [string]$ResourceGroupName
    [string]$Id
    [string]$Location
    [string]$LicenseType
    [string]$Tags
    [string]$AVSet
    [string]$NIC
    [string]$VMSize
    [string]$osdisk
    [string]$datadisks
}

if ( ! $(Get-AzContext) )
{
    # Login to Azure Teenant
    Connect-AzAccount
}
$VMArray = @()
foreach ($subscription in $Subscriptions) {
    Set-AzContext $subscription.Id
    $VMS = Get-AzVM
    foreach ($vm in $VMS) {
        Write-Output "$(Get-Date -format HH:mm:ss)  |  Getting VM details - Current vm $($vm.Name)"
        $VMDetails = New-Object AzureVM
        $VMDetails.Type = "Virtual Machine"
        $VMDetails.Name = $vm.Name
        $VMDetails.ResourceGroupName = $vm.ResourceGroupName
        $VMDetails.Id = $vm.Id
        $VMDetails.Location = $vm.Location
        $VMDetails.LicenseType = $vm.StorageProfile.ImageReference.Offer + " " + $vm.StorageProfile.ImageReference.Sku
        $VMDetails.Tags = ($vm.tags | convertto-json | ConvertFrom-Json ) -join ", " 
        $VMDetails.AVSet = $vm.AvailabilitySetReference
        $nics = $null
        foreach($NIC in $vm.NetworkProfile.NetworkInterfaces)
        {
            $nics += "id: " + $nic.Id + ", "
            $detailednic = Get-AzNetworkInterface -ResourceId $nic.Id
            $nics += "PrivateIP: " + $detailednic.IpConfigurations.privateipaddress + ", "
            $nics += "PublicIP: " + $detailednic.IpConfigurations.PublicIPAddress.Name + ", "
            $nics += "NSG: " + $detailednic.NetworkSecurityGroup.Id + ", "
            $nics += "subnetId: " + $detailednic.IpConfigurations.subnet.id + " | "
        }
        $VMDetails.NIC = $nics
        $VMDetails.VMSize = $vm.HardwareProfile.vmsize
        $VMDetails.OsDisk = $vm.StorageProfile.OsDisk.Name
        $datadisks = $null
        foreach($disk in $vm.StorageProfile.DataDisks)
        {
            $datadisks += "lun: " + ($disk.lun).ToString() + ","
            $datadisks += " name: " + $disk.Name + ","
            $detaileddisk = Get-AzDisk -ResourceGroupName $vm.ResourceGroupName -DiskName $disk.Name
            $datadisks += " DiskSize: " + ($detaileddisk.DiskSizeGB).ToString() + ","
            $datadisks += " Tier: " + $detaileddisk.Tier +","
            $datadisks += " DiskIOPS: " + $detaileddisk.DiskIOPSReadWrite + " | "
        }
        $VMDetails.datadisks = $datadisks
        $VMArray += $VMDetails
    }
}
$reportfile = $(Get-Date -format 'yyyy-MM-dd-HHmmss') + "-VMreport.csv"
$VMArray | ConvertTo-Csv -NoTypeInformation -Delimiter ";" | Out-File .\$reportfile
