import Foundation

class BlogListPage: Page {
    let title: String = "Blog - David Vos"

    lazy var route: Route = .init(
        path: "/blog",
        handler: { [weak self] request in
            guard let self = self else {
                return ErrorPage.staticErrorResponse
            }
            return self.render(request: request)
        }
    )

    func render(request: HTTPRequest?) -> Data {
        let headConfig = HeadComponent.HeadConfig(
            title: "Blogs - David Vos",
            description: "Blog posts about software development, game development, and technology by David Vos.",
            keywords: "David Vos Blog, Software Development Blog, Game Development, Swift, Unity, Programming",
            author: "David Vos",
            canonicalUrl: "https://dvos.me/blog",
            faviconPath: "/favicon.ico",
            stylesheetPaths: ["/colours.css", "/common.css", "/blog.css"],
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
                    <h1 class="page-title">Blogs</h1>
                    <p class="page-subtitle">Thoughts on software, games, and everything in between.</p>
                </header>

                <div class="blog-grid">
                    \(BlogComponent.renderAllCards())
                </div>
            </div>
        </body>
        </html>
        """
        return HTTPResponse.htmlResponse(htmlBody: body)
    }
}
