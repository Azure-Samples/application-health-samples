# PowerShell Sample Application (Protocol: HTTP, Port: 8000, RequestPath: "/")

This sample app will configure a health state based on the assigned Availability Zone of the VM. For best results, please create a VMSS with 2 or more availability zones. This application requires PowerShell and is recommended for Windows VMs. 

The VM health states will be set based on the following:
- Zone 1 ==> "Healthy"
- Zone 2 ==> "Unhealthy"
- Zone 3 ==> "Unknown"

You can use Custom Script Extension to run start.ps1 on your VM, it will then download application.ps1 and start emitting HTTP health probe responses to "http://localhost:8000/".