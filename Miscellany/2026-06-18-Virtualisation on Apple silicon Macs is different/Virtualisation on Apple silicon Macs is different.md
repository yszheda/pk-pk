---
title: "Virtualisation on Apple silicon Macs is different"
source: "https://eclecticlight.co/2026/04/29/virtualisation-on-apple-silicon-macs-is-different/"
author:
  - "[[hoakley]]"
  - "[[霍克利]]"
published: 2026-04-29
created: 2026-06-18
description: "Virtualising macOS, Linux and Windows on Intel Macs has been relatively straightforward, and device support left to the developer. That won't work for Apple silicon Macs. This explains what happens, its strengths and limitations as a result."
tags:
---
Before Apple silicon Macs, you’ve been able to run different versions of macOS, Linux or Windows in third-party virtualisers, such as those from VMware and Parallels. Those products enable a virtual machine running a different operating system to be hosted in macOS, both running code for Intel processors. As part of its engineering preparations for the switch to using Arm processors, Apple decided that the only practical way to support virtualisation on its new Mac hardware was to build it into macOS. This was to enable older versions of macOS, and other operating systems including Linux and Windows for Arm, to run in virtual machines.在苹果硅芯片Mac出现之前，你可以在第三方虚拟化器中运行不同版本的macOS、Linux或Windows，比如VMware和Parallels的虚拟机。这些产品允许运行不同操作系统的虚拟机托管在macOS中，两者都运行英特尔处理器代码。作为转向Arm处理器工程准备的一部分，苹果决定支持新Mac硬件虚拟化的唯一实际方式是将其集成到macOS中。此举旨在使旧版本的macOS及包括Linux和Windows for Arm在内的其他操作系统能够在虚拟机中运行。

This is quite different from the more challenging problem of running operating systems for different processors, such as Intel, on Apple silicon Macs. Although Intel apps can have their code translated by Rosetta 2, that doesn’t work for operating systems, which need a software emulator, a feature left for the likes of UTM.这与在苹果硅芯片Mac上为不同处理器（如英特尔）运行操作系统的更具挑战性的问题有很大不同。虽然英特尔应用可以通过 Rosetta 2 翻译代码，但这对操作系统不适用，因为操作系统需要软件模拟器，而此功能留给了 UTM 等软件。

#### Hypervisor 虚拟机监控程序

The fundamental requirement for modern virtualisers hosted on a primary operating system like macOS is a *hypervisor,* which Apple added to macOS back in OS X 10.10, in 2014. Like Intel processors, Arm CPUs provide hardware support for hypervisors, so much of the remaining work to implement virtualisation in Apple silicon Macs centred on device support. That had been relatively straightforward for Intel Macs, as they mainly use PC hardware components, but that isn’t the case for Apple’s new Macs.现代虚拟化器在主操作系统如macOS上的基本需求是虚拟机 *监控器，苹果* 于2014年在OS X 10.10中加入了虚拟机监控器。与英特尔处理器类似，Arm CPU为虚拟机监控程序提供硬件支持，因此苹果硅Mac实现虚拟化的剩余工作大多集中在设备支持上。这对英特尔Mac来说相对简单，因为它们主要使用PC硬件组件，但苹果的新Mac则不然。

#### Virtio drivers Virtio驱动单元

Every single hardware device in an Apple silicon chip is different from its equivalent (if there is one) in Intel Macs. Even if Apple had wanted to document them fully for external use, the engineering effort to match device support in Intel Macs would have been too costly for any third party. Thus starting with a hypervisor and expecting others to build a complete virtualiser wasn’t feasible, nor was it likely to result in the high performance that Apple and users expected. What Apple did instead was to build device support into macOS, in the form of Virtio drivers.苹果硅芯片中的每一个硬件设备都与英特尔Mac中的对应设备（如果有的话）不同。即使苹果想为外部使用完整文档化这些内容，英特尔Mac匹配设备支持的工程成本对任何第三方来说都太高昂。因此，从虚拟机监控器开始，期望别人构建完整的虚拟化器既不可行，也不太可能达到苹果和用户期望的高性能。苹果所做的是将设备支持内置于 macOS，形式为 Virtio 驱动。

