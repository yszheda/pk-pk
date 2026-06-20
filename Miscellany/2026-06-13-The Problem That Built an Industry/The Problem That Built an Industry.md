---
title: "The Problem That Built an Industry"
source: "https://ajitem.com/blog/iron-core-part-1-the-problem-that-built-an-industry/"
author:
  - "[[Ajitem Sahasrabuddhe]]"
published: 2026-04-08
created: 2026-06-13
description: "How a conversation on a plane in 1953 set in motion the stack that eventually processes tens of thousands of flight bookings per second, and why that stack is still here."
tags:
---
Series 系列 Part 1 of 6 // Iron Core 第一部分，共六部分 // 铁核

## The Problem That Built an Industry 孕育产业的问题

*Part 1 of 6 in the Iron Core series: the 60-year-old infrastructure that flies 4.5 billion people a year.铁核系列的第一部分（共6部分）：这座拥有60年历史、每年有45亿人飞行的基础设施。*

---

In December 2025, someone at Technogise opened MakeMyTrip's corporate platform, typed in a destination, and booked me two flights to London. The whole thing took under a minute. A confirmation email landed in my inbox. Six-character booking references appeared: **DDTCIV** and **DHB4AL**.2025年12月，Technogise的某人打开了MakeMyTrip的企业平台，输入目的地，给我订了两张飞往伦敦的机票。整个过程不到一分钟。一封确认邮件寄到了我的收件箱。出现了六字符的预订参考： **DDTCIV** 和 **DHB4AL。**

I was going to speak at ContainerDays 2026. A conference about containers, orchestration, and cloud-native infrastructure: the kind of modern, ephemeral, stateless systems I spend my working life thinking about.我本打算在2026年ContainerDays上发言。这是一个关于容器、编排和云原生基础设施的会议：那种我毕生都在思考的现代、短暂、无状态的系统。

The irony only hit me on the flight over.这种讽刺感直到飞过来的飞机上才真正感受到。

The infrastructure that booked those flights traces its design to the 1960s. It still runs on lineages that predate Unix and speaks command languages built for teletypes. The implementations, hardware, and surrounding software have been replaced and upgraded many times. What persists is the data model, the protocols, and the transaction semantics. None of that happened in a single rewrite: it accumulated while the system kept flying, and at peak it still handles on the order of 10,000 transactions per second.预订这些航班的基础设施设计可追溯到20世纪60年代。它仍然运行在 Unix 之前的谱系上，并使用为电传打字机编写的命令语言。其实现、硬件及相关软件多次更换和升级。持续存在的是数据模型、协议和事务语义。这些都不是一次性重写：在系统持续运行的同时，这些交易是积累的，峰值时仍能处理大约每秒1万笔交易。

I build distributed systems. I thought I understood complex infrastructure. Then I looked at my own boarding pass and pulled the thread.我构建分布式系统。我以为我懂复杂的基础设施。然后我看了看自己的登机牌，拉开了那条线。

This is a six-part series about what I found.这是一个六部分的系列，讲述我所发现的内容。

---

## The World Before SABRE SABRE 之前的世界

To understand why this infrastructure exists, you need to understand the problem it was built to solve.要理解这个基础设施存在的原因，你需要了解它被建造时要解决的问题。

By the mid-1950s, American Airlines was managing reservations on index cards. A booking required a phone call to an agent, who would search physical card racks across multiple city offices, confirm availability verbally, and call the passenger back. A transatlantic reservation could take 90 minutes to confirm. The airline was processing roughly 85,000 reservation requests a day across 50-plus cities. The system was collapsing.到20世纪50年代中期，美国航空开始通过索引卡管理预订。预订需要打电话给代理，工作人员会在多个市政府办公室的实体卡架上搜索，口头确认可用时间，然后再回电乘客。跨大西洋的预订可能需要90分钟确认。该航空公司每天处理约85,000个预订请求，覆盖50多个城市。系统正在崩溃。

The origin story of what would become the GDS (Global Distribution System) is well-documented, though it has acquired a degree of mythology in retelling. In 1953, C.R. Smith, president of American Airlines, was seated next to R. Blair Smith, an IBM salesman, on a cross-country flight. IBM and American Airlines entered a formal development partnership in 1959, six years later.后来成为全球分销系统（GDS）的起源故事有详尽的记载，尽管在被重新讲述时带有一定的神话色彩。1953年，美国航空公司总裁C.R.史密斯在一次跨国航班上，坐在IBM销售员R·布莱尔·史密斯旁边。六年后的1959年，IBM与美国航空正式建立开发合作关系。

