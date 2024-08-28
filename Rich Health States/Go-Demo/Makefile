BINDIR=bin
BUNDLEDIR=bundle
DEMO_BINARY_NAME=demo-app

create-certs:
	openssl req -x509 -newkey rsa:4096 -keyout $(BINDIR)/webserverkey.pem -out $(BINDIR)/webservercert.pem -days 365 -nodes -subj '/'

clean:
	rm -rf $(BINDIR)/* $(BUNDLEDIR)/*

build-windows: clean
	GOOS=windows GOARCH=amd64 go build -o $(BINDIR)/$(DEMO_BINARY_NAME)-windows.exe ./main/

bundle-windows: build-windows create-certs
	mkdir -p $(BUNDLEDIR)
	tar -czvf $(BUNDLEDIR)/demo-app-bundle.tar.gz -C $(BINDIR) $(DEMO_BINARY_NAME)-windows.exe webserverkey.pem webservercert.pem

build-linux: clean
	GOOS=linux GOARCH=amd64 go build -o $(BINDIR)/$(DEMO_BINARY_NAME)-linux ./main/

bundle-linux: build-linux create-certs
	mkdir -p $(BUNDLEDIR)
	tar -czvf $(BUNDLEDIR)/demo-app-bundle.tar.gz -C $(BINDIR) $(DEMO_BINARY_NAME)-linux webserverkey.pem webservercert.pem