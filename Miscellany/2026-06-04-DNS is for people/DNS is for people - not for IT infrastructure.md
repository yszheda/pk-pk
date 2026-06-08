---
title: DNS is for people - not for IT infrastructure
source: https://louwrentius.com/dns-is-for-people-not-for-it-infrastructure.html
author:
published:
created: 2026-06-04
description:
tags:
  - ToRead
  - networking
  - dns
  - self-hosting
  - homelab
---
The [Domain Name System](https://en.wikipedia.org/wiki/Domain_Name_System) exists because it's difficult for people to remember IP addresses (185.15.59.224) and much easier to remember domain names (wikipedia.org). [域名系统](https://en.wikipedia.org/wiki/Domain_Name_System) 的存在是因为人们很难记住IP地址（185.15.59.224），而记住域名（wikipedia.org）则要容易得多。

Regarding internet-accessible services, it makes sense to publish websites, API endpoints or similar services using DNS, as people have to interfact with them. The added benefit of a domain name is that the associated IP address can change without the client being affected.对于可通过互联网访问的服务而言，通过 DNS 发布网站、API 端点或类似服务是合理的，因为人们需要与这些服务进行交互。域名的额外优势在于，其关联的 IP 地址可以发生变化，而不会对客户端造成影响。

This article isn't against DNS for public services, but it questions if we should use DNS for internal IT infrastructure (independent of cloud vs. onprem) 本文并非反对将域名系统（DNS）用于公共服务，而是对是否应将其应用于内部信息技术（IT）基础设施（与使用公有云还是本地部署无关）提出了质疑。

## It's always DNS 永远是DNS的问题

Although DNS can be a very beneficial service, it can also become a liability. If you want a reliable system, you want as little components as possible. Every additional component adds a potential risk of failure. In addition, more components may create unforeseen behaviour and interactions that can cause outages (circular dependancies, and so on). If you can avoid adding components, you'll have a better chance of building a reliable system.尽管DNS是一项非常有益的服务，但它也可能成为一种负担。若想打造可靠的系统，就应尽可能减少组件数量。每增加一个组件，都会增加潜在的故障风险。此外，更多的组件可能会引发不可预见的行为和交互，进而导致系统中断（如循环依赖等问题）。如果能避免新增组件，就更有机会构建出可靠的系统。

Within the IT operations space, DNS has made a bit of a name for itself. Many may remember this little haiku.在 IT 运维领域，DNS 已经小有名气。很多人可能还记得这首小小的俳句。

```js
It’s not DNS
There’s no way it’s DNS
It was DNS
```

[(source) (来源)](https://www.reddit.com/r/sysadmin/comments/4oj7pv/comment/d4czk91/)

There are [multiple(1)](https://en.wikipedia.org/wiki/2021_Facebook_outage) [high-profile(2)](https://aws.amazon.com/message/101925/) incidents where DNS was involved. In these linked cases, the root-cause of the incident isn't the DNS system itself. Yet, because the root-cause affects the DNS service - which is in the critical path for virtually all services - the incident has such a huge impact.有 [多起(1)](https://en.wikipedia.org/wiki/2021_Facebook_outage) [备受关注(2)](https://aws.amazon.com/message/101925/) 的事件都涉及了DNS。在这些相关案例中，事件的根本原因并非DNS系统本身。然而，由于根本原因会影响DNS服务——而DNS服务几乎是所有服务的关键路径，因此这类事件造成的影响极大。

The Facebook / Meta outage was so significant because it locked people out of buildings (physical access) due to 'circular' dependancies on DNS being available. Again, it can be said that the circular dependancy is the root-cause, but the blast radius of DNS is in many cases so enormous that it may be difficult to have a clear end-to-end picture of potential risk.脸书/元公司的此次故障影响重大，原因是由于对域名系统（DNS）可用性存在“循环”依赖，导致人员无法进入大楼（实体通道）。同样可以说，循环依赖是根本原因，但域名系统的影响范围在很多情况下极为广泛，以至于很难清晰地梳理出潜在风险的端到端全貌。

## The case against DNS for internal IT infrastructure反对在内部IT基础设施中使用DNS的理由

From the perspective of IT operations, DNS has a drawback: DNS clients cache DNS records based on TTL. Different DNS client implementations can behave differently, but even if you have a fairly homogenous environment, the only way to assure clients (in this case other servers) use the updated IP address, is to control them and force a DNS refresh. 从IT运维的角度来看，DNS存在一个缺点：DNS客户端会基于生存时间（TTL）缓存DNS记录。不同的DNS客户端实现可能表现出不同的行为，但即便你的环境相当统一，要确保客户端（此处指其他服务器）使用更新后的IP地址，唯一的办法是管控它们并强制刷新DNS。

That got me thinking, why would we use DNS for infrastructure services? It isn't necessary for machine-to-machine communication. Instead of configuring domain names that may not resolve, we can just directly inject the appropriate IP address(ess) into configuration files. It's easy to configure systems with tools like Ansible or pyinfra at scale.这让我开始思考，我们为什么要将 DNS 用于基础设施服务？机器对机器的通信并不需要它。与其配置可能无法解析的域名，不如直接将合适的 IP 地址注入配置文件。借助 Ansible 或 pyinfra 这类工具，大规模配置系统也十分简便。

The counter argument could be that DevOPS / platform engineers are also humans, and it's much easier to spot misconfigurations or to troubleshoot if domain names are configured Instead of IP addresses. 反驳观点可能是，DevOPS/平台工程师也是人，若改用域名而非IP地址进行配置，那么发现配置错误或排查问题都会容易得多。

Fortunately, we still have `/etc/hosts`, which we can easily provision. Still no DNS service required! This way, we can configure domain names and pretend to use DNS. I also suspect that DNS queries against /etc/hosts are quite responsive.幸运的是，我们仍然有 `/etc/hosts` ，可以轻松对其进行配置。依然不需要 DNS 服务！这样一来，我们就能配置域名，并且模拟使用 DNS 的效果。我还怀疑针对 /etc/hosts 的 DNS 查询会有相当快的响应速度。

## DNS as generic security risk DNS作为普遍的安全风险

As of today, most network traffic is encrypted by default, or tunneled through an encrypted channel. DNS is - by default - the exception. Regarding internal IT infrastructure (cloud or 'onprem'), the network may be considered as a secure environment. An attack on the DNS service, spoofing packets, and so on, can be very disruptive though. Setting up DNSSEC may alleviate this problem, but that also introduces another administrative burden with it's own risk of misconfiguration. It's yet another layer of complexity. And we assume that internal infrastructure supports DNSSEC.截至目前，大多数网络流量默认处于加密状态，或通过加密通道建立隧道。而域名系统（DNS）默认是个例外。就内部IT基础设施（云环境或本地部署）而言，网络或许可被视为安全环境。但针对DNS服务的攻击、数据包欺骗等行为仍可能造成严重的破坏。部署DNSSEC或许能缓解这一问题，但这也会带来额外的管理负担，同时存在配置错误的风险，这又是一层复杂的设置。而且我们还假设内部基础设施支持DNSSEC。

## DNS as an Egress Exfiltration risk DNS作为出口数据窃取风险

Because [egress filtering](https://en.wikipedia.org/wiki/Egress_filtering) (filtering of outbound connections) can be cumbersome, it's often omitted, because the systems involved are 'trusted'. This is unfortunate as this makes life easier for an attacker. Any kind of resource required for an attack can be acquired on the vulnerable system with a simple outbound query towards the internet. Proper egress filtering of network traffic can be the difference between a succesfull and unsuccessful hacking attempt.由于 [出口过滤](https://en.wikipedia.org/wiki/Egress_filtering) （对出站连接的过滤）操作繁琐，相关系统又被视为“受信任的”，因此出口过滤常常被省略。这是很不幸的，因为这会让攻击者的行动变得更加容易。攻击者只需向互联网发起一次简单的出站查询，就能在存在漏洞的系统上获取攻击所需的各类资源。对网络流量进行规范的出口过滤，是黑客攻击能否成功的关键所在。

A lack of egress filtering also makes it much easier for an attacker to exfiltrate data. And the thing is: any IP protocol can be used to exfiltrate data, including DNS [^1]. 缺乏出口过滤还会让攻击者更容易窃取数据。问题在于：任何IP协议都可用于窃取数据，包括DNS。

This is how: the attacker gets a domain runs their internet-accessible authoritative nameserver for this domain. Now the attacker can make DNS requests to said domain like sensitivedata.evil.domain from the hacked system and you can extract all the data from the rogue DNS server logs [^2].具体做法如下：攻击者获取一个域名，并为该域名搭建可通过互联网访问的权威域名服务器。此后，攻击者可在被入侵的系统上向该域名（如敏感数据.恶意域名）发起 DNS 请求，你就能从恶意域名服务器的日志中提取所有数据。

Although a hacked server may not be able to directly interact with the attacker-controlled DNS server, by issuing DNS requests for the attacker-controlled domain, these requests will pass the local forwarding DNS server and be forwarded towards the attacker-controlled authoritative DNS server. See also tools like [dnscat2](https://github.com/iagox86/dnscat2) or [iodine](https://code.kryo.se/iodine/) 虽然被入侵的服务器可能无法直接与攻击者控制的DNS服务器交互，但通过向攻击者控制的域名发送DNS请求，这些请求会经过本地转发DNS服务器，并被转发至攻击者控制的权威DNS服务器。另见 [dnscat2](https://github.com/iagox86/dnscat2) 或 [iodine](https://code.kryo.se/iodine/) 等工具

Due to this risk, there is a case to be made, to - at least - not allow systems to query public DNS records. As servers may need to interfact with services on the internet (update servers, APIs, and so on), such access can be facilitated by a proxy server using allow-listed domains.出于这一风险，至少有理由不允许系统查询公共 DNS 记录。由于服务器可能需要访问互联网上的服务（更新服务器、API 等），这类访问可通过使用白名单域名的代理服务器来实现。

## Evaluation and closing words 评估与结语

In the end, everything is a tradeoff, where people must balance benefits and drawbacks against the context of their infrastructure, their particular risk appetite and even organisational structure and culture. 归根结底，一切都是一种权衡，人们必须结合自身的基础设施、特定的风险承受能力，甚至是组织结构和文化背景，来权衡利弊。

That said, I think it's reasonable to explore if DNS can be avoided altogether within the IT infrastructure to increase reliability and robustness. 尽管如此，我认为探索在 IT 基础设施中是否可以完全避免使用 DNS 以提高可靠性和稳健性是合理的。

Feel free to share your thoughts and feelings about this if you feel so inclined.如果你愿意的话，不妨分享一下你对此的想法和感受。

---

[^1]: Don't forget about services like NTP or ICMP. 别忘了 NTP 或 ICMP 这类服务。

[^2]: I have demonstrated this attack using this exact method with a domain I own for a customer that thought they had properly prevented egress traffic, including blocking NTP and ICMP. 我使用完全相同的方法，针对一位客户的自有域名演示了这种攻击——该客户本以为自己已妥善阻止了出口流量，其中包括阻断 NTP 和 ICMP 协议。