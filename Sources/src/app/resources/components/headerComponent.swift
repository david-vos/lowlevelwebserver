import Foundation

class HeaderComponent {
    static let quotes: [String] = [
        "Living in constant fear of a Windows 11 update.<br>Each morning I wake up wondering if the Microsoft overlords<br>will play with my soul and kill any unsaved document I have open.",
        "Writing slow code that breaks any and all Neovim setups since 2005.",
        "I would rather spend 4 years learning how to be a car mechanic then be forced to work with MATLAB.",
        "If I have to write 1 more line of Groovy code, I will personally fly to your house and delete your project.",
    ]

    struct SocialLink {
        let url: String
        let iconUrl: String
        let altText: String
        let ariaLabel: String
    }

    static let socialLinks: [SocialLink] = [
        SocialLink(
            url: "https://github.com/david-vos",
            iconUrl: "https://api.iconify.design/brandico:github.svg?color=%23333333",
            altText: "GitHub",
            ariaLabel: "Visit my GitHub profile"
        ),
        SocialLink(
            url: "https://www.linkedin.com/in/david-vos-software-developer",
            iconUrl: "https://api.iconify.design/brandico:linkedin.svg?color=%23333333",
            altText: "LinkedIn",
            ariaLabel: "Visit my LinkedIn profile"
        ),
        SocialLink(
            url: "https://www.instagram.com/localvos/",
            iconUrl: "https://api.iconify.design/brandico:instagram.svg?color=%23333333",
            altText: "Instagram",
            ariaLabel: "Visit my Instagram profile"
        ),
        SocialLink(
            url: "https://bsky.app/profile/dvos.me",
            iconUrl: "https://api.iconify.design/simple-icons:bluesky.svg?color=%23333333",
            altText: "BlueSky",
            ariaLabel: "Visit my BlueSky profile"
        ),
        SocialLink(
            url: "mailto:contact@dvos.me",
            iconUrl: "https://api.iconify.design/mdi:email-outline.svg?color=%23333333",
            altText: "Email",
            ariaLabel: "Send me an email"
        ),
    ]

    static func render(name: String = "David Vos", role: String = "- Software Developer") -> String {
        let selectedQuote = quotes.randomElement() ?? quotes[0]
        let formattedQuote = "\"\(selectedQuote)\"<br>- \(name)"

        let socialIconsHTML = socialLinks.map { link in
            """
            <a href="\(link.url)" target="_blank" rel="noreferrer noopener" class="social-icon" aria-label="\(link.ariaLabel)">
                <img src="\(link.iconUrl)" alt="\(link.altText)" width="20" height="20">
            </a>
            """
        }.joined(separator: "\n                        ")

        return """
                <header class="header-box">
                    <div class="header-content">
                        <h1 class="header-title">
                            <span class="header-name">\(name)</span>
                            <span class="header-role">\(role)</span>
                        </h1>
                        <p class="header-subtitle">\(formattedQuote)</p>
                        <div class="social-icons">
                            \(socialIconsHTML)
                        </div>
                    </div>
                    <div class="header-image">
                        <img src="https://github.com/david-vos.png" alt="David Vos" class="profile-image">
                    </div>
                </header>
                <nav class="main-nav">
                    <a href="/projects" class="nav-link">Projects</a>
                    <a href="/blog" class="nav-link">Blogs</a>
                </nav>
        """
    }
}