The result was **SABRE** (Semi-Automated Business Research Environment). It went live in 1964: five years after the 1959 contract, and eleven years after the 1953 conversation.结果就是 **SABRE** （半自动化商业研究环境）。该节目于1964年上线，距1959年合同签订已有五年，距1953年对话已有十一年。

That is the scale of lead time for infrastructure of this kind. The same year SABRE launched, IBM announced the System/360. Three years before the first ATM. Five years before the moon landing. Fifteen years before VisiCalc.这就是这类基础设施的交期规模。SABRE推出的同一年，IBM发布了System/360。第一台ATM出现前三年。登月前五年。在维斯计算（VisiCalc）出现前十五年。

Within a decade, every major airline followed suit:十年内，所有主要航空公司都效仿了：

| GDS | Founded 成立 | Original Owner 原始所有者 | Tech Foundation 科技基金会 |
| --- | --- | --- | --- |
| SABRE 军刀 | 1964 | American Airlines + IBM 美国航空 + IBM | IBM ACP / TPF |
| Apollo 阿波罗 | 1971 | United Airlines 联合航空 | IBM TPF |
| Galileo 伽利略 | 1987 | United + BA + KLM + Swissair 联合航空+英国航空+荷兰皇家航空+瑞士航空 | IBM TPF |
| Worldspan 世界跨度 | 1990 | Delta + Northwest + TWA 达美 + 西北 + TWA | IBM TPF |
| Amadeus 阿玛迪斯 | 1987 | Air France + Lufthansa + Iberia + SAS 法航 + 汉莎航空 + 伊比利亚航空 + 特种空货公司 | Bull mainframe, then Unix Bull大型机，然后是Unix |

Four of the five North American-originated stacks in that table were built on IBM TPF (or its ACP lineage). Amadeus is the exception: Bull, then Unix. They did not all land on the same executable runtime, but they had to solve the same problem shape: huge volume of small, latency-bounded transactions over shared inventory and settlement rules, in an industry where IATA practice and interlining economics made divergence expensive.该表中五个北美起源的栈中有四个是基于IBM TPF（或其ACP谱系）构建的。Amadeus是例外：先是Bull，然后是Unix。它们并非都运行在同一个可执行运行时，但必须解决相同的问题形态：大量小额、延迟受限的交易，涉及共享库存和结算规则，而在IATA实践和联联经济使分流成本高昂的行业中。

That convergence was not an accident of engineering taste. IATA's messaging standards, interlining settlement rules, and the economic penalties of non-interoperable systems pushed carriers toward compatible shapes. When you see similar stacks in one industry, regulatory standards and switching costs are usually doing more work than independent discovery.这种融合并非工程品味的偶然。IATA的消息标准、联运结算规则以及不可互操作系统的经济惩罚推动了承运人趋向兼容的形态。当你在某个行业看到类似的堆栈时，监管标准和切换成本通常比独立发现更多的工作量。

---

## TPF: The OS That Refuses to Die TPF：拒绝死亡的操作系统

**Transaction Processing Facility** (TPF) is an IBM mainframe operating system descended from ACP, American Airlines' original Airline Control Program. It was designed for one purpose: processing enormous volumes of simple transactions with sub-millisecond response times.**交易处理设施** （TPF）是IBM的一款大型操作系统，源自美国航空最初的航空控制程序ACP。它的设计目的只有一个：处理大量简单交易，响应时间极短。

It is not Unix. It does not share Unix's lineage, its philosophy, or its abstractions. It predates Unix by a decade.它不是Unix。它不共享Unix的渊源、理念或抽象概念。它比Unix早十年。

Understanding TPF requires setting aside almost everything you know about modern operating systems:理解TPF需要放下你对现代操作系统的几乎所有了解：

| Property 财产 | TPF | Modern OS 现代操作系统 |
| --- | --- | --- |
| Process model 流程模型 | No processes. No threads. Short-lived "programs" that execute and exit.没有流程。没有线。短暂的“程序”，执行后退出。 | Processes, threads, coroutines 进程、线程、协程 |
| Memory model 内存模型 | Fixed memory "cells" per transaction. No heap. No dynamic allocation.每个交易的固定内存“单元”。没什么。没有动态分配。 | Virtual memory, heap, GC 虚拟内存、堆、GC |
| I/O model 输入输出模型 | Extremely fast synchronous I/O to DASD (Direct Access Storage) 极快的同步I/O到DASD（直接访问存储） | Async I/O, block storage, NVMe 异步输入输出，块存储，NVMe |
| Scheduling 排程 | Preemptive, priority-based, microsecond granularity 抢占式、基于优先级的微秒级粒度 | Typically millisecond granularity 通常为毫秒级 |
| Failure model 失效模型 | Transaction-level rollback. The system does not crash; the transaction does.事务级回滚。系统不会崩溃;交易会有。 | Depends on application 这取决于应用情况 |
| Primary language 主要语言 | Assembler. C was added later. 汇编器。后来才加入了C。 | Everything 一切 |

