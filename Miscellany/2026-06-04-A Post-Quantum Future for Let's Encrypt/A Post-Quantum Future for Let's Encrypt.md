---
title: "A Post-Quantum Future for Let's Encrypt"
source: "https://letsencrypt.org/2026/06/03/pq-certs"
author:
published: 2026-06-03
created: 2026-06-04
description: "Let’s Encrypt is committed to a post-quantum-safe Web PKI. The path we’re planning to take is Merkle Tree Certificates (“MTCs”), a new approach that adds post-quantum authentication to the web without sacrificing the speed and reliability that have made TLS universal.This post is about these plans and why we believe MTCs are worth pursuing as a key to a post-quantum future.An increasingly urgent problem For much of the last several years, the conversation about post-quantum cryptography has been a conversation about encryption. The reasoning was straightforward: an attacker who records encrypted traffic today might be able to decrypt it years from now once quantum computers can break the underlying math. Authentication, the part of TLS that indicates a server is who it says it is, has been a less urgent problem. A quantum computer needs to forge a signature in real time, not retroactively, so threats to authentication hinge on the existence of a cryptographically relevant quantum computer (CRQC)."
tags:
  - "ToRead"
---
Let’s Encrypt is committed to a post-quantum-safe Web PKI. The path we’re planning to take is Merkle Tree Certificates (“MTCs”), a new approach that adds post-quantum authentication to the web without sacrificing the speed and reliability that have made TLS universal.Let’s Encrypt 致力于打造抗量子安全的网页公钥基础设施（Web PKI）。我们规划采用的路径是默克尔树证书（Merkle Tree Certificates，简称 MTCs），这是一种全新的方案，能在为网页添加抗量子认证功能的同时，不牺牲让传输层安全协议（TLS）得以普及的速度与可靠性。

This post is about these plans and why we believe MTCs are worth pursuing as a key to a post-quantum future.这篇帖子将介绍这些计划，并阐述我们为何认为多变量密码（MTCs）值得作为后量子时代的关键技术加以研发。

## An increasingly urgent problem

For much of the last several years, the conversation about post-quantum cryptography has been a conversation about encryption. The reasoning was straightforward: an attacker who records encrypted traffic today might be able to decrypt it years from now once quantum computers can break the underlying math. Authentication, the part of TLS that indicates a server is who it says it is, has been a less urgent problem. A quantum computer needs to forge a signature in real time, not retroactively, so threats to authentication hinge on the existence of a cryptographically relevant quantum computer (CRQC).在过去数年的大部分时间里，关于后量子密码学的讨论一直围绕着加密技术展开。其理由很简单：如今记录下加密流量的攻击者，或许在数年后，一旦量子计算机能够破解其底层数学原理，就能对其进行解密。而作为 TLS 协议中用于验证服务器身份的身份认证部分，却一直不是那么紧迫的问题。量子计算机需要实时伪造签名，而非事后追溯，因此身份认证面临的威胁取决于是否存在具备密码学相关能力的量子计算机（CRQC）。

