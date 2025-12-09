import Foundation

class BoxComponent {
    struct BoxItem {
        let title: String
        let text: String
        let imageUrl: String
        let link: String
    }

    static let boxes: [BoxItem] = [
        BoxItem(
            title: "DVos-Tools - Unity Event Bus",
            text: "In the hope of ever completing my first game, I needed an event bus for Unity to decouple my game systems. </br> " +
                "It supports routing of events to specific instantiated classes, together with a type of 'lazy loading' for easy development.</br> ",
            imageUrl: "https://github.com/dvos-tools.png",
            link: "https://github.com/dvos-tools/eventbus"
        ),
        BoxItem(
            title: "DVos-Tools - BLogger for unity",
            text: "A powerful logging system for Unity with in-game terminal and file logging. </br>" +
                "It also contains runtime logging and method calling for easy debugging and testing in builds.",
            imageUrl: "https://github.com/dvos-tools.png",
            link: "https://github.com/dvos-tools/blogger"
        ),
        BoxItem(
            title: "This very website!",
            text: "This website is written from scratch in Swift using a custom HTTP server built up from the TCP socket layer to HTTP v1.1.</br>" +
                "Feel free to check out the source code.",
            imageUrl: "https://github.com/david-vos.png",
            link: "https://github.com/david-vos/lowlevelwebserver"
        ),
    ]

    static func render(item: BoxItem, isReversed: Bool = false) -> String {
        let reverseClass = isReversed ? " reverse" : ""
        let imageHtml = item.imageUrl.isEmpty
            ? ""
            : "<img src=\"\(item.imageUrl)\" alt=\"\(item.title)\" class=\"box-image\">"
        return """
                <div class="item\(reverseClass)">
                    <div class="text-content">
                        <a href="\(item.link)" target="_blank" rel="noopener noreferrer" class="title-link">
                            <h2>\(item.title)</h2>
                        </a>
                        <p>\(item.text)</p>
                    </div>
                    <div class="box-content">
                        <a href="\(item.link)" target="_blank" rel="noopener noreferrer" class="box-link">
                            <div class="box">
                                \(imageHtml)
                                <div class="box-overlay"></div>
                            </div>
                        </a>
                    </div>
                </div>
        """
    }

    static func renderAll() -> String {
        return boxes.enumerated().map { index, item in
            let isReversed = index % 2 == 1
            return render(item: item, isReversed: isReversed)
        }.joined(separator: "\n\n")
    }
}
