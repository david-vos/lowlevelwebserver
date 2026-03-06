import Foundation

let router = Router()

let mainPage = MainPage()
let coloursCss = ColoursCss()
let commonCss = CommonCss()
let mainCss = MainCss()
let blogCss = BlogCss()
let projectsCss = ProjectsCss()
let blogPages = BlogPages()
let projectsPage = ProjectsPage()
let healthCheck = HealthCheck()

router.register(mainPage.route)
router.register(coloursCss.route)
router.register(commonCss.route)
router.register(mainCss.route)
router.register(blogCss.route)
router.register(projectsCss.route)
router.register(projectsPage.route)
router.register(healthCheck.route)
blogPages.registerRoutes(router: router)
router.registerResource(
    path: "/favicon.ico",
    contentType: "image/x-icon",
    bundlePath: "image/favicon.ico"
)
router.registerResource(
    path: "/cv",
    contentType: "application/pdf",
    bundlePath: "image/resume.pdf"
)
router.registerResource(
    path: "/fonts/RobotoMono-Regular.ttf",
    contentType: "font/ttf",
    bundlePath: "fonts/RobotoMono-Regular.ttf"
)
router.registerResource(
    path: "/fonts/RobotoMono-Bold.ttf",
    contentType: "font/ttf",
    bundlePath: "fonts/RobotoMono-Bold.ttf"
)
router.registerResource(
    path: "/fonts/RobotoMono-Italic.ttf",
    contentType: "font/ttf",
    bundlePath: "fonts/RobotoMono-Italic.ttf"
)

let server = WebServer(port: 9613, router: router)

signal(SIGINT) { _ in
    server.stop()
    exit(0)
}

server.start()
