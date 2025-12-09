import Foundation

class HeadComponent {
    struct HeadConfig {
        let title: String
        let description: String
        let keywords: String
        let author: String
        let canonicalUrl: String
        let faviconPath: String
        let stylesheetPath: String
        let lang: String

        static let `default` = HeadConfig(
            title: "David Vos - Software Developer",
            description: "David Vos is a Software Developer based in Flevoland, Netherlands. Skilled in Web Development, Game Development, and creating interactive art.",
            keywords: "David Vos, David Vos Software, David Vos Developer, LocalVos, Vos, David Vos Software Developer, David Vos Software Engineer, Netherlands, Flevoland, Web Development, Game Development, Interactive Art",
            author: "David Vos",
            canonicalUrl: "https://dvos.me",
            faviconPath: "/favicon.ico",
            stylesheetPath: "/main.css",
            lang: "en"
        )
    }

    static func render(config: HeadConfig = .default) -> String {
        return """
        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>\(config.title)</title>
            <meta name="description" content="\(config.description)">
            <meta name="keywords" content="\(config.keywords)">
            <meta name="author" content="\(config.author)">
            <link rel="canonical" href="\(config.canonicalUrl)">
            <link rel="icon" type="image/x-icon" href="\(config.faviconPath)">
            <link rel="stylesheet" href="\(config.stylesheetPath)">
        </head>
        """
    }
}
