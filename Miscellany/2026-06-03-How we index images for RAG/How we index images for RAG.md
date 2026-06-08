---
title: How we index images for RAG - kapa.ai - Instant AI answers to technical questions
source: https://www.kapa.ai/blog/how-we-index-images-for-rag
author:
published: 2026-06-01
created: 2026-06-03
description: Reading the screenshots, diagrams and tables in technical documentation for LLMs
tags:
  - ai
  - llm
  - rag
  - machine-learning
  - databases
---
Kapa builds AI assistants that answer questions from technical documentation. The knowledge bases we process hold millions of images: screenshots, architecture diagrams, circuit schematics, annotated UI walkthroughs. We spent several months working out how to make them useful in our RAG pipeline.  
Kapa 构建能够从技术文档中回答问题的 AI 助手。我们处理的知识库包含数百万张图像：截图、架构图、电路图、注释的 UI 演示。我们花费数月时间研究如何使它们在我们的 RAG 管道中发挥作用。

The short version: we don't send images to the model at query time. We describe each image once, at indexing time, with a cheap vision model, store the descriptions as text, and retrieve them alongside ordinary text chunks. Indexing is a one-time cost; after that, per-query overhead is 1% to 6% over text-only, and answers are measurably, statistically significantly better. This post explains how we got there.  
简而言之：我们在查询时不会将图像发送给模型。我们在索引时使用廉价的视觉模型一次性描述每张图像，将描述作为文本存储，并在普通文本块旁边检索它们。索引是一次性成本；之后，每个查询的开销比纯文本高 1%到 6%，答案在可衡量的、统计上显著的方面更好。这篇帖子解释了我们是如何做到这一点的。

