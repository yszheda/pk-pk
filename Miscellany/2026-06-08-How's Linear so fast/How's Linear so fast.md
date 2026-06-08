---
title: "How's Linear so fast? A technical breakdown"
source: "https://performance.dev/how-is-linear-so-fast-a-technical-breakdown"
author:
  - "[[Dennis Brotzky]]"
published: 2026-05-03
created: 2026-06-08
description: "breakdown of the architecture behind Linear's speed: local-first sync, MobX observables, instant first loads, and a keyboard-first design."
tags:
  - "ToRead"
---
## How's Linear so fast? A technical breakdownLinear 为何如此之快？技术深度解析

![How's Linear so fast? A technical breakdown](https://media.performance.dev/cdn-cgi/image/width=3572,quality=100,format=auto,fit=scale-down/posts/p_gAMR6Z7y49Fp/yLYBhiiY_FsV.jpg)

A few milliseconds is all it takes to update an issue in Linear. A traditional CRUD app doing the same thing takes about 300ms. How do they do it? There's no secret silver bullet to performance. The reality is that it's built from the ground up on the right foundation, then improved by countless decisions. My goal is to walk through some of the techniques that make Linear feel the way it does and help you implement the same.在 Linear 中更新一个问题只需几毫秒。而完成同样操作的传统 CRUD 应用则需要约 300 毫秒。他们是如何做到的？性能并没有什么神奇的万能解决方案。实际情况是，它从一开始就建立在合适的基础之上，再通过无数次优化决策不断完善。我的目标是梳理一些让 Linear 拥有出色体验的技术，并帮助你将这些技术落地应用。

## What I'll cover 我将介绍的内容

- Database in the browser 浏览器中的数据库
- Making the first load feel instant 让首次加载体验变得即时
- The sync engine 同步引擎
- Designed for speed 为速度而设计
- Animations 动画

A quick disclaimer: I've never worked at [Linear](https://linear.app/) and have never seen their code. Everything I share comes from my personal experience, studying their app, reading their blog posts, or watching their conference talks. I simply love building web apps and have been using Linear since their beta launch. Also, the article’s hero image comes from a video by [Meg Wayne](https://x.com/megxwayne), whose work for Linear is phenomenal.简短免责声明：我从未在 [Linear](https://linear.app/) 工作过，也从未见过他们的代码。我分享的所有内容都来自我的个人经历、研究他们的应用程序、阅读他们的博客文章或观看他们的会议演讲。我只是热爱开发网络应用程序，并且从 Linear 测试版上线时就一直在使用它。此外，本文的主图来自 [Meg Wayne](https://x.com/megxwayne) 制作的视频，她为 Linear 创作的作品非常出色。

---

## Database in the browser 浏览器中的数据库

Most web apps live inside the same loop. The user clicks. The browser fires an HTTP request. A server queries a database and sends it back. The browser repaints. The end result is a spinner, a skeleton, or a frozen UI for a few hundred milliseconds while the app waits on the network.大多数网络应用都运行在同一个循环中。用户点击操作，浏览器发起一个 HTTP 请求，服务器查询数据库并将数据返回，浏览器重新渲染界面。最终结果是，在应用等待网络响应的数百毫秒内，界面会出现加载图标、骨架屏，或是处于卡顿状态。

Linear inverts the traditional relationship. The actual database the UI reads from is in the browser, in IndexedDB. Mutations apply locally first, then asynchronously push to the server, which broadcasts deltas back to other clients via WebSocket.Linear 颠覆了传统的关系模式。UI 实际读取的数据库位于浏览器的 IndexedDB 中。变更首先在本地应用，然后异步推送到服务器，服务器再通过 WebSocket 将增量数据广播给其他客户端。

In my opinion, this is the most critical piece to Linear's performance. When your goal is to build a fast web app the biggest bottleneck you will fight is the network. Any data sent between the client and server costs hundreds of milliseconds. The best approach is to eliminate the need for a network request entirely: which is exactly what Linear does.在我看来，这是 Linear 性能表现的最关键部分。当你的目标是打造一款快速的网络应用时，你需要攻克的最大瓶颈就是网络。客户端与服务器之间传输的任何数据都会耗费数百毫秒的时间。最优的解决办法是彻底消除对网络请求的依赖——而这正是 Linear 所实现的核心功能。

I'll be repeating this a lot, but the secret to building incredible web apps is by hiding all the network requests from the user. The more loading states you can avoid the better.我会反复强调这一点，但打造出色的网络应用程序的秘诀，就是向用户隐藏所有的网络请求。你能避免的加载状态越多，效果就越好。

Here's an example of how simple Linear's requests are:下面举个例子，看看 Linear 的请求有多简单：

```typescript
// A traditional web app updating the server
async function updateIssue({ issue }) {
  showSpinner();
  const response = await fetch(\`/api/issues/${issue.id}\`, {
    method: "PATCH",
    body: JSON.stringify({ title: issue.title }),
  });
  const updated = await response.json();
  setIssue(updated)
  hideSpinner();
}
 
// vs Linear
issue.title = "Faster app launch";
issue.save();
```

The first line, `issue.title = "Faster app launch"`, updates an in-memory datastore (MobX observable in Linear's case). The second line, `issue.save();`, queues a transaction that their sync engine batches and flushes to the server. The key here is that the UI re-renders synchronously off the local, in-memory, update. There are no spinners because there is nothing to wait for because the data is synced in the backround. This is the magic of treating the browser as the database for each user.第一行代码 \` `issue.title = "Faster app launch"` \` 会更新内存中的数据存储（以 Linear 为例，是 MobX 可观察对象）。第二行代码 \` `issue.save();`\` 会将一个事务加入队列，其同步引擎会对该事务进行批处理，然后批量发送至服务器。关键在于，用户界面会根据本地内存中的更新同步重新渲染。由于数据在后台同步，无需等待，因此不会出现加载动画。这就是将浏览器作为每位用户的数据库所带来的优势。

[Tuomas](https://x.com/artman), one of Linear's co-founders, said this at a conference in 2024: 'Literally the first lines of code that I wrote was the sync engine, which is very uncommon to what you usually do when you're a startup.' From day one, Linear knew the approach they wanted to take and the tradeoffs it would take.[图奥马斯](https://x.com/artman) 作为 Linear 的联合创始人之一，在2024年的一场会议上表示：“我写的第一行代码就是同步引擎，这和初创公司通常的做法大相径庭。”从一开始，Linear 就明确了自己想要采取的策略，以及为此需要做出的权衡。

![HoverNotes Icon](chrome-extension://fhdmbhgpabjkadpaafomaabbdckofphm/assets/icons/hover-notes-icon-white.svg)

HoverNotes Icon

I know most people won't build a custom sync engine like Linear just to make their app feel fast and they don't need to. For most use cases, libraries like [Tanstack Query](https://tanstack.com/query/latest) and [SWR](https://swr.vercel.app/) can get surprisingly close with optimistic updates. Most web apps feel slow because the UI waits for each network request to complete before updating state. For most usecases the network request will succeed so you should take advantage of that and optimistically update your state.我知道大多数人不会为了让应用运行流畅而开发一个像 Linear 那样的自定义同步引擎，而且他们也没必要这么做。对于大多数使用场景， [Tanstack Query](https://tanstack.com/query/latest) 和 [SWR](https://swr.vercel.app/) 这类库凭借乐观更新能达到近乎完美的效果。大多数网页应用运行卡顿，是因为 UI 会等待每个网络请求完成后才更新状态。而在多数情况下，网络请求都会成功，因此你应该利用这一点，对状态进行乐观更新。

```typescript
// optimistic mutation with SWR
mutate(
  \`/api/issues/${issue.id}\`,
  { ...issue, title: "Faster app launch" },
  false
);
 
// vs Linear
issue.title = "Faster app launch";
issue.save();
```

The key idea is simple: UI responsiveness should not depend on network latency. Users perceive speed based on how quickly the interface reacts, not how quickly the server responds.核心思路很简单：用户界面的响应性不应依赖于网络延迟。用户感知到的速度取决于界面的响应速度，而非服务器的响应速度。

Optmistic requests is one of the highest leverage improvements you can make:乐观请求是你能做出的效果最显著的改进之一：

- eliminate unnecessary spinners 消除不必要的加载动画
- update state immediately 立即更新状态
- validate in the background 在后台进行验证
- rollback only if needed 仅在需要时回滚

Linear's foundation is based on this exact principal and it makes the app feel native and fast. Linear 的核心基础正是基于这一原则，这让应用体验流畅且贴近原生。

### A peek into Linear's stack 窥探 Linear 的技术栈

Linear is built on the simplest stacks you can find: React, TypeScript, MobX, Postgres, a CDN. There's no edge database, no React Server Components, or no fancy framework.Linear 基于你能找到的最简单的技术栈构建：React、TypeScript、MobX、Postgres 以及一个内容分发网络。这里没有边缘数据库，没有 React 服务端组件，也没有花哨的框架。

```text
Frontend
  React + react-dom               (UI runtime)
  MobX                            (observable graph, granular re-renders)
  TypeScript                      (single language end-to-end)
  Rolldown-Vite + plugin-react-oxc(mid-2025; previously Rollup; previously Parcel)
  ProseMirror + y-prosemirror     (rich text editor; Yjs CRDT for live collab)
  Radix UI primitives             (popovers, menus, focus traps)
  Emotion + StyleX                (Emotion runtime + StyleX compiled to atomic CSS)
  Comlink                         (Worker RPC)
  idb                             (IndexedDB wrapper backing the local-first store)
  graphql-request                 (GraphQL transport to the sync server)
  Sentry                          (error monitoring)
  Inter Variable                  (single woff2, font-display: swap)
 
Backend
  Node.js + TypeScript            (single language for all server code)
  PostgreSQL on Cloud SQL         (issues table partitioned 300 ways)
  Memorystore Redis               (event bus + cache + sync cursors)
  turbopuffer                     (similar-issue detection, vector db)
  Kubernetes on GCP               (one workload per concern)
  Cloudflare Workers              (multi-region edge proxy)
 
Other clients
  Desktop: Electron               (same web JS, native chrome)
  Mobile:  Swift (iOS) + Kotlin   (a separate full reimplementation)
 
Marketing
  Next.js                         (static)
  styled-components
  Inline SVG sprite
```

The biggest standout to me is their decision to stick with client-side rendering. CSR often gets criticized for slow initial loads, but with the right architecture and design it can feel instant.对我来说，最突出的一点是他们选择坚持客户端渲染。客户端渲染常因初始加载速度慢而受到诟病，但只要架构和设计得当，它就能做到即时响应。

I'm also a big fan of the simplicity it brings. Keeping the app entirely client-side creates a much cleaner mental model and removes a lot of the complexity that comes with server-rendered apps. You don't have to constantly think if you're on the server or client. If window object is accessible or not. If you're setting the right cache headers or not. There's beauty in simplicity and the constraints you're forced into.我也非常喜欢它带来的简洁性。将应用完全保留在客户端能构建出更清晰的思维模型，还能消除服务器端渲染应用所带来的诸多复杂性。你无需时刻纠结自己是处于服务器还是客户端环境，也不用考虑能否访问 window 对象，更不用纠结是否设置了正确的缓存标头。简洁本身以及你被迫遵循的约束条件，都蕴含着独特的美感。

So how does Linear make their client side rendered app feel instant?那么 Linear 是如何让其客户端渲染的应用实现秒开体验的呢？

---

## Making the first load feel instant 让首次加载体验变得即时

One thing I obsess over is the first load, and Linear clearly does as well. For productivity tools especially, the time it takes before you can actually start working is one of the most important details to consider. No one wants to be waiting for a new tab to load for multiple seconds 我一直很在意首次加载的体验，Linear 显然也是如此。尤其是对于生产力工具来说，真正开始使用前的加载时长是需要考虑的最重要细节之一。没人愿意等一个新标签页加载好几秒

First, you have to understand what makes initial loads slow. For a client side app you have to request the `index.html`, then that requests all the JavaScript and CSS, which then runs some sort of authentication, and finally makes some API requests to show the app.首先，你需要了解是什么导致初始加载速度缓慢。对于客户端应用程序，你必须请求 `index.html` ，然后该文件会请求所有的 JavaScript 和 CSS，接着执行某种身份验证，最后还会发起一些 API 请求来展示应用程序。

### Linear's bundler arc: Parcel, Rollup, Vite, RolldownLinear 的打包工具演进：Parcel、Rollup、Vite、Rolldown

The first step to making an app feel instant happens long before runtime. It starts at build time. Remember, the network is the bottleneck, so shipping the least amount of JavaScript and CSS is critical to fast load times.让应用给人即时响应的第一关在运行时之前就已开启，从构建阶段就需着手。要牢记，网络是性能瓶颈，因此尽可能减少 JavaScript 和 CSS 的代码量，对实现快速加载至关重要。

From what I can gather Linear has rewritten their build pipeline four times: Parcel → Rollup → Vite → Rolldown. Each migration was driven by the same goal: reduce the amount of JavaScript and CSS and improve the developer experience.据我了解，Linear 已经重写了四次构建流程：从 Parcel 到 Rollup，再到 Vite，最后是 Rolldown。每一次迁移都基于同一个目标：减少 JavaScript 和 CSS 的体积，并优化开发者体验。

From their own blog posts they claim:他们在自己的博客文章中声称：

- 50% less code shipped. 交付的代码减少50%。
- 30% smaller after compression. 压缩后体积减小30%。
- Cold-cache page loads got 10 to 30% faster.冷缓存页面加载速度提升了10%至30%。
- Time-to-first-paint of the active-issues view dropped 59% (on Safari).活动问题视图的首次绘制时间在 Safari 浏览器上下降了 59%。
- Memory usage dropped 70 to 80% 内存使用率下降了70%至80%

Most of that came from a combination of decisions targeting only modern browsers, better dead-code elimination, and aggressive code splitting. Dropping legacy support is the big win (no polyfills, no ES5 transpilation, no nomodule fallback) but the dead-code and chunking work matters just as much.这其中大部分得益于仅针对现代浏览器的一系列决策、更优的死代码消除以及高效的代码分割。放弃对旧版浏览器的支持是关键优势（无需 polyfill、无需 ES5 转译、无需 nomodule 降级方案），但死代码处理和代码分块的优化同样至关重要。

Even with all of these optimizations, Linear still ships a substantial amount of code: roughly 21 MB of minified JavaScript. The difference is that it's aggressively code split into hundreds of route-level chunks that are fetched on demand.即便进行了所有这些优化，Linear 仍需交付大量代码：约 21 兆字节的压缩 JavaScript。不同之处在于，它会对代码进行激进的拆分，形成数百个路由级代码块，并按需加载。

```typescript
// vite.config.ts (reconstruction; matches observed chunk graph)
export default defineConfig({
  plugins: [react()],
  build: {
    target: "esnext",            // no legacy syntax, no polyfills
    cssMinify: "lightningcss",
    modulePreload: { polyfill: false },
    rollupOptions: {
      output: {
        // One chunk per npm package > ~3 KB. Cache invalidation
        // becomes per-library instead of per-app-revision.
        manualChunks(id) {
          if (id.includes("node_modules")) {
            const pkg = id.match(/node_modules\/([^/]+)/)?.[1];
            if (pkg) return \`vendor-${pkg}\`;
          }
        },
      },
    },
  },
});
```

The lesson isn't which bundler to pick but the importance of dropping legacy browsers, going native ESM, and code splitting like crazy. Each step is small. Stacked, they cut Linear's first-load JavaScript roughly in half and their build time by an order of magnitude.经验教训不在于该选择哪种打包工具，而在于淘汰旧版浏览器、采用原生 ESM 以及全力进行代码拆分的重要性。每一步都很简单。叠加起来，这些操作将 Linear 的首屏 JavaScript 体积减少了近一半，构建时间也缩短了一个数量级。

So, the first secret to instant load times is reducing the amount of JavaScript and CSS needed to render something for the user.那么，实现秒级加载速度的第一个秘诀，就是减少渲染用户界面所需的 JavaScript 和 CSS 数量。

### Preloading after initial load 初始加载后的预加载

**Once you've split your JavaScript into the smallest chunks possible you can start doing work in the background.一旦你将 JavaScript 拆分成尽可能小的代码块，就可以开始在后台进行处理了。**

But hold on, splitting the bundle into hundreds of chunks creates a new problem. Each chunk imports other chunks, and the browser doesn't know what those are until it parses the entry script. Without help, the load timeline becomes a waterfall: fetch the entry, parse it, fetch its imports, parse those, fetch their imports. Every level adds a network round-trip, which you want to avoid at all costs.但先别急，将包拆分成数百个块会引发一个新问题。每个块都会导入其他块，而浏览器在解析入口脚本之前并不了解这些导入的内容。如果没有优化措施，加载流程会变成瀑布式：先获取入口脚本、解析它，再获取其导入的内容、解析这些内容，接着获取它们的导入内容并解析。每增加一层都会产生一次网络往返请求，这是我们需要极力避免的。

What Linear does is before any JavaScript runs, the browser sees the entire list and fires off the requests in parallel. By the time the entry script reaches its first `import`, the chunks are already in cache.Linear 的做法是，在任何 JavaScript 运行之前，浏览器就能看到整个列表，并并行发起请求。等到入口脚本执行到第一个 `import` 时，这些代码块已经被存入缓存了。

Here's what it looks like in the `<head />` if their `index.html` 这是在他们的 `<head />` 标签中呈现的样子，如果他们的 `index.html`

```html
<script type=module crossorigin
  src="https://static.linear.app/client/assets/html.2_JBQs3Q.js"></script>
<link rel=modulepreload crossorigin
  href="https://static.linear.app/client/assets/vendor-mobx.Crhy2qQc.js">
<link rel=modulepreload crossorigin
  href="https://static.linear.app/client/assets/SyncWebSocket.Djw6l_Op.js">
<link rel=modulepreload crossorigin
  href="https://static.linear.app/client/assets/DatabaseManager.DKssGAN8.js">
<!-- ...around many more -->
```

The `crossorigin` attribute on each preload matches the `crossorigin` on the entry script, so the browser reuses the cached fetch instead of treating preload and import as separate resources. Same trick as the font preload, applied to every chunk on the critical path.每个预加载的 `crossorigin` 属性与入口脚本的 `crossorigin` 属性相匹配，因此浏览器会复用缓存的获取操作，而非将预加载和导入视为独立资源。这与字体预加载采用的技巧相同，被应用于关键路径上的所有代码块。

The cold-load timeline collapses from a sequential waterfall into a single parallel batch. The network still does the work. It just does it all at once. The beauty of this technique is you're able to do all this work in the background when the user first hits the login page. In a few seconds the full app is stored in cache and served instantly.冷启动时间线从串行的瀑布式流程压缩为单一的并行批处理流程。网络依旧在执行这些操作，只是所有操作会一次性完成。这种技术的优势在于，用户首次访问登录页面时，你就能在后台完成所有这些工作。短短几秒内，完整的应用就会被存储到缓存中，随后即可即时加载使用。

It's extremely important to understand how people will use your app. Once you have this understanding you can start using it to your advantage, such as preloading scripts in the background as Linear does.了解用户如何使用你的应用至关重要。一旦掌握了这一点，你就可以开始利用这一认知为自己谋利，比如像 Linear 那样在后台预加载脚本。

### The service worker for even more speed and offline capabilities服务工作线程实现更高的运行速度与离线功能

The rest of the Linear, the route-level chunks for views the user hasn't visited yet, gets cached in the background by a service worker. The worker has a precache manifest baked into its source, around 1,200 hashed assets covering route chunks, icons, and fonts, and pulls them down lazily after the first page load. Within a few seconds of hitting the login screen, the full app is sitting in cache.Linear 的其余部分（即用户尚未访问过的视图的路由级代码块）会由服务工作线程在后台进行缓存。该工作线程的源码中内置了一个预缓存清单，包含约1200个经过哈希处理的资源，涵盖路由代码块、图标和字体，并在首屏加载后按需拉取这些资源。用户进入登录界面后的几秒钟内，整个应用就会被缓存起来。

![HoverNotes Icon](chrome-extension://fhdmbhgpabjkadpaafomaabbdckofphm/assets/icons/hover-notes-icon-white.svg)

HoverNotes Icon

This buys two things. Subsequent navigations skip the network entirely; the service worker answers directly from its cache without even going through HTTP cache. And the app keeps working when the network doesn't. Combined with the local-first sync engine (which already has the user's data in IndexedDB), Linear is usable offline. You can read issues, create new ones, edit titles and descriptions, change statuses. Everything queues in the local transaction store and flushes the next time the connection comes back.这实现了两大好处。后续的导航操作会完全跳过网络；服务工作线程直接从缓存中响应，甚至不会经过 HTTP 缓存。而且当网络断开时，应用仍能正常运行。再结合本地优先的同步引擎（用户数据已存储在 IndexedDB 中），Linear 支持离线使用。你可以查看议题、创建新议题、编辑标题和描述、修改状态。所有操作都会先在本地事务存储中排队，待网络恢复后立即同步。

Modulepreload is for what the app needs now, parallel-fetched so the browser never blocks on a serial import chain. The service worker is for what the app needs next.模块预加载用于应用当前所需的内容，通过并行获取使浏览器永远不会因串行导入链而阻塞。服务工作线程用于应用后续所需的内容。

So, to get load times fast the steps for Linear is to elminate as much code as possible, split it into small pieces, and precache it in the background. Again, the goal of all this work is to make network requests as fast as possible or, even better, eliminate them completely.因此，要实现快速加载，Linear 的做法是尽可能减少代码量，将代码拆分成小块，并在后台进行预缓存。同样，所有这些工作的目标都是让网络请求尽可能快，甚至更好的是，彻底消除网络请求。

### Vendor bundle composition 第三方包捆绑组成

I found it interesting that every package Linear uses gets its own chunk, cached independently. A traditional `vendor.js` invalidates the entire dependency graph on any bump. Linear's chunking turns vendor caching from a single massive file to fine-grained. Bumping a single dependency invalidates one chunk; the rest stay cached.我觉得很有意思的是，Linear 使用的每个包都有自己的代码块，并且被独立缓存。传统的 `vendor.js` 只要有任何版本更新，就会使整个依赖关系图失效。而 Linear 的代码块拆分方式，将供应商缓存从一个庞大的单一文件变成了细粒度的形式。更新单个依赖项只会使一个代码块失效，其余的则保持缓存状态。

Seems like a no-brainer and yet another detail to ensure fast load times.这似乎是个显而易见的做法，也是确保快速加载时间的又一个细节。

![](https://media.performance.dev/cdn-cgi/image/width=2400,quality=100,format=auto,fit=scale-down/posts/p_gAMR6Z7y49Fp/b5RGjc_nI54O.jpg)

Each individual package split into its own js file 每个独立的包都拆分为单独的 js 文件

### Loading massive font files 加载大型字体文件

Font loading is one of those details a lot of apps get wrong. The failure modes are visible: invisible text for half a second, layout shifts as the real font swaps in, double-fetched resources because the preload didn't match. Linear's setup avoids all three:字体加载是许多应用程序都容易出错的细节之一。错误表现显而易见：文字消失半秒、实际字体替换时出现布局偏移、因预加载不匹配导致资源重复加载。Linear 的设置规避了这三类问题：

```html
<!-- in <head> of index.html -->
<link rel="preload"
      href="https://static.linear.app/fonts/InterVariable.woff2?v=4.1"
      as="font" type="font/woff2" crossorigin="anonymous">
<link rel="preconnect" href="https://static.linear.app" crossorigin>
```

```css
@font-face {
  font-family: "Inter Variable";
  font-weight: 100 900;
  font-display: swap;
  src: url(https://static.linear.app/fonts/InterVariable.woff2?v=4.1)
       format("woff2");
}
/* Italic and Berkeley Mono follow the same shape, single woff2 each. */
```

Variable fonts cover the full 100–900 weight axis in a single woff2, eliminating per-weight requests. `font-display: swap` renders the fallback stack immediately and swaps to Inter when it loads. The trick that's easy to miss: `crossorigin="anonymous"` on the preload tag. Without it, the browser preloads the font, then fetches it again when CSS later references it, because the two requests have different CORS modes. `crossorigin` on the preload makes the browser reuse the cached one.可变字体在单个 woff2 文件中覆盖完整的 100–900 字重轴，消除了按字重单独请求的情况。 `font-display: swap` 会立即渲染后备字体栈，待 Inter 字体加载完成后再切换到它。有一个容易被忽略的关键技巧：预加载标签上需添加 `crossorigin="anonymous"` 。若缺少该属性，浏览器会先预加载字体，随后在 CSS 再次引用时重新获取它——因为这两个请求拥有不同的 CORS 模式。预加载时设置 `crossorigin` 属性，就能让浏览器复用缓存的字体文件。

This all seems simple, but I'm always surprsied at how many apps load fonts incorrectly. Linear is a great example of thinking through the details and ensuring font loading is as fast and accurate as possible.这一切看似简单，但我总是惊讶于有多少应用程序加载字体的方式都不正确。Linear 就是一个很好的例子，它充分考虑了细节，确保字体加载既快速又准确。

### Inlined app shell 内联应用外壳

Another key technique to make the first load feel fast: Inlined in `<head/>` is just enough CSS to paint the loading state with no external stylesheet fetched. Remember, the network is the bottleneck and what you'll always be fighting to make your app feel fast. In this case, Linear elminates a network request by inlining the critical CSS required to show the user an app shell.让首屏加载速度更快的另一项关键技巧：在 \` `<head/>` \` 中内联仅足以渲染加载状态的 CSS，无需获取外部样式表。请记住，网络是瓶颈，你始终需要全力优化以让应用获得更快的加载体验。在这种情况下，Linear 通过内联向用户展示应用外壳所需的关键 CSS，消除了一次网络请求。

```css
<style>
  :root {
    --bg-color: #f5f5f5;
    --bg-base-color: #fcfcfd;
    --bg-border-color: #e0e0e0;
    --sidebar-width: 244px;
  }
  html { background: var(--bg-color); height: 100%; }
  body { font-family: "Inter Variable", Arial, Helvetica, sans-serif; }
 
  #appBorders {
    border: 1px solid var(--bg-border-color);
    background: var(--bg-base-color);
    margin: 8px 8px 8px var(--sidebar-width);
    border-radius: 12px;
  }
 
  #logo { transform: translateZ(0); }
 
  @keyframes logoBackgroundPulse {
    0%   { opacity: 0; transform: scale(0.8); }
    70%  { opacity: 1; }
    100% { opacity: 0; transform: scale(1.0); }
  }
</style>
<script>performance.mark("appStart");</script>
```

Beyond CSS there is also a bunch of inlined JavaScript that's critical to loading the initial experience.除了 CSS 之外，还有大量内联 JavaScript，它们对于加载初始体验至关重要。

```typescript
<script>
// Electron context — lets CSS branch on native chrome.
if (navigator.userAgent.includes("Electron") && navigator.userAgent.includes("Linear")) document.documentElement.classList.add("electron");
 
// No local store → no workspace data → render the auth layout.
if (localStorage.getItem("ApplicationStore") === null) document.documentElement.classList.add("logged-out");
 
// Restore last-known shell tokens (sidebar bg, width, dark mode) before paint.
const c = JSON.parse(localStorage.getItem("splashScreenConfig") || "{}");
if (c.bgSidebarColor) document.documentElement.style.setProperty("--bg-sidebar-color", c.bgSidebarColor);
if (c.sidebarWidth) document.documentElement.style.setProperty("--sidebar-width", c.sidebarWidth + "px");
if (c.darkMode) document.documentElement.classList.add("dark");
 
// Compact sidebar to a sliver when the user opens links in the desktop app.
if (JSON.parse(localStorage.getItem("userSettings") || "{}").openLinksInDesktop) document.documentElement.style.setProperty("--sidebar-width", "8px");
 
</script>
```

Before any bundle has parsed, the JavaScript from `index.html` reads `localStorage.splashScreenConfig`, merges any `sessionStorage` override on top, and applies the user's remembered shell tokens directly to `document.documentElement.style`: sidebar background, base color, border color, sidebar width, agent toolbar height. It detects color-scheme preference and Electron context. It checks whether `localStorage.ApplicationStore` exists, and if not, adds a logged-out class that switches the shell to the auth layout.在任何包解析之前，来自 `index.html` 的 JavaScript 会读取 `localStorage.splashScreenConfig` ，在其基础上合并 `sessionStorage` 的任何覆盖值，并将用户记住的外壳令牌直接应用到 `document.documentElement.style` ：包括侧边栏背景、基础颜色、边框颜色、侧边栏宽度、智能体工具栏高度。它会检测配色方案偏好和 Electron 上下文。同时会检查 `localStorage.ApplicationStore` 是否存在，若不存在则添加登出类，将外壳切换至认证布局。

By the time the first JavaScript bundle comes from the network the loading screen is already correctly themed, sized, and positioned for whether the user is logged in.当第一个 JavaScript 包从网络加载完成时，加载界面已根据用户是否登录完成了正确的主题、尺寸设置和位置调整。

This gives the user the feeling that the app is ready to go as soon as they hit enter in the URL bar. There's no faster way around this than sending down the initial app shell in the initial `index.html` response.这会让用户产生一种只要在地址栏按下回车键，应用就准备就绪的感觉。要实现这一点，最快的方法就是在初始的 `index.html` 响应中直接下发初始应用壳。

![HoverNotes Icon](chrome-extension://fhdmbhgpabjkadpaafomaabbdckofphm/assets/icons/hover-notes-icon-white.svg)

HoverNotes Icon

### Render first, authenticate second 先渲染，后认证

Authentication is another step where most apps give up their performance budget. The conventional flow: fetch the HTML, load the bundle, validate the session, fetch the user, fetch the workspace, then render. One to three seconds before the user sees anything.身份验证是大多数应用牺牲性能预算的又一个环节。常规流程为：获取 HTML、加载包、验证会话、获取用户信息、获取工作空间，然后进行渲染。用户看到任何内容之前要等待一到三秒。

Linear treats auth the same way it treats mutations. Assume the happy path and verify in the background. This is probably one of my favorite parts of their architecture because it allows them to almost immediately render the full experience on load.Linear 对权限的处理方式与对突变的处理方式相同。假设一切顺利，并在后台进行验证。这可能是他们架构中我最喜欢的部分之一，因为这让他们能在页面加载时几乎立即呈现完整的使用体验。

Most CRUD apps keep the real session in an HttpOnly cookie, then add a second JS-readable cookie or `/me` request so the frontend can tell whether the user is logged in during startup. Linear does something simpler. Instead of maintaining a parallel auth signal, the inline boot script just checks whether `localStorage.ApplicationStore` exists:大多数 CRUD 应用会将真实会话存储在 HttpOnly Cookie 中，然后添加第二个可由 JavaScript 读取的 Cookie 或 `/me` 请求，以便前端在启动时判断用户是否登录。Linear 的做法更简单。它无需维护并行的身份验证信号，内联启动脚本只需检查 `localStorage.ApplicationStore` 是否存在即可：

```javascript
if (localStorage.getItem("ApplicationStore") === null) {
  document.documentElement.classList.add("logged-out");
}
```

If it's there, the user has used Linear in this browser before, which means their workspace is already sitting in IndexedDB. This goes back to the first section we covered where the database lives in the browser. If it's missing, there's nothing to render anyway, so the shell flips to its logged-out layout and the login flow takes over.如果存在该数据，说明用户此前在该浏览器中使用过 Linear，这意味着他们的工作区已存储在 IndexedDB 中。这回到了我们之前讲的第一部分内容：数据库存储在浏览器里。如果该数据不存在，那么也没有任何内容可渲染，因此应用外壳会切换到未登录布局，登录流程随即接管。

The initial flow for Linear isn't "do you have a valid session." It's "do we have anything to show you." Their actual session token sits in a cookie. The bundle never tries to be smart about it. It just renders what it has and lets the next request (the WebSocket handshake, a sync delta, any HTTP call) be the thing that fails with a 401 if the session has gone stale. When that happens, the client redirects to login.Linear的初始流程并非“你是否拥有有效会话”，而是“我们有什么内容可以展示给你”。其实际的会话令牌存储在Cookie中。这个前端代码包从不会刻意处理这种情况，它只会渲染已有的内容，然后让下一次请求（WebSocket握手、同步增量数据、任意HTTP调用）在会话失效时返回401错误。一旦出现这种情况，客户端就会重定向到登录页面。

The whole pattern is consistent with the rest of the architecture: the client trusts what's local, the server is the source of truth for correctness, and the two reconcile asynchronously. Just like a mutation. Just like their sync engine.整个模式与架构的其余部分保持一致：客户端信任本地内容，服务器是正确性的权威来源，二者以异步方式进行协调。就像一次变更操作。也像它们的同步引擎。

![HoverNotes Icon](chrome-extension://fhdmbhgpabjkadpaafomaabbdckofphm/assets/icons/hover-notes-icon-white.svg)

HoverNotes Icon

This is maybe one of my favorite details about Linear that I wish more apps behaved this way. For authentication, assume happy path, and fallback if not. If there's data to be shown: show it! And leverage your browser's datastores to render immediately.这或许是我最喜欢 Linear 的一个细节，我希望更多应用都能这样做。关于身份验证，采用乐观路径，若不满足则回退。若有数据可展示，就直接呈现！并利用浏览器的数据存储实现即时渲染。

---

## The sync engine 同步引擎

Most of what makes Linear fast lives downstream of one decision: the server is a sync target, not a source of truth for the UI. The internals of their sync engine been thoroughly reverse-engineered already, and Tuomas has given multiple excellent talks on the architecture. I'm not going to retrace them. What I want to do is name the three pillars that actually produce the speed, because the speed is a property of how they fit together, not of any single one.让 Linear 如此快速的核心原因，大多源于一个关键决策：服务器是同步目标，而非用户界面的真实数据来源。其同步引擎的内部结构早已被彻底反向工程，图奥马斯也就该架构发表过多次精彩演讲，我在此不再赘述。我想做的是点明造就其速度的三大支柱，因为这种速度是三者协同运作的结果，而非某一个单独要素的功劳。

### 1\. The data is already there 1. 数据已就位

When the app boots, it doesn't fetch the workspace from the server. It hydrates from IndexedDB into an in-memory MobX object pool, and every query from the UI goes to the pool first. There's no "loading issues" state because the issues are already on the user's machine.应用启动时，不会从服务器获取工作区。它会从 IndexedDB 中恢复为内存中的 MobX 对象池，UI 发出的每一次查询都会优先访问该对象池。由于问题数据早已存储在用户本地设备上，因此不存在“加载问题”的状态。

Something I found interesting is as they've scaled they've chunked the data in the sync enginer using the similar fundamentals as their JavaScript bundles. Not everything is fetched at once: the two heaviest tables, Issue and Comment, lazy-hydrate on demand. This is data-level code splitting, and it's what lets the engine scale: startup cost tracks the workspace structure, not the workspace size. A 10,000-issue workspace boots about as fast as a 100-issue one.我发现一个有趣的点是，随着规模扩大，他们在同步引擎中对数据进行分块处理，采用的基本原理与 JavaScript 包类似。并非所有数据都会被一次性获取：数据量最大的两张表——问题表（Issue）和评论表（Comment），会根据需求进行懒加载。这是一种数据层面的代码拆分，也正是引擎能够实现规模化的关键：启动成本取决于工作区的结构，而非工作区的大小。一个包含10000个问题的工作区，启动速度与只有100个问题的工作区几乎一样快。

Click into a project, the issues are there. Filter by assignee, the index is already built. There's nothing to fetch because there's nothing missing. It's either been immediately loaded from your browser or shortly after in a codesplit lazy chunk.点击进入某个项目，问题列表就会显示出来。按负责人筛选时，索引已预先构建完成。无需获取任何数据，因为不存在缺失内容。这些内容要么已从浏览器直接加载，要么会在代码分割的懒加载块中很快加载完毕。

![](https://media.performance.dev/cdn-cgi/image/width=2400,quality=100,format=auto,fit=scale-down/posts/p_gAMR6Z7y49Fp/IdWPGINS86Ge.png)

IndexedDB: the database is in your browser IndexedDB：你的浏览器内置数据库

### 2\. Mutations don't wait for the network2. 变更不等待网络

When you change an issue's status, three things happen almost at once: the MobX observable updates so the UI reflects the change, the mutation is written to a durable transaction queue in IndexedDB, and it's queued for the server. The network hasn't been touched yet.当你更改一个议题的状态时，几乎会同时发生三件事：MobX 可观察对象更新，使用户界面反映出这一变化；该变更会被写入 IndexedDB 中的持久事务队列；同时还会被加入服务器的请求队列。此时网络尚未进行任何操作。

The user never waits to see their own change. The retry, the rollback, the durability across reloads, all background. If the server rejects, the observable reverts and there's a brief flicker, but in practice that almost never happens because most invalid mutations are caught before the transaction is even created.用户从不会等待查看自己的修改结果。重试、回滚、重载后的持久化操作，全部都在后台完成。如果服务器拒绝请求，可观察对象会恢复原状，界面会短暂闪烁一下，但实际上这种情况几乎不会发生，因为绝大多数无效的变更都会在事务创建前就被拦截。

As I keep saying: the network is the enemy and you must do everything you can to avoid it. Linear's flow starts with the local mutation and treats the server as a confirmation step, not a permission step.我一直强调：网络就是敌人，你必须竭尽所能避开它。Linear 的流程始于本地变更，并将服务器视为确认步骤，而非授权步骤。

### 3\. One delta, one cell 3. 一个增量，一个单元格

When the server confirms a mutation (yours or someone else's), the change comes back as a small JSON envelope describing what moved. The client applies it by writing to the corresponding MobX observable.当服务器确认一次变更（无论是你的还是他人的）时，该变更会以一个小型 JSON 封装的形式返回，描述具体的变动内容。客户端会通过写入对应的 MobX 可观察对象来应用该变更。

Because every property on every model in Linear is its own observable, and every component that reads one is wrapped in `observer()`, MobX knows exactly which components depend on which fields. A change that updates one field of one issue re-renders exactly the components that read that field. Not the parent list, not the sidebar, one cell. A 50-issue update is 50 cell re-renders, not a list re-render. This is what lets a busy workspace stay smooth when ten people are editing things at once: the cost of receiving updates scales with what changed, not with what's on screen.在 Linear 中，由于每个模型上的所有属性都是独立的可观察对象，且读取这些属性的每个组件都被包裹在 \` `observer()` \` 中，MobX 能精准知晓哪些组件依赖于哪些字段。当修改某一工单的单个字段时，只有读取该字段的组件会重新渲染，而非父列表、侧边栏或单个单元格。对 50 个工单的更新仅会触发 50 个单元格的重新渲染，而非整个列表。这正是繁忙的工作区在十人同时编辑时仍能保持流畅的原因：接收更新的开销取决于实际修改的内容，而非屏幕上显示的内容量。

I've built real-time apps streaming in stock data and fundamentals and having atomic updates of individual components it key to making an app feel performant. You want to avoid cascading updates as much as possible and Linear does exactly that.我开发了用于实时传输股票数据和基本面信息的应用程序，而让单个组件实现原子更新，是让应用运行流畅的关键。你需要尽可能避免级联更新，而 Linear 恰好能做到这一点。

![HoverNotes Icon](chrome-extension://fhdmbhgpabjkadpaafomaabbdckofphm/assets/icons/hover-notes-icon-white.svg)

HoverNotes Icon

### Why the three fit together 为何这三者缺一不可

Take any one away and the app starts to feel slow. A local database without optimistic writes still spins on save. Optimistic writes without granular observables still jank on every update. Granular observables without a local database still wait on initial load. Linear's speed isn't a property of any single layer. It's a property of the system.拿掉其中任何一层，应用都会开始变得卡顿。不支持乐观写入的本地数据库在保存时仍会反复加载。没有细粒度可观察对象的乐观写入在每次更新时仍会出现卡顿。没有本地数据库的细粒度可观察对象在初始加载时仍需等待。Linear 的速度并非某一层的特性，而是整个系统的特性。

The bundler and loader shell are what make the app feel fast on first paint. The sync engine is what keeps it feeling fast once you start using it.打包器和加载器外壳让应用在首次渲染时就拥有流畅的体验，而同步引擎则能在你开始使用应用后，持续保持这种流畅感。

---

## Designed for speed 为速度而设计

Speed isn’t just an engineering problem. It’s a design problem too. A perfectly built sync engine still loses to a slow input model: if the fastest path to an action requires a mouse, three menus, and a click, the user pays for those steps regardless of how fast the underlying engine runs.速度不仅仅是一个工程问题，它同样是一个设计问题。一个构建完美的同步引擎，在输入缓慢的模型面前依然会败下阵来：如果完成某个操作的最优路径需要使用鼠标、打开三级菜单并点击一次，那么无论底层引擎的运行速度有多快，用户都得为这些操作步骤付出时间成本。

Another cornerstrone to Linear's speed is how they've intergarated the keyobard as a priamry tool to navigate and complete your work. Every common action has a shortcut. The command palette is one keystroke away. The right-click menu is custom-built. None of these are accidents but instead thoughtful design decision from day one.Linear 之所以能实现极速体验，另一大核心优势在于其将键盘整合为导航和完成工作的核心工具。每一个常用操作都配有快捷键，命令面板一键即可调出，右键菜单更是量身定制。这些设计绝非偶然，而是从一开始就经过深思熟虑的决策。

### Every action has a shortcut 每个操作都有快捷键

Single letters edit the focused issue. Two-letter combos navigate. Modifiers act globally.单字母快捷键编辑焦点问题。双字母组合实现导航。修饰键全局生效。

Listening to the founders talk about Linear’s early days, it’s clear that shortcuts were foundational from the start. The sync engine was designed in part so that any action could be performed at any time. It feels like this combination of design and engineering is continues to be behind every feature.听创始人讲述 Linear 的早期历程，不难发现捷径从一开始就是其核心基础。同步引擎的部分设计初衷，就是为了让任何操作都能在任意时间执行。如今，这种设计与工程的融合，似乎依然是每一项功能背后的支撑。

If you look through their UI you'll notice shortcuts visible everywhere. The most frequent ones are single characters as they're used the most often. Furthermore, every action can be done with a mouse as not to alienate beginners.如果你浏览它们的用户界面，会发现随处可见可见的快捷键。最常用的是单个字符，因为它们的使用频率最高。此外，所有操作都可以通过鼠标完成，以免让新手感到无所适从。

![](https://media.performance.dev/cdn-cgi/image/width=1584,quality=100,format=auto,fit=scale-down/posts/p_gAMR6Z7y49Fp/2Jd6ZXiwNCwp.jpg) ![](https://media.performance.dev/cdn-cgi/image/width=1584,quality=100,format=auto,fit=scale-down/posts/p_gAMR6Z7y49Fp/2__J_PuPKayE.jpg) ![](https://media.performance.dev/cdn-cgi/image/width=1584,quality=100,format=auto,fit=scale-down/posts/p_gAMR6Z7y49Fp/MuG3qxjnzrQq.jpg) ![](https://media.performance.dev/cdn-cgi/image/width=1584,quality=100,format=auto,fit=scale-down/posts/p_gAMR6Z7y49Fp/KgHIdD85Bfr5.jpg) ![](https://media.performance.dev/cdn-cgi/image/width=1584,quality=100,format=auto,fit=scale-down/posts/p_gAMR6Z7y49Fp/jvagQZ3l8V3y.jpg) ![](https://media.performance.dev/cdn-cgi/image/width=1584,quality=100,format=auto,fit=scale-down/posts/p_gAMR6Z7y49Fp/Y6mUzOgZJJHW.jpg)

### The command palette is always one keystroke away命令面板始终只需一次按键即可调出

`⌘ k` opens a command palette that lets users search over almost any action in Linear. Issues, projects, labels, status changes, navigation, issue creation, settings, theme toggles. The command is incredibly fast because it's searching the local MobX object pool, not a server. Remember, avoid the network.`⌘ k` 可打开命令面板，让用户搜索 Linear 中几乎所有操作。包括问题、项目、标签、状态变更、导航、创建问题、设置、主题切换等。该命令速度极快，因为它搜索的是本地 MobX 对象池，而非服务器。切记，要避免网络请求。

The architectural payoff is that the entire app is accessible from a single pane. Navigation is search. Issue creation is search. Status changes are search scoped to statuses. Moreoever, the command is contextual and adapts to the what you're working on. A great way to teach key actions and shortcuts for any view. One primitive, used everywhere, running on data that's already in memory.架构层面的优势在于，整个应用都可通过单一面板访问。导航是搜索操作。创建问题也是搜索操作。状态变更则是限定于特定状态的搜索。此外，该命令具备上下文感知能力，会根据你正在处理的内容进行适配。这是向用户讲解任意视图的核心操作和快捷键的绝佳方式。这一基础功能被应用在所有场景中，依托的是已加载到内存中的数据运行。

A fast app needs both incredible engineering and design. You can build a perfect sync engine and a flawless rendering pipeline, and still ship something that feels slow if the design is wrong. Engineering speed makes a single interaction fast. Design speed makes the path to each interaction short.一款出色的应用既需要卓越的工程技术，也离不开优秀的设计。即便你打造出了完美的同步引擎和无瑕疵的渲染管线，但若设计存在缺陷，最终推出的产品依然可能给人卡顿的感觉。工程层面的速度能让单次操作响应迅速，而设计层面的效率则能缩短完成每一项操作的流程路径。

For a tool used all day, the difference between a shortcut and a two-second mouse path compounds over every action. Combine shortcuts with a global commmand palette and you've got yourself an app that's incredibly fast to use.对于一款全天使用的工具来说，快捷键与两秒的鼠标移动路径之间的差异，会在每一次操作中不断累积。将快捷键与全局命令面板结合起来，你就能拥有一款使用起来极其流畅的应用程序。

---

## Animations 动画

All the work up to now can still be undone by bad animations. Teams spend enormous effort making every part of their app fast. Initial load, updates, database queries, all of it. They shave off milliseconds so users never have to wait. Then, at the very last step, someone adds a 500ms height animation to an element.到目前为止所做的所有工作，仍可能因糟糕的动画效果而前功尽弃。开发团队会付出巨大努力让应用的各个部分都运行流畅，包括初始加载、数据更新、数据库查询等所有环节。他们会争分夺秒地缩减耗时，确保用户无需等待。然而，在最后一步，有人却给某个元素添加了一个500毫秒的高度动画。

### There are only a handful of properties you should animate只有少数几个属性适合设置动画

Browsers have three tiers of property changes, and the cost scales with how high each one is on the rendering pipeline. Composited properties (`transform`, `opacity`) hand the work to the GPU and run independent of the main thread. Paint-triggering properties (`color`, `background-color`, `border-color`, `fill`) skip layout but still redraw pixels. Layout-triggering properties (`width`, `height`, `top`, `left`, `margin`, `padding`) force the browser to recompute the position of every subsequent element on the page. Never animate those. I mean never.浏览器对属性变更分为三个层级，其性能成本会随属性在渲染管线中的层级升高而增加。合成属性（ `transform` 、 `opacity` ）会将工作交由图形处理器（GPU）处理，且独立于主线程运行。触发重绘的属性（ `color` 、 `background-color` 、 `border-color` 、 `fill` ）会跳过布局计算，但仍会重新绘制像素。触发布局的属性（ `width` 、 `height` 、 `top` 、 `left` 、 `margin` 、 `padding` ）会迫使浏览器重新计算页面上每个后续元素的位置。绝对不要对这些属性做动画效果，我说的是绝对不要。

```css
/* What Linear does */
.row:hover {
  background-color: var(--color-bg-hover);
  transition: background-color 0.12s;
}
.icon-arrow {
  transform: translateX(0);
  transition: transform 0.15s;
}
 
/* What you'd write if you didn't know better */
.row:hover {
  margin-left: 2px;       /* triggers layout for every row beneath */
  transition: all 0.2s;   /* and now you're animating margin */
}
```

The `margin-left` version recomputes the layout of every row beneath the hovered one, on every frame, for the full 200ms of the transition. On a long issue list that's the difference between buttery and jank.`margin-left` 版本会在过渡的整整 200 毫秒内，每一帧都重新计算悬停行下方每一行的布局。在较长的问题列表中，这会带来流畅与卡顿的天壤之别。

If you go over every single property Linear animates in their app it's reserved to a handful, mostly those composited properties (`transform` and `opacity`) and sometimes properties like `background-color` and `border-color`.如果你查看 Linear 应用中每一个动画的属性，会发现它们只涉及少数几个，主要是那些合成属性（ `transform` 和 `opacity` ），有时还包括 `background-color` 和 `border-color` 这类属性。

### Know when to hold back 懂得何时克制

In my opionion, what's almost as important as only animating composite properties is knowing when to not animate at all. It's easy to get carried away with animations. But in a tool used every day, the animations you'd love on a marketing site start to get in the way. Even a small hover delay, in the wrong place, becomes the thing the user notices.在我看来，几乎和只对复合属性设置动画同样重要的，是知道何时完全不设置动画。动画很容易让人过度使用。但在一款日常使用的工具中，你在营销网站上很喜欢的那些动画反而会成为干扰。哪怕是一个很小的悬停延迟，只要出现在错误的位置，就会成为用户注意到的问题。

Linear nails most of this. The command palette is the one I'd argue is too slow, but I've become a cranky old man over the years.Linear 解决了大部分问题。我得说命令面板的速度太慢了，不过这些年我也变成了一个爱抱怨的老头。

![HoverNotes Icon](chrome-extension://fhdmbhgpabjkadpaafomaabbdckofphm/assets/icons/hover-notes-icon-white.svg)

HoverNotes Icon

The reason a lot of their animations work is that they reference their origin. The status popover scales out of the status pill. The agent panel slides in from its toggle. The motion is doing spatial work, telling the user where the new element came from, rather than fading in from nowhere as decoration. 他们的很多动画之所以效果出色，是因为它们都有明确的来源参照。状态弹出框从状态胶囊中缩放展开，智能体面板从对应的切换按钮处滑入。这种动效承担了空间定位的作用，向用户告知新元素的来源，而非毫无来由地淡入作为装饰效果。

### Keep durations short and snappy 保持动画时长简短利落

```css
/* variables form Linear's stylesheet */
 
--speed-highlightFadeIn: 0s;
--speed-highlightFadeOut: .15s;
--speed-quickTransition: .1s;
--speed-regularTransition: .25s;
--speed-slowTransition: .35s;
```

Most design systems default longer than they should. Material's standard duration is 200ms, iOS's spring closer to 350ms. Defaulting to shorter transitions is one of the easiest ways to make an app feel faster, and Linear's defaults sit well below the industry norm.大多数设计系统的默认时长都比实际需要的更长。Material 的标准时长为 200 毫秒，iOS 的弹性动画时长则接近 350 毫秒。将过渡效果默认设置得更短，是让应用运行起来更流畅的最简单方法之一，而 Linear 的默认时长远低于行业标准。

Linear takes this one step further with asymmetric timing on enter and exit. Hover highlights, popovers, and the agent panel appear instantly when you summon them, then fade out over 150ms when you dismiss them.Linear 在此基础上更进一步，让进入和退出的时机呈现非对称状态。悬停高亮、弹出窗口和智能体面板在调出时会立即显示，而在关闭时则会在 150 毫秒内逐渐淡出。

![HoverNotes Icon](chrome-extension://fhdmbhgpabjkadpaafomaabbdckofphm/assets/icons/hover-notes-icon-white.svg)

HoverNotes Icon

As a small side note, one of Linear's Design Engineers, [Emil Kowalski](https://x.com/emilkowalski), created an incredible course at [animations.dev](http://animations.dev/). If you found the last couple of sections interesting, it's worth checking out. He dives deep into animation principles with plenty of examples and practical tutorials.顺带提一句，Linear 的一位设计工程师埃米尔·科瓦尔斯基</b>在 [animations.dev](http://animations.dev/) 上制作了一门非常棒的课程。如果你觉得前面几节内容很有意思，很值得去看看。他结合大量示例和实用教程，深入讲解了动画原理。

---

## How Linear is so fast Linear 为何能如此流畅

There are so many more details I could cover that make Linear feel fast. The reality is there's no single thing that makes an app performant. It's the culmination of hundreds of decisions made correctly.我还可以补充更多细节，这些细节都让 Linear 用起来飞快。但事实是，没有哪一个单一因素能让一款应用达到高性能，而是数百个正确决策共同作用的结果。

What I love about Linear's approach is how simple most of it is. No Next, no Tanstack, no fancy framework. They decided early on what architecture would serve their users best and have stayed true to it. The result is a client-side rendered app that's faster than server-rendered ones (and without the complexity)!我喜欢 Linear 这种做法的地方在于其大部分设计都十分简洁。没有 Next、没有 Tanstack，也没有花哨的框架。他们很早就确定了最能服务用户的架构，并始终坚守这一选择。最终打造出的客户端渲染应用，速度比服务端渲染应用更快，而且还省去了复杂的技术实现！

The shape of it is roughly this. The server is a sync target rather than a source of truth. The database lives in the browser. Mutations apply locally first and reconcile in the background. The first load ships less code in more pieces, with a service worker precaching the rest while the user is still on the login page. Auth is assumed based off state and verified later. The sync engine hydrates from IndexedDB into per-property MobX observables, so a 50-issue update is 50 cell re-renders rather than a list re-render. The input model is keyboard-first. Every common action has a shortcut with a global command palette. Animations stay on the GPU, durations sit below the 100ms cause-and-effect threshold, and layout-triggering properties are never animated.它的大致架构如下。服务器是同步目标，而非事实来源。数据库存在于浏览器中。变更先在本地应用，再在后台进行协调。首次加载会以拆分后的少量代码交付，服务工作线程会在用户仍处于登录页面时预缓存其余内容。身份验证基于状态进行假定，并在后续完成验证。同步引擎会将 IndexedDB 中的数据转换为按属性划分的 MobX 可观察对象，因此更新 50 个任务只会触发 50 个单元格重新渲染，而非整个列表重新渲染。输入模型以键盘操作为优先。所有常见操作都配有快捷键，并配备全局命令面板。动画始终在 GPU 上运行，持续时间低于 100 毫秒的因果阈值，且不会对会触发布局的属性设置动画。

The hard part isn't the implementation. It's the dedication to the craft over years, as the codebase matures, expands, and pushes up against new constraints.困难的不在于实现本身，而在于随着代码库不断成熟、扩展并面临新的限制，多年来对这门手艺的坚守。

If you haven't, I'd recommend checking out [Linear](https://linear.app/) to see it all in action.如果你还没体验过，我推荐你去看看 [Linear](https://linear.app/) ，亲眼看看它的全部功能是如何实际运作的。

---

Hope you learned a thing or two! It was fun writing this and diving into the details that make Linear what it is. I just love building the best web apps in the world and see how other people do it. If you have any feedback, suggestions, or want to connect you can [find me on X.](https://x.com/brotzky)希望你有所收获！写这篇内容并深入探究造就 Linear 独特之处的细节，过程十分有趣。我就是热衷于打造全球最优质的网络应用，也喜欢看看其他人是怎么做的。如果你有任何反馈、建议，或是想和我交流，可以在 [X 平台上找到我](https://x.com/brotzky) 。