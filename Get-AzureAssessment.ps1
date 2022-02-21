<#
.SYNOPSIS
Get-AzureAssessment.ps1 - Create a report of the Azure Environment and executing assessment.
.DESCRIPTION
Script to prepare a report and assessment
.NOTES
Written By: Maciej Poborca
Website:	https://maciejpoborca.pl

Change Log
V1.00, 15/02/2022 - Initial version (Subscription and VM assessment)
#>
<# Declaring classes #>

Write-Output "$(Get-Date -format HH:mm:ss)  |  Executing Subscription report"
.\Get-AzureSubscriptions.ps1
Write-Output "$(Get-Date -format HH:mm:ss)  |  Executing VM Report"
.\Get-AzureVMs.ps1
Write-Output "$(Get-Date -format HH:mm:ss)  |  Executing Defender for cloud recommendations report"
.\Get-DefenderRecommendations.ps1
