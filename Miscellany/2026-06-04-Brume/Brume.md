---
title: Brume — desktop multi-timbral instrument
source: https://brume.aftertone.co/
author:
  - "[[Brandon Huey]]"
published:
created: 2026-06-04
description: A desktop multi-timbral music machine with four synthesis engines, a 10″ touch surface, and one cable to your DAW.
tags:
  - ToRead
  - synthesizer
  - music
  - audio
  - hardware
  - creative-coding
---
01 / Engines

## Four voices, four lineages.

Brume runs four synthesis engines with a shared voice tail (state-variable filter, amp envelope, modulation router), so patches stay coherent across very different sources. Each engine has its own mechanism for continuous spectral change: algorithm routing and per-voice FM-index envelopes in FM, a scanning window in Harmonic, cascaded wavefolding in Timbral, grain scatter in Granular. No samples sit anywhere in the signal path; every voice is generated from live math.

◆ Part 1 · FM

### FM

Metallic overtones from stacked sines

Six operators across twelve algorithm topologies, per-op ratio and level, global feedback, a per-voice FM-index envelope, and a voice-tail state-variable filter with its own envelope — DX-style FM with subtractive shaping on the way out.

<svg viewBox="0 0 240 120" preserveAspectRatio="xMidYMid meet"><rect x="106" y="6" width="28" height="13" rx="2" fill="none" stroke="currentColor"></rect><text x="120" y="13" fill="currentColor">6</text> <rect x="106" y="24" width="28" height="13" rx="2" fill="none" stroke="currentColor"></rect><text x="120" y="31" fill="currentColor">5</text> <rect x="106" y="42" width="28" height="13" rx="2" fill="none" stroke="currentColor"></rect><text x="120" y="49" fill="currentColor">4</text> <rect x="106" y="60" width="28" height="13" rx="2" fill="none" stroke="currentColor"></rect><text x="120" y="67" fill="currentColor">3</text> <rect x="106" y="78" width="28" height="13" rx="2" fill="none" stroke="currentColor"></rect><text x="120" y="85" fill="currentColor">2</text> <rect x="106" y="96" width="28" height="13" rx="2" fill="none" stroke="currentColor"></rect><text x="120" y="103" style="fill: currentColor;">1</text> <line x1="120" y1="19" x2="120" y2="24" stroke="currentColor" stroke-opacity="0.2"></line><polygon points="117,22 120,25 123,22" fill="none" stroke="currentColor"></polygon><line x1="120" y1="37" x2="120" y2="42" stroke="currentColor" stroke-opacity="0.2"></line><polygon points="117,40 120,43 123,40" fill="none" stroke="currentColor"></polygon><line x1="120" y1="55" x2="120" y2="60" stroke="currentColor" stroke-opacity="0.2"></line><polygon points="117,58 120,61 123,58" fill="none" stroke="currentColor"></polygon><line x1="120" y1="73" x2="120" y2="78" stroke="currentColor" stroke-opacity="0.2"></line><polygon points="117,76 120,79 123,76" fill="none" stroke="currentColor"></polygon><line x1="120" y1="91" x2="120" y2="96" stroke="currentColor" stroke-opacity="0.2"></line><polygon points="117,94 120,97 123,94" fill="none" stroke="currentColor"></polygon><path d="M 134 9 Q 152 9, 152 13 Q 152 17, 134 17" fill="none" stroke="currentColor"></path><polygon points="136,14 132,17 136,20" fill="none" stroke="currentColor"></polygon><line x1="120" y1="109" x2="120" y2="116" stroke="currentColor" stroke-opacity="0.2"></line><polygon points="117,114 120,117 123,114" fill="none" stroke="currentColor"></polygon><text x="138" y="114" fill="currentColor">ALG 1 · STACK</text></svg>

◆ Part 2 · Harmonic

### Harmonic

Additive synthesis under a scanning window

Eight harmonics with Gaussian scanning, per-harmonic waveform morph, FM on the fundamental, spectral tilt, and odd/even balance.

◆ Part 3 · Timbral

### Timbral

Triangle core folded into nonlinear spectra

Triangle core through a wave-multiplier shaper with linear FM, sub-oscillator, self-modulation feedback, and expanded symmetry.

◆ Part 4 · Granular

### Granular

Pitched grain clouds that drift and scatter

Pitched clouds of micro-oscillator grains with morphable waveforms. Density, scatter, drift, and FM within grains.

02 / Signal architecture

## Every voice, the same path.

MIDI in, voice allocation, modulation, filter, envelope, mixer. Sends to delay and reverb. A Lua FX slot for custom processing.

