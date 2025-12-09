import Foundation

class CommonCss: Page {
    let title: String = "Common CSS"
    lazy var route: Route = .init(
        path: "/common.css",
        handler: { [weak self] request in
            guard let self = self else {
                return ErrorPage.staticErrorResponse
            }
            return self.render(request: request)
        }
    )

    func render(request _: HTTPRequest?) -> Data {
        let css = """
        /* Enable View Transitions API for cross-document navigations */
        @view-transition {
            navigation: auto;
        }

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        html {
            scroll-behavior: smooth;
        }

        /* Simple crossfade transition for the whole page */
        ::view-transition-old(root) {
            animation: 150ms ease-out both fade-out;
        }

        ::view-transition-new(root) {
            animation: 210ms ease-in 90ms both fade-in;
        }

        @keyframes fade-out {
            to { opacity: 0; }
        }

        @keyframes fade-in {
            from { opacity: 0; }
        }

        body {
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Oxygen, Ubuntu, Cantarell, sans-serif;
            background: #f5f5f5;
            color: #333;
            line-height: 1.6;
            min-height: 100vh;
        }

        .container {
            max-width: 900px;
            margin: 0 auto;
            padding: 60px 20px;
        }

        /* Shared back link style */
        .back-link {
            display: inline-block;
            color: #666;
            text-decoration: none;
            font-size: 14px;
            margin-bottom: 24px;
            transition: color 0.2s ease;
        }

        .back-link:hover {
            color: #333;
        }

        /* Shared page header style */
        .page-header {
            text-align: center;
            margin-bottom: 48px;
        }

        .page-title {
            font-size: 48px;
            font-weight: 700;
            color: #333;
            margin-bottom: 12px;
        }

        .page-subtitle {
            font-size: 18px;
            color: #666;
        }

        @media (max-width: 768px) {
            .container {
                padding: 40px 16px;
            }

            .page-title {
                font-size: 36px;
            }
        }
        """
        return HTTPResponse.cssResponse(cssBody: css)
    }
}