TPF is not really an OS in the way you think of one. It is closer to what we would now call a **transaction runtime**: a system purpose-built to receive a unit of work, execute a short program against it, commit state changes, and immediately move on. The application-facing transaction path is deliberately minimal: no long-lived per-client worker holding connection state in memory between units of work, and no Unix-style thread-per-request model for that path. System-level scheduling, I/O, and housekeeping still exist; this is not a claim that the machine does nothing between transactions.TPF其实并不是你想象中的操作系统。它更接近我们现在所说的 **事务运行时** ：一个专门用于接收工作单元、对其执行短程序、提交状态变化并立即继续的系统。面向应用程序的事务路径刻意最小化：没有长时间的每个客户端工作单元间存储连接状态，也没有类似Unix的线程每请求模型。系统级调度、输入输出和维护功能依然存在;这并不是说机器在交易之间什么都不做。

This design was made for one workload. It is exceptionally good at that workload.这种设计是为单一工作负载设计的。它在这类工作量上表现得非常出色。

Modern TPF-based systems handle around 10,000 transactions per second under normal conditions. During a fare sale, when millions of customers simultaneously discover that flights are cheap, that number can reach 50,000 TPS. End-to-end message round-trip: roughly 100 milliseconds. Those numbers reflect a tight transaction model and sixty years of operational hardening.现代基于TPF的系统在正常情况下每秒处理约10,000笔交易。在票价促销期间，当数百万顾客同时发现机票便宜时，这个数字可以达到每秒5万。端到端消息往返时间：大约100毫秒。这些数字反映了严格的交易模式和六十年的运营磨砺。

In the 1990s, when every other industry was migrating off mainframes to Unix, airlines looked at the performance numbers and stayed put. The replacements could not match the throughput for this specific workload. Many still cannot. The IBM Z-series mainframes running z/TPF today are not running it out of nostalgia.在1990年代，当其他行业都从大型机迁移到Unix时，航空公司只看性能数据并选择了原地。替换设备无法匹配该特定工作负载的吞吐量。许多人至今仍无法理解。如今运行z/TPF的IBM Z系列大型机并非出于怀旧。

Sabre (the company) today also sells cloud-native layers and API-first products around the same domain. The industry runs old cores and new surfaces in parallel more often than headlines suggest.如今，Sabre（公司）也在同一领域销售云原生层和API优先产品。行业中旧核心和新表面并行运行的频率比头条报道的要高。

---

## Where My Flights Fit Into This 我的航班在这其中扮演的角色

When Technogise booked my ContainerDays travel through myBiz, the booking touched a specific layer of this ecosystem. MakeMyTrip uses **Amadeus** as its GDS: the system born from a 1987 partnership between Air France, Lufthansa, Iberia, and SAS, and now the dominant GDS across Europe, India, and much of Asia-Pacific.当Technogise通过myBiz预订我的ContainerDays旅行时，这个预订触及了这个生态系统的特定层面。MakeMyTrip使用 **Amadeus** 作为其GDS：该系统源自1987年法航、汉莎航空、伊比利亚航空和SAS的合作，现已成为欧洲、印度及亚太地区主导的GDS。

Amadeus is not running on the original 1987 Bull mainframe. It migrated to Unix in the 1990s and has since moved progressively toward a more modern architecture. But the data model, the protocol, and the command language that agents use (cryptic mode) remain continuous with the original 1960s design. The format of my PNR, the structure of my e-ticket, the way the fare is calculated: all of it follows conventions established before I was born.Amadeus并未运行在1987年原始的Bull主机上。它在1990年代迁移到Unix，并逐步向更现代的架构转变。但数据模型、协议以及代理使用的命令语言（隐晦模式）依然延续了1960年代的原始设计。我的PNR格式、电子票的结构、票价的计算方式：所有这些都遵循了我出生前就建立的惯例。

My outbound was entirely Air India (**DDTCIV**, NAG→DEL→LHR). Air India runs on **Amadeus Altéa**, a modern PSS (Passenger Service System) built on top of the Amadeus infrastructure. They migrated to it in 2023, replacing a legacy SITA system. That migration is one of the largest airline PSS migrations in Asian aviation history, and its cost and complexity are worth understanding on their own terms. I come back to it in Part 4.我的出发航班完全是印度航空（ **DDTCIV** 、NAG→DEL→LHR）。印度航空采用 **Amadeus Altéa** ，这是一套建立在Amadeus基础设施之上的现代乘客服务系统（PSS）。他们于2023年迁移到该系统，取代了旧有的SITA系统。这场迁移是亚洲航空史上最大规模的航空公司PSS迁移之一，其成本和复杂性值得单独理解。我在第四部分会回到这个话题。

