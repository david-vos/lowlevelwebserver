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
            padding: 40px;
            border-radius: 8px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            text-align: left;
            margin-bottom: 80px;
        }
        
        .header-title {
            font-size: 32px;
            font-weight: 600;
            margin-bottom: 12px;
            color: #333;
        }
        
        .header-subtitle {
            font-size: 18px;
            color: #666;
            margin-bottom: 24px;
        }
        
        .social-icons {
            display: flex;
            justify-content: flex-start;
            gap: 16px;
        }
        
        .social-icon {
            font-size: 24px;
            text-decoration: none;
            transition: transform 0.2s;
            display: inline-block;
        }
        
        .social-icon:hover {
            transform: scale(1.2);
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
            
            .item {
                flex-direction: column !important;
                gap: 24px;
                margin-bottom: 60px;
            }
            
            .text-content {
                order: 1;
            }
            
            .box-content {
                order: 2;
            }
        }
        """
        return HTTPResponse.cssResponse(cssBody: css)
    }
}