<svg viewBox="0 -14 800 374" xmlns="http://www.w3.org/2000/svg" fill="none" style="min-width: 640px;"><rect x="20" y="34" width="90" height="32" rx="3" fill="none" stroke="currentColor"></rect><text x="65" y="54" text-anchor="middle" fill="currentColor">MIDI IN</text> <line x1="110" y1="50" x2="150" y2="50" stroke="currentColor" stroke-opacity="0.2"></line><polygon points="148,46 156,50 148,54" fill="none" stroke="currentColor"></polygon><rect x="156" y="34" width="90" height="32" rx="3" fill="none" stroke="currentColor"></rect><text x="201" y="54" text-anchor="middle" fill="currentColor">CHANNEL MAP</text> <line x1="246" y1="50" x2="280" y2="50" stroke="currentColor" stroke-opacity="0.2"></line><line x1="280" y1="0" x2="280" y2="78" stroke="currentColor" stroke-opacity="0.2"></line><line x1="280" y1="0" x2="310" y2="0" stroke="currentColor" stroke-opacity="0.2"></line><polygon points="308,-4 316,0 308,4" fill="none" stroke="currentColor"></polygon><rect x="316" y="-12" width="100" height="24" rx="3" fill="none" stroke="currentColor"></rect><text x="366" y="4" text-anchor="middle" fill="currentColor">FM</text> <line x1="280" y1="26" x2="310" y2="26" stroke="currentColor" stroke-opacity="0.2"></line><polygon points="308,22 316,26 308,30" fill="none" stroke="currentColor"></polygon><rect x="316" y="14" width="100" height="24" rx="3" fill="none" stroke="currentColor"></rect><text x="366" y="30" text-anchor="middle" fill="currentColor">HARMONIC</text> <line x1="280" y1="52" x2="310" y2="52" stroke="currentColor" stroke-opacity="0.2"></line><polygon points="308,48 316,52 308,56" fill="none" stroke="currentColor"></polygon><rect x="316" y="40" width="100" height="24" rx="3" fill="none" stroke="currentColor"></rect><text x="366" y="56" text-anchor="middle" fill="currentColor">TIMBRAL</text> <line x1="280" y1="78" x2="310" y2="78" stroke="currentColor" stroke-opacity="0.2"></line><polygon points="308,74 316,78 308,82" fill="none" stroke="currentColor"></polygon><rect x="316" y="66" width="100" height="24" rx="3" fill="none" stroke="currentColor"></rect><text x="366" y="82" text-anchor="middle" fill="currentColor">GRANULAR</text> <line x1="416" y1="0" x2="440" y2="0" stroke="currentColor" stroke-opacity="0.2"></line><line x1="416" y1="26" x2="440" y2="26" stroke="currentColor" stroke-opacity="0.2"></line><line x1="416" y1="52" x2="440" y2="52" stroke="currentColor" stroke-opacity="0.2"></line><line x1="416" y1="78" x2="440" y2="78" stroke="currentColor" stroke-opacity="0.2"></line><line x1="440" y1="0" x2="440" y2="78" stroke="currentColor" stroke-opacity="0.2"></line><line x1="440" y1="50" x2="460" y2="50" stroke="currentColor" stroke-opacity="0.2"></line><polygon points="458,46 466,50 458,54" fill="none" stroke="currentColor"></polygon><rect x="466" y="34" width="80" height="32" rx="3" fill="none" stroke="currentColor"></rect><text x="506" y="48" text-anchor="middle" fill="currentColor">MOD MATRIX</text> <text x="506" y="58" text-anchor="middle" fill="currentColor">LFO · ENV · VEL</text> <line x1="546" y1="50" x2="576" y2="50" stroke="currentColor" stroke-opacity="0.2"></line><polygon points="574,46 582,50 574,54" fill="none" stroke="currentColor"></polygon><rect x="582" y="34" width="70" height="32" rx="3" fill="none" stroke="currentColor"></rect><text x="617" y="54" text-anchor="middle" fill="currentColor">FILTER</text> <line x1="652" y1="50" x2="682" y2="50" stroke="currentColor" stroke-opacity="0.2"></line><polygon points="680,46 688,50 680,54" fill="none" stroke="currentColor"></polygon><rect x="688" y="26" width="80" height="48" rx="3" fill="none" stroke="currentColor"></rect><text x="728" y="48" text-anchor="middle" fill="currentColor">MIXER</text> <text x="728" y="60" text-anchor="middle" fill="currentColor">LEVEL · PAN · MUTE</text> <text x="20" y="119" fill="currentColor">SEND BUSES</text> <line x1="728" y1="74" x2="728" y2="94" stroke="currentColor" stroke-opacity="0.2"></line><line x1="728" y1="94" x2="200" y2="94" stroke="currentColor" stroke-opacity="0.2"></line><line x1="200" y1="94" x2="200" y2="124" stroke="currentColor" stroke-opacity="0.2"></line><polygon points="196,122 200,130 204,122" fill="none" stroke="currentColor"></polygon><rect x="156" y="130" width="88" height="28" rx="3" fill="none" stroke="currentColor"></rect><text x="200" y="148" text-anchor="middle" fill="currentColor">SATURATOR</text> <line x1="340" y1="94" x2="340" y2="124" stroke="currentColor" stroke-opacity="0.2"></line><polygon points="336,122 340,130 344,122" fill="none" stroke="currentColor"></polygon><rect x="296" y="130" width="88" height="28" rx="3" fill="none" stroke="currentColor"></rect><text x="340" y="148" text-anchor="middle" fill="currentColor">CHORUS</text> <line x1="480" y1="94" x2="480" y2="124" stroke="currentColor" stroke-opacity="0.2"></line><polygon points="476,122 480,130 484,122" fill="none" stroke="currentColor"></polygon><rect x="436" y="130" width="88" height="28" rx="3" fill="none" stroke="currentColor"></rect><text x="480" y="148" text-anchor="middle" fill="currentColor">DELAY</text> <line x1="620" y1="94" x2="620" y2="124" stroke="currentColor" stroke-opacity="0.2"></line><polygon points="616,122 620,130 624,122" fill="none" stroke="currentColor"></polygon><rect x="576" y="130" width="88" height="28" rx="3" fill="none" stroke="currentColor"></rect><text x="620" y="148" text-anchor="middle" fill="currentColor">REVERB</text> <line x1="200" y1="158" x2="200" y2="176" stroke="currentColor" stroke-opacity="0.2"></line><line x1="340" y1="158" x2="340" y2="176" stroke="currentColor" stroke-opacity="0.2"></line><line x1="480" y1="158" x2="480" y2="176" stroke="currentColor" stroke-opacity="0.2"></line><line x1="620" y1="158" x2="620" y2="176" stroke="currentColor" stroke-opacity="0.2"></line><line x1="200" y1="176" x2="620" y2="176" stroke="currentColor" stroke-opacity="0.2"></line><line x1="410" y1="176" x2="410" y2="194" stroke="currentColor" stroke-opacity="0.2"></line><text x="20" y="219" fill="currentColor">LUA FX</text> <rect x="156" y="204" width="120" height="28" rx="3" fill="none" stroke="currentColor"></rect><text x="216" y="222" text-anchor="middle" fill="currentColor">SCRIPT FX</text> <line x1="276" y1="218" x2="404" y2="218" stroke="currentColor" stroke-opacity="0.2"></line><line x1="404" y1="218" x2="410" y2="206" stroke="currentColor" stroke-opacity="0.2"></line><line x1="410" y1="194" x2="410" y2="254" stroke="currentColor" stroke-opacity="0.2"></line><line x1="768" y1="50" x2="780" y2="50" stroke="currentColor" stroke-opacity="0.2"></line><line x1="780" y1="50" x2="780" y2="254" stroke="currentColor" stroke-opacity="0.2"></line><line x1="780" y1="254" x2="460" y2="254" stroke="currentColor" stroke-opacity="0.2"></line><circle cx="410" cy="254" r="6" fill="none" stroke="currentColor" stroke-width="0.8" opacity="0.6"></circle><text x="410" y="258" text-anchor="middle" font-family="var(--ff-mono)" font-size="8" fill="currentColor" opacity="0.6">+</text> <line x1="410" y1="260" x2="410" y2="284" stroke="currentColor" stroke-opacity="0.2"></line><polygon points="406,282 410,290 414,282" fill="none" stroke="currentColor"></polygon><rect x="360" y="290" width="100" height="32" rx="3" fill="none" stroke="currentColor"></rect><text x="410" y="304" text-anchor="middle" fill="currentColor">MASTER</text> <text x="410" y="314" text-anchor="middle" fill="currentColor">LIMITER · STEREO</text> <line x1="410" y1="322" x2="410" y2="344" stroke="currentColor" stroke-opacity="0.2"></line><polygon points="406,342 410,350 414,342" fill="none" stroke="currentColor"></polygon><text x="410" y="360" text-anchor="middle" style="font-size:8px;" fill="currentColor">AUDIO OUT</text></svg>

