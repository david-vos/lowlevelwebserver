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
        .container.home {
            min-height: 50vh;
            display: flex;
            flex-direction: column;
            justify-content: flex-end;
            padding-top: 0;
            padding-bottom: 0;
        }

        .container.home .header-box {
            margin-bottom: 20px;
        }

        .container.home .main-nav {
            margin-top: 0;
            margin-bottom: 0;
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

        .main-nav {
            display: flex;
            justify-content: center;
            gap: 24px;
            margin-top: -60px;
            margin-bottom: 80px;
        }

        .nav-link {
            display: inline-block;
            padding: 12px 32px;
            background: white;
            border-radius: 8px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            text-decoration: none;
            color: #333;
            font-weight: 500;
            font-size: 16px;
            transition: transform 0.2s ease, box-shadow 0.2s ease;
        }

        .nav-link:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 15px rgba(0,0,0,0.15);
        }

        @media (max-width: 768px) {
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
        }
        """
        return HTTPResponse.cssResponse(cssBody: css)
    }
}
