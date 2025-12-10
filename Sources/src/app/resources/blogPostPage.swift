import Foundation

class BlogPostPage: Page {
    let blogPost: BlogPost
    let title: String

    lazy var route: Route = .init(
        path: blogPost.path,
        handler: { [weak self] request in
            guard let self = self else {
                return ErrorPage.staticErrorResponse
            }
            return self.render(request: request)
        }
    )

    init(blogPost: BlogPost) {
        self.blogPost = blogPost
        title = blogPost.title
    }

    func render(request: HTTPRequest?) -> Data {
        let headConfig = HeadComponent.HeadConfig(
            title: "\(blogPost.title) - David Vos",
            description: blogPost.summary,
            keywords: "David Vos Blog, \(blogPost.title), Software Development",
            author: blogPost.author,
            canonicalUrl: "https://dvos.me\(blogPost.path)",
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
            <div class="container blog-container">
                \(BlogComponent.renderFull(post: blogPost))
            </div>
        </body>
        </html>
        """
        return HTTPResponse.htmlResponse(htmlBody: body)
    }
}

/// Helper class to create and register all blog post routes
class BlogPages {
    /// All individual blog post pages
    let pages: [BlogPostPage]

    /// The blog list page
    let listPage: BlogListPage

    init() {
        listPage = BlogListPage()
        pages = BlogComponent.posts.map { BlogPostPage(blogPost: $0) }
    }

    /// Register all blog routes (list + individual posts) with the router
    func registerRoutes(router: Router) {
        // Register the blog list page
        router.register(listPage.route)

        // Register each individual blog post page
        for page in pages {
            router.register(page.route)
        }
    }
}
