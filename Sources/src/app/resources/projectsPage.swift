import Foundation

class ProjectsPage: Page {
    let title: String = "Projects - David Vos"

    lazy var route: Route = .init(
        path: "/projects",
        handler: { [weak self] request in
            guard let self = self else {
                return ErrorPage.staticErrorResponse
            }
            return self.render(request: request)
        }
    )

    func render(request: HTTPRequest?) -> Data {
        let headConfig = HeadComponent.HeadConfig(
            title: "Projects - David Vos",
            description: "Projects and open source work by David Vos. Unity tools, web development, and more.",
            keywords: "David Vos Projects, Software Development, Unity Tools, Event Bus, Logger, Swift Web Server",
            author: "David Vos",
            canonicalUrl: "https://dvos.me/projects",
            faviconPath: "/favicon.ico",
            stylesheetPaths: ["/colours.css", "/common.css", "/projects.css"],
            lang: "en"
        )
        let headHTML = HeadComponent.render(config: headConfig)
        let themeToggle = ThemeToggleComponent.render(request: request)

        let body = """
        <!DOCTYPE html>
        <html lang="en">
        \(headHTML)
        <body>
            \(themeToggle)
            <div class="container">
                <header class="page-header">
                    <a href="/" class="back-link">← Back to Home</a>
                    <h1 class="page-title">Projects</h1>
                    <p class="page-subtitle">Open source tools and personal projects.</p>
                </header>

                <div class="projects-grid">
                    \(BoxComponent.renderAll())
                </div>
            </div>
        </body>
        </html>
        """
        return HTTPResponse.htmlResponse(htmlBody: body)
    }
}
