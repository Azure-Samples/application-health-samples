# Build and Run

To Build the Application follow the following steps:

1. Download and Intall Go 1.22 or newer version.
2. Run `make build-linux` or `make build-windows` to build the application for Linux or Windows.
3. Create a `webservercert.pem` and `webserverkey.pem` files in the same directory as the binary if you want to run the application over HTTPS. For Simplicity you may use the `make create-certs` or use another technique to create the certificates.
4. If you wish to create a zip with the demo app in order to deploy it, you can use the `make bundle-linux` or `make bundle-windows` command.
4. Run the application by going to the `/bin` directory and usingn the following command: `./demo-app` or `./demo-app.exe` for Windows.