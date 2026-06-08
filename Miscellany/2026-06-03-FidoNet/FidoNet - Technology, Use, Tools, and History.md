---
title: "FidoNet: Technology, Use, Tools, and History"
source: https://www.fidonet.org/inet92_Randy_Bush.txt
author:
published:
created: 2026-06-03
description:
tags:
  - ToRead
  - networking
  - history
  - retro-computing
  - ham-radio
---
```
FidoNet: Technology, Use, Tools, and History

   Randy Bush
     randy@psg.com

Copyright 1992-3, Randy Bush.  All rights reserved.
      FidoNet is a trademark of Tom Jennings.
```

Abstract 摘要

FidoNet is a point-to-point and store-and-forward email WAN which uses modems on the direct-dial telephone network. It was developed in 1984, and has over 20,000 public nodes worldwide. Although originally based on MS-DOS hosts, it has been ported to environments ranging from UNIX to the Apple //. There are gateways from FidoNet to the Internet, usually via the uucp network.FidoNet是一种点对点、存储转发型的电子邮件广域网，在直拨电话网络中使用调制解调器。它于1984年开发完成，在全球拥有超过2万个公共节点。尽管最初基于MS-DOS主机系统，如今已被移植到从UNIX到Apple //等各类环境中。FidoNet通常通过uucp网络建立了通往互联网的网关。

Technical Overview 技术概述

The public FidoNet consists of over 20,000 nodes which move email and enews over the public telephone network using a unique protocol and data format. As the initial implementations were written for MS-DOS, DOS-based hosts are still the vast majority of the network. But semi-formal specifications for the data formats and protocols have facilitated implementations for UNIX, Apples from the // to the Macintosh, CP/M, MVS, the Tandy CoCo, and many other platforms.公共的菲多网络拥有超过2万个节点，这些节点通过独特的协议和数据格式在公共电话网络上传输电子邮件和新闻。由于最初的实现是为MS-DOS系统编写的，基于DOS的主机仍是该网络的绝大多数。但针对数据格式和协议的半正式规范，推动了UNIX、从Apple Ⅱ到麦金塔的苹果设备、CP/M、MVS、坦迪CoCo以及众多其他平台的实现版本开发。

As FidoNet is almost entirely financed by private individuals, minimization of modem/telephone time has been the principal driving force behind any design of the data transfer protocols. The original implementations used an inefficient xmodem-based transport, a non-windowed ACK/NAK protocol with 128 byte packets. Although rarely used in practice, this protocol remains the minimal basic standard implementation today as it is trivial to code. Almost all current implementations offer an optional suite of quite efficient zmodem-based streaming transport protocols which are ACK-less, only NAKing in case of error. It is interesting to contrast this push for efficiency with uucp's profligate G protocol and the Internet's SMTP and NNTP protocols.由于FidoNet几乎完全由个人出资支持，最大限度减少调制解调器/电话使用时间一直是数据传输协议各类设计的核心驱动力。最初的实现采用了效率低下的基于Xmodem的传输方式，这是一种不使用窗口机制、包含128字节数据包的确认/否定确认协议。尽管在实际应用中极少使用，但该协议如今仍是最基础的标准实现，因为其编码工作十分简单。目前几乎所有实现都提供了一套可选的、效率极高的基于Zmodem的流式传输协议，这类协议无需确认，仅在出现错误时才发送否定确认。将这种对效率的追求与Uucp的冗余G协议以及互联网的SMTP、NNTP协议进行对比，是一件很有意思的事。

Addressing within FidoNet is numeric with a bit of punctuation, and specifies a particular node in the administrative hierarchy. Addresses are of the form zone:net/node where zone is one of the six continents (North America, Europe, Oceania, Asia, or Africa), net is the city (or larger area if the node density is sparse), and node is the particular host within the local network. For example, 1:105/6 is host number six within the Portland Oregon US local network (net 105) which is in North America ( zone 1). The addressing scheme may be extended to accommodate points which are power users who reduce their connect time by using private (i.e. unlisted) nodes to exchange email and enews with public nodes. Thus the extended addressing scheme is zone:net/node.point, e.g., 1:105/6.42.FidoNet 网络中的寻址采用数字形式并辅以少量标点符号，用于指定管理层级中的特定节点。地址格式为\*\*区域:网络/节点\*\*，其中区域对应六大洲之一（北美洲、欧洲、大洋洲、亚洲或非洲），网络代表城市（若节点密度较低则指代更大区域），节点则是本地网络中的特定主机。例如，1:105/6 指的是美国俄勒冈州波特兰本地网络（网络 105，隶属于区域 1，即北美洲）中的 6 号主机。 该寻址方案可进一步扩展，以适配核心用户群体——这类用户会使用私有节点（即未公开节点）与公共节点交换电子邮件和电子新闻，从而缩短连接时间。因此，扩展后的地址格式为\*\*区域:网络/节点.点\*\*，例如 1:105/6.42。

