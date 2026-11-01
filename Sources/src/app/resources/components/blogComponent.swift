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
            slug: "ndw-correlation",
            title: "Did That Bridge Cause This Traffic Jam?",
            summary: "Adding Dutch road data (NDW) to my P2000 map, and teaching it which incident, bridge opening or broken-down car caused which traffic jam. Plus moving everything to Postgres, and the long grind of making the SQL fast.",
            content: """
            <p>So in my <a href="/blog/vibe-coding-a-map" class="fancy-link">vibe coding post</a> I ended up with a nice 3D map full of P2000 dots. But a dot only tells you <em>something</em> happened. I wanted to know what it <em>did</em>. Is that red road a jam because of the crash two dots over? Because a bridge just opened? Or is it just... Tuesday? <span class="tilt">(・・ )?</span></p>

            <h3>Enter <span class="text-shadow">NDW</span></h3>
            <p>The <a href="https://opendata.ndw.nu/" target="_blank" class="fancy-link">NDW</a> (Nationaal Dataportaal Wegverkeer) publishes pretty much everything about Dutch roads as open data: accidents, broken-down cars, closures, speed limits, bridges opening, and measured travel times on about 77,000 road segments. All in DATEX II, which is XML. Lots of XML. My corporate Java past finally paid off <span class="tilt">(¬‿¬)</span></p>
            <p>Putting it on the map was the easy part. What I wanted was the <em>connection</em>. A bridge opens, and two minutes later the road in front of it slows down. Or a P2000 message about a car on the highway, and at the same moment NDW reports a broken-down car on the hard shoulder. Same event, seen from two sides.</p>

            <h3>Postgres for <span class="text-shadow">Everything</span></h3>
            <p>At this point everything lived in OpenSearch, and it was falling apart. Every P2000 message carried a copy of its incident summary, including a list of <em>all</em> message ids. So every new message rewrote every other message in that incident. That's O(N²): an incident with 500 messages meant a single <strong>13.2 MB</strong> update request, and one big incident could freeze processing of everything for up to two minutes.</p>
            <p>And correlation is a join with geography and time. That's not what a search engine is for. So, I moved everything to Postgres with PostGIS: P2000, NDW, BAG addresses, the national road network and search. Incident summaries are now calculated instead of stored, so the O(N²) bug simply can't exist anymore. Six containers became four. Big-bang migration, no backfill, all old history thrown away. Lazy? Yes it was. It's a hobby project <span class="tilt">(•ᴗ•)</span></p>

            <h3>Teaching It <span class="text-shadow">Cause and Effect</span></h3>
            <p>First lesson: straight-line distance is useless on a highway. Two records 200 meters apart can be on opposite sides of the road. So everything is placed on the road network first: which road, which side, which kilometer. Fun fact: on Dutch highways the hectometer markers go <em>up</em> on the right side and <em>down</em> on the left. So once you know the side, you know the driving direction. And a jam is always <em>upstream</em> of its cause.</p>
            <p>Every possible link then goes through gates for <strong>time</strong> (for a bridge: 5 minutes before to 20 minutes after it opens), <strong>space</strong> (same road, same side, within a few km) and <strong>text</strong> (<code>ongeval|aanrijding</code> scores with an NDW accident, <code>reanimatie|woning</code> loses points, because a medical call next to the highway is not why the highway is stuck).</p>
            <p>Today there are 16 different relations. My favorite: <code>CAUSES_RUBBERNECKING</code>. An accident on one side, and a jam on the <em>other</em> side, because everyone has to take a look. The Dutch even have a word for it: <em>kijkfile</em>.</p>
            <p>The biggest source of wrong links? Jams that happen every day anyway. If a road is stuck at that time on most days, the bridge that happened to open there isn't the cause. Rush hour is. So the engine keeps a history per road segment, and those <em>structural</em> jams get a penalty.</p>

            <h3>The SQL <span class="text-shadow">Grind</span></h3>
            <p>And now the part nobody warns you about. Getting the correlation <em>right</em> was one thing. Getting it <em>fast</em> took way, way longer.</p>
            <p>Every new NDW record has to be checked against everything around it, in time and space, across multiple versions of every record. My first queries were correct. And slow. Then I made them fast. And wrong. Then correct again. And slow again. You get the idea <span class="tilt">(ಥ﹏ಥ)</span></p>
            <p>Some things I learned the hard way:</p>
            <ul>
                <li>A coarse filter first. Every cause type gets a search box just big enough for its widest rule, and only what falls inside goes to the actual scoring</li>
                <li>A <code>DISTINCT ON</code> inside a view looks clean, but it can stop your filters from reaching the indexes. Rewriting it as a plain "no newer version exists" filter made a huge difference</li>
                <li>Shared logic as small SQL functions instead of copy-pasted fragments, so Postgres can inline them and I only have to fix things once</li>
                <li><code>EXPLAIN ANALYZE</code> is your best friend. And your worst enemy, because it never lies</li>
            </ul>
            <p>Somewhere in between I also moved the whole database layer to <a href="https://sqlc.dev/" target="_blank" class="fancy-link">sqlc</a>, so the SQL is hand-written and the Go around it is generated. Less code, but it also meant rewriting every query. Again. This whole process took a <em>long</em> time before it was both correct and nice.</p>

            <h3>Was It <span class="text-shadow">Worth It</span>?</h3>
            <p>Linked records are now grouped: an accident, the lane closure, the arrow truck and the jam are one story on the map instead of six random icons. And I finally know why the road was red. Most of the time it's just rush hour. But sometimes it really is that bridge on the other side of the city <span class="tilt">(｡•̀ᴗ-)✧</span></p>
            """,
            date: "October 10, 2026",
            author: "David Vos",
            imageUrl: "https://api.iconify.design/mdi/traffic-light.svg"
        ),
        BlogPost(
            slug: "p2000-tracker-history",
            title: "From Telegram Bot to Kafka and Back Again",
            summary: "The history of my P2000 tracker: a Christmas side-quest that became a monolith, a New Year's Day meltdown, kicking out Kafka for RabbitMQ, and the time bugs that followed me for months.",
            content: """
            <p>In earlier posts I explained <a href="/blog/how-p2000-works" class="fancy-link">what a P2000 message looks like</a> and <a href="/blog/listening-to-p2000" class="fancy-link">how a cheap USB stick can listen in</a>. This one is about what I built around it. And how it got completely out of hand. Again. <span class="tilt">(•ᴗ•)</span></p>

            <h3>It Started as a <span class="text-shadow">Bot</span></h3>
            <p>The plan in December 2025 was simple: receive P2000 messages and send them to a Telegram chat. Then Discord too, because why not.</p>
            <p>Of course it didn't stay simple. Within a week the "simple bot" was one big Go monolith with a REST API, Swagger docs, OpenSearch, Jaeger tracing, user accounts, role permissions and auth through Clerk. For a bot. That sends messages. To me. <span class="strikethrough">Enterprise-grade.</span> Corporate Java brain is a hell of a drug.</p>
            <p>Then on New Year's Day I tried to get the whole thing running on a VPS. My commit messages that day started at <em>"hopefully a good setup"</em> and ended at just <em>":("</em>. Happy new year to me <span class="tilt">(T_T)</span></p>
            <p>The day after, I split it up. The radio part became its own small service called <code>plistener</code>, running on my home server next to the dongle. All the bot, user and API stuff moved somewhere else. Those two talk through a message broker. Which brings us to...</p>

            <h3>Kafka: <span class="strikethrough">Because Real Companies Use It</span></h3>
            <p>The first version published everything to Kafka. I set that up on December 24th, because apparently that's what I do on Christmas Eve.</p>
            <p>And it worked! SASL/SCRAM authentication, TLS, a dead letter queue, OpenTelemetry traces in the message headers, the whole enterprise package. I write corporate Java for a living, so it felt like home. That should have been the first warning sign.</p>
            <p>Here's the thing: P2000 is a few messages per minute. Kafka is built for <em>millions</em>. Running a broker for my little trickle of pager messages ate way more RAM and CPU than it had any right to. And it's a lot of complexity: partitions, offsets, consumer groups, SASL configs, a library that needs <code>CGO</code>... All for "a message comes in, and something processes it".</p>
            <p>Kafka has real benefits. Replaying old messages is great! I just didn't need any of it.</p>

            <h3>Lets go, <span class="text-shadow">RabbitMQ</span></h3>
            <p>So in May I switched to <a href="https://www.rabbitmq.com/" target="_blank" class="fancy-link">RabbitMQ</a>. Every service that cares binds its own queue to it. The Telegram bot, the Discord bot, whatever comes next. No routing keys, no partitions, no consumer groups to think about.</p>
            <p>The publisher is non-blocking. Messages go into an in-memory queue of 100, and one goroutine sends them over <code>amqps://</code>. If the connection drops, it reconnects with exponential backoff (1s, 2s, 4s... up to 30s) and retries the same message. If the queue fills up in the meantime, the oldest message gets dropped. A P2000 alert from 10 minutes ago is less interesting than the one from right now anyway.</p>
            <p>For a few days both ran side by side. Then I removed Kafka completely. That commit deleted <strong>1182 lines</strong> and added 12. Best ratio I've ever had. <span class="tilt">(｡•̀ᴗ-)✧</span></p>

            <h3>Time is a <span class="text-shadow">Lie</span></h3>
            <p>Of course the hardest part wasn't the radio or the broker. It was time. It's always time.</p>
            <p><strong>Bug one:</strong> alerts showed up an hour or two off. It turns out <code>multimon-ng</code> timestamps every message with <code>gmtime()</code>, which means UTC. I was showing UTC as if it was Dutch time. One hour off in winter, two in summer. So the fix was converting it to <code>Europe/Amsterdam</code> in the tracker. Done, right?</p>
            <p><strong>Bug two:</strong> nope. Now the timestamp was a correct Amsterdam time... with no timezone attached. Just <code>2025-12-30 23:26:07</code>, and everything reading it had to <em>guess</em> the zone. Anything running outside CET/CEST guessed wrong. And a slim Docker image without <code>tzdata</code> can't even look up <code>Europe/Amsterdam</code> in the first place.</p>
            <p>The real fix came almost three months later, in a commit I named <em>"correct timezone regardless of timezone"</em>. Which I still think is beautiful. Every message now carries two timestamps:</p>
            <ul>
                <li><code>timestamp</code>: the Amsterdam time, only for showing on screen</li>
                <li><code>timestamp_at</code>: the same moment in RFC 3339 with an explicit zone, for anything that does math with it</li>
            </ul>
            <p>And the timezone database is now baked into the Go binary with <code>import _ "time/tzdata"</code>, so it doesn't matter what the container has installed. Lesson learned: never send a time without a zone. I knew this... I did it anyway <span class="tilt">(ಥ﹏ಥ)</span></p>

            <h3>What's <span class="text-shadow">Next</span></h3>
            <p>So now there's a USB stick in my home server that turns radio waves into neat JSON messages with correct timestamps <em>(finally)</em>, and a couple of bots that send them to whoever wants them.</p>
            <p>But a fanout exchange has a fun side effect: adding a new consumer costs nothing. So the same stream of messages later ended up feeding something much bigger than a bot: <a href="https://situatiekaart.nl/" target="_blank" class="fancy-link">situatiekaart.nl</a>, a live map that turns <code>A2 13112 Ookmeerweg 1068 Amsterdam</code> into a dot on a map and tries to figure out which crash caused which traffic jam.</p>
            <p>But that's a side-quest for another post... Until next time!</p>
            """,
            date: "August 30, 2026",
            author: "David Vos",
            imageUrl: "https://api.iconify.design/logos/rabbitmq-icon.svg"
        ),
        BlogPost(
            slug: "vibe-coding-a-map",
            title: "What Vibe Coding a Frontend Has Turned Me Into",
            summary: "I let AI build the frontend for my P2000 map with Angular and MapLibre. Then I spent a month fighting 3D buildings and terrain, and ended up doing it by hand anyway. And the 3D ground? Turns out the Netherlands is flat.",
            content: """
            <p>Let's make one thing clear. AI is a lazy way of programming. Especially if you set it free with a simple <em>"make a UI for this BE"</em>.</p>
            <p>That's exactly what I did though <span class="tilt">(¬‿¬)</span></p>

            <h3>Why a <span class="text-shadow">Map</span>?</h3>
            <p>I have <em>always</em> loved websites with interactive maps or 3D renders. And now that I have a constant stream of P2000 messages (see my <a href="/blog/listening-to-p2000" class="fancy-link">USB stick post</a>), I have a lot of points that I <em>could</em> render on a map.</p>
            <p>So let's go. And let's try to build it with those fancy AI tools everyone keeps talking about.</p>

            <h3>MapLibre and <span class="text-shadow">Angular</span></h3>
            <p>I did have two requirements. The map had to use <a href="https://maplibre.org/" target="_blank" class="fancy-link">MapLibre</a>, and the frontend had to be <a href="https://angular.dev/" target="_blank" class="fancy-link">Angular</a>.</p>
            <p>MapLibre because it's this amazingly clean way of interacting with a map, and I love it for that. Angular because it's the framework (or is it just a really big library?) that I had never tried before. Ever.</p>
            <p>Now it's also not a secret that I don't really like classic frontend dev. CSS, state management, why-is-this-div-200px-too-wide... I hate it. And right around this time the Opus models started getting good enough that I wanted a model to build it out <em>itself</em>. The polar opposite of the backend, which I wrote by hand.</p>

            <h3>Dots on a <span class="text-shadow">Map</span></h3>
            <p>The first version was honestly pretty good. Within a couple of days it showed dots on a map. P2000 messages, on a map, in a framework I'd never touched. Mostly without me touching it either.</p>
            <p>But dots on a flat 2D map wasn't what I wanted. What I <em>needed</em> was a 3D map. With 3D buildings. And a height map for the ground.</p>

            <h3>A Month in the <span class="text-shadow">3D Rabbit Hole</span></h3>
            <p>This is where it stopped being a fun weekend project. I spent a full month of development trying to get 3D ground and 3D buildings working together. A month. For a hobby project. That mostly shows dots.</p>
            <p>The ground looked easy at first: MapLibre supports terrain out of the box. Throw in some free elevation tiles, call <code>setTerrain</code>, add hillshading, done. Then I looked at it. And it looked... exactly the same as before. Because this is the Netherlands. The highest point of the entire country is 322 meters, and the rest is pretty much a pancake.</p>
            <p>So I added a terrain exaggeration setting. <code>1.5x</code>, <code>2.5x</code>, <code>3.5x</code>, with <code>2.5x</code> as the default. Just so you could see <em>anything</em>. When you need to multiply reality by 2.5 to notice it, maybe the feature doesn't make sense <span class="tilt">(._.)</span></p>
            <p>The buildings were the bigger fight. In the Netherlands every building is registered in the BAG, and <a href="https://3dbag.nl/" target="_blank" class="fancy-link">3DBAG</a> turns that into 3D models with real heights, measured with laser scans from airplanes. And I wanted the good stuff: <strong>LOD 1.3</strong>, the detailed models where a building is made of multiple parts with different heights. Fetched live from 3DBAG while you move around the map, converted from CityJSON solids into something MapLibre understands, on top of the exaggerated terrain.</p>
            <p>It was slow. Really slow. Downloading detailed 3D models of every building in view, on every pan, is not a great idea. Who knew. <span class="strikethrough">Everyone.</span> Everyone knew.</p>

            <h3>Giving <span class="text-shadow">Up</span> (the Smart Way)</h3>
            <p>So after a month I gave up. The terrain went away completely. And instead of LOD 1.3, I settled for <strong>LOD 1.2</strong>: every building is just a simple block with one height. Less pretty, but it actually works.</p>
            <p>And this is the part where the AI stopped being the one doing the work. The trick: don't fetch buildings at runtime at all, bake the heights into the map tiles beforehand.</p>
            <ul>
                <li>Buildings in OpenStreetMap in the Netherlands were imported from the BAG, so most of them carry a <code>ref:bag</code> tag with their BAG id</li>
                <li>A script pulls <em>only</em> the height numbers from 3DBAG (no geometry), for every building in the country. The API returns 10k per page, so it fetches in chunks and caches them, so a crashed run can resume</li>
                <li>Height above ground is the roof height minus the ground height, both from 3DBAG</li>
                <li>Then join it on the BAG id, and inject the heights into the self-hosted map tiles</li>
            </ul>
            <p>Now MapLibre just extrudes every building to its real height. No live requests, no waiting. Add some rounded corners, shadows, a skybox, and suddenly it looks like a <em>real</em> 3D city. A month of fighting for the fancy version, and the boring version is what made it.</p>

            <h3>Why <span class="text-shadow">Bother</span>?</h3>
            <p>Because it actually matters for P2000. A message like <em>"P 1 Brand woning"</em> on some street is a dot on a 2D map. On a 3D map, it's <em>that</em> building. The tall one. You immediately see if it's a house, an apartment block or a warehouse.</p>
            <p>The ground in 3D just made everything slower and harder to read. The buildings in 3D make the map clearer. That's the whole conclusion.</p>

            <h3>So What Did It Turn Me <span class="text-shadow">Into</span>?</h3>
            <p>Someone who writes a lot less frontend code and reviews a lot more of it. And who has a lot of opinions about AI slop, while happily shipping some of it.</p>
            <p>AI got me from nothing to dots on a map in a weekend, in a framework I'd never used. But the part I'm actually proud of, the buildings, is the part I ended up doing myself. Lazy programming gets you started. It doesn't get you finished <span class="tilt">(•ᴗ•)</span></p>
            """,
            date: "July 19, 2026",
            author: "David Vos",
            imageUrl: "https://api.iconify.design/mdi/map-outline.svg"
        ),
        BlogPost(
            slug: "listening-to-p2000",
            title: "Listening to Sirens with a USB Stick",
            summary: "How a cheap RTL-SDR dongle, rtl_fm and multimon-ng turn radio waves into P2000 messages, and how I keep it running 24/7 on my home server.",
            content: """
            <p>In my <a href="/blog/how-p2000-works" class="fancy-link">last post</a> I explained what a P2000 message looks like. A normal person would now open one of the many P2000 websites to read them. I bought a USB radio dongle instead <span class="tilt">(•ᴗ•)</span></p>

            <h3>From Radio Waves to <span class="text-shadow">Text</span></h3>
            <p>So how do you actually receive a message? the hardware is an RTL-SDR dongle: a cheap USB stick with a RTL2832U chip, originally meant for watching TV on your laptop or listoning in on some radio pirates. Turns out it can tune into a lot more than TV.</p>
            <p>On the software side, two existing tools do all the hard work:</p>
            <ul>
                <li><code>rtl_fm</code> tunes the dongle to 169.65 MHz and turns the radio signal into raw audio</li>
                <li><code>multimon-ng</code> listens to that audio and decodes the FLEX messages into text lines like the one above</li>
            </ul>
            <p>In its simplest form it's one line in a terminal:</p>
            <p><code>rtl_fm -f 169.65M -M fm -s 22050 -p 83 -g 30 | multimon-ng -a FLEX -t raw /dev/stdin</code></p>
            <p>Yes, it's literally piping the <code>stdout</code> of one program into the <code>stdin</code> of another. The Unix philosophy, but make it emergency services abel to know where to go.</p>
            <p>That <code>-p 83</code> is the PPM correction. Cheap dongles have cheap crystals, so mine is tuned slightly off from where it thinks it is. Without the correction it misses the frequency and you get nothing. Every dongle is different, so finding the right number is mostly trial and error.</p>

            <h3>Running It <span class="text-shadow">24/7</span></h3>
            <p>A command in a terminal is fun for an evening. But I wanted it running all the time. So the dongle lives in my home server, and a small Go service wraps both tools: it starts them, reads the decoded lines, and turns each one into a proper message.</p>
            <p>It all runs in a single Docker container on my home server</p>
            <p>The two processes also like to die randomly sometimes. So the service watches both, and when either one exits, it kills the other, waits 5 seconds, and starts both again. Self-healing, the poor man's way.</p>
            <p>And that's how you listen to sirens with a USB stick. What I did with all those messages afterwards, and how that got out of hand, is for a <a href="/blog/p2000-tracker-history" class="fancy-link">later post</a>... Until next time!</p>
            """,
            date: "June 6, 2026",
            author: "David Vos",
            imageUrl: "https://api.iconify.design/mdi/radio-tower.svg"
        ),
        BlogPost(
            slug: "how-p2000-works",
            title: "How to Read a Dutch Emergency Pager",
            summary: "What P2000 is, and what a Dutch emergency pager message actually looks like: capcodes, priorities, addresses and 565 abbreviations.",
            content: """
            <p>Every time I heard sirens outside, I wondered where they were going. Turns out the answer is flying through the air, all day long over all of the Netherlands, in a pretty readable format. Mostly <span class="tilt">(•ᴗ•)</span></p>

            <h3>What is <span class="text-shadow">P2000</span>?</h3>
            <p>P2000 is the Dutch paging network for emergency services. When fire, ambulance or police needs to get dispatched to a location, the dispatch center sends a message to their pagers. Yes, pagers. In 2026.</p>
            <p>P2000 is actually part of something bigger: <strong>C2000</strong>, the digital radio network all Dutch emergency services use to talk to each other. C2000 is the encrypted walkie-talkie part, P2000 is the paging part.</p>
            <p>And it's everywhere. C2000 runs on masts all over the Netherlands, in the middle of Amsterdam, but also in your home town. <a href="https://www.c2000masten.nl/" target="_blank" class="fancy-link">c2000masten.nl</a> has a map with over 600 of them. Chances are there's one closer to you than you think.</p>
            <p>The pager messages go out over the air on <code>169.65 MHz</code> using a protocol called <code>FLEX</code>. And here's the fun part: unlike the rest of C2000, they're not encrypted. Anyone with an antenna can receive them.</p>
            <p>Which means anyone with an antenna <em>and too much free time</em> can liston along together with the emergency services.</p>

            <h3>The construction of a <span class="text-shadow">Message</span></h3>
            <p>After decoding, a single message looks something like this:</p>
            <p><code>FLEX|2025-12-30 23:26:07|1600/2/K/A|06.077|001234567|ALN|A2 13112 Ookmeerweg 1068 Amsterdam 121803</code></p>
            <p>Pipe-separated, seven fields:</p>
            <ul>
                <li><code>2025-12-30 23:26:07</code>: when the receiver picked it up. Not when it was sent. And in UTC. Remember that, it'll hurt later</li>
                <li><code>1600/2/K/A</code> and <code>06.077</code>: FLEX transmission details, like the speed (1600 bits per second) and timing. Mostly uninteresting, unless you're the decoder</li>
                <li><code>001234567</code>: the <strong>capcode</strong>. That's the address of the pager (or group of pagers) this message is for. One alert often goes to a bunch of capcodes at once: the ambulance driving around in the city, the station, the regional dispatch...</li>
                <li><code>ALN</code>: the message type. Alphanumeric, so actual text. Other types exist (numeric, tone-only), but those don't tell you anything useful and are not used within p2000 - as far as I understand</li>
                <li>And finally the content: <code>A2 13112 Ookmeerweg 1068 Amsterdam 121803</code></li>
            </ul>
            <p>Capcodes in FLEX are 22 bits, so the highest real pager address is <code>4194303</code>. Anything above that is a system or broadcast address, and not a real pager. Same for messages with an empty text. You'd think "a pager message with no message" would be rare. It's not.</p>

            <h3>Reading the <span class="text-shadow">Content</span></h3>
            <p>The content is where it gets interesting, and also where it gets messy. It usually starts with a priority:</p>
            <ul>
                <li><code>A0</code>, <code>A1</code>, <code>A2</code>: ambulance urgency. <code>A0</code> is the highest (cardiac or respiratory arrest), <code>A2</code> means no immediate danger to life, so no sirens. And <code>B1</code>/<code>B2</code> for planned, non-urgent transport</li>
                <li><code>P 1</code>, <code>P 2</code>, <code>P 3</code> (or <code>PRIO 1</code>, depending on the region): fire department and others. <code>P 1</code> means lights and sirens, <code>P 2</code> means none</li>
            </ul>
            <p>After that usually comes the address: a street, a postal code, and a city. In this case Ookmeerweg, 1068, Amsterdam. Plus some numbers that might discribe some on-scene scenario that might mean something to the dispatcher</p>
            <p>Usually. Because there is no strict format. Every region, and sometimes every dispatcher, writes them a bit differently. And then there are the abbreviations. My parser currently knows <strong>565</strong> of them. <code>BR</code>, <code>OMS</code>, <code>MMT</code>, every fire station code in the country... And I still find new ones. <span class="strikethrough">Fun.</span></p>

            <p>And that's what a P2000 message looks like. Next up: how to actually receive them yourself, with a <a href="/blog/listening-to-p2000" class="fancy-link">cheap USB stick</a>... Until next time!</p>
            """,
            date: "June 2, 2026",
            author: "David Vos",
            imageUrl: "https://api.iconify.design/mdi/message-text.svg"
        ),
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
            imageUrl: "https://api.iconify.design/logos/docker-icon.svg"
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
            imageUrl: "https://api.iconify.design/logos/swift.svg"
        )
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
