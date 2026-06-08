---
title: "Cloning a Sennheiser BA2015 battery pack"
source: "https://blog.brixit.nl/cloning-a-sennheiser-ba2015-accu-pack/"
author:
  - "[[Martijn Braam]]"
published: 2026-06-05
created: 2026-06-08
description: "I generally avoid messing with Li-ion battery packs, but these are both Ni-mh  and expensive."
tags:
  - "ToRead"
---
One of the annoying things about electronics is that so many companies must make their own incompatible battery packs. For many products these are expensive but at some level still reasonable, the battery pack contains the protection circuitry and some guaranteed high quality Li-ion cells.电子产品有个令人头疼的地方，就是众多厂商都得生产各自不兼容的电池组。对许多产品来说，这类电池组成本高昂，但在某种程度上仍算合理，因为其中包含了保护电路以及一些品质有保障的优质锂离子电池芯。

This is not one of those devices. A significant portions of all wireless microphones by Sennheiser use the same BA2015 battery pack. These devices can also take two regular AA batteries but when using those it won't charge them in the dock. So how much would you pay for a bit of plastic around two standard Ni-mh AA batteries?这可不是那种设备。森海塞尔所有无线麦克风中有很大一部分都使用同款的 BA2015 电池组。这些设备也可以使用两节普通 AA 电池，但使用这种电池时，充电底座无法为其充电。那么，给两节标准镍氢 AA 电池外面包一层塑料，你愿意为此付多少钱呢？

