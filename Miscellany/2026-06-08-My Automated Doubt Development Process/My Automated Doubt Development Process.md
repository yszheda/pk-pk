---
title: "My Automated Doubt Development Process"
source: "https://www.alexself.dev/blog/automated-doubt"
author:
published: 2026-05-22
created: 2026-06-08
description: "How front-loading scrutiny through multi-agent validation rebuilt trust in AI-assisted development."
tags:
  - "ToRead"
---
This process originated out of a lack of trust. I lost trust early in my AI-assisted development due to allowing our LLM partners to do too much, too quickly and without the standard engineering practices I had come to internalize. Trust was regained by automating as much doubt as I could muster. What does performing doubt look like? Critiquing the implementation of an artifact and doing so, repeatedly. If you are using AI to write code, specs, docs or any artifact, you may find this piece useful.这个过程源于信任的缺失。在早期的人工智能辅助开发阶段，我因为让LLM合作伙伴做得太多、太快，且没有采用我早已内化的标准工程实践，从而失去了信任。我通过尽可能消除所有疑虑，重新赢回了信任。消除疑虑具体该怎么做？就是反复审视并批判某个成果的实现过程。如果你正借助人工智能编写代码、技术规范、文档或其他成果，你可能会发现这篇内容对你有所帮助。

I use subagents, quite a bit. They inhabit the fulcrum of the entire process. They are specialized in ways that audit perspectival surfaces a standard instantiation of Claude wouldn't necessarily cover. The core idea in all of this is automated doubt from multiple perspectives and the front-loading of scrutiny. The more parallax coverage in AI development, the better; where different vantage points catch different defects, the way two eyes give you depth. The development process goes something like this:我会大量使用子智能体。它们处于整个流程的关键支点。它们具备专门能力，能审视标准版 Claude 未必覆盖的视角相关层面。这一切的核心理念是从多个角度进行自动化质疑，并提前开展审查。人工智能开发中的视角覆盖越全面越好；不同视角能发现不同缺陷，就像两只眼睛能让你感知到深度。开发流程大致如下：

## Phase 1 — Design 第一阶段——设计

It starts with an idea or a feature I'd like to build and a specification. Like any good development practice, it's usually wise to start with a spec, PRD, plan, or whatever flavor of design preferred. I ask Claude to write the spec and I spend 2–5 minutes skimming the file to verify the core implementation aspects of the idea are captured. This is where the iteration process begins.一切都始于一个我想要实现的想法或功能，以及一份需求规格说明书。和所有优秀的开发流程一样，从规格说明书、产品需求文档、项目计划，或是任何形式的设计文档入手，通常都是明智之选。我会让 Claude 撰写这份规格说明书，然后花2到5分钟快速浏览文件，确认这个想法的核心实现要点都被准确涵盖。迭代流程正是从这一步开始的。

I start with a Pre-implementation workflow (slash command in Claude Code), which consists of three agents performing the first round of doubt: Pre-Implementation Architect, Documentation Validator and Assumption Excavator. These agents do several things: verify design quality, scope assessment, completeness, documentation gaps and all the hidden assumptions that exist in the spec. All relevant findings discovered are folded into the spec by the main terminal agent — usually 10–25 depending on the scope of the idea.我先从一个实施前工作流（Claude Code 中的斜杠命令）开始，该工作流由三名执行第一轮质疑的智能体组成：实施前架构师、文档验证师和假设挖掘师。这些智能体负责多项工作：验证设计质量、进行范围评估、检查完整性、发现文档漏洞，以及梳理需求规格说明中存在的所有隐性假设。主终端智能体会将发现的所有相关结论整合到需求规格说明中——根据想法的范围不同，主终端智能体的数量通常为10到25个。

Example findings: 示例发现：

> **Assumption Excavator:** "executionStatsSchema in registry-sdk returns {totalCount, recentCount, windowMinutes}. Spec assumes {avgScore, medianDurationMs, passRate, lastRunDate, lastRunScore}. Entire history section unbuildable without new API endpoint" **假设挖掘器：** “registry-sdk 中的 executionStatsSchema 返回 {totalCount, recentCount, windowMinutes}。规范假设为 {avgScore, medianDurationMs, passRate, lastRunDate, lastRunScore}。没有新的 API 端点，整个历史部分无法构建”

