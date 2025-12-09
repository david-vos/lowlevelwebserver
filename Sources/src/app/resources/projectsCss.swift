import Foundation

class ProjectsCss: Page {
    let title: String = "Projects CSS"
    lazy var route: Route = .init(
        path: "/projects.css",
        handler: { [weak self] request in
            guard let self = self else {
                return ErrorPage.staticErrorResponse
            }
            return self.render(request: request)
        }
    )

    func render(request _: HTTPRequest?) -> Data {
        let css = """
        .projects-grid {
            margin-top: 16px;
        }

        .item {
            display: flex;
            align-items: center;
            gap: 40px;
            margin-bottom: 80px;
        }

        .item.reverse {
            flex-direction: row-reverse;
        }

        .text-content {
            flex: 1;
        }

        .text-content h2 {
            font-size: 24px;
            font-weight: 600;
            margin-bottom: 16px;
            color: #333;
            transition: transform 0.2s ease, color 0.2s ease;
            display: inline-block;
        }

        .title-link {
            text-decoration: none;
            color: inherit;
            display: inline-block;
        }

        .title-link:hover h2 {
            transform: scale(1.03);
            color: #555;
        }

        .text-content p {
            font-size: 16px;
            color: #666;
        }

        .box-content {
            flex: 1;
        }

        .box-link {
            display: block;
            text-decoration: none;
            color: inherit;
        }

        .box {
            width: 100%;
            aspect-ratio: 1;
            background: white;
            border-radius: 8px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 18px;
            color: #666;
            transition: transform 0.2s ease, box-shadow 0.2s ease;
            overflow: hidden;
            position: relative;
        }

        .box-image {
            width: 100%;
            height: 100%;
            object-fit: cover;
        }

        .box-overlay {
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: linear-gradient(135deg, transparent 0%, rgba(0,0,0,0.15) 100%);
            pointer-events: none;
            transition: background 0.2s ease;
        }

        .box-link:hover .box {
            transform: translateY(-4px);
            box-shadow: 0 6px 20px rgba(0,0,0,0.15);
        }

        .box-link:hover .box-overlay {
            background: linear-gradient(135deg, transparent 0%, rgba(0,0,0,0.3) 100%);
        }

        @media (max-width: 768px) {
            .item {
                flex-direction: column !important;
                gap: 24px;
                margin-bottom: 60px;
            }

            .text-content {
                order: 1;
                flex: none;
                width: 100%;
            }

            .box-content {
                order: 2;
                flex: none;
                width: 100%;
            }

            .box {
                max-width: 100%;
                width: 100%;
            }
        }
        """
        return HTTPResponse.cssResponse(cssBody: css)
    }
}
