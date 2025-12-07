import Foundation
#if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
    import Darwin
#elseif os(Linux)
    import Glibc
#endif

/// Platform-agnostic socket helper functions written by AI...
/// Abstracts away Darwin vs Glibc differences
enum SocketHelpers {
    /// Closes a file descriptor (socket)
    /// - Parameter fileDescriptor: The socket file descriptor to close
    static func close(_ fileDescriptor: Int32) {
        #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
            Darwin.close(fileDescriptor)
        #elseif os(Linux)
            Glibc.close(fileDescriptor)
        #endif
    }

    /// Creates a TCP socket
    /// - Returns: Socket file descriptor, or -1 on error
    static func socket() -> Int32 {
        #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
            return Darwin.socket(AF_INET, SOCK_STREAM, 0)
        #elseif os(Linux)
            return Glibc.socket(AF_INET, SOCK_STREAM, 0)
        #endif
    }

    /// Binds a socket to an address
    /// - Parameters:
    ///   - fileDescriptor: The socket file descriptor to bind
    ///   - address: Pointer to the socket address structure (sockaddr)
    ///   - length: Size of the address structure in bytes
    /// - Returns: 0 on success, -1 on error
    static func bind(_ fileDescriptor: Int32, _ address: UnsafePointer<sockaddr>, _ length: socklen_t) -> Int32 {
        #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
            return Darwin.bind(fileDescriptor, address, length)
        #elseif os(Linux)
            return Glibc.bind(fileDescriptor, address, length)
        #endif
    }

    /// Starts listening on a socket
    /// - Parameters:
    ///   - fileDescriptor: The socket file descriptor to listen on
    ///   - backlog: Maximum length of the queue of pending connections
    /// - Returns: 0 on success, -1 on error
    static func listen(_ fileDescriptor: Int32, _ backlog: Int32) -> Int32 {
        #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
            return Darwin.listen(fileDescriptor, backlog)
        #elseif os(Linux)
            return Glibc.listen(fileDescriptor, backlog)
        #endif
    }

    /// Accepts an incoming connection
    /// - Parameters:
    ///   - fileDescriptor: The server socket file descriptor
    ///   - address: Pointer to store the client's address (will be filled by accept)
    ///   - length: Pointer to the size of the address structure (input/output parameter)
    /// - Returns: Client socket file descriptor, or -1 on error
    static func accept(_ fileDescriptor: Int32, _ address: UnsafeMutablePointer<sockaddr>, _ length: UnsafeMutablePointer<socklen_t>) -> Int32 {
        #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
            return Darwin.accept(fileDescriptor, address, length)
        #elseif os(Linux)
            return Glibc.accept(fileDescriptor, address, length)
        #endif
    }

    /// Receives data from a socket
    /// - Parameters:
    ///   - fileDescriptor: The socket file descriptor to read from
    ///   - buffer: Pointer to the buffer where received data will be stored
    ///   - length: Maximum number of bytes to read (buffer size)
    ///   - flags: Optional flags (usually 0)
    /// - Returns: Number of bytes received, 0 if connection closed, -1 on error
    static func recv(_ fileDescriptor: Int32, _ buffer: UnsafeMutablePointer<UInt8>, _ length: Int, _ flags: Int32 = 0) -> Int {
        #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
            return Darwin.recv(fileDescriptor, buffer, length, flags)
        #elseif os(Linux)
            return Glibc.recv(fileDescriptor, buffer, length, flags)
        #endif
    }

    /// Sends data to a socket
    /// - Parameters:
    ///   - fileDescriptor: The socket file descriptor to write to
    ///   - buffer: Pointer to the data to send
    ///   - length: Number of bytes to send
    ///   - flags: Optional flags (usually 0)
    /// - Returns: Number of bytes sent, -1 on error
    static func send(_ fileDescriptor: Int32, _ buffer: UnsafePointer<UInt8>, _ length: Int, _ flags: Int32 = 0) -> Int {
        #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
            return Darwin.send(fileDescriptor, buffer, length, flags)
        #elseif os(Linux)
            return Glibc.send(fileDescriptor, buffer, length, flags)
        #endif
    }

    /// Sets a socket option
    /// - Parameters:
    ///   - fileDescriptor: The socket file descriptor
    ///   - level: Option level (e.g., SOL_SOCKET)
    ///   - optionName: Option name (e.g., SO_RCVTIMEO)
    ///   - value: Pointer to the option value
    ///   - length: Size of the option value
    /// - Returns: 0 on success, -1 on error
    static func setSocketOption(_ fileDescriptor: Int32, _ level: Int32, _ optionName: Int32, _ value: UnsafeRawPointer, _ length: socklen_t) -> Int32 {
        #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
            return Darwin.setsockopt(fileDescriptor, level, optionName, value, length)
        #elseif os(Linux)
            return Glibc.setsockopt(fileDescriptor, level, optionName, value, length)
        #endif
    }
}

/// Extension on Int32 to provide a convenient close() method for socket file descriptors
extension Int32 {
    /// Closes this socket file descriptor
    func close() {
        SocketHelpers.close(self)
    }
}