The return (**DHB4AL**, MAN→LHR→DEL→NAG) mixed British Airways (also on Amadeus Altéa) and Air India. Because both carriers on that routing sit on the same Amadeus stack, a single PNR could span both airlines without a hand-built bridge between unrelated PSSs. That consistency is what made the booking work, and what made re-accommodation possible when things went wrong.返程航班（ **DHB4AL** ，曼→LHR→德拉→NAG）由英国航空（同样在阿玛迪斯阿尔特亚）和印度航空混合运营。由于该航线上的两家运营商都位于同一Amadeus协议栈上，一个PNR可以跨越两家航空公司，而无需在无关的PSS之间手工搭建桥梁。正是这种一致性让预订顺利进行，也让在出现问题时能够重新安置。

---

## IndiGo and the Budget Carrier DivergenceIndiGo与经济型运营商的分歧

IndiGo (the largest airline in India by market share) does not use Amadeus. It uses **Navitaire**, a PSS built specifically for low-cost carriers, now owned by Amadeus but operated as a separate product. Navitaire's NewSkies platform is purpose-built for high-volume, low-margin, point-to-point flying: no interline, no complex fare construction, no legacy baggage.IndiGo（印度市场份额最大的航空公司）不使用Amadeus。它使用 **Navitaire** ，这是一种专为低成本航空公司设计的PSS，现由Amadeus拥有，但作为独立产品运营。Navitaire的NewSkies平台专为高流量、低利润、点对点飞行而设计：无联运，无复杂票价结构，无遗留行李。

This is a deliberate architectural choice. Navitaire is cheaper to operate, faster to configure, and optimised for the IndiGo model: high frequency, fixed pricing, minimal complexity. The trade-off is reduced interoperability. IndiGo distributes inventory into Amadeus for travel agent bookings (you can see 6E flights in a cryptic availability display), but the ticketing and check-in systems are entirely Navitaire.这是一个有意为之的建筑选择。Navitaire 运行成本更低，配置更快，并且针对 IndiGo 模型进行了优化：高频率、固定定价、最小复杂度。代价是互操作性降低。IndiGo将库存分发到Amadeus中供旅行社预订（你可以在一个神秘的可用性显示屏中看到6E航班），但票务和值机系统完全由Navitaire操作。

The split matters when something goes wrong. An IndiGo delay affecting an Air India connection does not trigger automatic re-accommodation between systems. A human has to intervene.当出现问题时，分裂很重要。IndiGo延误影响印度航空转机不会触发系统间自动重新安置。必须有人介入。

| Airline 航空公司 | PSS | GDS Distribution GDS分发 |
| --- | --- | --- |
| Air India (AI) 印度航空（AI） | Amadeus Altéa 阿马迪乌斯·阿尔特亚 | Amadeus (primary) 阿玛迪斯（主要） |
| IndiGo (6E) 靛蓝（6E） | Navitaire NewSkies 新航海军 | Amadeus / Sabre (via distribution layer) Amadeus / Sabre（通过分发层） |
| Vistara (absorbed into AI) Vistara（被AI吸收） | Amadeus Altéa 阿马迪乌斯·阿尔特亚 | Amadeus 阿玛迪斯 |
| Air India Express 印度航空快线 | Navitaire 航海 | Amadeus / Sabre 阿玛迪斯 / 军刀 |

---

## What a 30-Second Booking Actually Triggers30秒的预订实际上会触发什么

When myBiz confirmed my booking in December 2025, the following sequence fired:当myBiz在2025年12月确认我的预订时，以下序列就触发了：

