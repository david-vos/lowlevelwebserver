import Foundation

class WebServer {
    private let port: UInt16
    private var tcpSocket: TCPSocket?
    private var isRunning = false

    private let receiveTimeoutSeconds: Int
    private let maximumRequestSizeBytes: Int

    init(port: UInt16 = 8080, receiveTimeoutSeconds: Int = 30, maximumRequestSizeBytes: Int = 1_000_000) {
        self.port = port
        self.receiveTimeoutSeconds = receiveTimeoutSeconds
        self.maximumRequestSizeBytes = maximumRequestSizeBytes
    }

    func start() {
        print("Starting web server on port \(port)...")

        let socket = TCPSocket(port: port)
        assert(socket.create(), "Failed to create socket")
        assert(socket.bind(), "Failed to bind to port \(port)")
        assert(socket.listen(), "Failed to liston on socket")
        print("Socket listening for connections")

        tcpSocket = socket
        isRunning = true

        print("Server started. Listening on port \(port)")
        print("Press Ctrl+C to stop the server\n")

        main(socket: socket)

        print("Server stopped")
    }

    func main(socket: TCPSocket) {
        while isRunning {
            let clientSocketFileDescriptor = socket.accept()
            if clientSocketFileDescriptor < 0 {
                print("Error: Failed to accept connection")
                continue
            }

            print("New connection accepted (socket: \(clientSocketFileDescriptor))")
            let requestStartTime = Date()

            let connection = TCPConnection(
                clientSocketFileDescriptor: clientSocketFileDescriptor,
                receiveTimeoutSeconds: receiveTimeoutSeconds,
                maximumRequestSizeBytes: maximumRequestSizeBytes
            )

            if let receivedData = connection.readUntilHeadersEnd(bufferSize: 4096) {
                print("  Received \(receivedData.count) total bytes")

                if let httpRequest = HTTPParser.parse(receivedData) {
                    print("Method: \(httpRequest.method.rawValue)")
                    print("URL: \(httpRequest.url)")
                    print("Version: \(httpRequest.version)")

                    let htmlResponse = HTTPResponse.htmlResponse(htmlBody: HTTPResponse.defaultHTML)

                    if connection.write(htmlResponse) {
                        print("Sent HTML response (\(htmlResponse.count) bytes)")
                    } else {
                        print("Failed to send response")
                    }
                } else {
                    print("Failed to parse HTTP request")
                }
            } else {
                print("No data received or connection error")
            }

            connection.close()
            let requestDuration = Date().timeIntervalSince(requestStartTime)
            print("Request processed in \(String(format: "%.9f", requestDuration)) seconds")
            print("Connection closed\n")
        }
    }

    func stop() {
        print("\n Stopping server...")
        isRunning = false
        tcpSocket?.close()
        tcpSocket = nil
    }
}
