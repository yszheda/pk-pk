---
title: "Turning a Dumb AC Unit Smart (Without Losing my Security Deposit)"
source: "https://prilik.com/blog/post/automating-ac-nyc/"
author:
published: 2026-07-20
created: 2026-08-07
description: "TL;DR: DIY home automation is ezpz with nothing more than a stepper motor, an esp32, and a high tolerance for Jank.My rental apartment’s AC unit can only be controlled using these retro-looking analog knob-based controls, mounted right onto the unit. No separate wall-mounted thermostat, no remote control… nothin’ fancy whatsoever.These knobs work… but having to constantly stand up and fiddle with them gets annoying pretty quick.Fortunately, there’s an ‘ol Prilik family saying that goes something like this: “remember son - the hardest problems in life can usually be solved with nothing more than a stepper motor, an esp32, and a dream”1And sure enough, after dropping ~$15 on parts, waiting for things to arrive from China, and spending a few hours iterating on the hardware assembly and firmware… I hacked together this beautiful mess:What you’re looking at here is a jerry-rigged esp32-controlled stepper motor, coupled to one of my AC unit’s knobs using a shaft coupler, all affixed to the AC’s back-plane using a cheap L-bracket and a binder clip (with some industrial-grade cardboard padding for good measure).This whole MacGyver’d up contraption talks to my Home Assistant instance over MQTT, which turns the AC unit on/off based on the state of a temperature sensor located in the same room.Et voila 🪄 ✨Just like that - I’ve managed to free myself from the shackles of having to get up off the couch just to tweak my AC!For all you professional embedded and mechatronics folks out there: I strongly suggest you stop reading here.The rest of this blog post is a walkthrough of a software engineer’s approach to home automation and building custom hardware, and let me tell you: both the final product, and the journey to get there, are hella jank.That said… if you’re not afraid of a bit of jank: read onwards, and join me on this fun foray into how I managed to hack together some totally bespoke home-automation hardware with almost no budget, or experience!"
tags:
  - "ToRead"
---
**TL;DR:** DIY home automation is ezpz with nothing more than a stepper motor, an esp32, and a high tolerance for Jank.**总结：简而言之：** DIY家庭自动化非常简单，只需一个步进电机、一台esp32，并且对不良设备容忍度很高。

---

My rental apartment’s AC unit can only be controlled using these retro-looking *analog* knob-based controls, mounted right onto the unit. No separate wall-mounted thermostat, no remote control… nothin’ fancy whatsoever.我租的公寓的空调只能用这些复古风格的 *模拟* 旋钮控制器来控制，这些控制器直接安装在设备上。没有单独的墙壁恒温器，没有遥控器......一点花哨的都不。

These knobs work… but having to constantly stand up and fiddle with them gets annoying pretty quick.这些旋钮能用......但不得不一直站着摆弄它们，很快就会让人感到烦躁。

