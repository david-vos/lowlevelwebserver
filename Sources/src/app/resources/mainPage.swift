import Foundation

class MainPage: Page {
    let title: String = "David Vos - Software Engineer"

    lazy var route: Route = .init(
        path: "/",
        handler: { [weak self] request in
            guard let self = self else {
                return ErrorPage.staticErrorResponse
            }
            return self.render(request: request)
        }
    )

    func render(request: HTTPRequest?) -> Data {
        let headerHTML = HeaderComponent.render()
        let headHTML = HeadComponent.render()
        let themeToggle = ThemeToggleComponent.render(request: request)
        let body = """
        <!DOCTYPE html>
        <html lang="en">
        \(headHTML)
        <body>
            \(themeToggle)
            <div class="container home">
                \(headerHTML)
            </div>
        </body>
        </html>
        """
        return HTTPResponse.htmlResponse(htmlBody: body)
    }
}
