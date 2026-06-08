---
title: "LLMs are eroding my software engineering career and I don't know what to do"
source: "https://human-in-the-loop.bearblog.dev/llms-are-eroding-my-software-engineering-career-and-i-dont-know-what-to-do/"
author:
published: 2026-06-07
created: 2026-06-08
description: "I'm a software engineer, completing 10 years of professional experience this year. I started my career as a web frontend engineer (it was easier for me to de..."
tags:
---
## LLMs are eroding my software engineering career and I don't know what to do大语言模型正在蚕食我的软件工程职业生涯，我却不知该何去何从

I'm a software engineer, completing 10 years of professional experience this year. I started my career as a web frontend engineer (it was easier for me to debug frontend code back then, so I chose that path), but shortly transitioned to (web) backend and never looked back.我是一名软件工程师，今年将迎来10年职业经验的里程碑。我最初是一名Web前端工程师（当时调试前端代码对我来说更轻松，所以我选择了这个方向），但很快就转向了（Web）后端领域，并且从此深耕于此。

Through a series of coincidences, once I stepped into backend development, I ended up working in software development roles in the domains of finance, bookkeeping and payment processing, where I had great autonomy and a close and candid relationship with Product Managers and stakeholders.通过一系列巧合，我一踏入后端开发领域，最终在金融、记账和支付处理领域担任软件开发相关岗位。在这些岗位上，我拥有很大的自主权，并且与产品经理及相关方保持着密切且坦诚的合作关系。

I learnt **a lot** about the domain and how to effectively write programs for it: PCI compliance, double-entry ledgers, escrows, reconciliation, payment lifecycles, bank transfer idempotency, etc.我学到了很多</b>关于这个领域的知识，也掌握了如何为其高效编写程序的方法：支付卡行业数据安全标准合规、复式记账、托管账户、对账、支付生命周期、银行转账幂等性等等。

It was, then, obvious that I should focus my career on becoming an expert on that domain to stand out as a professional and differentiate myself in a field that showed signs of an increasing need for domain specialists.那么，很明显我应该将职业生涯聚焦于成为该领域的专家，这样才能在一个对领域专业人才需求日益增长的领域中脱颖而出，成为专业人士并彰显自身独特性。

## The first pillar to erode: domain-specific knowledge第一个正在被侵蚀的支柱：领域专业知识

Last year, I got hired by a company in the finance workspace. So far, I had worked on companies that do have a strong payment and finance component to their operations/offerings, but that were not solely finance-focused companies.去年，我受雇于一家金融领域的公司。到目前为止，我服务过的企业在业务/产品中都包含强大的支付和金融板块，但它们并非纯粹的金融类公司。

That company also embraced AI wholeheartedly, so I got ChatGPT and Claude Enterprise accounts from day one and was encouraged to use them for my research, exploration, and even coding, albeit with a warning that I should still review and own every single line that made it into production.那家公司也全身心拥抱人工智能，所以我从一开始就拥有了ChatGPT和Claude Enterprise的账号，公司还鼓励我将它们用于研究、探索甚至编程工作，不过也提醒我，最终上线的每一行代码都仍需由我本人审核并承担责任。

One of my first projects involved reworking the legacy online payment system, which was a mess. They hired me for (among other things) my previous experience in building that and trusted me with the task.我早期参与的项目之一是改造老旧的在线支付系统，那系统简直一团糟。他们雇我来（除了其他原因外）是因为我之前有搭建这类系统的经验，并且把这项任务全权交给了我。

Different from the other companies I had worked for so far, they wanted the "Design Docs" I write before coding to be readable by both engineers and product managers - so they shouldn't be a technical deep dive and more of an architectural view. I wrote my first one with minimal AI assistance - I even called LLMs "stochastic parrots" at the time, a view I no longer hold - and delivered it.和我到目前为止共事过的其他公司不同，他们希望我在编写代码前撰写的“设计文档”能同时被工程师和产品经理读懂——因此这些文档不应是技术深度解析，而应更偏向架构层面的视角。我最初撰写第一份文档时几乎没有借助人工智能的帮助——当时我甚至将大语言模型称作“随机鹦鹉”，但如今我已不再持这种观点——并按时交付了文档。

