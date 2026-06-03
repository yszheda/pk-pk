---
title: "The Unreasonable Redundancy of Nature's Protein Folds"
source: "https://research.ligo.bio/posts/unreasonable-redundancy-of-natural-protein-folds/"
author:
published:
created: 2026-06-03
description: "A Ligo research note on redundancy in natural protein fold space and what kind of data still carries signal."
tags:
  - "ToRead"
---
## The Unreasonable Redundancy of Nature's Protein Folds自然蛋白质折叠的不合理冗余

Over the last few years, deep neural networks have made generative language modeling dramatically more powerful, giving us large language models. A similar leap happened for continuous modalities like images and videos. Recently, similar techniques have been applied to the generative modeling of biomolecules with great success. Models such as DeepMind's AlphaFold3 made it much easier to predict biomolecular interactions, including drug-protein and antibody-protein complexes, and soon after people figured out how to re-purpose these capabilities to design drug-like molecules.  
在过去的几年里，深度神经网络使生成式语言建模的能力大大增强，给了我们大型语言模型。对于图像和视频等连续模态也发生了类似的飞跃。最近，类似的技术被成功应用于生物分子的生成式建模。DeepMind 的 AlphaFold3 等模型使预测生物分子相互作用变得更加容易，包括药物-蛋白质和抗体-蛋白质复合物，不久之后人们就发现了如何重新利用这些能力来设计药物类分子。 In the near future, we might see most antibodies entering the clinic designed in large part with deep-learning-based generative models, potentially with superior pharmaceutical properties and targeting receptors that have resisted wet-lab based approaches.  
在不久的将来，我们可能会看到大多数抗体进入临床，这些抗体在很大程度上是由基于深度学习的生成模型设计的，可能具有更优越的药物特性，并靶向那些传统湿实验室方法难以应对的受体。

How would you improve on these systems? We definitely want to have better biomolecular modeling so we can put better drugs into the clinic. The recipe for improving a deep learning system has been surprisingly simple at a high level: you scale the model, scale the compute, and scale the data. LLMs are obviously improving by being scaled aggressively. AlphaFold3 was also a major effort to scale the model and data; it is trained on a broad collection of known biomolecular complexes, from experimental structures and protein-ligand complexes to the enormous sequence databases produced by genomics and metagenomics such as MGnify. Internally, DeepMind called the project "all-PDB" for a while, referring to all the interactions represented in the Protein Data Bank.  
你如何改进这些系统？我们确实希望拥有更好的生物分子建模，以便将更好的药物投入临床。改进深度学习系统的高层次食谱出人意料地简单：你扩展模型规模，扩展计算规模，扩展数据规模。LLM 显然通过激进地扩展规模在改进。AlphaFold3 也是一个大规模扩展模型和数据的主要努力；它是在广泛的已知生物分子复合物上训练的，从实验结构和蛋白质-配体复合物到由基因组学和宏基因组学产生的庞大序列数据库，如 MGnify。在内部，DeepMind 将该项目称为“all-PDB”一段时间，指的是蛋白质数据银行中代表的所有相互作用。

The key move in AlphaFold3's scaling recipe was to turn sequence scale into structure scale: use structure prediction to convert large protein sequence databases into predicted 3D structures. Genomics and metagenomics have given us billions of protein sequences, many inferred from environmental DNA collected from organisms that have never been cultured in the lab. For training structure-based design models, though, the useful object is often the 3D structure. Structure prediction models let us convert some of that sequence scale into structural data: take millions of natural sequences, predict the folds they adopt, and use those predicted structures as training examples for the next generation of biomolecular models.  
AlphaFold3 的扩展秘诀中的关键步骤是将序列尺度转化为结构尺度：利用结构预测将大型蛋白质序列数据库转换为预测的 3D 结构。基因组学和宏基因组学为我们提供了数十亿个蛋白质序列，其中许多是从环境中收集的 DNA 推断而来，而这些 DNA 来自从未在实验室中培养的生物体。然而，对于训练基于结构的模型而言，有用的对象往往是 3D 结构。结构预测模型让我们可以将部分序列尺度转化为结构数据：取数百万个天然序列，预测它们所采取的折叠方式，并使用这些预测结构作为下一代生物分子模型的训练示例。

At Ligo, we care about this recipe because we train generative models for designing enzymes. When we tried to scale our structural training data by folding more natural sequences, we ran into a problem: natural protein sequences are vast, but their folds are much more redundant than the sequence counts suggest. This post is about that mismatch, and about why simply folding more natural sequences may not buy as much new structural diversity as we hoped. We will describe data engineering tricks for clustering the known protein universe, and what our results imply about how to think about the enzyme design problem.  
在 Ligo，我们关心这个配方，因为我们训练生成模型来设计酶。当我们尝试通过折叠更多天然序列来扩展我们的结构训练数据时，我们遇到了一个问题：天然蛋白质序列非常庞大，但它们的折叠比序列计数所显示的冗余得多。这篇帖子是关于这种不匹配，以及为什么简单地折叠更多天然序列可能不会像我们希望的那样带来新的结构多样性。我们将描述用于对已知蛋白质宇宙进行聚类的数据工程技巧，以及我们的结果对我们如何思考酶设计问题意味着什么。

## Modern biomolecular models rely on sequence scale现代生物分子模型依赖于序列规模

Modern structure prediction models rely heavily on multiple sequence alignments. A multiple sequence alignment, or MSA, lines up related versions of a protein from different organisms. When two positions in that alignment tend to change together,  
现代结构预测模型高度依赖多重序列比对。多重序列比对（MSA）是将来自不同生物体的相关蛋白质版本排列在一起。当比对中的两个位置倾向于一起变化时， it can be a clue that the corresponding residues are close in 3D space or tied together by function. My mental model of AlphaFold2 is that it used this kind of coevolutionary signal to constrain the rough geometry of a protein, then learned how to fill in the rest of the structure.  
它可能是一个线索，表明相应的残基在 3D 空间中靠近或由功能联系在一起。我对 AlphaFold2 的理解是，它利用这种协同进化的信号来约束蛋白质的粗略几何形状，然后学习如何填充剩余的结构。