03 / Meridian

## One cable to your DAW.

One USB cable carries multi-channel audio out, bidirectional MIDI, and clock. Class-compliant — no drivers, no manager app.

Source

#### Brume

4 engines · 24 voices · dry + sends rendered per part.

Link · USB

#### Audio · MIDI · Clock

Class-compliant. One port. Stereo out plus planned per-part stems.

Destination

#### Your DAW

Bitwig, Logic, Ableton, Reaper. Arm a track, point at Brume, record.

<svg viewBox="0 0 1200 100" preserveAspectRatio="none"><defs><linearGradient id="gMer" x1="0" x2="1"><stop offset="0%" stop-color="#F4F1EC" stop-opacity="0.1"></stop><stop offset="50%" stop-color="#F4F1EC" stop-opacity="0.95"></stop><stop offset="100%" stop-color="#F4F1EC" stop-opacity="0.1"></stop></linearGradient></defs><rect x="20" y="35" width="180" height="30" fill="none" stroke="#F4F1EC" stroke-width="1"></rect><text x="110" y="55" text-anchor="middle" font-family="JetBrains Mono" font-size="11" fill="#F4F1EC" letter-spacing="2">BRUME</text> <rect x="1000" y="35" width="180" height="30" fill="none" stroke="#F4F1EC" stroke-width="1"></rect><text x="1090" y="55" text-anchor="middle" font-family="JetBrains Mono" font-size="11" fill="#F4F1EC" letter-spacing="2">DAW</text> <line x1="200" y1="50" x2="1000" y2="50" stroke="url(#gMer)" stroke-width="1.2"></line><g id="packets"><rect x="687.839999988556" y="47" width="14" height="6" fill="#F4F1EC" opacity="0.65"></rect><rect x="827.839999988556" y="47" width="14" height="6" fill="#F4F1EC" opacity="0.71"></rect><rect x="967.839999988556" y="47" width="14" height="6" fill="#F4F1EC" opacity="0.81"></rect><rect x="307.839999988556" y="47" width="14" height="6" fill="#F4F1EC" opacity="0.85"></rect><rect x="447.839999988556" y="47" width="14" height="6" fill="#F4F1EC" opacity="0.80"></rect><rect x="587.839999988556" y="47" width="14" height="6" fill="#F4F1EC" opacity="0.70"></rect></g><text x="600" y="25" text-anchor="middle" font-family="JetBrains Mono" font-size="10" fill="#F4F1EC99" letter-spacing="3">USB · CLASS COMPLIANT · AUDIO + MIDI + CLOCK</text> <text x="600" y="85" text-anchor="middle" font-family="JetBrains Mono" font-size="10" fill="#F4F1EC55" letter-spacing="3">macOS · Linux</text></svg>