I valued my knowledge and thought no LLMs could replace it.我珍视自己的知识，认为没有任何大语言模型能取代它。

Then my manager reached out to me: even though you're delivering code at a good pace, you're taking too long to deliver those Design Docs. Are you using AI? You should use more AI.后来我的经理找到我：虽然你写代码的进度不错，但交付那些设计文档的时间却拖得太久。你在用AI吗？你应该多用些AI。

"No way this will work", I thought in my head, but agreed. The models at that time were not as good as the ones we have now, but they did provide a good speed-up on my writing and even the decision-making.“这肯定行不通”，我心里这么想，但还是答应了。那时候的模型远不如我们现在的，但它们确实让我的写作效率大幅提升，甚至在决策方面也帮了忙。

And then I started realizing: all the knowledge I have accumulated over the years: the trade-offs between implementations, how acquiring works, how to structure idempotency to prevent double-charges, everything, was becoming useless. Even though the models still needed some steering, they could connect the dots on how to structure such systems, which was the hardest part that only develops in your brain after years of hands-on experience. **That was my first shock**.然后我开始意识到：我多年积累的所有知识——不同实现方式之间的权衡、收购业务的运作逻辑、如何构建幂等性机制以避免重复扣费，所有这些——都变得没用了。尽管这些模型仍需要一定的引导，但它们能理清这类系统的构建思路，而这恰恰是只有经过多年实操经验才能在脑海中形成的最难的部分。 **这是我第一次受到冲击** 。

But sure, I thought, they can do that because there's plenty of articles on the web on how that shit works along with all the technical documentation, and we have blog posts explaining how to apply the technical tools to the domain. For humans, it may take a long time to learn all that, but that's training data so the models can pick it up.但我想，他们肯定能做到这一点，因为网上有大量文章介绍这玩意儿的原理，还有各类技术文档，我们也有博客文章讲解如何将这些技术工具应用到具体领域。对人类来说，要掌握所有这些知识可能要花很长时间，但这些都是训练数据，模型可以从中学习。

What the models will never be good at, and that's where humans will shine, is debugging! I had accumulated a good experience debugging race conditions and distributed systems in production. That was my ticket to long-term employability.模型永远不擅长的事情——也是人类大显身手的领域——就是调试！我在生产环境中积累了丰富的调试竞争条件和分布式系统的经验。这是我获得长期就业机会的资本。

## The second pillar to erode: debugging and distributed systems第二个正在被侵蚀的支柱：调试与分布式系统