<svg id="blog-mermaid-_R_5r5lfiv5ulb_-1" width="100%" xmlns="http://www.w3.org/2000/svg" style="max-width: 276px;" viewBox="0 0 276 1038" role="graphics-document document" aria-roledescription="flowchart-v2"><g><marker id="blog-mermaid-_R_5r5lfiv5ulb_-1_flowchart-v2-pointEnd" viewBox="0 0 10 10" refX="5" refY="5" markerUnits="userSpaceOnUse" markerWidth="8" markerHeight="8" orient="auto"><path d="M 0 0 L 10 5 L 0 10 z" style="stroke-width: 1; stroke-dasharray: 1, 0;"></path></marker><marker id="blog-mermaid-_R_5r5lfiv5ulb_-1_flowchart-v2-pointStart" viewBox="0 0 10 10" refX="4.5" refY="5" markerUnits="userSpaceOnUse" markerWidth="8" markerHeight="8" orient="auto"><path d="M 0 5 L 10 10 L 10 0 z" style="stroke-width: 1; stroke-dasharray: 1, 0;"></path></marker><marker id="blog-mermaid-_R_5r5lfiv5ulb_-1_flowchart-v2-pointEnd-margin" viewBox="0 0 11.5 14" refX="11.5" refY="7" markerUnits="userSpaceOnUse" markerWidth="10.5" markerHeight="14" orient="auto"><path d="M 0 0 L 11.5 7 L 0 14 z" style="stroke-width: 0; stroke-dasharray: 1, 0;"></path></marker><marker id="blog-mermaid-_R_5r5lfiv5ulb_-1_flowchart-v2-pointStart-margin" viewBox="0 0 11.5 14" refX="1" refY="7" markerUnits="userSpaceOnUse" markerWidth="11.5" markerHeight="14" orient="auto"><polygon points="0,7 11.5,14 11.5,0" style="stroke-width: 0; stroke-dasharray: 1, 0;"></polygon></marker><marker id="blog-mermaid-_R_5r5lfiv5ulb_-1_flowchart-v2-circleEnd" viewBox="0 0 10 10" refX="11" refY="5" markerUnits="userSpaceOnUse" markerWidth="11" markerHeight="11" orient="auto"><circle cx="5" cy="5" r="5" style="stroke-width: 1; stroke-dasharray: 1, 0;"></circle></marker><marker id="blog-mermaid-_R_5r5lfiv5ulb_-1_flowchart-v2-circleStart" viewBox="0 0 10 10" refX="-1" refY="5" markerUnits="userSpaceOnUse" markerWidth="11" markerHeight="11" orient="auto"><circle cx="5" cy="5" r="5" style="stroke-width: 1; stroke-dasharray: 1, 0;"></circle></marker><marker id="blog-mermaid-_R_5r5lfiv5ulb_-1_flowchart-v2-circleEnd-margin" viewBox="0 0 10 10" refY="5" refX="12.25" markerUnits="userSpaceOnUse" markerWidth="14" markerHeight="14" orient="auto"><circle cx="5" cy="5" r="5" style="stroke-width: 0; stroke-dasharray: 1, 0;"></circle></marker><marker id="blog-mermaid-_R_5r5lfiv5ulb_-1_flowchart-v2-circleStart-margin" viewBox="0 0 10 10" refX="-2" refY="5" markerUnits="userSpaceOnUse" markerWidth="14" markerHeight="14" orient="auto"><circle cx="5" cy="5" r="5" style="stroke-width: 0; stroke-dasharray: 1, 0;"></circle></marker><marker id="blog-mermaid-_R_5r5lfiv5ulb_-1_flowchart-v2-crossEnd" viewBox="0 0 11 11" refX="12" refY="5.2" markerUnits="userSpaceOnUse" markerWidth="11" markerHeight="11" orient="auto"><path d="M 1,1 l 9,9 M 10,1 l -9,9" style="stroke-width: 2; stroke-dasharray: 1, 0;"></path></marker><marker id="blog-mermaid-_R_5r5lfiv5ulb_-1_flowchart-v2-crossStart" viewBox="0 0 11 11" refX="-1" refY="5.2" markerUnits="userSpaceOnUse" markerWidth="11" markerHeight="11" orient="auto"><path d="M 1,1 l 9,9 M 10,1 l -9,9" style="stroke-width: 2; stroke-dasharray: 1, 0;"></path></marker><marker id="blog-mermaid-_R_5r5lfiv5ulb_-1_flowchart-v2-crossEnd-margin" viewBox="0 0 15 15" refX="17.7" refY="7.5" markerUnits="userSpaceOnUse" markerWidth="12" markerHeight="12" orient="auto"><path d="M 1,1 L 14,14 M 1,14 L 14,1" style="stroke-width: 2.5;"></path></marker><marker id="blog-mermaid-_R_5r5lfiv5ulb_-1_flowchart-v2-crossStart-margin" viewBox="0 0 15 15" refX="-3.5" refY="7.5" markerUnits="userSpaceOnUse" markerWidth="12" markerHeight="12" orient="auto"><path d="M 1,1 L 14,14 M 1,14 L 14,1" style="stroke-width: 2.5; stroke-dasharray: 1, 0;"></path></marker><g><g></g><g><path d="M138,86L138,90.167C138,94.333,138,102.667,138,110.333C138,118,138,125,138,128.5L138,132" id="blog-mermaid-_R_5r5lfiv5ulb_-1-L_A_B_0" style=";" data-edge="true" data-et="edge" data-id="L_A_B_0" data-points="W3sieCI6MTM4LCJ5Ijo4Nn0seyJ4IjoxMzgsInkiOjExMX0seyJ4IjoxMzgsInkiOjEzNn1d" data-look="classic" marker-end="url(#blog-mermaid-_R_5r5lfiv5ulb_-1_flowchart-v2-pointEnd)" fill="none" stroke="currentColor"></path><path d="M138,214L138,218.167C138,222.333,138,230.667,138,238.333C138,246,138,253,138,256.5L138,260" id="blog-mermaid-_R_5r5lfiv5ulb_-1-L_B_C_0" style=";" data-edge="true" data-et="edge" data-id="L_B_C_0" data-points="W3sieCI6MTM4LCJ5IjoyMTR9LHsieCI6MTM4LCJ5IjoyMzl9LHsieCI6MTM4LCJ5IjoyNjR9XQ==" data-look="classic" marker-end="url(#blog-mermaid-_R_5r5lfiv5ulb_-1_flowchart-v2-pointEnd)" fill="none" stroke="currentColor"></path><path d="M138,342L138,346.167C138,350.333,138,358.667,138,366.333C138,374,138,381,138,384.5L138,388" id="blog-mermaid-_R_5r5lfiv5ulb_-1-L_C_D_0" style=";" data-edge="true" data-et="edge" data-id="L_C_D_0" data-points="W3sieCI6MTM4LCJ5IjozNDJ9LHsieCI6MTM4LCJ5IjozNjd9LHsieCI6MTM4LCJ5IjozOTJ9XQ==" data-look="classic" marker-end="url(#blog-mermaid-_R_5r5lfiv5ulb_-1_flowchart-v2-pointEnd)" fill="none" stroke="currentColor"></path><path d="M138,494L138,498.167C138,502.333,138,510.667,138,518.333C138,526,138,533,138,536.5L138,540" id="blog-mermaid-_R_5r5lfiv5ulb_-1-L_D_E_0" style=";" data-edge="true" data-et="edge" data-id="L_D_E_0" data-points="W3sieCI6MTM4LCJ5Ijo0OTR9LHsieCI6MTM4LCJ5Ijo1MTl9LHsieCI6MTM4LCJ5Ijo1NDR9XQ==" data-look="classic" marker-end="url(#blog-mermaid-_R_5r5lfiv5ulb_-1_flowchart-v2-pointEnd)" fill="none" stroke="currentColor"></path><path d="M138,646L138,650.167C138,654.333,138,662.667,138,670.333C138,678,138,685,138,688.5L138,692" id="blog-mermaid-_R_5r5lfiv5ulb_-1-L_E_F_0" style=";" data-edge="true" data-et="edge" data-id="L_E_F_0" data-points="W3sieCI6MTM4LCJ5Ijo2NDZ9LHsieCI6MTM4LCJ5Ijo2NzF9LHsieCI6MTM4LCJ5Ijo2OTZ9XQ==" data-look="classic" marker-end="url(#blog-mermaid-_R_5r5lfiv5ulb_-1_flowchart-v2-pointEnd)" fill="none" stroke="currentColor"></path><path d="M138,774L138,778.167C138,782.333,138,790.667,138,798.333C138,806,138,813,138,816.5L138,820" id="blog-mermaid-_R_5r5lfiv5ulb_-1-L_F_G_0" style=";" data-edge="true" data-et="edge" data-id="L_F_G_0" data-points="W3sieCI6MTM4LCJ5Ijo3NzR9LHsieCI6MTM4LCJ5Ijo3OTl9LHsieCI6MTM4LCJ5Ijo4MjR9XQ==" data-look="classic" marker-end="url(#blog-mermaid-_R_5r5lfiv5ulb_-1_flowchart-v2-pointEnd)" fill="none" stroke="currentColor"></path><path d="M138,902L138,906.167C138,910.333,138,918.667,138,926.333C138,934,138,941,138,944.5L138,948" id="blog-mermaid-_R_5r5lfiv5ulb_-1-L_G_H_0" style=";" data-edge="true" data-et="edge" data-id="L_G_H_0" data-points="W3sieCI6MTM4LCJ5Ijo5MDJ9LHsieCI6MTM4LCJ5Ijo5Mjd9LHsieCI6MTM4LCJ5Ijo5NTJ9XQ==" data-look="classic" marker-end="url(#blog-mermaid-_R_5r5lfiv5ulb_-1_flowchart-v2-pointEnd)" fill="none" stroke="currentColor"></path></g><g><g><g data-id="L_A_B_0" transform="translate(0, 0)"></g></g><g><rect style="stroke: none" fill="none"></rect></g><g><g data-id="L_B_C_0" transform="translate(0, 0)"></g></g><g><rect style="stroke: none" fill="none"></rect></g><g><g data-id="L_C_D_0" transform="translate(0, 0)"></g></g><g><rect style="stroke: none" fill="none"></rect></g><g><g data-id="L_D_E_0" transform="translate(0, 0)"></g></g><g><rect style="stroke: none" fill="none"></rect></g><g><g data-id="L_E_F_0" transform="translate(0, 0)"></g></g><g><rect style="stroke: none" fill="none"></rect></g><g><g data-id="L_F_G_0" transform="translate(0, 0)"></g></g><g><rect style="stroke: none" fill="none"></rect></g><g><g data-id="L_G_H_0" transform="translate(0, 0)"></g></g><g><rect style="stroke: none" fill="none"></rect></g></g><g><g id="blog-mermaid-_R_5r5lfiv5ulb_-1-flowchart-A-0" data-look="classic" transform="translate(138, 47)"><rect style="" x="-130" y="-39" width="260" height="78" fill="none" stroke="currentColor"></rect><g style="" transform="translate(-100, -24)"><rect></rect><foreignObject width="200" height="48"><p>Technogise travel admin (myBiz corporate portal)</p></foreignObject></g></g><g id="blog-mermaid-_R_5r5lfiv5ulb_-1-flowchart-B-1" data-look="classic" transform="translate(138, 175)"><rect style="" x="-130" y="-39" width="260" height="78" fill="none" stroke="currentColor"></rect><g style="" transform="translate(-100, -24)"><rect></rect><foreignObject width="200" height="48"><p>MakeMyTrip OTA layer (availability check, pricing)</p></foreignObject></g></g><g id="blog-mermaid-_R_5r5lfiv5ulb_-1-flowchart-C-2" data-look="classic" transform="translate(138, 303)"><rect style="" x="-130" y="-39" width="260" height="78" fill="none" stroke="currentColor"></rect><g style="" transform="translate(-100, -24)"><rect></rect><foreignObject width="200" height="48"><p>Amadeus GDS (seat inventory, PNR creation)</p></foreignObject></g></g><g id="blog-mermaid-_R_5r5lfiv5ulb_-1-flowchart-D-3" data-look="classic" transform="translate(138, 443)"><rect style="" x="-130" y="-51" width="260" height="102" fill="none" stroke="currentColor"></rect><g style="" transform="translate(-100, -36)"><rect></rect><foreignObject width="200" height="72"><p>Air India Altéa PSS (segment confirmation, HK status)</p></foreignObject></g></g><g id="blog-mermaid-_R_5r5lfiv5ulb_-1-flowchart-E-4" data-look="classic" transform="translate(138, 595)"><rect style="" x="-130" y="-51" width="260" height="102" fill="none" stroke="currentColor"></rect><g style="" transform="translate(-100, -36)"><rect></rect><foreignObject width="200" height="72"><p>IATA BSP (Billing Settlement Plan): payment routing</p></foreignObject></g></g><g id="blog-mermaid-_R_5r5lfiv5ulb_-1-flowchart-F-5" data-look="classic" transform="translate(138, 735)"><rect style="" x="-130" y="-39" width="260" height="78" fill="none" stroke="currentColor"></rect><g style="" transform="translate(-100, -24)"><rect></rect><foreignObject width="200" height="48"><p>E-ticket issued under Air India numeric code 098</p></foreignObject></g></g><g id="blog-mermaid-_R_5r5lfiv5ulb_-1-flowchart-G-6" data-look="classic" transform="translate(138, 863)"><rect style="" x="-130" y="-39" width="260" height="78" fill="none" stroke="currentColor"></rect><g style="" transform="translate(-100, -24)"><rect></rect><foreignObject width="200" height="48"><p>PNR DDTCIV created, stored in Amadeus</p></foreignObject></g></g><g id="blog-mermaid-_R_5r5lfiv5ulb_-1-flowchart-H-7" data-look="classic" transform="translate(138, 991)"><rect style="" x="-130" y="-39" width="260" height="78" fill="none" stroke="currentColor"></rect><g style="" transform="translate(-100, -24)"><rect></rect><foreignObject width="200" height="48"><p>Confirmation email → myBiz → Technogise → me</p></foreignObject></g></g></g></g></g><defs></defs><defs></defs></svg>

