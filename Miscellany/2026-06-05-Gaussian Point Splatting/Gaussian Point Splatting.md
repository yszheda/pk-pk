---
title: Gaussian Point Splatting
source: https://momentsingraphics.de/Siggraph2026.html
author:
published:
created: 2026-06-05
description:
tags:
  - computer-graphics
  - 3d
  - machine-learning
  - research
---
Joris Rijsdijk, Christoph Peters, Michael Weinnman, Ricardo Marroquim.  
2026–07 in *ACM Transactions on Graphics (Proc. SIGGRAPH)* 45, 4.  
[Official version](https://doi.org/10.1145/3811272)

## Abstract

We propose Gaussian point splatting, a stochastic method to render Gaussian splats that scales extremely well to scenes with many Gaussians. Our core idea is to sample pixel-sized, opaque points from the Gaussians and to splat them to a framebuffer using 64-bit atomics. Through parallel programming primitives, we achieve an even distribution of the workload across millions of threads. Since these threads splat points independently, multiple points may splat to the same pixel. That makes it non-trivial to determine how many points should be splatted for a Gaussian or how they should be distributed to achieve the desired opacity. We successfully formalize and solve these problems, thus keeping our renders faithful to the original Gaussian splatting. To further accelerate our method, we employ hierarchical frustum and occlusion culling. Our method renders hundreds of millions of Gaussians in real time. The only differences compared to the original Gaussian splatting are slight noise and differences in aliasing.

**Keywords:** novel view synthesis, gaussian splatting, large-scale scenes, GPU atomics, point rendering, parallelism

## Images

[![representative_image](https://momentsingraphics.de/Media/Siggraph2026/representative_image.webp)](https://momentsingraphics.de/Media/Siggraph2026/representative_image.webp)
- [Supplemental results (interactive online viewer)](https://momentsingraphics.de/Media/Siggraph2026/rijsdijk2026_gps_image_viewer/index.html)

## Notes

This work gets presented at SIGGRAPH 2026 on 20th of July. The author's version has been published on 20th of May 2026.

## Downloads and links

- [Paper](https://momentsingraphics.de/Media/Siggraph2026/rijsdijk2026_gps_paper.pdf)
- [Joris' project page](https://jorisar.nl/gaussian_point_splatting/)
- [Supplemental video (no temporal reprojection)](https://momentsingraphics.de/Media/Siggraph2026/rijsdijk2026_gps_2x2_k4_1spp.mp4)
- [Supplemental video (with temporal reprojection)](https://momentsingraphics.de/Media/Siggraph2026/rijsdijk2026_gps_2x2_k4_1spp_reprojection.mp4)
- [Supplemental results (image viewer download)](https://momentsingraphics.de/Media/Siggraph2026/rijsdijk2026_gps_image_viewer.zip)
- [Source code (download)](https://momentsingraphics.de/Media/Siggraph2026/rijsdijk2026_gps_code.zip)
- [Source code (github)](https://github.com/JorisAR/gaussian-point-splatting)
- [Shadertoy for opacity correction](https://www.shadertoy.com/view/WXdyWr)