![Abstract glitch art with pink and yellow patterns by Egor Komarov on Unsplash](https://i.ibb.co/qY17WByt/egor-komarov-6u-I9uw-M3-WJQ-unsplash-1-1.jpg "Abstract glitch art with pink and yellow patterns by Egor Komarov on Unsplash")

So, after LLMs started getting good at writing docs and helping plan the actual implementations, they became good at coding. It started in the second half of 2025 with the Claude Code hype, then Codex came and so on. Although I was using LLMs for writing unit tests every day before that, I wasn't trusting them to write the full implementation yet.所以，在大语言模型开始擅长撰写文档并协助规划实际的实现方案后，它们的编程能力也随之提升。这一趋势始于2025年下半年，当时Claude Code引发了热潮，随后Codex等工具也相继出现。尽管在此之前我每天都在使用大语言模型编写单元测试，但我还不敢让它们来完成完整的代码实现。

The natural next step was to introduce more AI into writing code. And honestly, I liked it. I like shipping things to production and seeing users happy as much as I like coding, so I was trading one thing that I like for another one that I also like, it was fair.自然而然的下一步是在代码编写中引入更多人工智能技术。说实话，我很喜欢这样做。我既喜欢将产品上线、看到用户满意的状态，也同样热爱编程，所以我是用自己喜欢的一件事去交换另一件同样喜欢的事，这很公平。

LLMs were becoming good at coding, but it still couldn't debug the mess left behind (by then or by the humans), so I still had a role that was bigger than steering the robot - a ticket to employability.大型语言模型在编程方面已经变得很出色，但它们仍然无法调试（当时或人类留下的）烂摊子，所以我仍有一个比操控机器人更重要的角色——一份赖以谋生的保障。

Everything seemed fine. 一切似乎都很顺利。

Then came the MCPs, the agentic workflows and Claude 4.5 and the sky started to fall.随后出现了 MCP、智能体工作流、Claude 4.5，一切开始急转直下。

Claude 4.5, to be honest, wasn't that good. It solved like 60% of the bugs given a stack trace and some context (a Sentry link with Sentry MCP enabled was all it took in most cases). Sometimes it gave a solution that sounded plausible but was totally wrong.说实话，Claude 4.5 并没有那么好用。给定堆栈跟踪和一些上下文信息（在大多数情况下，只需一个启用了 Sentry MCP 的 Sentry 链接），它只能解决大约 60% 的错误。有时它给出的解决方案听起来似乎合理，但实际上完全错误。

This time, however, I stopped doubting the machines. I saw bugs that in the past would easily take 1 day of full-time debugging being one-shotted by Claude Code. Of course, not all of them *yet*, but the pattern was clear.不过这一次，我不再怀疑这些工具了。我看到过去需要整整一天全职调试才能解决的漏洞，现在用 Claude Code 就能一次性搞定。当然，还不是所有漏洞都能这样，但趋势已经很明显了。

Then came 4.6, 4.7, GPT 5.5, Opus 4.8 and the DataDog MCP... Now I have CLIs that one-shots bugs across distributed systems for me. Bugs that I couldn't solve in the past. Bugs that would take 2 days of full-time debugging. Bugs across distributed systems that lack distributed observability. 90% of the bugs are one-shotted now, including bizarre race conditions, unexpected corner-cases, third-party integration issues, undocumented API edge cases, everything. I hardly have to intervene.随后出现了4.6、4.7、GPT 5.5、Opus 4.8以及DataDog MCP……如今我拥有了能一键解决分布式系统中各类问题的命令行界面。那些过去我无法解决的问题，那些需要花整整两天全力调试才能搞定的问题，那些分布式系统中缺乏分布式可观测性的问题，现在都迎刃而解了。如今90%的问题都能一键解决，包括怪异的竞争条件、意外的极端情况、第三方集成问题、未记录的API边缘情况，所有问题都不在话下。我几乎无需再介入处理。

Of course, I'm still employable because someone has to review the code and steer the robot. But I'm just another *off-the-shelf engineer* now. I have no domain expertise that another Sr. engineer steering an LLM cannot match. All my finance and payment domain expertise, all the debugging intuition and distributed system knowledge earned through hours of sweat and tears, is now *promptable*.当然，我依然有就业能力，因为总得有人来审查代码、操控机器人。但如今我只是另一个 *现成工程师* 。我没有任何其他操控大语言模型的高级工程师无法具备的领域专业知识。我所有的金融与支付领域专业知识，以及历经千辛万苦积累的调试直觉和分布式系统知识，如今都可以 *通过提示词实现* 。

We were taught that generalists and specialists will always have their roles. But now the market is shaping everyone into becoming a generalist. That's not a bad thing *per se*, until you look under the economics of supply and demand: if everyone is a generalist, the price of a generalist falls if there's no demand to match. And we all know the demand is drying up.我们曾被教导，通才和专才永远都会有各自的角色。但如今市场正将每个人都塑造成通才。这本身并非坏事，除非你深入审视供需经济学原理：如果人人都是通才，而没有相应的需求与之匹配，通才的价值就会下跌。而我们都清楚，需求正在不断枯竭。

## The third pillar, the one that hasn't eroded yet: code quality and architecture第三个支柱，也是目前尚未被侵蚀的那个：代码质量与架构

![A red cube with many squares by Steve A Johnson on Unsplash](https://i.ibb.co/dwpWtgrz/steve-a-johnson-Go-MXr-TCBj3c-unsplash-1.jpg "A red cube with many squares by Steve A Johnson on Unsplash")

I still have one pillar standing, though: code quality and software architecture - what's now being reduced to being called *"taste"* [^1].不过我还有一个核心优势屹立不倒：代码质量与软件架构——也就是如今被简化为所谓 *“品味”* 的东西 [1](#fn-1) 。

Along the course of my career, I always liked to refactor, always prized good code, and negotiated time in the sprint for it. DDD, Hexagonal, Clean Architecture, you know all the buzzwords. I like this topic, I like to discuss the trade-offs and different ideas on how to shape codebases. I *really* like it.在我的职业生涯中，我一直喜欢重构，始终珍视优质代码，并会在冲刺阶段争取到重构的时间。领域驱动设计、六边形架构、整洁架构，这些热门术语你都耳熟能详。我喜欢这个话题，喜欢探讨如何构建代码库的权衡取舍和不同思路。我 *真的* 很喜欢它。

This is the last pillar standing. Except that nobody cares anymore.这是最后一根还屹立着的支柱了。可问题是，现在已经没人在乎这根支柱了。

Agents do a really bad job at keeping codebases organized. If you don't steer them, they'll hit a circular dependency issue sooner than you think. Will duplicate code. Add unnecessary comments. Mix up pure functions and side-effects. Disregard the principles of SOLID.智能体在维护代码库的整洁性方面表现极差。如果不对其加以引导，它们会比你预想的更快出现循环依赖问题。会产生重复代码，添加不必要的注释，混淆纯函数与副作用，还会无视 SOLID 原则。

That should keep humans employed, except that this skill is now being reduced to the word "taste". But it's not just a renaming, the industry is moving to a world where code organization is less important.这应该能让人类继续保有工作，只不过这项技能如今被简化为“品味”一词。但这不仅仅是换个说法，行业正朝着代码组织不再那么重要的方向发展。

Sure, humans should steer the agent to prevent spaghetti codebases with circular dependency graphs. We don't want `F` -rated codebases that are impossible to touch without breaking something. But a `C` or `D`? It's now fine. Nobody needs `A` or `B` -grade codebases anymore because they're being made for LLMs, not for humans to read.当然，人类应该引导智能体，避免出现带有循环依赖图的混乱代码库。我们不想要 `F` 级别的代码库——这类代码库只要触碰就会出问题。但 `C` 级或 `D` 级呢？现在已经没问题了。没人再需要 `A` 级或 `B` 级的代码库，因为它们是为大语言模型（LLMs）打造的，而非供人类阅读。

I don't want to argue if this is inherently good or bad. If the source code is now written for machines to read and not humans, it may be actually ok to target them.我不想争论这本身是好是坏。如果源代码现在是为了让机器阅读而非人类阅读而编写的，那么以机器为目标或许其实是可行的。

But that's another pillar of my expertise that's eroding. A good chunk of the knowledge I accumulated on that topic is not that valuable anymore. All the time I spent on it - reading books, doing real-world exercises, discussing with other engineers, writing ADRs - is becoming useless.但这是我专业能力的另一根支柱正在逐渐崩塌。我在这个领域积累的大量知识，如今已没什么价值了。我为此投入的所有时间——读书、做实际练习、与其他工程师交流、编写架构决策记录（ADRs）——都正变得毫无意义。

## What now? 现在该怎么办？

I'm still employed and I see myself employed (at least in that company) for a foreseeable future. But I don't know what to think about the long-term.我目前仍在职，并且预计在可预见的未来还会在这家公司工作。但我不知道该如何看待长期的发展。

I spent 10 years (even more when you account for non-profession experience) getting good at things that are becoming less and less valuable. My last pillar of expertise is now reduced to a "taste" and will probably won't last long.我花了10年时间（若算上非职业相关的经历，时间还会更长）打磨那些价值正不断降低的技能。我最后一项核心专长如今也只剩“品味”可言，恐怕也难以长久维持。

And I know that's not just me. About 8 months ago there was a layoff at my current company (not related to AI, according to them). Some brilliant ex-coworkers were laid off and are still looking for jobs. Most of them suffer from the same problem I outlined here: their domain expertise is not enough to stand out anymore.我知道这不仅仅是我一个人的问题。大约八个月前，我所在的公司进行了一次裁员（据公司称与人工智能无关）。一些优秀的前同事被裁掉了，至今仍在找工作。他们中的大多数人都面临着我在这篇文章中提到的同样问题：他们的领域专业知识已经不足以让他们脱颖而出了。

The company is now hiring again for a few roles and domain familiarity is not a strong differentiator anymore. We used to list "Software Engineer - Area". Now it's just "Software Engineer" and the team assignment comes after the offer is accepted.这家公司目前又在招聘几个岗位，而领域熟悉度已不再是重要的区分因素。我们过去会列出“软件工程师-某领域”，现在只写“软件工程师”，团队分配则在录用通知被接受后再确定。

Of course, this is good for brilliant engineers that never had the chance to get deep into the domain and now have better chances at getting a job, but it's also sad to think that other brilliant engineers that spent their lives collecting domain knowledge are now competing on the same lane.当然，这对那些从未有机会深入钻研领域的优秀工程师来说是件好事，他们现在有了更好的就业机会；但一想到那些毕生积累领域知识的优秀工程师，如今却要在同一条赛道上竞争，又不免让人感到惋惜。

The only way out for keeping my employability in the long-term now seems to be shifting my domain expertise to something LLMs will not get good at so easily. But what's left?如今，要长期保持自身就业竞争力，唯一的出路似乎是将我的专业领域知识转向那些大语言模型不太容易精通的方向。但还剩下什么呢？

I thought about going back to college, learning Math, Statistics, advanced Machine Learning and applying for research role at a frontier lab. Except that there are no frontier labs in my country, the few ones that exist are flooding with applications and I have family matters that makes moving to another country difficult. By the time I can afford to make that jump, RSI may have made researchers obsolete.我考虑过重返大学，学习数学、统计学、高级机器学习，然后申请前沿实验室的研究岗位。可问题是，我的国家没有前沿实验室，为数不多的几家实验室也堆满了申请；同时，我还有家庭事务要处理，这让我很难移居到其他国家。等我有能力迈出这一步时，重复性工作可能已经让研究人员变得多余了。

Maybe I should consider transforming my woodworking hobby into a profession...或许我应该考虑把我的木工爱好变成一份职业……

---

**Update (Jun 7)**: this post went viral. I wrote another post replying to some comments from social media and expanding some of my arguments. You can read it [here](https://human-in-the-loop.bearblog.dev/replies-to-comments-on-my-llms-are-eroding-my-career-post/).**更新（6月7日）** ：这篇帖子走红了。我又写了一篇帖子回复社交媒体上的一些评论，并进一步阐述了我的部分观点。你可以在 [这里](https://human-in-the-loop.bearblog.dev/replies-to-comments-on-my-llms-are-eroding-my-career-post/) 阅读。

---

<iframe src="chrome-extension://cnjifjpddelmedmihgijeibhnjfabmlf/side-panel.html?context=iframe"></iframe>

[^1]: See [this](https://www.anthropic.com/research/how-ai-is-transforming-work-at-anthropic#:~:text=design%20decisions%20that%20require%20organizational%20context%20or%20%E2%80%9Ctaste.%E2%80%9D), [this](https://pakodas.substack.com/p/how-to-be-a-30x-ai-engineer-with-a-taste#:~:text=The%20word%20that%20keeps%20coming%20up%20is%20%E2%80%9Ctaste.%E2%80%9D) and [this](https://davegriffith.substack.com/p/what-do-engineers-mean-when-we-say) for reference. Don't take this as an endorsement of the content inside any of these posts.请参考 [这篇](https://www.anthropic.com/research/how-ai-is-transforming-work-at-anthropic#:~:text=design%20decisions%20that%20require%20organizational%20context%20or%20%E2%80%9Ctaste.%E2%80%9D) 、 [这篇](https://pakodas.substack.com/p/how-to-be-a-30x-ai-engineer-with-a-taste#:~:text=The%20word%20that%20keeps%20coming%20up%20is%20%E2%80%9Ctaste.%E2%80%9D) 和 [这篇](https://davegriffith.substack.com/p/what-do-engineers-mean-when-we-say) 。不要将此视为对这些帖子中内容的认可。