04 / Specification

## Purpose-built on Compute Module 5.

Raspberry Pi OS Lite, Rust audio runtime, 10.1-inch capacitive touch. Boots fast. Bridges to your DAW over USB.

Engines

FM · Harmonic · Timbral · Granular

Polyphony

24 voices · 6 per part

Filter

SVF per voice, 2 ADSR per voice

Modulation

2 LFO + 2 step seq per part

Effects

Saturator · Chorus · Delay · Reverb

Sends

Per-part delay + reverb sends

MIDI

USB class-compliant, clock sync

Audio

48 kHz stereo

Meridian

USB to DAW — audio + MIDI + clock

Display

10.1″ 1024×600 capacitive touch

Scripting

Lua 5.4 — sequencing, DSP, custom FX

Platform

Rust runtime, RT Linux, CM5 ARM A76

05 / Bill of materials

## Four components. One cable.

Boot and play. The hardware is a deliberate assembly of off-the-shelf parts — the instrument is the software.

01 · Compute Module 5

<svg viewBox="0 0 200 150" fill="none" stroke="currentColor" stroke-width="0.8"><rect x="40" y="25" width="120" height="90" rx="3"></rect><rect x="70" y="45" width="40" height="40" rx="1"></rect><text x="90" y="68" text-anchor="middle" font-size="6" font-family="JetBrains Mono" fill="currentColor" stroke="none">BCM</text> <text x="90" y="76" text-anchor="middle" font-size="5" font-family="JetBrains Mono" fill="currentColor" stroke="none">2712</text> <rect x="120" y="48" width="28" height="16" rx="1"></rect><text x="134" y="59" text-anchor="middle" font-size="5" font-family="JetBrains Mono" fill="currentColor" stroke="none">8GB</text> <rect x="120" y="70" width="20" height="12" rx="1"></rect><text x="130" y="79" text-anchor="middle" font-size="4" font-family="JetBrains Mono" fill="currentColor" stroke="none">eMMC</text> <rect x="48" y="48" width="16" height="12" rx="1"></rect><text x="56" y="57" text-anchor="middle" font-size="4" font-family="JetBrains Mono" fill="currentColor" stroke="none">WiFi</text> <line x1="50" y1="115" x2="80" y2="115" stroke-width="2"></line><line x1="90" y1="115" x2="120" y2="115" stroke-width="2"></line><circle cx="55" cy="35" r="4" stroke-width="0.5"></circle><circle cx="45" cy="30" r="2" stroke-width="0.4"></circle><circle cx="155" cy="30" r="2" stroke-width="0.4"></circle><circle cx="45" cy="110" r="2" stroke-width="0.4"></circle><circle cx="155" cy="110" r="2" stroke-width="0.4"></circle><text x="100" y="145" text-anchor="middle" font-size="6" font-family="JetBrains Mono" fill="currentColor" stroke="none" letter-spacing="1">COMPUTE MODULE 5</text></svg>

#### CM5

Compute Module 5. Quad-core ARM A76, 8 GB RAM, 32 GB eMMC, wireless.

02 · Carrier board

<svg viewBox="0 0 200 150" fill="none" stroke="currentColor" stroke-width="0.8"><rect x="20" y="15" width="160" height="110" rx="3"></rect><rect x="55" y="30" width="90" height="50" rx="2" stroke-dasharray="3,2"></rect><text x="100" y="58" text-anchor="middle" font-size="5" font-family="JetBrains Mono" fill="currentColor" stroke="none">CM5 SOCKET</text> <rect x="25" y="25" width="6" height="60" rx="0.5"></rect><text x="28" y="92" text-anchor="middle" font-size="4" font-family="JetBrains Mono" fill="currentColor" stroke="none">GPIO</text> <rect x="30" y="120" width="16" height="6" rx="2"></rect><text x="38" y="132" text-anchor="middle" font-size="4" font-family="JetBrains Mono" fill="currentColor" stroke="none">USB-C</text> <rect x="55" y="120" width="14" height="5" rx="1"></rect><text x="62" y="132" text-anchor="middle" font-size="4" font-family="JetBrains Mono" fill="currentColor" stroke="none">HDMI</text> <rect x="120" y="118" width="12" height="8" rx="1"></rect><rect x="136" y="118" width="12" height="8" rx="1"></rect><text x="140" y="134" text-anchor="middle" font-size="4" font-family="JetBrains Mono" fill="currentColor" stroke="none">USB-A</text> <rect x="155" y="40" width="18" height="14" rx="1"></rect><text x="164" y="60" text-anchor="middle" font-size="4" font-family="JetBrains Mono" fill="currentColor" stroke="none">ETH</text> <rect x="85" y="90" width="8" height="14" rx="0.5" stroke-width="0.5"></rect><text x="89" y="110" text-anchor="middle" font-size="3.5" font-family="JetBrains Mono" fill="currentColor" stroke="none">J2/OTG</text> <circle cx="25" cy="20" r="2" stroke-width="0.4"></circle><circle cx="175" cy="20" r="2" stroke-width="0.4"></circle><circle cx="25" cy="120" r="2" stroke-width="0.4"></circle><circle cx="175" cy="120" r="2" stroke-width="0.4"></circle><text x="100" y="145" text-anchor="middle" font-size="6" font-family="JetBrains Mono" fill="currentColor" stroke="none" letter-spacing="1">IO BOARD</text></svg>

