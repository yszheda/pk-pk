---
title: "From GAA to 3D Stacked FET: Expanding the Transistor into the Third Dimension"
source: "https://semiconductor.samsung.com/news-events/tech-blog/from-gaa-to-3d-stacked-fet-expanding-the-transistor-into-the-third-dimension/"
author:
published: 2026-06-17
created: 2026-06-24
description: "Samsung Electronics' Semiconductor Research Center presented the paper “First Demonstration of 3D Stacked FETs at Gate Pitch of 42 nm Featuring Triple Stacked Nanosheet Channels for Advanced Logic Applications” at the 2026 VLSI Symposium, held from June 14–18."
tags:
  - "ToRead"
---
## From GAA to 3D Stacked FET: Expanding the Transistor into the Third Dimension 从全环绕栅极到3D堆叠场效应晶体管：将晶体管拓展至第三维度

### 1\. Introduction 1. 引言

Samsung Electronics' Semiconductor Research Center presented the paper *“First Demonstration of 3D Stacked FETs at Gate Pitch of 42 nm Featuring Triple Stacked Nanosheet Channels for Advanced Logic Applications”* at the 2026 VLSI Symposium, held from June 14–18. This article aims to provide an accessible explanation of the significance of this research. 三星电子半导体研究中心在6月14日至18日举办的2026年国际超大规模集成电路（VLSI）研讨会上，发表了题为《面向先进逻辑应用的、具有三层纳米片沟道的42纳米栅极间距3D堆叠场效应晶体管首次实现》的论文。本文旨在通俗解读这项研究的重要意义。

**\[Research highlight\] \[研究亮点\]**