Each arrow is a system boundary. Each boundary has its own protocol, its own failure mode, and its own eventual consistency characteristics. The 30-second booking conceals a chain of synchronous and asynchronous calls across systems built in different decades by different companies in different countries.每个箭头都是一个系统边界。每个边界都有自己的协议、失败模式以及最终的一致性特征。30秒的预约隐藏了一条跨不同年代由不同国家不同公司构建的同步和异步通话链。

The PNR at the end of that chain (six characters, DDTCIV) is the thread that holds it all together.链条末尾的PNR（六个字符，DDTCIV）是连接这一切的线索。

In the next part, I will decode exactly what those six characters are, what they contain, and why the fare calculation line on my e-ticket is one of the most information-dense strings in commercial aviation.在下一部分，我将详细解析这六个字符是什么，包含什么，以及为什么我的电子机票上的票价计算行是商业航空中信息量最密集的字符串之一。

---

## Takeaways 要点

**A narrow, well-tested design maintained by people who understand it deeply can be the hardest thing to displace for the workload it was built for.** TPF is not modern. It would fail most architectural reviews a contemporary engineering team would apply. What it has is a transaction model built for inventory and settlement, decades of operational tuning, and peak loads on the order of 50,000 TPS with end-to-end latency around 100 milliseconds. The numbers are a consequence of fit between design and workload, not a general property of mainframes.**一个狭义且经过充分测试、由深刻理解它的人维护的设计，可能是其设计时最难取代的，因为它是为其设计而设计的负荷。** TPF不是现代的。大多数现代工程团队都会申请的建筑评审，这会失败。它拥有的是为库存和结算打造的交易模型，经过数十年的运营调优，以及约5万TPS的峰值负载，端到端延迟约为100毫秒。这些数字是设计和工作负载配合的结果，而非大型机的普遍特性。

