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
v1.02, 02/03/2022 - Add Azure Advisor Recommendation + Information where to find fileshare + Azure Consumption report
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
Write-Output "$(Get-Date -format HH:mm:ss)  |  Executing Azure Advisor Recommendations report"
Invoke-WebRequest -Uri https://raw.githubusercontent.com/PoborcaMaciej/AzureAssessment/main/get-AzureAdvisorRecommendations.ps1 -OutFile 'get-azureAdvisorRecommendations.ps1'
.\get-azureAdvisorRecommendations.ps1
Write-Output "$(Get-Date -format HH:mm:ss)  |  Executing Azure Consumption report"
Invoke-WebRequest -Uri https://raw.githubusercontent.com/PoborcaMaciej/AzureAssessment/main/get-azureconsumptiondetails.ps1 -OutFile 'get-azureconsumptiondetails.ps1'
.\get-azureconsumptiondetails.ps1



Write-Output $('- Your reports are completed and stored in the fileshare shown below' )
Write-Output $('   Storage Account: ' + $(Get-CloudDrive).Name )
Write-Output $('    FileShare Name: ' + $(Get-CloudDrive).FileShareName )
