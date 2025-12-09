import Foundation

class BoxComponent {
    struct BoxItem {
        let title: String
        let text: String
        let boxContent: String
    }

    static let boxes: [BoxItem] = [
        BoxItem(
            title: "DVos-Tools - Unity Event Bus",
            text: "In the hope of ever completing my first game, I needed an event bus for Unity to decouple my game systems. </br> " +
                "It supports routing of events to specific instantiated classes, together with a type of 'lazy loading' for easy development.</br> ",
            boxContent: "Box"
        ),
        BoxItem(
            title: "DVos-Tools - BLogger for unity",
            text: "A powerful logging system for Unity with in-game terminal and file logging. </br>" +
                "It also contains runtime logging and method calling for easy debugging and testing in builds.",
            boxContent: "Box"
        ),
        BoxItem(
            title: "This very website!",
            text: "This website is written from scratch in Swift using a custom HTTP server built up from the TCP socket layer to HTTP v1.1.</br>" +
                "Feel free to check out the source code.",
            boxContent: "Box"
        ),
    ]

    static func render(item: BoxItem, isReversed: Bool = false) -> String {
        let reverseClass = isReversed ? " reverse" : ""
        return """
                <div class="item\(reverseClass)">
                    <div class="text-content">
                        <h2>\(item.title)</h2>
                        <p>\(item.text)</p>
                    </div>
                    <div class="box-content">
                        <div class="box">\(item.boxContent)</div>
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
