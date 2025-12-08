import Foundation

let router = Router()

let mainPage = MainPage()
let mainCss = MainCss()

router.register(mainPage.route)
router.register(mainCss.route)
router.registerResource(
    path: "/favicon.ico",
    contentType: "image/x-icon",
    bundlePath: "image/favicon.ico"
)

let server = WebServer(port: 9613, router: router)

signal(SIGINT) { _ in
    server.stop()
    exit(0)
}

server.start()