![](https://blog.brixit.nl/image/w1000/static//static/files/blog.brixit.nl/1780605907/thomann-ba2015.PNG)

This is one of the cheaper legit ones. The smaller changes ask $80-$100 for them 这是比较便宜的正品之一。小商家要价80到100美元

I think this is a top contender for most expensive package of AA batteries you can get, and I have several microphones that need to have these replaced.我觉得这绝对是你能买到的最贵的AA电池套装了，而且我有好几支麦克风都需要换这种电池。

From the official [Sennheiser page](https://www.sennheiser.com/en-nl/catalog/products/wireless-systems/ba-2015/ba-2015-009950) for these batteries:来自这些电池的官方 [森海塞尔页面](https://www.sennheiser.com/en-nl/catalog/products/wireless-systems/ba-2015/ba-2015-009950) ：

> It contains two rechargeable NiMH cells and is inserted into the battery compartment instead of two standard AA cells. The battery pack features an integrated sensor which indicates the battery status, monitors temperature during recharging and avoids the charging of non-rechargeable batteries.它包含两节可充电镍氢电池，需替代两节标准AA电池装入电池仓。该电池组配备集成传感器，可显示电池状态、监控充电过程中的温度，并避免对不可充电电池进行充电。

The integrated sensor that gives this battery pack all these features is in fact a $0.02 NTC temperature sensor, most of the functionality they list here is actually the battery management chip that's in the microphone, not in the battery pack.赋予这个电池组所有这些特性的集成传感器实际上是一个价值0.02美元的NTC温度传感器，它们在这里列出的大部分功能实际上是麦克风中的电池管理芯片所具备的，而非电池组本身的功能。

The only real reason for these things to exist is to avoid the charging of non-rechargeable batteries since you can put Alkaline AA batteries in this microphone and run it for a few hours, so this avoids that edge case of someone both owning the super expensive charging docks but removing the original battery and putting cheap non-rechargable batteries in there.这些设计存在的唯一实际原因是为了避免不可充电电池的充电问题——你可以在这款麦克风里装入AA碱性电池并使用数小时，因此这就规避了一种极端情况：有人既配备了超昂贵的充电底座，却又取下原装电池，装入廉价的不可充电电池。

I get that might be a problem and I can't think of a better solution either, but that doesn't mean you have to ask this much money for this. It seems like third party battery manufacturers agree. This is why it's possible to get way cheaper replacement parts for it.我知道这可能是个问题，我也想不出更好的解决办法，但这并不意味着你就要为此收这么多钱。第三方电池制造商似乎也认同这一点，这就是为什么能买到便宜得多的替换配件。

![](https://blog.brixit.nl/image/w1000/static//static/files/blog.brixit.nl/1780606403/image.png)

Third party replacement battery pack from the home brand of a dutch webshop 荷兰网店自有品牌的第三方替换电池组

This is a lot better already! And a reasonable person would these in the microphones and be happy. But I'm not a reasonable person.这已经好多了！一个通情达理的人看到这些麦克风会很高兴。但我不是个通情达理的人。

These packs just contain two cells made by Panasonic that you can just buy. If you go really cheap they can be $.95 per cell, for matching the specs of the original Sennheiser pack it's around $2.50 per cell. The NTC temperature sensor can be as cheap as $0.02 for the SMT part, but to be easier to construct and match the original a more expensive through hole part can be used for $0.20 instead. So for making 5 of these battery packs:这些电池组仅包含两节由松下生产的电池，你可以单独购买。如果追求极致低价，单节电池价格可低至0.95美元；而要匹配森海塞尔原装电池组的规格，单节电池价格则约为2.5美元。NTC温度传感器方面，表面贴装（SMT）型的价格低至0.02美元，不过为了更便于组装且与原装产品匹配，也可以选用价格稍高的通孔型元件，单价为0.20美元。因此，制作5组这样的电池组：

![](https://blog.brixit.nl/image/w1000/static//static/files/blog.brixit.nl/1780607270/image.png)

Prices from Mouser, it can be a lot cheaper if you use a ship that doesn't have as much markup. 莫尔斯电子的价格方面，如果选择加价没那么高的渠道，价格会便宜不少。

## Building a battery pack 制作电池组

The batteries in my microphones have already been replaced by the third party ones, so that means I have some old legit Sennheiser batteries to tear down to make a proper copy.我的麦克风电池已经被第三方电池替换了，这意味着我还有一些原装的森海塞尔旧电池可以拆解，用来制作一个真正的复刻品。

The first thing I did before breaking open the battery pack was make a rough model of the battery in OpenSCAD while the original still had accurate dimensions.在拆开电池组之前，我做的第一件事是在电池原始尺寸还准确的时候，用 OpenSCAD 制作了一个电池的简易模型。

![](https://blog.brixit.nl/image/w1000/static//static/files/blog.brixit.nl/1780607838/IMG_20260604_192148.jpg)

3D printed test for outer dimensions and the original 针对外形尺寸和原版的3D打印测试

This is a pretty simple design but it's not very solid because the walls have to be quite thin to make it fit both the batteries and fit the original case size.这个设计相当简单，但不够牢固，因为为了同时容纳电池并符合原机壳的尺寸，壁板必须做得相当薄。

After this I opened it up, this had to be done destructively because it seems like the plastic parts are friction welded closed. The cells themselves are also glued in the plastic case.之后我把它拆开了，这么做必须得破坏结构，因为这些塑料部件看起来是摩擦焊封死的。电池单体也用胶水固定在塑料外壳里。

![](https://blog.brixit.nl/image/w1000/static//static/files/blog.brixit.nl/1780607953/20260604_0002.jpg)

This is the rear of the original battery pack, nicely showing which cells I should order to replace the ones inside. Both cells are in the same direction and the markings here show which contact is positive and negative.这是原电池组的背面，清晰地标出了我应该订购哪些电芯来更换内部的电芯。两个电芯的朝向一致，此处的标识标明了哪个触点为正极、哪个为负极。

![](https://blog.brixit.nl/image/w1000/static//static/files/blog.brixit.nl/1780608054/20260604_0004.jpg)

The negative terminal is just a hole in the case that directly exposes the negative terminal of one of the cells 负极只是外壳上的一个孔，直接露出了其中一节电池的负极

![](https://blog.brixit.nl/image/w1000/static//static/files/blog.brixit.nl/1780608098/20260604_0005.jpg)

The positive terminal is the button top of the other cell in the pack. To make this work these are actually two different cells, one is flat top so the cell doesn't poke out and the other is a button top. In my design I'm using two flat-top cells instead and the button contact is actually a tiny magnet.正极是电池组中另一节电池顶部的凸起触点。要实现这一设计，实际上用了两节不同的电池，一节是平顶的，这样电池就不会凸出来，另一节是带凸起触点的。在我的设计中，我改用了两节平顶电池，而凸起触点则是一个微型磁铁。

Now for the magic part that makes the battery pack work:现在来说明让电池组正常工作的关键部分：

![](https://blog.brixit.nl/image/w1000/static//static/files/blog.brixit.nl/1780608220/20260604_0003.jpg)

There is a third contact on the top of the pack. This is used to detect if you have a battery pack inserted or two seperate AA batteries that might not be chargeable. If this contact is blocked by a piece of tape the microphone will act exactly like two regular batteries are inserted and the charging dock will do the whole blinking red led thing to indicate it cannot charge.电池顶部有第三个触点。该触点用于检测你插入的是电池组，还是可能无法充电的两节独立AA电池。如果这个触点被胶带遮挡，麦克风会完全按照插入两节普通电池的状态工作，充电底座则会出现红灯闪烁的情况，以此提示无法进行充电。

With a bit of work I managed to destroy the plastic case enough to take it apart and break the glue layer.我费了点劲，把塑料外壳弄坏了一些，终于把它拆开，还弄破了胶层。

![](https://blog.brixit.nl/image/w1000/static//static/files/blog.brixit.nl/1780608390/20260604_0011.jpg)

The two cells are welded together with a metal strip to connect the positive and negatives and the third contact just connects to a NTC with the other terminal soldered to the side of one of the cells by removing a chunk of the plastic outer layer of that cell.两个电池通过一条金属带焊接在一起，以连接正负极；第三个触点仅连接至一个NTC，其另一端通过去除该电池外层塑料的一部分，焊接到其中一个电池的侧面。

![](https://blog.brixit.nl/image/w1000/static//static/files/blog.brixit.nl/1780608522/20260604_0009.jpg)

The NTC also seems to be a tiny SMT NTC in a plastic blob that has wires hanging off it instead of being one of the more regular through-hole NTC resistors. I have not managed to find a part that looks exactly like this. But after measuring it it looks like this is a 10kΩ NTC with a beta value of around 3200k.这个NTC看起来也像是一个塑料封装的微型SMT NTC，它引出了导线，而不是那种更常见的直插式NTC电阻。我一直没能找到外观和它完全一样的元件。但经过测量后发现，这应该是一个10千欧的NTC，其B值约为3200开。

## Case design 外壳设计

Compared to the initial draft I made of the case before tearing down the original I have decided to rotate the print by 90 degrees to print it on its side. This means the very thin tabs that hold the ends of the battery won't break off as easily because there aren't layers aligned with that stress line anymore to break off. It also makes it possible to print more of the features without any supports.与我最初制作的案例初稿相比，在拆解原模型之前，我决定将打印方向旋转90度，让模型侧立打印。这意味着固定电池两端的极细凸耳不会那么容易断裂，因为不再有与受力线对齐的层体可以脱落。这也让我们能够打印更多的结构特征而无需任何支撑。

![](https://blog.brixit.nl/image/w1000/static//static/files/blog.brixit.nl/1780680134/20260605_0007.jpg)

A few small details have changed here like the tab on the positive terminal now has a 45 degree chamfer on it to print it while it hangs mid air. The only supported part of the case is now the tab that sits on the top of the pack that has the temperature sensor contact. This prints very nicely though with a tree support.这里有几个小细节做了调整，比如正极端子上的凸耳现在做了45度倒角，这样在悬空打印时就能成型。外壳现在唯一的支撑点是位于电池组顶部、带有温度传感器触点的凸耳。不过用树状支撑打印这个部分的效果非常好。

![](https://blog.brixit.nl/image/w1000/static//static/files/blog.brixit.nl/1780680206/20260605_0003.jpg)

Another important part is the electrical connection. I made a hole through the case that gives enough room to fit a bent paperclip through the length of the case which connects the two cells together. With this all together this produces a reasonably solid battery pack that together with the microphone case makes a solid connection. I have included the OpenSCAD code for the case at the bottom of this post.另一个重要部分是电气连接。我在外壳上钻了一个孔，留出足够的空间让一个弯曲的回形针穿过外壳的长度，从而将两个电池单元连接在一起。将这些部件组装起来后，就能得到一个相当牢固的电池组，它与麦克风外壳配合可实现稳固的连接。我已在本文末尾附上了外壳的 OpenSCAD 代码。

## Conclusion 结论

It is absolutely possible to do this, but the resulting battery pack won't be nearly as solid as even the third party packs that are available. With the amount of time required to fiddle with the connection paperclip and winding the temperature sensor leads around a tiny plastic tab it is probably not worth it to print your batteries.这样做是完全可行的，但最终制成的电池组甚至远不如市面上第三方电池组的质量可靠。要摆弄连接回形针，还要把温度传感器的导线绕在小小的塑料凸片上，所花的时间实在太多，因此打印电池很可能并不划算。

It is very annoying though that the official packs are so ridiculously expensive. Sennheiser is not a printer company, the microphones are not subsidized by the massive cost of a battery and if it cost Sennheiser really anywhere near this to produce them they should have a word with their vendor...不过官方套装的价格高得离谱，这一点实在让人恼火。森海塞尔不是打印机厂商，麦克风的成本也不会因为电池而大幅增加。如果森海塞尔生产麦克风的成本真的接近这个价格，那他们真该和供应商好好谈谈了……

Clearly the third part cells prove it can be economical to not rip off your customer base.显然第三方电池单元证明了不宰客是可以实现经济的。

### Code 代码

```
outer_x=51;
outer_y=28;
outer_z=15;
channel=0.5;

module cell(terminal=0, terminal_r=2.5) {
    color("orange")
        cylinder(h=49.5, r=14/2, $fn=90);
    
    color("orange")
        translate([0, 0.3, 0])
        cylinder(h=49.5, r=14/2, $fn=90);

    
    if(terminal>0) {
        translate([0, 0, -terminal+0.01])
        cylinder(h=terminal, r=terminal_r, $fn=90);
        translate([0, 0.4, -terminal+0.01])
            cylinder(h=terminal, r=terminal_r, $fn=90);
    }
}

module triangle(short_edge, long_edge, length) {
    linear_extrude(length) {
        polygon([
            [0, 0],
            [long_edge, 0],
            [0, short_edge]
        ]);
    }
}

difference() {
    union() {
        cube([outer_x, outer_y, outer_z]);
        
        // Positive terminal tab
        translate([-2, outer_y-4-6, 0])
        cube([2, 6, 1]);
    }
    
    // Make positive terminal printable from side
    translate([-2, outer_y-4-6, 0])
    rotate([0, 0, 0])
        triangle(2,2, outer_x+2);

    
    // Main cutout for space in the front
    difference() {
        translate([1, -0.5, 6])
            cube([outer_x-2, outer_y+1, 10]);
        
        // Connection tab for temperature sensor
        translate([outer_x-5, outer_y/2-1.5, outer_z-2])
            cube([5, 3, 2]);
        translate([outer_x-5-2, outer_y/2-2, outer_z-2])
            cube([2, 4, 2]);
    }
        
    // Bottom chamfer 1
    translate([-1, outer_y, 0])
    rotate([-90, 270, -90])
        triangle(2,3, outer_x+2);
    
    // Bottom chamfer 2
    translate([-1, 0, 0])
    rotate([90, 0, 90])
        triangle(3,8, outer_x+2);

    // Cell 1 (negative terminal)
    translate([-0.75+outer_x, 7, 8])
    rotate([180, 90, 0])
        cell(terminal=10, terminal_r=4);
    
    // Cell 2 (positive terminal)
    translate([0.75, 7+14, 8])
    rotate([0, 90, 0])
        cell(terminal=10);

    // Channel for the cell cross-connection wire
    translate([0.75,outer_y/2+3,1.5])
        cube([outer_x-1.5, channel+0.2, 10]);
    translate([1.4+(channel/2), outer_y/2+3, 1.8])
    rotate([75, 0, 0])
        cylinder(h=12, r=channel/2+0.6, $fn=90);
    translate([1.8+(channel/2), outer_y/2+3, 1.5])
        cylinder(h=12, r=channel/2+1, $fn=90);

}
outer_x=51;outer_y=28;outer_z=15;channel=0.5;模块 cell(终端=0, 终端半径=2.5) {颜色("橙色")圆柱体(高=49.5, 半径=14/2, $fn=90);颜色("橙色")平移([0, 0.3, 0])圆柱体(高=49.5, 半径=14/2, $fn=90);如果(终端>0) {平移([0, 0, -终端+0.01])圆柱体(高=终端, 半径=终端半径, $fn=90);平移([0, 0.4, -终端+0.01])圆柱体(高=终端, 半径=终端半径, $fn=90);}}模块 三角形(短边, 长边, 长度) {线性拉伸(长度) {多边形([[0, 0],[长边, 0],[0, 短边]]);}}差集() {并集() {立方体([outer_x, outer_y, outer_z]);// 正极接线片平移([-2, outer_y-4-6, 0])立方体([2, 6, 1]);}// 使正极可从侧面打印平移([-2, outer_y-4-6, 0])旋转([0, 0, 0])三角形(2,2, outer_x+2);// 正面空间主挖空差集() {平移([1, -0.5, 6])立方体([outer_x-2, outer_y+1, 10]);// 温度传感器连接片平移([outer_x-5, outer_y/2-1.5, outer_z-2])立方体([5, 3, 2]);平移([outer_x-5-2, outer_y/2-2, outer_z-2])立方体([2, 4, 2]);}// 底部倒角1平移([-1, outer_y, 0])旋转([-90, 270, -90])三角形(2,3, outer_x+2);// 底部倒角2平移([-1, 0, 0])旋转([90, 0, 90])三角形(3,8, outer_x+2);// 电芯1（负极）平移([-0.75+outer_x, 7, 8])旋转([180, 90, 0])cell(终端=10, 终端半径=4);// 电芯2（正极）平移([0.75, 7+14, 8])旋转([0, 90, 0])cell(终端=10);// 电芯跨接线通道平移([0.75,outer_y/2+3,1.5])立方体([outer_x-1.5, channel+0.2, 10]);平移([1.4+(channel/2), outer_y/2+3, 1.8])旋转([75, 0, 0])圆柱体(高=12, 半径=channel/2+0.6, $fn=90);平移([1.8+(channel/2), outer_y/2+3, 1.5])圆柱体(高=12, 半径=channel/2+1, $fn=90);}
```