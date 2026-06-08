---
title: "Beautiful Kernel Functions and How to See Them"
source: "https://kelvinpaschal.com/blog/kernel-functions/"
author:
  - "[[Kelvin Paschal Idanwekhai]]"
published: 2026-05-30
created: 2026-06-08
description: "If you know the 'shape' or pattern of the given dataset, you can use the right kernel function when training a GP model. This is where domain knowledge of a given dataset can be useful. One fun thing I love about kernels is that you can add or multiply them to form composites."
tags:
  - "ToRead"
---
Let us assume you have a machine that gives an arbitrary amount of gold whenever you insert cheese. You don’t know how much cheese you’d need to insert to get a specific amount of gold. The mapping is also not linear, i.e., $G$ is not directly or inversely proportional to $C$, so bigger amount of cheese doesn’t necessarily mean larger portions of gold. Your goal is to figure out how to get the largest portion of gold from this machine, assuming you have a finite amount of cheese.

We’re assuming the process is not random, that is, there is an assumed mapping from amount of cheese $\left(\right. C \left.\right)$ to amount of gold $\left(\right. G \left.\right)$. Let us call this mapping $f$, and you want to uncover it so that you can predict the amount $G$ you’d get whenever you insert some $C$.

You want to understand the relationship: $G = f \left(\right. C \left.\right)$

One way to uncover this relationship is by inserting different amount of cheese and observing the amount of gold you get. This is called a data collection/generation process. With this data, you can build a model to help you predict $G$ for every $C$ you insert. But why is this called a model?

A model is an approximation of something else. We don’t know the internal workings of the machine, and we can’t observe all possible outputs from it since we do not have infinite cheese. We’re building an approximation of the cheese-gold mapping, based on the limited number of inputs and outputs observed. This is essentially what machine learning modeling is; an attempt to correctly approximate the process that generates some type of data, based on the historical observations we’ve collected about this process.

For the purpose of this post, there is a specific type of machine learning method I will talk about, and it’s called a Gaussian process (GP). To explain GPs, I’ll continue our previous analogy.

Say you’ve only observed one or two data points, there are infinitely many guesses you can still make about this cheese-gold mapping. Of course, this space becomes less ‘infinite,’ as you collect more observations from the machine. A GP works by constructing an infinite amount of guesses or functions of the true process you want to approximate. As you accumulate more observations, it changes the shape of these functions to match the data, and hence the true process (just like the way you change your mind after getting new information). A GP is simply a distribution over functions (or guesses). Because we have an infinite amount of guesses, the expected true guess (or best model) is the mean of all plausible guesses. We can use the variation/spread between those guesses to calculate an uncertainty. If the uncertainty is large, then all guesses are significantly different, and our mean guess is probably wrong. If the uncertainty is small, it means that the guesses are not too dissimilar, and we can trust the mean.

