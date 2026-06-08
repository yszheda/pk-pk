---
title: Blog - Sum-product, unit distances, and number fields
source: https://www.erdosproblems.com/forum/thread/blog:6
author:
published: 2026-05-31
created: 2026-06-05
description:
tags:
  - ToRead
  - mathematics
  - research
  - number-theory
---
## Sum-product, unit distances, and number fields

By [Thomas Bloom](https://www.erdosproblems.com/forum/user/TFBloom)

In this blog post I will give my personal view on the recent counterexamples to the unit distance conjecture and sum-product conjecture over the reals (see [\[90\]](https://www.erdosproblems.com/90) and [\[52\]](https://www.erdosproblems.com/52) respectively). My goal is to sketch the constructions and try and give some intuition as to where they came from and why they work. My main target audience is the me-of-a-month-ago, who did not know much algebraic number theory, and who needs the relevant parts of the basic theory in this area explained, but wants to know exactly where the quantitative improvements come from. (I know a bit more algebraic number theory now, but still much less than I'd like!) My focus is on the combinatorial side, and I will stop with an appeal to the literature as soon as we need to do any serious number theory. (In particular I will not attempt to discuss even the statement, let alone the proof, of the [Golod-Shafarevich theorem](https://en.wikipedia.org/wiki/Golod%E2%80%93Shafarevich_theorem).)  
  
Any faults in this post are entirely my own, and if you are confused by any aspect of the proofs sketched here I encourage you to review the original sources. Comments and corrections are welcome in the comment section.  
  
The original OpenAI disproof of the unit distance conjecture can be read [here](https://cdn.openai.com/pdf/74c24085-19b0-4534-9c90-465b8e29ad73/unit-distance-proof.pdf), with a human-written companion paper [here](https://arxiv.org/abs/2605.20695) and an explicit (and improved) version of the argument by Sawin [here](https://arxiv.org/abs/2605.20579). The disproof of the sum-product paper by me, Sawin, Schildkraut, and Zhelezov, is [here](https://arxiv.org/html/2605.28781v1).  

### Warmup round

  
  
Consider the following natural statement in additive combinatorics: if and then how well can we bound above by ? In other words, for what constant can we say ? This is trivially true with , since and . Also obviously, weird things might happen for some small sets. But is it possible with arbitrarily close to - in other words, with , provided is large enough in terms of ? Initial experimentation suggests that it might be - the sum set tends to be smaller than the difference set, and in all the natural examples one might consider, anything that forces to be large also forces to be large.  
  
So maybe one could conjecture that . This is false, however, thanks to the 'tensor power trick'. First note that I never actually said where the lives - maybe you were thinking of a set of integers, but in additive combinatorics all of these concepts make sense in any abelian group, so we can also consider finite for arbitrarily large .  
  
How does this help? Well first find some example where is large compared to , just by fluke/law of small numbers. For example, if then has elements but has elements. So here where . So what, you might say - this is one particular finite , and I knew that small sets might be weird, so I covered this by saying 'exponent at most only for *sufficiently large* sets . The point is that we can blow up any fixed example like this to arbitrary large examples with the *same behaviour*: if we let then the sum and difference sets are also just the cartesian products, so and . This means that there exist arbitrarily large sets (in some abelian group) such thatThus the initial naive guess was wrong; the best exponent is by at least , and no restricting to 'sufficiently large sets' is going to save it.  
  
(If you're interested in this type of problem, and earlier examples of this kind of tensor power construction used in additive combinatorics, see e.g. [this page](https://teorth.github.io/optimizationproblems/constants/3a.html) or [\[GRH07\]](#bib-container0) by Gyarmati, Ruzsa, and Hennecart.)  
  
The constructions in both the sum-product and unit distance counterexamples have a similar flavour: one finds a 'trivial' construction, only winning by some constant factor, and then 'blowing up' this constant win by taking -dimensional versions, where . In the example above this was easy to do, since given any abelian group we can just form the direct product and everything scales as expected. In the sum-product and unit distance problems, however, we have to (a) construct sets in and respectively, not in some , and (b) make sure that not just addition but some additional operation (multiplication and distance respectively) also scales in some predictable way.  
  
The former is actually not that big of an issue, but the latter requires some serious work. Fortunately, all of this work was done a long time ago, by algebraic number theory.  
  

### Algebraic number theory refresher

  
  
I'll begin with an informal refresher of algebraic number theory, or at least that tiny fraction relevant to us. All of the below can be found in any graduate course on algebraic number theory. You may want to skip to the summary at the end of this section, and only read back if that is unfamiliar to you. One striking aspect is that, despite the central role played by primes, ideals, the class group, etc in algebraic number theory we don't need to discuss them at all, or even define them, to explain the constructions.  
  
A number field is a field of characteristic , and so contains , which has finite dimension over . This dimension is called the degree of . The finite dimension means that every is algebraic over - that is, it is the root of a polynomial with coefficients in . If there is such a polynomial which is monic then is called an algebraic integer. The algebraic integers in form a ring in , denoted . (Note that this contains the usual integers, since and every is the root of .) This is not obvious (e.g. it is not obvious, under our definition, that the sum of two integers is another integer) but it is one of the first results proved in any course on algebraic number theory.  
  
Since contains the algebraic closure of , we can view as a subset of - but, importantly, there is not a unique way of doing so. For example, if we let then forms a basis over , so every can be written as with . This looks like a well-defined element of (in fact of ), except when we recall that is not uniquely defined - there are two distinct roots of in : and . As soon as we fix which one of these we mean, we fix how is embedded into , but there is a choice here.  
  
In general, if has degree , there are exactly embeddings (field homomorphisms) of into . If all of these are actually maps into (like with ) then is called totally real. Any embedding which does not map into is called a complex embedding - these naturally form pairs via the conjugate map, since if is an embedding then is also an embedding (and if these must be different). Therefore we often write for the number of real embeddings and for the number of complex embeddings up to conjugation, so that .  
  
These embeddings give us a natural way to view geometrically as a high-degree geometric space. For convenience let's suppose that is totally real, so we only have to worry about (but everything below works for arbitrary number fields, you just have to be careful with conjugate embeddings, and some s become ). Then we have the natural map (sometimes called the Minkowski map)where are the embeddings of into . Importantly, just like forms a -dimensional lattice inside , the ring of integers forms a -dimensional lattice inside under this map.  
  
The covolume of a lattice is the volume of the parallelepiped formed by its basis vectors. It basically measures how tightly packed the lattice is - so has covolume , for example. Since is a lattice in , this is a natural parameter to associate with , and we call it the discriminant of (this is a lie - for good algebraic reasons it's actually defined to be the square of this covolume (and also perhaps with a factor of ) but this will be irrelevant for our purposes, so just think of as 'the covolume of the lattice').  
  
We will view with the norm , and will call this the 'size', so that the 'size' of is . Importantly, points in are -separated in this norm; this is best proved via the norm map , which takes algebraic integers to integers. If are two algebraic integers then is a non-zero algebraic integer, and soso there is at least one coordinate where and differ by at least .  
  
This separation means, via standard geometry of numbers, we understand how to count the size of the lattice intersected with various convex sets defined in terms of this norm - in particular, ifthen , where the hides losses of and the covolume of the lattice, which is .  
  
For our applications, we will also need another lattice. The integer ring is not, in general, a group under multiplication, since it does not contain multiplicative inverses. The unit group is the set of algebraic integers whose multiplicative inverse (which obviously exists somewhere in ) is also an algebraic integer.  
  
One might first think that there is not much interesting to say here - in , for example, there are only two units, and . In general, any root of unity is a unit - it is an algebraic integer, as a root of , and its multiplicative inverse is another root of unity. But there are only finitely many roots of unity in any number field, so is this it? No! One of the main sources (in my view) of the power and richness of number fields is that there are many more non-trivial units available; for example in the element is a unit, since both it and are roots of , and . But now all powers for are also distinct units, so there are infinitely many.  
  
Indeed, [Dirichlet's theorem](https://en.wikipedia.org/wiki/Dirichlet%27s_unit_theorem) states that (up to the roots of unity) the units form a group isomorphic to . Once again, we will assume that is totally real, so , and the unit group has rank .  
  
The unit group we can also view as a subset of , now via the embedding(We have taken the logarithmic map to ensure that multiplication, the natural map on units, translates to addition, the natural map on ). This means we can view as a subset of . One might first expect that it forms a lattice in , which is true, but not of full rank - it has rank , and in fact is contained inside the hyperplane given by , since any unit has norm , soso . This turns out to be the only constraint, however, and now otherwise we can treat as a lattice of full rank inside this hyperplane. It turns out that points in are still separated by some absolute constant in the norm, and so the sethas, as above, many elements, where the hides a loss of and the covolume of the unit lattice. (But note that when writing e.g. we are thinking of as an element of under the logarithmic embedding, not the Minkowski embedding.)  
  
Aha, but what is the covolume of the unit lattice? Definitely not anymore - this is a new parameter, called the regulator of . Fortunately for us, however, it turns out that they are closely related, in that . I do not know an elementary 'easy' proof of this, but it is a very classical fact, and follows e.g. from the [class number formula](https://en.wikipedia.org/wiki/Class_number_formula) (and there have been many papers written pinning down the precise quantitative relationship between parameters like , , and others such as the class number, but for us the crude bound will suffice).  
  
To summarise then:
- In a number field of degree , the ring of integers is a lattice of rank in , and , the set of with , grows like .
- The group of units is a lattice of rank in , and , the set of with , grows like .
- The embedding of is the logarithmic version of the embedding of , so in particular .
- All of the here are up to losses of .
- The above is assuming is totally real (has no complex embeddings), but similar statements hold for any number field, just taking extra care with complex conjugates.
I will now sketch how to use these facts to disprove first the sum-product conjecture (as was done recently by myself, Sawin, Schildkraut, and Zhelezov [\[BSSZ26\]](#bib-container0)), and then the unit distance conjecture.  
  

### The sum-product counterexample

  
  
The sum-product problem over the reals (see [\[52\]](https://www.erdosproblems.com/52)) states that, for any finite , either or must grow like . This is a natural conjecture, since it seems difficult for any set to have both additive and multiplicative structure, yet the known lower bounds were much weaker, of the shape for some small constant . The best-known construction previously, due to Erdős and Szemerédi [\[ErSz83\]](#bib-container0), had both sum and product set with size , and used the distribution of primes.  
  
Following our strategy above, let's try to make a more trivial improvement over . First note that a geometric progression has size and . On the other hand, an arithmetic progression has size and . It is a natural thought to try and combine these two to get the best of both worlds. One way is to take the product set . (I learnt this trick from the influential paper of Balog and Wooley [\[BaWo17\]](#bib-container0), which used this idea to disprove a stronger sum-product conjecture.) This has size , and since , the product set has sizeThe sum set is harder to bound - we do not have anything nice like for example. But we do have a height bound: everything in is an integer in the interval , and so has size , and soNow if we choose we get and then if we choose we get ; this already shows an arbitrary constant improvement over the trivial . The trouble is then that we cannot take arbitrarily large - indeed, we have . But our experience in the previous section shows this should not discourage us: if we can generalise this to a higher-dimensional version, then grows like for some constant , whileand with some other small constant this is at most for some constant , but now can get arbitrarily large.  
  
The appropriate high-dimensional analogue of an arithmetic progression is the ball in the additive lattice of , where is a totally real number field of degree . This is a subset of in (after an arbitrary embedding of ), but it has size , and additively behaves like a -dimensional box of integers with side length . Similarly, the high-dimensional analogue of a geometric progression is the multiplicative ball , which has size growing like .  
  
So now we take and , and . As above, we haveand, since is a set of integers from with size ,(There is one slight complication, which is to ensure that there is not a lot of cancellation between and so , which is handled by restricting to be a narrow annulus rather than a ball, and using the fact that units in are separated from by some absolute constant). Now choosing some large constant, and then some still larger constant, we haveas required, while grows like for some constant , so gets arbitrarily large provided we can choose with .  
  
What do we need from ? It needs to be a totally real number field, with degree , such that the discriminant (and hence also the regulator) is bounded above by . This bound is absolutely crucial; it controls the covolume of the lattices involved, and if the discriminant grows even slightly faster (e.g. like ) then we would e.g. have only , and hence would have to grow with , and the , so would have to grow even faster like , and then we have a saving of while the size of grows like , so this is not a power of .  
  
Fortunately, there are towers of such number fields, as proved by Martinet [\[Ma78\]](#bib-container0) in 1978, using the Golod-Shafarevich theorem, and so we are done.  
  
Finally, note that these sets get arbitrarily large, but only exist in number fields of degree . In particular they are far from subsets of the integers, which is the main setting which concerned Erdős (although he did also ask it for the reals). It remains wide open whether counterexamples exist to the sum-product conjecture in the integers, and I expect any proof or disproof to require much deeper number theory than is being used here.  
  

### The unit distance construction (via units)

  
  
The following is a sketch/summary of [the approach taken by Mythos](https://www-cdn.anthropic.com/files/4zrzovbb/website/ca35f196125c899a5ad11f011080202a652aef02.pdf), which uses units, rather than a prime which splits completely, and is (in my view) simpler than [the original OpenAI approach](https://cdn.openai.com/pdf/74c24085-19b0-4534-9c90-465b8e29ad73/unit-distance-proof.pdf). (For some reason the Mythos paper chooses a worse parameter choice than below, but this is easily remedied, and so both the OpenAI and Mythos proofs give a lower bound like for some constant for the number of unit distances.)  
  
First let's review the problem (see [\[90\]](https://www.erdosproblems.com/90)) and Erdős' original construction. We want to find a set with points such that the number of unit distance pairs - that is, the number of such that , where is the usual Euclidean distance - is as large as possible.  
  
Obviously this count is at most , and an easy double counting argument improves this to . Spencer, Szemerédi, and Trotter [\[SST84\]](#bib-container0) improved this to . For lower bounds, is easily achieved, since we could take one point and then points on the unit circle centred at . Erdős [\[Er46b\]](#bib-container0) improved this to by considering in (which we can view as a subset of , and hence of ).  
  
We will not describe the number-theoretic reasons behind the factor here, since they turn out to be irrelevant for the construction. As with sum-products, the idea is to instead identify a way to get a small *constant* improvement over the trivial lower bound, and then 'blow it up' by taking number fields of large degree.  
  
Consider the ring of integers in . This has degree over , and we can view elements of as where , which gives a natural way to view them as a subset of , mapping it to the point . Let be the set corresponding to those with , so that . What does it mean for two elements in to be distance apart? Well if , where , say, then we need . There are four solutions to this, and so we'd like to take the unit distance pairs to be those like where . There is one slight wrinkle, which is that to ensure that we actually need to be in the slightly smaller ball . But with this restriction, we can take any such , and hence the number of unit distance pairs in , which has size , is at leastwhich is (as ) about double the trivial lower bound of we described earlier. This still feels pretty trivial though, so it is surprising (and perhaps this explains why it had been missed for so long) that doing an analogous construction, but now instead of fixing the degree of the number field and taking , we take constant and let the degree of the number field , is enough to get a lower bound like for some constant .  
  
Now for the general construction. Let be a number field of degree - we do *not* want it to be totally real, but we do want at least one real embedding, so (where, as usual, is a root of ). An example of such a number field is , since we can either take the real cubic root of , or one of the two conjugate complex roots. Suppose has real embeddings and complex embeddings, so . Let , which is a quadratic extension of , so has degree over .  
  
Let (where denotes the usual conjugation of over ). This is a subgroup of the full unit group , and one can check (via the usual logarithmic embedding, since anything in the kernel must be a root of unity, and there are only finitely many such in ) that in fact is a full rank lattice in . Since , we can write any as where - and, remembering that has at least one real embedding, we can view , so that if then . This also means we can identify as a subset of . Furthermore, if is the set of those which (when writing , so viewing as a subset of ) have height at most , then .  
  
(To continue with our earlier example of , if and , then as before, but also and all its powers are elements of , sinceso modulo roots of unit is isomorphic to .)  
  
Now let be the set of algebraic integers in with size at most (recalling this means the maximum absolute value under *all* embeddings) so that (as above) . We can view as a subset of (in fact even a subset of ) via an arbitrary real embedding of . We claim the following
- If and then .
- .
- .
The first part is immediate from the definition of , recalling that the size we measured under the logarithmic map, so in terms of the additive lattice elements in have size at most . (There is one annoying wrinkle, which is that if then and don't need to be algebraic integers, but and are since e.g. , so this can be fixed by just dilating by everywhere, losing only a constant factor.) The second and third points are because of the geometry of numbers estimates and viewing both and as lattices intersected with balls in the appropriate space. So now, if , and , then we have a set of size , where the number of unit distance pairs isIf , say, then this iswhere is some constant depending on the discriminant and regulator of and - but if these are all bounded above by then is an absolute constant. Therefore if we choose some large constant depending on , this is at least , and if we now choose some even larger constant this is at least , say. But (since and are both constants) the set grows like for some constant , so this improvement is actually at least for some absolute constant as required!  
  
(Note that this construction has the nice advantage that the point set is actually a cartesian product, just like the original Erdős construction. You can view an example of this construction, with and [here](#) where the points which differ from the origin by an element of are marked in red. An interactive version is available [here](https://www.erdosproblems.com/forum/unit-grid).)  
  
This is the entire proof (modulo details), with the exception that, as with the sum-product case, we have not justified the existence of the field . Remember that we need these fields to have degree , and to have discriminant (and regulator etc) bounded above by , and similarly for , and also should have , the number of complex embeddings, satisfying . The existence of such a tower is by no means obvious - but, once again thanks to the Golod-Shafarevich theorem, such a tower does exist (and this can be deduced from Martinet's tower construction, but is presumably also present in other places in the literature), and we are happy.  
  

### Conclusion

  
  
Applying the Golod-Shafarevich theorem to construct towers of number fields with the desired properties is not new - I'm sure there were many number theorists from the 1980s onwards who, if you asked them to prove the existence of such a tower, could have done so without much difficulty. The exact statement required may be hard to extract from existing literature, but this is just because before these kind of constructions there was little reason to actually prove such a statement, with no applications in sight.  
  
The real novelty is in noting that the existence of such towers has interesting combinatorial consequences; this passage from the existence of the towers to combinatorics uses only relatively 'shallow' parts of algebraic number theory. Why were these constructions missed for so long? One explanation is that we were being *too* clever; in both the sum-product problem and Erdős' unit distance construction, we knew how to use non-trivial amounts of number theory to get non-trivial savings. No doubt many people had tried to work out the analogues of these number-theoretic savings for other number fields - and indeed this is possible, but it doesn't lead to greater savings. What does work is to take a much more 'trivial' construction, keeping everything constant except for the degree, and blow that up instead.  
  
The circle of ideas described above originated (at least in connection with additive combinatorics - there were related ideas already employed in the world of lattices and coding theory I believe) with [OpenAI's disproof](https://openai.com/index/model-disproves-discrete-geometry-conjecture/) of the unit distance conjecture (although Anthropic claims that the Mythos proof sketched above was obtained independently). How did the AI discover this? Reading the (edited) [chain of thought](https://cdn.openai.com/pdf/1625eff6-5ac1-40d8-b1db-5d5cf925de8b/unit-distance-cot.pdf) released by OpenAI is illuminating; it very quickly hit on the idea of using number fields of high degree, which is natural given Erdős' original construction, but it did not make it work immediately. Indeed its first few attempts failed, and then it switched to thinking about upper bounds, and then back to constructions, and so on. It was very keen to reduce something to known literature - as one might expect about an artificial intelligence which has every paper and textbook at its fingertips to search. There are many instances in its chain of thought of 'maybe if one had this...ah, but the literature says this, which is weaker, so instead...'.  
  
This is, of course, similar to how a lot of human research proceeds; we think about a problem via different angles and hope to reduce it to something which is already solved. Indeed, there are many close possible worlds in which a human found exactly this construction via a very similar chain of thought. But, for whatever reason, this did not happen. One striking aspect is how many times it ran into 'good reasons' why its current idea to create a counterexample must fail; most humans would have been discouraged by this, and given up the search for a counterexample, especially since they did not expect to find one anyway. Yet the AI persisted, for unclear reasons (perhaps because it has hidden guidance to favour counterexamples over proofs, or to not give up but rather alter its approach, but this is pure speculation, and I have no insider knowledge about how the OpenAI model works).  
  
We are unable to search the literature with the speed and patience of AI - and in a way, this is a strength of human research. Many great advances have come about through ignorance or laziness: "I don't know if this is already known, and searching is a pain, so let me try and work out my own way to do it..." or "This is known via this huge amount of theory, but I don't want to learn all that, maybe there's an elementary way...". Very little research is creating something completely new: it is usually some combination of synthesis and simplification of existing ideas. The ideas presented above are already substantially simpler than the raw proof first generated by AI, and no doubt there will be many further simplifications and strengthenings in the months to come.  
  
Finally, as has been pointed out many times by now, we hear much more about the successes of AI than its failures. By this point all problems on this site have been attempted many times by a range of different AI systems, including (I assume) by internal models with a large amount of resources. Given this, it is actually surprising how *few* of the problems on this site have been solved in the last few months, since the amount of attention they have received recently (from both humans and AI) is much more than many of them have ever received before.  
  
For every success story like the unit distance counterexample, there are likely thousands of pages generated for each of these problems, which have led nowhere. This may be because the AI keeps trying and failing, never giving up but never making progress, like a Sisyphus with slippery hands, or, worse, where some subtle hallucinations crept in which were then built upon and magnified a thousandfold, resulting in the AI confidently declaring success atop a mountain of nonsense, with the boulder lying untouched on the ground below.

- Thanks for the great and insightful blog post!  
	  
	On the last imagery about AI pushing on with nonsense when it has made a single mistake, I feel like you would benefit from learning how reasoning models work. Before reasoning models, this is touted as the number one reason, e.g. by Yann LeCun, why LLMs \*cannot\* reliably reason no matter what. Note that we're talking about much easier problems here, not high-level mathematics. It then turns out that you can train the model to self-correct so that even if a mistake is made, it can recover. In any case, if the notion is that any mistake that creeps in is likely to derail the AI, this is not true since long ago and is exactly the reason current models accomplish so much.
	- Of course it is clear that current reasoning models can accomplish a lot without hallucinations (the unit distance construction should be proof enough of that!) But this does not mean that they always do so, and I still see some hallucinations in what people send me (perhaps because they are using older models, or maybe are unlucky).  
		  
		I wrote the final paragraph mainly to push back against the idea (which I have heard from some recently) that since the unit distance chain of thought took 125 pages, maybe every problem could be solved if they just left their AI running long enough, and spent enough tokens. I think this is wrong (and wasteful), and it is much better used together with an expert human's guidance, to spot any 'getting off the rails' early.

**All comments are the responsibility of the user. Comments appearing on this page are not verified for correctness. Please keep posts mathematical and on topic.**

[Log in](https://www.erdosproblems.com/forum/login?next=%2Fforum%2Fthread%2Fblog%3A6) to add a comment.

<iframe src="chrome-extension://cnjifjpddelmedmihgijeibhnjfabmlf/side-panel.html?context=iframe"></iframe>