import Foundation

enum HTTPMethod: String, CaseIterable {
    case GET
    case POST
    case PUT
    case DELETE
    case PATCH
    case HEAD
    case OPTIONS
    case TRACE
    case CONNECT

    /// Creates an HTTPMethod from a string, returning nil if invalid
    init?(rawValue: String) {
        let uppercased = rawValue.uppercased()
        if let method = HTTPMethod.allCases.first(where: { $0.rawValue == uppercased }) {
            self = method
        } else {
            return nil
        }
    }
}

struct HTTPRequest {
    let method: HTTPMethod
    let url: String
    let version: String
}

/// Parses the HTTP request from raw TCP data
/// - Parameter data: The raw TCP stream data received from the client
/// - Returns: Parsed HTTPRequest, or nil if parsing fails
/// HTTP Request Format:
/// ```
/// GET /index.html HTTP/1.1\r\n
/// Host: localhost:9613\r\n
/// User-Agent: curl/7.68.0\r\n
/// \r\n
/// ```
class HTTPParser {
    static func parse(_ data: Data) -> HTTPRequest? {
        guard let requestString = String(data: data, encoding: .utf8) else { return nil }
        let lines = requestString.components(separatedBy: .newlines)

        // Find the first non-empty line (the request line)
        // Skip any empty lines that might come before it
        guard let requestLine = lines.first(where: { !$0.trimmingCharacters(in: .whitespaces).isEmpty }) else {
            return nil
        }

        // URLs should not contain spaces (they should be %20 encoded),
        let trimmedRequestLine = requestLine.trimmingCharacters(in: .whitespaces)

        // Split by spaces, but handle multiple spaces
        let requestLineComponents = trimmedRequestLine.components(separatedBy: " ")
            .filter { !$0.isEmpty }

        guard requestLineComponents.count == 3 else { return nil }

        let methodString = requestLineComponents[0].uppercased()
        let url = requestLineComponents[1]
        let version = requestLineComponents[2].uppercased()

        guard let method = HTTPMethod(rawValue: methodString) else { return nil }
        guard url.hasPrefix("/") else { return nil }
        guard version.hasPrefix("HTTP/") else { return nil }

        return HTTPRequest(method: method, url: url, version: version)
    }
}