A list of all nodes in the public FidoNet network is automatically updated and distributed weekly. This list contains the actual data telephone number of each host, as well as the geographic location and name of the system operator (sysop). Every city's local network maintains its local data and sends those data to a regional coordinator who, in turn, sends the region's aggregated data to a continental coordinator. The continental coordinators exchange their data, and create a list of the differences between the current week's data and that of the previous week. This \`nodediff' is then distributed back down the hierarchy all the way to each individual node in the network.公共 FidoNet 网络中所有节点的列表每周会自动更新并分发。该列表包含每个主机的实际电话号码，以及系统操作员（系统管理员）的地理位置和姓名。每个城市的本地网络会保存本地数据，并将这些数据发送给区域协调员，区域协调员再将该区域汇总后的数据发送给大陆协调员。大陆协调员交换各自的数据，生成本周数据与上周数据之间的差异列表。这个“节点差异”文件随后会沿着层级结构向下分发，直至网络中的每个节点。

As all modem phone numbers are published in the nodelist, point-to-point transfers are always possible. But, as store-and-forward capabilities are specified in the basic standards, email tends to be routed through a world-wide hierarchic topology and enews via a world-wide ad hoc, but generally geographically hierarchic, acyclic graph.由于所有现代电话号码都发布在节点列表中，因此点对点传输始终可行。但由于基本标准中规定了存储转发功能，电子邮件通常会通过全球层级拓扑结构进行路由，而新闻则通过全球临时网络传输——不过这种临时网络通常在地理上呈现层级特征，且属于无环图结构。

Topology 拓扑结构

FidoNet's addressing hierarchy - zone, net, node, point - approximates the route which email follows.FidoNet的寻址层级——区域、网络、节点、点——与电子邮件所遵循的路径大致相符。

Power users run points which may connect to only their respective host nodes to receive and deliver their email and enews. As they are not in the public nodelist, points are not considered to be official nodes in the network, and thus are not subject to constraints of technology, national mail hour, etc.高级用户运行的节点仅连接至各自的主机节点，用于接收和发送电子邮件及电子新闻。由于这些节点不在公共节点列表中，因此不被视为网络中的官方节点，从而不受技术、全国邮件时限等限制的约束。

Within a local network (i.e. city), nodes usually exchange email directly with each other. For example, 1:105/6 exchanges mail directly with all other nodes in 1:105/\*. In those cities where phone tariff zones divide the city, local hubs are used to concentrate intra-city traffic to reduce costs.在本地网络（即同一城市）内，节点之间通常直接相互交换电子邮件。例如，1:105/6 会与 1:105/\* 中的所有其他节点直接交换邮件。在那些按电话资费区划分城市的地区，会使用本地集线器集中市内流量以降低成本。

Each local network has one node with an alias of node 0 (i.e. zone:net/0) which is known as the "inbound host." By default, all mail from outside the local net is delivered to the inbound host to be distributed within the local network. Thus, a node in New York may deliver all mail to San Francisco with a single telephone call, as opposed to a call for every SF node for which it has mail. While each node is responsible for sending its own mail (as FidoNet is financed from the pockets of individuals), some local networks cooperate sufficiently to provide an "outbound host" to concentrate all mail destined for outside the city.每个本地网络都有一个别名为节点 0（即区域：网络/0）的节点，被称为“入站主机”。默认情况下，来自本地网络外部的所有邮件都会被投递到入站主机，再由其在本地网络内分发。因此，纽约的一个节点只需打一次电话，就能将所有邮件投递到旧金山，而无需为每一个需要接收邮件的旧金山节点都单独打电话。尽管每个节点都需要自行发送自己的邮件（因为 FidoNet 由个人自费运营），但一些本地网络会充分协作，指定一个“出站主机”来集中处理所有发往本市之外的邮件。

Each of the six zones (continents) has a unique host which provides inter-zone email routing. These "zonegates" have alias addresses of the form orig-zone:orig-zone/dest-zone. For example, the gate from North America (zone 1) to Oceania (zone 3) has an addressing alias of the form 1:1/3. Hence, a node in North America may save the cost of an inter-continental call to Australia by sending the message to 1:1/3, which will in turn send it to 3:3/1, which will see that it is delivered within Australia.六个区域（大洲）各有一个唯一的主机，负责区域间的电子邮件路由。这些“区域网关”拥有格式为\*\*原始区域:原始区域/目标区域\*\*的别名地址。例如，从北美（区域1）到大洋洲（区域3）的网关，其地址别名格式为1:1/3。因此，北美地区的节点若将消息发送至1:1/3，就能节省拨打澳大利亚洲际电话的成本；该网关会进一步将消息转发至3:3/1，而这个网关会完成消息在澳大利亚境内的投递。

Since November, 1991, an experimental system has been using the Internet to transport mail and enews between Europe and North America. The data are moved directly between the zonegates via IP (i.e. not gated between data formats) courtesy of RIPE and EUnet. This saves FidoNet operators thousands of dollars a month. Since late in 1992, this tunneling of the Internet has been extended to Taiwan, Southern Africa, Chile, and other areas. This is done with the explicit consent of the IP carriers involved, to whom FidoNet owes a considerable debt of gratitude.自1991年11月起，一套实验系统开始通过互联网在欧洲和北美之间传输邮件和电子新闻。得益于RIPE和EUnet的支持，数据通过IP协议直接在区域网关间传输（即无需在不同数据格式间进行网关转换）。这为FidoNet运营者每月节省了数千美元的成本。自1992年末起，这种互联网隧道技术已延伸至中国台湾、南非南部、智利及其他地区。此举是在相关IP运营商的明确同意下开展的，FidoNet对这些运营商深表感激。