AlphaFold3 seems to be doing something broader. Its antibody-antigen performance is especially interesting because there are no MSAs to extract clues from. Antibodies and their targets do not share an evolutionary history. To do well there, the model has to learn something about protein surfaces themselves: which shapes, chemistries, and local geometries are likely to be compatible with each other. That is a different kind of signal than residue coevolution within one protein family.  
AlphaFold3 看起来在做更广泛的事情。它在抗体-抗原方面的表现特别有趣，因为没有可用来提取线索的 MSA。抗体及其靶点没有共享进化历史。要在这一方面做得好，模型必须学习关于蛋白质表面本身的东西：哪些形状、化学性质和局部几何形状可能彼此兼容。这是一种不同于一个蛋白质家族内残基协同进化的信号。

This is where MGnify-scale data may matter. Metagenomic sequence resources expose models to enormous numbers of natural variants, many from organisms we have never cultured. The empirical clue is that models trained with MGnify-scale protein distillation seem to separate most clearly on antibody-antigen prediction, where direct coevolution cannot explain the interaction signal ([Supplementary info](#supplementary-interface-benchmarks)). That increased coverage of sequence space looks valuable. The question is whether it also comes with comparable diversity in protein folds.  
这是 MGnify 规模数据可能产生影响的领域。宏基因组序列资源让模型接触到大量的天然变异体，其中许多来自我们从未培养过的生物体。经验性线索是，使用 MGnify 规模蛋白质蒸馏训练的模型似乎在抗体-抗原预测上表现出最清晰的分离，而直接协同进化无法解释这种相互作用信号（补充信息）。序列空间的覆盖范围增加看起来很有价值。问题是它是否也带来了蛋白质折叠的可比多样性。

## Sequence diversity is not fold diversity序列多样性不等于折叠多样性

The theoretical protein sequence space is absurdly large: a protein of length N has 20 <sup>N</sup> possible amino-acid sequences. Natural proteins occupy only a tiny, highly structured part of that space. Evolution tends to reuse folds that are stable, expressible, and adaptable, rather than scattering proteins uniformly across every possible sequence and shape.  
理论上的蛋白质序列空间是极其庞大的：长度为 N 的蛋白质有 20^N 种可能的氨基酸序列。天然蛋白质仅占据该空间中极小、高度结构化的部分。进化倾向于重复利用稳定、可表达和适应性强的折叠结构，而不是将蛋白质均匀地分散到每一种可能的序列和形状中。

That matters for training data. When we scale predicted structures, we are not necessarily adding independent examples. We may also be adding many sequence variants of the same fold families, domain combinations, and evolutionary compromises. The example below shows the basic problem: proteins can look far apart when measured by sequence similarity, while still being very close in fold space.  
那对于训练数据很重要。当我们扩展预测结构时，我们不一定是在添加独立的例子。我们可能还会添加很多相同折叠家族、结构域组合和进化妥协的序列变体。下面的例子展示了基本问题：当通过序列相似性测量时，蛋白质看起来可能相距很远，而实际上在折叠空间中仍然非常接近。

One concrete example from our AFDB fragment clusters: in structural cluster `A0A242HMU2_f1`, three proteins are only 23.9–28.3% identical in sequence while still sharing the same fold (TM-score > 0.75).  
我们 AFDB 片段簇的一个具体例子：在结构簇 `A0A242HMU2_f1` 中，三个蛋白质在序列上只有 23.9–28.3%的相同性，但仍然共享相同的折叠（TM-score > 0.75）。

| Fragment 片段 | UniProt annotation UniProt 注释 | Length 长度 | Seq. id. to rep.   序列 ID 到代表 | TM to rep.TM 代表 |
| --- | --- | --- | --- | --- |
| `A0A518BRX6_f1` | 3-oxoacyl-\[acyl-carrier-protein\] reductase FabG, Bacteria   3-氧代酰基-\[酰基-载体蛋白\]还原酶 FabG，细菌 | 249 aa | 100% | 1.000 |
| `A0A1Q3EPK1_f1` | NAD-binding protein, *Lentinula edodes*   NAD 结合蛋白，云芝 | 283 aa | 28.2% | 0.768 |
| `A0A6I8MDZ6_f1` | Short-chain dehydrogenase/reductase SDR, *Oceanivirga miroungae*   短链脱氢酶/还原酶 SDR，Oceanivirga miroungae | 261 aa 261 个氨基酸 | 23.9% | 0.793 |

### Same fold, low sequence identity相同折叠，低序列相似性

Three AFDB predictions from the same structural cluster, aligned with local TM-align.  
来自同一结构簇的三条 AFDB 预测，与本地 TM-align 对齐。

`A` FabG reductase FabG 还原酶 `B` SDR protein SDR 蛋白 `C` clipped NAD-binding core 剪切的 NAD 结合核心

Aligned fold overlay ready.

The NAD-binding protein was clipped to residues 201-483 before alignment. The removed N-terminal tail had mean pLDDT 31.9, while the retained core has mean pLDDT 91.3. The overlay uses A0A518BRX6 as the reference frame.  
NAD 结合蛋白在比对前被切割为 201-483 残基。被移除的 N 端尾部平均 pLDDT 为 31.9，而保留的核心部分平均 pLDDT 为 91.3。叠加图使用 A0A518BRX6 作为参考框架。

As we scale up our sequence datasets, how many genuinely new folds should we expect to see? If MGnify grew 10x, how many of those new sequences would actually be structurally novel?  
随着我们扩展序列数据集，我们应该期待看到多少真正的新折？如果 MGnify 增长了 10 倍，其中有多少新序列实际上是结构上新颖的？

To answer this systematically across the whole space, we need a scalable clustering algorithm. Foldseek is a brilliant tool for this, and its authors have already clustered the AlphaFold Database with it, [reporting 2.3 million non-singleton structural clusters](https://www.nature.com/articles/s41586-023-06510-w). But there are real issues with clustering predicted structures, and the clustering problem itself is ill-posed. We think the true number of reusable structural neighborhoods **is much closer to tens of thousands than to the 2.3 million non-singleton clusters reported by that fast Foldseek pass** — closer to 25,000 than 2.3 million in our current analysis. Here's the reasoning.  
要系统地在整个空间中回答这个问题，我们需要一个可扩展的聚类算法。Foldseek 是一个出色的工具，其作者已经使用它对 AlphaFold 数据库进行了聚类，报告了 230 万个非单例结构簇。但预测结构的聚类存在实际问题，聚类问题本身也是不适定的。我们认为可重用的结构邻域的真实数量远接近于数万，而不是 230 万个非单例簇——在我们当前的分析中，更接近于 2.5 万而不是 230 万。以下是理由。

## The predicted-structure problem for clustering聚类预测结构问题

Predicted structures are different from crystals. The sequences and MSAs are real, but the structures are missing context, and AlphaFold will predict the whole chain: ordered domains, floppy tails, long linkers, signal peptides, and multi-domain proteins whose relative placement may not be meaningful.  
预测结构不同于晶体。序列和 MSAs 是真实的，但结构缺少上下文，AlphaFold 将预测整个链：有序结构域、柔性尾部、长连接器、信号肽和多结构域蛋白，其相对位置可能没有意义。

This makes the clustering problem ill-posed. Are two proteins the same fold because one domain matches? Are they different because one has a disordered extension?  
这使得聚类问题不明确。两个蛋白因为一个结构域匹配而相同折叠？因为一个有无序延伸而不同？

The shape of predicted structures is also a problem for training generative models on this data. You don't want to waste model capacity fitting disordered regions, and you don't want to learn to generate bizarre, elongated chains. You could filter on global pLDDT, radius of gyration, and similar whole-chain metrics, but those filters are too crude for data shaped like this — they throw out good domains attached to bad tails. We need a more surgical way to keep the signal and drop the noise.  
预测结构的形状也对在这个数据上训练生成模型构成问题。你不想浪费模型容量去拟合无序区域，也不想学习生成奇怪的、细长的链。你可以根据全局 pLDDT、回转半径和类似的整个链指标进行过滤，但对于这种形状的数据来说，这些过滤器过于粗糙——它们会丢弃连接在坏尾巴上的好结构域。我们需要一种更外科手术式的方法来保留信号并去除噪声。

### Predicted chains are not clean domains预测的链不是干净的域

very high 非常高 confident 自信 low 低 very low 非常低

`A0A5B2Z7Q7`, ArsR-family transcriptional regulator  
`A0A5B2Z7Q7`, ArsR 家族转录调控因子

AFDB prediction ready.

`P38398-3`, breast cancer type 1 susceptibility protein isoform (BRCA1)  
`P38398-3` ，乳腺癌类型 1 易感蛋白异构体（BRCA1）

AFDB prediction ready.

## First pass: remove the obvious noise第一遍：去除明显的噪音

Our first attempt was simple. Remove residues below a pLDDT threshold, split what remains into contiguous sequence fragments, and then spatially rejoin fragments that are clearly touching. The rejoin step is a union-find problem: if fragment A touches B, and B touches C, then A, B, and C become one connected fragment.  
我们的第一次尝试很简单。移除低于 pLDDT 阈值的残留物，将剩余部分分成连续的序列片段，然后空间上重新连接明显接触的片段。重新连接步骤是一个并查集问题：如果片段 A 接触 B，并且 B 接触 C，那么 A、B 和 C 就变成一个连接的片段。

- Residues below pLDDT 65 are marked as unusable.  
	低于 pLDDT 65 的残留物被标记为不可用。
- Remaining residues become contiguous sequence fragments.  
	剩余的残留物变成连续的序列片段。
- Fragments with enough close contacts are merged spatially.  
	具有足够密切接触的片段被空间上合并。
- The resulting candidates can then be filtered before clustering.  
	结果候选者可以在聚类之前进行过滤。

This gets rid of a lot of obvious disorder. It also keeps ordered domains that global filters would throw away because the full protein looked too long, too extended, or too messy.  
这可以去除很多明显的无序性。它还保留了全局过滤器会丢弃的有序域，因为完整的蛋白质看起来太长、太延伸或太混乱。

**Limitations of naive fragmentation.** The obvious failure mode is a high-confidence linker. If the linker survives the pLDDT filter and makes enough contacts, the spatial merge can connect two domains that we would rather treat separately. Union-find then does exactly what it was asked to do: it turns the connected chain into one fragment.  
朴素片段化的局限性。明显的失效模式是高置信度的连接器。如果连接器在 pLDDT 过滤器中幸存下来，并且形成足够的接触，空间合并可以将两个我们宁愿分开处理的域连接起来。并查集然后准确地完成了它被要求做的事情：将连接的链转换成一个片段。

The problem is that this is not really a local-confidence question. The residues can be predicted confidently and still be the wrong unit of training. What we need to detect is the bottleneck in the spatial graph: the narrow path that connects otherwise independent pieces.  
这个问题不完全是关于局部置信度的问题。残基可以被有信心地预测，但仍然可能是错误的训练单位。我们需要检测的是空间图中的瓶颈：连接原本独立部分的狭窄路径。

### A0A0E0RCK4 first pass A0A0E0RCK4 首次通过

The full chain is kept intact; fragments shorter than 20 residues are left unnumbered.  
整个链保持完整；长度小于 20 个残基的片段将不编号。

First-pass coloring ready.

pLDDT < 65 pLDDT<65 fragment 1 (178 aa) 片段 1 (178 个氨基酸) fragment 2 (196 aa) 片段 2 (196 个氨基酸)

## The graph-theoretic split图论中的分裂

We need a way to split proteins based on how the residues are connected to each other. For that, a protein is naturally a graph: each residue is a node, and edges connect residues that are close in space. We use C-alpha atoms from the confident part of the prediction, connect each residue to its spatial nearest neighbors, and give close neighbors stronger weights than distant ones. In the current version, each residue sees its 15 nearest spatial neighbors.  
我们需要一种根据残基之间的连接方式来分割蛋白质的方法。为此，蛋白质自然可以被视为一个图：每个残基是一个节点，边连接在空间上接近的残基。我们使用预测中置信度较高的 C-alpha 原子，将每个残基与其空间上最近的邻居连接起来，并给予接近的邻居比远的邻居更强的权重。在当前版本中，每个残基可以看到其 15 个最近的 spatial 邻居。

This turns the fragmentation problem into a connectivity problem. A compact domain becomes a dense local graph. A high-confidence linker becomes a narrow bridge between two dense regions. Graph theory gives us tools for asking whether that bridge is really part of one unit, or whether it is holding two independent pieces together.  
这把碎片化问题转化为了连接性问题。一个紧凑的域变成了一个密集的局部图。一个高置信度的连接器变成了两个密集区域之间的一个狭窄桥梁。图论为我们提供了工具，让我们能够判断这个桥梁是否真的属于一个整体，或者它是否在将两个独立的部分连接在一起。

### Graph theoretic split of a nearest neighbour protein graph近邻蛋白质图的图论分割

Nearest-neighbor graph ready.

Fiedler vector Fiedler 向量

The protein cartoon is shown in Mol\* green; the overlay is the actual k-nearest-neighbor graph, with each edge colored by the average Fiedler value of its endpoint residues.  
蛋白质卡通以 Mol\*绿色显示；叠加的是实际的 k 近邻图，每条边都由其端点残基的平均 Fiedler 值着色。

Spectral bisection asks for the weakest global connection in this graph (why the quantity we compute finds this connection is a little bit black magic to me, ask the graph theorists). We found that the spectral bisection points of a protein correlate very well with the points we'd cut at if we were manually identifying different protein regions. A standalone version of the splitter is included in [Supplementary info](#supplementary-spectral-split).  
谱二分要求找到这个图中最弱的全局连接（为什么我们计算的量能找到这个连接对我来说有点像黑魔法，问一下图论学家）。我们发现蛋白质的谱二分点与我们手动识别不同蛋白质区域时切割的点非常吻合。分割器的独立版本包含在补充信息中。

### For the curious: the Fiedler vector对于好奇者：Fiedler 向量

Given a weighted adjacency matrix $W$ of a graph, the normalized graph Laplacian is:  
给定图的加权邻接矩阵 $W$ ，归一化图拉普拉斯矩阵为：

$$
L_{\mathrm{sym}} = I - D^{-1/2} W D^{-1/2}
$$

Here $D$ is the diagonal degree matrix. The eigenvectors of $L_{\mathrm{sym}}$ reveal graph structure:  
这里 $D$ 是对角度矩阵。 $L_{\mathrm{sym}}$ 的特征向量揭示图结构：

- The smallest eigenvalue is always 0.  
	最小特征值总是为 0。
- The second smallest eigenvalue, $\lambda_2$, measures algebraic connectivity.  
	第二小的本征值 $\lambda_2$ 衡量代数连通性。
- The corresponding Fiedler vector gives a useful two-way partition: residues with opposite signs sit on opposite sides of the cut.  
	相应的 Fiedler 向量提供了一个有用的双向划分：具有相反符号的残基位于切割的两侧。

This is the same quantity shown on the graph above. The protein is just green context, while the graph edges are colored by the average Fiedler value of their two endpoint residues. Strongly negative edges are blue, strongly positive edges are red, and edges near zero are pale. Those near-zero residues are the bottleneck between the two sides, so those are the residues we remove before assigning fragments.  
这是上图所示的同一种量。蛋白质只是绿色背景，而图边框根据其两个端点残基的平均 Fiedler 值进行着色。强负边框为蓝色，强正边框为红色，接近零的边框为浅色。那些接近零的残基是两侧之间的瓶颈，因此那些就是我们在分配片段之前移除的残基。

### Recursive bisection 递归二分

A single bisection only finds one cut. Multi-domain proteins need repeated cuts, so after each split we check each partition separately. If a partition has `λ<sub>2</sub> > threshold`, we treat it as internally well connected and stop. Otherwise, we split again.  
一个单一的二分法只找到一个切口。多域蛋白需要重复切割，所以在每次分割后我们分别检查每个分区。如果一个分区有 `λ<sub>2</sub> > threshold` ，我们将其视为内部连通并停止。否则，我们再次分割。

### Naive merge versus spectral pipeline朴素合并与谱管道

Both panels load one full-chain CIF; fragments shorter than 20 residues are left unnumbered.  
两个面板都加载一个完整链的 CIF；长度小于 20 个残基的片段保持未编号。

**`A0A0M9EDZ0`** uncharacterized protein, Candidatus Magnetomorum sp. HK-1  
非特征蛋白，候选磁菌属 sp. HK-1 573 residues; mean pLDDT 92.4  
573 个残基；平均 pLDDT 92.4

Naive 朴素 pLDDT + union-find: 1 fragment; largest 568 aa  
pLDDT + 并查集：1 个片段；最大 568 个氨基酸

Fragments ready.

low confidence / cut (5 aa)  
低置信度/切割（5 aa） fragment 1 (568 aa) 片段 1 (568 个氨基酸)

Spectral pipeline 光谱管道 Fiedler + spatial merge: 2 fragments; largest 418 aa  
Fiedler + 空间合并：2 个片段；最大 418 aa

Fragments ready.

low confidence / cut (8 aa)  
低置信度/切割（8 个氨基酸） fragment 1 (418 aa) 片段 1 (418 个氨基酸) fragment 2 (147 aa) 片段 2 (147 个氨基酸)

The right panel shows the current split-then-merge pipeline: spectral bisection first proposes cuts, then spatial clustering re-merges pieces that still look like one compact unit.  
右侧面板显示了当前的分割后合并流程：光谱二分法首先提出切割点，然后空间聚类重新合并仍然看起来像是一个紧凑单元的片段。

## Clustering the fragments对片段进行聚类

Once we split proteins into their "interacting units", the unit of clustering is no longer one predicted protein. It is one compact fragment. We can cluster those fragments by structural similarity and ask how much independent fold signal the distillation sets actually contain.  
一旦我们将蛋白质分割成它们的“相互作用单元”，聚类的单元就不再是一个预测的蛋白质。它是一个紧凑的片段。我们可以通过结构相似性对这些片段进行聚类，并询问这些蒸馏集实际上包含多少独立的折叠信号。

We cluster MGnify at roughly 30% sequence identity with MMseqs2, which gives about 40 million sequence clusters. From there, we discard sequence singletons, then use the [OpenFold3-predicted structures released through the OpenFold datasets portal](https://portal.openfold.omsf.io/datasets) for the remaining MGnify sequences.  
我们使用 MMseqs2 在约 30%的序列相似度下对 MGnify 进行聚类，这产生了大约 4000 万个序列簇。从那里开始，我们丢弃序列单例，然后使用通过 OpenFold 数据集门户发布的 OpenFold3 预测结构，用于剩余的 MGnify 序列。 We fragment those predicted structures and filter the fragments with quality metrics meant to keep examples amenable to training a generative model (we will write more about this in a later post). The structural clustering below starts from the resulting set: about 2 million MGnify fragments.  
我们将预测的结构片段化，并使用旨在保持对生成模型训练友好的质量指标进行过滤（我们将在后续文章中更详细地介绍这一点）。下面的结构聚类从结果集开始：大约 200 万个 MGnify 片段。

[We use Foldseek for the first pass of clustering](#supplementary-foldseek-command). Foldseek's fast mode uses both structural and sequence-derived signals, which is what makes it practical, but also means it can split fragments that are structurally very similar and sequence-divergent.  
我们使用 Foldseek 进行初步聚类。Foldseek 的快速模式同时使用结构和序列衍生的信号，这使得它实用，但也意味着它可以分割结构非常相似但序列差异较大的片段。

### Common pitfall: Foldseek singletons are not always singletons常见陷阱：Foldseek 单体并不总是单体

A Foldseek singleton is not necessarily a new fold. It only means no other fragment crossed the thresholds in that particular Foldseek run. To check this failure mode, we took 1,000 fragments that Foldseek had labeled as singletons and compared them against each other with pairwise TM-score. At TM ≥ 0.8, 373 of those fragments fell into 69 connected components. The largest hidden cluster had 35 members. These were supposed to be singletons.  
一个 Foldseek 单例不一定是新的折叠。它只是意味着在特定的 Foldseek 运行中，没有其他片段跨越了阈值。为了检查这种失败模式，我们选取了 1,000 个 Foldseek 标记为单例的片段，并使用成对 TM 分数将它们相互比较。在 TM ≥ 0.8 的情况下，其中 373 个片段 fell into 69 个连通分量。最大的隐藏簇有 35 个成员。这些本应是单例的。

### Hidden clusters among Foldseek singletonsFoldseek 单例中的隐藏簇

Each panel overlays four fragments that Foldseek had separated into singleton clusters.  
每个面板叠加了 Foldseek 分离成单体的四个片段。

Cluster 6 簇 6 18 singletons · min TMalign TM 0.953–1.000  
18 个单例 · min TMalign TM 0.953–1.000

Singleton overlay ready.

Cluster 11 簇 11 7 singletons · min TMalign TM 0.929–1.000  
7 单例 · min TMalign TM 0.929–1.000

Singleton overlay ready.

Cluster 13 聚类 13 6 singletons · min TMalign TM 0.841–1.000  
6 单例 · min TMalign TM 0.841–1.000

Singleton overlay ready.

Three hidden clusters from a random sample of 1,000 Foldseek-labeled singleton fragments. Each panel shows one representative plus three aligned members from the same TM-score component. Ranges use the lower of the two directional TM-scores reported by `TMalign.cpp`.  
从 1,000 个 Foldseek 标记的单体片段中随机抽取的三个隐藏簇。每个面板显示一个代表性成员和来自同一 TM-score 组件的三个对齐成员。范围使用 `TMalign.cpp` 报告的两个方向 TM-score 中的较低值。

The practical lesson is to be skeptical of the singletons. If we treat every Foldseek singleton as an independent structural mode, we overestimate novelty and give the sampler a distorted picture of fold space. TM-score is much slower, but it is the right ground-truth audit pass when the question is whether two fragments really share a fold.  
实际教学中要对单个结构持怀疑态度。如果我们把每个 Foldseek 单个结构都当作独立的结构模式来处理，我们会高估新颖性，并给采样器一个扭曲的折叠空间图像。TM-score 计算速度较慢，但在判断两个片段是否真正共享折叠结构时，它是正确的真实情况审核步骤。

So we added a second pass over cluster representatives. Instead of comparing every fragment to every other fragment, we compared representatives against representatives with a more structure-centered alignment, then confirmed candidate merges with our TM-align implementation. Merge criterion: min(tm\_norm\_a, tm\_norm\_b) ≥ 0.7. Both directions had to independently confirm fold-level similarity. If two representatives passed that test, we merged their clusters with union-find.  
所以我们增加了一个对簇代表体的二次处理。不再将每个片段与每个其他片段进行比较，而是将代表体与具有更结构中心对齐的代表体进行比较，然后使用我们的 TM-align 实现确认候选合并。合并标准：min(tm\_norm\_a, tm\_norm\_b) ≥ 0.7。两个方向都必须独立确认折叠级别的相似性。如果两个代表体通过了测试，我们就使用并查集合并它们的簇。

1.96M → 25.3K 1.96M→25.3K MGnify fragments → structural clusters  
MGnify 片段 → 结构簇

71.5% of MGnify multi-member fragments are in the top 1,000 clusters  
MGnify 多成员片段中有 top 1,000 簇

64.3% of AFDB multi-member fragments are in the top 1,000 clusters  
AFDB 多成员片段中有 top 1,000 簇

| Dataset 数据集 | Fragments in multi-member clusters   多成员集群中的片段 | Multi-member clusters 多成员集群 | Largest cluster 最大簇 | Top 100 前 100 名 | Top 1,000 前 1,000 名 |
| --- | --- | --- | --- | --- | --- |
| AlphaFold Database AlphaFold 数据库 | 1,592,372 | 30,622 | 20,836 | 26.0% | 64.3% |
| MGnify | 1,961,750 | 25,302 | 41,801 | 29.1% | 71.5% |

These are the results that surprised us. After sequence clustering, fragmentation, quality filtering, and dropping singleton clusters from this summary, MGnify is not two million independent structural examples. The repeated part of the dataset is closer to twenty-five thousand structural neighborhoods, with most of the mass concentrated in a small head of the distribution. The top 1,000 MGnify clusters are only about 4.0% of the multi-member cluster list, but they contain 71.5% of the fragments in those clusters.  
这些是我们感到惊讶的结果。在序列聚类、片段化、质量过滤以及从这份摘要中移除单例簇之后，MGnify 并非两百万个独立的结构示例。数据集的重复部分更接近于两万五千个结构邻域，大部分质量集中在分布的小头部。前 1,000 个 MGnify 簇仅占多成员簇列表的 4.0%，但它们包含了这些簇中 71.5%的片段。

### MGnify is dominated by a small head of clustersMGnify 主要由一小部分簇主导

Singleton clusters are omitted here to focus on the multi-member distribution.  
在此处省略单例簇，以专注于多成员分布。

**1.96M** fragments plotted 绘制了 196 万个片段 **25.3K** multi-member clusters  
25.3K 多成员簇 **71.5%** in the top 1,000  
71.5%位于前 1000 名

#### Cumulative fragment mass累积碎片质量

MGnify cluster-size distribution after removing size-1 clusters from the visualization. The cumulative plot uses the remaining multi-member fragments as its denominator.  
在可视化中移除大小为 1 的簇后，MGnify 簇大小分布。累积图使用剩余的多成员片段作为其分母。

That changes what "sampling from MGnify" means. Sampling fragments uniformly mostly revisits the same common neighborhoods. Sampling clusters uniformly goes too far the other way and gives the smallest repeated neighborhoods too much influence. The sampler needs to live somewhere between those two extremes.  
这意味着“从 MGnify 采样”的含义发生了变化。均匀采样片段主要会重新访问相同的常见邻域。均匀采样簇则走向另一极端，给予最小的重复邻域过多的影响力。采样器需要处于这两者之间的某个位置。

## Sampling from a redundant world从冗余世界采样

If we are training a generative model on MGnify, how should we sample from these clusters? The standard recipe is: pick a cluster uniformly, then pick a member uniformly from inside it. For data this skewed, that overshoots in the opposite direction.  
如果我们在 MGnify 上训练生成模型，应该如何从这些聚类中进行采样？标准方法是：均匀选择一个聚类，然后从其中均匀选择一个成员。对于这种偏斜的数据，这种方法会在相反方向上造成过度采样。 With uniform cluster sampling, the top 1,000 MGnify clusters — which hold 71.5% of multi-member fragments — would be sampled only about 4% of the time.  
使用均匀聚类采样时，排名前 1,000 个 MGnify 聚类——这些聚类包含 71.5% 的多成员片段——的采样频率大约只有 4%。 We instead use a balancing exponent γ (implemented as `cluster_size_exponent`), where the aggregate sampling probability of a cluster scales like N <sup>γ</sup> with N the cluster size. γ = 1 recovers the dataset distribution; γ = 0 weights every cluster equally; values in between trade off natural abundance against fold diversity.  
我们使用一个平衡指数 γ（实现为 `cluster_size_exponent` ），其中簇的聚合采样概率随着簇的大小 N <sup>γ</sup> 而变化。γ = 1 恢复数据集分布；γ = 0 等同地加权每个簇；介于两者之间的值在自然丰度与折叠多样性之间进行权衡。

### Sampling mass under γ-reweightingγ-重加权下的采样质量

Per-cluster aggregate weight scales as N <sup>γ</sup>.  
每个簇的聚合权重按 N <sup>γ</sup> 比例缩放。

**10,462** effective clusters  
10,462 个有效集群 **22.2%** sampling mass in top 1,000  
22.2% 的采样质量在 前 1,000 个

top 10 前 10 名

data 7.05% 数据 7.05% sample 0.81% 样本 0.81%

top 100 前 100 名

data 26.0% 数据 26.0% sample 4.80% 樣本 4.80%

top 1,000 前 1,000 名

data 64.3% 数据 64.3% sample 22.2% 樣本 22.2%

Gray shows how much of the raw dataset sits in the largest clusters. Teal shows how much sampling mass those clusters receive after reweighting. Effective clusters are the inverse-Simpson count, 1 / ∑ <sub>i</sub> p <sub>i</sub> <sup>2</sup>, where p <sub>i</sub> is the sampling mass assigned to cluster i.  
灰色显示了原始数据集中有多少数据位于最大的簇中。蓝绿色显示了这些簇在重新加权后获得的采样质量。有效簇是逆辛普森计数，即 1 / ∑ p <sup>2</sup> ，其中 p 是分配给簇 i 的采样质量。

The right γ depends on what the downstream model is supposed to learn. A generative model trying to *cover* fold space wants lower γ, since it benefits from seeing rare folds more than once per epoch. A folding model trying to *match* natural conditional distributions wants higher γ. We don't have a settled answer, but γ around 0.5 has been a reasonable starting point in our setups — it preserves the head's dominance while flattening the long tail. The effective-cluster count in the figure is a useful sanity check: it's the number of clusters you would need if they were all equally weighted to give the same diversity as your reweighted distribution.  
正确的 γ 取决于下游模型应该学习什么。一个试图覆盖折叠空间的生成模型需要较低的 γ，因为它受益于在每个 epoch 中多次看到稀有折叠。一个试图匹配自然条件分布的折叠模型需要较高的 γ。我们没有一个确定的答案，但在我们的设置中，γ 约为 0.5 是一个合理的起点——它保留了头部的主导地位，同时使长尾变得平坦。图中显示的有效聚类计数是一个有用的 sanity check：如果你需要所有聚类都同等加权，以给出与你的重新加权分布相同的多样性，那么这就是你需要多少个聚类。

## Conclusion 结论

What surprised us is how redundant natural fold space looks once you pick the right unit of clustering. After cleaning up predicted structures, cutting away obvious noise, splitting multi-domain chains, auditing Foldseek singletons, and clustering the resulting fragments, most of the mass sits in a small number of structural neighborhoods. **Natural proteins do not appear to be exploring backbone space uniformly.** They seem to reuse a relatively small set of fold solutions over and over.  
让我们感到惊讶的是，一旦选择了合适的聚类单位，冗余的自然折叠空间看起来是怎样的。在清理预测结构、切除明显的噪声、拆分多域链、审核 Foldseek 单例，并将结果片段聚类后，大部分质量都集中在少数几个结构邻域中。自然蛋白质似乎并没有在骨架空间中均匀地探索。它们似乎反复重用相对较少的一组折叠解决方案。

Natural enzymes often evolve by modifying existing proteins: duplication, divergence, loop changes, active-site mutations, cofactors, metals, and changes in the local environment around a substrate. What surprised us was not that nature reuses folds, but how strongly that reuse shows up once we process predicted structures into training units and cluster them at scale.  
天然酶通常通过修饰现有蛋白质进化：复制、分化、环状结构变化、活性位点突变、辅因子、金属以及底物周围局部环境的变化。让我们惊讶的不是自然界重用折叠结构，而是在我们将预测结构处理成训练单元并大规模聚类后，这种重用表现得多么强烈。

For enzyme design, this leaves two different possibilities. One is the nature-like route: choose a familiar scaffold and learn how to engineer the active-site neighborhood with much higher precision. In that view, the loops, first-shell residues, ligand pose, cofactors, and interaction geometry matter more than making the backbone globally novel. If that is the right regime, then simply adding more natural sequence-derived structures may not help much by itself; it may mostly give us more examples of the same scaffold families.  
在酶设计方面，这留下了两种不同的可能性。一种是类自然路线：选择一个熟悉的骨架，并学习如何以更高的精度来设计活性位点区域。在这种观点下，环、第一层残基、配体姿势、辅因子和相互作用几何形状比使骨架全局新颖更重要。如果这是正确的模式，那么仅仅通过添加更多源于自然序列的结构可能不会有多大帮助；它可能主要只是给我们提供更多相同骨架家族的例子。

The other possibility is more speculative. Evolution is historically constrained; new enzymes do not appear from nowhere, and natural fold space may be shaped by what was easy to reach through duplication and divergence. If design models become good enough, there may be useful backbone space that nature never explored. But that raises a harder question: can models trained mostly on natural folds learn to explore outside the natural fold manifold, or do they inherit the same redundancy we are measuring here?  
另一种可能性更具推测性。进化在历史上受到限制；新的酶并非凭空出现，而自然折叠空间可能是由复制和分化容易达到的区域塑造的。如果设计模型足够好，可能会有自然界从未探索过的有用骨架空间。但这提出了一个更难的问题：主要在自然折叠上训练的模型能否学会探索自然折叠流形之外的区域，或者它们是否会继承我们在此测量的相同冗余？

We will find out in the lab as we try to design enzymes, seeing which designs actually express, fold, and catalyze. More on this later.  
我们将在实验室中尝试设计酶，看看哪些设计能够实际表达、折叠和催化。后面会更多讨论这个话题。

## Supplementary info 补充信息

### Where the MGnify distillation advantage actually shows upMGnify 蒸馏优势实际上体现在哪里

One reason I am suspicious of treating MGnify as just more sequence data: the performance advantage does not appear uniformly across every interface benchmark. It shows up strongly in antibody-antigen prediction, while most of the broader cofolding benchmarks remain closer together. This is not a clean causal experiment — architecture, compute, and training details all move at once — but it fits the intuition that protein-protein interaction accuracy improves when the model has seen much more of natural protein space.  
我之所以怀疑将 MGnify 仅视为更多序列数据：性能优势并非在每个接口基准测试中均匀显现。它在抗体-抗原预测中表现突出，而大多数更广泛的协同折叠基准测试结果则相对接近。这并非一个清晰的因果关系实验——架构、计算和训练细节都在同时变化——但它符合这样一种直觉：当模型接触了更多自然蛋白质空间时，蛋白质-蛋白质相互作用准确性会提高。

![Antibody-antigen scaling analysis comparing AlphaFold3, OF3p2, Protenix-v1, Boltz-1, and Chai-1 by number of seeds and mean DockQ](https://research.ligo.bio/posts/unreasonable-redundancy-of-natural-protein-folds/assets/antibody-antigen-scaling.png)

In this comparison, AlphaFold3, OF3p2, and Protenix-v1 use MGnify-scale protein distillation; Boltz-1 and Chai-1 do not. The separation is most visible on antibody-antigen docking, where the antibody and antigen do not share coevolutionary history. 在这个比较中，AlphaFold3、OF3p2 和 Protenix-v1 使用 MGnify-scale 蛋白质蒸馏；Boltz-1 和 Chai-1 则不使用。这种区别在抗体-抗原对接上最为明显，其中抗体和抗原没有共同进化历史。

![FoldBench interface benchmark success rates for AlphaFold3, OF3p2, Protenix-v1, Boltz-1, and Chai-1 across protein-protein, protein-peptide, protein-DNA, and protein-RNA interfaces](https://research.ligo.bio/posts/unreasonable-redundancy-of-natural-protein-folds/assets/Foldbench-all-cofolding.png)

The broader interface benchmarks are much more compressed. Across protein-protein, protein-peptide, protein-DNA, and protein-RNA cofolding, the same split between MGnify-distilled and non-MGnify-distilled models is not nearly as clean. 更广泛的接口基准测试压缩程度更高。在蛋白质-蛋白质、蛋白质-肽、蛋白质-DNA 和蛋白质-RNA 共折叠方面，MGnify 蒸馏和非 MGnify 蒸馏模型之间的相同分割并不那么清晰。

### Spectral linker split 光谱链接器拆分

This is a standalone version of the graph split used above. It assumes you have already filtered out low-confidence residues, and that `ca_coords` contains only the C-alpha coordinates you still want to consider. The function returns the C-alpha indices that sit closest to Fiedler sign-change boundaries; in our pipeline those residues become linker/cut residues before fragment IDs are assigned.  
这是一个独立版本的图拆分，用于上述操作。它假设您已经过滤掉了低置信度的残基，并且 `ca_coords` 只包含您仍然想要考虑的 Cα坐标。该函数返回位于 Fiedler 符号变化边界最近的 Cα索引；在我们的管道中，这些残基在分配片段 ID 之前会成为连接/切割残基。

```python
import numpy as np
from scipy.sparse import csr_matrix
from scipy.spatial import KDTree

def spectral_linker_indices(
    ca_coords: np.ndarray,
    *,
    k: int = 15,
    sigma: float = 8.0,
    connectivity_threshold: float = 0.05,
    boundary_size: int = 4,
    min_partition_size: int = 50,
) -> np.ndarray:
    """
    Find linker-like C-alpha positions with recursive spectral bisection.

    Parameters
    ----------
    ca_coords:
        Array with shape (N, 3), containing only the C-alpha coordinates that
        survived whatever filtering you want to apply first, usually pLDDT.
    k:
        Number of spatial nearest neighbors used to build the residue graph.
    sigma:
        Gaussian bandwidth for edge weights: exp(-d^2 / (2 sigma^2)).
    connectivity_threshold:
        Stop splitting when the Fiedler value is above this threshold.
    boundary_size:
        Number of residues closest to each sign-change boundary to mark.
    min_partition_size:
        Do not try to split partitions smaller than this.

    Returns
    -------
    np.ndarray
        Sorted indices into ca_coords. These are the residues to treat as
        linkers/cuts before assigning final fragments.
    """
    coords = np.asarray(ca_coords, dtype=float)
    if coords.ndim != 2 or coords.shape[1] != 3:
        raise ValueError("ca_coords must have shape (N, 3)")

    n = len(coords)
    if n < min_partition_size:
        return np.array([])

    k_eff = min(k, n - 1)
    if k_eff < 1:
        return np.array([])

    tree = KDTree(coords)
    distances, neighbors = tree.query(coords, k=k_eff + 1)

    # Skip the self-neighbor in column 0.
    row = np.repeat(np.arange(n), k_eff)
    col = neighbors[:, 1:].ravel()
    weights = np.exp(-(distances[:, 1:] ** 2).ravel() / (2 * sigma**2))

    W = csr_matrix((weights, (row, col)), shape=(n, n))
    W = W.maximum(W.T)

    linker_indices: set[int] = set()

    def split(node_indices: np.ndarray) -> None:
        if len(node_indices) < min_partition_size:
            return

        idx = np.sort(node_indices)
        sub_W = W[idx][:, idx].toarray()

        degree = sub_W.sum(axis=1)
        if np.count_nonzero(degree) < 2:
            return

        d_inv_sqrt = np.zeros_like(degree)
        nonzero = degree > 0
        d_inv_sqrt[nonzero] = 1.0 / np.sqrt(degree[nonzero])

        # Normalized graph Laplacian: L_sym = I - D^-1/2 W D^-1/2.
        L_sym = np.eye(len(idx)) - d_inv_sqrt[:, None] * sub_W * d_inv_sqrt[None, :]

        evals, evecs = np.linalg.eigh(L_sym)
        if len(evals) < 2:
            return

        fiedler_value = evals[1]
        fiedler_vector = evecs[:, 1]
        if fiedler_value > connectivity_threshold:
            return

        boundary_order = np.argsort(np.abs(fiedler_vector))[:boundary_size]
        linker_indices.update(idx[boundary_order].tolist())

        keep = np.ones(len(idx), dtype=bool)
        keep[boundary_order] = False

        partition_a = idx[keep & (fiedler_vector < 0)]
        partition_b = idx[keep & (fiedler_vector >= 0)]

        split(partition_a)
        split(partition_b)

    split(np.arange(n))
    return np.array(sorted(linker_indices))
```

### Foldseek command Foldseek 命令

For the fragment clustering pass, this is the Foldseek command we used before the representative-level structural audit.  
对于片段聚类过程，这是我们在代表性水平的结构审核之前使用的 Foldseek 命令。

```bash
# Foldseek command for reproducibility
$FOLDSEEK cluster "$DB_DIR/fragDB" "$DB_DIR/fragCluDB" "$TMP_DIR" \
  --threads "$THREADS" \
  -c 0.8 --cov-mode 0 \
  --tmscore-threshold 0.7 \
  --tmscore-threshold-mode 1 \
  --lddt-threshold 0.6 \
  --max-seqs 2000 \
  -e 0.001 \
  --alignment-type 2 \
  --cluster-reassign 1 \
  -v 2
```

## Citation 引用

Please cite this work as:  
请引用这项工作：

```
Arda Goreci, "The Unreasonable Redundancy of Nature's Protein Folds",
Ligo Biosciences Blog, May 20, 2026.
```

Or use the BibTeX citation:  
或使用 BibTeX 引用：

```
@article{goreci2026naturesproteinfolds,
  author = {Arda Goreci},
  title = {The Unreasonable Redundancy of Nature's Protein Folds},
  journal = {Ligo Biosciences Blog},
  year = {2026},
  month = may,
  day = {20},
  publisher = {Ligo Biosciences}
}
```