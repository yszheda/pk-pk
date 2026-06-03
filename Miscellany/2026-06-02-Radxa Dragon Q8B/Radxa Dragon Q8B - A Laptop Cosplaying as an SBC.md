---
title: "Radxa Dragon Q8B: A Laptop Cosplaying as an SBC?"
source: https://bret.dk/radxa-dragon-q8b-a-laptop-cosplaying-as-an-sbc/
author:
  - "[[Bret]]"
published: 2026-05-30
created: 2026-06-02
description: The Radxa Q6A was Radxa's first Qualcomm-based SBC release last year, and even though we're still deep in the midst of RAMageddon, Radxa are announcing the
tags:
  - sbc
  - single-board-computer
  - radxa
  - arm
  - hardware
  - linux
  - embedded-systems
  - laptop
---
The Radxa Q6A was Radxa’s first Qualcomm-based SBC release last year, and even though we’re still deep in the midst of RAMageddon, Radxa are announcing the Dragon Q8B today, the very same day you’re reading this. Even I don’t know how I’ve managed that in 2026.

At its core, a Qualcomm Snapdragon 8cx Gen 3 SoC running at 3GHz provides the horsepower, and provide it does. Well, in a sense. If you’re wondering whether this is the same chip that we saw in laptops a couple of years ago, wonder no more, it’s the same one, and oh boy, it’s a ride.

Want the TL;DR? It brute forces its way to the top of the comparison list in this review, leaving the Raspberry Pi 5 in its dust, and also takes the top spot (for now) over on sbc.compare for a large number of tests, so I think Radxa might be on to something? Has this blossoming partnership finally produced an SBC without compromise?!

If you want a bit more than a TL;DR though, buckle up, I’m bringing the waffley ranty first look of yesteryear back, and on the bench we have the 32GB RAM model (I should really increase the valuation on the contents insurance after this) and I’ll be comparing numbers against a range of Radxa’s range, the industry “standard”, and the (previous) number one over on the sbc.compare leaderboards.  
  
A quick word before we get stuck in, mind. This board is only being announced today, and the sample on my bench is an early one running OS builds that are still being tweaked. So this is more of a first look with some initial benchmarks and my early thoughts than a board I’ve lived with for months. The numbers are a snapshot in time, and I’d expect them to shift a touch as the software settles, though I wouldn’t expect anything to change dramatically, it’s mostly a case of polishing what’s already here.s.

![Radxa Dragon Q8B I/O and cooler](https://bret.dk/wp-content/uploads/2026/05/radxa-dragon-q8b-review-top-side-cooler.jpg)

Sample number 6.. The early bird (me) gets the worm (32GB RAM) but at what cost?

***Disclaimer!** To get it out of the way nice and early, Radxa supplied this board ahead of launch for testing (it’s an early sample, and the OS images are still a work in progress, so do bear that in mind throughout) but no money exchanged hands, there was no obligation for a review, and I’m writing this because I want to. As always, all words are my own (nobody would be dumb enough to claim them) and Radxa have had no editorial say before, or after publishing.*

## What Is the Radxa Dragon Q8B?

To get straight to the point, the Dragon Q8B is packing a laptop SoC in an SBC form-factor, which is great for performance, as the Snapdragon 8cx Gen 3 SoC still has plenty in the tank (4x Cortex-X1 cores at 3GHz, and 4x Cortex-A78, at 2.4GHz), and packs one hell of a punch.

Radxa’s Qualcomm steam train seems to have no sign of stopping, and it’s great to see boards actually being launched in the current climate. Heck, they even announced they were working on consumer NAS products based on Qualcomm SoCs this week…

Where things get a little dicey for the Dragon Q8B is software support, annoyingly. The Snapdragon SoC was used primarily for Windows on Arm laptops, and Linux support can be patchy and hacky, but we got there in the end with the help of Armbian (shout out to Meco from [sbcwiki.com](https://sbcwiki.com/) for working on that!) and after my initial testing, Radxa had an Ubuntu 26 build available.

Before we get to the meaty part of the review, let’s quickly confirm the specifications of the Radxa Dragon Q8B, as I think people will be pleasantly surprised.

## Radxa Dragon Q8B Specifications

From speaking to others and seeing public results in places like the Geekbench Browser, we know there are 8, 16, and 32GB SKUs available, all of which offer the same I/O and features overall.

2x USB 3.2 Gen 2 Type-C connectors with DP Alt Mode is rather nice, and packed in a relatively small footprint is a lot of powerful hardware. You get 2×2.5GbE RJ45 ports, a further 2 USB 3.2 Gen 2 ports, this time in Type-A format, 2 M.2 M-Keys on the underside, and a UFS connector for a small, fast, replaceable storage option.

![image](https://bret.dk/wp-content/uploads/2026/05/image.png)

Not seen in this Radxa photo on the underside, is the switch to choose between 12V and 20V USB-PD for the input. You can see the pads for it above the USB 2.0 Type-A ports, along with the silkscreen text, but on the actual board, it looks like this.

![Radxa Dragon Q8B underside showing the USB PD switch for either 12V or 20V input](https://bret.dk/wp-content/uploads/2026/05/radxa-dragon-q8b-review-usb-pd-switch.jpg)

PSU only does 12V? No problem!

## Meet Today’s Competition

I’ve decided to keep it an (almost) all Radxa affair for testing and bring in the [Dragon Q6A](https://sbc.compare/47-radxa-dragon-q6a-6gb), the [ROCK 5B+](https://sbc.compare/17-radxa-rock-5b-plus-16gb/), CIX P1-powered [Orion O6N](https://sbc.compare/101-radxa-orion-o6n-32gb), and for good luck, a [Raspberry Pi 5.](https://sbc.compare/1-raspberry-pi-5-8gb)

I’m hoping they’ll cover all of the bases for comparison, but to quickly justify my choices, the Dragon Q6A is the less powerful sibling of the Q8B, the ROCK 5B+ has one of the most popular SBC SoCs in the Rockchip RK3588, the Orion O6N is one of the most powerful ARM SoCs available in boards like this, and it has 32GB of RAM. The Raspberry Pi 5 gets a spot at the table because, well, everyone knows what it is, and given the pricing at the moment, people are definitely looking alternatives more and more. Do we approve?

## Setup and the State of the Software

At the time of launch we have an Ubuntu 26 build from Radxa directly, and it’s fair to say things are still moving quickly, the builds were being updated even as I was testing.though it only comes in a desktop flavour. Armbian will have you covered if you’d prefer Debian, or server/CLI builds, though it’s not an officially supported OS just yet and you’ll need to build it yourself. All of my testing was done on a Debian 13 build of Armbian, and I cross-checked against Ubuntu and saw nothing out of the ordinary. A week after completing my testing, Radxa also released Debian 13 (Trixie) builds with Gnome/KDE options, and these booted just fine.

It’s not a particularly new SoC, however, and I know others have alternatives like Arch Linux running already, so I imagine we’ll see other distros become available shortly, and once Armbian (hopefully) gets official support, you’ll see a range of pre-installed software options too.

I suppose I do also have to mention that Windows 11’s Windows on ARM (WoA) will work out of the box with this, and this is really what the Qualcomm SoC sees as its bread and butter given than this chip found itself in a range of Windows laptops a few years ago when it came onto the scene. Performance is around what you’d expect from laptops with the same chip, though I imagine Meco on sbcwiki will be checking out Windows and gaming in a little more details, so keep an eye out for his piece too.

![image 1](https://bret.dk/wp-content/uploads/2026/05/image-1.png)

Will you have as much support for things as the Raspberry Pi? No, but then again nearly no SBC has it. If you’ve dealt with any of the alternatives before, you’ll have no problem here, and with Armbian, you can be up and running incredibly quickly, with an interface and base that you’re used to if you’ve used it before.

It’s nice hardware and it’s been around for a few years now (the SoC that is), we just have to hope that we can get the most out of it. There’s mainline Linux support for the chip, so let’s see?

## What’s Not Quite Working (Yet)

I should quickly mention a few things to look out for if Radxa announce, and release this board for sale shortly after. As of Friday 29th May (2026) the Radxa OS builds do not have functioning RJ45. At the time of testing, only a build of Arch Linux that Sophon at Radxa kindly supplied me had the Qualcomm Ethernet ports in a functioning state, but that means that it shouldn’t be too long before we see things ported over to the Radxa OS builds.

The Dragon Q8B also unearthed something in my Linpack testing in the sense that it found a way to draw 50W, almost cook itself, and then hard crash each time. After some digging, I realised that I’d been using the more intensive OpenBLAS algorithm, and I build for all of the optimisations I can detect for the SoC. This has worked fine on over 100 SBCs, but none of those had been laptop SoCs in a small SBC layout. This meant that the PMICs had a really, really bad time, cooked (not in a good way) and gave up after 10s each time.

![Radxa Dragon Q8B with Noctua fan and large heatsink attempting to cool the PMICs](https://bret.dk/wp-content/uploads/2026/05/radxa-dragon-q8b-review-pmic-cooling.jpg)

Not even an industrial Noctua fan and a big ol heatsink could keep things under control

The BIOS currently has the USB ports disabled due to bugs, so the only way to access the BIOS options is via serial. Perhaps Radxa already have an update that handles that that I couldn’t get my hands on in time.

Finally, I was unable to get UFS to be detected on any of the OS builds I tested, and whilst Radxa list UFS and normal OS builds for download on their GitHub repository for the Q8B, it’s not detected when you try to boot from it and it throws you into the BIOS.

Again, I want to stress that this is nitpicking, this is not meant to be an in-depth 6 month in review, but I thought it may be interesting for some to see what the cycle is like during these types of launches/announcements.

## Benchmark Methodology

Into the heart of things we go, and let’s have a quick run down of how the testing is going to go down.

All testing was done over on [sbc.compare](https://sbc.compare/) in a controlled environment with everything set up for maximum performance. The performance CPU governor is in use, the stock cooler was blasting its fan at 100%, and a Noctua industrial fan was blowing across it for good measure too.

A few caveats, if I may. Ollama doesn’t really handle big.LITTLE setups very well, and it’s CPU-only, so take the LLM tests with a pinch of salt as always, though they give us a good enough rough idea. We also have some wildly different RAM configurations on show, and performance may vary slightly depending on your particular work loads, so bear that in mind.

Power was measured using a TC66C USB-C power monitor, with power being delivered by a 21V5A capable USB-C power supply to ensure we had enough juice to give this sneaky laptop in an SBC.

## Radxa Dragon Q8B Benchmarks

We’ll kick off with the CPU-focused benchmarks (oh, I’m also using new graphs for this review, do we like? Do we hate? Please tell me in the comments..) and it’s mostly as you’d expect. The 12 cores of the CIX-powered Orion O6N give it an edge in multi-core workloads, but there’s not much in it. Single core workloads on the other hand are ahead by nearly 27% in Geekbench 6, and the pattern continues throughout. Nice.

### CPU Performance

Single-Core

![radxa dragon q8b](https://bret.dk/wp-content/plugins/sbc-compare/assets/board-images/radxa-dragon-q8b.webp "Radxa Dragon Q8B: A Laptop Cosplaying as an SBC? 22")

Radxa Dragon Q8B 32GB

1,682 Best

![radxa orion o6n](https://bret.dk/wp-content/plugins/sbc-compare/assets/board-images/radxa-orion-o6n.webp "Radxa Dragon Q8B: A Laptop Cosplaying as an SBC? 23")

Radxa Orion O6N 32GB

1,327 79%

![radxa dragon q6a](https://bret.dk/wp-content/plugins/sbc-compare/assets/board-images/radxa-dragon-q6a.webp "Radxa Dragon Q8B: A Laptop Cosplaying as an SBC? 24")

Radxa Dragon Q6A 6GB

1,180 70%

![raspberry pi 5](https://bret.dk/wp-content/plugins/sbc-compare/assets/board-images/raspberry-pi-5.webp "Radxa Dragon Q8B: A Laptop Cosplaying as an SBC? 25")

Raspberry Pi 5 8GB

902 54%

![radxa rock 5b](https://bret.dk/wp-content/plugins/sbc-compare/assets/board-images/radxa-rock-5b.webp "Radxa Dragon Q8B: A Laptop Cosplaying as an SBC? 26")

Radxa ROCK 5B+ 16GB

813 48%

Multi-Core

![radxa orion o6n](https://bret.dk/wp-content/plugins/sbc-compare/assets/board-images/radxa-orion-o6n.webp "Radxa Dragon Q8B: A Laptop Cosplaying as an SBC? 23")

Radxa Orion O6N 32GB

6,954 Best

![radxa dragon q8b](https://bret.dk/wp-content/plugins/sbc-compare/assets/board-images/radxa-dragon-q8b.webp "Radxa Dragon Q8B: A Laptop Cosplaying as an SBC? 22")

Radxa Dragon Q8B 32GB

6,897 99%

![radxa dragon q6a](https://bret.dk/wp-content/plugins/sbc-compare/assets/board-images/radxa-dragon-q6a.webp "Radxa Dragon Q8B: A Laptop Cosplaying as an SBC? 24")

Radxa Dragon Q6A 6GB

3,215 46%

![radxa rock 5b](https://bret.dk/wp-content/plugins/sbc-compare/assets/board-images/radxa-rock-5b.webp "Radxa Dragon Q8B: A Laptop Cosplaying as an SBC? 26")

Radxa ROCK 5B+ 16GB

2,944 42%

![raspberry pi 5](https://bret.dk/wp-content/plugins/sbc-compare/assets/board-images/raspberry-pi-5.webp "Radxa Dragon Q8B: A Laptop Cosplaying as an SBC? 25")

Raspberry Pi 5 8GB

2,188 31%

Single-Core Combined

![radxa dragon q8b](https://bret.dk/wp-content/plugins/sbc-compare/assets/board-images/radxa-dragon-q8b.webp "Radxa Dragon Q8B: A Laptop Cosplaying as an SBC? 22")

Radxa Dragon Q8B 32GB

4,373 MIPS Best

![radxa orion o6n](https://bret.dk/wp-content/plugins/sbc-compare/assets/board-images/radxa-orion-o6n.webp "Radxa Dragon Q8B: A Laptop Cosplaying as an SBC? 23")

Radxa Orion O6N 32GB

3,867 MIPS 88%

![radxa dragon q6a](https://bret.dk/wp-content/plugins/sbc-compare/assets/board-images/radxa-dragon-q6a.webp "Radxa Dragon Q8B: A Laptop Cosplaying as an SBC? 24")

Radxa Dragon Q6A 6GB

3,829 MIPS 88%

![raspberry pi 5](https://bret.dk/wp-content/plugins/sbc-compare/assets/board-images/raspberry-pi-5.webp "Radxa Dragon Q8B: A Laptop Cosplaying as an SBC? 25")

Raspberry Pi 5 8GB

3,334 MIPS 76%

![radxa rock 5b](https://bret.dk/wp-content/plugins/sbc-compare/assets/board-images/radxa-rock-5b.webp "Radxa Dragon Q8B: A Laptop Cosplaying as an SBC? 26")

Radxa ROCK 5B+ 16GB

2,883 MIPS 66%

Multi-Core Combined

![radxa dragon q8b](https://bret.dk/wp-content/plugins/sbc-compare/assets/board-images/radxa-dragon-q8b.webp "Radxa Dragon Q8B: A Laptop Cosplaying as an SBC? 22")

Radxa Dragon Q8B 32GB

35,576 MIPS Best

![radxa orion o6n](https://bret.dk/wp-content/plugins/sbc-compare/assets/board-images/radxa-orion-o6n.webp "Radxa Dragon Q8B: A Laptop Cosplaying as an SBC? 23")

Radxa Orion O6N 32GB

33,823 MIPS 95%

![radxa dragon q6a](https://bret.dk/wp-content/plugins/sbc-compare/assets/board-images/radxa-dragon-q6a.webp "Radxa Dragon Q8B: A Laptop Cosplaying as an SBC? 24")

Radxa Dragon Q6A 6GB

17,401 MIPS 49%

![radxa rock 5b](https://bret.dk/wp-content/plugins/sbc-compare/assets/board-images/radxa-rock-5b.webp "Radxa Dragon Q8B: A Laptop Cosplaying as an SBC? 26")

Radxa ROCK 5B+ 16GB

15,470 MIPS 43%

![raspberry pi 5](https://bret.dk/wp-content/plugins/sbc-compare/assets/board-images/raspberry-pi-5.webp "Radxa Dragon Q8B: A Laptop Cosplaying as an SBC? 25")

Raspberry Pi 5 8GB

12,000 MIPS 34%

Performance

![radxa orion o6n](https://bret.dk/wp-content/plugins/sbc-compare/assets/board-images/radxa-orion-o6n.webp "Radxa Dragon Q8B: A Laptop Cosplaying as an SBC? 23")

Radxa Orion O6N 32GB

137.16 GFLOPS Best

![radxa rock 5b](https://bret.dk/wp-content/plugins/sbc-compare/assets/board-images/radxa-rock-5b.webp "Radxa Dragon Q8B: A Laptop Cosplaying as an SBC? 26")

Radxa ROCK 5B+ 16GB

44.15 GFLOPS 32%

![radxa dragon q6a](https://bret.dk/wp-content/plugins/sbc-compare/assets/board-images/radxa-dragon-q6a.webp "Radxa Dragon Q8B: A Laptop Cosplaying as an SBC? 24")

Radxa Dragon Q6A 6GB

38.66 GFLOPS 28%

![raspberry pi 5](https://bret.dk/wp-content/plugins/sbc-compare/assets/board-images/raspberry-pi-5.webp "Radxa Dragon Q8B: A Laptop Cosplaying as an SBC? 25")

Raspberry Pi 5 8GB

36.60 GFLOPS 27%

![radxa dragon q8b](https://bret.dk/wp-content/plugins/sbc-compare/assets/board-images/radxa-dragon-q8b.webp "Radxa Dragon Q8B: A Laptop Cosplaying as an SBC? 22")

Radxa Dragon Q8B 32GB

No Data

Performance/Watt

![radxa dragon q6a](https://bret.dk/wp-content/plugins/sbc-compare/assets/board-images/radxa-dragon-q6a.webp "Radxa Dragon Q8B: A Laptop Cosplaying as an SBC? 24")

Radxa Dragon Q6A 6GB

3.83 GFLOPS/W Best

![radxa orion o6n](https://bret.dk/wp-content/plugins/sbc-compare/assets/board-images/radxa-orion-o6n.webp "Radxa Dragon Q8B: A Laptop Cosplaying as an SBC? 23")

Radxa Orion O6N 32GB

3.52 GFLOPS/W 92%

![raspberry pi 5](https://bret.dk/wp-content/plugins/sbc-compare/assets/board-images/raspberry-pi-5.webp "Radxa Dragon Q8B: A Laptop Cosplaying as an SBC? 25")

Raspberry Pi 5 8GB

3.16 GFLOPS/W 82%

![radxa rock 5b](https://bret.dk/wp-content/plugins/sbc-compare/assets/board-images/radxa-rock-5b.webp "Radxa Dragon Q8B: A Laptop Cosplaying as an SBC? 26")

Radxa ROCK 5B+ 16GB

2.30 GFLOPS/W 60%

![radxa dragon q8b](https://bret.dk/wp-content/plugins/sbc-compare/assets/board-images/radxa-dragon-q8b.webp "Radxa Dragon Q8B: A Laptop Cosplaying as an SBC? 22")

Radxa Dragon Q8B 32GB

No Data

Single Core

![radxa dragon q8b](https://bret.dk/wp-content/plugins/sbc-compare/assets/board-images/radxa-dragon-q8b.webp "Radxa Dragon Q8B: A Laptop Cosplaying as an SBC? 22")

Radxa Dragon Q8B 32GB

1,756 Best

![raspberry pi 5](https://bret.dk/wp-content/plugins/sbc-compare/assets/board-images/raspberry-pi-5.webp "Radxa Dragon Q8B: A Laptop Cosplaying as an SBC? 25")

Raspberry Pi 5 8GB

1,654 94%

![radxa orion o6n](https://bret.dk/wp-content/plugins/sbc-compare/assets/board-images/radxa-orion-o6n.webp "Radxa Dragon Q8B: A Laptop Cosplaying as an SBC? 23")

Radxa Orion O6N 32GB

1,386 79%

![radxa dragon q6a](https://bret.dk/wp-content/plugins/sbc-compare/assets/board-images/radxa-dragon-q6a.webp "Radxa Dragon Q8B: A Laptop Cosplaying as an SBC? 24")

Radxa Dragon Q6A 6GB

1,310 75%

![radxa rock 5b](https://bret.dk/wp-content/plugins/sbc-compare/assets/board-images/radxa-rock-5b.webp "Radxa Dragon Q8B: A Laptop Cosplaying as an SBC? 26")

Radxa ROCK 5B+ 16GB

1,280 73%

Multi Core

![radxa dragon q8b](https://bret.dk/wp-content/plugins/sbc-compare/assets/board-images/radxa-dragon-q8b.webp "Radxa Dragon Q8B: A Laptop Cosplaying as an SBC? 22")

Radxa Dragon Q8B 32GB

10,730 Best

![radxa orion o6n](https://bret.dk/wp-content/plugins/sbc-compare/assets/board-images/radxa-orion-o6n.webp "Radxa Dragon Q8B: A Laptop Cosplaying as an SBC? 23")

Radxa Orion O6N 32GB

9,742 91%

![radxa rock 5b](https://bret.dk/wp-content/plugins/sbc-compare/assets/board-images/radxa-rock-5b.webp "Radxa Dragon Q8B: A Laptop Cosplaying as an SBC? 26")

Radxa ROCK 5B+ 16GB

6,076 57%

![radxa dragon q6a](https://bret.dk/wp-content/plugins/sbc-compare/assets/board-images/radxa-dragon-q6a.webp "Radxa Dragon Q8B: A Laptop Cosplaying as an SBC? 24")

Radxa Dragon Q6A 6GB

5,300 49%

![raspberry pi 5](https://bret.dk/wp-content/plugins/sbc-compare/assets/board-images/raspberry-pi-5.webp "Radxa Dragon Q8B: A Laptop Cosplaying as an SBC? 25")

Raspberry Pi 5 8GB

4,920 46%

CPU Score

![radxa orion o6n](https://bret.dk/wp-content/plugins/sbc-compare/assets/board-images/radxa-orion-o6n.webp "Radxa Dragon Q8B: A Laptop Cosplaying as an SBC? 23")

Radxa Orion O6N 32GB

7,269 Best

![radxa dragon q8b](https://bret.dk/wp-content/plugins/sbc-compare/assets/board-images/radxa-dragon-q8b.webp "Radxa Dragon Q8B: A Laptop Cosplaying as an SBC? 22")

Radxa Dragon Q8B 32GB

6,277 86%

![radxa dragon q6a](https://bret.dk/wp-content/plugins/sbc-compare/assets/board-images/radxa-dragon-q6a.webp "Radxa Dragon Q8B: A Laptop Cosplaying as an SBC? 24")

Radxa Dragon Q6A 6GB

3,525 48%

![radxa rock 5b](https://bret.dk/wp-content/plugins/sbc-compare/assets/board-images/radxa-rock-5b.webp "Radxa Dragon Q8B: A Laptop Cosplaying as an SBC? 26")

Radxa ROCK 5B+ 16GB

2,778 38%

![raspberry pi 5](https://bret.dk/wp-content/plugins/sbc-compare/assets/board-images/raspberry-pi-5.webp "Radxa Dragon Q8B: A Laptop Cosplaying as an SBC? 25")

Raspberry Pi 5 8GB

2,394 33%

RAM Score

![radxa dragon q8b](https://bret.dk/wp-content/plugins/sbc-compare/assets/board-images/radxa-dragon-q8b.webp "Radxa Dragon Q8B: A Laptop Cosplaying as an SBC? 22")

Radxa Dragon Q8B 32GB

2,354 Best

![radxa orion o6n](https://bret.dk/wp-content/plugins/sbc-compare/assets/board-images/radxa-orion-o6n.webp "Radxa Dragon Q8B: A Laptop Cosplaying as an SBC? 23")

Radxa Orion O6N 32GB

1,953 83%

![radxa dragon q6a](https://bret.dk/wp-content/plugins/sbc-compare/assets/board-images/radxa-dragon-q6a.webp "Radxa Dragon Q8B: A Laptop Cosplaying as an SBC? 24")

Radxa Dragon Q6A 6GB

1,871 79%

![raspberry pi 5](https://bret.dk/wp-content/plugins/sbc-compare/assets/board-images/raspberry-pi-5.webp "Radxa Dragon Q8B: A Laptop Cosplaying as an SBC? 25")

Raspberry Pi 5 8GB

1,374 58%

![radxa rock 5b](https://bret.dk/wp-content/plugins/sbc-compare/assets/board-images/radxa-rock-5b.webp "Radxa Dragon Q8B: A Laptop Cosplaying as an SBC? 26")

Radxa ROCK 5B+ 16GB

1,346 57%

Single Core

![radxa dragon q8b](https://bret.dk/wp-content/plugins/sbc-compare/assets/board-images/radxa-dragon-q8b.webp "Radxa Dragon Q8B: A Laptop Cosplaying as an SBC? 22")

Radxa Dragon Q8B 32GB

6.46 kH/s Best

![radxa dragon q6a](https://bret.dk/wp-content/plugins/sbc-compare/assets/board-images/radxa-dragon-q6a.webp "Radxa Dragon Q8B: A Laptop Cosplaying as an SBC? 24")

Radxa Dragon Q6A 6GB

5.07 kH/s 78%

![radxa orion o6n](https://bret.dk/wp-content/plugins/sbc-compare/assets/board-images/radxa-orion-o6n.webp "Radxa Dragon Q8B: A Laptop Cosplaying as an SBC? 23")

Radxa Orion O6N 32GB

4.84 kH/s 75%

![raspberry pi 5](https://bret.dk/wp-content/plugins/sbc-compare/assets/board-images/raspberry-pi-5.webp "Radxa Dragon Q8B: A Laptop Cosplaying as an SBC? 25")

Raspberry Pi 5 8GB

3.86 kH/s 60%

![radxa rock 5b](https://bret.dk/wp-content/plugins/sbc-compare/assets/board-images/radxa-rock-5b.webp "Radxa Dragon Q8B: A Laptop Cosplaying as an SBC? 26")

Radxa ROCK 5B+ 16GB

3.64 kH/s 56%

Multi Core

![radxa dragon q8b](https://bret.dk/wp-content/plugins/sbc-compare/assets/board-images/radxa-dragon-q8b.webp "Radxa Dragon Q8B: A Laptop Cosplaying as an SBC? 22")

Radxa Dragon Q8B 32GB

45.49 kH/s Best

![radxa orion o6n](https://bret.dk/wp-content/plugins/sbc-compare/assets/board-images/radxa-orion-o6n.webp "Radxa Dragon Q8B: A Laptop Cosplaying as an SBC? 23")

Radxa Orion O6N 32GB

42.99 kH/s 95%

![radxa dragon q6a](https://bret.dk/wp-content/plugins/sbc-compare/assets/board-images/radxa-dragon-q6a.webp "Radxa Dragon Q8B: A Laptop Cosplaying as an SBC? 24")

Radxa Dragon Q6A 6GB

26.25 kH/s 58%

![radxa rock 5b](https://bret.dk/wp-content/plugins/sbc-compare/assets/board-images/radxa-rock-5b.webp "Radxa Dragon Q8B: A Laptop Cosplaying as an SBC? 26")

Radxa ROCK 5B+ 16GB

21.43 kH/s 47%

![raspberry pi 5](https://bret.dk/wp-content/plugins/sbc-compare/assets/board-images/raspberry-pi-5.webp "Radxa Dragon Q8B: A Laptop Cosplaying as an SBC? 25")

Raspberry Pi 5 8GB

15.43 kH/s 34%

### Storage and I/O

What you’ll immediately see here is that the 4 lanes of PCIe Gen 3 connectivity given to one of the M.2 slots on the Q8B give it a massive advantage, and providing you’re lucky enough to have a drive laying around to make the most of that without bankrupting you right now, you’re going to have a good time.

![Radxa Dragon Q8B underside showing the 2 M.2 M-Key connectors](https://bret.dk/wp-content/uploads/2026/05/radxa-dragon-q8b-review-m2-nvme-slots.jpg)

If you have a fast M.2 device that can use the 4 lanes of Gen 3, make sure you select the right connector!

UFS as an alternative is a great option (on the Orion O6N this is connected via a USB bridge, hence the not so great performance for comparison) but the modules aren’t as readily available, and larger capacities can also be quite expensive in this day and age. Its connector is also hidden by 1 of the 2 M.2 slots if a 2280 NVMe is installed in the Gen 3 x2 slot, so if both are in use, they could get a little toasty. Well, when support is added for them that is.

4K Sequential Read

Radxa Dragon Q8B — Crucial P5 Plus 1024GB

1,136.0 MB/s Best

Radxa Orion O6N — Crucial P5 Plus 1024GB

925.6 MB/s 81%

Raspberry Pi 5 — Crucial P5 Plus 1024GB

866.5 MB/s 76%

Radxa Dragon Q6A — Crucial P5 Plus 1024GB

645.5 MB/s 57%

Radxa ROCK 5B+ — Crucial P5 Plus 1024GB

621.4 MB/s 55%

Radxa Dragon Q6A — Radxa UFS 128GB

493.4 MB/s Best

Radxa Orion O6N — Radxa UFS 128GB

37.7 MB/s 8%

Raspberry Pi 5 — Raspberry Pi 64GB

38.8 MB/s Best

Radxa Dragon Q8B — Raspberry Pi 64GB

26.1 MB/s 67%

Radxa Dragon Q6A — Raspberry Pi 64GB

22.6 MB/s 58%

Radxa ROCK 5B+ — Raspberry Pi 64GB

19.1 MB/s 49%

4K Sequential Write

Radxa Dragon Q8B — Crucial P5 Plus 1024GB

1,110.3 MB/s Best

Radxa Orion O6N — Crucial P5 Plus 1024GB

654.2 MB/s 59%

Raspberry Pi 5 — Crucial P5 Plus 1024GB

604.9 MB/s 54%

Radxa ROCK 5B+ — Crucial P5 Plus 1024GB

479.3 MB/s 43%

Radxa Dragon Q6A — Crucial P5 Plus 1024GB

456.4 MB/s 41%

Radxa Dragon Q6A — Radxa UFS 128GB

274.3 MB/s Best

Radxa Orion O6N — Radxa UFS 128GB

35.2 MB/s 13%

Raspberry Pi 5 — Raspberry Pi 64GB

35.6 MB/s Best

Radxa Dragon Q8B — Raspberry Pi 64GB

10.8 MB/s 30%

Radxa ROCK 5B+ — Raspberry Pi 64GB

7.7 MB/s 22%

Radxa Dragon Q6A — Raspberry Pi 64GB

6.7 MB/s 19%

4K Random Read

Radxa Dragon Q8B — Crucial P5 Plus 1024GB

1,119.1 MB/s Best

Raspberry Pi 5 — Crucial P5 Plus 1024GB

866.5 MB/s 77%

Radxa Orion O6N — Crucial P5 Plus 1024GB

863.6 MB/s 77%

Radxa Dragon Q6A — Crucial P5 Plus 1024GB

608.5 MB/s 54%

Radxa ROCK 5B+ — Crucial P5 Plus 1024GB

581.8 MB/s 52%

Radxa Dragon Q6A — Radxa UFS 128GB

475.1 MB/s Best

Radxa Orion O6N — Radxa UFS 128GB

16.3 MB/s 3%

Raspberry Pi 5 — Raspberry Pi 64GB

22.0 MB/s Best

Radxa Dragon Q8B — Raspberry Pi 64GB

20.4 MB/s 93%

Radxa Dragon Q6A — Raspberry Pi 64GB

17.4 MB/s 79%

Radxa ROCK 5B+ — Raspberry Pi 64GB

16.4 MB/s 75%

4K Random Write

Radxa Dragon Q8B — Crucial P5 Plus 1024GB

1,090.9 MB/s Best

Radxa Orion O6N — Crucial P5 Plus 1024GB

640.7 MB/s 59%

Raspberry Pi 5 — Crucial P5 Plus 1024GB

590.6 MB/s 54%

Radxa ROCK 5B+ — Crucial P5 Plus 1024GB

466.3 MB/s 43%

Radxa Dragon Q6A — Crucial P5 Plus 1024GB

437.4 MB/s 40%

Radxa Dragon Q6A — Radxa UFS 128GB

254.9 MB/s Best

Radxa Orion O6N — Radxa UFS 128GB

20.4 MB/s 8%

Raspberry Pi 5 — Raspberry Pi 64GB

15.1 MB/s Best

Radxa Dragon Q6A — Raspberry Pi 64GB

13.9 MB/s 92%

Radxa Dragon Q8B — Raspberry Pi 64GB

12.5 MB/s 83%

Radxa ROCK 5B+ — Raspberry Pi 64GB

11.1 MB/s 74%

### Graphics and the Adreno GPU

I was unable to get the Q6A to play ball in time to publish this initially, though in the coming week or so I’ll be going back to add that. Overall, however, the story is much the same. If you compare these boards over on sbc.compare you’ll be able to see the drivers that are in use, because it’s a bit of a mixed bag between what Armbian bundle, and OS vendors themselves. GLMark2 goes the way of the CIX P1, but vkmark has the Q8B absolutely trouncing the competition.

1080p

![radxa orion o6n](https://bret.dk/wp-content/plugins/sbc-compare/assets/board-images/radxa-orion-o6n.webp "Radxa Dragon Q8B: A Laptop Cosplaying as an SBC? 23")

Radxa Orion O6N 32GB

1,717 Best

![radxa dragon q8b](https://bret.dk/wp-content/plugins/sbc-compare/assets/board-images/radxa-dragon-q8b.webp "Radxa Dragon Q8B: A Laptop Cosplaying as an SBC? 22")

Radxa Dragon Q8B 32GB

1,499 87%

![radxa rock 5b](https://bret.dk/wp-content/plugins/sbc-compare/assets/board-images/radxa-rock-5b.webp "Radxa Dragon Q8B: A Laptop Cosplaying as an SBC? 26")

Radxa ROCK 5B+ 16GB

947 55%

![raspberry pi 5](https://bret.dk/wp-content/plugins/sbc-compare/assets/board-images/raspberry-pi-5.webp "Radxa Dragon Q8B: A Laptop Cosplaying as an SBC? 25")

Raspberry Pi 5 8GB

657 38%

![radxa dragon q6a](https://bret.dk/wp-content/plugins/sbc-compare/assets/board-images/radxa-dragon-q6a.webp "Radxa Dragon Q8B: A Laptop Cosplaying as an SBC? 24")

Radxa Dragon Q6A 6GB

No Data

4K

![radxa orion o6n](https://bret.dk/wp-content/plugins/sbc-compare/assets/board-images/radxa-orion-o6n.webp "Radxa Dragon Q8B: A Laptop Cosplaying as an SBC? 23")

Radxa Orion O6N 32GB

632 Best

![radxa dragon q8b](https://bret.dk/wp-content/plugins/sbc-compare/assets/board-images/radxa-dragon-q8b.webp "Radxa Dragon Q8B: A Laptop Cosplaying as an SBC? 22")

Radxa Dragon Q8B 32GB

475 75%

![radxa rock 5b](https://bret.dk/wp-content/plugins/sbc-compare/assets/board-images/radxa-rock-5b.webp "Radxa Dragon Q8B: A Laptop Cosplaying as an SBC? 26")

Radxa ROCK 5B+ 16GB

279 44%

![raspberry pi 5](https://bret.dk/wp-content/plugins/sbc-compare/assets/board-images/raspberry-pi-5.webp "Radxa Dragon Q8B: A Laptop Cosplaying as an SBC? 25")

Raspberry Pi 5 8GB

150 24%

![radxa dragon q6a](https://bret.dk/wp-content/plugins/sbc-compare/assets/board-images/radxa-dragon-q6a.webp "Radxa Dragon Q8B: A Laptop Cosplaying as an SBC? 24")

Radxa Dragon Q6A 6GB

No Data

1080p

![radxa dragon q8b](https://bret.dk/wp-content/plugins/sbc-compare/assets/board-images/radxa-dragon-q8b.webp "Radxa Dragon Q8B: A Laptop Cosplaying as an SBC? 22")

Radxa Dragon Q8B 32GB

5,281 Best

![radxa rock 5b](https://bret.dk/wp-content/plugins/sbc-compare/assets/board-images/radxa-rock-5b.webp "Radxa Dragon Q8B: A Laptop Cosplaying as an SBC? 26")

Radxa ROCK 5B+ 16GB

1,405 27%

![radxa orion o6n](https://bret.dk/wp-content/plugins/sbc-compare/assets/board-images/radxa-orion-o6n.webp "Radxa Dragon Q8B: A Laptop Cosplaying as an SBC? 23")

Radxa Orion O6N 32GB

902 17%

![raspberry pi 5](https://bret.dk/wp-content/plugins/sbc-compare/assets/board-images/raspberry-pi-5.webp "Radxa Dragon Q8B: A Laptop Cosplaying as an SBC? 25")

Raspberry Pi 5 8GB

406 8%

![radxa dragon q6a](https://bret.dk/wp-content/plugins/sbc-compare/assets/board-images/radxa-dragon-q6a.webp "Radxa Dragon Q8B: A Laptop Cosplaying as an SBC? 24")

Radxa Dragon Q6A 6GB

No Data

4K

![radxa dragon q8b](https://bret.dk/wp-content/plugins/sbc-compare/assets/board-images/radxa-dragon-q8b.webp "Radxa Dragon Q8B: A Laptop Cosplaying as an SBC? 22")

Radxa Dragon Q8B 32GB

1,400 Best

![radxa rock 5b](https://bret.dk/wp-content/plugins/sbc-compare/assets/board-images/radxa-rock-5b.webp "Radxa Dragon Q8B: A Laptop Cosplaying as an SBC? 26")

Radxa ROCK 5B+ 16GB

435 31%

![radxa orion o6n](https://bret.dk/wp-content/plugins/sbc-compare/assets/board-images/radxa-orion-o6n.webp "Radxa Dragon Q8B: A Laptop Cosplaying as an SBC? 23")

Radxa Orion O6N 32GB

309 22%

![raspberry pi 5](https://bret.dk/wp-content/plugins/sbc-compare/assets/board-images/raspberry-pi-5.webp "Radxa Dragon Q8B: A Laptop Cosplaying as an SBC? 25")

Raspberry Pi 5 8GB

93 7%

![radxa dragon q6a](https://bret.dk/wp-content/plugins/sbc-compare/assets/board-images/radxa-dragon-q6a.webp "Radxa Dragon Q8B: A Laptop Cosplaying as an SBC? 24")

Radxa Dragon Q6A 6GB

No Data

## Power Consumption and Thermals

We already know about the CIX P1’s bruteforce approach to power consumption, as in, just throw everything you have at the SoC and keep it running as fast as you can.

This works well for the Dragon Q8B because it’s much faster in nearly every test, and does it whilst consuming less power across fewer CPU cores. No Linpack power results here because of the earlier mentioned instability. I could get it to run on the 4 X1 cores, but I wasn’t going to add that data to the database and confuse things.

Idle Power

![radxa dragon q6a](https://bret.dk/wp-content/plugins/sbc-compare/assets/board-images/radxa-dragon-q6a.webp "Radxa Dragon Q8B: A Laptop Cosplaying as an SBC? 24")

Radxa Dragon Q6A 6GB

2.50W Best

![radxa dragon q8b](https://bret.dk/wp-content/plugins/sbc-compare/assets/board-images/radxa-dragon-q8b.webp "Radxa Dragon Q8B: A Laptop Cosplaying as an SBC? 22")

Radxa Dragon Q8B 32GB

3.50W 71%

![radxa orion o6n](https://bret.dk/wp-content/plugins/sbc-compare/assets/board-images/radxa-orion-o6n.webp "Radxa Dragon Q8B: A Laptop Cosplaying as an SBC? 23")

Radxa Orion O6N 32GB

9.30W 27%

![raspberry pi 5](https://bret.dk/wp-content/plugins/sbc-compare/assets/board-images/raspberry-pi-5.webp "Radxa Dragon Q8B: A Laptop Cosplaying as an SBC? 25")

Raspberry Pi 5 8GB

No Data

![radxa rock 5b](https://bret.dk/wp-content/plugins/sbc-compare/assets/board-images/radxa-rock-5b.webp "Radxa Dragon Q8B: A Laptop Cosplaying as an SBC? 26")

Radxa ROCK 5B+ 16GB

No Data

Load Power

![radxa dragon q6a](https://bret.dk/wp-content/plugins/sbc-compare/assets/board-images/radxa-dragon-q6a.webp "Radxa Dragon Q8B: A Laptop Cosplaying as an SBC? 24")

Radxa Dragon Q6A 6GB

6.40W Best

![raspberry pi 5](https://bret.dk/wp-content/plugins/sbc-compare/assets/board-images/raspberry-pi-5.webp "Radxa Dragon Q8B: A Laptop Cosplaying as an SBC? 25")

Raspberry Pi 5 8GB

6.50W 98%

![radxa rock 5b](https://bret.dk/wp-content/plugins/sbc-compare/assets/board-images/radxa-rock-5b.webp "Radxa Dragon Q8B: A Laptop Cosplaying as an SBC? 26")

Radxa ROCK 5B+ 16GB

8.60W 74%

![radxa dragon q8b](https://bret.dk/wp-content/plugins/sbc-compare/assets/board-images/radxa-dragon-q8b.webp "Radxa Dragon Q8B: A Laptop Cosplaying as an SBC? 22")

Radxa Dragon Q8B 32GB

21.70W 29%

![radxa orion o6n](https://bret.dk/wp-content/plugins/sbc-compare/assets/board-images/radxa-orion-o6n.webp "Radxa Dragon Q8B: A Laptop Cosplaying as an SBC? 23")

Radxa Orion O6N 32GB

23.70W 27%

Ollama Max

![radxa dragon q6a](https://bret.dk/wp-content/plugins/sbc-compare/assets/board-images/radxa-dragon-q6a.webp "Radxa Dragon Q8B: A Laptop Cosplaying as an SBC? 24")

Radxa Dragon Q6A 6GB

7.50W Best

![raspberry pi 5](https://bret.dk/wp-content/plugins/sbc-compare/assets/board-images/raspberry-pi-5.webp "Radxa Dragon Q8B: A Laptop Cosplaying as an SBC? 25")

Raspberry Pi 5 8GB

10.80W 69%

![radxa rock 5b](https://bret.dk/wp-content/plugins/sbc-compare/assets/board-images/radxa-rock-5b.webp "Radxa Dragon Q8B: A Laptop Cosplaying as an SBC? 26")

Radxa ROCK 5B+ 16GB

14.30W 52%

![radxa dragon q8b](https://bret.dk/wp-content/plugins/sbc-compare/assets/board-images/radxa-dragon-q8b.webp "Radxa Dragon Q8B: A Laptop Cosplaying as an SBC? 22")

Radxa Dragon Q8B 32GB

28.10W 27%

![radxa orion o6n](https://bret.dk/wp-content/plugins/sbc-compare/assets/board-images/radxa-orion-o6n.webp "Radxa Dragon Q8B: A Laptop Cosplaying as an SBC? 23")

Radxa Orion O6N 32GB

33.90W 22%

Linpack Max

![radxa dragon q6a](https://bret.dk/wp-content/plugins/sbc-compare/assets/board-images/radxa-dragon-q6a.webp "Radxa Dragon Q8B: A Laptop Cosplaying as an SBC? 24")

Radxa Dragon Q6A 6GB

10.10W Best

![raspberry pi 5](https://bret.dk/wp-content/plugins/sbc-compare/assets/board-images/raspberry-pi-5.webp "Radxa Dragon Q8B: A Laptop Cosplaying as an SBC? 25")

Raspberry Pi 5 8GB

11.60W 87%

![radxa rock 5b](https://bret.dk/wp-content/plugins/sbc-compare/assets/board-images/radxa-rock-5b.webp "Radxa Dragon Q8B: A Laptop Cosplaying as an SBC? 26")

Radxa ROCK 5B+ 16GB

19.20W 53%

![radxa orion o6n](https://bret.dk/wp-content/plugins/sbc-compare/assets/board-images/radxa-orion-o6n.webp "Radxa Dragon Q8B: A Laptop Cosplaying as an SBC? 23")

Radxa Orion O6N 32GB

39W 26%

![radxa dragon q8b](https://bret.dk/wp-content/plugins/sbc-compare/assets/board-images/radxa-dragon-q8b.webp "Radxa Dragon Q8B: A Laptop Cosplaying as an SBC? 22")

Radxa Dragon Q8B 32GB

No Data

## Radxa Dragon Q8B Pricing and Availability

OK, so we’ve been through all of the data, we’ve looked at everything, but given the announcement was today, where can we buy one and how much will they cost?

So far I could only find them listed on Arace, and their UI doesn’t really let you click around and see the prices of each SKU, just the default one, but in the page source we have all of the data, and it’s a mixed bag.

| Variant | SKU | Price (USD) |
| --- | --- | --- |
| Radxa Dragon Q8B 4GB | RS782-D4S32W0 | $149.00 |
| Radxa Dragon Q8B 8GB | RS782-D8S32W0 | $209.00 |
| Radxa Dragon Q8B 16GB | RS782-D16S32W0 | $329.00 |
| Radxa Dragon Q8B 32GB | RS782-D32S32W0 | $569.00 |
| Heatsink for Radxa Dragon Q8B | AE038 | $3.90 |

The heatsink pricing is good, though I’d probably have liked for it to be included in the price of the boards themselves and at least bundled together, if not pre-installed. You’re going to want cooling for this, and not everyone’s going to have something that fits perfectly, if at all.

Arace were also doing their usual “pay $5 to get a $50 coupon” type of deal, though at the time of writing/publishing, this was sold out already. I’m not sure if they’ve actually gone on sale yet, or if they did sell out quickly, but if you’re lucky enough to get your hands on one then the middle-ground models with $50 off don’t look like too bad value given the current climate. Heck, it’s great value actually when you look at the performance you’re getting.

The question will just be when they’re going to be available, as there doesn’t seem to be a date given yet, and these things tend to be announced a month or so (at least) before they’re made available, and will all SKUs be available?

## Closing Thoughts

Even at this early stage, the Radxa Dragon Q8B impresses and takes the number 1 spot in nearly every test on [sbc.compare](https://sbc.compare/116-radxa-dragon-q8b-32gb). With the pricing we now have, it’s a pretty damn compelling purchase, especially if you’re going to be able to get the most out of all of the hardware. Dual 2.5GbE RJ45, powerful X1/A78 cores, and plenty of high speed I/O make it a great option for routers, a NAS, a teeny browsing machine, or even some light gaming.

Radxa are drinking all of the Qualcomm Kool-Aid, and the releases are coming thick and fast (there was also a Radxa Dragon Q5E announced today, though sadly I don’t have one to show results for yet!)

I can’t complain about what’s not working just yet, as it was an early sample and development is still ongoing, but honestly? It’s not far off. I think in the next release or two of their builds, we’ll have full functionality in Radxa OS, and Armbian won’t be far behind. Powerful hardware, software we’re all used to? What’s not to (potentially) love.

What are you guys thinking about the wave of Qualcomm-based SBC releases, we saw the [Arduino UNO Q](https://sbc.compare/96-arduino-uno-q-2gb) towards the end of last year on the lower-end (in terms of raw performance at least, it wasn’t about that) and Radxa seem to be doing their best to flaunt everything Qualcomm has to offer, be it SBCs, NAS, you name it, Radxa will probably try and launch it..

If you’ve made it this far, thank you, and congratulations, I’ll go back to my hole now. Bye!

**Related Posts**