package main

import (
	"flag"
	"log"
	"net/http"
	"sync"
	"time"

	"github.com/gin-gonic/gin"
)

type HealthState string

// Available health
const (
	Healthy   HealthState = "Healthy"
	Unhealthy HealthState = "Unhealthy"
	Unknown   HealthState = "Unknown"
)

// RichHealthStateResponse represents the response structure for the health endpoint.
type RichHealthStateResponse struct {
	ApplicationHealthState string `json:"ApplicationHealthState"`
}

// Initially the application health state is Healthy.
var (
	applicationHealthState HealthState = Healthy
	mutex                  sync.Mutex
)

// main is the entry point of the application.
// It starts an HTTP server and an HTTPS server, and periodically updates the application health state.
// The HTTP server listens on the port specified by the "httpPort" flag, and the HTTPS server listens on the port specified by the "httpsPort" flag.
// The application health state is updated every 3 minutes, cycling between "Healthy", "Unhealthy", and "Unknown".
// The "/health" endpoint of the HTTP server returns the current application health state.
// If an error occurs while starting the servers, the application will log the error and exit applicationHealthState represents the health state of the application.
func main() {
	// Parse command-line flags
	httpPort := flag.String("httpPort", "8080", "HTTP server port")
	httpsPort := flag.String("httpsPort", "8443", "HTTPS server port")
	flag.Parse()

	// Create a new Gin router
	r := gin.Default()

	// Start a ticker to periodically update the application health state
	ticker := time.NewTicker(3 * time.Minute)
	go func() {
		for range ticker.C {
			mutex.Lock()
			switch applicationHealthState {
			case Healthy:
				applicationHealthState = Unhealthy
			case Unhealthy:
				applicationHealthState = Unknown
			case Unknown:
				applicationHealthState = Healthy
			}
			mutex.Unlock()
		}
	}()

	// Endpoint used by Applicaton Health Extension to monitor the health of the this application.
	r.GET("/health", func(c *gin.Context) {
		mutex.Lock()
		defer mutex.Unlock()
		switch applicationHealthState {
		case Unknown:
			// Unknown AppHealth Extension expects a non-200 status code for unknown health state
			c.JSON(http.StatusFound, RichHealthStateResponse{ApplicationHealthState: string(applicationHealthState)})
		case Healthy, Unhealthy:
			// Healthy and Unhealthy AppHealth Extensions expect a 200 status code
			// and JSON Body with the health state.
			// example: {"ApplicationHealthState":"Healthy"} for Healthy State and
			// {"ApplicationHealthState":"Unhealthy"} for Unhealthy State
			c.JSON(http.StatusOK, RichHealthStateResponse{ApplicationHealthState: string(applicationHealthState)})
		}
	})

	go func() {
		if err := r.Run(":" + *httpPort); err != nil {
			log.Fatalf("Failed to run HTTP server on port %s: %v", *httpPort, err)
		}
	}()

	// HTTPS server
	if err := r.RunTLS(":"+*httpsPort, "webservercert.pem", "webserverkey.pem"); err != nil {
		log.Fatalf("Failed to run HTTP server on port %s: %v", *httpPort, err)
	}
	r.Run()
}