This work received an outstanding review score of 8.29 out of 10 during the 2026 VLSI Symposium paper evaluation process, ranking among the highest-scoring papers out of more than 1,000 submissions and earning recognition as a Best Paper. It was also selected as one of the 2026 VLSI Technical Highlights and featured in the symposium’s official Press Kit for media outreach. Additional information can be found in the official [VLSI Symposium Press Kit↗](https://www.vlsisymposium.org/press-kit/).该研究成果在2026年国际超大规模集成电路研讨会论文评审过程中获得了8.29分（满分10分）的优异评审分数，在1000余篇投稿论文中位列高分论文之列，并获评最佳论文。该成果同时入选2026年国际超大规模集成电路技术亮点，被收录于研讨会官方媒体宣传资料包。更多相关信息可查阅研讨会官方 [国际超大规模集成电路研讨会媒体资料包↗](https://www.vlsisymposium.org/press-kit/) 。

Transistor architectures have continuously evolved—from planar transistors to FinFETs, and later to Gate-All-Around (GAA) structures—with each generation improving the ability to control electrical current more precisely. However, achieving further scaling in logic devices requires more than simply improving the control of individual transistors. Equally important is determining how n-type and p-type transistors can be arranged more efficiently.晶体管架构一直在不断演进——从平面晶体管到鳍式场效应晶体管（FinFETs），再到后来的全栅（Gate-All-Around，GAA）结构，每一代都提升了更精准控制电流的能力。然而，要实现逻辑器件的进一步微缩，仅靠优化单个晶体管的控制能力是远远不够的。同样关键的是找到更高效的方式来排布n型和p型晶体管。

One promising answer to this challenge is the 3D Stacked FET. In conventional designs, n-type and p-type transistors are placed side by side on a planar surface. In contrast, a 3D Stacked FET vertically stacks the two transistors. This approach enables more transistors to be integrated within the same footprint, offering a new pathway for advancing the scaling of next-generation logic devices.针对这一挑战，一个颇具前景的解决方案是3D堆叠场效应晶体管。在传统设计中，N型和P型晶体管并排放置在一个平面上。相比之下，3D堆叠场效应晶体管将这两种晶体管垂直堆叠。这种方案能在相同的芯片面积内集成更多晶体管，为推动下一代逻辑器件的微缩发展开辟了新路径。

![Evolution of transistor architectures: Planar FET → FinFET → GAA → 3D Stacked FET](https://image.semiconductor.samsung.com/image/samsung/p6/semiconductor/newsroom/20260616-gaa/finfet-contents-01.png?$ORIGIN_PNG$)

\[Figure 1\] Evolution of transistor architectures: Planar FET → FinFET → GAA → 3D Stacked FET

### 2\. Why stack vertically? 2. 为何要垂直堆叠？

In conventional logic circuits, n-type and p-type transistors are arranged side by side on the same plane. This architecture has been used successfully for decades and has played a critical role in enabling today’s high-performance semiconductor devices. However, as the demand for higher transistor density continues to increase, this planar arrangement faces growing limitations.在传统逻辑电路中，N型和P型晶体管并排布置在同一平面上。这种架构已成功应用数十年，并在打造当今高性能半导体器件方面发挥了关键作用。然而，随着对晶体管更高密度的需求持续增长，这种平面布局面临的局限性也日益凸显。

A city provides a useful analogy. When available land becomes scarce, urban planners initially reduce the spacing between buildings and use roads and open spaces more efficiently. Eventually, however, further horizontal expansion becomes impractical. At that point, the solution is to build upward. High-rise buildings create more usable space on the same piece of land by utilizing the vertical dimension.一个城市可以提供一个很贴切的类比。当可利用的土地变得稀缺时，城市规划者首先会缩小建筑间距，更高效地利用道路和开放空间。然而，最终进一步的横向扩张会变得不切实际。到那时，解决办法就是向上建造。高层建筑通过利用垂直空间，在同一块土地上创造出更多可用面积。

Logic devices face a similar challenge. Arranging n-type and p-type transistors side by side can only achieve a certain level of density. By stacking them vertically, more transistors can be accommodated within the same chip area.逻辑器件面临着类似的挑战。将n型和p型晶体管并排排列只能达到一定的密度水平。通过垂直堆叠它们，在相同的芯片面积内可以容纳更多的晶体管。

In other words, 3D Stacked FETs extend transistor placement from the two-dimensional plane into the vertical dimension.换句话说，3D 堆叠场效应晶体管将晶体管的布局从二维平面延伸到了垂直维度。

The GAA architecture naturally supports this transition toward three-dimensional integration. Because GAA devices employ nanosheet channels that can be formed in multiple layers, they provide a technological foundation for stacking and controlling channels vertically. In this sense, 3D Stacked FETs are not a completely different technological direction from GAA; rather, they can be viewed as the next evolutionary step that extends the GAA platform into the third dimension.全环绕栅极（GAA）架构天然支持向三维集成的这一转型。由于全环绕栅极器件采用可多层形成的纳米片沟道，它们为垂直堆叠和控制沟道提供了技术基础。从这个意义上来说，三维堆叠场效应晶体管并非与全环绕栅极截然不同的技术方向，反而可被视为将全环绕栅极平台拓展至三维空间的下一个演进阶段。

![Comparison between planar n-type/p-type transistor placement and vertically stacked transistor placement ](https://image.semiconductor.samsung.com/image/samsung/p6/semiconductor/newsroom/20260616-gaa/finfet-contents-02.png?$ORIGIN_PNG$)

\[Figure 2\] Comparison between planar n-type/p-type transistor placement and vertically stacked transistor placement

### 3\. Three key challenges in building a 3D stacked FET3. 构建3D堆叠场效应晶体管的三大关键挑战

At first glance, the concept of a 3D Stacked FET may appear straightforward. It seems as though the solution is simply to stack transistors on top of one another. In practice, however, implementing such a structure requires overcoming several significant technical challenges.乍一看，3D 堆叠场效应晶体管的概念似乎很简单，仿佛只需将晶体管层层堆叠即可解决问题。但在实际应用中，构建这样的结构需要克服多项重大技术挑战。

There are three major challenges: 存在三大主要挑战：

First, sufficient current conduction paths must be secured.首先，必须确保有足够的电流传导路径。

Second, multiple channel layers must be formed uniformly and with high crystalline quality.第二，需均匀形成多个沟道层并保证其具备高结晶质量。

Third, the upper and lower transistors must be electrically isolated from one another.第三，上层和下层晶体管必须相互实现电气隔离。

This research presents technological solutions to each of these challenges.本研究针对上述每一项挑战都提出了技术解决方案。

**3-1. Expanding the current path: Triple-stacked nanosheet channels 3-1. 拓展电流通路：三层堆叠纳米片沟道**

The channel is the pathway through which current flows in a transistor. If the channel width is insufficient, the transistor may not be able to deliver the required drive current when switched on, potentially limiting device performance.沟道是电流在晶体管中流动的通路。如果沟道宽度不足，晶体管在导通时可能无法提供所需的驱动电流，从而可能限制器件性能。

A 3D Stacked FET offers significant advantages in reducing transistor footprint. However, while reducing area, it must also maintain sufficient current-carrying capability.3D堆叠场效应晶体管在减小晶体管面积方面具有显著优势。然而，在减小面积的同时，它还必须保持足够的载流能力。

One of the key achievements of this work is the implementation of triple-stacked nanosheet channels in both the n-type and p-type transistors while vertically integrating them. By stacking multiple nanosheet channels, the effective channel width can be maintained even within a highly compact footprint.这项工作的关键成果之一，是在n型和p型晶体管中均实现了三层纳米片沟道的集成，并对二者进行了垂直整合。通过堆叠多个纳米片沟道，即便在极高紧凑的尺寸内，也能保持有效的沟道宽度。

This demonstrates that 3D Stacked FETs can provide not only higher density but also sufficient current drive capability within a vertically integrated architecture.这表明3D堆叠场效应晶体管不仅能在垂直集成架构中实现更高的集成密度，还能具备足够的电流驱动能力。

![Cross-sectional view of the 3D Stacked FET structure](https://image.semiconductor.samsung.com/image/samsung/p6/semiconductor/newsroom/20260616-gaa/finfet-contents-03.png?$ORIGIN_PNG$)

\[Figure 3\] Cross-sectional view of the 3D Stacked FET structure

**3-2. Creating high-quality current paths: Advanced epitaxial growth for uniform silicon crystal layers 3-2. 构建高质量电流通路：用于均匀硅晶体层的先进外延生长技术**

Channel width alone does not determine transistor performance. Even a wide current path can suffer from degraded electrical performance if it contains defects or structural irregularities.仅沟道宽度本身并不能决定晶体管的性能。即便电流通路很宽，若其中存在缺陷或结构不规则，其电气性能也会下降。

In a multi-layer nanosheet architecture, channel quality becomes even more critical. Small variations in thickness, shape, or crystal quality between layers can lead to non-uniform current flow, ultimately affecting device performance and variability.在多层纳米片架构中，沟道质量变得更为关键。层与层之间在厚度、形状或晶体质量上的微小差异，都会导致电流分布不均，最终影响器件性能与稳定性。

The situation is similar to a highway. Even if the road is wide, traffic cannot flow smoothly if the surface is uneven or if the lane widths vary significantly from one section to another.这一情况类似于高速公路。即便路面宽阔，但若路面不平坦，或不同路段的车道宽度差异显著，车流也无法顺畅通行。

The same principle applies to transistor channels. Uniform channel dimensions and high crystal quality are essential for stable current transport.同样的原理也适用于晶体管沟道。均匀的沟道尺寸和高晶体质量是稳定电流传输的关键。

In GAA devices, nanosheet channels are formed by growing thin silicon-based crystal layers. In this work, the epitaxial growth process was precisely optimized to achieve highly uniform and defect-free nanosheet channels across multiple stacked layers.在全环绕栅极（GAA）器件中，纳米片沟道是通过生长硅基薄膜晶体层形成的。本研究对外延生长工艺进行了精准优化，在多层堆叠结构上实现了高均匀性且无缺陷的纳米片沟道。

This achievement goes beyond simply stacking channels. It demonstrates the ability to maintain consistent channel quality throughout the entire structure, providing a critical foundation for the performance and uniformity of future 3D Stacked FET technologies.这一成就并非简单的通道堆叠，它展现了在整个结构中保持通道质量一致的能力，为未来3D堆叠场效应晶体管技术的性能与一致性奠定了关键基础。

![Comparison of crystal layer uniformity](https://image.semiconductor.samsung.com/image/samsung/p6/semiconductor/newsroom/20260616-gaa/finfet-contents-04.png?$ORIGIN_PNG$)

\[Figure 4\] Comparison of crystal layer uniformity

**3-3. Separating the upper and lower transistors: Middle Dielectric Isolation (MDI) 3-3. 分离上下晶体管：中间介质隔离（MDI）**

Another key technology in 3D Stacked FETs is the ability to clearly separate the upper and lower transistors.3D 堆叠场效应晶体管的另一项关键技术是能够清晰区分上层和下层晶体管。

An apartment building provides a useful analogy. Although all residents share the same building, each floor is separated by ceilings and floors that reduce interference between occupants. Without this separation, noise and disturbances would easily travel between floors.一栋公寓楼就是一个很贴切的类比。虽然所有住户共用同一栋楼，但每一层都由天花板和地板隔开，减少了住户之间的干扰。如果没有这种分隔，噪音和干扰很容易在各楼层之间传播。

The same principle applies to 3D Stacked FETs. Because the upper and lower transistors are positioned extremely close to one another, a dedicated isolation structure is required to prevent unwanted electrical interaction. This role is fulfilled by the Middle Dielectric Isolation (MDI) layer.同样的原理也适用于3D堆叠场效应晶体管。由于上下两个晶体管的位置非常接近，需要专门的隔离结构来防止不必要的电干扰。中介质隔离（MDI）层承担了这一作用。

The MDI is more than a simple insulating layer. It serves as a critical boundary that separates the upper and lower transistors and provides a structural reference for forming the gate stacks of each device.MDI 不仅仅是一层简单的绝缘层。它作为一道关键边界，将上下晶体管分隔开来，并为每个器件形成栅叠层提供结构参考。

N-type and p-type transistors require different electrical characteristics and therefore different gate materials. In conventional planar layouts, these devices can be separated laterally during fabrication. In a vertically stacked architecture, however, the two devices are positioned directly above and below one another, making precise control of the MDI location and thickness essential.N型和P型晶体管需要不同的电气特性，因此需要不同的栅极材料。在传统的平面布局中，这些器件可在制造过程中进行横向分离。然而，在垂直堆叠架构中，这两种器件彼此直接上下排列，因此对金属-栅极-介质-绝缘体（MDI）的位置和厚度进行精确控制至关重要。

If the MDI layer is too thin or improperly positioned, electrical coupling between the upper and lower transistors may occur. Conversely, if the layer is too thick or non-uniform, it may complicate the formation of the gate structures required for each transistor.如果MDI层过薄或位置不当，可能会在上、下晶体管之间产生电耦合。反之，如果该层过厚或不均匀，则可能使每个晶体管所需栅极结构的形成过程变得复杂。

For this reason, MDI can be considered just as important as the stacking technology itself. In a 3D Stacked FET, success depends not only on the ability to stack devices, but also on the ability to separate them with precision.基于这一原因，MDI 可被视为与堆叠技术本身同等重要。在三维堆叠场效应晶体管中，成功不仅取决于堆叠器件的能力，还取决于精准分离它们的能力。

![Cross-sectional view of a 3D Stacked FET structure](https://image.semiconductor.samsung.com/image/samsung/p6/semiconductor/newsroom/20260616-gaa/finfet-contents-05.png?$ORIGIN_PNG$)

\[Figure 5\] Cross-sectional view of a 3D Stacked FET structure

### 4\. Toward denser 3D stacked FETs 4. 迈向更密集的3D堆叠场效应晶体管

One particularly significant achievement of this work is the demonstration of a 3D Stacked FET with a gate pitch of just 42 nm. Gate pitch refers to the distance between neighboring gates, and reducing this distance enables higher transistor density.这项研究的一项尤为重要的成果是展示出了栅极间距仅为42纳米的3D堆叠场效应晶体管。栅极间距指的是相邻栅极之间的距离，减小这一距离能够实现更高的晶体管密度。

As the gate pitch shrinks, however, fabrication becomes increasingly challenging. Channels, gates, source/drain regions, isolation layers, and contact structures must all be formed with exceptional precision within a very limited space.然而，随着栅极间距不断缩小，制造的难度也日益增加。沟道、栅极、源/漏区、隔离层以及接触结构都必须在极其有限的空间内以极高的精度完成制备。

The challenge is even greater for 3D Stacked FETs. In addition to conventional planar scaling, these devices require precise vertical stacking and isolation of transistors.对于3D堆叠场效应晶体管而言，挑战甚至更大。除了传统的平面缩放外，这些器件还需要对晶体管进行精确的垂直堆叠与隔离。

Demonstrating a 42 nm gate-pitch 3D Stacked FET therefore represents more than the introduction of a new transistor architecture. It provides evidence that 3D Stacked FETs are evolving into a practical technology pathway for next-generation logic devices.展示出42纳米栅极间距的3D堆叠场效应晶体管，其意义远不止于引入一种全新的晶体管架构。这也证明了3D堆叠场效应晶体管正逐步成为下一代逻辑器件的实用技术路径。

![3D Stacked FET Wafer Cross Section (TEM)](https://image.semiconductor.samsung.com/image/samsung/p6/semiconductor/newsroom/20260616-gaa/finfet-contents-06.png?$ORIGIN_PNG$)

\[Figure 6\] 3D Stacked FET Wafer Cross Section (TEM)

### 5\. Demonstrating current control and device uniformity5. 实现电流控制与器件均匀性

Ultimately, the primary role of a transistor is to control electrical current. When turned off, leakage current must remain minimal. When turned on, sufficient current must flow to support circuit operation. Equally important, these characteristics must be consistently maintained across many devices on the same wafer.归根结底，晶体管的主要作用是控制电流。晶体管关断时，漏电流必须保持在极低水平；导通时，必须有足够的电流通过以支持电路运行。同样重要的是，这些特性必须在同一晶圆上的众多器件中保持一致。

In this study, the researchers demonstrated the current-control characteristics of both n-type and p-type transistors within a 42 nm gate-pitch 3D Stacked FET.在本研究中，研究人员展示了栅极间距为42纳米的三维堆叠场效应晶体管中n型和p型晶体管的电流控制特性。

![Current-control characteristics of the 3D Stacked FET](https://image.semiconductor.samsung.com/image/samsung/p6/semiconductor/newsroom/20260616-gaa/finfet-contents-07.png?$ORIGIN_PNG$)

\[Figure 7\] Current-control characteristics of the 3D Stacked FET

In addition, the team evaluated device uniformity by comparing the electrical characteristics of multiple devices across the wafer. Uniformity is a critical requirement for semiconductor manufacturing because practical chip production depends on millions—or even billions—of transistors exhibiting consistent behavior.此外，该团队通过对比整个晶圆上多个器件的电气特性来评估器件均匀性。均匀性是半导体制造的关键要求，因为实际的芯片生产依赖于数百万甚至数十亿个晶体管表现出一致的性能。

![Electrical performance variation and process impact in 3D Stacked FETs](https://image.semiconductor.samsung.com/image/samsung/p6/semiconductor/newsroom/20260616-gaa/finfet-contents-08.png?$ORIGIN_PNG$)

\[Figure 8\] Electrical performance variation and process impact in 3D Stacked FETs  
a) Impact of source/drain epitaxy on Ioff–IDsat characteristics  
b) Impact of bottom source/drain etch profile on Ioff–VTlin characteristics

### 6\. Not the end of GAA, but its 3D evolution6. 并非GAA的终点，而是其三维演进

GAA represented a major innovation in transistor architecture, enabling superior electrostatic control of the channel. 3D Stacked FETs build upon that foundation by extending the GAA concept into the vertical dimension.全环绕栅极（GAA）是晶体管架构中的一项重大创新，能够对沟道实现更优异的静电调控。3D 堆叠场效应晶体管（3D Stacked FETs）则在此基础上，将全环绕栅极（GAA）的设计理念拓展至垂直维度。

Logic technology is now moving beyond the challenge of simply making individual transistors smaller. Engineers must also determine how to arrange n-type and p-type transistors more efficiently, how to form multiple channel layers with high uniformity, and how to isolate vertically stacked devices with precision.逻辑技术如今已不再局限于单纯缩小单个晶体管的尺寸这一挑战。工程师们还必须解决如何更高效地布置N型和P型晶体管、如何形成高均匀性的多沟道层，以及如何精准隔离垂直堆叠器件等问题。

Through the demonstration of a 42 nm gate pitch, triple-stacked nanosheet channels, advanced epitaxial growth processes, Middle Dielectric Isolation (MDI), and validated electrical performance, this work highlights the technological potential of 3D Stacked FETs as a key enabler for future logic technologies.通过对42纳米栅极间距、三层堆叠纳米片沟道、先进外延生长工艺、中间介质隔离（MDI）以及经验证的电气性能的展示，本研究凸显了3D堆叠场效应晶体管作为未来逻辑技术关键支撑技术的技术潜力。

The future of logic semiconductors is no longer confined to a two-dimensional plane. The stage for innovation is now expanding into the third dimension.逻辑半导体的未来不再局限于二维平面，创新的舞台正不断向三维空间延伸。

- #GAA #GAA
- #3DSFET #3DSFET
- #Foundry #代工

What’s Next

- ![SAFE Forum US](https://image.semiconductor.samsung.com/image/samsung/p6/semiconductor/newsroom/20260615-safe-2026-post-event/safeforum2026-article-4x3.png?$ORIGIN_PNG$)
	SAFE Forum US

![](chrome-extension://dbjibobgilijgolhjdcbdebjhejelffo/assets/icon.png)<iframe allow="clipboard-write; web-share" src="chrome-extension://cnjifjpddelmedmihgijeibhnjfabmlf/side-panel.html?context=iframe"></iframe>