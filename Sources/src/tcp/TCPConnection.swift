import Foundation
#if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
    import Darwin
#elseif os(Linux)
    import Glibc
#endif

/// Represents a TCP connection to a client
class TCPConnection {
    private let clientSocketFileDescriptor: Int32
    private let receiveTimeoutSeconds: Int
    private let maximumRequestSizeBytes: Int

    init(clientSocketFileDescriptor: Int32, receiveTimeoutSeconds: Int = 30, maximumRequestSizeBytes: Int = 1_000_000) {
        self.clientSocketFileDescriptor = clientSocketFileDescriptor
        self.receiveTimeoutSeconds = receiveTimeoutSeconds
        self.maximumRequestSizeBytes = maximumRequestSizeBytes

        var timeout = timeval()
        #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
            timeout.tv_sec = Int(receiveTimeoutSeconds) // Seconds (Int on Darwin)... Thx AI
        #elseif os(Linux)
            timeout.tv_sec = Int32(receiveTimeoutSeconds) // Seconds (Int32 on Linux)... Thx AI
        #endif
        timeout.tv_usec = 0

        let timeoutLength = socklen_t(MemoryLayout<timeval>.size)
        _ = SocketHelpers.setSocketOption(
            clientSocketFileDescriptor,
            SOL_SOCKET,
            SO_RCVTIMEO,
            &timeout,
            timeoutLength
        )
    }

    /// Reads data from the socket into a buffer
    /// - Parameter bufferSize: Maximum number of bytes to read in one call
    /// - Returns: The data read, or nil on error/connection closed
    func read(bufferSize: Int = 4096) -> Data? {
        var buffer = [UInt8](repeating: 0, count: bufferSize)

        // recv() returns:
        // if response > 0: Number of bytes actually read
        // if response == 0: Connection closed by client
        // if reponse == -1: Error occurred
        let bytesReceived = buffer.withUnsafeMutableBufferPointer { bufferPointer in
            SocketHelpers.recv(clientSocketFileDescriptor, bufferPointer.baseAddress!, bufferSize, 0)
        }

        if bytesReceived < 0 {
            // Error reading from socket
            return nil
        }

        if bytesReceived == 0 { return nil } // Connection closed by client}

        // Create a Data object containing only the bytes we actually received
        return Data(buffer.prefix(bytesReceived))
    }

    /// Reads data until the end of HTTP headers is found (\r\n\r\n)
    /// - Parameter bufferSize: Size of each read chunk (default 4096 bytes)
    /// - Returns: All data up to and including \r\n\r\n, or nil on error/timeout/size limit exceeded
    func readUntilHeadersEnd(bufferSize: Int = 4096) -> Data? {
        var allData = Data()
        let startTime = Date()

        // The HTTP header terminator: \r\n\r\n (double CRLF)
        // This marks the end of HTTP headers and start of body (if any)
        guard let headerTerminator = "\r\n\r\n".data(using: .utf8) else {
            return nil
        }

        // Keep reading until we find \r\n\r\n, timeout, or size limit
        while true {
            if allData.count >= maximumRequestSizeBytes {
                print("Request size limit exceeded (\(allData.count) bytes >= \(maximumRequestSizeBytes) bytes)")
                return nil
            }

            let elapsedSeconds = Date().timeIntervalSince(startTime)
            if elapsedSeconds >= Double(receiveTimeoutSeconds) {
                print("Receive timeout exceeded (\(Int(elapsedSeconds))s >= \(receiveTimeoutSeconds)s)")
                return nil
            }

            guard let chunk = read(bufferSize: bufferSize) else {
                // Connection closed or error/timeout
                // If we have some data, return it (might be a complete request if client closed)
                return allData.isEmpty ? nil : allData
            }

            allData.append(chunk)

            // Check if we've received the header terminator (\r\n\r\n)
            if allData.range(of: headerTerminator) != nil {
                return allData
            }
        }
    }

    /// Writes data to the socket
    /// - Parameter data: The data to send
    /// - Returns: true if all data was sent successfully, false on error
    func write(_ data: Data) -> Bool {
        var offset = 0
        let totalBytes = data.count

        // Keep sending until all data is sent
        while offset < totalBytes {
            let remainingBytes = totalBytes - offset
            var result = 0

            data.withUnsafeBytes { bufferPointer in
                let baseAddress = bufferPointer.baseAddress!.assumingMemoryBound(to: UInt8.self)
                result = SocketHelpers.send(
                    clientSocketFileDescriptor,
                    baseAddress.advanced(by: offset),
                    remainingBytes,
                    0
                )
            }

            if result < 0 { return false } // Error occurred
            if result == 0 { return false } // Connection closed

            offset += result
        }

        return offset == totalBytes
    }

    /// Closes the connection
    func close() {
        SocketHelpers.close(clientSocketFileDescriptor)
    }
}
