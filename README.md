# Application Health Extension - demo/sample apps

This repo holds demo/sample applications that emits a health signal to be used by [Application Health Extension](https://learn.microsoft.com/en-us/azure/virtual-machine-scale-sets/virtual-machine-scale-sets-health-extension?tabs=rest-api).
These samples are intended to Help Application Health Extension Customers understand how to setup or create their application.

## Application Health Extension Requirements
### ARM Template Extension Schema

```json
{
  "extensionProfile" : {
     "extensions" : [
      {
        "name" : "HealthExtension",
        "properties": {
          "publisher": "Microsoft.ManagedServices",
          "type": "<ApplicationHealthLinux or ApplicationHealthWindows>",
          "autoUpgradeMinorVersion": true,
          "typeHandlerVersion": "2.0",
          "settings": {
            "protocol": "<protocol>",
            "port": <port>,
            "requestPath": "</requestPath>",
            "intervalInSeconds": <intervalInSeconds>,
            "numberOfProbes": <numberOfProbes>,
            "gracePeriod": <gracePeriod>
          }
        }
      }
    ]
  }
}
```

#### Parameters

- `protocol`: The protocol to use for the health check. Valid values are `http`, `https`, and `tcp`.
- `port`: The port to use for the health check. Optional when protocol is http or https, mandatory when protocol is tcp
- `requestPath`: The path to the health check endpoint. Mandatory when protocol is http or https, not allowed when protocol is tcp
- `intervalInSeconds`: The interval in seconds between health checks.Optional, default is 1. This setting is the number of consecutive probes required for the health status to change.
  - > For example, if numberOfProbes == 3, you will need 3 consecutive "Healthy" signals to change the health status from "Unhealthy"/"Unknown" into "Healthy" state. The same requirement applies to change health status into "Unhealthy" or "Unknown" state.
- `numberOfProbes`: Optional, default = `intervalInSeconds * numberOfProbes`; maximum grace period is 14400 seconds. The number of consecutive probes that must return a healthy status before the extension reports the application as healthy.

### Possible Health States

The application has four possible health statuses:

- [`Initializing`](command:_github.copilot.openSymbolInFile?%5B%22demo-app%2Fmain.go%22%2C%22Initializing%22%5D "demo-app/main.go"): The Initializing state only occurs once at extension start time and can be configured by the extension settings gracePeriod and numberOfProbes.
- [`Healthy`](command:_github.copilot.openSymbolInFile?%5B%22demo-app%2Fmain.go%22%2C%22Healthy%22%5D "demo-app/main.go"): The application is running normally.
- [`Unhealthy`](command:_github.copilot.openSymbolInFile?%5B%22demo-app%2Fmain.go%22%2C%22Unhealthy%22%5D "demo-app/main.go"): The application has encountered an issue.
- [`Unknown`](command:_github.copilot.openSymbolInFile?%5B%22demo-app%2Fmain.go%22%2C%22Unknown%22%5D "demo-app/main.go"): This state is only reported for http or https probes and occurs in the following scenarios:
  - When a non-2xx status code is returned by the application
  - When the probe request times out
  - When the application endpoint is unreachable or incorrectly configured
  - When a missing or invalid value is provided for ApplicationHealthState in the response body
  - When the grace period expiresThe application's health status is unknown.

### Health State Responses Expected by AppHealthExtension 2.0

  **Healthy and Unhealthy** states are reported by the application. The health check endpoint should return a JSON response with the following structure:
  `Status Code: 2xx`

  ```json
  {
    "ApplicationHealthState": "<Healthy, Unhealthy>"
  }
  ```

  **Unknown** state is reported by the extension when the application returns a `non-2xx status code`, the probe request times out, the application endpoint is unreachable or incorrectly configured, a missing or invalid value is provided for `ApplicationHealthState` in the response body, or the grace period expires.

