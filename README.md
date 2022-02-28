# AzureAssessment

**Cloud Shell**

1. Open PowerShell in your CloudShell Terminal. Easiest way is to open https://shell.azure.com website.
2. Go to Home Directory

> cd $HOME_DIR 

3. Invoke download script from github and save it locally

> Invoke-WebRequest -Uri https://raw.githubusercontent.com/PoborcaMaciej/AzureAssessment/main/Get-AzureAssessment.ps1 -OutFile 'Get-AzureAssessment.ps1'

4. Run script
> ./Get-AzureAssessment.ps1

5. Download your report in CSV format. You will found it on your Storage Account in File Share. Details about them will be reported.
