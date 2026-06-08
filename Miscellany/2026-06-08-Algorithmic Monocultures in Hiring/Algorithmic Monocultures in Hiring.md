---
title: "Algorithmic Monocultures in Hiring"
source: "https://algorithmichiring.github.io/"
author:
published:
created: 2026-06-08
description:
tags:
  - "ToRead"
---
Over 90% of U.S. employers [rely](https://www.weforum.org/stories/2025/03/ai-hiring-human-touch-recruitment/) on hiring algorithms to screen job applicants. Many different employers use algorithms from the same few vendors. We conduct the largest empirical study of algorithmic hiring with data for

```
3.4 million real job applicants
```
submitting
```
4 million applications
```
to
```
156 employers
```
across
```
11 market sectors
```
. Every application was assessed by algorithms from a single vendor: we test whether this *algorithmic monoculture* bottlenecks job opportunities. We are the first to demonstrate large-scale evidence of racial disparities and homogeneous outcomes in high-stakes hiring decisions. 超过90%的美国雇主 [依赖](https://www.weforum.org/stories/2025/03/ai-hiring-human-touch-recruitment/) 招聘算法来筛选求职者。众多不同的雇主使用来自少数几家相同供应商的算法。我们依托340万名真实求职者向11个行业领域的156家雇主提交的400万份申请数据，开展了规模最大的算法招聘实证研究。所有申请均由单一供应商的算法进行评估：我们借此检验这种 *算法单一化* 现象是否会限制就业机会。我们首次为高风险招聘决策中存在的种族差异及同质化结果提供了大规模实证依据。

---

## Key Findings 关键发现

1 **Large-scale adverse impact for Asians and Blacks.** We are the first to demonstrate adverse impact in deployed algorithmic hiring as one of the largest demonstrations of unfair outcomes in real high-stakes AI decisions. **25.87% of applications** submitted by Black applicants and **14.74%** of applications submitted by Asian applicants are directed to positions that adversely impact them based on the standards of the relevant [U.S. employment law (Title VII)](https://www.eeoc.gov/statutes/title-vii-civil-rights-act-1964).**对亚裔和黑人产生大规模不利影响。** 我们首次在部署的算法招聘中证实了这种不利影响，这是真实高风险人工智能决策中不公平结果的最典型案例之一。 **黑人申请者提交的** 25.87%的申请以及 **亚裔申请者提交的** 14.74%的申请，会根据相关 [美国就业法（第七条）](https://www.eeoc.gov/statutes/title-vii-civil-rights-act-1964) 的标准被分配至对其产生不利影响的岗位。

2 **Adverse impact only revealed by disaggregated position-by-position analysis.** While empirical studies of algorithmic hiring are very constrained due to data access limitations, prior studies [showed](https://dl.acm.org/doi/10.1145/3442188.3445928) minimal adverse impact due studying all of the vendor's data as a whole. By studying each position separately, in accordance with the standards of Title VII, we identify positions that demonstrate adverse impact that gets washed out in aggregate.**仅通过按职位细分的分析才能揭示不利影响。** 由于数据访问限制，算法招聘的实证研究受到极大限制，以往研究 [表明](https://dl.acm.org/doi/10.1145/3442188.3445928) ，将供应商的所有数据作为整体研究时，几乎不存在不利影响。而按照《第七条》的标准对每个职位单独进行研究，我们能够识别出那些在整体分析中被掩盖的存在不利影响的职位。

3 **Algorithmic monocultures in hiring yield systemic rejections.** We are the first to demonstrate systemic rejections in deployed algorithmic hiring as posited in [prior](https://arxiv.org/abs/2211.13972) [theoretical](https://www.cambridge.org/core/journals/canadian-journal-of-philosophy/article/algorithmic-leviathan-arbitrariness-fairness-and-opportunity-in-algorithmic-decisionmaking-systems/3AA0ECA77F8622488E9DB0834287215B) [research](https://scholarship.law.unc.edu/aidr_collection/11/) about algorithmic monoculture. The observed systemic rejection rate significantly exceeds that of the baseline of statistically independent decisions, even though the baseline accurately predicted observed systemic rejection rates in other hiring data in the absence of centralized algorithmic monocultures. **招聘中的算法单一文化会导致系统性拒录。** 我们首次证实了已部署的算法招聘中存在如 [先前](https://arxiv.org/abs/2211.13972) [理论](https://www.cambridge.org/core/journals/canadian-journal-of-philosophy/article/algorithmic-leviathan-arbitrariness-fairness-and-opportunity-in-algorithmic-decisionmaking-systems/3AA0ECA77F8622488E9DB0834287215B) [研究](https://scholarship.law.unc.edu/aidr_collection/11/) 中关于算法单一文化的假设所提出的系统性拒录现象。观察到的系统性拒录率显著高于统计独立决策的基准值，而在没有集中式算法单一文化的情况下，该基准值能准确预测其他招聘数据中的系统性拒录率。

4 **Data access inhibits independent research into hiring algorithms.** We are the first and only group to independently conduct empirical research deployed hiring algorithms at scale, even though hiring algorithms mediate high-stakes decisions and are pervasively adopted. Given the data barriers, policy intervention may be necessary to enable scientific inquiry and increase accountability into this high-impact application of AI.**数据获取限制了对招聘算法的独立研究。** 尽管招聘算法主导着高风险决策且已被广泛采用，但我们是首个也是唯一一个独立开展大规模部署的招聘算法实证研究的团队。鉴于数据壁垒，或许有必要通过政策干预来推动相关科学研究，并提高这一高影响力人工智能应用的问责性。

---

## Algorithmic Hiring Pipeline 算法招聘流程

Many employers procure hiring algorithms from the same third-party vendors. Over 60% of the Fortune 100 use HireVue's algorithms. When hiring algorithms from a single vendor mediate hiring decisions at multiple employers, they constitute an **algorithmic monoculture**. 许多雇主从同一家第三方供应商处采购招聘算法。《财富》百强企业中有超过60%使用HireVue的算法。当来自同一家供应商的招聘算法为多家雇主做出招聘决策时，它们就构成了一种 **算法单一文化** 。

![Diagram of the AI-mediated hiring pipeline showing how applicants are screened by shared algorithms across multiple employers](https://algorithmichiring.github.io/figures/fig1_pipeline.png)

Figure 1. Job applications are assessed by hiring AI to be recommended or not recommended. If an applicant is not recommended by the algorithm, they are likely to be rejected without further consideration by a human. 图1。 招聘AI对求职申请进行评估，以决定是否推荐。如果一名求职者未被算法推荐，他们很可能会被人类直接拒绝，而不会得到进一步的考虑。

---

## Revealing Adverse Impact 揭示不利影响

Title VII of the US Civil Rights Act governs discrimination in hiring. [Prior](https://dl.acm.org/doi/10.1145/3442188.3445928) [studies](https://link.springer.com/article/10.1007/s43681-022-00208-x) found very limited adverse impact in algorithmic hiring data as a whole. We surface previously-overlooked adverse impact by studying positions separately. Black applicants are the most likely to be adversely impacted: 30% of Black applicants apply to at least one position that demonstrates adverse impact against Black applicants. In terms of total effect, Asian applicants experience the largest shortfall: if Asians were selected at the same rate as the most selected racial group for each position, then 29000 additional Asian applications would be recommended. 《美国民权法案》第七章管辖招聘中的歧视行为。 [此前](https://dl.acm.org/doi/10.1145/3442188.3445928) [研究](https://link.springer.com/article/10.1007/s43681-022-00208-x) 发现，整体来看算法招聘数据中的不利影响十分有限。我们通过单独研究不同职位，揭示了此前被忽视的不利影响。黑人申请者受不利影响的可能性最大：30%的黑人申请者至少申请了一个对黑人申请者存在不利影响的职位。就总影响而言，亚裔申请者的损失最大：若在每个职位上，亚裔的录用率与录用率最高的种族群体相同，那么还会有29000份亚裔申请者的申请被推荐录用。

![Adverse impact across applicant groups](https://algorithmichiring.github.io/figures/adverse_impact.png)

Figure 2. Adverse impact according to the Title VII four-fifths rule measured at the level of positions (left) and applications/applicants (center). The shortfall (right) is the number of applications that would have been selected if the adversely impacted racial group was selected at the same rate as the most selected group. 图2。 根据《第七条》五分之四规则衡量的不利影响，分别体现在职位层面（左）和申请/申请人层面（中）。差额（右）指的是若受不利影响的种族群体的选拔比例与选拔比例最高的群体相同时，本应被选中的申请数量。

---

## Identifying Systemic Rejection 识别系统性拒绝

When applicants apply to multiple positions, they can receive the same outcomes. Algorithmic monoculture could make this most likely. If so, the systemic rejections where applicants are rejected everywhere would be especially concerning. Of applicants that submit 4 applications, 10% are systemically rejected. The observed systemic rejection rate significantly exceeds the baseline rate expected under independent decisions (χ <sup>2</sup> = 18,481, *p* < 0.001). 当求职者申请多个职位时，可能会得到相同的结果。算法单一化最有可能导致这种情况。若果真如此，求职者在所有申请的职位上均被系统性拒绝的情况就会尤其令人担忧。在提交4份申请的求职者中，有10%的人遭遇了系统性拒绝。观察到的系统性拒绝率显著高于独立决策下的预期基准率（χ² = 18,481， *p* < 0.001）。

![Chart showing systemic rejection rates exceed baseline predictions](https://algorithmichiring.github.io/figures/pymetrics_homogeneity.png)

Figure 3. Systemic rejection rates in hiring AI data. The observed rates always exceed the baseline: shared dependence on one vendor yields homogeneous outcomes. 图3。 招聘AI数据中的系统性拒绝率。观察到的比率始终高于基线：对单一供应商的共同依赖会导致同质化结果。

To contextualize the observed systemic rejection rates, we introduce the baseline of independent decisions ([Toups et al., 2023](https://arxiv.org/abs/2307.05862)). To test the predictivity of this baseline, we use data from the largest prior study of hiring ([Kline et al., 2022](https://www.nber.org/papers/w29053)), which sent 83,000 applications to 108 Fortune 500 firms. The baseline accurately predicts the observed rates (χ <sup>2</sup> = 20.05, *p* = 0.69). Therefore, excess homogeneity is distinctive of centralized algorithmic assessment. 为了结合观察到的系统性拒绝率进行背景分析，我们引入独立决策的基准（ [Toups 等人，2023](https://arxiv.org/abs/2307.05862) ）。为了检验该基准的预测性，我们使用此前规模最大的招聘相关研究数据（ [Kline 等人，2022](https://www.nber.org/papers/w29053) ），该研究向 108 家《财富》500 强企业投递了 83,000 份申请。该基准能准确预测观察到的比率（χ² = 20.05， *p* = 0.69）。因此，过度同质性是集中式算法评估的显著特征。

![Kline et al. systemic rejection rates matching baseline predictions](https://algorithmichiring.github.io/figures/kline.png)

Figure 4. Systemic rejection rates for data from Kline et al. (2022). Unlike the algorithmic hiring data, the baseline accurately predicted the observed rates. 图4。 Kline 等人（2022年） 数据中的系统性排斥率。与算法招聘数据不同，该基线准确预测了观测到的比率。

---

## Simulating Counterfactual Outcomes 模拟反事实结果

What would happen if applicants applied more broadly than they did in reality? Would this lessen their chances of systemc rejection? When applicants apply everywhere, we find that at least one model recommends them. But under more realistic behavior, applicants need to submit 25 applications to ensure at least one recommendation with 99.9% probability — compared to just 10 applications for independent decisions. 如果申请者的申请范围比实际情况更广，会发生什么？这会降低他们被系统拒绝的概率吗？我们发现，当申请者到处投递申请时，至少会有一个模型向他们发出推荐。但在更现实的情况下，申请者需要提交25份申请，才能以99.9%的概率确保至少获得一项推荐；而如果是独立决策的情况，仅需提交10份申请即可。

![Simulation showing systemic rejection rates under broader application behavior](https://algorithmichiring.github.io/figures/simulation.png)

Figure 5. Simulated systemic rejection rates if applicants applied where they applied in reality, as well as to neighboring models that share applicants. 图5。 若申请者申请了现实中他们所申请的院校，同时也申请了共享申请者的邻近院校，模拟得出的整体拒录率。

---

## Policy Recommendations 政策建议

Hiring AI is governed by employment discrimination law, general AI regulation, and specific rules for algorithmic hiring. In the U.S., Title VII already evaluates adverse impact at the level of [specific jobs](https://www.ecfr.gov/current/title-41/subtitle-B/chapter-60/part-60-3/subject-group-ECFR34f59e83ab36f01/section-60-3.15) rather than blended aggregates. More broadly, hiring systems are increasingly treated as [high-risk AI](https://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX:32024R1689), including under the EU AI Act. At the municipal level, New York City Local Law 144 established an early framework for regulating automated employment decision tools, but [current guidance](https://codelibrary.amlegal.com/codes/newyorkcity/latest/NYCrules/0-0-0-138393) does not adequately address the position-level effects we document. 招聘人工智能受就业歧视法、通用人工智能法规以及算法招聘特定规则的约束。在美国，《第七条》已针对 [具体职位](https://www.ecfr.gov/current/title-41/subtitle-B/chapter-60/part-60-3/subject-group-ECFR34f59e83ab36f01/section-60-3.15) 而非混合汇总情况评估不利影响。从更广泛的角度来看，包括根据《欧盟人工智能法案》的规定，招聘系统正越来越多地被视为 [高风险人工智能](https://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX:32024R1689) 。在市政层面，纽约市第144号地方法为监管自动化就业决策工具设立了早期框架，但 [当前指导意见](https://codelibrary.amlegal.com/codes/newyorkcity/latest/NYCrules/0-0-0-138393) 未能充分解决我们所记录的职位层面影响。

1

**Measure adverse impact per position.** Regulators and auditors should evaluate adverse impact ratios at the level of individual positions. Aggregate-only analyses can conceal disparate impact. **按岗位评估不利影响。** 监管机构和审计人员应在单个岗位层面评估不利影响比率。仅进行汇总分析可能会掩盖差异化影响。

2

**Strengthen market surveillance.** Federal agencies should quantify the rate of homogeneous outcomes. Without cross-employer links, existing reporting won't capture systemic rejection. **加强市场监管。** 联邦机构应量化同质化结果的发生率。若无跨雇主关联，现有报告将无法反映系统性排斥问题。

3

**Monitor algorithmic monoculture.** Policymakers should surveil shared dependencies in the hiring supply chain. Concentrated reliance on the same systems can yield correlated failures, systemic rejection, and reduced competition in hiring. **监控算法单一化问题。** 政策制定者应监督招聘供应链中的共享依赖。过度依赖同一系统可能导致相关性故障、系统性淘汰以及招聘领域竞争的减弱。

4

**Expand researcher access.** Legislators should stimulate independent research, including underlying data access, into major hiring platforms. Issues will be difficult to diagnose, let alone rectify, without the foundation of empirically-grounded externally-conducted inquiry. **扩大研究人员的访问权限。** 立法者应推动对主要招聘平台开展独立研究，包括获取相关底层数据。如果没有基于实证的外部调查作为基础，相关问题将难以诊断，更谈不上纠正。

---

## Citation 引用

@article{bommasani2026algorithmic, title={Algorithmic Monocultures in Hiring}, author={Bommasani, Rishi and Bana, Sarah H. and Creel, Kathleen A. and Jurafsky, Dan and Liang, Percy}, booktitle={Proceedings of the 2026 ACM Conference on Fairness, Accountability, and Transparency}, year={2026} } @article{bommasani2026algorithmic,title={招聘中的算法单一文化},author={Bommasani, Rishi and Bana, Sarah H. and Creel, Kathleen A. and Jurafsky, Dan and Liang, Percy},booktitle={2026年ACM公平、问责与透明性会议论文集},year={2026}}

<iframe src="chrome-extension://cnjifjpddelmedmihgijeibhnjfabmlf/side-panel.html?context=iframe"></iframe>