Gateways to the Other Networks 通往其他网络的网关

There are gateways between FidoNet and the uucp network, and thereby the Internet. FidoNet is addressable from the Internet DNS universe via the DNS zone fidonet.org. A FidoNet node e.g. 1:105/42 has the domainized name f6.n105.z1.fidonet.org. Gating is done almost exclusively via the uucp network. The MX forwarders for the fidonet.org zone are set up such that there is default forwarding for all FidoNet hosts should there be no gateway which is local to the target host.FidoNet 与 uucp 网络之间存在网关，进而连接到互联网。通过互联网域名系统（DNS）的 fidonet.org 区域，可从 DNS 体系中访问 FidoNet。例如，FidoNet 节点 1:105/42 拥有域名化名称 f6.n105.z1.fidonet.org。网关几乎完全通过 uucp 网络实现。fidonet.org 区域的 MX 转发器设置为：若目标主机无本地网关，则所有 FidoNet 主机均默认进行转发。

The correct RFC822 address for a FidoNet power user at point zo:ne/no.po is [user@Ppo.Fno.Nne.Zzo.FIDONET.ORG](mailto:user@Ppo.Fno.Nne.Zzo.FIDONET.ORG). For example, FidoNet 高级用户在 zo:ne/no.pois 节点的正确 RFC822 地址为 [user@Ppo.Fno.Nne.Zzo.FIDONET.ORG](mailto:user@Ppo.Fno.Nne.Zzo.FIDONET.ORG) 。例如，

```
randy.bush@p0.f42.n105.z1.fidonet.org
```

And, as points are optional in FidoNet, Jane User at the BBS user at node zone:net/node is [user@Fnode.Nnet.Zzone.FIDONET.ORG](mailto:user@Fnode.Nnet.Zzone.FIDONET.ORG). For example, 而且，由于在 FidoNet 中地址是可选的，节点区:网络/节点上的公告板系统用户 Jane User 的地址为 [user@Fnode.Nnet.Zzone.FIDONET.ORG](mailto:user@Fnode.Nnet.Zzone.FIDONET.ORG) 。例如，

```
lisa.gronke@f6.n105.z1.fidonet.org
```

The UFGATE package, which allows an MS-DOS-based FidoNet node to simulate a uucp host, gates both email and enews. This package made gating fairly popular by 1987. More recently, other DOS packages have provided similar features. RFmail, a complete FidoNet implementation which runs on UNIX SysV and Xenix, includes gateware to transform between FidoNet message format and that of the uucp/Internet.UFGATE 软件包可让基于 MS-DOS 的 FidoNet 节点模拟 uucp 主机，同时实现邮件与电子新闻的网关功能。到 1987 年，这款软件包让网关功能变得相当普及。近年来，其他 DOS 软件包也提供了类似功能。RFmail 是可在 UNIX SysV 和 Xenix 系统上运行的完整 FidoNet 实现方案，其内置的网关软件可实现 FidoNet 消息格式与 uucp/互联网消息格式之间的转换。

Currently there are on the order of one hundred gateway systems, most of them in North America. Aside from the expected inter-network email, there is considerable gating of Usenet news to and from FidoNet echomail conferences.目前大约有一百个网关系统，其中大部分位于北美。除了预期的网络间电子邮件外，Usenet 新闻与 FidoNet 电子函件会议之间也存在大量的信息转接。

A number of newsgroups are shared globally by FidoNet and the Usenet, e.g. FidoNet's MODULA-2 echomail conference is Usenet's comp.lang.modula2 and FidoNet's K12Net conferences are the Usenet's k12.\* hierarchy. Usenet newsgroups are also made available on a purely local basis in many cities as FidoNet echomail.FidoNet 和 Usenet 全球共享多个新闻组，例如 FidoNet 的 MODULA-2 电子回声会议对应 Usenet 的 comp.lang.modula2，FidoNet 的 K12Net 会议对应 Usenet 的 k12.\* 层级结构。在许多城市，Usenet 新闻组也会以 FidoNet 电子回声的形式仅在本地提供。

Internetwork gateways have been used extensively by non-governmental organizations (NGOs) in Africa, as well as by an ingenious transport between the South African academic IP network (UNINET-ZA) and the Internet \[Guillarmod 92\].非洲的非政府组织（NGOs）已广泛使用网间网关，南非学术知识产权网络（UNINET-ZA）与互联网之间也通过一种巧妙的传输方式实现了互联\[Guillarmod 92\]。

Users 用户

The public FidoNet has approximately 20,000 nodes worldwide. Although FidoNet started in North America, by 1985 there were systems in Europe, very soon followed by systems on the other continents. Currently, about 59% of the publicly listed nodes are in North America, 30% in Europe, 4% in Australia and New Zealand, and 7% in Asia, Latin America, and Africa.公共 FidoNet 全球约有 20,000 个节点。尽管 FidoNet 起源于北美，但到 1985 年，欧洲已出现相关系统，其他大陆的系统也很快相继建立。目前，公开列出的节点中约 59% 位于北美，30% 在欧洲，4% 在澳大利亚和新西兰，7% 分布在亚洲、拉丁美洲和非洲。

