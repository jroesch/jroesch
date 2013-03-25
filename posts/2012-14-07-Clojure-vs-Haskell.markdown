--- 
title: Clojure vs. Haskell
author: Jared Roesch
date: July 12, 2012
description: A quick post on why Haskell is the *more* consistent and clear than Clojure.
---
### DRAFT
I just recently started writing some Clojure again after not using it at all over the past 6 months. From
the beginning I've had a really high opinion of the language and I think it gets a lot of things right, and I have
a lot of fun to writing it. As I've been getting back on the horse, I'm finsihing up and reviewing 
the Joy of Clojure, and hacking on some small ideas. The big thing that has changed for me is that between the 
time I started learning Clojure(near the end of last summer) and now I've become a Haskell fanatic. 
So as I refresh on Clojure I find what use to be more *foreign* concepts much more familiar and appreciated.

As I have become a Haskeller over the last year I have more and more relied on the function as my coceptual
model of everything. It has influenced me tremendously from my work in Python, C++, and most of all Javascript.
So when I came back to Clojure I had become use to the idea that everything I was invoking was a function(or could be modeled as such) .Of course that is not correct in context of a Lisp. I had forgot about Macros. 

So as an exercise I decided to set about writing an HTML templating system that provided for embedded logic in Clojure.
I started writing a function to remove the embedded code from the templated HTML and I wanted to simply be able to take   
a list of indices and make sure that they are above -1, which is the error condition for String functions in Java.

In Haskell I just say, "Hey I have a [Int], and I want a [Bool], (> 0) :: (Num a, Ord a) => a -> Bool, and I have my 
first step.

~~~~~{.haskell}
map (> 0) [1, 2, 3]
~~~~~

Then I can simply fold over the booleans and reduce it to a single value

~~~~~{.haskell}
foldl (&&) True $ map (> 0) [1, 2, 3]

~~~~~

The types guided me and I know how everything works, I can simply inspect the types and have guareentee that I will 
get the value I wanted.

While attempting this in Clojure turned out to be much more diffcult at first galance.

So at first I tried the Haskell method 

~~~~~{.clojure}
(reduce and true (map #(< 0 %) nums)
~~~~~

and that blew up in my face, mostly because of my own stupidity. 

I quickly rememeber `and` was variadic and already did the reduction for me. 

At the same time I relized and is a macro and there for doesn't fufill the IFn type that Clojure expects 
as a combinator.

I then found out in 1.3 the release after I stopped writing Clojure there was a function added 
called every-pred that takes a predicate function and gives me a boolean reduction like I want.

~~~~~{.clojure}
(def grtr-zero (every-pred #(< 0 %))
~~~~~

So now I have my reduction. Then I was confounded because I have this function now, but how to do apply it to the list.
I can't just do grtr-zero nums, my immediate reaction was to do (flatten '(gz nums)) => (gz 1 2 3). This still wasn't good because now I had a list, but I needed to eval it. Then I realized apply exists and that it does essentially what
I was doing combines all args into a Seq then calls the Java fucntion (. f applyTo (seq args)).

I finally found a clean solution(one that didn't do anything Hack-y like eval).

In the end this made me appreciate consistency of Haskell all the more as a language. A few weeks ago at a local hack-aton I ended spending multiple hours dicussing "functional programming" with some one, and ended up spending most of the time showing him that like Lisp Haskell is relatively simple at its core. It for the most part is a tiny language that gives you a few built-in features. Some nice syntatic sugar, but not much else. Though underneath all that it is consistent. Everything is an expression, everything has a type, and using that I can piece together anything. While in 
Clojure even though I have an abundance of meta data, ability to look at the source. The same clarity of design feels missing. I remember having a similar issue when I first started with Clojure and was playing with sets.

In contrast when learning Haskell the mimimum groking point was understanding types. From that point on I can just Hooggle a type and find the exact thing I need. 

My main point of this is the insidious nature of having Macros and functions with no clear delination. In Hakell I can
inspect anything and one know if it is a function and its exact type and behaviour. I would of had no issue deciphering and. 

