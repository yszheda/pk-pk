---
title: "PlayStation Architecture | A Practical Analysis"
source: "https://www.copetti.org/writings/consoles/playstation/"
author:
  - "[[Rodrigo Copetti]]"
published: 2019-08-08
created: 2026-06-04
description: "An in-depth analysis that explains how this console works internally"
tags:
  - "ToRead"
---
## Supporting imagery

### Model

### Motherboard

![Motherboard](https://www.copetti.org/images/consoles/ps1/motherboard.53772eccd0c3590bb5e4a2218cd7fe1d3b2d8046c9a6a83751d3a85c5b837153_hu_557b7b5f6decae11.webp)

Motherboard Showing model 'SCPH-1000'. Remaining chips are fitted on the back. Later models included SG-RAM instead of VRAM and removed most of the external I/O and video outs.

### Diagram

![Diagram](https://www.copetti.org/images/consoles/ps1/_diagrams/main.1e96320eb87b0478a0852983ebc352f90f5684a4e470495cfb55df218cd59afd_hu_c1bcbf15477e7998.webp)

Main architecture diagram The Bus Interface Unit is also connected to special ports of the GPU and SPU.

---

## A quick introduction

Sony knew that 3D hardware could get very messy to develop for. Thus, their debuting console will keep its design *simple* and *practical* … Although this may come at a cost!

---

## CPU

This section dissects the **Sony CXD8530BQ**, one of the two big chips this console houses. It’s what we would call a ‘System-on-Chip’ in today’s terms.

### The origins

The main processor follows one of those ‘X designed by Y, based on Z, and second-sourced from W’ arrangements, which is a bit dense to summarise in just a few sentences. So, why don’t we start with some historical context?

#### A bit of history

![Image](https://www.copetti.org/images/consoles/ps1/quadra.9de0a14f61f33fd2806050994496b9ace5619460cd9fdf761af55159806e3f4a.webp)

A Macintosh Quadra 700 next to a PowerPC upgrade card. Like many adopters of the Motorola 68k, the 90s dictated a necessary shift towards RISC-based CPUs (i.e. PowerPC, in the case of Apple).

The early nineties were marked by a turning point in the fortunes of many popular CPUs. The once-leading 8-bit processors, such as the [Z80](https://www.copetti.org/writings/consoles/master-system/#cpu) and [6502](https://www.copetti.org/writings/consoles/nes/#core-functionality), had already faded from the spotlight, and Motorola’s famous [68000](https://www.copetti.org/writings/consoles/mega-drive-genesis/#cpu), along with other [16-bit designs](https://www.copetti.org/writings/consoles/super-nintendo/#cpu) that enjoyed success in the late 80s, were now candidates for replacement. Even in the PC field at the time, Andrew S. Tanenbaum, in his celebrated debate with Linus Torvalds, predicted that Intel’s x86 architecture had only *five more years* left until its demise from the home market.

At first glance, it may look as though technological development had hit a wall. In reality, however, a new wave of relatively unknown CPUs was beginning to find its way into mainstream devices. Many of these designs originated in academia, and so intended to prove particular sets of design principles. Novel examples from that era include:

- **MIPS**: Adopted by Silicon Graphics Incorporated (targeting graphics workstations).
- **PowerPC**: Adopted by Apple (targeting desktop publishing).
- **SPARC**: Developed by Sun Microsystems (targeting servers and business workstations).
- **ARM**: [Developed by Acorn](https://www.copetti.org/writings/consoles/game-boy-advance/#the-cambridge-miracle), initially targeting the consumer market before expanding into PDAs, cell phones, and other embedded devices.
- … and many more ‘microcontroller’ chips that had yet to be finalised or adopted by a major industry - such as the **Hitachi’s SH** and **NEC’s V810**. To their surprise, these were subsequently selected for the [Sega Saturn](https://www.copetti.org/writings/consoles/sega-saturn/) and the [Nintendo Virtual Boy](https://www.copetti.org/writings/consoles/virtual-boy/), respectively.

All of these processors had one thing in common: they adhered to the **Reduced Instruction Set Computer** (RISC) discipline, which radically shifted how such chips were designed and programmed. One rule of the RISC architecture dictated that a single instruction could not mix memory access with register operations. This allowed hardware designers to simplify the circuitry responsible for executing instructions… and then enhance it with parallelism techniques.

#### MIPS and Sony

![Image](https://www.copetti.org/images/consoles/ps1/irix.52ab50e7f95bafd141358b8f398dbdd9af62e5ae84f492fc2a0c7d3226e1480f.webp)

The SGI Iris 4D/80, a beefy graphics workstation featuring a twin-tower design. The 4D series inaugurated the MIPS CPU in SGI computers, with this particular model bundling the R2000 processor \[1\]. I took this photo at the Computer History Museum (Mountain View, California), during my second visit in March 2025.

**MIPS Computer Systems** originated from the eagerness of its founders (Stanford faculty) who were keen to turn their research into physical processors. This aligned well with the appetite of Silicon Valley venture capitalists in the 80s, who were anxious to invest in such innovations <sup><a href="#bib:cpu-chm_mips" role="doc-biblioref">[2]</a></sup>. Their debuting CPU, the ‘MIPS R2000’, is considered the first commercial CPU to incorporate a RISC design, and it found a space in many UNIX workstations.

However, it wasn’t until 1987 that MIPS’ chips became a topic of conversation, all thanks to their adoption (and eventual acquisition) by **Silicon Graphics Incorporated** (SGI) to power its equipment. SGI was an influential force in the computer graphics market, especially with the development of [hardware-accelerated vertex pipelines](https://www.copetti.org/writings/consoles/nintendo-64/#graphics), a function originally carried out by software (within the CPU). Following the merger, SGI secured a leading position in both CPU and graphics sectors.

Prior to the development of the PlayStation, MIPS transitioned to a business model based on **IP licensing**, in which CPU designs were sold in the form of licenses, and licensees were then free to customise and manufacture the designs. Among their offerings was the **R3000A CPU**, found in their low-end catalogue. As such, the R3000A was not associated with the flagship line (unlike the R4000, which [others](https://www.copetti.org/writings/consoles/nintendo-64/#cpu) would later choose), but it was an attractive investment in terms of cost.

Back to the main topic, Sony designed their audio and graphics chips in-house, but still needed the leading chip to drive those two. The selected CPU had to be powerful enough to showcase the *impressive* capabilities of Sony’s chips, while remaining affordable to keep the console at a competitive price.

#### LSI and the commission

At the same time, **LSI Logic** (a semiconductor manufacturer) was a MIPS licensee that provided a ‘build-your-own’ CPU programme for businesses. This service, known as **CoreWare**, enabled clients to assemble custom CPU packages by choosing from a series of building blocks <sup><a href="#bib:cpu-lsi" role="doc-biblioref">[3]</a></sup>. Part of the CoreWare library included the ‘CW33300’ block, a CPU core derived from the LSI LR33300 - an off-the-shelf CPU chip that LSI also commercialised.

Now, where am I going with all this? It turns out both the LR33300 and CW33300 are a **binary-compatible with the MIPS R3000A family**. Their architectures differ slightly in some areas, but the programming interface (MIPS I ISA) remains the same.

In the end, Sony commissioned LSI to build their CPU package. They selected the CW33000, changed some bits, and integrated it with other blocks to form the chip you find on the PlayStation’s motherboard.

### The offering

![Image](https://www.copetti.org/images/consoles/ps1/cpu_chip.008e74d7bdfa1375cbdc1b606658115ea5e82c2613fedaa52f0f3ba996b1f6f7_hu_ea0ff6b63553528.webp)

The SoC chip on the PlayStation’s motherboard, where the MIPS R3000A-based core resides.

The resulting CPU core runs at **33.87 MHz** and features:

- The **MIPS I** ISA: The first version of the MIPS instruction set architecture. Among many things, it uses **32-bit words** and includes multiplication and division instructions.
- **32 general-purpose registers** and **2 multiplication/division registers**: These are 32-bit as well. One general-purpose register (`R0`) is hardwired to zero, a common trait in RISC designs.
- **32-bit data bus**: In the PS1, this bus branches into two:
	- **Main Bus** (32-bit): Connects the MDEC and GPU.
		- **Sub Bus** (16/8-bit): Connects the remaining components and I/O. This bus is bridged by the **Bus Interface Unit**, which also enables access to special ports of the GPU and SPU.
- **32-bit address bus**: Enables access of up to 4 GB of physical memory. In other words, RAM, memory-mapped I/O, etc.
- **5-stage pipeline**: Allows up to five instructions to be processed simultaneously (see a [previous article](https://www.copetti.org/writings/consoles/sega-saturn/#cpu) for a detailed explanation).
- **4 KB of instruction cache**: This can be ‘isolated’ as well, allowing the program to manipulate the instruction cache directly.
- Oddly, **there is no data cache**. The **1 KB of memory** normally reserved for it is mapped to a fixed address <sup><a href="#bib:cpu-mame_cpu" role="doc-biblioref">[4]</a></sup>. This area is called **Scratchpad** and it’s used as ‘fast SRAM’.
![Image](https://www.copetti.org/images/consoles/ps1/edo_chips.83e200317ec05acf9a737b761c1d9b3231c2948cf8b732e88e92d7b8e168d4b6.webp)

Four 512 KB chips of EDO RAM.

To do something meaningful, Sony provided **2 MB of RAM** for general-purpose use. Curiously enough, they fitted **Extended Data Out** (EDO) chips on the motherboard. These are slightly more efficient than typical DRAM, obtaining lower latency.

### Taking over the CPU

At certain points, any subsystem (graphics, audio or the CD drive) will require large chunks of data at a fast rate. However, the CPU is not always capable of keeping up with the demand.

For this reason, the CD-ROM controller, MDEC, GPU, SPU and the parallel port are granted access to a dedicated **DMA controller** whenever they require it. **Direct Memory Access** (DMA) takes control of the main bus to perform data transfers independently. This results in significantly higher throughput than routing the transfer through the CPU, although the latter is still required to set up the DMA operation.

It’s also worth noting that once the DMA kicks in, the CPU is unable to access the main bus. This means the CPU will be idling unless it’s got something in Scratchpad to keep itself busy!

### Complementing the core

Like other MIPS R3000-based CPUs, the CW33000 supports configurations with up to four coprocessors. Sony customised it with three:

#### System Control Coprocessor

Identified as ‘CP0’, the **System Control Coprocessor** is a common block found in MIPS CPUs. In R3000-based systems, like this one, the CP0 governs how the cache is implemented. Thus, enabling direct access to the data cache (in the form of ‘Scratchpad’) and instruction cache (through ‘cache isolation’). The control coprocessor also handles interrupts, exceptions and breakpoints - the latter is useful during debugging.

> Wait, shouldn’t coprocessors only *expand* CPU functions? Why is CP0 tightly coupled with the CPU?

Indeed, R3000 cores depend on the system control coprocessor to make use of many components. Whether or not this should be ‘legal’ comes down to the interpretation of the word ‘coprocessor’. According to MIPS, a coprocessor is not strictly an optional part of the CPU - it may also command the CPU’s surroundings (e.g. cache, interrupts). Hence, a coprocessor can be an integral part of the system. This is something to bear in mind when discussing MIPS-related systems.

Later [R4000-based systems](https://www.copetti.org/writings/consoles/nintendo-64/) incorporated a Memory Management Unit (MMU) and a Translation Lookaside Buffer (TLB) into this block, thereby increasing its capabilities and taking up [new roles](https://www.copetti.org/writings/consoles/nintendo-64/#memory-management).

#### Geometry Transformation Engine

The ‘CP2’, or **Geometry Transformation Engine** (GTE), is a specialised math processor that accelerates vector and matrix calculations.

While only operating fixed-point types, it still provides useful operations for 3D graphics, such as:

- Matrix or vector multiplication, addition, and vector square.
- Perspective transformation (used for 3D projections).
- Outer product of two or three vectors (the latter is used for clipping).
- Many interpolation functions that use different parameters.
- Depth cueing and colour value derived from a light source (used for lighting and colour operations).
- Z/depth averaging. I suspect this is used for the ‘ordering table’ (I explain more details in the ‘Graphics’ section).

You don’t need to memorise all of this to follow the rest of the article! Just keep in mind that the GTE takes care of the initial stages of the graphics pipeline, including 3D projection, lighting, and clipping. This will help to generate the required data to send to the GPU for rendering.

#### Motion Decoder

The **Motion Decoder**, also called ‘MDEC’ or ‘Macroblock Decoder’, is another processor living next to the CPU. This time, it decompresses ‘macroblocks’ into a format the GPU can understand. A macroblock is a data structure containing an image encoded similarly to JPEG.

The MDEC decompresses bitmaps consisting of 8x8 pixels at 24 bpp (bits per pixel). Overall, the MDEC can compute 9,000 macroblocks per second <sup><a href="#bib:cpu-walker" role="doc-biblioref">[5]</a></sup>, enabling to stream a 320x240 px **Full-Motion Video** (FMV) at 30 frames per second.

DMA is used to transfer compressed data through the CD-ROM, RAM, and MDEC. The same path is used in reverse, though the destination in this case is VRAM.

While this component resides within the SoC and shares the same data bus, it is not a MIPS coprocessor; the CPU and DMA access it via the memory map, rather than intercepting instructions.

For more info about the MDEC unit, I suggest consulting Sabin’s <sup><a href="#bib:cpu-sabin" role="doc-biblioref">[6]</a></sup> and Czekański’s <sup><a href="#bib:cpu-jakub_mdec" role="doc-biblioref">[7]</a></sup> resources.

### Missing units?

So far, we’ve seen a ‘CP0’ and a ‘CP2’, but **where’s the ‘CP1’?** Well, that’s actually reserved for a **Floating-Point Unit** (FPU) - and I’m afraid Sony didn’t provide one. This doesn’t mean the CPU is incapable of performing arithmetic with decimal numbers; it simply won’t be fast enough (when using software routines) or particularly accurate (when relying on fixed-point arithmetic).

Game logic (involving physics, collision detection, and similar) can still get by using fixed-point arithmetic. Fixed-point encoding represents decimal numbers with an immutable number of decimal places. This leads to a loss in precision during certain operations, but remember: this is a video game console, not a professional flight simulator. Hence, the trade-off between precision and performance can be considered reasonable.

By the way, if you’d like a quick refresher on concepts like ‘fixed-point’, ‘floating-point’, ‘decimal’, and ‘integer’, I recommend taking a look at Gabriel Ivancescu’s post <sup><a href="#bib:cpu-gabriel" role="doc-biblioref">[8]</a></sup>.

### Delay galore

As we’ve seen before, the CW33300 is a pipelined processor - meaning it queues multiple instructions and executes them in parallel at different stages. This hugely improves instruction throughput, but without proper control, it can lead to **pipeline hazards**, resulting in computational errors.

The MIPS I architecture is particularly susceptible to <sup><a href="#bib:cpu-chen" role="doc-biblioref">[9]</a></sup>:

- **Control hazards**: Instructions may get executed when they shouldn’t.
- **Data hazards**: Instructions may operate with outdated data before it’s been updated.

![Image](https://www.copetti.org/images/consoles/ps1/delay_slots.ccc1846a7b3daf73fd4ec5596d8f6b3b551b47c9eed8d5a60b992942dba7941b.jpg)

Instructions from ‘Spyro The Dragon’ visualised in the NO$PSX debugger. Notice how LW (load word from memory), JAL (jump and link) and BNE (branch on not equal) are each followed by a delay slot to prevent hazards. Instructions marked in red (found before address 800597C4 ) are fillers (useless instructions), while the rest marked in blue perform meaningful computations.

Consequently, MIPS I CPUs exhibit the following behaviour:

- **Any instruction following a ‘branch’ or ‘jump’ opcode is executed unconditionally**: Thus, developers have to manually fill the pipeline with modest instructions (such as `calculate 0 plus 0`) after the branch or jump to mitigate the hazard. These fillers are called **branch delay slots**.
	- Modern CPUs converted this phenomenon into an advantage: [Branch prediction](https://www.copetti.org/writings/consoles/gamecube/#cpu). By adding circuitry to detect the hazard, the CPU can discard speculative computations if the branch or jump condition isn’t met. But if it holds true, then the CPU saves time.
- **‘Load’ instructions don’t stall the pipeline until the retrieved data becomes available**: The second stage of the pipeline (called `RD` or ‘Read and Decode’) gathers the operands that will be used during the third stage (`ALU`) <sup><a href="#bib:cpu-manual" role="doc-biblioref">[10]</a></sup>. The fourth stage (`MEM`, from ‘access MEMory’) looks for data in memory (e.g. main RAM or the CD reader). Now, here’s the problem: by the time a `load` instruction gathers the data from outside, the next instruction already fetched the operands. Therefore, when an instruction depends on the data from a preceding `load`, a filler must be inserted to ensure the correct operands are fetched on time.

As illustrated in the example, some delay slots are filled with meaningful instructions, which perform computations that are not affected by the hazard. Hence, delay slots do not always equate to wasted cycles.

#### A core philosophy

Having explained this, you may be wondering why a processor exhibiting such flaws would ever be commercialised. Well, one tenet of the RISC philosophy is that the burden of CPU programming is shifted from the developer to the **compiler**. MIPS, in particular, **prioritised the production of high-quality compilers** (including assemblers) to accompany their new CPUs <sup><a href="#bib:cpu-chm_mips" role="doc-biblioref">[11]</a></sup>. Hence, the company envisioned that developers would use a higher-level language (like C) while the toolchain automatically dealt with hazards, either by reordering instructions to fill in slots, or by adding useless fillers as a last measure.

In fact, exposing the CPU pipeline to developers was an core design strategy at MIPS, evidenced by its very initials standing for ‘Microprocessor without Interlocked Pipelined Stages’.

So, all in all, while I don’t find it pleasant to see a program filling the CPU with bubbles, I think MIPS tackled this challenge in a very ingenious way. That said, it wasn’t without its disadvantages, however. As [later years revealed](https://www.copetti.org/writings/consoles/nintendo-64/#cpu), exposing the pipeline made backwards compatibility very tricky, especially as future CPUs debuted revolutionary microarchitectures.

---

## Graphics

To recap, a large part of the graphics pipeline is carried out by the GTE. This includes perspective transformation (which projects the 3D space onto a 2D plane using the camera’s perspective) and lighting. The processed data is then sent to Sony’s proprietary **Graphics Processor Unit** (GPU) for rendering.

### Organising the content

The system features **1 MB of Video RAM** (VRAM) that will be used to store the frame buffer, textures, and other resources the GPU will require to render the scene. The CPU can populate this area using DMA.

The type of chip fitted (**VRAM**) is dual-ported, like the [Virtual Boy’s](https://www.copetti.org/writings/consoles/virtual-boy/#organising-the-content). VRAM uses two 16-bit buses, which enables concurrent access by the CPU, DMA, GPU and the video encoder.

![Image](https://www.copetti.org/images/consoles/ps1/_diagrams/vram/vram.d71d09d28fa765985f99f1aa9ebc525ce237c41df20dd8d12a57142b9d955b55.png)

Memory layout using VRAM.

![Image](https://www.copetti.org/images/consoles/ps1/_diagrams/vram/sgram.1ad88c70c94ffa69fcca60051414fcd68e1d627ce5cffdcbad8bfc3f31fc5ad0.png)

Memory layout using SGRAM.

Though in later revisions of this console, Sony switched to **Synchronous Graphics RAM** (SGRAM) chips (the single-ported alternative, using an individual 32-bit data bus). *Boo!*… Well, to be fair, each one comes with its pros and cons.

One thing for sure is that, due to timing differences, later games (such as *Jet Moto 3*) display glitched graphics when run on VRAM-based systems. If you want to know the details, Martin Korth’s ‘Nocash PSX Specifications’ document the various timings and such <sup><a href="#bib:cpu-korth" role="doc-biblioref">[12]</a></sup>.

### Drawing the scene

If you’ve been reading the [Sega Saturn article](https://www.copetti.org/writings/consoles/sega-saturn/), let me tell you that the design of this GPU is *a lot* simpler! For starters, the GPU is made of a **single chip**.

![Image](https://www.copetti.org/images/consoles/ps1/gpu_set.9e375e0fa67ac67ddf07d9ebbf322d54149bd0ab32c3712aa429fb81842ee16b.webp)

The graphics chipset on my motherboard revision: the GPU (right), 1 MB SGRAM (top left), and video DAC (bottom left).