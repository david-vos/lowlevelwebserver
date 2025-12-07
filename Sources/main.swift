import Foundation

let server = WebServer(port: 9613)

signal(SIGINT) { _ in
    server.stop()
    exit(0)
}

server.start()
