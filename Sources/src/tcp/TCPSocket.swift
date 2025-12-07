import Foundation

class TCPSocket {
    private var socketFileDescriptor: Int32?
    private let port: UInt16
    private var isBound = false
    private var isListening = false

    init(port: UInt16) {
        self.port = port
    }

    deinit {
        close()
    }

    /// Returns true if successful, false otherwise
    func create() -> Bool {
        // socket() creates an endpoint for communication
        // AF_INET = IPv4 address family
        // SOCK_STREAM = TCP (reliable, connection-oriented)
        // 0 = let system choose the protocol (TCP for SOCK_STREAM)
        // Thx AI
        socketFileDescriptor = SocketHelpers.socket()

        guard let fileDescriptor = socketFileDescriptor, fileDescriptor >= 0 else {
            return false
        }

        // Set socket option to reuse address
        // This allows the port to be reused immediately after the server stops
        // Without this, you'd have to wait ~30 seconds after stopping the serverAddress
        // Thx AI
        var reuseAddress: Int32 = 1
        setsockopt(fileDescriptor, SOL_SOCKET, SO_REUSEADDR, &reuseAddress, socklen_t(MemoryLayout<Int32>.size))

        return true
    }

    /// Returns true if successful, false otherwise
    func bind() -> Bool {
        guard let fileDescriptor = socketFileDescriptor else { return false }
        var serverAddress = sockaddr_in()
        serverAddress.sin_family = sa_family_t(AF_INET)
        serverAddress.sin_port = port.bigEndian
        serverAddress.sin_addr.s_addr = INADDR_ANY.bigEndian

        // Convert sockaddr_in to sockaddr (required by bind())
        // sockaddr is a generic structure that can represent different address families
        // We need to cast because bind() expects a sockaddr pointer, not sockaddr_in
        // Thx AI
        let bindAddress = withUnsafePointer(to: &serverAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) { $0 }
        }

        // bind() associates the socket with a specific address/port
        let addressLength = socklen_t(MemoryLayout<sockaddr_in>.size)
        let bindResult = SocketHelpers.bind(fileDescriptor, bindAddress, addressLength)

        if bindResult < 0 {
            return false
        }

        isBound = true
        return true
    }

    /// - backlog: Maximum length of the queue of pending connections
    /// Returns true if successful, false otherwise
    func listen(backlog: Int32 = 128) -> Bool {
        guard let fileDescriptor = socketFileDescriptor, isBound else { return false }

        let listenResult = SocketHelpers.listen(fileDescriptor, backlog)

        if listenResult < 0 {
            return false
        }

        isListening = true
        return true
    }

    /// Blocks until a client connects
    /// Returns the client socket file descriptor, or -1 on error
    func accept() -> Int32 {
        guard let fileDescriptor = socketFileDescriptor, isListening else { return -1 }

        // accept() blocks until a client connects
        // It returns a new socket file descriptor for the client connection
        var clientAddress = sockaddr_in()
        var clientAddressLength = socklen_t(MemoryLayout<sockaddr_in>.size)

        let clientSocketFileDescriptor = withUnsafeMutablePointer(to: &clientAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) { addressPointer in
                SocketHelpers.accept(fileDescriptor, addressPointer, &clientAddressLength)
            }
        }

        return clientSocketFileDescriptor
    }

    func close() {
        if let fileDescriptor = socketFileDescriptor {
            SocketHelpers.close(fileDescriptor)
            socketFileDescriptor = nil
            isBound = false
            isListening = false
        }
    }
}
