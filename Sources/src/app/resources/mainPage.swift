import Foundation

class MainPage: Page {
    let title: String = "Main Page"
    lazy var route: Route = .init(
        path: "/",
        handler: { [weak self] request in
            guard let self = self else {
                return ErrorPage.staticErrorResponse
            }
            return self.render(request: request)
        }
    )

    func render(request _: HTTPRequest?) -> Data {
        let body = """
        <!DOCTYPE html>
        <html lang="en">
        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>\(title)</title>
            <link rel="icon" type="image/x-icon" href="/favicon.ico">
            <link rel="stylesheet" href="/main.css">
        </head>
        <body>
            <div class="container">
                <header class="header-box">
                    <h1 class="header-title">Your Name</h1>
                    <p class="header-subtitle">Your Subtitle</p>
                    <div class="social-icons">
                        <a href="#" class="social-icon">🔗</a>
                        <a href="#" class="social-icon">🔗</a>
                        <a href="#" class="social-icon">🔗</a>
                        <a href="#" class="social-icon">🔗</a>
                    </div>
                </header>

                <div class="item">
                    <div class="text-content">
                        <h2>Title 1</h2>
                        <p>Text content goes here</p>
                    </div>
                    <div class="box-content">
                        <div class="box">Box</div>
                    </div>
                </div>

                <div class="item reverse">
                    <div class="text-content">
                        <h2>Title 2</h2>
                        <p>Text content goes here</p>
                    </div>
                    <div class="box-content">
                        <div class="box">Box</div>
                    </div>
                </div>

                <div class="item">
                    <div class="text-content">
                        <h2>Title 3</h2>
                        <p>Text content goes here</p>
                    </div>
                    <div class="box-content">
                        <div class="box">Box</div>
                    </div>
                </div>

                <div class="item reverse">
                    <div class="text-content">
                        <h2>Title 4</h2>
                        <p>Text content goes here</p>
                    </div>
                    <div class="box-content">
                        <div class="box">Box</div>
                    </div>
                </div>

                <div class="item">
                    <div class="text-content">
                        <h2>Title 5</h2>
                        <p>Text content goes here</p>
                    </div>
                    <div class="box-content">
                        <div class="box">Box</div>
                    </div>
                </div>

                <div class="item reverse">
                    <div class="text-content">
                        <h2>Title 6</h2>
                        <p>Text content goes here</p>
                    </div>
                    <div class="box-content">
                        <div class="box">Box</div>
                    </div>
                </div>
            </div>
        </body>
        </html>
        """
        return HTTPResponse.htmlResponse(htmlBody: body)
    }
}
