import Foundation

class MainCss: Page {
    let title: String = "Main CSS"
    lazy var route: Route = .init(
        path: "/main.css",
        handler: { [weak self] request in
            guard let self = self else {
                return ErrorPage.staticErrorResponse
            }
            return self.render(request: request)
        }
    )

    func render(request _: HTTPRequest?) -> Data {
        let css = """
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
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

        .header-box {
            background: white;
            padding: 40px 40px 40px 30px;
            border-radius: 8px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            margin-bottom: 80px;
            display: flex;
            align-items: center;
            gap: 30px;
        }

        .header-content {
            flex: 1;
            text-align: left;
        }

        .header-image {
            flex-shrink: 0;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .profile-image {
            width: 150px;
            height: 150px;
            border-radius: 50%;
            object-fit: cover;
        }

        .header-title {
            font-size: 32px;
            font-weight: 600;
            margin-bottom: 12px;
            color: #333;
        }

        .header-name {
            font-size: 40px;
            display: block;
            margin-bottom: 2px;
        }

        .header-role {
            font-size: 22px;
            font-weight: 400;
            color: #777;
            display: block;
            margin-top: 0;
        }

        .header-subtitle {
            font-size: 16px;
            color: #666;
            margin-bottom: 24px;
            margin-left: 24px;
            padding-left: 16px;
            line-height: 1.6;
            font-style: italic;
            border-left: 2px solid #e0e0e0;
        }

        .social-icons {
            display: flex;
            justify-content: flex-start;
            gap: 12px;
        }

        .social-icon {
            text-decoration: none;
            transition: all 0.2s;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            width: 40px;
            height: 40px;
            border: 1.5px solid #d0d0d0;
            border-radius: 4px;
            background-color: #fafafa;
        }

        .social-icon img {
            display: block;
            width: 20px;
            height: 20px;
            opacity: 0.6;
        }

        .social-icon:hover {
            transform: scale(1.05);
            background-color: #f0f0f0;
            border-color: #b0b0b0;
        }

        .social-icon:hover img {
            opacity: 0.9;
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
        }

        .text-content p {
            font-size: 16px;
            color: #666;
        }

        .box-content {
            flex: 1;
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
        }

        @media (max-width: 768px) {
            .container {
                padding: 40px 16px;
            }
            
            .header-box {
                flex-direction: column;
                text-align: center;
                padding: 30px 20px;
                gap: 24px;
            }
            
            .profile-image {
                width: 120px;
                height: 120px;
            }
            
            .header-content {
                text-align: center;
            }
            
            .header-subtitle {
                margin-left: 0;
                padding-left: 0;
                border-left: none;
                border-top: 2px solid #e0e0e0;
                padding-top: 16px;
            }
            
            .social-icons {
                justify-content: center;
            }
            
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