$$
G P \left(\right. m \left(\right. x \left.\right) , k \left(\right. x , x^{'} \left.\right) \left.\right)
$$

A GP is characterized by its mean and covariance. The kernel function is what helps us calculate the covariance or uncertainty. It tells us how strongly two points should be correlated. I’ve been working with GPs in the last few years, and I’ve come to love how flexible they are. They are non-parametric models, so they do not assume a fixed or finite set of parameters for the function shape. You can tune how a GP models a dataset by changing its kernel function. If you look up the definition of a kernel function, you’d get something like this.

> A kernel function is a mathematical tool used in machine learning, particularly in algorithms like Support Vector Machines (SVMs), to transform data into a higher-dimensional space without explicitly calculating the coordinates in that space. This allows for the analysis of complex, nonlinear relationships in the data while maintaining computational efficiency.

In the context of GPs, a kernel or covariance function $k \left(\right. x , x^{'} \left.\right) = C o v \left(\right. f \left(\right. x \left.\right) , f \left(\right. x^{'} \left.\right) \left.\right)$, encodes which function values should vary together. They as used as a measure of similarity.

If you know the ‘shape’ or pattern of the given dataset, you can use the right kernel function when training a GP model. This is where domain knowledge of a given dataset can be useful. One fun thing I love about kernels is that you can add or multiply them to form composites. This means you’re able to bias the model to even more complex data representations.

Now that we’ve built an intuition for machine learning and GPs, I will use the rest of this post to go over different kernel representations and their visualizations. I provide figures to show a 1D sample from the GP prior when using a specific kernel, and I show covariance heatmaps where the kernel compares two inputs.

1. **Linear Kernel Function**. This kernel doesn’t do anything complex, it assumes that the function can be explained by a linear trend. It measures the similarity between data points $x$ and $x^{'}$ by calculating their dot product.
	$$
	k \left(\right. x , x^{'} \left.\right) = x^{\top} x^{'}
	$$
	  
	In the left figure below, there are three sampled functions from the GP prior, all of which show simple linear shapes formed by the kernel. In all right-hand-side figures, the x-axis and y-axis are two possible input values. The color shows how similar the kernel thinks those two values are. Bright means “these two points strongly influence each other”; dark means “these two points have an inverse covariance or mostly unrelated.”

![Linear kernel](https://images.kelvinpaschal.com/kernels/linear.png)

1. **Periodic Kernel.** This kernel is useful for modeling data that varies periodically, an example is climate data where you might want to model the yearly temperature of a particular city. It is formally known as the Exp-Sine-Squared kernel. Remember that a Sine wave is periodic? The kernel is expanded below.
	$$
	k \left(\right. x , x^{'} \left.\right) = \text{exp} \left(\right. - \frac{2 sin^{2} ⁡ \left(\right. \pi d \left(\right. x , x^{'} \left.\right) / p \left.\right)}{l^{2}} \left.\right)
	$$
	  
	where $p$ and $l$ are the periodicity and length scales of the kernel respectively, and $d \left(\right. . , . \left.\right)$ is the Euclidean distance. You can observe the repeating or periodic pattern that it creates in the figures below. It goes from low to high values, and high to low again, just like a periodic wave.

![Periodic kernel](https://images.kelvinpaschal.com/kernels/periodic.png)

1. **Composites of Linear and Periodic Kernels.** As I wrote earlier, you can combine kernel functions to form composites. This is a nice way to simultaneously take advantage of the properties of different kernels. Adding kernels means the model can explain the data as a sum of patterns. Multiplying kernels means all patterns must apply at once.
	In the visualizations below, I show what it looks like when you add and multiply the linear and periodic kernels. You can see traces of both kernels the figures, but you’ll notice that the effect of the periodic kernel is more pronounced when multiplying, as opposed to the additive composite where it looks mostly linear with a little backdrop of periodicity.

![Linear plus periodic](https://images.kelvinpaschal.com/kernels/linear_+_periodic.png)

![Linear times periodic](https://images.kelvinpaschal.com/kernels/linear_x_periodic.png)

1. **Radial Basis Function (RBF) kernel.** This is a popular kernel, and it is often used as the default in Support Vector Machines (SVM). This kernel is stationary, meaning that it calculates similarity between two points based on the magnitude of their distance, and not their location in space. It is given by the equation below.
	$$
	k \left(\right. x , x^{'} \left.\right) = exp ⁡ \left(\right. - \frac{d \left(\right. x , x^{'} \left.\right)^{2}}{2 ℓ^{2}} \left.\right)
	$$
	  
	where $l$ is the length scale, and $d \left(\right. . , . \left.\right)$ is the Euclidean distance. The RBF kernel scales distance from 0 to 1 (see right figure below). Zero when the distance is infinite, and 1 when $x$ is the same as $x^{'}$. If you observe the right figure, you’ll see bright colors where similar numbers meet in the coordinate. Take a look at (-2, -2); it has a color that corresponds to 1 since both points are the same. As two points grow in distance, their similarity goes to 0. If $l$ is small, then the function is sensitive to small changes in data and adjusts quickly, whereas if $l$ is large, the function changes slowly. Looking at the left figure, notice that the function is a bit smooth, which might not necessarily reflect a lot of real life data. There are other variations of RBF that address this.

![RBF](https://images.kelvinpaschal.com/kernels/RBF.png)

1. **Rational Quadratic Kernel.** This kernel is just like the previous one, and you can see below that they have similar equations. The RBF changes smoothly, and it assumes the same for the data. In real life, data isn’t always smooth, and we need to account for this. The rational quadratic kernel is simply an infinite sum of the RBF kernel, with different length scales $l$. The kernel also introduces a parameter $\alpha$, which is used to scale the mixture of RBF, capturing variation at multiple length scales.
	$$
	k \left(\right. x , x^{'} \left.\right) = \left(\left(\right. 1 + \frac{d \left(\right. x , x^{'} \left.\right)^{2}}{2 \alpha ℓ^{2}} \left.\right)\right)^{- \alpha}
	$$

![Rational Quadratic](https://images.kelvinpaschal.com/kernels/rational_quadratic.png)

1. **Matérn Kernel.** The Matérn kernel is the generalized form of the RBF kernel. It includes a term $\nu$, which is used to control the smoothness of this function. $l$ and $d \left(\right. . , . \left.\right)$ are the same length scale and Euclidean distance parameter like in the previous kernels, while $K_{\nu}$ is the modified Bessel function of the second kind.
	$$
	k \left(\right. x , x^{'} \left.\right) = \frac{1}{\Gamma \left(\right. \nu \left.\right) 2^{\nu - 1}} \left(\right. \frac{\sqrt{2 \nu}}{l} d \left(\right. \left(\right. x , x^{'} \left.\right) \left.\right)^{\nu} K_{\nu} \left(\right. \frac{\sqrt{2 \nu}}{l} d \left(\right. x , x^{'} \left.\right) \left.\right)
	$$
	Below, I provide two instances of the Matérn kernel where $\nu$ is varied. When $\nu$ is small, it means that the approximate function is sensitive and changes sharply. A large value of $\nu$ corresponds to a smoother function, so as $\nu$ grows to infinity it becomes the RBF kernel. Notice how the sampled functions for $\nu = 1.2$ is less smooth than the functions where $\nu = 2.5$.

![Matern](https://images.kelvinpaschal.com/kernels/matern.png)

1. **More complex composites.** Since we’ve outlined some of the popular kernels, I thought it’ll be interesting to show you how to form composites with them. Perhaps you might grow appreciation for how the kernels change based on the operator (addition or multiplication) used. One can create cool representation by stacking kernel different kernel functions. Pay attention to the shape and smoothness of the sampled functions.

![Matern_RBF](https://images.kelvinpaschal.com/kernels/Matern_RBF.png)

![linear_rationalquadratic_Matern](https://images.kelvinpaschal.com/kernels/linear_RationalQuadratic_Matern.png)

![linear_rationalquadratic_Matern^2](https://images.kelvinpaschal.com/kernels/linear_RationalQuadratic_Matern%5E2.png)

In this post, we built intuition for machine learning, Gaussian processes, and kernel functions. I showed how different kernel representation change the shape of a GP prior function, and hence the inductive bias of the model. You can bias your model towards a specific dataset with the right kernel function.

All code used to generate these visualizations can be found in this [Colab Notebook](https://colab.research.google.com/drive/1yk2gVCNQuzf2hyr9Zp9FlIW-LWRb_wd3?usp=sharing). You can play around with the notebook by visualizing other composite kernels you dream up.

<iframe src="chrome-extension://cnjifjpddelmedmihgijeibhnjfabmlf/side-panel.html?context=iframe"></iframe>