![](https://prilik.com/blog/assets/automating-ac-nyc/aircon-controls-crop.jpg)

Fortunately, there’s an ‘ol Prilik family saying that goes something like this: “remember son - the hardest problems in life can usually be solved with nothing more than a stepper motor, an esp32, and a dream” [^1] 幸运的是，有句老普里利克家族的谚语大意是这样的：“记住，儿子——人生中最难的问题通常只需一个步进电机、一个esp32和一个梦想就能解决。”

And sure enough, after dropping ~$15 on parts, waiting for things to arrive from China, and spending a few hours iterating on the hardware assembly and firmware… I hacked together this beautiful mess:果然，在花了~15美元买零件、等待中国寄来的零件，并花了几个小时迭代硬件组装和固件之后......我拼凑出了这份美丽的混乱：

![](https://prilik.com/blog/assets/automating-ac-nyc/v1-final-working-crop.jpg)

What you’re looking at here is a jerry-rigged **esp32-controlled stepper motor**, coupled to one of my AC unit’s knobs using a **shaft coupler**, all affixed to the AC’s back-plane using a **cheap L-bracket** and a **binder clip** (with some industrial-grade **cardboard padding** for good measure).你看到的是一个临时改装的 **esp32控制步进电机** ，通过 **轴联结** 器连接到我空调的一个旋钮上，所有部件都用 **廉价的L型支架** 和 **活页夹** 固定在空调的背板上（还加了一些工业级 **纸板垫** 子以防万一）。

This whole MacGyver’d up contraption talks to my **Home Assistant** instance over **MQTT**, which turns the AC unit on/off based on the state of a temperature sensor located in the same room.这整套MacGyver'd up装置通过MQTT与我的 **Home Assistant** 实例通信， **MQTT** 根据同一房间内温度传感器的状态开关空调。

Et voila 🪄 ✨ 这就是🪄 ✨全部内容

Just like that - I’ve managed to free myself from the shackles of having to get up off the couch just to tweak my AC!就这样——我终于摆脱了必须起身去调节空调的束缚！

> For all you professional embedded and mechatronics folks out there: I *strongly* suggest you stop reading here.对于所有专业嵌入式和机电一体化爱好者：我 *强烈* 建议你们停止阅读。
> 
> The rest of this blog post is a walkthrough of a *software* engineer’s approach to home automation and building custom hardware, and let me tell you: both the final product, *and* the journey to get there, are *hella jank*.接下来的博客内容是 *软件工程师在* 家庭自动化和定制硬件构建过程中的详细讲解，告诉你：无论是最终产品 *还是* 实现过程，都非常 *糟糕* 。
> 
> That said… if you’re not afraid of a bit of jank: read onwards, and join me on this fun foray into how I managed to hack together some totally bespoke home-automation hardware with almost no budget, or experience!话虽如此......如果你不怕有点小瑕疵：请继续阅读，加入我这场有趣的冒险，看看我是如何在几乎没有预算和经验的情况下，打造出完全定制的家庭自动化硬件的！

## 🗽 Setting the stage

In April 2025, I moved to New York City. After a brief apartment hunt, I managed to find a place I’m pretty happy with: the location is convenient, the building is fairly modern, and the rent is an absolute steal. There’s not much to complain about!2025年4月，我搬到了纽约市。经过短暂的找房，我找到了一个相当满意的地方：位置便利，建筑相当现代，租金绝对划算。没什么好抱怨的！

…well, except for the AC situation.…嗯，除了空调的情况。

See, for whatever reason, developers in NYC *really* like using these loud, power-hungry, wall-mounted [PTAC units](https://en.wikipedia.org/wiki/Packaged_terminal_air_conditioner) in their apartment buildings. Some buildings might spend a bit extra in order to wire these units up to wall-mounted thermostats… but oftentimes, they’ll just go with the cheapest option: completely *analog, unit-mounted knobs*.你看，不管出于什么原因，纽约的开发商 *非常* 喜欢在公寓楼里使用这些吵闹、耗电的墙挂式 [PTAC设备](https://en.wikipedia.org/wiki/Packaged_terminal_air_conditioner) 。有些建筑可能会多花点钱把这些设备接到墙上恒温器上......但很多时候，他们会选择最便宜的方案：完全 *模拟的单元安装旋钮* 。

Here’s a picture of what I’m talking about:这是我说的那种情况的图片：

![](https://prilik.com/blog/assets/automating-ac-nyc/aircon-controls.jpg)

Yeah - guess which option *my* building went with 🙃 是的——猜猜 *我* 楼用🙃了哪个选项

## 🤔 What are my options here?

Like any good renter, the first thing I did was gently ask my landlord if there was any way to “upgrade” the controls to something a bit more… modern. As expected, the response was roughly along the lines of “lol no, why would we do that?”, which, to be fair, was basically the response I expected.像所有好租客一样，我做的第一件事就是温和地问房东，有没有办法“升级”一下控制，换成更......现代。正如预料的那样，回应大致是“哈哈，为什么要这么做？”，说实话，这基本上是我预料中的。

Well, no matter, like any good engineer - *surely* I can hack my way out of this pickle?好吧，没关系，像任何优秀的工程师一样——我 *肯定* 能破解这困境吧？

After a bit of finessing, I managed to pop the cover off the unit, and expose its ~~soft underbelly~~ inner workings. Much to my surprise, not only did I find some info about the unit, but even a whole wiring diagram!经过一番调整，我终于把外壳撬开，露出了它柔软的内部结构。令我惊讶的是，我不仅找到了关于这台设备的一些信息，甚至还有一整张接线图！

![](https://prilik.com/blog/assets/automating-ac-nyc/ptac-controls-and-wiring-diagram-crop.jpg) ![](https://prilik.com/blog/assets/automating-ac-nyc/ptac-serial-and-info.jpg)

Now, I’m no expert when it comes to wiring diagrams, but by following the wiring, it certainly seems like this entire circuit is operating at *line voltage*, with nary a low-voltage digital signal I can hook into in sight.我不是布线图专家，但按照布线操作，似乎整个 *电路都在电压* 下工作，几乎看不到低压数字信号。

## ⏺️ Smart Relays?

Ok, maybe I can just splice in a [smart relay](https://www.amazon.com/smart-relay/s?k=smart+relay) somewhere? I’m no electrician, but it’s probably not *that* hard, right?好吧，也许我可以在某处接一个 [智能继电](https://www.amazon.com/smart-relay/s?k=smart+relay) 器？我不是电工，但应该不 *难* ，对吧？

Well, maybe? 也许吧？

But honestly, I didn’t think this was gonna be a viable route for me.但说实话，我并不认为这条路对我来说可行。

Setting aside the fact that working with line voltage and HVAC equipment is a bit “spooky” for someone with zero electrical wiring experience (and that my landlord probably wouldn’t be *thrilled* with me messing about with these sorts of things), the bigger issue was that all the juicy wires I’d be interested in intercepting are stuffed *deep* inside the AC unit.撇开对完全没有电气布线经验的人来说，处理线路电压和暖通空调设备有点“吓人”（而且房东可能也不会 *喜欢* 我动这些东西），更大的问题是我感兴趣的那些漂亮电线都塞在空调机组 *深* 处。

As far as I could tell, the only way to access those wires would be to yank the whole unit out of the wall… something that I wasn’t particularly interested in doing. [This thread](https://www.doityourself.com/forum/air-conditioning-cooling-systems/577337-older-ice-cap-ptac-add-thermostat.html) from ~2017 reinforced my impressions that this would be far more trouble than its worth.据我所知，唯一能接触到这些电线的办法就是把整个设备从墙里拔出来......而我并不是特别感兴趣。2017年 [~的这个帖子](https://www.doityourself.com/forum/air-conditioning-cooling-systems/577337-older-ice-cap-ptac-add-thermostat.html) 让我更加坚信，这样做麻烦远大于价值。

So… what now? 所以......接下来怎么办？

## 🔌 Smart Plugs?

Ok, here’s an idea: what if I just cut power to the unit using a [smart plug](https://www.amazon.com/s?k=smart+plug&crid=2WEKKKT1D6E9M&sprefix=smart+pl%2Caps%2C142&ref=nb_sb_noss_2)?好，有个想法：如果我用 [智能插座](https://www.amazon.com/s?k=smart+plug&crid=2WEKKKT1D6E9M&sprefix=smart+pl%2Caps%2C142&ref=nb_sb_noss_2) 切断设备的电源怎么样？

> Note: The internet was quick to warn me that toggling power to a running AC unit could potentially cause damage to the unit, especially if something goes wrong and you start rapidly cycling it on/off.注意：网上很快提醒我，切换空调电源可能会损坏设备，尤其是当出现故障时，你开始频繁开关空调。
> 
> While I’m no expert in these sorts of things… for the sake of science (and because I’m a bit stubborn), I nonetheless kept looking into this option.虽然我不是这方面的专家......出于科学考虑（也因为我有点固执），我还是继续研究这个选项。

Alas, much to my chagrin - the unit plugs into the wall using one of those fancy NEMA 5-20P plugs, which is basically impossible to find a smart switch for!可惜的是，这台设备用的是那种高级的NEMA 5-20P插头插墙，几乎找不到智能开关！

![](https://prilik.com/blog/assets/automating-ac-nyc/NEMA_5-20P.svg.png)

Well shoot! 哎呀！

If hooking into the wiring is a non-starter, and putting the unit behind a smart plug is non-trivial… am I just out of luck?如果接线根本做不到，把设备装在智能插座后面也不简单......我是不是没运气？

Of course not! 当然不是！

Clearly it was time to put my engineering hat on and *jank* together a solution: why not just make a little robot to turn the dials for me?显然，是时候戴上工程帽子， *临时拼* 凑解决方案了：为什么不做个小机器人帮我转动旋钮呢？

## 🎛️ Dialing in the right approach

Looking at the unit, we find 2 dials:看设备时，我们发现了两个刻度盘：

1. **Mode Control:** A stiff, discrete dial, clicking between 6 “modes” of operation (Off, Lo-Cool, Hi-Cool [^2], Vent, Exhaust, and Heat) **模式控制：** 一个硬挺、独立的旋钮，能在6种“模式”间切换（关闭、低冷、高冷、通风、排气和加热）
2. **Temp Control:** A smooth, analog dial, connected to a simple bimetallic-strip based thermostat **温度控制：** 一个光滑的模拟表盘，连接到一个简单的双金属条式恒温器

And fortunately - both plastic knobs pop right off, exposing a shaft that shouldn’t be *too* hard to mechanically couple with:幸运的是——两个塑料旋钮都能直接弹开，露出一个机械连接起来不 *难* 的轴：

![](https://prilik.com/blog/assets/automating-ac-nyc/aircon-controls-noknob.jpg)

This gave me two options to toggle the AC unit on and off:这让我有两个开关空调的选项：

**Option 1:** hooking into the **Mode Control** dial **选项1：** 接入 **模式控制** 旋钮

- Leave the Temp Control dial set to “max cold” 温度控制旋钮保持“最大冷”状态
- Buy a stepper motor with enough torque to overcome the stiff action of the dial 买一台有足够扭矩以克服旋钮僵硬动作的步进电机
	- …which would probably need a 12V DC (if not more) power source, requiring extra circuitry to power …这可能需要12V直流（甚至更高）电源，需要额外的电路来供电
		- …and require some more robust mounting hardware, to counteract the torque, and ensure the stepper motor stays in the right place …并且需要更坚固的安装硬件，以抵消扭矩，并确保步进电机保持在正确的位置
- Precisely calibrate the stepper motor to rotate the dial the right number of degrees between the “Off” state and the “Cool” state 精确校准步进电机，使旋钮在“关闭”和“冷却”状态之间旋转到正确的度数

**Option 2:** hooking into the **Temp Control** dial **选项二：** 接入 **温度控制** 旋钮

- Leave the Mode Control dial on “Lo-Cool” [^3] 将模式控制旋钮保持在“低
- Buy a cheap, low-torque, low-power stepper motor, *just* powerful enough to rotate the fairly loose dial 买一个便宜、低扭矩、低功率的步进电机，功率 *刚好* 能转动相对松散的旋钮
	- …that doesn’t need a lot of mounting hardware to stay in the right place, given that the torque is fairly low …考虑到扭矩较低，这台机器不需要太多固定硬件就能固定在正确的位置
- Imprecisely yeet the stepper motor all the way left/right, toggling the target temp between “really really hot” or “really really cold” 不精确地将步进电机全推向左右，目标温度在“非常非常热”和“非常非常冷”之间切换。

Hopefully you can guess which one I went with 🥰 希望你能猜到我🥰选的是哪一个

> Option 2 certainly is the “jankier” of the two options, given that it relies on a second-order property (target temp) to power the unit on/off… but hey - whatever’s easier, right?选项2无疑是两个选项中更“不稳定”的，因为它依赖于二阶属性（目标温度）来控制设备开关......不过，嘿——哪种更简单，对吧？

## 🔨 The road to V0

I was *fairly* sure this was gonna work, but obviously, the only way to find out was to hack together a proof-of-concept (ideally - with the least number of new purchases as possible).我 *相当* 确定这会成功，但显然，唯一的办法就是拼凑一个概念验证（理想情况下——尽可能减少新购买数量）。

To cut a long story short - here’s what I came up with for V0:长话短说——这是我为V0设计的方案：

| Part 部分 | Cost 费用 | Source 资料来源 |
| --- | --- | --- |
| ESP32 Dev Board ESP32开发板 | $6 | [Amazon 亚马逊](https://www.amazon.com/dp/B0DDPJQX3X) |
| Shaft Coupler 轴联挂器 | $6.69 | [Amazon 亚马逊](https://www.amazon.com/dp/B0D4YBM6HB) |
| Stepper motor + controllers 步进电机+控制器 | $2.66 ($8 / 3 pack) 2.66美元（8美元 / 3件装） | [Amazon 亚马逊](https://www.amazon.com/dp/B0BG4ZCFLQ) |
| L Brackets L括号 | free 免费 | leftover ikea parts (from a LAIVA bookshelf) 宜家剩余零件（来自LAIVA书架） |
| screws 螺丝 | free 免费 | leftover monitor parts 剩余的监视器零件 |
| USB Cable + charger USB线+充电器 | free 免费 | found in the ‘ol junk drawer 在'老废物抽屉里发现的 |

**Total:** ~$16 **总共：** ~$16

And here’s the result: 结果如下：

*(breadboard with the rest of the hardware out-of-frame) （面包板，其他硬件都掉在画面外）*

![](https://prilik.com/blog/assets/automating-ac-nyc/v0-working-closeup.jpg)

![](https://prilik.com/blog/assets/automating-ac-nyc/v0-working-poc.jpg)

Since I couldn’t screw anything into the AC chassis (remember: security deposit!), I had to get creative. I ended up grabbing a couple of metal L-brackets left over from an IKEA LAIVA bookshelf, and some spare screws from a monitor VESA mount.因为我无法把任何东西拧进空调底盘（记住：押金！），我不得不想出办法。我最后从宜家LAIVA书架上捡了几个剩下的金属L型支架，还有一些显示器VESA支架上的备用螺丝。

By bolting these to the stepper motor, it made the motor assembly physically “wider”. When the motor rotates, the brackets bump against the back wall of the control cavity, which resists the torque and forces the rotational energy down into the shaft coupler and turns the dial. Truly ~~unintentional~~ ingenious design!通过将这些部件螺栓固定到步进电机上，使电机组件在物理上“更宽”。当电机旋转时，支架撞击控制腔的后壁，抵抗扭矩，将旋转能量向下推入轴联轴器并转动旋钮。真是无意中巧妙的设计！

> Sidenote: I’m leaving out a few intermediate steps that I took to get to this design:顺便说一句：我省略了一些我为达到这个设计所采取的中间步骤：
> 
> - I didn’t get the right shaft-coupler the first time (or the second time (or the third time…)), so it took a few Amazon returns until I found the right one.我第一次（或者第二次（或者第三次......）都没买到合适的轴联结器，所以我花了几次亚马逊退货才找到合适的。
> - Before buying the ESP32 Dev Board, I validated the stepper motor + shaft coupler worked using a (really, really) old Arduino Leonardo I had lying around, and controlling it manually over serial (using a really long USB cable extending to my PC) 在购买ESP32开发板之前，我验证了步进电机+轴耦合器是用我手头上一台（真的非常非常）旧的Arduino Leonardo手动控制的（用一条很长的USB线连接到我的电脑）
> - My first attempt at mounting this thing involved wooden skewers, a glue stick, and a cut-up Amazon box… a failed experiment, to say the least.我第一次尝试安装这个东西时，用了木签、一根胶棒和一个切好的亚马逊盒子......至少可以说是一次失败的实验。

Of course, what good is some hardware without some software?当然，没有软件的硬件又有什么用呢？

### 💻 Writing the Firmware

The firmware here is *dead simple*: it connects to Wi-Fi, hosts a local web server, and listens for HTTP/MQTT commands to spin the motor.这里的固件非常 *简单* ：它连接Wi-Fi，托管本地网络服务器，并监听HTTP/MQTT命令来驱动电机。

While I do somewhat miss the Good Old Days where I’d spend a couple weekends hacking together this sort of one-off firmware… truth be told, I’m kinda glad that LLMs can one-shot code for these sorts of projects. I ended up using a combo of Claude and Gemini, and they did a Totally Fine™️ job hacking together something that works.虽然我有点怀念过去的美好时光，那时我会花几个周末破解这种一次性固件......说实话，我挺高兴大型语言模型能一次性完成这类项目的代码。我最后用了Claude和Gemini的组合，他们做得非常好™️，做出了能用的软件。

![](https://prilik.com/blog/assets/automating-ac-nyc/bereal-claude-code.jpg)

It even generated a little Web UI I could use to configure my Wi-Fi credentials and adjust settings dynamically:它甚至生成了一个小网页界面，我可以用来动态配置Wi-Fi凭证和调整设置：

![](https://prilik.com/blog/assets/automating-ac-nyc/fw_webui.png)

[Code](https://gist.github.com/daniel5151/2d9950a27119e7e481db4446f2abcf13) is available here, but honestly - it’s not all that interesting.这里有 [代码](https://gist.github.com/daniel5151/2d9950a27119e7e481db4446f2abcf13) ，但说实话——没那么有趣。

## 🏠 Making it Useful with Home Assistant

With the firmware flashed and the hardware jankily mounted in place, I decided to kick the tires on this thing by sitting comfortably on the couch, pulling up the web UI on my phone, and hitting the button to turn the motor.固件刷好，硬件安装得很不稳，我决定试试这台机器，舒服地坐在沙发上，打开手机网页界面，按下启动电机的按钮。

Lemme tell you - seeing the AC kick on/off without me leaving the couch?告诉你——看到空调自动开关，我没离开沙发？

Absolute Cinema. 绝对的电影。

That said, while it *was* cool to see it working from the web UI… for this to be truly useful, I’d need to get it integrated with Home Assistant.话虽如此，虽然看到它能从网页界面运行 *很* 酷......要让它真正有用，我需要把它集成到Home Assistant里。

If you’re not familiar, [Home Assistant](https://www.home-assistant.io/) is an open-source home automation platform that acts as a local brain for all your smart devices. It is absolutely fantastic, and if you do *any* remotely non-trivial smart home stuff - you should *absolutely* set it up.如果你不熟悉， [Home Assistant](https://www.home-assistant.io/) 是一个开源的家庭自动化平台，作为你所有智能设备的本地智能系统。它绝对很棒， *如果你做任何* 稍微不简单的智能家居项目，绝对应该 *去* 安装。

### Step 1: Exposing the Stepper Motor as an MQTT Cover

Instead of writing some kind of custom API integration script, I took advantage of Home Assistant’s excellent support for **MQTT Discovery**.我没有写某种自定义的API集成脚本，而是利用了Home Assistant对 **MQTT发现** 的优秀支持。

> If you’re not familiar with MQTT, think of it as a super lightweight pub/sub messaging protocol designed for resource-constrained IoT devices.如果你不熟悉MQTT，可以把它看作是一种为资源有限的物联网设备设计的超轻量级发布/订阅消息协议。
> 
> Devices can “publish” messages to specific paths (called topics, like `living_room/ac/state`), and other devices (like Home Assistant) can “subscribe” to those topics to listen for updates or send commands.设备可以“发布”消息到特定路径（称为主题，如 `living_room/ac/state` ），而其他设备（如Home Assistant）则可以“订阅”这些主题以监听更新或发送命令。

If you configure a device to publish a specific configuration JSON payload to a standardized discovery topic (e.g., `homeassistant/cover/ac_stepper_cover/config`), Home Assistant will *automatically* discover the device and configure all of its entities, sensors, and controllers - all without you having to write a single line of YAML config!如果你配置设备发布特定的配置JSON负载到标准化发现主题（例如 `homeassistant/cover/ac_stepper_cover/config` ），Home *Assistant会自动发现* 该设备并配置其所有实体、传感器和控制器——你无需编写一行YAML配置！

For a dial controller like this, I decided to expose it as an [MQTT Cover](https://www.home-assistant.io/integrations/cover.mqtt/) integration. While “covers” are typically used for things like window blinds, motorized curtains, or garage doors… its schema supports opening, closing, stopping, which maps pretty well to our rotating dial.对于这样的旋钮控制器，我决定将其暴露为 [MQTT Cover](https://www.home-assistant.io/integrations/cover.mqtt/) 集成。虽然“罩子”通常用于窗帘、电动窗帘或车库门等物品......它的模式支持开合、关闭、停止，这与我们的旋转旋钮相当契合。

When the ESP32 boots up, it automatically connects to the MQTT broker and fires off this discovery JSON payload:当ESP32启动时，它会自动连接到MQTT代理并发射这个发现JSON负载：

```json
{
  "name": "AC Stepper Cover",
  "unique_id": "ac_stepper_esp32_01",
  "object_id": "ac_stepper_cover",
  "command_topic": "homeassistant/cover/ac_stepper_cover/set",
  "state_topic": "homeassistant/cover/ac_stepper_cover/state",
  "position_topic": "homeassistant/cover/ac_stepper_cover/position",
  "set_position_topic": "homeassistant/cover/ac_stepper_cover/position/set",
  "payload_open": "OPEN",
  "payload_close": "CLOSE",
  "payload_stop": "STOP",
  "device_class": "damper",
  "device": {
    "identifiers": "ac_stepper_esp32",
    "name": "AC Control Stepper"
  }
}
```

Once Home Assistant registers the cover, it listens for user interaction on the UI and publishes corresponding commands to the `command_topic`. On the ESP32, the MQTT callback parses the message and drives the stepper motor:一旦Home Assistant注册了封面，它会监听用户界面上的交互，并向 `command_topic` 发布相应命令。在ESP32上，MQTT回调解析消息并驱动步进电机：

```cpp
void mqttCallback(char* topic, byte* payload, unsigned int length) {
  String message = extractMessageFromPayload(payload, length);
  if (String(topic) == COMMAND_TOPIC) {
    handleCoverCommand(message);
  }
}

void handleCoverCommand(const String& command) {
  if (command == "OPEN") {
    motorState.isOpening = true;
    moveMotor(STEPS_PER_REVOLUTION, motorState.currentSpeed);
  } else if (command == "CLOSE") {
    motorState.isOpening = false;
    moveMotor(-STEPS_PER_REVOLUTION, motorState.currentSpeed);
  } else if (command == "STOP") {
    stopMotor();
  }
}
```

Sending an `OPEN` payload makes the stepper motor rotate forward by a full revolution, wrapping the dial to “Coldest”, while `CLOSE` spins the stepper backward to turn it off.发送 `OPEN` 有效载荷使步进电机向前旋转一整圈，旋钮绕至“Coldest”，而 `CLOSE` 则将步进马达向后旋转以关闭。

And just like that - Home Assistant can control the motor!就这样——Home Assistant 可以控制电机了！

![](https://prilik.com/blog/assets/automating-ac-nyc/ha-stepper-as-cover.png)

### Step 2: Adding a Thermostat

With the dial controllable via Home Assistant, the final step was telling it *when* to turn on and off.旋钮可以通过Home Assistant控制，最后一步就是告诉它 *何时* 开机和关闭。

Fortunately, Home Assistant has a built-in integration called [Generic Thermostat](https://www.home-assistant.io/integrations/generic_thermostat/). It’s dead simple - point it at a switch/cover to toggle + a temperature sensor to monitor, and it handles all the hysteresis logic for you!幸运的是，Home Assistant内置了一个叫通用 [恒温器的](https://www.home-assistant.io/integrations/generic_thermostat/) 集成。非常简单——把它指向开关/盖子开关/温度传感器监控，它就能帮你处理所有滞后逻辑！

For the temperature sensor, I’m using an [AirGradient ONE](https://www.airgradient.com/indoor/), a high-quality smart air quality monitor that happens to live in the same room as the AC unit.温度传感器方面，我用的是 [AirGradient ONE](https://www.airgradient.com/indoor/) 这款高品质智能空气质量监测器，恰好和空调在同一个房间里。

Hooking the two together is as simple as adding this to my `configuration.yaml`:把两者连接起来就像把这个加到我的配置里那么简单 `configuration.yaml` ：

```yaml
climate:
  - platform: generic_thermostat
    name: Living Room AC
    heater: cover.ac_stepper_cover
    target_sensor: sensor.airgradient_temperature
    min_temp: 65
    max_temp: 80
    ac_mode: true
    cold_tolerance: 0.5
    hot_tolerance: 0.5
```

And just like that, I had a fully automated smart thermostat running my AC unit!就这样，我的空调机组有了全自动智能恒温器！

![](https://prilik.com/blog/assets/automating-ac-nyc/ha-thermostat.png)

---

## 🛌 Building a Second Unit, Upgrading to V1

Having the living room AC automated was awesome, but as someone who lives in an NYC apartment with the *unfathomable luxury* of having both a living room *and* a bedroom - I realized that I’d need to build a second contraption to automate the second, identical AC unit in my bedroom.客厅空调自动化很棒，但作为一个住在纽约公寓、拥有客厅 *和* 卧室的 *奢华* 的人，我意识到我需要再建一个装置来自动化卧室里第二个一模一样的空调。

Unfortunately, I was fresh out of leftover IKEA brackets and VESA screws… so it was time to find some “real” components I could use to build a more “production-ready” V1 version.可惜我家的余下支架和VESA螺丝都用完了......所以是时候找到一些“真正”的组件，用来构建更“生产级”的V1版本了。

> There’s definitely a world where I decided to use this project as an excuse to finally buy a 3D printer and dip my feet into the world of more “serious” hardware engineering… but truth be told - I just wanted to solve my problem ASAP, so my smooth software-engineering brain decided to just KISS.确实有那么一个世界，我会用这个项目作为借口，终于买了一台3D打印机，开始涉足更“严肃”的硬件工程领域......但说实话——我只是想尽快解决问题，所以我那个流畅的软件工程师大脑决定直接KISS了。

So I went on a little Temu and Amazon shopping spree, and sourced new parts. Here is the bill of materials for the V1 build:于是我去Temu和亚马逊上逛了一圈，找了新零件。这是V1组装的材料清单：

| Part 部分 | Cost 费用 | Source 资料来源 |
| --- | --- | --- |
| ESP32 Dev Board (but smaller) ESP32开发板（但体积更小） | $3.30 | [Temu 以前](https://www.temu.com/goods.html?_bg_fs=1&goods_id=601100253124451) |
| Shaft Coupler 轴联挂器 | $2.42 | [Temu 以前](https://www.temu.com/goods.html?_bg_fs=1&goods_id=601099519071638&sku_id=17592227065720) |
| Stepper motor + controllers 步进电机+控制器 | $2.66 ($8 / 3 pack) 2.66美元（8美元 / 3件装） | [Amazon 亚马逊](https://www.amazon.com/dp/B0BG4ZCFLQ) |
| L Bracket L组 | $0.50 ($4 / 8 pack) 0.50美元（4美元 / 8包） | [Amazon 亚马逊](https://www.amazon.com/dp/B0DBFX6HL6) |
| Nuts and bolts 螺母和螺栓 | negligible [^4] 可忽略 | [Amazon 亚马逊](https://www.amazon.com/dp/B09KS23KQ6) |
| USB cable + charger USB线+充电器 | $5 | Temu (take your pick) Temu（随你选择） |
| Binder Clip (bodge) 束胸夹（bodge） | negligible 可忽略不计 | The Office 🤫 办公室 🤫 |

**Total:** ~$14 **总共：** ~$14

For V1, I swapped out the bulky ESP32 dev board for a much smaller dev board, and used adjustable metal L-brackets that had slots. This allowed me to bolt the stepper motor directly to the bracket with actual nuts and bolts, making the motor-to-bracket connection rock-solid.V1时，我用更小的开发板替换了笨重的ESP32开发板，并使用带槽的可调节金属L型支架。这样我就能用真正的螺母和螺栓把步进电机直接固定在支架上，使电机与支架的连接非常牢固。

Here is what the finished V1 bracket assembly looks like from various angles:从不同角度看，成品V1支架组件的样子如下：

Instead of letting the brackets float and bump against the back wall, I decided to “super securely mount” the assembly to the vertical sheet metal inside the AC’s control compartment using a large binder clip and some “industrial grade” cardboard (to get the spacing just right).我没有让支架漂浮在后墙上撞击，而是用一个大号活页夹和一些“工业级”纸板“把组件”超级牢固地固定在空调控制舱内的垂直钣金上（以调整间距）。

![](https://prilik.com/blog/assets/automating-ac-nyc/v1-final-working.jpg)

I plugged the small ESP32 board in, tucked it neatly into the compartment, and closed the lid. And thanks to some clever USB cable routing - if you look at the AC unit from the outside, you would never even know it was smart!我把小的ESP32主板插上，整齐地塞进隔层，盖上盖子。多亏了巧妙的USB线布线——从外面看空调，根本不会觉得它是智能的！

## 📝 Real World Feedback

So funny enough, I actually built this entire assembly *last* summer, and even wrote ~80% of this blog post shortly after deploying the project… but then I got sidetracked with other stuff, lol.有趣的是，我实际上 *去年夏天就* 做了整个汇编，甚至在部署项目后不久写了这篇博客文章的80%内容......但后来我被别的事情耽搁了，哈哈。

On the bright side, this means that I’ve had ample time to actually put this project through its paces, and with 1-and-a-half summers under its belt so far, I can safely report the following:好的一面是，这意味着我有充足的时间真正把这个项目做成，到目前为止已经经历了一个半夏天，我可以放心地报告以下情况：

It works *okay?* 效果 *还行吗？*

Definitely not great… but maybe *~80% okay?*绝对不怎么样......但也许 *~80%可以？*

Ultimately, the biggest issue is that binder clips and cardboard aren’t quite as robust of a mounting mechanism as I’d hoped they’d be… and over time, the stepper motor tends to “sag” a bit, resulting in a bit too much friction between the motor, the coupler, and the underlying knob, causing the mechanism to stall out until someone manually goes and reseats it… 归根结底，最大的问题是活页夹和纸板作为固定机构没有我期望的那么坚固......随着时间推移，步进电机会有些“下垂”，导致电机、联轴器和下方旋钮之间的摩擦过大，导致机构卡住，直到有人手动重新安装......

Is this annoying? Yeah. 这烦人吗？是的。

Is this less annoying than having to *constantly* adjust the AC manually? Absolutely.这比 *手动不断调节* 空调更麻烦吗？绝对是。

Who knows though? If I’m still in this apartment next summer - maybe I’ll actually invest in a 3D printed mounting solution to bring the reliability up to 100%?不过谁知道呢？如果明年夏天我还住在这套公寓——也许我会投资一个3D打印的安装方案，把可靠性提升到100%。

## 🤔 Final Thoughts

Is it the most elegant piece of mechatronics engineering? Absolutely not.它是机电工程中最优雅的作品吗？绝对不是。

It’s jank as hell, held together with binder clips, cardboard padding, running slopcode firmware, and built entirely out of cheap parts from China.它非常破烂，靠活页夹、纸板填充物、运行slopcode固件，完全用中国廉价零件组装。

But who cares! It solves my hyper-niche problem Well Enough™️, cost me less than $15, and has provably saved me a non-trivial amount of money on my electricity bill.但谁在乎呢！它很好地解决了我那个极其细分的问题™️，花费不到15美元，而且确实帮我节省了不少电费。

So at the end of the day, I’m pretty happy with how it all turned out:) 所以说到底，我对最终的结果挺满意的:)

[^1]: oddly specific, I know 奇怪地具体，我知道

[^2]: The only real diff between these two modes is how fast the dispersion fan runs. Empirically, hi-cool *does* make the room cool a *bit* faster… at the expense of the fan being extra-loud. I usually stick to lo-cool. 这两种模式之间唯一的区别是色散风扇的转速。从经验上看，高酷 *确实* 会让房间凉快 *一些*......但这代价是风扇声音特别大。我通常选择低酷的风格。

[^3]: This works thanks to a nice property my unit has: when the target temp has been hit, and no more cooling is needed - the unit goes totally silent and inert (until the temp goes back up, and the unit needs to kick back in) 这得益于我设备的一个好特性：当目标温度达到且不再需要冷却时，设备会完全静音和惰性（直到温度回升，设备需要重新启动

[^4]: It was ~$7 for a pack that’ll last me for years to come 一包能用很多年，价格是~7美元