FidoNet technology is also used privately within large corporations, public institutions, and NGOs. While the scale of the private use of FidoNet is not known, it is estimated to be at least as large as the public network. It is known to be used in companies such as AT&T, Georgia Pacific, and the Canadian Post Office, among others. It is heavily used by NGOs in Africa.FidoNet 技术也被大型企业、公共机构和非政府组织私下使用。虽然 FidoNet 私人使用的规模尚不明确，但据估计，其规模至少与公共网络相当。据悉，美国电话电报公司、佐治亚-太平洋公司、加拿大邮局等企业均在使用该技术。非洲的非政府组织也大量使用 FidoNet 技术。

While hobbyists and public BBSs predominate the North American FidoNet, perhaps half of the public systems in Europe are subsidized by small to medium-scale businesses. In Africa, there is very serious use by NGOs and poorly-funded academic institutions. Within North America, there is growing use within the school systems thanks to the spreading K12Net \[Murray 92\].在北美，爱好者和公共电子布告栏系统主导着菲多网，而欧洲大约一半的公共系统由中小型企业提供补贴。在非洲，非政府组织和资金匮乏的学术机构对其使用非常普遍。在北美内部，随着K12Net网络的普及，学校系统中的使用也在不断增加\[Murray 92\]。

While the original FidoNet systems were fully integrated within bulletin board systems, FidoNet "mail-only" systems are now a noticeable portion of the public network. These provide the owner a facility similar to ham radio or a fax machine, but provide no public access via dial-up.虽然最初的 FidoNet 系统完全集成在电子公告板系统中，但如今 FidoNet 的“纯邮件”系统已成为公共网络中相当显眼的一部分。这类系统为使用者提供了类似业余无线电或传真机的功能，但不支持通过拨号方式进行公共访问。

Around the world, BBSs with FidoNet capability provide the most publicly accessible and lowest-cost email and enews service today. While most BBSs are only usable by a single dial-up caller at a time, others run multi-line systems ranging from two to 20 lines. Public access requirements vary from formal user validation and possibly a small fee to completely open facilities allowing full use by the first-time caller.在全球范围内，具备 FidoNet 功能的电子公告板系统（BBS）如今提供着最易公开访问且成本最低的电子邮件和电子新闻服务。虽然大多数电子公告板系统（BBS）一次仅能供一位拨号呼叫者使用，但也有一些系统运行着多线路设备，线路数量从两条到二十条不等。公开访问的要求各不相同，从需要正式的用户验证并可能收取少量费用，到完全开放的设施允许首次呼叫者全面使用。

Although no formal measurements have been made, it has been estimated that the average FidoNet BBS has over 200 active users, half of whom use enews and 5% use private email. As not all FidoNet nodes have BBS access, we can estimate that on the order of 2,000,000 FidoNet users read or write enews, and on the order of 200,000 of these use private email.尽管尚未进行正式测量，但据估计，平均每个 FidoNet 电子布告栏系统（BBS）拥有超过 200 名活跃用户，其中一半用户使用电子新闻（enews），5% 使用私人电子邮件。由于并非所有 FidoNet 节点都能访问电子布告栏系统（BBS），我们可以估算约有 200 万 FidoNet 用户阅读或撰写电子新闻（enews），其中约 20 万人使用私人电子邮件。

History 历史

In 1984, Tom Jennings wished to move messages from his MS-DOS-based Fido BBS to that of a friend, John Madil. As Jennings was the author of the Fido BBS, he was able to quickly modify it to extract messages from a specially- designated local message base and queue them for sending to the remote BBS. As US telephone rates are much lower in the middle of the night, he wrote a separate external program to run this email transfer for one designated hour to exchange mail with the other node.1984年，汤姆·詹宁斯希望将信息从他基于MS-DOS的Fido BBS转移到朋友约翰·马迪尔的Fido BBS。由于詹宁斯是Fido BBS的开发者，他得以快速对其进行修改，从指定的本地消息库中提取信息，并将这些信息排队等待发送到远程BBS。鉴于美国的电话费率在午夜时分要低得多，他编写了一个独立的外部程序，在指定的一小时内执行这种邮件传输，以与另一个节点交换邮件。

This soon grew to more nodes, reaching 200 by early in 1985. The nodelist, a list of all known active nodes in the public FidoNet, was developed as a distributed external file and was initially maintained by Jennings. The reserved mail transfer hour became enshrined as "national mail hour," and is preserved today despite current technology being capable of intermixing mail transfer and BBS access.这一数字很快增长到更多节点，到1985年初已达到200个。节点列表，即公共FidoNet中所有已知活跃节点的清单，被开发为分布式外部文件，最初由詹宁斯维护。预留的邮件传输时间被确立为“全国邮件时间”，尽管当前技术已能将邮件传输与电子布告栏系统访问结合起来，这一规定至今仍被保留。

With the porting of FidoNet to the DEC Rainbow, FidoNet BBSs became quite popular with the DEC Users Group in St. Louis Missouri. Ken Kaplan and Ben Baker were particularly active, and started the first FidoNet newsletter. As the nodelist approached 100 members, Kaplan and Baker took over from Jennings its organization and maintenance.随着 FidoNet 移植到 DEC Rainbow 电脑上，FidoNet 电子布告栏系统（BBS）在密苏里州圣路易斯的 DEC 用户群中变得相当受欢迎。肯·卡普兰（Ken Kaplan）和本·贝克（Ben Baker）尤为活跃，他们创办了第一份 FidoNet 通讯。当节点列表成员数接近 100 时，卡普兰和贝克从詹宁斯手中接管了该系统的组织与维护工作。