That comfort has been eroding for a while. In the United States, the NSA’s [CNSA 2.0 suite](https://www.nsa.gov/Cybersecurity/Post-Quantum-Cybersecurity-Resources/) has directed national security systems toward post-quantum algorithms on a 2030-to-2035 schedule since 2022, and [NIST’s draft transition guidance](https://nvlpubs.nist.gov/nistpubs/ir/2024/NIST.IR.8547.ipd.pdf) would deprecate RSA-2048 and P-256 after 2030 and disallow them after 2035. The [European Union’s roadmap](https://digital-strategy.ec.europa.eu/en/library/coordinated-implementation-roadmap-transition-post-quantum-cryptography) targets high-risk systems by the end of 2030 and broad migration by 2035. These mandates don’t bind the public Web PKI directly, but they set the end-of-decade timeline that the vendors, libraries, and standards bodies it relies on are already working toward.这种安全感已经在逐渐削弱有一段时间了。在美国，美国国家安全局（NSA）的 [CNSA 2.0 套件](https://www.nsa.gov/Cybersecurity/Post-Quantum-Cybersecurity-Resources/) 自2022年起就已将国家安全系统的发展方向指向后量子算法，规划时间为2030至2035年；而 [美国国家标准与技术研究院（NIST）的过渡指导草案](https://nvlpubs.nist.gov/nistpubs/ir/2024/NIST.IR.8547.ipd.pdf) 规定，2030年后将不再推荐使用RSA-2048和P-256算法，2035年后则禁止使用这些算法。 [欧盟的路线图](https://digital-strategy.ec.europa.eu/en/library/coordinated-implementation-roadmap-transition-post-quantum-cryptography) 设定的目标是2030年底前完成高风险系统的迁移，2035年前实现全面迁移。这些强制要求虽不直接约束公共网络公钥基础设施（Web PKI），但它们定下的这个十年末的时间节点，已是其依赖的供应商、程序库和标准制定机构正在努力推进的方向。

This year, the timeline shortened further. Google [announced](https://blog.google/innovation-and-ai/technology/safety-security/cryptography-migration-timeline/) that it would migrate its services by 2029, citing tightening estimates for the potential arrival of a CRQC. [Cloudflare followed](https://blog.cloudflare.com/post-quantum-roadmap/) with a parallel commitment. In addition, [Go 1.27](https://go.dev/doc/go1.27) adds ML-DSA, a NIST-standardized post-quantum signature scheme, to the standard library, a sign that post-quantum signatures are becoming practical infrastructure.今年，这一时间线进一步缩短。谷歌 [宣布](https://blog.google/innovation-and-ai/technology/safety-security/cryptography-migration-timeline/) 将在2029年前完成其服务的迁移，理由是对CRQC潜在出现时间的预估愈发紧迫。 [Cloudflare 紧随其后](https://blog.cloudflare.com/post-quantum-roadmap/) 作出了类似承诺。此外， [Go 1.27](https://go.dev/doc/go1.27) 在标准库中新增了ML-DSA——这是一种由美国国家标准与技术研究院（NIST）标准化的后量子签名方案，标志着后量子签名正逐渐成为实用的基础设施。

Post-quantum authentication is no longer a problem the Web PKI ecosystem should defer. Long-lived keys (root certificate authorities, code-signing keys, identity systems) are particularly valuable targets, and new technology takes years to gain broad adoption, so the work has to start early.后量子认证不再是 Web PKI 生态系统可以推迟解决的问题。长期密钥（根证书颁发机构、代码签名密钥、身份系统）是极具价值的攻击目标，而新技术的广泛采用需要数年时间，因此相关工作必须尽早开展。

## The Web PKI’s unique circumstances

The Web PKI is one of the trickiest places to deploy post-quantum signatures. The reason is size.Web PKI 是部署后量子签名最棘手的场景之一，原因在于尺寸问题。

ML-DSA-44, one of the smaller NIST standardized post-quantum signature schemes, has a signature roughly 2,420 bytes long. The algorithms used in the Web PKI today are much smaller. RSA-2048 signatures are 256 bytes and ECDSA-P256 signatures are 64 bytes. Public keys are bigger as well: 1,312 bytes for ML-DSA-44, 256 bytes for RSA-2048, and 64 bytes for ECDSA-P256. A typical Web PKI handshake today carries five signatures and two public keys. Replacing those with ML-DSA equivalents would push a single TLS handshake well past 10 kilobytes. [Cloudflare’s research](https://blog.cloudflare.com/another-look-at-pq-signatures/) has shown that, at that scale, a meaningful share of TLS connections fail on real-world networks, and the rest get slower.ML-DSA-44是美国国家标准与技术研究院（NIST）标准化的后量子签名方案中规模较小的一种，其签名长度约为2420字节。如今Web公钥基础设施（Web PKI）中使用的算法签名要小得多：RSA-2048签名为256字节，ECDSA-P256签名为64字节。公钥长度也同样更长：ML-DSA-44的公钥为1312字节，RSA-2048为256字节，ECDSA-P256为64字节。如今典型的Web PKI握手包含5个签名和2个公钥，若将这些替换为ML-DSA的等效算法，单次TLS握手的大小将远超10千字节。 [Cloudflare的研究](https://blog.cloudflare.com/another-look-at-pq-signatures/) 表明，达到这一规模后，大量TLS连接会在实际网络环境中失败，其余连接的速度也会变慢。

![Authentication data in a single TLS handshake, by algorithm](https://letsencrypt.org/images/blog/2026.06.03-pq-certs-handshake-size.svg)

Authentication data in a single TLS handshake, by algorithm

Larger handshakes would affect every TLS connection, not just those that would fail. They would mean constrained bandwidth, slower connections, and a worse experience for users, all in exchange for security against a threat that hasn’t materialized yet. That’s a steep cost to enable by default, and defaults are what actually move security at web scale.更大的握手操作会影响每一个TLS连接，而非仅那些会失败的连接。这将意味着带宽受限、连接变慢，用户体验变差，而这一切都是为了防范一种尚未成为现实的威胁。默认启用这样的操作代价极大，而默认设置才是真正能在网络规模下推动安全发展的关键。

## Merkle Tree Certificates

A different design called Merkle Tree Certificates (“MTCs”) has been emerging over the past year, and we believe it is a strong path forward for the post-quantum Web PKI.过去一年，一种名为默克尔树证书（简称 MTC）的全新设计逐渐兴起，我们认为它是后量子时代 Web 公钥基础设施（Web PKI）的一条极具前景的发展路径。

Instead of issuing certificates one at a time and signing each one individually, an MTC certificate authority issues certificates in batches, with a single signature covering the entire batch. Browsers stay up to date on those batch signatures (called “landmarks”) separately from the TLS handshake.MTC证书颁发机构不再逐个签发证书并单独为每一份证书签名，而是批量签发证书，用单一签名覆盖整个批次。浏览器会与TLS握手分开，单独更新这些批量签名（称为“地标”）的相关信息。

In the common case, the entire authentication path in an MTC handshake is one signature, one public key, and one inclusion proof. That’s smaller than today’s Web PKI handshake, even though MTCs use post-quantum algorithms. The other case is the “standalone” form. It uses slightly larger handshakes as a fallback when a client’s landmark is out of date.在常见情况下，MTC 握手过程中的整个认证路径仅包含一个签名、一个公钥和一个包含证明。即便 MTC 使用后量子算法，其规模也小于如今的 Web PKI 握手。另一种情况是“独立”形式，当客户端的地标信息过期时，该形式会使用规模稍大的握手作为备用方案。

![Post-quantum authentication overhead: conventional versus Merkle Tree Certificate](https://letsencrypt.org/images/blog/2026.06.03-pq-certs-mtc-authentication-overhead.svg)

Post-quantum authentication overhead: conventional versus Merkle Tree Certificate

There is more to MTCs than size optimization. Because every certificate is part of a published Merkle tree, transparency becomes a property of issuance itself. Today’s Certificate Transparency ecosystem is bolted on after the fact: certificates are issued by CAs, then logged separately, with extra signatures riding along in the TLS handshake to attest to that logging. With MTCs, a certificate cannot exist outside the Merkle tree. Certificate Transparency is built in.MTC 所具备的价值远不止规模优化。由于每一份证书都是已发布的默克尔树的一部分，透明度本身就成为了签发流程的固有属性。如今的证书透明度生态系统是事后才附加的：证书由证书颁发机构（CA）签发，之后再单独录入日志，并在传输层安全（TLS）握手过程中附带额外签名，以此证明证书已完成录入。而采用 MTC 时，证书无法脱离默克尔树单独存在。证书透明度被直接内置其中。

This is not entirely new ground for us. Let’s Encrypt has operated [Certificate Transparency logs](https://letsencrypt.org/docs/ct-logs/) since 2019. Those logs are append-only Merkle trees, the same core data structure MTCs are built on, and ones we have run in production, at scale, for years.这对我们来说并非全新领域。Let’s Encrypt 自 2019 年起就运营着 [证书透明度日志](https://letsencrypt.org/docs/ct-logs/) 。这些日志是仅追加的默克尔树，这与 MTC 所基于的核心数据结构相同，也是我们多年来在生产环境中大规模运行的结构。

Cloudflare and Chrome are already running a [feasibility experiment](https://blog.cloudflare.com/bootstrap-mtc/) with MTCs against real internet traffic. The IETF’s [PLANTS working group](https://datatracker.ietf.org/wg/plants/about/) is working on standardizing the design. Chrome has [announced](https://security.googleblog.com/2026/02/cultivating-robust-and-efficient.html) that MTCs are its preferred path for adding post-quantum certificates to the public web.Cloudflare 和 Chrome 已针对真实互联网流量开展了一项基于 MTC 的 [可行性实验](https://blog.cloudflare.com/bootstrap-mtc/) 。互联网工程任务组（IETF）的 [PLANTS 工作组](https://datatracker.ietf.org/wg/plants/about/) 正致力于该设计的标准化工作。Chrome 已 [宣布](https://security.googleblog.com/2026/02/cultivating-robust-and-efficient.html) ，将 MTC 作为在公共网络中添加后量子证书的首选路径。

## Our plans

We are planning to support Merkle Tree Certificates as the path forward for the post-quantum Web PKI. We are targeting late 2026 for a staging environment that issues MTCs, and 2027 for a production-ready environment.我们计划支持默克尔树证书，将其作为后量子网络公钥基础设施的发展方向。我们的目标是在2026年底推出可发放默克尔树证书的暂存环境，2027年推出可投入生产的环境。

This is not a small endeavor. Issuing MTCs at the scale of Let’s Encrypt requires meaningful changes throughout our stack: in our issuance infrastructure, in the ACME protocol our subscribers use to obtain certificates, in revocation and operational tooling, and in the transparency-log infrastructure that MTCs subsume. We have been participating in the IETF PLANTS and ACME working groups as the standards take shape.这并非一项小工程。以 Let’s Encrypt 的规模签发多阶段证书（MTCs），需要对整个技术栈进行重大调整：包括签发基础设施、用户获取证书所使用的 ACME 协议、吊销与运维工具，以及多阶段证书所涵盖的透明日志基础设施。随着相关标准逐步成型，我们一直在参与 IETF 的 PLANTS 和 ACME 工作组的工作。

Alongside the MTC work, we are tracking the standards for ML-DSA signatures in X.509 ([RFC 9881](https://www.rfc-editor.org/rfc/rfc9881)) and TLS ([draft-ietf-tls-mldsa](https://datatracker.ietf.org/doc/draft-ietf-tls-mldsa/)), and the ecosystem work this depends on, like the addition of ML-DSA to the Go standard library. The Web PKI’s transition to post-quantum security needs all of this to land in browsers, libraries, and ACME clients, whether the certificates ultimately delivered are MTCs or ML-DSA signed X.509.除了MTC相关工作外，我们还在跟踪X.509（ [RFC 9881](https://www.rfc-editor.org/rfc/rfc9881) ）和TLS（ [draft-ietf-tls-mldsa](https://datatracker.ietf.org/doc/draft-ietf-tls-mldsa/) ）中ML-DSA签名的标准，以及相关的生态系统建设工作，例如将ML-DSA加入Go标准库。无论最终交付的证书是MTC还是ML-DSA签名的X.509证书，Web公钥基础设施（Web PKI）向后量子安全的转型都需要这些内容落地到浏览器、库和ACME客户端中。

## What this means if you use Let’s Encrypt

Nothing changes today. Your current Let’s Encrypt certificates will continue to be issued and renewed exactly as they always have been. When post-quantum certificates become available from Let’s Encrypt, they will arrive the way our service always has: free, automated, and available to anyone with an ACME client.今天没有任何变化。你当前的 Let’s Encrypt 证书将继续像以往一样被颁发和续期。当 Let’s Encrypt 推出后量子证书时，它们将以我们服务一贯的方式到来：免费、自动化，且可供任何拥有 ACME 客户端的人使用。

The transition will take time. There are standards still being finalized, root programs still defining their requirements, and engineering work that has to land in the broader ecosystem (browsers, libraries, ACME clients) before any of this matters at scale. We will keep the community informed as the work progresses and as the timelines firm up.这一过渡需要时间。目前仍有标准在最终确定，根程序仍在定义其要求，而且在所有这些内容大规模发挥作用之前，还需要将工程工作融入更广泛的生态系统（浏览器、库、ACME 客户端）。我们将在工作推进和时间表明确后，及时向社区通报最新情况。

If you maintain an ACME client or run an ACME-driven certificate pipeline, this is a good moment to start tracking the work in the PLANTS working group and the discussions on the [mtcs@chromium.org](https://groups.google.com/a/chromium.org/g/mtcs) mailing list. Some of the changes coming will require client-side support, and the ecosystem will benefit from clients that are ready when the issuance side is.如果你维护着一个 ACME 客户端或运行着由 ACME 驱动的证书流水线，现在正是开始关注 PLANTS 工作组工作以及在 [mtcs@chromium.org](https://groups.google.com/a/chromium.org/g/mtcs) 邮件列表中参与讨论的好时机。即将到来的部分变更需要客户端提供支持，而当签发端准备就绪时，做好准备的客户端将为整个生态系统带来利好。

## A note on the wider post-quantum transition

For the broader internet community: post-quantum encryption is the more urgent problem, because any TLS connection without post-quantum key exchange is potentially harvestable for later decryption. If you operate servers, please ensure they support hybrid post-quantum key exchange (X25519MLKEM768). Major browsers and operating systems already do, and turning it on at the server is one of the highest-leverage things you can do this year.面向广大互联网社区：后量子加密是更为紧迫的问题，因为任何未采用后量子密钥交换的 TLS 连接都有可能被截获，以供日后解密。如果你运营服务器，请确保其支持混合式后量子密钥交换（X25519MLKEM768）。主流浏览器和操作系统已支持该功能，在服务器端开启这一功能是你今年能做的最具高杠杆效应的举措之一。

## In closing

We have been building infrastructure for the public web [since 2013](https://www.abetterinternet.org/about/) on the principle that security should be available to everyone, automatically, at no cost. The quantum transition is a generational change in how that security works under the hood.自2013年起，我们一直在为公共网络构建基础设施，秉持的原则是安全应免费、自动地惠及每一个人。量子跃迁是这类底层安全运行方式的一次历史性变革。