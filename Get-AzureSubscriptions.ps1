<#
.SYNOPSIS
Get-AzureSubscriptions.ps1 - Create a report of the Azure Subscriptions
.DESCRIPTION
Script to prepare a report
.NOTES
Written By: Maciej Poborca
Website:	https://maciejpoborca.pl

Change Log
V1.00, 15/02/2022 - Initial version - Subscription
#>
<# Declaring classes #>
Class AzureSubscription 
{
    [string]$Type
    [string]$Name
    [string]$SubscriptionId
    [string]$TenantId
    [string]$Plan
    [string]$SpendingLimit
}

if ( ! $(Get-AzContext) )
{
    # Login to Azure Teenant
    Connect-AzAccount
}
<# Part of the code responisble for subscription listing#>
$SubscriptionsArray = @()
Write-Output "$(Get-Date -format HH:mm:ss)  |  Getting list of the subscription"
$Subscriptions = Get-AzSubscription
foreach ($subscription in $Subscriptions) {
    Write-Output "$(Get-Date -format HH:mm:ss)  |  Getting subscription details - Current subscription $($subscription.Name)"
    $SubscriptionDetails = New-Object AzureSubscription
    $SubscriptionDetails.Type = "Subscription"
    $SubscriptionDetails.Name = $subscription.Name
    $SubscriptionDetails.SubscriptionId = $subscription.Id
    $SubscriptionDetails.TenantId = $subscription.HomeTenantId
    $SubscriptionDetails.Plan = ($subscription.ExtendedProperties.SubscriptionPolices | ConvertFrom-Json).quotaId
    $SubscriptionDetails.SpendingLimit = ($subscription.ExtendedProperties.SubscriptionPolices | ConvertFrom-Json).spendingLimit
    $SubscriptionsArray += $SubscriptionDetails
}
$reportfilename = $(Get-Date -format 'yyyy-MM-dd-HHmmss') + "-subscriptionreport.csv"
$reportfile = $( $(Get-CloudDrive).MountPoint + '\' + $ReportFileName )
$SubscriptionsArray | ConvertTo-Csv -NoTypeInformation -Delimiter ";"| Out-File $reportfile