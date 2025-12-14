import Foundation

class HealthCheck: Page {
    let title: String = "David Vos - HealthCheck"

    lazy var route: Route = .init(
        path: "/health",
        handler: { [weak self] request in
            guard let self = self else {
                return ErrorPage.staticErrorResponse
            }
            return self.render(request: request)
        }
    )

    func render(request _: HTTPRequest?) -> Data {
        let headHTML = HeadComponent.render()
        let body = """
        <!DOCTYPE html>
        <html lang="en">
        \(headHTML)
        <body>
            <div class="container healthcheck">
                <h1>Health Check</h1>
                <p>Status: <strong>OK</strong></p>
        </body>
        </html>
        """
        return HTTPResponse.htmlResponse(htmlBody: body)
    }
}
