# Demo Application for Azure Application Health Extension 2.0 with Rich Health States  

## Sample Demo Application
This application is a simple web server written in Go using the [gin-gonic/gin](https://github.com/gin-gonic/gin) framework. It exposes a health check endpoint and can be run on both HTTP and HTTPS. 

The purpose of this demo applicaton is to demonstrate the use of the Azure Application Health Extension 2.0 with rich health states. The extension allows you to monitor the health of your application by sending health probes to a specified endpoint. The application can report four possible health statuses: `Initializing`, `Healthy`, `Unhealthy`, and `Unknown`.

This is app is intented to be used for Educational purposes and as a Starting point for your own application.

## Demo Application Usage

This sample demo application is a simple web server that exposes a health check endpoint (`/health`) and can be run on both HTTP and HTTPS.

Once it starts it will cycle between the `Healthy`, `Unhealthy`, and `Unknown` health states every 3 minutes.

## Demo Application Extension Schema

To use this sample demo application on a Azure Virtual Machine, or VMSS please follow the following steps:

### HTTPS

1. Set the `protocol` to `https`.
2. Set the `port` to `8443`.
3. Set the `requestPath` to `/health`.
4. Set the `intervalInSeconds` to `60`. (Optional)
5. Set the `numberOfProbes` to `3`. (Optional)
6. Set the `gracePeriod` to `180`. (Optional)

### HTTP
1. Set the `protocol` to `http`.
2. Set the `port` to `8080`.
3. Set the `requestPath` to `/health`.
4. Set the `intervalInSeconds` to `60`. (Optional)
5. Set the `numberOfProbes` to `3`. (Optional)
6. Set the `gracePeriod` to `180`. (Optional)


## [Build & Run Application](./main/README.md)

## Test Deployment
If you wish to test this application in an Azure VMSS, follow the instructions in the [Jupyter NoteBook](deploy_demo.ipynb)