#### Carrier Board

CM5 IO Board with USB OTG for multi-channel audio and MIDI to your DAW. HDMI, GPIO, Ethernet.

03 · Display

<svg viewBox="0 0 200 150" fill="none" stroke="currentColor" stroke-width="0.8"><rect x="20" y="15" width="160" height="100" rx="4"></rect><rect x="28" y="21" width="144" height="82" rx="2" stroke-width="0.4"></rect><line x1="35" y1="45" x2="75" y2="45" stroke-width="0.3"></line><line x1="35" y1="52" x2="65" y2="52" stroke-width="0.3"></line><line x1="35" y1="59" x2="70" y2="59" stroke-width="0.3"></line><rect x="90" y="35" width="60" height="45" rx="1" stroke-width="0.3"></rect><circle cx="130" cy="70" r="8" stroke-width="0.3" stroke-dasharray="2,2"></circle><circle cx="130" cy="70" r="2" stroke-width="0.5"></circle><line x1="60" y1="115" x2="40" y2="138" stroke-width="1"></line><line x1="140" y1="115" x2="160" y2="138" stroke-width="1"></line><line x1="35" y1="138" x2="165" y2="138" stroke-width="0.8"></line><path d="M95 115 Q95 125 90 130" stroke-width="0.5"></path><text x="85" y="138" text-anchor="middle" font-size="4" font-family="JetBrains Mono" fill="currentColor" stroke="none">HDMI+USB</text> <text x="100" y="148" text-anchor="middle" font-size="6" font-family="JetBrains Mono" fill="currentColor" stroke="none" letter-spacing="1">10.1″ TOUCHSCREEN</text></svg>

#### Touchscreen

Pick the HDMI touchscreen that fits your build. Brume’s UI is designed around a 1024×600 logical layout and auto-scales to whatever panel you connect — tap into the CM5 touchscreen ecosystem. Reference unit: 10.1″ 1920×1200.

04 · Software

<svg viewBox="0 0 200 150" fill="none" stroke="currentColor" stroke-width="0.8"><rect x="50" y="15" width="100" height="112" rx="2" stroke-width="0.6"></rect><rect x="60" y="23" width="80" height="18" rx="1"></rect><text x="100" y="35" text-anchor="middle" font-size="6" font-family="JetBrains Mono" fill="currentColor" stroke="none" letter-spacing="1">BRUME</text> <rect x="60" y="45" width="80" height="16" rx="1"></rect><text x="100" y="55" text-anchor="middle" font-size="5" font-family="JetBrains Mono" fill="currentColor" stroke="none">labwc + webkitgtk</text> <rect x="60" y="65" width="80" height="16" rx="1"></rect><text x="100" y="75" text-anchor="middle" font-size="5" font-family="JetBrains Mono" fill="currentColor" stroke="none">AUDIO CONFIG</text> <rect x="60" y="85" width="80" height="16" rx="1"></rect><text x="100" y="95" text-anchor="middle" font-size="5" font-family="JetBrains Mono" fill="currentColor" stroke="none">PI OS LITE</text> <rect x="60" y="105" width="80" height="16" rx="1" stroke-dasharray="2,1"></rect><text x="100" y="115" text-anchor="middle" font-size="5" font-family="JetBrains Mono" fill="currentColor" stroke="none">eMMC / 32 GB</text> <text x="100" y="145" text-anchor="middle" font-size="6" font-family="JetBrains Mono" fill="currentColor" stroke="none" letter-spacing="1">LINUX INSTALL</text></svg>

#### Software

Brume installs onto Raspberry Pi OS Lite. The `brumectl` CLI adds the runtime packages, labwc/webkitgtk shell, audio config, presets, and systemd service; `--update` refreshes the binary and factory presets over SSH.

Controllers

05 · Reference controller

