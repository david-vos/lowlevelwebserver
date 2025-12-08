import Foundation

class FaviconPage: Page {
    let title: String = "Favicon"

    lazy var route: Route = .init(
        path: "/favicon.ico",
        handler: { [weak self] request in
            guard let self = self else {
                return ErrorPage.staticErrorResponse
            }
            return self.render(request: request)
        }
    )

    func render(request _: HTTPRequest?) -> Data {
        guard let faviconURL = Bundle.module.url(
            forResource: "favicon", withExtension: "ico", subdirectory: "image"
        ) else {
            return ErrorPage.staticErrorResponse
        }

        guard let faviconData = try? Data(contentsOf: faviconURL) else {
            return ErrorPage.staticErrorResponse
        }

        return HTTPResponse.binaryResponse(
            contentType: "image/x-icon",
            body: faviconData
        )
    }
}