As the nodelist passed the 200 mark, it became obvious that, for example, San Francisco had much daily traffic for St. Louis and vice versa, and dozens of telephone calls were being placed to all the various nodes in each city. As calls within a city of the US are generally free, but calls between cities are not, it seemed obvious to concentrate the intercity traffic into one call per night. Therefore, what had been a simple linear nodelist was broken into a structure of city segments transforming the FidoNet address notation from node to net/node.当节点列表突破200个节点时，情况变得很明显，比如旧金山到圣路易斯的每日通话量很大，反之亦然，而且每个城市的各个节点之间都有数十通电话在拨打。由于美国境内的市内通话通常免费，而跨市通话则不然，因此显然应该将跨市通话集中为每晚一通。于是，原本简单的线性节点列表被拆分为城市分段结构，FidoNet的地址表示法也从“节点”形式转变为“网络/节点”形式。

In late 1986, it became obvious that an analogous problem existed between the continents. At the same time, the idea emerged of power users, or points, who could use FidoNet data formats and transport protocols (as opposed to BBS interfaces) to send and receive their mail and enews. So, at a FidoNet Standards Committee meeting in October 1986, the nodelist was redesigned as a four level hierarchy of zone (continent), net, node, and point, with the address becoming zone:net/node.point, as it remains today.1986年末，各大洲之间存在类似问题这一事实变得显而易见。与此同时，一种针对高级用户（或称点位）的构想应运而生，这些用户可以借助FidoNet的数据格式和传输协议（而非BBS接口）收发邮件与电子新闻。因此，在1986年10月的FidoNet标准委员会会议上，节点列表被重新设计为包含区域（对应大洲）、网络、节点和点位的四级层级结构，地址格式也定为区域:网络/节点.点位，这一格式沿用至今。

The rate of growth of FidoNet seems typical of electronic networks in the last decade. The approximate number of nodes at year ends is:FidoNet 的增长速度似乎是过去十年电子网络的典型水平。年末节点的大致数量如下：

Year Nodes 年份 节点数

