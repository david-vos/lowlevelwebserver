import Foundation

class ErrorPage: Page {
    let title: String = "500 - Internal Server Error"
    lazy var route: Route = .init(
        path: "/error",
        handler: { [weak self] request in
            guard let self = self else {
                return ErrorPage.staticErrorResponse
            }
            return self.render(request: request)
        }
    )

    static func errorResponse(message: String? = nil, stackTrace: String? = nil) -> Data {
        let errorDetails = message ?? "Unknown error"
        let stackTraceHtml = stackTrace.map { """
            <h2>Stack Trace:</h2>
            <pre style="background: #f8f8f8; padding: 15px; border-radius: 4px; overflow-x: auto; font-size: 12px; line-height: 1.4;">\($0)</pre>
        """ } ?? ""

        let html = """
        <!DOCTYPE html>
        <html lang="en">
        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>500 - Internal Server Error</title>
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
                    border-left: 4px solid #dc3545;
                }
                h1 {
                    color: #dc3545;
                    margin-top: 0;
                }
                h2 {
                    color: #dc3545;
                    font-size: 18px;
                    margin-top: 20px;
                }
                p {
                    color: #666;
                    line-height: 1.6;
                }
                pre {
                    background: #f8f8f8;
                    padding: 15px;
                    border-radius: 4px;
                    overflow-x: auto;
                    font-size: 12px;
                    line-height: 1.4;
                    color: #333;
                }
            </style>
        </head>
        <body>
            <div class="container">
                <h1>500 - Internal Server Error</h1>
                <p>Something went wrong on our end.</p>
                <h2>Error Details:</h2>
                <pre>\(errorDetails)</pre>
                \(stackTraceHtml)
            </div>
        </body>
        </html>
        """
        return HTTPResponse.htmlResponse(statusCode: 500, statusText: "Internal Server Error", htmlBody: html)
    }

    static let staticErrorResponse: Data = errorResponse()

    func render(request _: HTTPRequest?) -> Data {
        return ErrorPage.errorResponse()
    }
}
