<#
.SYNOPSIS
Get-DefenderRecommendations.ps1 - Create a report of the Azure defender recommendations
.DESCRIPTION
Script to prepare a report
.NOTES
Written By: Maciej Poborca
Website:	https://maciejpoborca.pl

Change Log
V1.00, 15/02/2022 - Initial version - Defender recommendations
#>
<# Declaring classes #>
Class Recommendation
{
    [string]$SubscriptionID
    [string]$resource
    [string]$Recommendation
    [string]$ResourceGroup
    [string]$SubscriptionName
}

if ( ! $(Get-AzContext) )
{
    # Login to Azure Teenant
    Connect-AzAccount
}
<# Part of the code responisble for reccomendation listing#>
$RecommendationTable = @()
Write-Output "$(Get-Date -format HH:mm:ss)  |  Getting list of the subscription"
$Subscriptions = Get-AzSubscription
foreach ($subscription in $Subscriptions) {
    Set-AzContext $subscription.Id
    $SecurityTasks = Get-AzSecurityTask # get all recommendations from ASC
    foreach($SecurityTask in $SecurityTasks)
    {
        If([string]::IsNullOrEmpty($SecurityTask.ResourceId.Split("/")[8])) {  
        # resource field is empty, do nothing, since this is not actionable
    }
    else {
        $Recommendation = New-Object Recommendation
        $Recommendation.SubscriptionID = ($SecurityTask.ResourceId.Split("/")[2])
        $Recommendation.Recommendation = $SecurityTask.RecommendationType
        $Recommendation.resource = ($SecurityTask.ResourceId.Split("/")[8])
        $Recommendation.SubscriptionName = $Subscription.Name
        $Recommendation.ResourceGroup = ($SecurityTask.ResourceId.Split("/")[4])
        $RecommendationTable += $Recommendation
    }   
    }
}
$reportfile = $(Get-Date -format 'yyyy-MM-dd-HHmmss') + "-DefenderRecommendations.csv"
$RecommendationTable | ConvertTo-Csv -NoTypeInformation -Delimiter ";" | Out-File .\$reportfile



