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
            slug: "building-swift-load-balancer",
            title: "Building a Load Balancer (and Accidentally Kubernetes)",
            summary: "I said 'what if I got side-tracked building a load balancer'... so I did. A mini container orchestrator in Swift with round-robin routing, health checks, and zero-downtime rolling releases.",
            content: """
            <p>So at the end of my last blog post, I teased: <em>"But what if I get side-tracked and start working on creating my own rolling release and load balancer..."</em></br>
            Reader, I did. </span></p>

            <h3>The Problem With <span class="text-shadow">One Container</span></h3>
            <p>My website runs as a single Docker container. Every time I push a new version, it restarts-and for a couple of seconds, anyone visiting gets nothing. For a personal site that maybe three people visit, this is <span class="strikethrough">a complete non-issue</span>... but also a perfect excuse to massively over-engineer the deployment pipeline.</p>
            <p>The dream: multiple containers behind a load balancer, replaced one at a time during updates. Zero downtime. Professional-grade infrastructure for a website that mostly just shows my CV. <span class="tilt">(｡•̀ᴗ-)✧</span></p>

            <h3>Pods, But at <span class="text-shadow">Home</span></h3>
            <p>If you've used Kubernetes, this will look very familiar. Each running instance of the web server is called a <code>Pod</code>-it has a UUID, a status (<code>pending</code>, <code>running</code>, <code>terminating</code>...), a host port, and a Docker container underneath. A <code>DeploymentConfig</code> says how many replicas to run, which Docker image to use, and which health check path to hit.</p>
            <p>I did not set out to reinvent Kubernetes. But I am stupid enough to steal a good idea and make it much worse</p>

            <h3>Round-Robin <span class="text-shadow">Routing</span></h3>
            <p>The load balancer is a reverse proxy. Every incoming HTTP request asks the <code>LoadBalancer</code> for the next healthy pod-it keeps a counter, increments it on each request, and takes <code>index % podCount</code>. Classic round-robin.</p>
            <p>The only interesting bit: requests come in concurrently, so the counter is protected with an <code>NSLock</code>. Without it, two threads could read the same index and route two requests to the same pod while skipping the next one. The kind of bug that looks fine in testing but it misbehaves under real load... Not that I have any</span></p>

            <h3>Health Checks & <span class="text-shadow">Self-Healing</span></h3>
            <p>Every 10 seconds, the <code>PodManager</code> sends an HTTP <code>GET</code> to each pod's health endpoint. A <code>2xx</code> means healthy. Anything else-timeout, connection refused, a <code>500</code>-counts as a failure. After three consecutive failures, the pod gets replaced.</p>
            <p>But here's the important part: before the old pod dies, a replacement has to start <em>and pass its own health check</em>. If the new pod is also broken, it gets scrapped and the old one stays alive. This is what makes the system self-healing rather than just self-destructing.</span></p>

            <h3>Rolling Releases: <span class="text-shadow">Zero Downtime</span></h3>
            <p>Every two minutes, the load balancer calls the <a href="https://docs.github.com/en/rest/releases/releases" target="_blank" class="fancy-link">GitHub releases API</a> and checks if there's a newer release tag than the one currently running. If there is, a rolling update kicks off.</p>
            <p>First, the Docker image gets rebuilt against the new release tag. Then, for each old pod-<em>one at a time</em>-a new pod starts from the fresh image, waits up to 60 seconds to pass a health check, and only <em>then</em> is the old pod stopped and removed. If the new pod never becomes healthy, it gets scrapped and the old one keeps running.</p>
            <p>During the whole process, traffic keeps flowing to whatever pods are healthy. Some requests hit old pods, some hit new ones-but all of them hit <em>something that works</em>.</span></p>

            <h3>I <span class="strikethrough">Slightly</span> Cheated</h3>
            <p>In the web server post I built everything from raw TCP sockets with no frameworks. This time I used <a href="https://vapor.codes/" target="_blank" class="fancy-link">Vapor</a> for the HTTP layer. Reason: I needed an HTTP <em>client</em> to proxy requests and ping health check endpoints, and implementing one of those from scratch is a whole other project. And I'm lazy sometimes</span></p>
            <p>Everything else is still custom: the pod lifecycle, the round-robin router, the rolling update algorithm, the Docker CLI wrapper. I just didn't want to hand-roll HTTP client connection pooling on top of everything else. Some battles aren't worth fighting.</p>

            <h3>What Building Mini-Kubernetes <span class="text-shadow">Taught Me</span></h3>
            <p>The happy path was easy to get working in an afternoon. Then I spent the next day finding all the ways it falls apart: what if the Docker build takes longer than expected? What if two health cycles overlap during a rolling update? What if the host runs out of ephemeral ports? Each question revealed another edge case that Kubernetes has already solved-usually with a lot more sophistication than my version. <span class="strikethrough">Production-ready.</span></p>
            <p>It also made me properly appreciate the humble <code>/healthcheck</code> endpoint. That one route-returning <code>Status: OK</code>-is what the entire system uses to decide which pods are safe to route to and which should be replaced. Small thing, surprisingly big job.</p>
            <p>And with that, my personal website now deploys with zero downtime, uses round-robin load balancing across multiple pods, and automatically picks up new GitHub releases. For a site that three people visit. <em>Worth it.</em> <span class="tilt">(•ᴗ•)</span></p>
            """,
            date: "December 15, 2025",
            author: "David Vos",
            imageUrl: "https://api.iconify.design/logos:docker-icon.svg"
        ),
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
            <p>But what if I get side-tracked and start working on creating my own rolling release and load balancer... Until next time!</p>
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