Virtio is a [standard](https://docs.oasis-open.org/virtio/virtio/v1.1/virtio-v1.1.html) originally developed by Rusty Russell to provide an abstraction layer over I/O devices. When the guest operating system calls to open a file, for example, that’s passed to a front-end Virtio storage device para-driver, and from there into a Virtio back-end driver that interacts with the storage device. Although this might seem less efficient than traditional virtualisation, in practice it can prove far more efficient.Virtio 是由 Rusty Russell 最初开发的 [标准](https://docs.oasis-open.org/virtio/virtio/v1.1/virtio-v1.1.html) ，用于为 I/O 设备提供抽象层。例如，当客户操作系统调用打开文件时，该文件会传递给前端的Virtio存储设备副驱动，再传入与存储设备交互的Virtio后端驱动。虽然这看起来不如传统虚拟化高效，但实际上可以证明其效率更高。

![virtualisation1](https://eclecticlight.co/wp-content/uploads/2022/07/virtualisation1.jpg)

virtualisation1

Its most obvious advantage is that creating a virtualiser app becomes a matter of configuring and opening the required Virtio devices, and letting the guest, Virtio and the host get on with it. And that’s essentially what an app does with Apple’s [Virtualisation framework](https://developer.apple.com/documentation/virtualization).它最明显的优势是，创建虚拟化应用只需配置和打开所需的Virtio设备，让访客、Virtio和主机各自操作。这本质上就是应用在苹果虚拟 [化框架](https://developer.apple.com/documentation/virtualization) 下所做的。

Apple’s choice of Virtio was undoubtedly swayed by the fact that Linux already has good [Virtio support](https://docs.kernel.org/driver-api/virtio/virtio.html), but at the time macOS had none. In the couple of years preceding the release of Monterey, Apple’s engineers thus set about building Virtio support into macOS, which explains why macOS lightweight virtualisation is only available in Monterey and later hosts, and when running Monterey and later guests. As implemented in macOS (both as guest and host), there are also extensions to support keyboard and pointing devices, a shared clipboard, and high-performance graphics with Metal and GPU support.苹果选择Virtio无疑是因为Linux已经有很好的 [Virtio支持](https://docs.kernel.org/driver-api/virtio/virtio.html) ，但当时macOS没有。在 Monterey 发布前的几年里，苹果工程师着手将 Virtio 支持集成到 macOS，这也解释了为什么 macOS 轻量级虚拟化仅在 Monterey 及以后托管平台上可用，并且在运行 Monterey 及以后访客平台上。在macOS中实现（无论是作为访客还是主机），还支持键盘和指向设备、共享剪贴板，以及支持Metal和GPU的高性能图形。

In the Virtio model, providing such support is the task of the operating system, not the virtualiser. For vendors like VMware and Parallels this reduces not only the cost of development, but also the commercial value of their products; there’s no scope for either of them to engineer better or faster graphics support, as that’s determined by features provided in both guest and host operating systems, via Virtio or an equivalent. That puts Apple in charge of what hardware and features are supported by virtualisation on Apple silicon.在Virtio模型中，提供此类支持是操作系统的任务，而非虚拟化器。对于像VMware和Parallels这样的厂商来说，这不仅降低了开发成本，也降低了其产品的商业价值;它们都没有空间设计更好或更快的图形支持，因为这取决于客户操作系统和主机操作系统（通过Virtio或类似软件）提供的功能。这使得苹果掌控了苹果硅片虚拟化支持哪些硬件和功能。

#### Performance 性能

On the other hand, it guarantees optimum performance in VMs. Not only is their CPU and GPU code run direct on the hardware, just as in the host, but Virtio devices deliver almost as good performance as on the host. Comparable Geekbench 6.3.0 benchmarks when running macOS Monterey as both guest and host are:另一方面，它保证了虚拟机的最佳性能。不仅CPU和GPU代码直接运行在硬件上，就像主机一样，Virtio设备的性能几乎和主机一样好。当 macOS Monterey 作为访客和主机运行时，Geekbench 6.3.0 的对比基准测试如下：

- CPU single core VM 3,643, host 3,892 CPU 单核 VM 3.643，主机 3.892
- CPU multi-core VM 12,454, host 22,706 (limited by the number of cores available) CPU 多核虚拟机 12,454，主机 22,706（受可用核心数量限制）
- GPU Metal VM 102,282, host 110,960, with the VM as an Apple Paravirtual device.GPU Metal VM 102,282，主机 110,960，虚拟机作为苹果类虚拟设备。

Subsequent versions of macOS have improved on those. It’s worth noting that virtual cores allocated to a VM are primarily Performance cores, so threads running in the VM that would normally be run on Efficiency cores normally run significantly faster than they would do in the host.后续的macOS版本对这些进行了改进。值得注意的是，分配给虚拟机的虚拟核心主要是性能核心，因此虚拟机中运行的线程通常运行在效率核心上，速度通常比主机上快得多。

Initially, performance of VM primary storage in its disk image wasn’t good, but more recently [this has improved substantially](https://eclecticlight.co/2026/03/27/does-disk-storage-speed-limit-macos-virtual-machines/), even with FileVault enabled in the VM.最初，虚拟机主存储在磁盘镜像中的性能不佳，但最近即使启用了 FileVault 功能， [性能也有显著改善](https://eclecticlight.co/2026/03/27/does-disk-storage-speed-limit-macos-virtual-machines/) 。

#### Rosetta 2 罗塞塔2号

Although it can’t be used to translate a guest operating system, Rosetta 2 can still be used inside a macOS VM to translate and run 64-bit Intel code in apps that are compatible with macOS 10.15 Catalina, but is subject to the same limitations as any version of macOS on Apple silicon, in that it can’t handle older or 32-bit apps. This will become most useful when [Apple drops full support for Rosetta](https://eclecticlight.co/2026/01/17/whats-happening-with-code-signing-and-future-macos/) in macOS 28. VMs with older versions of macOS will still be able to translate and run compatible 64-bit Intel code, even though the host won’t be able to.虽然它不能用于翻译客机操作系统，但 Rosetta 2 仍可在 macOS 虚拟机中翻译并运行兼容 macOS 10.15 Catalina 的应用中的 64 位 Intel 代码，但与苹果硅基上的任何版本 macOS 一样，无法处理较旧或 32 位应用。当苹果在macOS 28 [中全面放弃对Rosetta的支持](https://eclecticlight.co/2026/01/17/whats-happening-with-code-signing-and-future-macos/) 时，这一点将变得尤为有用。装有旧版macOS的虚拟机仍然能够翻译并运行兼容的64位Intel代码，尽管主机无法做到。

#### Major limitations 主要局限性

Support for iCloud and iCloud Drive access wasn’t made available in VMs until Sequoia, and now requires that both the guest and host must be running macOS 15.0 or later. As VMs that support these features are structurally different from earlier VMs, this also means those VMs that have been upgraded from an earlier macOS still can’t support iCloud or iCloud Drive.iCloud 和 iCloud Drive 访问支持直到 Sequoia 才在虚拟机中提供，现在要求访客和主机都必须运行 macOS 15.0 或更高版本。由于支持这些功能的虚拟机结构与早期虚拟机不同，这也意味着那些从早期macOS升级的虚拟机仍然无法支持iCloud或iCloud Drive。

The greatest remaining limitation in virtualising macOS on Apple silicon is its inability to run many apps from the App Store. Although some do run without problems, any that check their App Store credentials will fail, as a VM can’t be signed into the App Store. This appears to be the result of Apple’s authorisation restrictions, and unless Apple rethinks and reengineers its store policies, it looks unlikely to change.在苹果硅片上虚拟化macOS的最大限制是无法从App Store运行许多应用。虽然有些虚拟机运行正常，但任何检查 App Store 凭证的虚拟机都会失败，因为虚拟机无法登录 App Store。这似乎是苹果授权限制的结果，除非苹果重新思考和调整其商店政策，否则改变的可能性不大。

Some lesser features remain problems. For example, network connections from a VM are always treated as being Ethernet, and there’s no support for them as Wi-Fi, even though they can connect using the host’s Wi-Fi. Audio also remains odd, and appears to be only partially supported. Although Sequoia has enabled support for storage devices, earlier macOS was confined to the VM’s disk image and shared folders.一些次要功能仍然存在问题。例如，虚拟机的网络连接总是被视为以太网，且不支持它们作为Wi-Fi，尽管它们可以通过主机的Wi-Fi连接。音频表现也很奇怪，似乎只部分支持。尽管红杉已支持存储设备，但早期macOS仅限于虚拟机的磁盘映像和共享文件夹。

Many aren’t aware that [Apple’s macOS licences](https://www.apple.com/legal/sla/docs/macOSTahoe.pdf) do cover its use in VMs, in Section 2B(iii), where there’s a limit of two macOS VMs that can be running on a Mac at any time. This is enforced by macOS, and trying to launch a third will be blocked. For the record, the licence also limits the purposes of virtualisation to “(a) software development; (b) testing during software development; (c) using macOS Server; or (d) personal, non-commercial use.” It’s worth noting that Apple discontinued macOS Server on 21 April 2022, and it’s unsupported for any macOS more recent than Monterey.许多人不知道 [苹果的macOS许可确实涵盖](https://www.apple.com/legal/sla/docs/macOSTahoe.pdf) 了虚拟机的使用，在第2B（iii）节中，Mac上最多只能运行两个macOS虚拟机。这是macOS强制执行的，尝试启动第三个会被阻止。声明中，许可协议还将虚拟化的目的限制为“（a）软件开发;（b） 软件开发期间的测试;（c） 使用 macOS Server;或（d）个人、非商业用途。”值得注意的是，苹果于2022年4月21日停止了macOS Server，且该服务器不支持任何比Monterey更新的macOS系统。

#### Usage 用途

Some examples of what you can use a macOS VM for:以下是一些macOS虚拟机可以做的事情示例：

- run apps compatible with Sonoma but not Sequoia, on M4 and M5 Macs that can’t run Sonoma;在无法运行Sonoma的M4和M5 Mac上运行兼容Sonoma但不兼容Sequoia的应用;
- run apps in a custom environment, e.g. with different region and language settings;在自定义环境中运行应用，例如不同地区和语言设置;
- check and access potentially malicious documents or apps in a locked-down environment;在封锁环境中检查并访问潜在的恶意文档或应用;
- test compatibility with multiple versions and localisations of macOS;测试与多个版本和本地化macOS的兼容性;
- work with highly sensitive data, in an isolated environment;在孤立环境中处理高度敏感数据;
- access a different iCloud account simultaneously;同时访问不同的iCloud账户;
- run beta-test versions of macOS 27.运行 macOS 27 的测试版。

#### Summary 摘要

macOS VMs on Apple silicon can: 苹果硅上的macOS虚拟机可以：

- run Monterey and later on any model, but not Big Sur or Intel macOS;运行Monterey及后续型号，但不支持Big Sur或Intel macOS;
- run most betas of the next release of macOS;运行大多数下一版本 macOS 的测试版;
- run Intel apps using Rosetta 2; 使用 Rosetta 2 运行 Intel 应用;
- deliver near-normal CPU and GPU performance, and support FileVault;提供接近正常的CPU和GPU性能，并支持FileVault;
- access iCloud and iCloud Drive only when both host and guest are running Sequoia or later;只有当主机和访客都运行红杉或更高版本时，才能访问iCloud和iCloud Drive;
- but they can’t run most App Store apps.但他们无法运行大多数应用商店应用。