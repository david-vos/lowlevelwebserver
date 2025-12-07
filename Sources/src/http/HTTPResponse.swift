import Foundation

/// Helper for building HTTP responses
class HTTPResponse {
    /// Creates a complete HTTP response with HTML body
    /// - Parameters:
    ///   - statusCode: HTTP status code (e.g., 200)
    ///   - statusText: HTTP status text (e.g., "OK")
    ///   - htmlBody: The HTML content to return
    /// - Returns: Complete HTTP response as Data
    static func htmlResponse(statusCode: Int = 200, statusText: String = "OK", htmlBody: String) -> Data {
        // Build the HTTP response
        var response = "HTTP/1.1 \(statusCode) \(statusText)\r\n"
        response += "Content-Type: text/html; charset=utf-8\r\n"
        response += "Content-Length: \(htmlBody.utf8.count)\r\n"
        response += "Connection: close\r\n"
        response += "\r\n"
        response += htmlBody

        // Convert to Data for sending over socket
        return Data(response.utf8)
    }

    /// Default HTML page to return
    static let defaultHTML = """
    <!DOCTYPE html>
    <html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Web Server</title>
        <style>
            body {
                font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Oxygen, Ubuntu, Cantarell, sans-serif;
                max-width: 800px;
                margin: 50px auto;
                padding: 20px;
                background: #f5f5f5;
            }
            .container {
                background: white;
                padding: 30px;
                border-radius: 8px;
                box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            }
            h1 {
                color: #333;
                margin-top: 0;
            }
            p {
                color: #666;
                line-height: 1.6;
            }
        </style>
    </head>
    <body>
        <div class="container">
            <h1>I forgot to create content for the requested page</h1>
            <p>Please reach out to dev@dvos.me to report the bug</p>
            <p>Nothing is wrong with the server. I just messup up...</p>
        </div>
    </body>
    </html>
    """
}
