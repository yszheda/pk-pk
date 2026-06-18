---
title: "Local Qwen isn't a worse Opus, it's a different tool"
source: "https://blog.alexellis.io/local-ai-is-not-opus/"
author:
  - "[[Alex Ellis]]"
published: 2026-06-17
created: 2026-06-18
description: "We've all heard people say that Qwen is near-Opus level, but I have receipts and am here to be transparent with you."
tags:
  - "ToRead"
---
We've all heard people say that local Qwen 27B or 35-A3B is "near-Opus level", but I have receipts from a software business and open source projects, and am here to be transparent with you.我们都听过有人说本地的通义千问 27B 或 35-A3B 模型达到了“接近 opus 级别”的水平，但我有来自软件业务和开源项目的实际数据，今天就来跟大家坦诚地聊一聊。

> This post is long-form for a reason. It's not a cursory glance, an unsubstantiated claim on X about cancelling Claude Max, or a hobbyist report from a model running at single-digit tokens per second with a 32K context window. It isn't written by a famous CEO tweeting about coding from an airplane.这篇长文的撰写是有原因的。它不是浅尝辄止的浏览，不是在 X 平台上关于取消 Claude Max 的无根据言论，也不是由一个以每秒个位数令牌速度运行 32K 上下文窗口模型的爱好者撰写的报告。它也不是由某位著名首席执行官在飞机上发推文谈论编程时写就的。
> 
> It's my journey as a founder in a small software business, where local models have produced real, caveated value. I have skin in the game, but no incentive to push either cloud or local models, and a strong desire for local models to become capable and reliable.这是我作为一家小型软件公司创始人的亲身经历，在这段历程中，本地模型已切实创造出附带条件的价值。我切身参与其中，却没有动力去推广云模型或本地模型中的任何一方，同时也热切期盼本地模型能够变得功能强大且运行稳定。

I'll cover how the card paid for itself in the first two or three months, how it keeps serving our specific business use case, why I still can't trust it unsupervised, and Qwen's worst trait: the infinite loops and hallucination risk. These show up most when you quantize it down to fit a consumer GPU.我会介绍这张卡在头两三个月如何回本、它如何持续适配我们特定的业务场景、为何我仍无法在无监督的情况下信任它，以及通义千问最糟糕的特性：无限循环与幻觉风险。这些问题在你为适配消费级显卡对其进行量化处理时表现得最为明显。