<svg viewBox="0 0 200 150" fill="none" stroke="currentColor" stroke-width="0.8"><rect x="10" y="58" width="180" height="58" rx="3"></rect><text x="14" y="65" font-size="2.8" font-family="JetBrains Mono" fill="currentColor" stroke="none">nanoKONTROL2</text> <text x="186" y="65" text-anchor="end" font-size="3" font-family="JetBrains Mono" fill="currentColor" stroke="none" letter-spacing="0.4">KORG</text> <rect x="7" y="82" width="3" height="6" rx="0.5" stroke-width="0.5"></rect><rect x="14" y="70" width="4.5" height="3" rx="0.4" stroke-width="0.4"></rect><rect x="20" y="70" width="4.5" height="3" rx="0.4" stroke-width="0.4"></rect><rect x="14" y="77" width="3" height="3" rx="0.4" stroke-width="0.4"></rect><rect x="18.5" y="77" width="3" height="3" rx="0.4" stroke-width="0.4"></rect><rect x="23" y="77" width="3" height="3" rx="0.4" stroke-width="0.4"></rect><rect x="14" y="84" width="2.5" height="3" rx="0.4" stroke-width="0.4"></rect><rect x="17.5" y="84" width="2.5" height="3" rx="0.4" stroke-width="0.4"></rect><rect x="21" y="84" width="2.5" height="3" rx="0.4" stroke-width="0.4"></rect><rect x="24.5" y="84" width="2.5" height="3" rx="0.4" stroke-width="0.4"></rect><circle cx="29.2" cy="85.5" r="1.5" stroke-width="0.4"></circle><rect x="14" y="91" width="4.5" height="3" rx="0.4" stroke-width="0.4"></rect><circle cx="50" cy="68" r="2" stroke-width="0.5"></circle><line x1="50" y1="66" x2="50" y2="67.5" stroke-width="0.5"></line><rect x="48" y="72" width="4" height="2.4" rx="0.3" stroke-width="0.4"></rect><rect x="48" y="75" width="4" height="2.4" rx="0.3" stroke-width="0.4"></rect><rect x="48" y="78" width="4" height="2.4" rx="0.3" stroke-width="0.4"></rect><rect x="48.5" y="83" width="3" height="24" rx="0.3" stroke-width="0.4"></rect><rect x="47" y="94" width="6" height="2.5" rx="0.3" stroke-width="0.5"></rect><text x="50" y="112" text-anchor="middle" font-size="2.6" font-family="JetBrains Mono" fill="currentColor" stroke="none">1</text> <circle cx="68" cy="68" r="2" stroke-width="0.5"></circle><line x1="68" y1="66" x2="68" y2="67.5" stroke-width="0.5"></line><rect x="66" y="72" width="4" height="2.4" rx="0.3" stroke-width="0.4"></rect><rect x="66" y="75" width="4" height="2.4" rx="0.3" stroke-width="0.4"></rect><rect x="66" y="78" width="4" height="2.4" rx="0.3" stroke-width="0.4"></rect><rect x="66.5" y="83" width="3" height="24" rx="0.3" stroke-width="0.4"></rect><rect x="65" y="98" width="6" height="2.5" rx="0.3" stroke-width="0.5"></rect><text x="68" y="112" text-anchor="middle" font-size="2.6" font-family="JetBrains Mono" fill="currentColor" stroke="none">2</text> <circle cx="86" cy="68" r="2" stroke-width="0.5"></circle><line x1="86" y1="66" x2="86" y2="67.5" stroke-width="0.5"></line><rect x="84" y="72" width="4" height="2.4" rx="0.3" stroke-width="0.4"></rect><rect x="84" y="75" width="4" height="2.4" rx="0.3" stroke-width="0.4"></rect><rect x="84" y="78" width="4" height="2.4" rx="0.3" stroke-width="0.4"></rect><rect x="84.5" y="83" width="3" height="24" rx="0.3" stroke-width="0.4"></rect><rect x="83" y="89" width="6" height="2.5" rx="0.3" stroke-width="0.5"></rect><text x="86" y="112" text-anchor="middle" font-size="2.6" font-family="JetBrains Mono" fill="currentColor" stroke="none">3</text> <circle cx="104" cy="68" r="2" stroke-width="0.5"></circle><line x1="104" y1="66" x2="104" y2="67.5" stroke-width="0.5"></line><rect x="102" y="72" width="4" height="2.4" rx="0.3" stroke-width="0.4"></rect><rect x="102" y="75" width="4" height="2.4" rx="0.3" stroke-width="0.4"></rect><rect x="102" y="78" width="4" height="2.4" rx="0.3" stroke-width="0.4"></rect><rect x="102.5" y="83" width="3" height="24" rx="0.3" stroke-width="0.4"></rect><rect x="101" y="102" width="6" height="2.5" rx="0.3" stroke-width="0.5"></rect><text x="104" y="112" text-anchor="middle" font-size="2.6" font-family="JetBrains Mono" fill="currentColor" stroke="none">4</text> <circle cx="122" cy="68" r="2" stroke-width="0.5"></circle><line x1="122" y1="66" x2="122" y2="67.5" stroke-width="0.5"></line><rect x="120" y="72" width="4" height="2.4" rx="0.3" stroke-width="0.4"></rect><rect x="120" y="75" width="4" height="2.4" rx="0.3" stroke-width="0.4"></rect><rect x="120" y="78" width="4" height="2.4" rx="0.3" stroke-width="0.4"></rect><rect x="120.5" y="83" width="3" height="24" rx="0.3" stroke-width="0.4"></rect><rect x="119" y="92" width="6" height="2.5" rx="0.3" stroke-width="0.5"></rect><text x="122" y="112" text-anchor="middle" font-size="2.6" font-family="JetBrains Mono" fill="currentColor" stroke="none">5</text> <circle cx="140" cy="68" r="2" stroke-width="0.5"></circle><line x1="140" y1="66" x2="140" y2="67.5" stroke-width="0.5"></line><rect x="138" y="72" width="4" height="2.4" rx="0.3" stroke-width="0.4"></rect><rect x="138" y="75" width="4" height="2.4" rx="0.3" stroke-width="0.4"></rect><rect x="138" y="78" width="4" height="2.4" rx="0.3" stroke-width="0.4"></rect><rect x="138.5" y="83" width="3" height="24" rx="0.3" stroke-width="0.4"></rect><rect x="137" y="86" width="6" height="2.5" rx="0.3" stroke-width="0.5"></rect><text x="140" y="112" text-anchor="middle" font-size="2.6" font-family="JetBrains Mono" fill="currentColor" stroke="none">6</text> <circle cx="158" cy="68" r="2" stroke-width="0.5"></circle><line x1="158" y1="66" x2="158" y2="67.5" stroke-width="0.5"></line><rect x="156" y="72" width="4" height="2.4" rx="0.3" stroke-width="0.4"></rect><rect x="156" y="75" width="4" height="2.4" rx="0.3" stroke-width="0.4"></rect><rect x="156" y="78" width="4" height="2.4" rx="0.3" stroke-width="0.4"></rect><rect x="156.5" y="83" width="3" height="24" rx="0.3" stroke-width="0.4"></rect><rect x="155" y="96" width="6" height="2.5" rx="0.3" stroke-width="0.5"></rect><text x="158" y="112" text-anchor="middle" font-size="2.6" font-family="JetBrains Mono" fill="currentColor" stroke="none">7</text> <circle cx="176" cy="68" r="2" stroke-width="0.5"></circle><line x1="176" y1="66" x2="176" y2="67.5" stroke-width="0.5"></line><rect x="174" y="72" width="4" height="2.4" rx="0.3" stroke-width="0.4"></rect><rect x="174" y="75" width="4" height="2.4" rx="0.3" stroke-width="0.4"></rect><rect x="174" y="78" width="4" height="2.4" rx="0.3" stroke-width="0.4"></rect><rect x="174.5" y="83" width="3" height="24" rx="0.3" stroke-width="0.4"></rect><rect x="173" y="90" width="6" height="2.5" rx="0.3" stroke-width="0.5"></rect><text x="176" y="112" text-anchor="middle" font-size="2.6" font-family="JetBrains Mono" fill="currentColor" stroke="none">8</text> <text x="100" y="140" text-anchor="middle" font-size="6" font-family="JetBrains Mono" fill="currentColor" stroke="none" letter-spacing="1">NANOKONTROL2</text></svg>