> **Pre-Implementation Architect:** "HarnessProfile embeds mcp.read/merge/remove/write methods alongside path config. Consider extracting McpConfigStrategy to separate concerns. Each harness file will grow to 80–120 lines otherwise." **预实现架构师：** “HarnessProfile 将 mcp.read/merge/remove/write 方法与路径配置嵌入在一起。考虑提取 McpConfigStrategy 来分离关注点。否则每个 harness 文件的代码行数将增加到 80 到 120 行。”

The scope determines the amount of iterations I make. If the scope calls for it, the iteration continues with the next set of agents: Gap Analyzer, Implied Completeness Detector, Ambiguity Mapper. These agents in particular are excellent at finding all the omitted aspects of the system that will be missed if left unaddressed. When the gaps are discovered, they are added to the spec.范围决定了我进行迭代的次数。如果范围有此要求，迭代将继续处理下一组智能体：差距分析器、隐含完整性检测器、歧义映射器。这些智能体尤其擅长找出系统中所有被遗漏的方面，若不加以处理，这些方面就会被忽略。一旦发现这些漏洞，就会将其补充到规范中。

Example findings: 示例发现：

> **Gap Analyst:** "McpConfigStrategy defines read/merge/write but does not specify behavior for malformed input, permission denied, partial write failure, or file locking. Destructive operation on user config files across 4 harnesses in 3 formats." **差距分析员：** “McpConfigStrategy 定义了读取/合并/写入操作，但未指定格式错误的输入、权限被拒绝、部分写入失败或文件锁定的行为。该策略会对 3 种格式的 4 个测试工具中的用户配置文件执行破坏性操作。”

> **Implied Completeness Detector:** "Manifest records version at root but installation state per-harness. When v0.3.0 user (Claude Code) runs v0.4.0 with --harness opencode, behavior undefined. Per-harness versioning or upgrade reconciliation not addressed." **隐含完整性检测器：** “在根节点记录清单版本，但按测试工具记录安装状态。当 v0.3.0 版本的用户（Claude Code）使用 --harness opencode 运行 v0.4.0 版本时，行为未定义。未解决按测试工具的版本管理或升级协调问题。”

For practical use: 实际应用场景：

- **Small scope:** Pre-implementation only **小范围：** 仅预实现阶段
- **Medium scope:** Pre-implementation with Gap, Implied, Ambiguity **中等范围：** 存在差距、隐含内容与模糊性的预实现阶段
- **Large scope:** Full sweep with multiple runs with each, occasionally dipping into other specialized agents **大范围：** 全面扫描，每次均进行多次运行，偶尔会涉及其他专业智能体

Now I pause and spend some time to read the spec, ~15–60 min. If everything checks out and the spec is ready for development, I ask Claude to generate a companion checklist that we can update and follow along. The checklist is created as a separate file and helps if you need to step away and close out a session mid-dev.现在我会停下来花些时间阅读规范，大约15到60分钟。如果一切无误且规范已准备好进行开发，我会让Claude生成一份配套的清单，我们可以对其进行更新并照着执行。这份清单会作为单独的文件创建，在你需要中途暂停、结束开发会话的情况下也能派上用场。

## Phase 2 — Development 第二阶段——开发

Claude pulls up the spec and checklist and begins development. If I'm picking the spec up with the development partly complete in a new session, I usually ask Claude to explore, or send a Chain Tracer or Deep Explore subagent for the complete picture prior to restarting.Claude 调出规范和清单并开始开发。如果我是在新会话中接手部分开发完成的规范，我通常会让 Claude 进行探索，或者在重新开始之前派一个 Chain Tracer 或 Deep Explore 子代理去了解完整情况。

One aspect of my development process that might stand out and that I would like to highlight: I don't use subagents for writes. This comes back to the trust angle. My experiences of spawning subagents for writes gone awry, often causing more harm than good, led to a temporary line drawn in the sand. I also say temporary, because this will undoubtedly change. As I understand it, there are methods for proper swarm orchestration, worktrees, agent-to-spec driven dev, but that's a bit beyond my trust level now. Sometimes the Claude terminal agent will spawn them for bulk updates, but I prefer a single Claude Code terminal instance building out the project.在我的开发流程中，有一个可能比较突出且我想强调的方面：我不会为写操作使用子智能体。这又回到了信任这个核心问题上。我曾多次为写操作生成子智能体，结果往往弄巧成拙，弊大于利，这让我暂时定下了这条原则。我之所以说“暂时”，是因为这一点无疑会改变。据我了解，目前已有一些合理的集群编排、工作树、智能体按规范驱动开发的方法，但这些还超出了我目前的信任范畴。有时 Claude 终端智能体会为批量更新生成子智能体，但我更倾向于用单个 Claude Code 终端实例来搭建整个项目。

