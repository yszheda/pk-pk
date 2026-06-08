---
title: "Chuwi Minibook X: the netbook we deserve"
source: https://tylercipriani.com/blog/2026/05/28/chuwi-minibook-x/
author:
  - "[[Tyler Cipriani]]"
published: 2026-06-01
created: 2026-06-03
description:
tags:
  - ToRead
  - hardware
  - sbc
  - linux
  - laptop
---
Netbooks are dead, but the Chuwi Minibook X scratches the same itch.

The Minibook X is a 10.5″ x86\_64 sub-ultrabook with 16GB RAM, a 512GB NVMe drive, and only one majorly annyoing Linux quirk.

I needed a knock-around laptop, so I bought myself a Minibook for my birthday last year. The more I tote it around, the more fun I’m having with this ridiculous little computer.

![Chuwi Minibook X, KDE lock screen](https://photos.tylercipriani.com/thumbs/58/ec9d31f64e7d203a6d40603d8ec352/larger.avif)

Chuwi Minibook X, KDE lock screen

## Quick specs

Much like the netbooks of yore, the Minibook is a budget machine. But it’s 2026, so even budget machines pack more oomph than I need from a utility laptop.

- CPU 4-core/4-thread 3.6GHz Intel N150 Twin Lake
- 16 GB RAM – LPDDR5-6400 – soldered 😿
- 512GB NVMe – upgradable
- 10.51” IPS 2K 16:10 screen
- 28.88Wh Li-Ion battery
- Weight: 911g
- Ports: 2×USB-C (1×PD charging)
- Cost: $350
![Chuwi Minibook with back cover removed, exposing battery and NVMe drive](https://photos.tylercipriani.com/thumbs/a1/cbe8bd56a1085ab2e3c7a6388bed5f/larger.avif)

Chuwi Minibook with back cover removed, exposing battery and NVMe drive

One oddity is that the Minibook comes bundled with a 12V/2A USB-C charger. I chucked the charger; I worried I’d fry some 5V SoC someday. The Minibook works fine with a PD charger.

![Minibook X using a PD Charger at 20V](https://photos.tylercipriani.com/thumbs/18/7a50ffe3248627bddf4ca435c047a5/medium.avif)

Minibook X using a PD Charger at 20V

I’d assume the 12V charger was a cost-saving choice, but it also creates some weird possibilities for DC/off-grid setups.

## Linux and weirdness: sideways panels and kernel parameters

![Charlie Stross, one of my favorite SciFi authors, recommended the Chuwi Minibook X on Mastodon](https://photos.tylercipriani.com/2026-05-17_cstross-chuwi-minibook.png)

Charlie Stross, one of my favorite SciFi authors, recommended the Chuwi Minibook X on Mastodon

The fediverse told me that Minibook runs Linux “boringly well,” which was *almost* true.

I tried Debian, then jumped to NixOS for kicks.

What works:

- Camera/Microphone/Speakers
- Touchscreen
- Sleep/Suspend
- Hibernate
- Keyboard backlight
- USB-C HDMI
- Bluetooth (non-free blobs – Intel)
- Wi-Fi 6 (non-free blobs – Intel)

But on first boot, the screen orientation is 270° clockwise:

![Tails setup screen rotated](https://photos.tylercipriani.com/thumbs/fd/618ab5184903c7a8a69428d4df70e0/larger.avif)

Tails setup screen rotated

The Chuwi’s screen is a panel from a cheap tablet; the screen rotation issue is a hardware problem (the screen is mounted sideways). To fix the screen’s rotation, I had to tweak screen orientation at every software layer. Fixing this problem was a journey:

1. Bootloader – Switched from `systemd-boot` to `grub`, carrying some [unmerged GRUB rotation patches](https://github.com/iggyZiggy/chuwi-grub-rotation-nix-patch) on top.
2. Initrd – Tell the Intel display driver about the panel orientation via a kernel parameter, and force the Intel driver to load in the initramfs. On NixOS: `boot.kernelParams = ["video=DSI-1:panel_orientation=right_side_up"];` and `boot.initrd.kernelModules = ["i915"];` (see Kernel docs for [modedb default video mode support](https://docs.kernel.org/fb/modedb.html))
3. Desktop environment – For X11, good ole `xrandr --output DSI-1 --rotate right`. Wayland picked this up from the DRM connector. This one was easy.
4. Framebuffer – Ensure all TTYs have the proper orientation by adding `fbcon=rotate:1` to kernel parameters `boot.kernelParams = ["fbcon=rotate:1"];` (see Kernel docs for [framebuffer console boot options](https://docs.kernel.org/fb/fbcon.html#c-boot-options))

Behold, the final result in all its glory:

![HoverNotes Icon](chrome-extension://fhdmbhgpabjkadpaafomaabbdckofphm/assets/icons/hover-notes-icon-white.svg)

HoverNotes Icon

## Size, weight, and build

This computer is mind-bogglingly small. The build is sturdy and totable; it’ll hold up to a backpack jostling.

![Chuwi Minibook X with banana for scale](https://photos.tylercipriani.com/thumbs/20/2a52c0ab8facc8cb6d6bb6f81fe137/larger.avif)

Chuwi Minibook X with banana for scale

The laptop’s case is MacBook-esque: aluminum and good-looking. The MacBook Air’s dimensions dwarf the Chuwi’s, but the two laptops are about the same thickness.

![Chuwi Minibook X alongside Macbook Air](https://photos.tylercipriani.com/thumbs/47/64546616494468e5901dc5289f0de7/larger.avif)

Chuwi Minibook X alongside Macbook Air

> A notebook that weighs more than a kilo is simply not a good thing
> 
> – [Linus Torvalds](https://techcrunch.com/2012/04/19/an-interview-with-millenium-technology-prize-finalist-linus-torvalds/)

The Minibook weighs in just shy of a kilo at 912 grams.

![Chuwi Minibook X weights 912g](https://photos.tylercipriani.com/thumbs/43/3dd984db05dddda91ec2f1e4691652/larger.avif)

Chuwi Minibook X weights 912g

## Perf, thermals, and power

tl;dr: you get what you pay for. But battery life and cooling are better than I’d have guessed.

The Minibook X was never going to compile the Linux kernel in record time. But the performance matches the specs, it stays cool, and it has enough battery life to run a movie marathon.

Numbers:

- Geekbench6 (a fun side-quest to get running on NixOS), better than I [expected](https://browser.geekbench.com/search?q=n150).
	- Single-core: 1295
		- Multi-core: 3332
- Wi-Fi 6 speed: 424 Mbps, more than enough to stream a 4K movie.
- Power
	- Idle: 3.8W
		- During benchmark: ~15W

Battery: When I left the 1995 classic film “Hackers” looping in VLC, the battery lasted about 6 hours.

Heat: Running `stress-ng` for 10 minutes, the hottest part of the laptop chassis remained below 90°F (32°C):

![Chuwi Minibook X running stress-ng on thermal camera. Thermal camera reads 88.4°F](https://photos.tylercipriani.com/thumbs/e1/ece6929d3378c0b9bff4e42c4f687d/larger.avif)

Chuwi Minibook X running stress-ng on thermal camera. Thermal camera reads 88.4°F

## What I dislike

There’s so much to dislike about this laptop:

- Screen is terrible – 2K? 50Hz refresh rate? Why!?
- Keyboard is terrible – it only registers keystrokes when you hit the exact center of each key.
- Touchpad is terrible – It’s a diving board-style, without physical buttons.
- Sound is meh – I can hear the tinny laptop speaker fine, but it’s underwhelming. I’ve never tried tweaking it in Pipewire, though; it’s possible it could be better.

But “terrible” is in comparison to the nicest modern laptops in existence. Everything I listed here works fine. I’m honestly blown away when I tune my expectations to the sub-$400 laptop range.

## Verdict

In [*The Death and Life of Great American Cities*](https://en.wikipedia.org/wiki/The_Death_and_Life_of_Great_American_Cities), Jane Jacobs wrote, “new ideas require old buildings”: cheap spaces let people try risky ideas.

The Chuwi Minibook X is an old building.

I can brick the Minibook and have a normal Monday on my serious work laptop. Nothing has to work, which makes it perfect to try out new Linux desktop stuff:

- NixOS – I’ve been using Debian for 15 years+, figured I’d try joining the NixOS cult for a while.
- RiverWM – I’m on a quest to find the Wayland version of XMonad; [River](https://github.com/riverwm/river) is pretty close.
- KDE Plasma – I’ve used a tiling window manager for over a decade. What’s it like to use a desktop that Just Works™?
- Steam – Never been much into games, but I decided to give Steam a try since, well, why not?

Cheap, weird computers like the Chuwi make it safe to play. And playing with computers is still fun.

![HoverNotes Icon](chrome-extension://fhdmbhgpabjkadpaafomaabbdckofphm/assets/icons/hover-notes-icon-white.svg)

HoverNotes Icon