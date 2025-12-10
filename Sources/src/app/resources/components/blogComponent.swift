import Foundation

struct BlogPost {
    let slug: String
    let title: String
    let summary: String
    let content: String
    let date: String
    let author: String
    let imageUrl: String

    var path: String {
        return "/blog/\(slug)"
    }
}

class BlogComponent {
    static let posts: [BlogPost] = [
        BlogPost(
            slug: "building-swift-web-server",
            title: "Building a Web Server from Scratch in Swift",
            summary: "How I created a HTTP server using Swift, Using TCP sockets to serve the web page you are viewing right now.",
            content: """
            <p>I've built <em>quite a few</em> personal websites over the years. Most were basic React/Next.js apps, others used 3D web frameworks or full OS-like experiences.</br>
            At some point, I found myself wanting to go back to a simple, no-bullshit website... So <em>of course</em> I decided to roll my own web server in Swift <span class="tilt">(•ᴗ•)</span>. Makes sense, <em>right?!</em></p>

            <h3>Why <span class="text-shadow">Swift</span>?</h3>
            <p>Swift is a language I'd never used but always wanted to give a go. After completing the first week or so of <a href="https://adventofcode.com/2025" target="_blank" class="fancy-link">Advent of Code 2025</a> in Swift, I really liked the language.
            It has everything I want: strong typing, performance, and compiled binaries. Plus, it doesn't feel as boring or <span class="strikethrough">soulless</span> as programming in Go... ( fight me <span class="tilt">(ง •̀_•́)ง</span> )</p>

            <h3>Why Build from <span class="tilt">Scratch</span>?</h3>
            <p>There are already great web frameworks in Swift like <a href="https://vapor.codes/" target="_blank" class="fancy-link">Vapor</a>. So why not use those?
            Well, first of all, I wanted to learn how web servers <em>actually</em> work at a fundimental level. I also think I may have gone slightly insane from writing too much Java/Groovy at work-which is <em>truly</em> a soul-sucking experience</p>

            <h3>Basics <span class="text-shadow">TCP Sockets</span></h3>
            <p>The foundation of any web server is the ability to accept network connections. However I did not find it that interesting to create my own TCP stack from scratch. So I might do that in the future, but not today.
            So lets cheat a bit! In Swift, we can use the <code>POSIX socket APIs</code> through the <code>Darwin</code> module. This makes me only need to creat a socket, binding it to a port, and listening for incoming connections.
            Whenever a client connects, we can accept the connection and read/write data to a new socket specific to that client. We can then handle multiple clients using <code>DispatchQueue</code> for concurrency as long as we use non-blocking I/O.
            </p>

            <h3>Implementing HTTP/1.1</h3>
            <p>Once we can accept TCP connections, the next step is parsing HTTP requests. HTTP/1.1 is a text-based protocol, making it relatively straightforward to parse. We need to handle the request line, headers, and optionally a body.
            All we have to do is follow <a href="https://www.rfc-editor.org/rfc/rfc9110.html#name-example-message-exchange" target="_blank" class="fancy-link">the spec</a> and that's it-<em>super easy!</em></p>
            <p>A router maps URL paths to handlers. In this implementation, I created a simple and <span class="tilt">"stupid"</span> routing system that supports both static pages and dynamic content.
            All you need to do is register a URL path string and pass a render function that returns the HTML content as a string. This does, however, mean you can't do any of the <span class="strikethrough">fancy</span> stuff like <code>/fake/fake/../../blogs</code>
            But hey, You can't get everything in life.</p>

            <h3>What this 3 day SideQuest has offered me</h3>
            <p>Building a web server from scratch has been a nice change of pace. It's given me a deeper understanding of some of the complexities behind what I consider the "standard" of web development-enough so that I didn't want to bother implementing <span class="strikethrough">HTTP/2</span> or <span class="strikethrough">HTTP/3</span> <span class="tilt">(｡- .•)</span></p>
            """,
            date: "December 9, 2025",
            author: "David Vos",
            imageUrl: "https://api.iconify.design/logos:swift.svg"
        ),
    ]

    /// Find a blog post by its slug
    static func findBySlug(_ slug: String) -> BlogPost? {
        return posts.first { $0.slug == slug }
    }

    /// Render a blog post card for the list view
    static func renderCard(post: BlogPost) -> String {
        return """
                <article class="blog-card">
                    <a href="\(post.path)" class="blog-card-link">
                        <div class="blog-card-image">
                            <img src="\(post.imageUrl)" alt="\(post.title)">
                        </div>
                        <div class="blog-card-content">
                            <time class="blog-date">\(post.date)</time>
                            <h2 class="blog-card-title">\(post.title)</h2>
                            <p class="blog-card-summary">\(post.summary)</p>
                            <span class="blog-read-more">Read more →</span>
                        </div>
                    </a>
                </article>
        """
    }

    /// Render all blog cards for the list view
    static func renderAllCards() -> String {
        return posts.map { renderCard(post: $0) }.joined(separator: "\n\n")
    }

    /// Render a full blog post
    static func renderFull(post: BlogPost) -> String {
        return """
                <article class="blog-post">
                    <header class="blog-post-header">
                        <a href="/blog" class="back-link">← Back to Blogs</a>
                        <time class="blog-date">\(post.date)</time>
                        <h1 class="blog-post-title">\(post.title)</h1>
                        <p class="blog-post-author">By \(post.author)</p>
                    </header>
                    <div class="blog-post-content">
                        \(post.content)
                    </div>
                    <footer class="blog-post-footer">
                        <a href="/blog" class="back-link">← Back to Blogs</a>
                    </footer>
                </article>
        """
    }
}