I tackle all phases of the specification until complete. Verify the build works, and then comes the post-implementation development process. I mentioned automated doubt and this is where it shines. The next several iterations of the development process involve running a Post-Implementation workflow consisting of the following subagents: Code Validator, Type Safety Validator, Test Architect, Code Optimizer, Public Interface Validator and Security Analyst. These agents audit the codebase and provide findings: code & testing quality, security posture, duplication, performance considerations, semantic or structural integrity, documentation, the public interface, etc. The first run usually generates (depending on the scope) 15–35 findings, usually with the first 15–20 findings flagged as critical or high severity. These findings are addressed and I re-run the Post-implementation workflow. Then tackle the next set of issues, then the next and so on until I've reached my idea of what quality ought to look like.我会处理规范的所有阶段直至完成。验证构建是否正常运行，随后进入实施后开发流程。我之前提到过自动化审查，而这正是它发挥作用的地方。接下来的几轮开发流程将运行实施后工作流，其中包含以下子代理：代码验证器、类型安全验证器、测试架构师、代码优化器、公共接口验证器以及安全分析师。这些代理会审计代码库并提供各类结果：代码与测试质量、安全状况、代码重复、性能考量、语义或结构完整性、文档、公共接口等。首次运行通常会生成（视范围而定）15至35项结果，其中前15至20项通常被标记为关键或高严重级别。我会处理这些结果，然后重新运行实施后工作流。接着解决下一批问题，依此类推，直到达到我认为应有的质量标准。

Example findings: 示例发现：

> **Code Validator:** "Every other execution method calls trackIfEnabled() after completion. startPipeline() returns PipelineHandle directly without tracking. Async pipeline users get no tracking data." **代码验证器：** “所有其他执行方法都会在完成后调用 trackIfEnabled()。startPipeline() 会直接返回 PipelineHandle，不进行跟踪。异步管道用户将无法获取跟踪数据。”

> **Security Analyst:** "PreflightError includes shellQuote-expanded target path verbatim. Error messages containing resolved filesystem paths may propagate to tracking API and dashboard." **安全分析师：** “PreflightError 会按原样包含经过 shellQuote 扩展的目标路径。包含已解析文件系统路径的错误消息可能会传播到跟踪 API 和控制面板。”

## Phase 3 — Wrap-up and Ship 第三阶段——收尾与发布

Once I've satisfied my preference for what I'm ready to release and everything checks out both in a practical and quality manner, I then run the final workflow: Ship. This workflow consists of the following agents: Code Validator, Type Safety Validator, Test Architect, Code Auditor, Public Interface Validator, Security Analyst, Anxiety Reader, API Contract Validator (if API), Release Readiness Validator. This workflow finalizes the iterative process tackled in the previous phase. 5/9 agents were all in the post-implementation workflow, so they should be finding very little or entering preference territory, the others are checking the API contract (if relevant), runtime consistency, what could break and the release posture of the system. When this runs, the question is: is this ready for release? Depending on the complexity, this may require 2+ iterations of Ship.一旦我确定自己对即将发布的内容的偏好已满足，且从实用性和质量层面来看一切都符合要求，我就会执行最终的工作流程：发布。该工作流程包含以下智能体：代码验证器、类型安全验证器、测试架构师、代码审计员、公共接口验证器、安全分析师、风险评估员、API 契约验证器（若涉及 API）、发布就绪性验证器。此工作流程将完成上一阶段开始的迭代流程。9 个智能体中有 5 个都参与了实施后工作流程，因此它们基本不会发现问题，或只需进行少量偏好设置；其余智能体则会检查 API 契约（如适用）、运行时一致性、潜在故障点以及系统的发布状态。执行该流程时，核心问题是：该内容是否已准备好发布？根据复杂程度不同，这一发布流程可能需要进行 2 次及以上的迭代。

Example findings: 示例发现：

> **Anxiety Reader:** "Promise.allSettled fires all agents simultaneously with no concurrency limit, risking resource exhaustion and API rate limits." **焦虑阅读者：** “Promise.allSettled 会同时触发所有智能体，没有并发限制，存在资源耗尽和 API 速率限制的风险。”