**Similar stacks in one industry usually reflect shared constraints, not independent convergence.** The GDS world is not a clean story of unrelated companies discovering the same solution. Regulated-era economics, interlining, IATA messaging practice, and network effects pushed carriers toward interoperable shapes. Several majors bet on TPF for the core transaction engine; Amadeus bet elsewhere yet still speaks the same lineage of PNRs, fares, and cryptic at the edge. Asking what standards and settlement rules made divergence expensive is usually more productive than asking why engineers made similar choices.**同一行业内类似的堆栈通常反映的是共享的约束，而非独立的融合。** GDS的世界并非一个无关公司发现相同解决方案的简单故事。监管时代的经济学、联运、IATA消息传递实践和网络效应推动了运营商走向互操作型态。几家大公司押注TPF作为核心交易引擎;阿玛迪斯在别处下注，但仍然沿用PNR、票价和边缘隐晦的传承。询问哪些标准和结算规则使发散变得昂贵，通常比问工程师为何做出类似选择更有成效。

**PSS migrations are years-long undertakings with visible scar tissue.** Air India's move to Amadeus Altéa in 2023 involved decades of booking history, interline agreements, loyalty programme integrations, and airport systems dependencies. The operational impact lasted months past go-live. Scale and data age are the variables that make airline migrations different from typical enterprise software replacements.**PSS迁移是持续多年的过程，瘢痕组织可见。** 印度航空于2023年迁至阿玛迪斯阿尔特亚机场，涉及数十年的预订历史、联运协议、忠诚度计划整合以及机场系统的依赖。运营影响持续了数月，超过了上线时间。规模和数据时代是使航空公司迁移区别于典型企业软件替代的因素。

