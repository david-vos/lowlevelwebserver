import Foundation

let router = Router()

let mainPage = MainPage()
let commonCss = CommonCss()
let mainCss = MainCss()
let blogCss = BlogCss()
let projectsCss = ProjectsCss()
let blogPages = BlogPages()
let projectsPage = ProjectsPage()

router.register(mainPage.route)
router.register(commonCss.route)
router.register(mainCss.route)
router.register(blogCss.route)
router.register(projectsCss.route)
router.register(projectsPage.route)
blogPages.registerRoutes(router: router)
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