> **Code Auditor:** "File I/O errors in writeReportFiles caught by handleCoreError which gives SDK-specific hints instead of filesystem-specific messaging." **代码审计器：** “writeReportFiles 中的文件输入/输出错误被 handleCoreError 捕获，该函数会提供特定于软件开发工具包的提示，而非特定于文件系统的提示信息。”

## Conclusion 结论

On the philosophical end, this is the negotiation between the artifacts, the agents and the operator and where the idea of quality converges. We all have an idea of what quality means to us, even the agents themselves have ideas of what both quantifies and qualifies as quality. This is the agreement we make with ourselves and the agents: what constitutes readiness. The foundation of it all is the idea that we are aiming for some form of consistency, usability, readability, maintainability — and underneath those, something we can be more confident in. Quality can be a subjective state, with objective goals. I iterate until those ideas converge. How do you know when to terminate the loop? I'd like to think it's intuitive: the combination of patience, practice, judgement and your expertise in asking the right questions. Is the juice worth the squeeze for this next fix or feature? It comes back to the personal thresholds for whatever state of the project you are ready to release. The artist is never finished, is the engineer? It ultimately comes down to the operator. The good thing about versioning, is that you can always add, subtract or modify in some manner and how that quality manifests is derived from preference and the artifact's trajectory.从哲学层面来说，这是人工制品、智能体与操作者之间的博弈，也是质量理念的交汇点。我们每个人心中都有对“质量”的定义，即便是智能体本身，也清楚如何量化质量、以及何为合格的质量。这是我们与自身、与智能体达成的共识：何为就绪状态。这一切的核心是，我们追求的是某种形式的一致性、可用性、可读性、可维护性——而在这些特质之下，是我们能更有把握的东西。质量可以是一种主观状态，同时也有着客观目标。我会不断迭代，直到这些理念达成统一。如何判断何时停止这个循环？我认为这是一种直觉：耐心、实践、判断力，再加上你擅长提出恰当问题的专业素养，共同构成了判断依据。为了下一次修复或功能优化，付出的努力是否值得？这最终取决于你对项目当前状态的个人接受阈值，即你准备好发布项目的那个状态。艺术家的作品永远没有完成，工程师也是如此？这归根结底还是取决于操作者。版本控制的好处在于，你总能以某种方式添加、删减或修改内容，而质量的呈现方式，则源于个人偏好与人工制品的发展轨迹。

One consideration of the method, and one I can state with confidence: this process is not necessarily cheap on the tokens. For those of us who have spent countless hours burning through tokens and hitting usage limits, this can play a major role in how we develop with AI. For some projects, this process is absolutely overkill, and for others, it's simply not enough and requires appending an entirely different set of agents to audit. My personal inclination is to run this process and run it repeatedly. I'd like to ensure the code I am developing with Claude or any other AI system can be verified, validated and ideally, meet a higher standard. Some projects may require nothing more than a Code Validator and Test Architect for review, others involve 40+ agents from multiple perspectives. If there is at least one agent that should be tried out on any artifact — codebase, spec, docs, etc — it's the Assumption Excavator, as it is near universally applicable.关于这种方法，有一点我可以肯定地说：这个过程在令牌消耗上并非一定省钱。对于那些花了无数时间耗尽令牌、触达使用上限的人来说，这一点会极大影响我们使用AI的开发方式。对于某些项目，这个过程完全是多此一举；而对于另一些项目，它又远远不够，还需要添加一整套完全不同的智能体来进行审核。我个人倾向于运行这个过程，并且反复运行它。我希望确保用 Claude 或其他任何人工智能系统开发出的代码都能经过验证、确认，并且理想情况下，达到更高的标准。有些项目可能只需要一个代码验证器和测试架构师来审核，而另一些项目则需要40多个来自不同视角的智能体参与。如果说任何产物——代码库、规范、文档等——都至少有一个智能体值得尝试，那就是假设挖掘器，因为它的适用性几乎是通用的。

---

This process originated out of a lack of trust and has developed into a trust signal.这个流程源于对信任的缺失，如今已演变为一种信任信号。

The agents, commands, and pipelines referenced in this post are available at [github.com/aself101/agents-and-pipelines](https://github.com/aself101/agents-and-pipelines).本文中引用的智能体、命令和流水线可在 [github.com/aself101/agents-and-pipelines](https://github.com/aself101/agents-and-pipelines) 获取。