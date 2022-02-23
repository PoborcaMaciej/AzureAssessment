<#
.SYNOPSIS
get-azuredefenderassessment.ps1 - Create a report of the Azure defender Assessment
.DESCRIPTION
Script to prepare a defender assessment
.NOTES
Written By: Maciej Poborca
Website:	https://maciejpoborca.pl

Change Log
V1.00, 15/02/2022 - Initial version - Defender assessment
#>
<# Declaring classes #>
Class Recommendation
{
    [string]$SubscriptionID
    [string]$resource
    [string]$Recommendation
    [string]$status
    [string]$Description
    [string]$RemediationDescription
}

if ( ! $(Get-AzContext) )
{
    # Login to Azure Teenant
    Connect-AzAccount
}
<# Part of the code responisble for reccomendation listing#>
$RecommendationTable = @()
$SecurityTasks = Get-AzSecurityAssessment # get all recommendations from ASC
foreach($SecurityTask in $SecurityTasks)
{
    $Recommendation = New-Object Recommendation
    $Recommendation.SubscriptionID = ($SecurityTask.ResourceDetails.Id.Split("/")[2])
    $Recommendation.Recommendation = $SecurityTask.DisplayName
    $Recommendation.status = $SecurityTask.status.code
    $Recommendation.resource = $SecurityTask.ResourceDetails.Id
    $Recommendation.Description = (Get-AzSecurityAssessmentMetadata -Name $SecurityTask.Name).Description
    $Recommendation.RemediationDescription = (Get-AzSecurityAssessmentMetadata -Name $SecurityTask.Name).RemediationDescription
    $RecommendationTable += $Recommendation
}   


if ( $PSVersionTable.os -like "*azure*" )
{
    $reportfilename = $(Get-Date -format 'yyyy-MM-dd-HHmmss') + "-DefenderAssessment.csv"
    $reportfile = $( $(Get-CloudDrive).MountPoint + '\' + $ReportFileName )
    $RecommendationTable | ConvertTo-Csv -NoTypeInformation -Delimiter ";" | Out-File $reportfile
}
else{
    $reportfilename = $(Get-Date -format 'yyyy-MM-dd-HHmmss') + "-DefenderAssessment.csv"
    $RecommendationTable | ConvertTo-Csv -NoTypeInformation -Delimiter ";" | Out-File .\$reportfilename
}

