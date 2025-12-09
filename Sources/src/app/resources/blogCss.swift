import Foundation

class BlogCss: Page {
    let title: String = "Blog CSS"
    lazy var route: Route = .init(
        path: "/blog.css",
        handler: { [weak self] request in
            guard let self = self else {
                return ErrorPage.staticErrorResponse
            }
            return self.render(request: request)
        }
    )

    func render(request _: HTTPRequest?) -> Data {
        let css = """
        /* Blog Grid */
        .blog-grid {
            display: grid;
            gap: 32px;
        }

        /* Blog Card */
        .blog-card {
            background: white;
            border-radius: 8px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            overflow: hidden;
            transition: transform 0.2s ease, box-shadow 0.2s ease;
        }

        .blog-card:hover {
            transform: translateY(-4px);
            box-shadow: 0 6px 20px rgba(0,0,0,0.15);
        }

        .blog-card-link {
            display: flex;
            text-decoration: none;
            color: inherit;
            align-items: stretch;
        }

        .blog-card-image {
            flex-shrink: 0;
            width: 120px;
            min-height: 120px;
            display: flex;
            align-items: center;
            justify-content: center;
            background: #f9f9f9;
            padding: 24px;
        }

        .blog-card-image img {
            width: 64px;
            height: 64px;
            object-fit: contain;
        }

        .blog-card-content {
            flex: 1;
            padding: 24px;
        }

        .blog-date {
            font-size: 13px;
            color: #888;
            display: block;
            margin-bottom: 8px;
        }

        .blog-card-title {
            font-size: 20px;
            font-weight: 600;
            color: #333;
            margin-bottom: 8px;
            line-height: 1.3;
        }

        .blog-card-summary {
            font-size: 15px;
            color: #666;
            line-height: 1.5;
            margin-bottom: 12px;
        }

        .blog-read-more {
            font-size: 14px;
            color: #555;
            font-weight: 500;
        }

        /* Blog Post Page */
        .blog-container {
            max-width: 750px;
        }

        .blog-post {
            background: white;
            border-radius: 8px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            padding: 48px;
        }

        .blog-post-header {
            margin-bottom: 32px;
            padding-bottom: 24px;
            border-bottom: 1px solid #eee;
        }

        .blog-post-title {
            font-size: 36px;
            font-weight: 700;
            color: #333;
            line-height: 1.2;
            margin-bottom: 12px;
        }

        .blog-post-author {
            font-size: 15px;
            color: #666;
        }

        .blog-post-content {
            font-size: 17px;
            line-height: 1.8;
            color: #444;
        }

        .blog-post-content p {
            margin-bottom: 20px;
        }

        .blog-post-content h3 {
            font-size: 22px;
            font-weight: 600;
            color: #333;
            margin-top: 32px;
            margin-bottom: 16px;
        }

        .blog-post-content ul {
            margin-bottom: 20px;
            padding-left: 24px;
        }

        .blog-post-content li {
            margin-bottom: 8px;
        }

        .blog-post-content code {
            background: #f4f4f4;
            padding: 2px 6px;
            border-radius: 4px;
            font-family: 'Courier New', monospace;
            font-size: 0.9em;
            color: #e83e8c;
        }

        .blog-post-content a.fancy-link {
            color: #0066cc;
            text-decoration: none;
            border-bottom: 2px solid #0066cc;
            transition: all 0.2s ease;
        }

        .blog-post-content a.fancy-link:hover {
            color: #004499;
            border-bottom-color: #004499;
            background: rgba(0, 102, 204, 0.1);
        }

        .blog-post-content .text-shadow {
            text-shadow: 2px 2px 0px rgba(0, 0, 0, 0.15);
            font-weight: 600;
        }

        .blog-post-content .tilt {
            display: inline-block;
            transform: rotate(-3deg);
            font-style: normal;
        }

        .blog-post-content .strikethrough {
            text-decoration: line-through;
            opacity: 0.7;
        }

        .blog-post-footer {
            margin-top: 40px;
            padding-top: 24px;
            border-top: 1px solid #eee;
        }

        @media (max-width: 768px) {
            .blog-card-link {
                flex-direction: column;
            }

            .blog-card-image {
                width: 100%;
                height: 100px;
            }

            .blog-post {
                padding: 24px;
            }

            .blog-post-title {
                font-size: 28px;
            }

            .blog-post-content {
                font-size: 16px;
            }
        }
        """
        return HTTPResponse.cssResponse(cssBody: css)
    }
}