#### Controller

Korg **nanoKONTROL2** is the reference USB-MIDI controller — 8 knobs, 8 faders, transport, and per-strip S/M/R. Brume ships with a default CC-mapping JSON plus a Lua starter script.

06 · Deep-control surface

<svg viewBox="0 0 200 150" fill="none" stroke="currentColor" stroke-width="0.8"><rect x="30" y="10" width="140" height="130" rx="4"></rect><text x="38" y="20" font-size="3.5" font-family="JetBrains Mono" fill="currentColor" stroke="none" letter-spacing="0.3">LaunchControl</text> <text x="79" y="19" font-size="2.6" font-family="JetBrains Mono" fill="currentColor" stroke="none">XL</text> <rect x="157" y="14" width="8" height="8" rx="0.8" stroke-width="0.5" fill="none"></rect><polygon points="159.5,16 163,16 163,20 159.5,20" fill="currentColor" stroke="none" opacity="0.85"></polygon><rect x="34" y="25" width="10" height="3" rx="0.4" stroke-width="0.4"></rect><rect x="34" y="29.5" width="4.5" height="3" rx="0.4" stroke-width="0.4"></rect><rect x="39.5" y="29.5" width="4.5" height="3" rx="0.4" stroke-width="0.4"></rect><rect x="34" y="34" width="4.5" height="3" rx="0.4" stroke-width="0.4"></rect><rect x="39.5" y="34" width="4.5" height="3" rx="0.4" stroke-width="0.4"></rect><circle cx="36.5" cy="42" r="1.5" stroke-width="0.4"></circle><polygon points="41,40.5 44,42 41,43.5" stroke-width="0.4" fill="none"></polygon><rect x="34" y="47" width="10" height="2.8" rx="0.3" stroke-width="0.4"></rect><rect x="34" y="51.5" width="10" height="2.8" rx="0.3" stroke-width="0.4"></rect><rect x="34" y="56" width="10" height="2.8" rx="0.3" stroke-width="0.4"></rect><circle cx="58" cy="26" r="2.2" stroke-width="0.5"></circle><circle cx="72" cy="26" r="2.2" stroke-width="0.5"></circle><circle cx="86" cy="26" r="2.2" stroke-width="0.5"></circle><circle cx="100" cy="26" r="2.2" stroke-width="0.5"></circle><circle cx="114" cy="26" r="2.2" stroke-width="0.5"></circle><circle cx="128" cy="26" r="2.2" stroke-width="0.5"></circle><circle cx="142" cy="26" r="2.2" stroke-width="0.5"></circle><circle cx="156" cy="26" r="2.2" stroke-width="0.5"></circle><circle cx="58" cy="36" r="2.2" stroke-width="0.5"></circle><circle cx="72" cy="36" r="2.2" stroke-width="0.5"></circle><circle cx="86" cy="36" r="2.2" stroke-width="0.5"></circle><circle cx="100" cy="36" r="2.2" stroke-width="0.5"></circle><circle cx="114" cy="36" r="2.2" stroke-width="0.5"></circle><circle cx="128" cy="36" r="2.2" stroke-width="0.5"></circle><circle cx="142" cy="36" r="2.2" stroke-width="0.5"></circle><circle cx="156" cy="36" r="2.2" stroke-width="0.5"></circle><circle cx="58" cy="46" r="2.2" stroke-width="0.5"></circle><circle cx="72" cy="46" r="2.2" stroke-width="0.5"></circle><circle cx="86" cy="46" r="2.2" stroke-width="0.5"></circle><circle cx="100" cy="46" r="2.2" stroke-width="0.5"></circle><circle cx="114" cy="46" r="2.2" stroke-width="0.5"></circle><circle cx="128" cy="46" r="2.2" stroke-width="0.5"></circle><circle cx="142" cy="46" r="2.2" stroke-width="0.5"></circle><circle cx="156" cy="46" r="2.2" stroke-width="0.5"></circle><rect x="56.5" y="62" width="3" height="30" rx="0.3" stroke-width="0.4"></rect><rect x="55" y="70" width="6" height="2.5" rx="0.3" stroke-width="0.5"></rect><rect x="70.5" y="62" width="3" height="30" rx="0.3" stroke-width="0.4"></rect><rect x="69" y="78" width="6" height="2.5" rx="0.3" stroke-width="0.5"></rect><rect x="84.5" y="62" width="3" height="30" rx="0.3" stroke-width="0.4"></rect><rect x="83" y="74" width="6" height="2.5" rx="0.3" stroke-width="0.5"></rect><rect x="98.5" y="62" width="3" height="30" rx="0.3" stroke-width="0.4"></rect><rect x="97" y="66" width="6" height="2.5" rx="0.3" stroke-width="0.5"></rect><rect x="112.5" y="62" width="3" height="30" rx="0.3" stroke-width="0.4"></rect><rect x="111" y="72" width="6" height="2.5" rx="0.3" stroke-width="0.5"></rect><rect x="126.5" y="62" width="3" height="30" rx="0.3" stroke-width="0.4"></rect><rect x="125" y="68" width="6" height="2.5" rx="0.3" stroke-width="0.5"></rect><rect x="140.5" y="62" width="3" height="30" rx="0.3" stroke-width="0.4"></rect><rect x="139" y="76" width="6" height="2.5" rx="0.3" stroke-width="0.5"></rect><rect x="154.5" y="62" width="3" height="30" rx="0.3" stroke-width="0.4"></rect><rect x="153" y="80" width="6" height="2.5" rx="0.3" stroke-width="0.5"></rect><rect x="52" y="97" width="12" height="6.5" rx="0.8" stroke-width="0.4"></rect><rect x="66" y="97" width="12" height="6.5" rx="0.8" stroke-width="0.4"></rect><rect x="80" y="97" width="12" height="6.5" rx="0.8" stroke-width="0.4"></rect><rect x="94" y="97" width="12" height="6.5" rx="0.8" stroke-width="0.4"></rect><rect x="108" y="97" width="12" height="6.5" rx="0.8" stroke-width="0.4"></rect><rect x="122" y="97" width="12" height="6.5" rx="0.8" stroke-width="0.4"></rect><rect x="136" y="97" width="12" height="6.5" rx="0.8" stroke-width="0.4"></rect><rect x="150" y="97" width="12" height="6.5" rx="0.8" stroke-width="0.4"></rect><rect x="52" y="105" width="12" height="6.5" rx="0.8" stroke-width="0.4"></rect><rect x="66" y="105" width="12" height="6.5" rx="0.8" stroke-width="0.4"></rect><rect x="80" y="105" width="12" height="6.5" rx="0.8" stroke-width="0.4"></rect><rect x="94" y="105" width="12" height="6.5" rx="0.8" stroke-width="0.4"></rect><rect x="108" y="105" width="12" height="6.5" rx="0.8" stroke-width="0.4"></rect><rect x="122" y="105" width="12" height="6.5" rx="0.8" stroke-width="0.4"></rect><rect x="136" y="105" width="12" height="6.5" rx="0.8" stroke-width="0.4"></rect><rect x="150" y="105" width="12" height="6.5" rx="0.8" stroke-width="0.4"></rect><text x="58" y="120" text-anchor="middle" font-size="2.8" font-family="JetBrains Mono" fill="currentColor" stroke="none">1</text> <text x="72" y="120" text-anchor="middle" font-size="2.8" font-family="JetBrains Mono" fill="currentColor" stroke="none">2</text> <text x="86" y="120" text-anchor="middle" font-size="2.8" font-family="JetBrains Mono" fill="currentColor" stroke="none">3</text> <text x="100" y="120" text-anchor="middle" font-size="2.8" font-family="JetBrains Mono" fill="currentColor" stroke="none">4</text> <text x="114" y="120" text-anchor="middle" font-size="2.8" font-family="JetBrains Mono" fill="currentColor" stroke="none">5</text> <text x="128" y="120" text-anchor="middle" font-size="2.8" font-family="JetBrains Mono" fill="currentColor" stroke="none">6</text> <text x="142" y="120" text-anchor="middle" font-size="2.8" font-family="JetBrains Mono" fill="currentColor" stroke="none">7</text> <text x="156" y="120" text-anchor="middle" font-size="2.8" font-family="JetBrains Mono" fill="currentColor" stroke="none">8</text> <text x="100" y="148" text-anchor="middle" font-size="6" font-family="JetBrains Mono" fill="currentColor" stroke="none" letter-spacing="1">LAUNCH CONTROL XL 3</text></svg>

#### Deep surface

Novation **Launch Control XL 3** positions as the deeper control option — 24 endless encoders, 8 faders, 16 pads, transport. In development as a first-class surface: dedicated CC-mapping JSON with a per-engine page layout, Lua starter scripts.

07 · Open control layer

#### Extend

Plug in a class-compliant MIDI controller, touch **MIDI learn**, save the mapping, then shape the behavior in **Lua**. Map a controller you like, then share the mapping and a starter script so everyone gets it out of the box.

01 **MIDI learn**

02 **Lua behavior**

03 **Contribute support**