1984 100 1985 600 1986 1400 1987 2500 1988 4000 1989 6500 1990 9000 1991 11000 1992 16000 1993 20000 (Apr '93) 1984 1001985 6001986 14001987 25001988 40001989 65001990 90001991 110001992 160001993 20000（1993年4月）

At present, the registered public FidoNet is considerably larger than BITNET and has recently passed the estimated size of the registered part of the uucp network.目前，已注册的公共 FidoNet 规模远大于 BITNET，且最近已超过了 uucp 网络已注册部分的预估规模。

In February 1986, Jeff Rush developed FidoNet's form of enews called echomail. As very few FidoNetters were familiar with the Usenet, they were quite surprised at the popularity and rate of growth of echomail. Within two weeks, an international echomail conference, MODULA-2, was propagated between Europe, Australia, and North America, and today the daily volume of compressed echomail is over eight megabytes. The social effects, both good and bad, of echomail on the network parallel those of the Usenet.1986年2月，杰夫·拉什开发出了FidoNet体系下的电子新闻形式，名为回声邮件。由于当时极少有FidoNet用户熟悉Usenet，他们对回声邮件的受欢迎程度和发展速度感到十分惊讶。短短两周内，一场名为MODULA-2的国际回声邮件会议便在欧洲、澳大利亚和北美之间传播开来，如今每日压缩后的回声邮件流量已超过8兆字节。回声邮件对网络产生的正面和负面社会影响，与Usenet的影响如出一辙。

Although primitive experiments had been conducted earlier, in 1986 gateways between FidoNet and the uucp network, and hence the Internet, became sufficiently reliable for production use.尽管此前已开展过初步实验，但1986年，FidoNet与uucp网络之间以及uucp网络与互联网之间的网关已达到生产可用的足够可靠水平。

Technical Standards 技术标准

Technical standards development began in 1986, with the publication of FSC-0001 describing the then-extant xmodem-based protocol suite and the basic data formats \[Bush 1986\]. This was shortly followed by a description of the nodelist in FSC-0002 \[Baker 87\]. A FidoNet Standards Committee (now FTSC) was formed in 1986 by the then-active software authors, chaired by a non-author. The FTSC collects and publishes documents called FSCs, which are similar to the IETF's RFCs. Those which are voted as formal standards are known as FTS documents.技术标准的制定始于1986年，FSC-0001文件的发布阐述了当时现存的基于xmodem的协议套件以及基本数据格式\[Bush 1986\]。紧随其后，FSC-0002文件对节点列表进行了说明\[Baker 87\]。1986年，当时活跃的软件开发者成立了FidoNet标准委员会（现为FTSC），由一位匿名主席领导。FTSC收集并发布名为FSCs的文件，这些文件与IETF的RFC类似。被投票认定为正式标准的文件被称为FTS文件。

There are approximately 80 FSC documents at this time and five official FTS standards. Some of the more interesting are:目前大约有80份FSC文件和五项官方FTS标准。其中一些较为有趣的内容如下：

Document Topic FTS-0001 basic data formats and protocols FTS-0004 format of echomail FTS-0005 syntax and semantics of the nodelist FTS-0006 enhanced session and transport protocols FSC-0034 control data embedded within message text 文档 主题 FTS-0001 基本数据格式与协议 FTS-0004 回声邮件格式 FTS-0005 节点列表的语法与语义 FTS-0006 增强型会话与传输协议 FSC-0034 嵌入在消息文本中的控制数据

The current document set is kept on many FidoNet nodes and is available via ftp on the internet as 当前的文档集保存在许多 FidoNet 节点上，也可通过互联网上的 ftp 访问，其地址为

```
ftp.psg.com:~/pub/fidonet/stds/*
```

FTS-0001 describes the original message data formats, session protocols, and link layer protocols for FidoNet as it was originally developed by Tom Jennings. The ability for a node to obey this standard is mandatory if it wishes to be listed within the public FidoNet, although the vast majority of connections now use the far more efficient FTS-0006 suite. Data transfer uses xmodem and a variant called TLink, 128 byte block ACK/NAK protocols, neither of which is streaming, bidirectional, or windowing, and which discriminate between email and file transfer at the session and data transfer level. Mid-file restart recovery is also absent.FTS-0001 阐述了由汤姆·詹宁斯最初开发的菲多网所采用的原始消息数据格式、会话协议以及链路层协议。若一个节点希望被列入公共菲多网名录，就必须遵守这一标准，不过如今绝大多数连接都使用效率高得多的 FTS-0006 协议套件。数据传输采用 Xmodem 协议以及名为 TLink 的变体，还有 128 字节块的确认/未确认协议；这些协议均不具备流式、双向或窗口机制，且在会话层和数据传输层对电子邮件传输与文件传输进行区分。文件传输过程中的中途恢复功能也未被纳入。

The FTS-0006 session and link layer protocols \[Becker 90\] were developed by Wynn Wagner and Vince Perriello in 1987 to overcome the serious inefficiency of FTS-0001. The default data link layer described uses zmodem, a very efficient streaming, windowing, and ACK-less (NAK only on failure) protocol designed by Chuck Forsberg. It also provides mid-file restart recovery. The YooHoo/2U2 session level protocol provides for exchange of identification and authorization data as well as allowing negotiation of the link layer protocol.FTS-0006 会话层和链路层协议\[Becker 90\]由韦恩·瓦格纳（Wynn Wagner）和文斯·佩列洛（Vince Perriello）于1987年研发，旨在解决FTS-0001协议严重的低效问题。该协议所采用的默认数据链路层采用了由查克·福斯伯格（Chuck Forsberg）设计的Zmodem协议，这是一种高效的流式传输、窗口化且无需确认（仅在故障时发送否定应答）的协议，同时支持文件传输中途重启恢复功能。YooHoo/2U2 会话层协议可实现身份识别与授权数据的交换，还能对链路层协议进行协商。

Common Software Components 通用软件组件

Like their uucp/Internet brethren, FidoNet systems tend to have different components to act as user, transfer/routing, and transport agents. While not all FidoNet implementations are composed identically, on the whole the following concepts and nomenclature are understood throughout FidoNet.与它们的 uucp/互联网同类系统一样，FidoNet 系统通常包含不同的组件，分别充当用户代理、传输/路由代理和传输代理。虽然并非所有 FidoNet 实现的组成都完全相同，但总体而言，以下概念和命名规则在整个 FidoNet 中通用。

A Bulletin Board System (BBS) is often available which provides a mail and news user agent (M/NUA) to dial-up callers of the BBS, and often provides a console interface for the system operator as well. As BBS M/NUAs must be usable by dial-up users on unspecified terminals, the interfaces tend to be line oriented with rather primitive editing facilities. Some BBS systems such as Fido and Opus provide complete software suites integrating all components necessary to use FidoNet, while most other BBSs require the addition of external components to use them with FidoNet.电子公告牌系统（BBS）通常具备一项功能，可为系统的拨号访问用户提供邮件与新闻用户代理（M/NUA），同时也往往为系统操作员提供控制台界面。由于BBS的邮件与新闻用户代理必须能供在各类未指定终端上使用的拨号用户操作，其界面多为面向行的形式，且编辑功能相当基础。部分BBS系统（如Fido和Opus）提供完整的软件套件，整合了使用FidoNet所需的所有组件；而大多数其他BBS系统则需额外添加外部组件，才能与FidoNet配合使用。

An Editor is a console M/NUA which is usually available for those nodes which do not have a BBS or where the system operator prefers a different interface. As the system console generally has known characteristics, Editor M/NUAs tend toward screen-oriented, multi-color, fancy interfaces, often with quite sophisticated editing capabilities.编辑器是一种控制台 M/NUA，通常适用于那些没有公告板系统（BBS）的节点，或者系统操作员偏好使用其他界面的节点。由于系统控制台通常具有已知的特性，编辑器 M/NUA 往往采用面向屏幕、多色彩、界面精美的设计，通常还具备相当完善的编辑功能。

A Packer or Scanner is analogous to the mail/news transfer agent (M/NTA). It transforms the data to/from the internal (i.e. not standardized) storage format from/to the external FTS-0001/4 transmission format. Packer M/NTAs also make routing decisions, usually based on data in a local routing rule file. These local routing rules tell the M/NTA what routes to use for mail within the local city network, cost-reduction routes for mail within the zone, and any special routes for inter-zone mail. The NTA portion uses an echomail rule base to decide which echomail groups are to be exchanged with which other nodes in the network.打包器或扫描器类似于邮件/新闻传输代理（M/NTA）。它将数据在内部（即非标准化）存储格式与外部 FTS-0001/4 传输格式之间进行相互转换。打包器类型的 M/NTA 还会做出路由决策，通常基于本地路由规则文件中的数据。这些本地路由规则会告知 M/NTA，本地城市网络内的邮件应采用哪些路由、区域内的邮件可采用哪些降低成本的路由，以及跨区域邮件应采用哪些特殊路由。NTA 部分则使用回声邮件规则库来确定网络中哪些回声邮件组需要与哪些其他节点进行交换。

A Mailer is the session and link level transport layer which decides when to make and accept FidoNet calls to/from other nodes, and provides everything needed to transport the email, enews, and files between FidoNet nodes. Mailers know about modems and how to control them, how to detect if an incoming call is a human BBS user as opposed to an incoming FidoNet call, how to pass humans through to a BBS, what times of day to place expensive but time-dependent calls, etc. Because the mailer provides the link level protocols, its characteristics determine inter-node compatibility; therefore a node is best known for the mailer it runs. Hence a node might be known as a Binkley node or a Fido node because it uses BinkleyTerm or Fido as its mailer.邮件器是会话层和链路层的传输层，它决定何时发起与其他节点的FidoNet呼叫以及何时接收来自其他节点的FidoNet呼叫，并提供在FidoNet节点之间传输电子邮件、电子新闻和文件所需的所有功能。邮件器可识别调制解调器及其控制方法，能区分来电是人工BBS用户呼叫还是FidoNet自动呼叫，可将人工呼叫转接至BBS系统，还能判断在一天中的哪些时段拨打费用高昂但受时间限制的呼叫等。由于邮件器提供链路层协议，其特性决定了节点间的兼容性；因此，一个节点通常以其所运行的邮件器而闻名。比如，某个节点因使用BinkleyTerm或Fido作为邮件器，会被称作Binkley节点或Fido节点。

A Nodelist Compiler transforms the nodelist from the standard FTS-0005 distribution format to that needed by the node's other software, i.e. mailer, BBS, editor, and/or packer. Aside from trivial differences in syntax, more complex translations may be needed. I.e. mailer software usually requires that telephone numbers be transformed given local rules.节点列表编译器将节点列表从标准的 FTS-0005 分发格式转换为节点其他软件（即邮件程序、电子公告板系统、编辑器和/或打包程序）所需的格式。除了语法上的细微差异外，还可能需要进行更复杂的转换。例如，邮件程序通常要求根据本地规则转换电话号码。

Policy and Politics 政策与政治

In contrast to the uucp network or the Internet, and due mostly to the low cost of entry, from its earliest days, FidoNet has been owned and operated primarily by end-users and hobbyists more than by computer professionals. Therefore, social and political issues arose in FidoNet far faster and more seriously than might be expected by those raised in other network cultures.与uucp网络或互联网不同，且主要由于其准入成本较低，从诞生之初，FidoNet的所有权和运营就主要由终端用户和爱好者掌握，而非计算机专业人士。因此，FidoNet中出现的社会和政治问题，其速度和严重程度远超其他网络文化背景下的人们的预期。

Tom Jennings intended FidoNet to be a cooperative anarchy to provide minimal-cost public access to electronic mail. Two very basic features of FidoNet encourage this. Every node is self-sufficient, needing no support from other nodes to operate. But more significant is that the nodelist contains the modem telephone number of all nodes, allowing any node to communicate with any other node without the aid or consent of technical or political groups at any level. This is in strong contrast to the uucp network, BITNET, and the Internet.汤姆·詹宁斯将FidoNet设计成一种协作式无政府状态，旨在以最低成本为公众提供电子邮件访问渠道。FidoNet的两个核心基本特征促成了这一点。每个节点都能自给自足，运行时无需其他节点的支持。但更重要的是，节点列表包含了所有节点的调制解调器电话号码，这使得任意节点都能与其他任何节点进行通信，无需借助任何层级的技术或政治组织的帮助或同意。这与Unix-to-Unix Copy程序网络、BITNET以及互联网形成了鲜明对比。

In 1985, the first FidoNet policy document was published. It concerned itself almost entirely with technical procedural issues. It required a capability to send and receive email, defined the "national mail hour" as mandatory, delineated roles of the local network hubs and nodelist coordinators, and stated simple restrictions on routing of traffic through unsuspecting nodes. In addition, it stated two social rules, a proscription against use of the network for illegal purposes (e.g. pirated software) and a statement of FidoNet's basic social guideline, "Do not be excessively annoying and do not become excessively annoyed." 1985年，首份FidoNet政策文件发布。该文件几乎完全围绕技术流程问题展开，要求具备收发电子邮件的功能，将“全国邮件时段”定为强制要求，明确了本地网络集线器和节点列表协调员的职责，并对流量通过无感知节点的路由制定了简单限制。此外，文件还规定了两条社交规则：一是禁止将网络用于非法用途（如盗版软件）；二是阐明了FidoNet的基本社交准则——“切勿过度惹人烦，也切勿过度恼怒”。

In 1986, a well-intentioned but naive group formed the International FidoNet Association, intending to promulgate the technology and coordinate publication of the newsletter and other writings about the network. Unfortunately, as FidoNet operators were far more socially oriented than their more technical brethren in the other networks, the formal organization of IFNA tended to draw considerable political interest and attracted the less constructive political elements of the FidoNet culture. The issue came to a head in 1989 with an attempt to load the IFNA board of directors and pass a motion which explicitly put IFNA in complete control of the network. The motion was cleverly forced into a netwide referendum (FidoNet's only global vote to date) which required a majority of the network assent to IFNA rule. The referendum did not pass, and IFNA was subsequently dissolved.1986年，一个善意但天真的团体成立了国际FidoNet协会，打算公布时事通讯和其他关于该网络的文章的技术和coordinatepublication。不幸的是，由于FidoNet运营商比其他网络中技术含量更高的兄弟更注重社会，IFNA的正式组织往往会引起相当大的政治兴趣，并吸引FidoNet文化中无关紧要的建设性政治因素。1989年，这个问题达到了顶点，试图让IFNA董事会承担责任，并通过一项明确让IFNA完全控制网络的动议。该动议被巧妙地推进了网络全民公决（FidoNet迄今为止唯一的全球投票），这需要网络的大多数同意IFNA规则。全民公决没有通过，IFNA随后解散。

The first written policy was published and adopted by informal consent. Subsequently, three revisions of FidoNet policy have been written and made operational by various, but less democratic, procedures. The current document, Policy-4, was written by the regional nodelist coordinators, and has a large amount of social and political content enshrining a hierarchy of coordinators: an International Coordinator (IC), a Zone Coordinator (ZC) in each continent, Regional Coordinators (RCs) in subdivisions of the continents, usually countries, and a Network Coordinator (NC) for each local network. As it was written by the self-anointed RCs, ZCs and the IC are elected by the RCs and NCs are appointed by the RCs. Although the document has caused considerable acrimony and is large and complex, it contains many useful operational guidelines, so is generally observed.首份书面政策经非正式同意后发布并通过。此后，FidoNet 政策历经三次修订，均通过各类但民主程度较低的流程制定并落地实施。现行文件《政策-4》由区域节点列表协调员起草，其中包含大量社会与政治相关内容，明确了协调员的层级体系：一名国际协调员（IC）、各大洲各设一名区域协调员（ZC）、各大洲细分区域（通常为国家）设区域协调员（RC），以及每个本地网络设网络协调员（NC）。该文件由自封的区域协调员起草，国际协调员（IC）和大洲区域协调员（ZC）由区域协调员选举产生，网络协调员（NC）则由区域协调员任命。尽管该文件引发了诸多激烈争议，且篇幅冗长、内容复杂，但其中包含诸多实用的运营指导原则，因此得到了普遍遵守。

The amazing resilience of FidoNet's social and technical structure was made evident yet again in 1989-90, when the RCs in many of the continents attempted to exert serious social control under the recently published Policy-4. While echomail provided quite high-bandwidth (albeit low content) communication, and thus the political situation could be openly debated, the power structure's inability to restrict node-to-node communication prevented any real control from being effected. A fair number of RCs and NCs were forced to resign, and the rest have since taken more passive and facilitative roles.1989至1990年，各大洲的区域协调员试图依据最新发布的《4号政策》实施严格的社会管控，这再次凸显了FidoNet社交与技术结构惊人的韧性。尽管回声邮件提供了相当高带宽（尽管内容质量较低）的通信方式，使得政治局势能够被公开讨论，但权力结构因无法限制节点间的通信，最终未能实现任何实质性管控。不少区域协调员和国家协调员被迫辞职，其余人此后也转而承担更具被动性和辅助性的角色。

Bibliography 参考文献

\[Baker 87\] Ben Baker, FSC-0027, "The Distribution Nodelist" \[Baker 87\] 本·贝克，FSC-0027，《分发节点列表》

\[Becker 90\] Phil Becker, FTS-0006, "YOOHOO and YOOHOO/2U2: The netmail handshake used by Opus-CBCS and other intelligent FidoNet mail handling packages" \[Becker 90\] 菲尔·贝克尔，FTS-0006，《YOOHOO 与 YOOHOO/2U2：Opus-CBCS 及其他智能 FidoNet 邮件处理程序所使用的网络邮件握手协议》

\[Bush 86\] Randy Bush, FTS-0001, "A Basic FidoNet Technical Standard" \[Bush 86\] 兰迪·布什，FTS-0001，《FidoNet 基础技术标准》

\[Guillarmod 92\] F. Jacot Guillarmod, "From FidoNet to Internet: the evolution of a national network", "Proceedings of INET'92", H. Ishida Editor.\[吉拉尔莫德 92\] F. 雅科·吉拉尔莫德，《从 FidoNet 到互联网：一个全国性网络的演变》，《INET'92 会议论文集》，H. 石田 主编。

\[Murray 92\] Murray, Janet, "K12 Network: Global Education through Telecommunications", "Proceedings of INET'92", H. Ishida Editor.\[穆雷 92\] 穆雷，珍妮特，《K12 网络：通过电信实现全球教育》，收录于《INET'92 会议论文集》，H. 石田 主编。

<iframe src="chrome-extension://cnjifjpddelmedmihgijeibhnjfabmlf/side-panel.html?context=iframe"></iframe>