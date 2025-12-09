import Dispatch
import Foundation

class WebServer {
    private let port: UInt16
    private var tcpSocket: TCPSocket?
    private var isRunning = false
    private let router: Router

    private let receiveTimeoutSeconds: Int
    private let maximumRequestSizeBytes: Int

    /// Concurrent queue for handling multiple connections simultaneously
    private let connectionQueue = DispatchQueue(
        label: "com.webserver.connections",
        attributes: .concurrent
    )

    init(
        port: UInt16 = 8080,
        receiveTimeoutSeconds: Int = 5,
        maximumRequestSizeBytes: Int = 1_000_000,
        router: Router = Router()
    ) {
        self.port = port
        self.receiveTimeoutSeconds = receiveTimeoutSeconds
        self.maximumRequestSizeBytes = maximumRequestSizeBytes
        self.router = router
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

            // Handle each connection concurrently
            connectionQueue.async { [weak self] in
                self?.handleConnection(clientSocketFileDescriptor: clientSocketFileDescriptor)
            }
        }
    }

    private func handleConnection(clientSocketFileDescriptor: Int32) {
        print("New connection accepted (socket: \(clientSocketFileDescriptor))")
        let requestStartTime = Date()

        let connection = TCPConnection(
            clientSocketFileDescriptor: clientSocketFileDescriptor,
            receiveTimeoutSeconds: receiveTimeoutSeconds,
            maximumRequestSizeBytes: maximumRequestSizeBytes
        )

        defer {
            connection.close()
            let requestDuration = Date().timeIntervalSince(requestStartTime)
            print("Request processed in \(String(format: "%.4f", requestDuration))s (socket: \(clientSocketFileDescriptor))\n")
        }

        guard let receivedData = connection.readUntilHeadersEnd(bufferSize: 4096) else {
            // No data received - likely a preconnect or closed connection
            // Just close silently without sending error
            return
        }

        print("  Received \(receivedData.count) bytes (socket: \(clientSocketFileDescriptor))")

        guard let httpRequest = HTTPParser.parse(receivedData) else {
            let errorResponse = ErrorPage.staticErrorResponse
            _ = connection.write(errorResponse)
            return
        }

        print("  \(httpRequest.method.rawValue) \(httpRequest.url) (socket: \(clientSocketFileDescriptor))")

        let response = router.navigate(
            path: httpRequest.url, request: httpRequest
        )

        if connection.write(response) {
            print("  Sent \(response.count) bytes (socket: \(clientSocketFileDescriptor))")
        } else {
            print("  Failed to send response (socket: \(clientSocketFileDescriptor))")
        }
    }

    func stop() {
        print("\n Stopping server...")
        isRunning = false
        tcpSocket?.close()
        tcpSocket = nil
    }
}
