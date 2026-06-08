---
title: "KNN early termination in Manticore Search"
source: "https://manticoresearch.com/blog/knn-early-termination/"
author:
  - "[[Ilya Kuznetsov]]"
published: 2026-05-29
created: 2026-06-08
description: "How Manticore detects when HNSW search has converged and stops early, cutting distance computations by 50-80% with minimal precision loss."
tags:
  - "ToRead"
---
![blog-post](https://manticoresearch.com/images/blog/knn-early-termination_hu1f1b95ab4e84ede1666461086289baf9_1277298_90a50049f6645f197312d8e47cd41aae.webp)

Modern search engines do more than match keywords. When you search for "cozy mystery set in Paris" and get results for "atmospheric detective novel in France" that's vector search at work: documents and queries are converted into lists of numbers, called embeddings, and the search engine finds the documents whose numbers are closest to the query's.

Manticore Search supports this natively. Under the hood, it uses a data structure called HNSW: a graph that connects nearby vectors, so it can find nearest neighbors quickly without scanning every document. That makes vector search fast enough to run on millions of documents in milliseconds.

> But HNSW has an inefficiency. Early in the traversal, almost every distance computation finds a better candidate than the ones already in the result set.

As the search goes on, those improvements become rarer, but the algorithm keeps traversing the graph until it exhausts its exploration budget. By that point, the result set has often already converged, and the remaining work does little or nothing to improve it. Early termination fixes this by detecting that point and stopping early.

The effect becomes more noticeable as `k` grows, where `k` is the number of nearest neighbors the query asks Manticore to return. Returning more neighbors requires more graph exploration, and much of that extra work happens after the result set has already stabilized. That also makes early termination more valuable, because it has more unnecessary work to cut.

This gets more pronounced with [vector quantization](https://manual.manticoresearch.com/Searching/KNN#Vector-quantization). Quantization compresses stored vectors to save memory, which slightly lowers search precision. To recover it, Manticore uses [oversampling](https://manual.manticoresearch.com/Searching/KNN#KNN-vector-search): it fetches 3x more candidates than requested, then rescores them using the original full-precision vectors. With the default 3x oversampling, HNSW explores many more candidates per query. Large `k` values often come from this kind of candidate expansion: an application may ask the vector index for hundreds or thousands of candidates, then rescore, rerank, or filter them down to a much smaller final result set to improve recall and precision. That raises latency, and early termination helps win some of it back.

The waste is measurable. Benchmarks on a 1M-vector dataset show that with `k=60`, which is the default result limit with default 3x oversampling, early termination reduces distance computations to about 65% of the full search. At `k=1000`, computations drop to 30%. At `k=10000`, just 20%. The search converges long before the exploration budget runs out, and the savings grow with `k`.

Early termination lets Manticore detect this convergence and stop. The algorithm was designed with a specific precision target: lose no more than 2-4% of result set precision compared to a full HNSW search.

## How it works

The algorithm tracks a simple signal: discovery rate - the fraction of distance computations that actually improve the result set.

Each time a new node's distance is computed, one of two things happens: either it's good enough to enter the heap - the priority queue that holds the current best candidate neighbors - or it's worse than everything already there and gets discarded. Entering the heap counts as a "discovery." Early in the search, discoveries are frequent - the heap is filling up and most candidates are useful. As the search progresses and the heap saturates with good results, discoveries become rare. Most new distance computations just confirm that the algorithm has already found the best candidates.

Manticore monitors this transition. After each round of neighbor expansion, it computes the discovery rate:

```bash
discovery_rate = new_candidates_collected / distances_computed
```

If this rate stays below a threshold for several rounds in a row, the search stops.

> The idea is simple: if the algorithm keeps computing distances but nothing improves the result, the search has converged.

## The threshold: quantile-based adaptation

That raises the obvious next question: what threshold should count as "low"? A fixed threshold wouldn't work well - different datasets and different regions of the same dataset have wildly different discovery rate distributions. What counts as "low" depends on context.

Manticore uses a quantile-based adaptive threshold. Instead of comparing the discovery rate against a fixed number, it continuously estimates a low percentile of recent rounds (20th percentile, or 14th percentile for L2 distance) and uses that as the baseline. This keeps the method lightweight while letting it adapt to different datasets and different regions of the graph.

In other words, the threshold adapts to the local search pattern. If the algorithm enters a sparse region of the graph, the threshold drops and avoids stopping too early. If it enters a richer region, the threshold rises.

## Patience: how many bad rounds before stopping

The threshold alone is not enough, though. A single round with a low discovery rate isn't enough to declare convergence. It could just be a temporary dip before the search finds a better path. Manticore uses a "patience counter" that requires multiple consecutive bad rounds before terminating.

The patience value scales inversely with `ef`, the HNSW exploration factor that controls how many candidates the search keeps exploring. For example, patience ranges from 9 at low `ef` values down to 6 at very high `ef`. Larger `ef` values mean more total rounds, so even with lower patience the algorithm has seen more evidence before deciding to stop. The counter resets to zero whenever a round has a healthy discovery rate, so a single good round restarts the patience window. This prevents the algorithm from stopping during a temporary plateau that leads to a productive region of the graph.

## Warm-up phase

The algorithm ignores the termination signal while the heap is still filling up, meaning fewer than `ef` candidates have been collected. During this phase, discovery rates are artificially high because almost everything enters the heap, so the signal is not useful. Early termination only starts once the heap is full and new candidates must replace existing ones.

## Benchmark results

The quantile thresholds were tuned to keep precision loss within 2–4%. They were tuned separately for L2 and cosine/IP distance metrics, and validated across both [quantized and non-quantized](https://manual.manticoresearch.com/Searching/KNN#Vector-quantization) data.

The following benchmarks were run on the [dbpedia-entities](https://huggingface.co/datasets/KShivendu/dbpedia-entities-openai-1M) dataset (1M vectors, 768 dimensions) on a machine with 8 physical cores / 16 logical cores.

- "Precision" here means the fraction of true k-nearest neighbors that appear in the result set (with fixed k, this is the same as recall@k).
- "Precision ratio" is the precision of HNSW with early termination ("ET") divided by precision without it (1.0 means no precision loss).
- "Visit ratio" is the fraction of distance computations performed compared to full HNSW search (lower is better).

[Oversampling and rescoring](https://manual.manticoresearch.com/Searching/KNN#KNN-vector-search) were disabled to isolate the effect of early termination on raw HNSW traversal.

![Precision ratio vs visit ratio](https://manticoresearch.com/blog/knn-early-termination/knn_et_precision_chart.svg)

The green line on the chart (precision) stays almost flat across all `k` values, with precision ratio remaining above 0.97 throughout the benchmark. Meanwhile the orange line (visit ratio) drops steeply. At `k=100`, it cuts distance computations nearly in half. At `k=1000`, it saves 70%. At `k=10000`, 80%.

At `k <= 10`, early termination is disabled because the search is already cheap and the savings are too small to justify any precision loss. The savings grow with `k`, because larger result sets lead to more rounds of neighbor expansion and more chances to detect convergence early.

## Performance under concurrent load

The benchmarks above show that early termination cuts distance computations a lot while preserving precision. But what does that mean for actual query latency, especially under concurrent load? The chart below shows latency ratios (ET / no ET) at 1, 8, and 16 concurrent threads on the same dbpedia dataset:

![Early termination latency ratio by thread count](https://manticoresearch.com/blog/knn-early-termination/knn_et_latency_chart.svg)

At `k=1000`, early termination reduces distance computations by 71% (ratio 0.29). The latency improvement depends on how many threads are running at the same time:

- **1 thread:** 24% faster (ratio 0.76)
- **8 threads:** 45% faster (ratio 0.55)
- **16 threads:** 48% faster (ratio 0.52)

> The distance computation savings stay the same regardless of thread count, but the latency benefit nearly doubles from 1 to 16 threads.

The main reason is lower pressure on the CPU memory system. Each distance computation pulls vector data and graph links into cache. When several threads run HNSW traversal at the same time, they compete for shared cache and memory bandwidth. Doing fewer distance computations per query reduces memory traffic, keeps each thread’s working set smaller, and lowers cache churn between queries. As a result, each thread finishes faster and interferes less with the others.

Single-thread benchmarks understate the benefit of early termination. Under production-like concurrent load, the percentage latency reduction is roughly twice as large.

## When early termination kicks in (and when it doesn't)

Early termination is enabled by default and works on both quantized and non-quantized vector data. It is automatically disabled when `k <= 10`.

The benefit grows with the effective exploration budget, which is `max(ef, k)`. Since hnswlib uses this internally as the number of candidates it keeps in play, larger `k` means more candidates, more rounds, and more chances to detect convergence.

Quantized vectors are typically used with rescoring and oversampling (both enabled by default) to recover precision lost from quantization. Oversampling (default 3x) multiplies the effective `k` passed to HNSW. For example, a query with `k=100` uses 300 candidates internally when oversampling is 3x. That larger search budget gives early termination more room to detect convergence and stop early. Since the performance benefit of early termination grows with `k`, oversampling pushes queries into the range where the savings are largest.

## Syntax

Early termination is on by default. To disable it:

**SQL:**

```sql
-- default: early termination enabled
SELECT id, knn_dist()
FROM products
WHERE knn(embedding, (0.12, 0.45, 0.78, 0.33));

-- explicitly disable early termination
SELECT id, knn_dist()
FROM products
WHERE knn(embedding, (0.12, 0.45, 0.78, 0.33), { early_termination=0 });

-- combine with other KNN options
SELECT id, knn_dist()
FROM products
WHERE knn(embedding, (0.12, 0.45, 0.78, 0.33), { ef=200, early_termination=0 });
```

**JSON:**

```json
POST /search
{
    "table": "products",
    "knn": {
        "field": "embedding",
        "query": [0.12, 0.45, 0.78, 0.33],
        "early_termination": false
    }
}
```

## When to disable it

There are a few scenarios where you might want to turn early termination off:

- **Maximum precision is critical.** Early termination trades a small amount of recall for speed. If your application requires the absolute best recall that HNSW can provide at a given `ef`, disable it.
- **Small k values (<= 30).** The algorithm auto-disables for `k <= 10`, but even for `k` between 11 and 30, the performance benefit is modest. If you notice any recall difference in this range, disabling early termination costs little in latency.
- **Benchmarking HNSW recall.** If you are measuring HNSW recall, you probably want deterministic behavior without adaptive shortcuts. Disable early termination to get a clean baseline.

## How it relates to other KNN optimizations

Early termination is one of several optimizations that Manticore applies to KNN search. It works independently of and stacks with the others:

- [Prefiltering](https://manticoresearch.com/blog/knn-prefiltering/) reduces wasted work by skipping filtered-out documents during HNSW traversal. Early termination reduces wasted work by stopping the traversal once the result set has converged. They solve different problems and work well together.
- [Oversampling](https://manticoresearch.com/blog/quantization/#why-oversampling--rescoring-matters) retrieves more candidates than `k` to improve recall after rescoring. Early termination can reduce the cost of that expanded search by stopping once enough good candidates have been found.
- [Rescoring](https://manticoresearch.com/blog/quantization/#why-oversampling--rescoring-matters) recalculates distances using full-precision vectors after the initial search with quantized vectors. Early termination operates during the initial quantized search phase, reducing the number of candidates evaluated before rescoring kicks in.
- **Automatic brute-force fallback** skips HNSW entirely when a linear scan is cheaper. Early termination only applies when HNSW is actually used.