![](https://framerusercontent.com/images/qURKX4mwPMBTX9peq1oYfpPQw.png?width=2013&height=1102)

*Both answers are correct. The one that shows the screenshot is the one a user can act on without hunting for the setting.  
两个答案都是正确的。显示屏幕截图的那个是用户可以不经查找设置就能采取行动的那个。*

## What images actually do in technical documentation图像在技术文档中实际上起什么作用

We went through thousands of real customer questions across hardware, semiconductor, and developer-tooling accounts to see how images earn their place in an answer. They split into two kinds.  
我们通过分析数千个来自硬件、半导体和开发者工具账户的真实客户问题，来了解图像是如何在答案中找到其位置的。它们分为两类。

Most are illustrative. They show what the text already says, only more clearly: a guide says "click the settings icon," and the screenshot beside it shows which icon, where, and what it looks like. The words carry the fact; the picture makes it easy to act on.  
大多数图像是说明性的。它们展示了文本已经说明的内容，只是更清晰：一个指南说“点击设置图标”，旁边的截图显示了哪个图标、在哪里以及它看起来像什么。文字传达了事实；图像使操作变得容易。

Some are load-bearing. A wiring diagram, a spec table, a certification or color-availability matrix can hold a value that lives in the figure and essentially nowhere else. There the picture is not a convenience, it is the source of the answer.  
有些是承重结构。一张电路图、一份规格表、一份认证或颜色可用性矩阵可以包含一个存在于图中且几乎不存在于其他地方的值。在那里，图片不是一种便利，它是答案的来源。

We confirmed the lift either way: with image context available, an LLM judge preferred the answers across three customer projects and two models, by a statistically significant margin (McNemar's test, p < 0.05).  
我们确认了这一点：无论哪种情况，在有图像上下文的情况下，一个 LLM 裁判在三个客户项目和两个模型上更倾向于某个答案，其优势具有统计学意义（McNemar 检验，p < 0.05）。

![](https://framerusercontent.com/images/lgyxrHf3yYNsxGf6DrlLl0tdGw.png?width=1931&height=1063)

The improvement is the kind a user feels. Instead of "look for the configuration section that controls the setting," you get the specific path plus a screenshot showing exactly where to click. Same facts, far easier to act on. For a support assistant, that is the difference between a user who self-serves and one who opens a ticket.  
改进是用户能感受到的。不再是“寻找控制该设置的配置部分”，而是得到具体的路径加上一张截图，显示确切要点击的位置。相同的事实，但行动起来容易得多。对于支持助手来说，这是区别于用户自助服务与打开工单的关键。

Either way, images make answers materially better. The engineering question is the one the rest of this post is about: how to use them without paying a vision bill on every query.  
无论如何，图片能让答案实质上变得更好。本文其余部分要讨论的工程问题是：如何在不为每个查询支付视觉费用的情况下使用它们。

## Why query-time multimodal does not work at scale为什么查询时多模态无法规模化工作

The approach most people reach for first: retrieve the relevant chunks, collect the images they reference, and pass everything to a vision-capable model.  
人们首先尝试的方法：检索相关片段，收集它们引用的图像，并将所有内容传递给一个具备视觉能力的模型。

We tested it with GPT 5.1 and Claude 4.6 Sonnet across hundreds of production questions. The problems are structural, not engineering details to tune away.  
我们使用 GPT 5.1 和 Claude 4.6 Sonnet 在数百个生产问题中进行了测试。问题在于结构层面，而不是可以通过调整工程细节来解决的。

![](https://framerusercontent.com/images/tbv8htyL0o1fRwoJK4prhcluoU.png?width=1602&height=1063)

**The economics do not work.** Raw images added 27% to per-query cost on GPT and 51% on Claude (Claude tokenizes an image at roughly 975 tokens to GPT's 716). We serve millions of queries; paying that much more on all of them, when most answers do not need a fresh look at the pixels, is not a trade we can make.  
经济学行不通。原始图像增加了 GPT 每次查询成本的 27%，Claude 的 51%（Claude 将图像标记为大约 975 个标记，而 GPT 为 716 个）。我们服务于数百万次查询；在所有查询上支付这么多费用，而大多数答案不需要重新查看像素，这不是我们可以做的交易。

**The images do not physically fit.** A typical question retrieves 10-30 chunks referencing 20-30 images on average, with a long tail past 130. Claude's payload limit is 30 MB and OpenAI's 50 MB; around 25 images already approaches Claude's ceiling. You would have to cap images aggressively, which defeats the point.  
图像在物理上无法适配。一个典型的问题会检索 10-30 个数据块，平均引用 20-30 张图像，并且存在超过 130 的长尾。Claude 的负载限制是 30 MB，OpenAI 的是 50 MB；大约 25 张图像就已经接近 Claude 的上限。您必须对图像进行严格限制，这违背了初衷。

**Multimodal retrieval does not suit this domain.** CLIP-style embeddings wash out exactly the fine detail that matters in charts, tables, and annotated screenshots, and short technical queries ("how do I configure X") give too little signal to match against image vectors.  
多模态检索不适用于这个领域。CLIP 风格的嵌入会模糊图表、表格和标注截图中重要的细节，而简短的技术查询（“如何配置 X”）提供的信号太少，无法与图像向量匹配。

These are properties of today's ecosystem, not bugs to fix. They pointed us away from query-time vision entirely.  
这些是当今生态系统本身的特性，而不是需要修复的错误。它们完全将我们引离了查询时的视觉处理。

## Describe once at indexing time, retrieve as text在索引时描述一次，以文本形式检索

The approach that works inverts the economics. Instead of paying to process images on every query, you pay once, at indexing time, to turn each image into a text description. After that, retrieval and generation run entirely in text.  
这种方法是经济模式的倒置。与其在每次查询时付费处理图像，不如在索引时一次性付费，将每张图像转换为文本描述。之后，检索和生成完全在文本中运行。

At indexing time, a vision language model writes a caption for each image. The captions are stored and retrieved alongside ordinary text chunks. At query time, if a caption is relevant, the retriever pulls it in; the model sees the caption, never the raw image, and cites the image by its original URL.  
在索引时，一个视觉语言模型为每张图像编写一个标题。这些标题与普通文本块一起存储和检索。在查询时，如果标题相关，检索器会将其拉取；模型看到的是标题，而不是原始图像，并通过其原始 URL 引用图像。

This works because the heavy lifting, actually looking at the image, happens once, at ingestion, instead of on every query. For an illustrative screenshot the caption is a description; for a load-bearing figure it is a transcription of what the figure holds, the values in the table, the labels on the diagram. Either way the content becomes text, and the rest of the pipeline never has to see a pixel. [Microsoft's research team](https://devblogs.microsoft.com/ise/multimodal-rag-with-vision/) also reached the same conclusion: describe at ingestion, store as separate chunks.  
这之所以有效，是因为繁重的计算工作——实际查看图像——只发生一次，在数据摄取时，而不是在每次查询时。对于说明性截图，标题是描述；对于承重性图表，它是图表所包含的内容的转录，表格中的值，图表上的标签。无论如何，内容都变成了文本，其余的流程再也不需要看到像素。微软的研究团队也得出了同样的结论：在数据摄取时描述，以单独的块存储。

This is what makes the load-bearing case work, and it is where a lot of assistants quietly fail. A color-availability matrix is a wall of check marks; a fire-resistance table is a grid of ratings. Flatten one into plain text with a generic extractor and the structure dissolves, which is how an assistant ends up confidently telling a customer a panel comes in a color it does not. Transcribed at ingestion, the same matrix becomes retrievable text, and the answer stays grounded in what the figure actually shows.  
这就是承重外壳能够发挥作用的地方，也是许多助手默默失败的地方。颜色可用性矩阵是一面检查标记墙；耐火性表格是一个评级网格。用通用提取器将其中一个扁平化为纯文本，结构就会消失，这就是助手如何自信地告诉客户一个面板有它实际上没有的颜色。在摄入时转录，同一个矩阵变成了可检索的文本，答案仍然基于图形实际显示的内容。

![](https://framerusercontent.com/images/fy8Qrki0H9xNqgSn4wQgjPfuGA.png?width=1989&height=1179)

*For datasheet-heavy products, the figure can sometimes be the answer. Though, this is rarely found based on real user questions in production.  
对于数据表密集型产品，图表有时可以是答案。然而，这在生产中很少基于真实用户问题找到。*

## What you have to get right in production 你需要在生产中做对的

### Filtering: most images are junk, and some cannot be classified过滤：大多数图像都是垃圾，有些无法分类

![](https://framerusercontent.com/images/Tqgp2wyeJVboXC7VFaDe02lOOTA.png?width=1765&height=1063)

You cannot caption millions of images indiscriminately. Most are noise: logos, avatars, social preview cards, decorative banners. Heuristics handle the first pass (drop unsupported formats, tiny images, extreme aspect ratios). For the rest, we built a zero-shot classifier on multimodal embeddings. It is cheap enough to run across the whole corpus.  
你不能随意给数百万张图片加标题。大多数都是噪音：标志、头像、社交预览卡片、装饰性横幅。启发式算法处理第一轮（丢弃不支持的格式、微小的图片、极端的宽高比）。对于其余的，我们在多模态嵌入上构建了一个零样本分类器。它足够便宜，可以在整个语料库上运行。

On clear-cut images it hits 96.8% accuracy (F1 0.974). On ambiguous ones, accuracy collapses to 59.8%, and the reason is fundamental. A screenshot of a countdown timer could be a decorative banner or step 3 of a tutorial about timers. The pixels are identical; without the surrounding text there is not enough information to decide, and no embedding model can fix that. So we accept it: the classifier removes the clear junk (about 13% of what survives heuristics) and we tolerate the ambiguous edge. Context-aware classification is the obvious next step.  
在清晰的图像上，准确率达到 96.8%（F1 0.974）。在模糊的图像上，准确率降至 59.8%，而原因在于根本。一个倒计时计时器的截图可能是装饰性横幅，也可能是关于计时器的教程的第 3 步。像素是相同的；没有周围的文字，没有足够的信息来决定，而且没有任何嵌入模型可以解决这个问题。所以我们接受这一点：分类器移除了明显的垃圾（大约是 13%的通过启发式方法存活的图像），我们容忍模糊的边缘。上下文感知分类是明显的下一步。

### Captioning: context matters more than model size字幕：上下文比模型大小更重要

Two things drive caption quality. First, surrounding text: feed the model the paragraphs before and after the image and quality jumps. Without context, a file-upload dialog is "a web page with a file upload form"; with it, the caption is grounded in the specific product, workflow, and step, which is what makes it useful for retrieval.  
驱动标题质量有两个因素。首先，周围文本：向模型提供图像前后的段落，质量会跃升。没有上下文，文件上传对话框是“一个带有文件上传表单的网页”；有了它，标题就基于特定的产品、工作流程和步骤，这才是它对检索有用的原因。

Second, expensive models buy little. We compared five, from Claude 4.6 Sonnet down to GPT 5.4 nano. A small model (GPT 5.4 mini) produced captions almost indistinguishable from models four times its price; only nano dropped off. At our scale, a small model is the obvious choice.  
其次，昂贵的模型用处不大。我们比较了五个，从 Claude 4.6 Sonnet 一直到 GPT 5.4 nano。一个小模型（GPT 5.4 mini）生成的标题几乎无法与价格是其四倍的大模型区分开来；只有 nano 模型表现下降。在我们这个规模下，小模型是明显的选择。

### Storage: separate caption chunks beat inline存储：分离标题块优于内联

Two ways to integrate a caption. Inline: replace the image's alt text in the document, so some chunks carry both text and description. Separate: store each caption as its own chunk, leaving the document untouched.  
两种整合标题的方式。内联：在文档中替换图像的 alt 文本，因此某些片段同时包含文本和描述。分离：将每个标题作为自己的片段存储，不改变文档。

We expected inline to win, since the caption sits next to its text. Separate won, on both cost and image usage. Inline captions inflate every chunk they live in, and those chunks ship on every query whether the images are relevant or not. Separate chunks only enter the context when the retriever judges them relevant, so you pay for an image only when it matters. On one image-heavy project, inline raised per-query cost 19% with GPT; separate, 6%. With Claude, separate captions slightly lowered cost versus text-only. And they earn their place: the re-ranker promoted them into the top 15 on 51% of queries, while overall ranking held steady (Spearman ρ = 0.905).  
我们预期内联会获胜，因为标题紧挨着文本。分离获胜，在成本和图像使用上都是如此。内联标题会使其所在的每个块膨胀，而这些块会在每个查询中发送，无论图像是否相关。分离块只有在检索器判断它们相关时才会进入上下文，所以你只有在图像重要时才为图像付费。在一个图像密集型项目中，内联使用 GPT 使每查询成本提高了 19%；分离，6%。使用 Claude，分离标题相对于纯文本略微降低了成本。它们赢得了自己的位置：重新排序器在 51%的查询中将它们提升到前 15 名，而整体排名保持稳定（Spearman ρ = 0.905）。

## Results 结果

End to end across three customer projects with GPT 5.1 and Claude 4.6 Sonnet:  
在三个客户项目中，使用 GPT 5.1 和 Claude 4.6 Sonnet 进行端到端：

|  | Text-only baseline 纯文本基线 | With image captions 带图像标题 |
| --- | --- | --- |
| Images cited in answers 答案中引用的图像 | 0% | 10% to 64% 10% 到 64% |
| Answer quality (LLM judge)   答案质量（LLM 判定） | baseline 基线 | significantly better (p < 0.05)   显著改善 (p < 0.05) |
| Per-query cost 每查询成本 | baseline 基线 | +1% to 6% +1% 到 6% |
| Latency (time to first token)   延迟（第一个令牌的时间） | baseline 基线 | sub-second increase 亚秒级增长 |
| Model uncertainty 模型不确定性 | baseline 基线 | unchanged or slightly lower   保持不变或略微降低 |
| Indexing cost 索引成本 | n/a 不适用 | one-time, then no recurring image cost   一次性，之后无 recurring 图像成本 |

Across every experiment, images were placed correctly 94% to 99% of the time.  
在每一次实验中，图像正确放置的比例为 94%至 99%。

This is a less flashy answer than "use a multimodal model," and that is the point. It works because it puts the vision where it belongs: once, at ingestion, turning whatever an image holds into text, instead of paying to re-examine pixels on every query. Whether an image clarifies the words or carries the answer outright, reading it once is cheaper and a better fit for how the rest of the pipeline works. The constraints we hit were not obstacles to engineer around; they were pointing at the architecture.  
这是一个不如“使用多模态模型”那样耀眼的答案，而这正是要点。它之所以有效，是因为它把视觉处理放在了它应该的位置：在摄入时一次性将图像所包含的内容转换为文本，而不是在每次查询时都付费重新检查像素。无论图像是解释文字还是直接包含答案，一次性阅读都更经济，也更符合其余流程的工作方式。我们遇到的限制不是需要工程师去克服的障碍；它们是在指明架构的方向。

Rolling out in preview now.  
正在预览中。

###### TRUSTED BY 200+ INDUSTRY-LEADING ENTERPRISES WITH COMPLEX PRODUCTS受 200 多家拥有复杂产品的行业领先企业信赖

- Logitech
	Ask anything...
- n8n
	How does the $if() expression helper work in n8n?  
	$n8n 中的 $if() 表达式辅助函数是如何工作的？
	Spinning...惊慌...
	Ask anything...有任何问题...
- monday.com
	How do I change a status column's value via the monday.com API?  
	如何通过 monday.com API 更改状态列的值？
	Whirring...呼噜噜...
	Ask anything...有任何问题...

<iframe src="chrome-extension://cnjifjpddelmedmihgijeibhnjfabmlf/side-panel.html?context=iframe"></iframe>