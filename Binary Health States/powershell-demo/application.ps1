# Define the URL to listen on
$baseUrl = "http://localhost:8000/"
$listener = New-Object System.Net.HttpListener
$listener.Prefixes.Add($baseUrl)
$listener.Start()
Write-Host "Listening on $baseUrl"

# Method to handle GET /health requests
function Get-Health {
    param (
        $context
    )

    $response = $context.Response
    $response.StatusCode = 200
    $response.ContentType = "application/json"

    # Optional: Return a JSON response body (empty object here)
    $responseBody = "{}"
    $buffer = [System.Text.Encoding]::UTF8.GetBytes($responseBody)
    $response.ContentLength64 = $buffer.Length
    $response.OutputStream.Write($buffer, 0, $buffer.Length)

    # Close the response
    $response.Close()

    Write-Host "Responded with 200 OK for GET /health"
}

# Function to route requests to the appropriate handler
function Handle-Request {
    param (
        $context
    )

    $request = $context.Request

    switch ($request.HttpMethod) {
        'GET' {
            switch ($request.Url.AbsolutePath) {
                '/health' {
                    Get-Health -context $context
                }
                default {
                    # Handle unknown GET requests
                    Write-Host "Received unknown GET request"
                    $response = $context.Response
                    $response.StatusCode = 404
                    $response.Close()
                }
            }
        }
        default {
            # Handle unknown HTTP methods
            Write-Host "Received unknown HTTP method"
            $response = $context.Response
            $response.StatusCode = 405
            $response.Close()
        }
    }
}

# Infinite loop to keep the server running
while ($true) {
    # Wait for an incoming request
    $context = $listener.GetContext()
    Handle-Request -context $context
}