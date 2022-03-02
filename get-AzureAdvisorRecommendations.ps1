<#
.SYNOPSIS
Get-AzureAdvisorRecommendations.ps1 - Create a report of the Azure Advisor Recommendation
.DESCRIPTION
Script to prepare a report
.NOTES
Written By: Maciej Poborca
Website:	https://maciejpoborca.pl

Change Log
V1.00, 15/02/2022 - Initial version - Azure Advisor Recommendation
#>
<# Declaring classes #>

Class AzureAdvisorRecommendation
{
    [string]$Problem
    [string]$Solution
    [string]$impact
    [string]$ImpactedResourceType
    [string]$ImpactedResource
    [string]$Category
}

if ( ! $(Get-AzContext) )
{
    # Login to Azure Teenant
    Connect-AzAccount
}
$RecommendationTable = @()
$Subscriptions = Get-AzSubscription
foreach ($subscription in $Subscriptions) {
    Set-AzContext $subscription.Id
    $Recommendations = Get-AzAdvisorRecommendation
    foreach ($Recommendation in $Recommendations) {
        Write-Output "$(Get-Date -format HH:mm:ss)  |  Getting advisor recommendation details - Current recommendation $($recommendation.ShortDescription.Problem)"
        $AdvisorRecommendation = New-Object AzureAdvisorRecommendation
        $AdvisorRecommendation.Problem = $Recommendation.ShortDescription.Problem
        $AdvisorRecommendation.Solution = $Recommendation.ShortDescription.Solution
        $AdvisorRecommendation.Category = $Recommendation.Category
        $AdvisorRecommendation.Impact = $Recommendation.Impact
        $AdvisorRecommendation.ImpactedResourceType = $Recommendation.ImpactedField
        $AdvisorRecommendation.ImpactedResource = $Recommendation.impactedValue
        $RecommendationTable += $AdvisorRecommendation
    }
}
if ( $PSVersionTable.os -like "*azure*" )
{
    $reportfilename = $(Get-Date -format 'yyyy-MM-dd-HHmmss') + "-AzureAdvisor.csv"
    $reportfile = $( $(Get-CloudDrive).MountPoint + '\' + $ReportFileName )
    $RecommendationTable | ConvertTo-Csv -NoTypeInformation -Delimiter ";" | Out-File $reportfile
}
else{
    $reportfilename = $(Get-Date -format 'yyyy-MM-dd-HHmmss') + "-AzureAdvisor.csv"
    $RecommendationTable | ConvertTo-Csv -NoTypeInformation -Delimiter ";" | Out-File .\$reportfilename
}

