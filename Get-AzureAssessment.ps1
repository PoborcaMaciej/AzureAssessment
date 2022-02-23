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
V1.01, 23/02/2022 - Allow to execute directly from cloud shell
#>
<# Declaring classes #>
$WarningPreference = 'SilentlyContinue'
Write-Output "$(Get-Date -format HH:mm:ss)  |  Executing Subscription report"
Invoke-WebRequest -Uri https://raw.githubusercontent.com/PoborcaMaciej/AzureAssessment/main/Get-AzureSubscriptions.ps1 -OutFile 'Get-AzureSubscriptions.ps1'
.\Get-AzureSubscriptions.ps1
Write-Output "$(Get-Date -format HH:mm:ss)  |  Executing VM Report"
Invoke-WebRequest -Uri https://raw.githubusercontent.com/PoborcaMaciej/AzureAssessment/main/Get-AzureVMs.ps1 -OutFile 'Get-AzureVMs.ps1'
.\Get-AzureVMs.ps1
Write-Output "$(Get-Date -format HH:mm:ss)  |  Executing Defender for cloud recommendations report"
Invoke-WebRequest -Uri https://raw.githubusercontent.com/PoborcaMaciej/AzureAssessment/main/get-DefenderRecommendations.ps1 -OutFile 'Get-DefenderRecommendations.ps1'
.\Get-DefenderRecommendations.ps1
Write-Output "$(Get-Date -format HH:mm:ss)  |  Executing Defender for cloud assessment report"
Invoke-WebRequest -Uri https://raw.githubusercontent.com/PoborcaMaciej/AzureAssessment/main/get-azuredefenderassessment.ps1 -OutFile 'get-azuredefenderassessment.ps1'
.\get-azuredefenderassessment.ps1