---

*Next: Part 2: Six Characters. What DDTCIV actually is, what it contains, and why it is less unique than you think.下一篇：第二部分：六个角色。DDTCIV到底是什么，包含了什么，以及为什么它没有你想象的那么独特。*

*The Iron Core is a six-part series by Ajitem Sahasrabuddhe. Ajitem is a software engineer at [Technogise](https://technogise.com/) and spoke at ContainerDays 2026 in London.《铁核》是阿吉特姆·萨哈斯拉布德创作的六部分系列剧。Ajitem是 [Technogise](https://technogise.com/) 的软件工程师，曾在2026年伦敦ContainerDays活动上发表演讲。*

## Series contents 系列内容

01

The Problem That Built an Industry 孕育产业的问题

Current 现状

[02

Six Characters 六个角色

Read 阅读

](https://ajitem.com/blog/iron-core-part-2-six-characters/)[03

The Command Line That Never Died 永不消逝的命令行

Read 阅读

](https://ajitem.com/blog/iron-core-part-3-the-command-line-that-never-died/)[04

From GDS to Gate 从GDS到Gate

Read 阅读

](https://ajitem.com/blog/iron-core-part-4-from-gds-to-gate/)[05

Bird Strike, Terminal 2 鸟击，2号航站楼

Read 阅读

](https://ajitem.com/blog/iron-core-part-5-bird-strike-terminal-2/)[06

The Revolution That's Taking Forever

Read

](https://ajitem.com/blog/iron-core-part-6-the-revolution-thats-taking-forever/)