<#
.SYNOPSIS
Get-Azureconsumptiondetails.ps1 - Create a report of the Azure consumption details
.DESCRIPTION
Script to prepare a report
.NOTES
Written By: Maciej Poborca
Website:	https://maciejpoborca.pl

Change Log
V1.00, 15/02/2022 - Initial version - Consumption details
#>
if ( ! $(Get-AzContext) )
{
    # Login to Azure Teenant
    Connect-AzAccount
}
<# Part of the code responisble for subscription listing#>
$UsageDetailsTable = @()
Write-Output "$(Get-Date -format HH:mm:ss)  |  Getting list of the subscription"
$Subscriptions = Get-AzSubscription
$today = Get-Date
foreach ($subscription in $Subscriptions) {
    $UsageDetails = Get-AzConsumptionUsageDetail -StartDate $today.AddMonths(-1) -enddate $today
    $UsageDetailsTable += $UsageDetails
}

if ( $PSVersionTable.os -like "*azure*" )
{
    $reportfilename = $(Get-Date -format 'yyyy-MM-dd-HHmmss') + "-UsageDetailsReport.csv"
    $reportfile = $( $(Get-CloudDrive).MountPoint + '\' + $ReportFileName )
    $UsageDetailsTable | ConvertTo-Csv -NoTypeInformation -Delimiter ";" | Out-File $reportfile
}
else{
    $reportfilename = $(Get-Date -format 'yyyy-MM-dd-HHmmss') + "-UsageDetailsReport.csv"
    $UsageDetailsTable | ConvertTo-Csv -NoTypeInformation -Delimiter ";" | Out-File .\$reportfilename
}
