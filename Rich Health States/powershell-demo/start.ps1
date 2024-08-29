$applicationDir = "$home\Application"
if([System.IO.Directory]::Exists($applicationDir)){
    Write-Host "Not created $applicationDir as it already exists."
}
else{
    New-Item -Path $applicationDir -ItemType Directory
    Write-Host "$applicationDir created successfully."
}

$applicationPath = "$home\Application\application.ps1"

#TODO: Add SAS token for "Application" script below
Invoke-WebRequest -Uri "<URI for application.ps1 file>" -OutFile $applicationPath
Write-Host "Downloaded application to $applicationPath"

Write-Host "Starting application..."
Start-Process powershell.exe -ArgumentList $applicationPath
Write-Host "Finished starting application"