# PowerShell Sample Application (Protocol: HTTP, Port: 8000, RequestPath: "/health")

This sample app will send a 200 ("Healthy") response to "http://localhost:8000/health" and a 400 ("Unhealthy") response to all other endpoints. This application requires PowerShell and is recommended for Windows VMs. 

For example:
- At port: 8000, requestPath: "/health", the application will always return a 200 response ("Healthy")
- At any other port/requestPath values, the application will always return a 400 response ("Unhealthy")

You can use Custom Script Extension to run start.ps1 on your VM, it will then download application.ps1 and start emitting HTTP health probe responses to "http://localhost:8000/health"