![Figuring out the power connectors for the RTX 6000 Pro](https://blog.alexellis.io/content/images/2026/06/17/6000.jpg)

> Figuring out the power connectors for the RTX 6000 Pro 弄清楚 RTX 6000 Pro 的电源连接器

**On my use case for AI 针对我的人工智能使用场景**

My journey as a maintainer and founder started with OpenFaaS - built completely by hand, as was all software in 2016 up until recently. That meant laying down the core of the project on my own, then inviting others to participate through community - not because I couldn't do it on my own, but because my goal was to build a successful open source project. Around 2017 I tried to fund my time by joining VMware, and in 2019 after changes in the market, I needed a way to fund the work myself, so moved towards open-core and built a bootstrapped company. Today our small team maintains [OpenFaaS](https://openfaas.com/), [SlicerVM](https://slicervm.com/) - AI sandboxes and "the missing API for Linux", [Actuated.com](https://actuated.com/) - self-hosted CI runners for GitHub/GitLab, and [Inlets.com](https://inlets.dev/) - self-hosted HTTP/TCP tunnels.我作为维护者和创始人的历程始于 OpenFaaS——它完全是我亲手搭建的，就像2016年直到最近所有软件的开发方式一样。这意味着我要亲自奠定项目的核心基础，然后通过社区邀请其他人参与——不是因为我无法独立完成，而是因为我的目标是打造一个成功的开源项目。大约在2017年，我试图通过加入VMware来为自己的工作获得资金支持；2019年，随着市场发生变化，我需要一种自主资助项目工作的方式，于是转向了开源核心模式，并创办了一家自筹资金的公司。如今，我们的小团队维护着 [OpenFaaS](https://openfaas.com/) 、 [SlicerVM](https://slicervm.com/) （AI沙箱以及“Linux缺失的API”）、 [Actuated.com](https://actuated.com/) （适用于GitHub/GitLab的自托管CI运行器）和 [Inlets.com](https://inlets.dev/) （自托管HTTP/TCP隧道）。

These products use very low level Linux primitives like containers, Kubernetes, Firecracker microVMs, and networked protocols. If you squint, they're all opinionated infrastructure products focused on: efficiency, user-experience, control and autonomy. They're written in Go, and some have React-based UI components, landing pages, docs, agent skills, and CLIs. Along with the code, we also provide the best-in-class support, because we are lean and willing to do things that don't scale to help customers.这些产品运用了容器、Kubernetes、Firecracker 微虚拟机以及网络协议等极底层的 Linux 原语。粗略来看，它们都是秉持特定设计理念的基础设施产品，核心聚焦于：效率、用户体验、管控与自主化。这些产品采用 Go 语言编写，部分产品还包含基于 React 的用户界面组件、登录页面、文档、智能体技能以及命令行界面。除提供代码外，我们还提供顶尖水准的支持服务，因为我们团队精简高效，愿意做那些无法规模化推广的工作来帮助客户。

I've been using AI tools for as long as they've been available - from tab completion in VS Code in the early days, through to getting ChatGPT to generate chunks of code, or find bugs, to living in tmux 12 hours per day. I found myself in tmux so much of the time that I wrote a free tool [Superterm.dev](https://superterm.dev/) to keep track of my sessions, notes, and to get visual feedback from coding agents. Over that time, I've seen the capabilities go from "reduce boilerplate" to "design, architect, and test end to end". It's Claude or Codex that do the majority of my work, and whilst I insist on doing my own writing, I rarely write code by hand - as much as it pains me to say that.从人工智能工具问世以来，我就一直在使用它们——从早期 VS Code 的代码补全，到让 ChatGPT 生成代码片段、排查漏洞，再到每天有12小时都沉浸在 tmux 终端环境中。我在 tmux 里待的时间太久了，于是开发了一款免费工具 [Superterm.dev](https://superterm.dev/) ，用来管理我的会话、记录笔记，还能从编码智能体那里获取可视化反馈。这段时间里，我见证了这些工具的能力从“减少重复代码”发展到“设计、架构并完成端到端测试”。如今我大部分的工作都由 Claude 或 Codex 完成，尽管我坚持自己撰写文字，但我几乎不再手动写代码了——说这话时我心里也挺不是滋味的。

**A turning point for frontier intelligence 前沿智能的转折点**

I'd say it was roughly between November 2025 and January 2026 that we saw a turning point. Many developers on X started to espouse Claude Opus as having changed and how it was now capable of doing *all of* their work. Manual coding turned bad as quickly as milk sours left out the fridge. The costs of the top-end coding plans settled at roughly 200 USD / mo for individuals. A real number, but tolerable for the value they generated. Even today, if you avoid too much unattended work, you can make it last through the 5 hour limit, and weekly limit if you're careful.我认为我们看到转折点的时间大致在2025年11月到2026年1月之间。X平台上的许多开发者开始宣称Claude Opus已经升级，如今它能够完成 *所有* 工作。手动编码的效率下降得就像放在冰箱外的牛奶变酸一样快。面向个人用户的顶级编码套餐费用稳定在每月约200美元。这是一个实实在在的数字，但就其带来的价值而言是可以接受的。即便在今天，如果你避免过多无人值守的任务，你也能在5小时限制内用完额度，要是足够细心，还能撑过周额度限制。

**What makes local models interesting 是什么让本地模型变得有趣**

> There's an argument that says: "Why use anything less than the best you can afford?" 有一种观点认为：“为什么要选择超出自己承受能力的最佳方案呢？”

The year of 2026 certainly is a new frontier: we find ourselves in a place where any idea can be cloned overnight by someone you've never heard of with a subscription in a developing nation. I've seen it happen to our SlicerVM product (originally written by hand in 2022) and Superterm (new in 2026, 100% written by coding agents). It's not to say that a vibecoded clone is a 100% equivalent of a well engineered and architected solution with an experienced team supporting it, but a market where the cost of software went to nil - free and good enough can be all that matters.2026年无疑是一片新的前沿领域：我们身处这样一个时代，任何创意都可能被某个你从未听说过、只需订阅服务的发展中国家用户在一夜之间克隆出来。我亲眼见过我们的SlicerVM产品（2022年最初由人工手写代码开发）和Superterm（2026年全新推出，100%由编码智能体编写）遭遇这种情况。这并非说，仅凭氛围编码生成的克隆产品，就能与由经验丰富团队支撑、设计精良且架构完善的解决方案相提并论，但在一个软件成本趋近于零的市场里——免费且足够好用，或许就成了唯一重要的事。

So in such a competitive landscape, why limit yourself to something that's worse? Isn't that an opportunity cost? Isn't that risking your livelihood?在如此竞争激烈的环境中，为什么要让自己局限于更差的选择呢？这难道不是一种机会成本吗？这难道不是在拿自己的生计冒险吗？

There are estimates that the leading models contain between 0.5-2T parameters. That's not just "marginally more" or a "few times more" than the best in class for local hardware - that's on a different level. The parameter count is a rough proxy for capacity, knowledge, and reasoning ability. Yet somehow, even a tiny dense model like Qwen 3.6 27B is able to score a reputable benchmark of 77.2 on [SWE-Bench Verified](https://qwen.ai/blog?id=qwen3.6-27b) vs 88.6% from Claude Opus 4.8.有估计显示，主流模型的参数数量在0.5万亿到2万亿之间。这相比本地硬件领域的顶尖模型，不只是“略多”或“多几倍”的差距，而是处于完全不同的层级。参数数量是衡量模型容量、知识储备和推理能力的一个粗略指标。然而，即便是通义千问3.6 27B这样规模较小的密集型模型，也能在 [SWE-Bench Verified](https://qwen.ai/blog?id=qwen3.6-27b) 这一权威基准测试中取得77.2的高分，而Claude Opus 4.8的得分则为88.6%。

So you could be forgiven for taking to X and shouting loudly that "local is only 12% behind SOTA" and many have, including engaging one-shotted demos of space invaders. You may go as far as claiming that a single 6-year old GPU can replace your 200 USD / mo ChatGPT Pro subscription, and indeed many have made that claim.所以你在 X 平台上大声疾呼“本地模型仅比当前最优技术落后12%”，这完全可以理解，而且已经有很多人这么做了，其中还包括令人眼前一亮的《太空侵略者》单轮演示。你甚至可能会声称，一块6年前的GPU就能取代你每月200美元的ChatGPT Pro订阅，事实上，也确实有不少人提出过这样的说法。

**Benchmaxxing 跑分内卷**

Benchmarks are a moving target, and since they're widely available, it's possible to educate and tune a model to obtain a higher score than they would otherwise on these tests. The classic SWE-Bench Verified benchmark is based upon a set of Python issues across a number of Open Source projects. Python has threads, and async, however most code you run into is single-threaded and synchronous. In contrast, we write distributed systems in Go, where channels, contexts, and structs span across a large execution domain.基准测试是一个不断变化的目标，而且由于它们广泛可用，我们可以对模型进行指导和调优，使其在这些测试中获得比原本更高的分数。经典的 SWE-Bench Verified 基准测试基于多个开源项目中的一组 Python 问题。Python 支持线程和异步编程，但你遇到的大多数代码都是单线程且同步的。相比之下，我们用 Go 语言编写分布式系统，其中的通道、上下文和结构体覆盖了庞大的执行域。

**Cost 成本**

There's a very popular take "local models aren't about cost" and that comes from a position of privilege. Individuals can use coding plans that provide high amounts of usage through a working day for 200 USD / mo. On that basis, you are getting SOTA level intelligence, the best chance of something working and being of quality, of finding that bug, or generating that landing page.有一种很流行的说法是“本地模型无关乎成本”，但这种观点源于一种特权心态。个人可以通过编码方案，以每月200美元的价格在工作日内实现高频率的使用。基于这一条件，你能获得当前最先进水平的智能，拥有让方案落地且保证质量的最大可能，也能更顺利地定位漏洞或生成落地页。

Coding plans are clearly subsidised, just look at what happened to GitHub Copilot plans. They started off by giving away 1500 requests for 39 USD / mo and you could make that last a very long time for pennies. Something that was undisclosed changed at GitHub/Microsoft/Azure, and they moved everyone over to token-based pricing and the backlash was huge. The true cost had been hidden for so long, we'd become accustomed to it.编码计划显然有明确补贴，看看 GitHub Copilot 计划的变化就知道了。起初他们推出的是每月 39 美元可使用 1500 次请求的套餐，花几分钱就能用很久。后来 GitHub、微软和 Azure 方面有了未公开的调整，将所有人都转为了基于令牌的计费方式，引发了巨大的反对声浪。真实成本被隐藏了太久，我们早已对此习以为常。

Now, if you're paying for tokens on API rates, the breaking point comes sooner than many of us realise. Recently, [Uber capped spend](https://uk.finance.yahoo.com/news/uber-caps-monthly-employee-ai-180608705.html) to 1500 USD / mo per developer per tool. The median salary at Uber is 330k USD annually, so if a developer used two tools to the maximum extent, it's roughly 12% of their annual compensation.现在，如果你按照 API 费率为令牌付费，那么临界点会比我们很多人意识到的来得更早。最近， [优步设定了消费上限](https://uk.finance.yahoo.com/news/uber-caps-monthly-employee-ai-180608705.html) ，每位开发者每个工具每月最高花费 1500 美元。优步员工的年薪中位数为 33 万美元，因此如果一名开发者将两款工具都用到极致，相关费用大约占其年薪的 12%。

So for heavy use, loops, agentic analysis, in-product capabilities deployed through SaaS systems, open weight, or local models can provide serious value. It's not fair to rule out cost, but for many it's not about that.因此，对于高频使用、循环任务、智能体分析、通过SaaS系统部署的产品内功能，开源权重模型或本地模型能够带来实实在在的价值。成本问题固然不能忽视，但对很多场景而言，核心考量并非成本。

**Sovereignty and privacy 主权与隐私**

We work with various enterprise customers that take data controls very seriously. If you squint at our product line, we're all about privacy and sovereignty. OpenFaaS runs functions on your infrastructure, with your limits and preferred languages, and events. SlicerVM runs microVMs not on some abstracted cloud-based bare-metal, but on your own kit, even your MacBook. Inlets runs tunnels where you can control the tunnel client and server with 100% privacy. Actuated takes the arduous parts of GitHub Actions away and says "install an agent on your machines and forget about it".我们与众多高度重视数据管控的企业客户展开合作。审视我们的产品系列，核心都围绕隐私与主权展开。OpenFaaS 在你的基础设施上运行函数，支持你自定义的限制条件、偏好语言以及各类事件。SlicerVM 并非在抽象的云环境裸金属服务器上运行微型虚拟机，而是部署在你自有设备上，甚至你的 Mac 电脑也可以。Inlets 提供隧道服务，你可以完全掌控隧道客户端与服务器，保障100%的隐私。Actuated 则解决了 GitHub Actions 中繁琐的操作环节，只需“在你的设备上安装一个代理，后续无需再操心”。

So naturally, we are drawn to local models - both from our core values and beliefs about how the Internet should be, but through obligations.因此，自然而然地，我们被本地模型所吸引——这既源于我们对互联网应然状态的核心价值观与信念，也源于我们的责任与义务。

You may not hold these beliefs, you may not handle any customer data, but if you live outside of the US, the removal of Anthropic's Fable 5 model overnight might have come as a shock. In other words, there is serious vendor risk, and many of us are addicted to the source.你可能并不持有这些观点，也可能从未处理过任何客户数据，但如果你身处美国境外，Anthropic 的 Fable 5 模型一夜之间下架或许会让你感到震惊。换句话说，这存在严重的供应商风险，而我们很多人都对这类来源形成了依赖。

Local models are the solution to "What if the frontier labs do X?" 本地模型是解决“前沿实验室做X怎么办”这一问题的方案。

## Tempering the blade 淬炼锋芒

I said that local models are not the same tool as SOTA. What did I mean by that?我说本地模型和最先进技术并非同一类工具。我这么说是什么意思呢？

I build furniture using hand tools, and occasionally just like I'll release an open source project to scratch an itch, I'll make an edge tool like a chisel, a grooving plane blade, a scratch awl, a Sloyd knife for carving.我用手工工具制作家具，偶尔也会像为了解决某个小需求而发布开源项目那样，打造一些边缘工具，比如凿子、开槽刨刀片、锥子以及用于雕刻的斯洛伊德刀。

![Tempering a marking knife](https://blog.alexellis.io/content/images/2026/06/17/temper.jpg)

> Tempering a Japanese style marking knife on the back of a heated file, until it hits straw colour.在加热的锉刀背面对日式划线刀进行回火，直至其呈现稻草色。

There are two ways to work with steel depending on how much you can invest. Forging is taking a raw piece of steel, heating it up and smashing it with a hammer into the form you need. It's seen as the most pure and honourable way to work - the "real way". Then for smaller items, "stock removal" is much more approachable. It involves taking sheet steel, cutting out a shape and grinding in a bevel or a point.根据投资金额的多少，加工钢材有两种方式。锻造是取一块原材料钢材，加热后用锤子锻打成所需形状。这种方式被视为最纯粹、最正统的加工方法——即“真正的加工方式”。而对于小型工件，“材料去除法”则更容易操作。该方法需取用钢板，裁剪出所需形状，再打磨出斜角或尖端。

But that's just the shaping. You then have to heat the steel up, and quench it in oil or water. This makes the steel become extremely hard, so hard that if you dropped it - it would shatter into pieces. So we have to scrub off the black scum, and heat it up again, watching for a rainbow of colours. If we go one shade past where we need, we have to start the heat treating all over again.但这只是塑形工序。接下来你需要将钢材加热，然后放入油或水中淬火。这会让钢材变得极硬，硬到如果掉在地上，就会碎成碎片。所以我们得刷掉黑色的浮渣，再次加热，同时留意它呈现出的彩虹色。如果颜色过了我们需要的那一个色调，就必须从头开始整个热处理流程。

Our team's experience of local models is exactly like missing the temper colours. The model is running so hot, that it shoots past the goal and starts looping. Nothing can fix it, other than closing down the harness and hoping the cleared context will give a different result.我们团队使用本地模型的体验就像失去了情绪色彩。模型运行得异常火热，直接越过目标开始循环往复。除了关闭上下文窗口并寄希望于清空后的上下文能给出不同结果外，没有任何办法能修复这个问题。

I'd never leave a blade tempering unattended, just like I'd never leave Qwen 3.6 27B working on a long horizon task. For steel the workaround is using a kiln, or temperature controlled oven to remove variability.我绝不会让刀刃的回火过程无人看管，就像我绝不会让通义千问3.6 27B模型去处理长周期任务一样。对于钢材，解决办法是使用窑炉或控温烤箱来消除变量波动。

That Sloyd knife we forged could be used to knock in nails, but you're likely to cut your hands and ruin the edge at the same time. Let's go back to the start, if it's a different tool, what is it good for?我们锻造的那把手工刀可以用来敲钉子，但这样做很可能会划伤手，同时还会弄坏刀刃。咱们从头说起，如果换一种工具，它适合做什么呢？

**What I was looking for 我所寻找的东西**

I was looking for all of the things we covered in the previous section: privacy, fixed costs and protection against vendor risk. Where I got and continue to get let down is where I treat a local model inside opencode in the same way I treat Claude or Codex. It's almost creepy how long they can work fully unattended whilst making real progress towards a goal.我一直在找我们上一节讨论过的所有内容：隐私、固定成本以及针对供应商风险的防护措施。但让我感到失望的是，我把 opencode 中的本地模型当作和 Claude 或 Codex 一样的工具来对待。它们能在无人值守的情况下持续工作，同时朝着目标稳步取得实质性进展，这一点简直令人惊叹。

I can paste in something like: "Eoin told me he has been running Slicer VMs in a loop and ran out of FDs. He suspects VSock" and then after a couple of minutes Claude replies "Now I see the full picture: You're doing X, you need to do Y". I say "do it and test it end to end on my mini PC" and after any period of time - 5 or 15 minutes, I can raise a PR, have it code reviewed automatically, and then tell Claude to read it and iterate again.我可以输入这样的内容：“埃oin告诉我，他一直在循环运行Slicer虚拟机，结果文件描述符耗尽了。他怀疑是VSock的问题”，然后几分钟后，Claude会回复“现在我了解全貌了：你应该做X，而你需要做Y”。我会说“在我的迷你电脑上完整实现并测试一下”，之后无论过5分钟还是15分钟，我都可以提交拉取请求，让系统自动进行代码审查，然后让Claude阅读并再次迭代优化。

It's a wonderfully efficient loop for a small team like us that manages multiple products and works very closely with enterprise and community users.对于我们这样管理着多款产品、且与企业用户和社区用户紧密协作的小型团队来说，这是一个效率极高的循环。

**Sharp lessons from a 3090 3090带来的深刻教训**

I started off with a single 3090 card in 2023, and quickly realised I needed another to be able to load models and have sufficient context. Nothing about local models from 2023 is worth covering here, other than they were so hard to use that I gave up on them. Qwen 3.5 was the first time I saw real work being done by agents.2023年我一开始只有一张3090显卡，很快就意识到我需要再添一张，才能加载模型并保证足够的上下文。2023年的本地模型没什么值得在这里赘述的，只除了它们实在太难用，我最终放弃了它们。通义千问3.5是我第一次看到智能体真正发挥作用。

I could load a model into either card in Q4 quantization with 200k context (also quantized) and get it to do small tasks, when guided. I still remember how quickly that went south. I told the model "Explore this machine from every angle, complete a forensic report on the machine and how it's used" - Claude would have shrugged that off. Qwen started reading every single file on my machine one by one, filled its context, then hallucinated the filenames and even tool calls `~/faas-netes` became `~/faaned`. Stepping back, I was able to get a really lucid report by scoping the task "Take a quick look around this machine, tell me who uses it and what for" and that ran at roughly 40-50 tokens per second (generation).我可以将一个模型以4位量化（上下文也为200k且同样经过量化）加载到任意一张卡片中，在给出引导指令的情况下让它完成一些小型任务。但我至今仍记得情况很快就变得糟糕。我对模型说：“从各个角度探查这台机器，完成一份关于该机器及其使用方式的法医报告”——Claude 对此只会不屑一顾。而通义千问则开始逐个读取我机器上的所有文件，耗尽上下文后，还凭空捏造了文件名，甚至连工具调用都出现了错误， `~/faas-netes` 变成了 `~/faaned` 。后来我调整了任务范围，对它说：“快速查看一下这台机器，告诉我谁在使用它、用途是什么”，最终得到了一份非常清晰的报告，生成速度约为每秒40-50个标记。

A 27B model simply doesn't fit at full fidelity into 1x 3090 card, so the knobs and dials are: compression level of the model's weights (quantization), length of the context, and compression level of the keys and values of the context.一个270亿参数的模型根本无法以全精度塞进一张3090显卡中，因此可调节的参数包括：模型权重的压缩程度（量化）、上下文长度，以及上下文键值对的压缩程度。

There's a well known rule of thumb that bad things start happening at Q4\_0 on the keys part of the KV cache. The most aggressive I've ever been is Q8\_0 for keys and Q4\_0 for values.有一个广为人知的经验法则：在 KV 缓存的键（keys）部分，从 Q4\_0 开始就会出现问题。我做过的最激进的尝试是键（keys）用 Q8\_0、值（values）用 Q4\_0。

The 3090s were a constant source of headaches - I had to quantize well below where I was comfortable. One of the cards would only show up if I crossed my fingers when turning it on. Even reboots wouldn't cure it - I had to A/C power off and remove the power cable each time for 30 seconds.3090显卡系列一直让我头疼不已——我不得不把量化参数调到远低于自己能接受的水平。其中一张显卡每次开机时，我都得双手合十祈祷它才能被识别出来。就算重启也解决不了这个问题，每次我都得切断交流电电源，拔掉电源线静置30秒才行。

My latest experiment was setting up vLLM (the gold standard for production and concurrent serving) and even with an NVLink (175GBP) and tensor parallelism turned on, it was 3 tokens/second slower than llama.cpp during generation for an equivalent setup.我最近的一次实验是搭建 vLLM（生产环境和并发服务的黄金标准），即便开启了 NVLink（175 英镑）和张量并行，在相同配置下，其生成速度也比 llama.cpp 慢 3 个令牌/秒。

I was spending more time on making them work than the results.我花在让它们正常运转上的时间，远多于关注结果的时间。

**Big spender 大手大脚的人**

We offer support contracts to enterprise companies using our products, and when a ticket comes in we are incentivised to resolve it as soon as reasonably possible. I thought that getting a card that would make all the niggles go away would fix local models, and customer support was worth the risk.我们为使用我们产品的企业客户提供支持合同，每当收到客户工单时，我们都会受到激励，尽合理可能快地解决问题。我原以为拿到一张能解决所有小麻烦的卡就能搞定本地模型的问题，而且客户支持服务也值得冒这个险。

We dropped around 12000 USD on an RTX 6000 Pro Blackwell edition with 96GB of VRAM. Even a couple of months on, the price has increased to around 15400 USD so adding a second becomes much harder to justify. You can't just "slot another card in" to a consumer machine. There are many concerns from PCI lanes, to bandwidth, to card spacing, and the draw on the PSU.我们花了约12000美元购入一张配备96GB显存的RTX 6000 Pro Blackwell版显卡。即便过了几个月，其价格已涨至约15400美元，因此再添置第二张显卡的理由变得愈发不充分。普通消费级电脑可没法简单地“再插一张卡”。从PCIe通道、带宽、显卡间距到电源供应单元的功耗，都存在诸多顾虑。

It was a calculated bet, and it has paid off, but not because it replaces our Claude subscriptions - it can't do that.这是一次经过深思的赌注，而且已经获得了回报，但这并不是因为它取代了我们的 Claude 订阅服务——它做不到这一点。

**Painless customer support, without leaking customer data 贴心的客户支持，且不会泄露客户数据**

Many operators at enterprise companies are highly capable and skilled, but they're held back by manual procedures and practices. Sometimes you're lucky and someone will work through every point in a troubleshooting guide and tell you what they got wrong. Other times, you're 150 replies deep into an email chain and they've still not run that one command that would answer it all.许多企业公司的运维人员能力出众、技术娴熟，却被繁琐的手动流程和操作方式所束缚。有时还算幸运，有人会按故障排除指南逐一排查，并告诉你问题出在哪里。但更多时候，你已经在邮件往来中来回沟通了150次，他们却仍未执行那个能彻底解决问题的指令。

So we wrote "diag" a CLI tool that is easy for operators to run and that captures a complete snapshot of an OpenFaaS installation on Kubernetes. They can then email this dump to us and we can run it through an airgapped local model, in an ephemeral VM created by Slicer. You can read more about the issues we found in [Introducing: Painless support and hands-off architecture reviews](https://www.openfaas.com/blog/painless-support-with-diag/) over on the OpenFaaS blog.于是我们编写了“diag”这一命令行工具，运维人员可以轻松运行它，它会捕获 Kubernetes 上 OpenFaaS 安装的完整快照。随后他们可以将这份转储文件通过邮件发送给我们，我们会在 Slicer 创建的临时虚拟机中，通过离线本地模型对其进行分析。你可以在 OpenFaaS 博客的 [推出：无缝支持与免干预架构评审](https://www.openfaas.com/blog/painless-support-with-diag/) 一文中，详细了解我们发现的问题。

**Revenue recovery 收入追回**

A renewal came up recently, and only because I fed the telemetry database into a local model, did we find out they'd been under-reporting licenses and under-paying by about 4-5x for over 12 months. That revenue recovery alone paid for the card.最近一次续费的时候，我把遥测数据库输入到本地模型中，才发现他们在过去12个多月里一直少报许可证数量，少付的费用达到了正常金额的4到5倍。光是这笔追回的收入，就足以支付这张卡片的成本。

There's no way I would have in good conscience ran the telemetry dump or a customer's diag output through any cloud plan, regardless of their stance on data retention. This is a good time for me to cover near- and far-east coding plans - caveat emptor - I'm yet to find one that doesn't take a privileged position on your IP - training and ownership rights for inputs and outputs. ChatGPT Pro and Claude Max can be configured for a 30 day retention period, but even that level likely invalidates your contracts with customers.我绝不可能凭良心将遥测数据转储或客户的诊断输出内容通过任何云平台处理，无论对方在数据留存方面持何种立场。现在正好是我说明近东和远东编码方案的时候——注意，买家自负其责——我还没发现有哪一种方案不会对你的知识产权占据特权地位，包括对输入和输出内容的训练权与所有权。ChatGPT Pro 和 Claude Max 可配置为30天的留存期，但即便这个留存时长，也很可能使你与客户签订的合同失效。

Sometimes I've given GPT or Opus the schema for the telemetry table and had it write an AGENTS.md that the local model is most likely to follow. Our data is reported several times per day, from multiple high-availability replicas, so it can't just be summed up across a 24 hour period. With earlier iterations of the model, I saw it fail at arithmetic - 27.3K counted as 273,000. It was only because I was thoroughly checking its work that I caught it out.有时我会给 GPT 或 Opus 遥测表的架构，让它编写一份 AGENTS.md，本地模型大概率会遵循这份文档。我们的数据每天会从多个高可用性副本中报告数次，因此无法在24小时内对其进行汇总。在使用该模型的早期版本时，我发现它在算术运算上会出错——比如把27.3K算作273,000。也是因为我仔细核对了它的输出，才发现了这个错误。

Another time, the model inferred a customer was likely to churn because they had a small number of functions. It completely ignored that the customer ran that smaller number of functions many times per day. So often it's better to have them focus on analysis, not interpretation.还有一次，模型推断一位客户很可能会流失，原因是该客户使用的功能数量较少。但它完全忽略了这位客户每天会多次使用这些为数不多的功能。因此，很多时候模型更应专注于分析，而非解读。

**Our current setup 我们当前的设置**

I'm a big supporter of folks like Jack Rong and [Kyle Hessling](https://x.com/KyleHessling1?lang=en) who have worked on fine-tunes of open weight models like Qwen. [Qwopus](https://huggingface.co/Jackrong/Qwopus3.6-27B-v2-MTP-GGUF) attempts to layer Chain of Thought traces on top of Qwen to make it better at reasoning and coding. They do this to help the community and because of a deep belief in local AI.我非常支持像荣杰（Jack Rong）和 [凯尔·赫斯林（Kyle Hessling）](https://x.com/KyleHessling1?lang=en) 这样的人，他们参与了通义千问（Qwen）等开源权重模型的微调工作。 [Qwopus](https://huggingface.co/Jackrong/Qwopus3.6-27B-v2-MTP-GGUF) 试图在通义千问的基础上叠加思维链追踪，以提升其推理和编码能力。他们这么做是为了帮助社区，同时也源于对本地人工智能的坚定信念。

In our team we run both the latest generation of Qwopus, and the base 27B Qwen 3.6 model on the RTX 6000 rig. Over time this changes - as new finetunes come out, as new point releases of Qwen drop and as we land upon new edge-cases and limitations. Up until very recently, we ran with thinking turned off completely, and have only recently added it back in which coincided with seeing more looping.在我们的团队中，RTX 6000 工作站上同时部署了最新一代的 Qwopus 模型以及基础版 27B 通义千问 3.6 模型。随着时间推移，配置会不断调整——新的微调模型推出、通义千问发布新的点版本，同时我们也会遇到新的边缘场景和模型局限性。直到最近之前，我们一直完全关闭了推理功能，直到近期才重新开启，而这恰好与我们观察到更多循环问题的时间点相吻合。

The models are served by two independent llama.cpp instances, which means they retain full context length. The default answer to "concurrency" is to run `--parallel 2` but this halves the available context.这些模型由两个独立的 llama.cpp 实例提供服务，这意味着它们保留完整的上下文长度。关于“并发”的默认设置是运行 `--parallel 2` ，但这会将可用上下文减半。

```bash
$ nvidia-smi
Wed Jun 17 11:56:03 2026       
+-----------------------------------------------------------------------------------------+
| NVIDIA-SMI 590.48.01              Driver Version: 590.48.01      CUDA Version: 13.1     |
+-----------------------------------------+------------------------+----------------------+
| GPU  Name                 Persistence-M | Bus-Id          Disp.A | Volatile Uncorr. ECC |
| Fan  Temp   Perf          Pwr:Usage/Cap |           Memory-Usage | GPU-Util  Compute M. |
|                                         |                        |               MIG M. |
|=========================================+========================+======================|
|   0  NVIDIA RTX PRO 6000 Blac...    Off |   00000000:01:00.0 Off |                  Off |
| 30%   32C    P8             15W /  600W |   85937MiB /  97887MiB |      0%      Default |
|                                         |                        |                  N/A |
+-----------------------------------------+------------------------+----------------------+

+-----------------------------------------------------------------------------------------+
| Processes:                                                                              |
|  GPU   GI   CI              PID   Type   Process name                        GPU Memory |
|        ID   ID                                                               Usage      |
|=========================================================================================|
|    0   N/A  N/A            2265      C   ...ma.cpp/build/bin/llama-server      31198MiB |
|    0   N/A  N/A            2544      C   ...ma.cpp/build/bin/llama-server      54718MiB |
+-----------------------------------------------------------------------------------------+
```

llama.cpp is built from source and kept up to date weekly, or as required. The build from source is required in order to add support for Nvidia GPUs.llama.cpp 从源码编译构建，每周或根据需要进行更新。为了添加对英伟达（Nvidia）显卡的支持，必须进行源码编译构建。

Here's our command for a single instance of Qwen with full context length and full quality context.这是我们针对单实例 Qwen 的命令，支持完整上下文长度和全质量上下文。

```bash
#!/bin/bash
~/llama.cpp/build/bin/llama-server \
 -hf unsloth/Qwen3.6-27B-MTP-GGUF:UD-Q8_K_XL \
 --alias Qwen3.6-27B-Base \
 --host 0.0.0.0 \
 --port 8085 \
 -ngl 99 \
 -c 262144 \
 --cache-type-k f16 \
 --cache-type-v f16 \
 --flash-attn on \
 --parallel 1 \
 --threads 16 \
 -b 4096 \
 -ub 2048 \
 --jinja \
 --reasoning-budget 2048 \
 --temperature 0.6 \
 --top-p 0.95 \
 --top-k 20 \
 --min-p 0.0 \
 --presence-penalty 1.1 \
 --reasoning on \
 --spec-type draft-mtp \
 --spec-draft-n-max 6 \
 --chat-template-kwargs '{"preserve_thinking": true}' \
 --chat-template-file chat_template.jinja \
 --reasoning-budget-message "reasoning budget consumed, time to answer now"
```

We get about a 93% acceptance rate on our speculative decoding from MTP, and the speed increases from a stable 67 tok/s to 130-200 tok/s sustained over long periods. It feels faster than using a cloud model.我们基于 MTP 的推测式解码接受率约为 93%，速度从稳定的 67 个令牌/秒提升至长期可持续的 130-200 个令牌/秒。使用起来比云模型更快。

It's important to follow the instructions from the model card when tuning llama.cpp. There are often reasons why a certain temperature has been selected by the lab. For instance, with the Qwopus fine-tune, it works best with thinking turned off and the temperature really hot at 0.85-1.0.在微调 llama.cpp 时，遵循模型卡片上的说明至关重要。实验室选择特定温度往往有其原因。例如，就 Qwopus 微调而言，在关闭思考功能且温度调至 0.85-1.0 这一较高值时，效果最佳。

**About that looping 关于循环问题**

Recently I've been tuning it to try to avoid looping, goes back to that tempering analogy. You can't just leave this model to work on long horizon tasks.最近我一直在调整它，试图避免出现循环，这又回到了那个回火的比喻。你不能只让这个模型去处理长期任务。

I asked Qwen what commands we should add to `faas-cli`, and it came back with some reasonable suggestions, but got stuck and kept repeating them over and over, burning 600W of my electricity for a good half an hour.我问通义千问应该给 `faas-cli` 添加哪些命令，它给出了一些合理的建议，但之后就卡住了，一直重复这些建议，整整半小时耗了我600瓦的电量。

```
58. faas-cli function import - Import functions from a YAML file or URL.
59. faas-cli function export - Export deployed functions back to a stack.yaml file.
60. faas-cli function scale - Manually scale function replicas without redeploying.
61. faas-cli function rename - Rename a function in-place.
62. faas-cli function diff - Compare local stack.yaml with what's deployed - show differences.

63. faas-cli function import - Import functions from a YAML file or URL.
64. faas-cli function export - Export deployed functions back to a stack.yaml file.
65. faas-cli function scale - Manually scale function replicas without redeploying.
66. faas-cli function rename - Rename a function in-place.
67. faas-cli function diff - Compare local stack.yaml with what's deployed - show differences.

68. faas-cli function import - Import functions from a YAML file or URL.
69. faas-cli function export - Export deployed functions back to a stack.yaml file.
70. faas-cli function scale - Manually scale function replicas without redeploying.
71. faas-cli function rename - Rename a function in-place.
72. faas-cli function diff - Compare local stack.yaml with what's deployed - show differences.

Build · Qwen3.6-27B-Base toilgate
```

The same thing happened when I asked it to "add --json to all get and list commands" - it was convincing for the first one or two and even wrote tests.当我让它“给所有的 get 和 list 命令添加 --json 参数”时，也发生了同样的事——它在前一两个命令上表现得很靠谱，甚至还写了测试用例。

Then because `--json` is machine readable, `faas-cli` needed to stop printing warnings about insecure TLS when using a `http://` remote endpoint. Qwen couldn't work out how to do this so I told it to write a reverse proxy in Python and call that instead. The first version looked plausible but had bad indenting. When it realised the issue, it corrupted the file, and kept complaining that it didn't know how to fix it and was stuck in a different kind of loop. It just wouldn't give up, but went progressively off the rails.然后，由于 `--json` 是机器可读的， `faas-cli` 需要停止在使用 `http://` 远程端点时打印关于不安全TLS的警告。通义千问不知道该怎么做，所以我让它用Python写一个反向代理，然后调用这个代理来替代。第一个版本看起来还不错，但缩进有问题。当它意识到这个问题时，却把文件弄乱了，还一直抱怨不知道该如何修复，陷入了另一种循环中无法自拔。它就是不肯放弃，反而一步步偏离了正轨。

Han from my team has reported very similar looping - mostly the second kind. The model or agent is stuck, at the edge of its ability and won't ask for help. For me, I've mainly hit the former, which is arguably worse and means I rarely trust it beyond the telemetry and diag work for customer support/renewals.我团队的韩同事反馈了非常类似的循环问题——大多是第二种情况。模型或智能体陷入停滞，处于能力边界却不主动求助。而我主要遇到的是前者，这种情况可能更糟，这意味着除了用于客户支持/续费率的遥测和诊断工作外，我几乎不会信任它。

**Measuring and distributing access 衡量与分配访问权限**

To begin with, I set up a single inlets tunnel and hoped the agents wouldn't clash. Two agents hitting the same llama.cpp instance with unrelated contexts means each request invalidates the other's cached prefix — so the full prompt gets re-processed from scratch every time, a thrashing latency you don't want to feel often. We were still doing most work on coding plans then, so it wasn't yet a real problem.首先，我搭建了一个入口隧道，希望智能体之间不会发生冲突。两个智能体向同一个 llama.cpp 实例发送无关上下文的请求，意味着每个请求都会使另一个请求的缓存前缀失效——因此每次完整的提示词都要从头重新处理，这种严重的延迟问题是我们不希望频繁遇到的。当时我们的大部分工作仍在制定编码方案，所以这还不是一个真正的问题。

Distributing that setup was simple: edit `opencode.json` and add the URL and token, then copy that file onto your various machines or Slicer VMs.部署该设置的过程很简单：编辑 `opencode.json` 文件并添加URL和令牌，然后将该文件复制到你的各类机器或Slicer虚拟机上。

But as soon as another person uses the model, it stops being a prototype. Who's on which llama.cpp instance? How much are they using? Which model? What has that cost us in electricity? What happens if that person leaves the team? How do we add in another model for the team?但一旦有另一个人使用这个模型，它就不再是原型了。谁在使用哪个 llama.cpp 实例？他们的使用量有多少？用的是哪个模型？这让我们在电费上花了多少钱？如果那个人离开团队会怎样？我们该如何为团队接入另一个模型？

![Toilgate overview](https://blog.alexellis.io/content/images/2026/06/17/toilgate.png)

> Toilgate is 100% vibe-coded and too much work to open source. If you like the idea, feel free to make your own.Toilgate 完全是凭感觉写的代码，开源的工作量太大了。如果你喜欢这个创意，不妨自己做一个。

Rather than manually editing my opencode.json file, and sending that to various team mates, I decided to write a provider for opencode. It would manage the available models from the stable base through to more experimental Qwopus variants that were quantized. Just run `opencode` - go to the model picker and select `toilgate` then whatever you want to use.我没有手动编辑我的 opencode.json 文件并将其发送给各个团队成员，而是决定为 opencode 编写一个提供程序。它会管理从稳定基础版本到经过量化的实验性 Qwopus 变体的所有可用模型。只需运行 `opencode` ——进入模型选择器，选中 `toilgate` ，然后选择你想使用的任意模型即可。

Two Shelly Plus Plugs are monitoring the power consumption at the wall to give me a better idea of actual costs. The RTX 6000 Pro will pull 600W during inference and is relatively quiet, the two 3090s are closer to 750W combined and extremely noisy.我用两个 Shelly Plus 智能插头监测墙上的耗电量，以便更清楚地了解实际成本。RTX 6000 Pro 显卡在推理时功耗为 600 瓦，噪音相对较小；而两张 3090 显卡的总功耗接近 750 瓦，噪音非常大。

**The wrong comparison 错误的对比**

The trap once you can measure is comparing the input/output costs per million tokens to OpenAI's API pricing for GPT-5.5. That's the wrong comparison for the current capability. It's more about understanding the ongoing costs, which I'm bearing personally since the machine is in my house, for work that's not suitable for a cloud model.一旦你能衡量这个陷阱，就是将每百万令牌的输入/输出成本与 OpenAI 的 GPT-5.5 接口定价进行对比。对于当前的功能来说，这是错误的比较方式。更重要的是要了解持续的成本——由于服务器就在我家，这些成本由我个人承担，而这些工作并不适合云模型。

This is where "local AI" turns into an operations problem. You need identity, access control, metering, quotas, model routing and power monitoring. The harder part we keep coming back to is the reliability of the agent/model combination, keeping up with innovations like MTP, and ensuring enough uptime for people who have started to depend on the model being available.这就是“本地人工智能”演变成运营问题的地方。你需要身份验证、访问控制、计量、配额、模型路由和电源监控。我们一直面临的更棘手的问题是智能体/模型组合的可靠性、跟上MTP等创新的步伐，以及确保那些开始依赖该模型正常运行的用户拥有足够的正常运行时间。

## Wrapping up 总结

Whilst local Qwen is not "near Opus levels", and I hope I've demonstrated that enough in the post, it is of value for certain tasks and workflows. It's also incredibly early, and it can only get better from here. Qwen 3.5 was probably the first model that gave us results we could use. There are rumours of 3.7 coming out soon, which I'd expect to be an iterative improvement - not a revolutionary one.虽然本地通义千问还没达到“ opus 级别”，我也希望我在这篇帖子里已经充分证明了这一点，但它在某些特定任务和工作流中仍有价值。目前这项技术还处于非常早期的阶段，未来只会越来越好。通义千问 3.5 或许是第一款能为我们提供可用结果的模型。有传闻称 3.7 版本即将推出，我预计它会是一次迭代式的优化，而非颠覆性的革新。

Concrete things that help: 实用建议如下：

- Match the local model and harness to specialised tasks - customer support, well bounded maintenance, and end-to-end testing 将本地模型和工具适配到特定任务——客户支持、边界明确的维护以及端到端测试
- AGENTS.md - when I added detailed instructions to [alexellis/arkade](https://github.com/alexellis/arkade), I found that the local model could add new CLIs more quickly and efficiently than human contributors, and would test its work AGENTS.md——当我向 [alexellis/arkade](https://github.com/alexellis/arkade) 添加详细说明时，我发现本地模型能比人类贡献者更快、更高效地添加新的命令行界面（CLI），并且会对其工作进行测试
- Pay attention to the tuning notes on the model card - temperature, context settings, and quantization all matter. Beware of very low quantizations.请注意模型卡片上的调优说明——温度、上下文设置和量化都很重要。要警惕极低的量化值。
- Local models can quickly read and explain codebases, even if they can't write them - this is a superpower 本地模型可以快速阅读并解释代码库，即便它们无法编写代码——这是一项超能力
- Fine-tunes like Qwopus exist - be willing to experiment to find the right model 像 Qwopus 这样的微调模型是存在的——你需要愿意尝试，找到适合的模型
- Agent Skills can help immensely - we had a local agent [set up Slicer](https://x.com/alexellisuk/status/2062141036093165929?s=20) completely from scratch on a new mini PC. It even gave feedback on the usability of `slicer` CLI which we integrated 智能体技能能提供极大帮助——我们有一位本地智能体 [从零开始在一台新迷你电脑上搭建了 Slicer](https://x.com/alexellisuk/status/2062141036093165929?s=20) 。它还就 `slicer` 命令行界面的可用性给出了反馈，我们已将该反馈整合进去
- Normalise [running the same task with a local and cloud model](https://x.com/alexellisuk/status/2062485340812673513/photo/1) - sometimes you'll be disappointed, other times you won't believe your luck 统一 [在本地模型和云模型上运行同一任务](https://x.com/alexellisuk/status/2062485340812673513/photo/1) ——有时你会大失所望，有时又会喜出望外
- Don't hand it long-horizon, unsupervised agentic work - that's where it loops, and even our almost 15k USD card couldn't fix that 别给它安排长期、无监督的智能体任务——这正是它会陷入循环的地方，即便我们那张价值近1.5万美元的卡也解决不了这个问题

You'll notice I've not mentioned 70B models - most are genuinely old at this point, generations behind. The 35-A3B variant of Qwen tends to be popular because it looks faster on MacBooks - the reason is because there are only 3B active parameters at generation time, I'd much rather trade speed for the best quality I can get. There are much bigger models like GLM 5.2, Kimi 2.7, Minimax M3 and Deepseek V4 Flash. They can run on some local rigs, but you're often talking about 4-6 RTX 6000 Pro cards to even load a quantized version of the model, which puts them out of scope for us.你会注意到我还没提到 70B 模型——目前大多数这类模型都已经相当老旧，落后了好几代。通义千问的 35-A3B 变体往往更受欢迎，因为在 MacBook 上运行时速度看起来更快——原因是生成时只有 30 亿活跃参数，但我更愿意用速度换取我能得到的最佳质量。还有更大的模型，比如 GLM 5.2、Kimi 2.7、Minimax M3 以及 Deepseek V4 Flash。它们可以在部分本地设备上运行，但通常需要 4 到 6 张 RTX 6000 Pro 显卡才能加载模型的量化版本，这就超出了我们的使用范围。

As a consumer, I don't know what the next step up would take - whether it shifts into enterprise hardware, or whether there's a place for 27B dense models, but today they are not cut out to write Go all day long. Their limited knowledge and attention shows up immediately in code review. Whilst Go code can be written, and may even have working concurrency, [our experiments got shut down very quickly](https://x.com/alexellisuk/status/2038629892380651691?s=20) when we found Qwen would not follow instructions to be brief, and went into spurious detail on automated code reviews, and hallucinated concurrency issues and race conditions. The relatively unsexy Grok Coder Fast 1 was cheaper, and faster and served us well for months before being deprecated.作为一名消费者，我不知道下一步会走向何方——是转向企业级硬件，还是270亿参数的密集型模型有其用武之地，但如今它们并不适合整天编写Go代码。它们有限的知识储备和注意力会在代码审查中立刻暴露无遗。虽然Go代码是可以写出来的，甚至可能具备可用的并发功能，但 [我们的实验很快就被叫停了](https://x.com/alexellisuk/status/2038629892380651691?s=20) ，因为我们发现通义千问不会遵循简洁的指令，反而在自动化代码审查方面堆砌无关细节，还凭空捏造了并发问题和竞争条件。相对不那么亮眼的Grok Coder Fast 1不仅价格更低、速度更快，还为我们服务了好几个月才被淘汰。

You can read about our [code review bot here](https://slicervm.com/blog/evolving-our-code-review-bot-with-slicer-sandboxes/) and about [painless customer support and architecture review for OpenFaaS here](https://www.openfaas.com/blog/painless-support-with-diag/).你可以在此处阅读我们的 [代码审查机器人](https://slicervm.com/blog/evolving-our-code-review-bot-with-slicer-sandboxes/) ，并在此处了解 [OpenFaaS 的便捷客户支持与架构审查](https://www.openfaas.com/blog/painless-support-with-diag/) 。