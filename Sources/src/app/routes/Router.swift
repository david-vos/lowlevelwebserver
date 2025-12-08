import Foundation

class Router {
    private var routes: [String: Route] = [:]

    func register(_ route: Route) {
        routes[route.path] = route
    }

    /// Register a binary resource (image, file, etc.) from the bundle
    /// - Parameters:
    ///   - path: The URL path where the resource will be served (e.g., "/favicon.ico")
    ///   - contentType: The MIME content type (e.g., "image/x-icon", "image/png")
    ///   - bundlePath: The path to the resource in the bundle (e.g., "image/favicon.ico")
    func registerResource(path: String, contentType: String, bundlePath: String) {
        let route = Route(
            path: path,
            handler: { _ in
                guard let resourceURL = Bundle.module.resourceURL?.appendingPathComponent(bundlePath),
                      let resourceData = try? Data(contentsOf: resourceURL)
                else {
                    return ErrorPage.staticErrorResponse
                }
                return HTTPResponse.binaryResponse(contentType: contentType, body: resourceData)
            }
        )
        register(route)
    }

    // Returns the socket payload for the requested path
    func navigate(path: String, request: HTTPRequest?) -> Data {
        guard let route = routes[path] else {
            return HTTPResponse.htmlResponse(
                statusCode: 404,
                statusText: "Not Found",
                htmlBody: HTTPResponse.pageNotFoundHTML
            )
        }
        return route.handler(request)
    }
}

struct Route {
    let path: String
    let handler: (HTTPRequest?) -> Data
}

protocol Page {
    var route: Route { get }
    var title: String { get }
    func render(request: HTTPRequest?) -> Data
}
