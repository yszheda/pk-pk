---
title: "SaySynth: A Brief History of Speaking Machines"
source: "https://brian.abelson.live/log/2025/12/20/saysynth-composition-codes.html"
author:
published:
created: 2026-06-03
description: "These are expanded notes from a talk I gave at composition. codes on December 21, 2025. Slides here. Video here. SaySynth is a synthesizer I built on top of ..."
tags:
  - "ToRead"
---

*These are expanded notes from a talk I gave at [composition.codes](https://composition.codes/) on December 21, 2025. [Slides here](https://brian.abelson.live/slides/saysynth.html). [Video here](https://www.youtube.com/watch?v=tX3nEPt0fKk).这些是我于2025年12月21日在 [composition.codes](https://composition.codes/) 发表的演讲的扩展笔记。 [幻灯片在此](https://brian.abelson.live/slides/saysynth.html) 。 [视频在此](https://www.youtube.com/watch?v=tX3nEPt0fKk) 。*

[SaySynth](https://gitlab.com/abelsonlive/saysynth) is a synthesizer I built on top of macOS’s text-to-speech framework — more popularly known as the **say** command. But to explain why I built it and why I think it matters, I want to take a detour through the history of speaking machines more broadly.[SaySynth](https://gitlab.com/abelsonlive/saysynth) 是我基于macOS的文本转语音框架——也就是广为人知的 **say** 命令——开发的一款合成器。但要解释我为何开发它，以及我认为它的重要性所在，我想先绕个弯，整体聊聊语音合成设备的发展历史。

## A Typology of Speaking Machines 说话机器的类型学

There are roughly four kinds of speaking machines that have existed over time:纵观历史，大致存在四种类型的发声机器：

**Mechanical** — Literally physical: bellows forcing air through a reed, with different knobs, valves, and whistles shaping different formants and phonemes. The human operator is part of the instrument.**机械的** ——字面意义上指物理层面的：风箱推动空气穿过簧片，通过不同的旋钮、阀门和哨音塑造不同的共振峰与音素。演奏者是这件乐器的一部分。

**Formant/Rule-Based** — More like a synthesizer: an oscillator and a comb filter simulating the resonant shape of the vocal tract. The system models the acoustics of speech without recording any actual speech.**共振峰/基于规则** ——更类似于合成器：由振荡器和梳状滤波器模拟声道的共振形态。该系统无需录制任何真实语音，即可对语音声学特性进行建模。

**Sample-Based (Concatenative)** — From something as crude as a toy with a phonograph inside, all the way to sophisticated “diphone” synthesizers that splice together recordings of every possible phoneme transition. GPS voices and automated customer service phone lines of the ’90s and 2000s were built this way.**基于样本拼接式** ——从内部装有留声机的玩具这类极为简陋的设备，到将所有可能音素过渡的录音片段拼接而成的精密“双音素”合成器，均属于此类。20世纪90年代和21世纪初的GPS语音播报以及自动化客服电话线路，都是通过这种方式制作的。

**Generative (Neural/AI)** — What most people think of today. These are basically sample-based systems taken to an extreme: instead of recordings of phoneme pairs, you’re dealing with individual digital samples predicted by a neural network, sample by sample.**生成式（神经/人工智能）** ——这是如今大多数人所认知的类型。这类系统本质上是基于采样的系统发展到极致的产物：不再使用音素对的录音，而是通过神经网络逐样预测单个数字采样值来进行处理。

## A Brief History 简史

### Von Kempelen’s Speaking Machine (1773)肯佩伦的说话机器（1773年）

<video src="https://brian.abelson.live/assets/video/kemplens-speaking-machine.mp4" controls=""></video>

![](https://brian.abelson.live/assets/img/vonkemplen-diagram.png)

The first speaking machine most people point to. An operator pushes air through a reed and moves their hand around a piece of leather to simulate the shape of the vocal tract, while separate whistles handle noisier consonants like S and T. Crude, but the basic architecture — oscillator source, shaped by something simulating a vocal tract — is essentially what we still see in formant synthesizers today.大多数人会提及第一台会说话的机器。操作员让空气穿过簧片，并在一块皮革上移动手部来模拟声道的形状，同时通过独立的哨音处理S、T这类噪音更明显的辅音。这一装置虽简陋，但其基本架构——由振荡器发声，再经模拟声道的结构进行塑形——与如今共振峰合成器的核心原理基本一致。

### Joseph Faber’s Euphonia (1845) 约瑟夫·费伯的“悦耳琴”（1845年）

![](https://brian.abelson.live/assets/img/euphonia.png)

Faber iterated on von Kempelen’s design into something far more sophisticated: sixteen keys, each generating a different phoneme. You can start to see the importance of the *operator* in these systems. To make it seem less threatening, Faber put a woman’s face on the front of it and, reportedly, sometimes hung a dress in front of the machinery. I suspect this had the opposite of its intended effect.费伯对冯·肯佩伦的设计进行了改进，打造出了一套复杂得多的装置：十六个按键，每个按键对应一个不同的音素。你开始能意识到 *操作者* 在这些系统中的重要性。为了让它看起来不那么吓人，费伯在装置正面装了一张女性的脸，而且据说，他有时还会在机器前挂一条裙子。我怀疑这起到了与初衷截然相反的效果。

### Edison Talking Dolls (1890s) 爱迪生会说话玩偶（19世纪90年代）

<video src="https://brian.abelson.live/assets/video/edison-speaking-doll.mp4" controls=""></video>

Not quite a speaking machine in the traditional sense, but the first concatenative one: a doll with a miniature phonograph inside playing back recordings of children’s rhymes. Edison thought embedding recorded voices in a toy would help people get comfortable with the technology. The preserved recordings suggest he was mistaken.它并非传统意义上的会说话的机器，而是第一台拼接式发声装置：一个内部装有微型留声机的玩偶，播放童谣录音。爱迪生认为在玩具中嵌入录制的声音能帮助人们适应这项技术。现存的录音表明他错了。

### VODER (1939) 语音合成器（1939年）

<video src="https://brian.abelson.live/assets/video/voder-1939.mp4" controls=""></video>

![](https://brian.abelson.live/assets/img/voder-diagram.gif)

Demonstrated at the 1939 World’s Fair, the VODER was genuinely remarkable for its time — a monophonic synthesizer with an oscillator, a noise generator, and a set of controls for shaping phonemes in real time, with pitch controlled by a foot pedal. What I find most interesting about it is that its “impressiveness” was entirely dependent on its operators, women known as “Voderettes,” who trained for *years* to produce intelligible speech. The inventor got all the credit. The operators are largely nameless to history.1939年纽约世界博览会上展出的语音合成器（VODER）在当时堪称真正的非凡之作——这是一款单音合成器，配备振荡器、噪声发生器，还有一套可实时调整音素的控制装置，音高则由脚踏板控制。我觉得它最有意思的一点是，其“惊艳程度”完全取决于操作员——这些被称为“语音合成师”（Voderettes）的女性，为了发出清晰可辨的语音，接受了长达 *数年* 的训练。发明者独享了所有赞誉，而这些操作员在历史上却大多默默无闻。

### MUSA — Multichannel Speaking Automaton (1978)穆萨——多通道语音自动机（1978年）

<video src="https://brian.abelson.live/assets/video/musa-cselt-example.mp4" controls=""></video>

Developed in Italy, MUSA was one of the first practical diphone synthesizers. They even pressed a vinyl record of the results. It uses recordings of every possible phoneme transition (around 2,000 combinations) and then applies DSP to smooth them together. This approach became dominant in commercial TTS through the ’90s and 2000s.MUSA 于意大利研发而成，是首批实用的双音素合成器之一。研究人员甚至将合成结果压制在了黑胶唱片上。该技术会录制所有可能的音素过渡（约2000种组合），随后通过数字信号处理（DSP）技术对其进行平滑拼接。在20世纪90年代至21世纪初，这种方法在商业文本到语音（TTS）系统中占据了主导地位。

### S.A.M. — Software Automatic Mouth (1982)S.A.M. — 软件自动语音合成器（1982年）

![](https://brian.abelson.live/assets/img/sam-ad.jpg)

The first commercially available speech synthesizer, available for the Commodore 64, Atari, and Apple II. What makes SAM notable is that it exposed controls for pitch, speed, and inflection to the user. The company that made it later provided the technology underlying Macintosh’s Macintalk — which is where this story gets personal.首款商用语音合成器，适用于康懋达64、雅达利和苹果II电脑。SAM的特别之处在于它向用户开放了音高、语速和语调的控制选项。研发该产品的公司后来为麦金塔电脑的Macintalk语音系统提供了核心技术——这也是这段故事与我个人息息相关的原因。

## Two Recurring Patterns 两种反复出现的模式

Before moving on, it’s worth noting two things that recur throughout this history.在继续之前，值得指出的是，这段历史中反复出现两个特点。

**Speaking machines are often demonstrated through singing.** From HAL 9000 singing “Daisy Bell” in *2001: A Space Odyssey* to Siri, singing has always been the ultimate proof-of-concept for TTS, because it forces the system to handle pitch variation, rhythm, and expressiveness. But there’s an implicit claim embedded in this: that singing is the pinnacle of human linguistic expression, and that a speaking machine isn’t truly “human” unless it can sing.**会说话的机器通常通过演唱来展示。** 从 *《2001：太空漫游》* 中哈尔9000演唱《雏菊贝尔》，到如今的苹果语音助手Siri，演唱一直是文本到语音合成（TTS）技术的终极概念验证，因为它要求系统处理音高变化、节奏和表现力。但这其中隐含着一种观点：演唱是人类语言表达的巅峰，一台会说话的机器若不能演唱，就并非真正的“具有人类特质”。

![](https://brian.abelson.live/assets/img/hal-9000-eye.png) ![](https://brian.abelson.live/assets/img/siri.gif)

**Speaking machines encode the biases of the culture that produces them.** Faber put a female face on his Euphonia to make it seem less threatening. The Voderettes trained for years and are now forgotten. Most AI assistants today are female-coded by default. This isn’t incidental — it reflects a consistent, uncomfortable pattern in how we try to make machines seem approachable by feminizing them, while making the actual human labor behind them invisible.**会说话的机器会承载孕育它们的文化的偏见。** 费伯为他的“尤福尼亚”装置设计了女性形象，以降低其威慑感。沃德勒茨团队经过多年训练，如今却已被遗忘。如今大多数人工智能助手默认都带有女性化特征。这并非偶然——它反映出一种一贯且令人不安的模式：我们试图通过将机器女性化，让它们显得亲切易接近，却同时掩盖了背后真实的人类劳动。

## Macintalk and the say Command 麦金塔克语音与say命令

<video src="https://brian.abelson.live/assets/video/fred-mac.mp4" controls=""></video>

In 1984, Apple shipped Macintalk, a formant-based TTS system. At its launch, Steve Jobs had the Mac introduce itself — a demo that was received with the kind of collective rapture that, in retrospect, feels a little embarrassing.1984年，苹果公司推出了Macintalk，这是一套基于共振峰的文本转语音系统。产品发布时，史蒂夫·乔布斯让Mac进行了自我介绍——这场演示收获了众人的集体狂热，如今回想起来，多少有些令人尴尬。

If you had an Apple computer in the ’90s, you probably remember playing with voices like Bad News, Cellos, Bubbles, Whisper, or Princess. In 2001, with Mac OS X (Cheetah), Apple added a command-line interface to this capability:如果你在20世纪90年代拥有一台苹果电脑，你或许还记得体验过坏消息、大提琴、泡泡、低语或公主这类语音。2001年，随着Mac OS X（猎豹版）的发布，苹果为这一功能加入了命令行界面：

![](https://brian.abelson.live/assets/img/mac-osx-disk.png)

```bash
say -v Fred "I sure like being inside this fancy computer"
```

What most people don’t know is that **say** (and the underlying speech framework) had a hidden, low-level DSL for controlling prosody at the phoneme level. Here’s what it looks like:大多数人不知道的是， **say** （以及其底层的语音框架）有一个隐藏的、低级的领域特定语言，用于在音素层面控制韵律。其形式如下：

```
[[inpt TUNE]]
~
AA {D 120; P 176.9:0 171.4:22 161.7:61}
r {D 60; P 166.7:0}
~
y {D 210; P 161.0:0}
UW {D 70; P 178.5:0}
_
S {D 290; P 173.3:0 178.2:8 184.9:19 222.9:81}
...
[[inpt TEXT]]
```

Each phoneme can be assigned a duration (**D**, in milliseconds) and a pitch curve (**P**, as frequency-at-position pairs). That chunk above is roughly “are you brushing your teeth?” decomposed into its constituent sounds and then recomposed with explicit timing and pitch. You can get surprisingly expressive with it — not natural-sounding, but expressive in a different way.每个音素都可以被赋予一个时长（D</b>，单位为毫秒）和一条音高曲线（P</b>，以频率-位置对的形式呈现）。上面的这段内容大致是将“你在刷牙吗？”分解为其组成音素，然后再按照明确的时长和音高重新组合而成。用这种方法可以做出极具表现力的语音——虽然听起来不自然，但却是另一种形式的表达。

I couldn’t find many examples of other people using this syntax. It was documented on an archived Apple developer site and is now deprecated, removed from current macOS. (Which is why I needed to bring an old Mac mini to the demo.) 我没找到太多其他人使用这种语法的例子。它曾记录在苹果开发者网站的存档页面上，如今已被弃用，从当前的 macOS 系统中移除了。（这也是我需要带一台旧的 Mac mini 来进行演示的原因。）

## SaySynth

The insight behind SaySynth is simple: if you can specify pitch per-phoneme in the **say** DSL, you can use it as a synthesizer. Instead of trying to produce legible speech, you push the tool in a direction it was never designed for.SaySynth 背后的核心理念很简单：如果你能在 **say** 领域特定语言中为每个音素指定音高，就可以将其用作合成器。我们不再追求生成清晰可辨的语音，而是将工具推向它原本从未被设计过的方向。

Rather than writing raw DSL by hand, I built a YAML-based sequencer on top of it. Here’s an excerpt from a piece called “fire”:我没有直接手写原始的领域特定语言（DSL），而是在其基础上构建了一个基于 YAML 的序列器。以下是一段名为“fire”的代码片段节选：

```yaml
name: fire
globals:
    start_bpm: 65
    rate: 160
    stereo: true
tracks:
    water:
        type: chord
        options:
            root: F#2
            text: wawer
            voice: Victoria
            chord_notes: [-12, -5, 0, 4, 9, 14]
            segment_count: 1/32
            randomize_segments: octaves,velocity
            volume_range: [0.01, 0.19]
    fire:
        type: chord
        options:
            root: F#0
            chord_notes: [0, 12]
            text: fire!
            segment_count: 1/6
            randomize_segments: octaves,velocity
            volume_range: [0.05, 0.4]
```
<iframe src="https://bandcamp.com/EmbeddedPlayer/album=4231311876/size=large/bgcol=ffffff/linkcol=0687f5/tracklist=false/artwork=small/transparent=true/"><a href="https://abelsonlive.bandcamp.com/album/saysynth">saysynth by Brian Abelson</a></iframe>

Each “chord” is produced by spawning multiple parallel **say** subprocesses, one per note. Because there’s no way to synchronize them precisely, they slowly drift in and out of phase. The system *failing* to do the thing it’s supposed to do is what makes it sound interesting — more organic, more human-like than it has any right to be.每一个“和弦”都是通过生成多个并行的say</b>子进程来实现的，每个音符对应一个子进程。由于无法精确同步这些子进程，它们的相位会逐渐发生偏移。系统 *未能* 完成其应有的功能，反而让这段声音听起来别具韵味——比它本应呈现的效果更具自然感，也更贴近人声。

I’ve also [been working on support for alternative tunings via Ableton’s Scala](https://gitlab.com/abelsonlive/asclpy) (**.ascl**) format, which makes it possible to play in, say, Wendy Carlos’s tuning from *Beauty in the Beast* rather than standard 12-tone equal temperament.我还在 [通过 Ableton 的 Scala 支持替代调律](https://gitlab.com/abelsonlive/asclpy) （**.ascl** ）格式，这使得我们可以使用温迪·卡洛斯在 *《Beauty in the Beast》* 中使用的调律来演奏，而非标准的 12 平均律。

## Why Does This Matter? 为何这很重要？

> Whatever you now find weird, ugly, uncomfortable and nasty about a new medium will surely become its signature… It’s the sound of failure: so much modern art is the sound of things going out of control, of a medium pushing to its limits and breaking apart.无论你现在觉得一种新媒介有多么怪异、丑陋、令人不适和讨厌，这些特质终将成为它的标志……这是一种失败的声响：许多现代艺术所呈现的，都是事物失控的声响，是媒介不断逼近自身极限并走向崩解的声响。
> 
> — Brian Eno — 布莱恩·伊诺

The version of the future that tech companies sell us is one in which AI improves exponentially until it reaches “humanness” — the singularity.科技公司向我们描绘的未来版本，是人工智能呈指数级发展直至具备“人性”——即实现技术奇点的场景。

![](https://brian.abelson.live/assets/img/singularity-plot-1.png)

What this story leaves out is that humanness isn’t a fixed target. Capitalism slowly dehumanizes people, narrows what we do and how we’re valued, until it becomes easier for AI to approximate what we’ve become. If you’re training machine learning models in a warehouse or running the same script in a call center, you’re already functioning like a machine in the relevant sense.这个故事忽略了一点，即人的本质并非一个固定的目标。资本主义会慢慢消解人的主体性，压缩我们的行为空间与价值评判标准，最终让人工智能更容易复刻出我们如今的样子。如果你在仓库里训练机器学习模型，或是在呼叫中心重复执行同一套脚本，从相关层面来说，你已经在像机器一样运转了。

![](https://brian.abelson.live/assets/img/singularity-plot-2.png)

The history of speaking machines is, in part, a history of compressing the expressive range of human voice until it becomes usable — legible, predictable, efficient. Each generation of TTS gets more natural-sounding and less weird. The **say** command’s low-level phoneme DSL, which let you do genuinely strange things with pitch and timing, is now deprecated. SSML (the standardized modern alternative) lets you specify *relative* pitch but not actual frequencies. As TTS has gotten better at sounding human, it’s gotten less interesting as a creative tool.语音合成设备的发展史，在某种程度上就是一部压缩人类声音表达范围的历史——直到它变得可用——清晰可辨、可预测且高效。每一代文本转语音（TTS）技术都变得更自然、更不怪异。 **say** 命令的底层音素领域特定语言（DSL）曾让你能对音高和节奏进行极为奇特的操控，如今已被弃用。语音合成标记语言（SSML）——这一标准化的现代替代方案——允许你指定 *相对* 音高，却无法设定实际频率。随着文本转语音技术在模仿人声上愈发精进，它作为创意工具的价值也随之降低。

I think there’s real value in working with tools that are supposed to do one thing and fail, tools that preserve the texture of their own limitation. Not for nostalgia’s sake, but because that texture *is* the thing — because art’s job right now might be to make strange what capitalism is trying to make invisible and ordinary.我认为，与那些本应只做一件事却做不到的工具合作，与那些保留着自身局限质感的工具合作，有着真正的价值。这并非出于怀旧，而是因为这种质感 *就是* 关键所在——当下艺术的使命，或许就是让资本主义试图变得隐形且寻常的事物，变得陌生而独特。

![](https://brian.abelson.live/assets/img/singularity-plot-2-warped.gif)

---

*SaySynth is on [GitLab](https://gitlab.com/abelsonlive/saysynth). Music made with it is on [Bandcamp](https://abelsonlive.bandcamp.com/album/saysynth).SaySynth 发布在 [GitLab](https://gitlab.com/abelsonlive/saysynth) 上。用它制作的音乐发布在 [Bandcamp](https://abelsonlive.bandcamp.com/album/saysynth) 上。*

---

#### Links in this post: 本文中的链接：

- "composition.codes": [https://composition.codes/](https://composition.codes/) composition.codes": [https://composition.codes/](https://composition.codes/)
- "Slides here": [https://brian.abelson.live/slides/saysynth.html](https://brian.abelson.live/slides/saysynth.html) “此处的幻灯片”： [https://brian.abelson.live/slides/saysynth.html](https://brian.abelson.live/slides/saysynth.html)
- "Video here": [https://www.youtube.com/watch?v=tX3nEPt0fKk](https://www.youtube.com/watch?v=tX3nEPt0fKk) “视频在此”： [https://www.youtube.com/watch?v=tX3nEPt0fKk](https://www.youtube.com/watch?v=tX3nEPt0fKk)
- "SaySynth": [https://gitlab.com/abelsonlive/saysynth](https://gitlab.com/abelsonlive/saysynth) SaySynth"： [https://gitlab.com/abelsonlive/saysynth](https://gitlab.com/abelsonlive/saysynth)
- "saysynth by Brian Abelson": [https://abelsonlive.bandcamp.com/album/saysynth](https://abelsonlive.bandcamp.com/album/saysynth) saysynth 由布莱恩·艾布尔森创作"： [https://abelsonlive.bandcamp.com/album/saysynth](https://abelsonlive.bandcamp.com/album/saysynth)
- "been working on support for alternative tunings via Ableton’s Scala": [https://gitlab.com/abelsonlive/asclpy](https://gitlab.com/abelsonlive/asclpy) 一直在通过 Ableton 的 Scala 开发对替代调音的支持"： [https://gitlab.com/abelsonlive/asclpy](https://gitlab.com/abelsonlive/asclpy)