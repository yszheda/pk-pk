---
title: The Four Programming Questions from My 1994 Microsoft Internship Interview
source: https://www.computerenhance.com/p/the-four-programming-questions-from
author:
  - "[[Casey Muratori]]"
published: 2023-08-02
created: 2026-06-02
description: Interestingly enough, at least two of them were specifically about performance!
tags:
  - ToRead
  - microsoft
  - interview
  - algorithms
  - career
  - programming-history
  - tech-companies
  - internship
---
*There are no [Performance-Aware Programming](https://www.computerenhance.com/p/table-of-contents) lessons this week because it is Summer Internship 1994 Week here on Computer, Enhance! This week will feature five posts about the programming questions I was asked when I interviewed for a Microsoft summer internship way, way back in 1994. Normally scheduled lessons will resume next week.*

![](https://www.youtube.com/watch?v=DS7ygFv84yk)

Long, long, *long* ago — I believe it was in 1994, but it could have been 1993 — I had to interview at Microsoft for a summer intern position. I interviewed with four separate people, and each one asked me a classic Microsoft interview “programming question”.

Of course, there wasn’t much of an internet back then, so I had *no idea* that was going to happen. I had no idea what a classic Microsoft programming question even was, or that they would be asking me them in the interviews.

What’s more, being young and inexperienced at the time, I had actually never had anyone ask me to solve a programming question on the spot before. It was a brand new experience for me, and although I would never recommend this style of question as an interview today, I can tell you that as a teenager it was a *tremendous amount of fun*.

It was so much fun, in fact, that I remember *all four questions* to this day.

This week, I’d like to share the four questions with you, talk about the answers that were “correct” at the time, and perhaps go a little further and ask what the “correct” answers might be today given the evolution of desktop computing. Each day this week, I’ll post an answer to one of the questions until we’ve completed all four.

For now, let’s look at the questions themselves…

### Question #1: Rectangle Copy

I believe the idea behind the interview process was that the programming questions would get *harder* as you went through the day. So the first question was the easiest: write C code that copies a rectangle from one buffer to another.

I do not remember precisely which parameterization they gave me to do. Because this question was easy for me even at the time, my memory of it is less specific — but it was *something* like this:

```markup
void CopyRect(char *BufferA, int PitchA, char *BufferB, int PitchB, 
              int FromMinX, int FromMinY, int FromMaxX, int FromMaxY,
              int ToMinX, int ToMinY)
{
    /* Fill this in */
}
```

In other words, given buffers A and B, a “From” rectangle in buffer A, and a “To” position in buffer B, write the code that copies the elements from A to B. Pixels were often only 8 bits at that time, so I believe the elements were 8-bits in this question.

As you can see, this is a pretty easy question, at least for anyone who knows C/C++. It might be a bit scarier for people who aren’t used to working with pointers, but in general, the idea of a rectangle copy is fairly straightforward. I was not asked to do anything specific with regards to the performance, either, so it was really just designed to see if I understood this kind of thing *at all.*

### Question #2: String Copy

Weirdly, the second person who interviewed me asked a very similar question, but one that was seemingly *easier* than the first question. This was the only one that might be considered “out of sequence”, since questions 3 and 4 ramped up in difficulty quite a bit.

Question number two was a *string* copy. Generally speaking, if you can write a rectangle copy, you can write a string copy, but, I guess they had their reasons for asking this.

Specifically, the strings were ASCII-Z, which means one byte per element, null-terminated — something like this:

```markup
void CopyString(char *From, char *To)
{
    /* Fill this in */
}
```

This is a strange question for a number of reasons, not the least of which being the modifications that they asked me to make after I (successfully) wrote it out. Of the four interviews, in retrospect, this is the only one where I’m left wondering if maybe the interviewer didn’t really know their stuff that well… it’s hard to say, but, as I’ll describe in more detail when I answer this question, there were some things in this interview that, with the benefit of all the experience I have now, I look back on and scratch my head a little bit.

### Question #3: Flood Fill Detection

The third question was by far the most interesting of the four, and quite a bit more difficult than the first two. It’s still not *actually* difficult, but given my relative inexperience with problems like it at the time, I was *not* able to solve this one on the spot. But it’s a fantastic little problem just the same!

The question comes from an implementation of a flood fill algorithm the interviewer had written for a Microsoft product. I forget *which* product, but I think it was some flavor of BASIC. It was for the graphics library of *some* language product like this, because I remember the interviewer specifically saying the solution “allowed us to beat Borland’s performance”.

For folks who don’t know what a “flood fill” is, it’s like the paint bucket in Photoshop: given an image and a particular X,Y coordinate in that image, you want to find all the connected pixels of that color and *change* their color to something else. While this is not really a feature people think much about today (you do not, for example, see a lot of “how to implement a flood fill using OpenGL” posts on the internet, etc.), it was a *very common* operation in hobbyist graphics libraries of the era. My recollection is that many BASICs I encountered in the early days all had flood fills.

For this question, they did not ask me to implement an actual flood fill. Rather, they asked me to implement the code that *detected* whether a particular byte *matched* a particular color.

Now normally this would not be much of a question, because that’s just an equals operator — *if* each byte represents a pixel. But the catch in this question is that this was for [four-color CGA mode](https://en.wikipedia.org/wiki/Color_Graphics_Adapter), where pixels occupy *only two bits each.*

This means that each byte contains *four* pixels packed together, not *one*. So you cannot just use a simple comparison (at least not in those days, since SIMD instructions did not exist on home computers). So the question becomes, what is the most efficient way to test to see if *any* of the four pixels in a byte contains a given color?

In other words:

```markup
int ContainsColor(char unsigned Pixel, char unsigned Color)
{
    /* Fill in the computation of true (non-zero) or false (zero) here */
}
```

Additionally, I was allowed to store Color however I wanted — so if I needed some precomputation, I was allowed to bake it in there.

This was my favorite question of the four by far, even though I couldn’t do it. In retrospect, it’s *even more* my favorite now, because it’s a classic example of doing SIMD-style programming without any SIMD instructions. It was the first time I’d ever seen anything quite like that, but of course, it was not the last.

### Question #4: Outlining A Circle

The fourth and final question was somewhat ridiculous. While there’s nothing wrong with asking someone to write the code to outline a circle, it’s almost entirely an *experience* question. Either you already know the algorithm that you’d use for this sort of thing on 1990s desktop hardware, or you don’t. There’s no chance you can figure it out on the spot, because the original discovery of the algorithm itself was *pretty darn spectacular.*

So, question number four is a fine question if you want to know how well-read the candidate is. If not, it’s mostly useless. Needless to say, I *didn’t* get this one in the interview, because I’d never seen the algorithm (or anything like it). I did *eventually* write the code on the whiteboard for it, but the interviewer had to hold my hand through most of it.

Anyway, the question takes the following form:

```markup
void Plot(int X, int Y); /* This is given as already existing */

void OutlineCircle(int Cx, int Cy, int R)
{
    /* Fill in code here that calls Plot once for each pixel on the outline */
}
```

You may be wondering why everything is an integer instead of a floating point number. Well, it was 1994, and floats *still weren’t fast enough* on desktop computers to be used for most things. Integer was still preferred most of the time for graphics. Things were moving toward float, to be sure, but the era of “most graphics happens in float” had not yet arrived.

### Answers

Those are the four questions I was asked in my internship interview. I will be giving my answers — both then, and now — in the next four posts. But before you read those, give them a shot yourself! They were a lot of fun for me at the time, and I think you might enjoy them too. If you’re an experienced programmer, you already know how to do all of them, but if you’re like me, you will still enjoy rederiving the last two from scratch!

And of course, if you’re not already a Computer Enhance subscriber and would like to sign up to haver our free or paid posts delivered to your inbox, you can always pick a subscription level here: