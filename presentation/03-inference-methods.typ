#import "@preview/polylux:0.3.1": *
#import themes.simple: *
#import "@preview/cetz:0.2.0"
#import "@preview/tablex:0.0.6": tablex, rowspanx, colspanx

#show: simple-theme

#set text(size: 20pt, lang:"en")
// #set text(font: "heuristica")
#show regex("[♯♭]"): set text(font: "dejavu serif")
#set table(inset: 10pt, stroke: none)
#show link: underline
#show raw.where(block: false): r => text(fill: maroon, r)

#let beta(a, b) = (x) => calc.pow(x, a - 1) * calc.pow(1 - x, b - 1)

#title-slide[
  = Workshop Bayesian Corpus Studies

  #v(1em)
  Christoph Finkensiep\
  Würzburg, Feb 2024

  == Session 3: Understanding Inference Methods
]

#centered-slide[
  = Inference and Conditioning
]

#slide[
  == Inference as Conditioning

  Inference = computing a conditional distribution given the join distribution.

  #v(1em)
  
  Model:
  $ p(x,y) $

  Observing $x$:
  $ p(x | y=4) = p(x,y=4) / p(x=4) $
]

#slide[
  == Factorization

  #side-by-side(
    [
      1. draw $a$
      2. draw $b | a$
      3. draw $c | a, b$
      #uncover("2-", image("img/bayes-net1.svg", width: 5cm))
    ],
    uncover("6-")[
      1. draw $c$
      2. draw $a | c$
      3. draw $b | a, c$
      #image("img/bayes-net2.svg", width: 5cm)
    ]
  )

  #uncover("3-")[
    A probabilistic program is a _factorization_ of a joint distribution.
  ]

  #side-by-side[
    #uncover("4-")[$p(a, b, c)\ = p(a) dot p(b, c | a)$]\
    #uncover("5-")[$= p(a) dot p(b | a) dot p(c | b, a)$]
  ][
    #uncover("7-")[$p(a, b, c)\ = p(c) dot p(a, b | c)$]\
    #uncover("8-")[$= p(c) dot p(a | c) dot p(b | a, c)$]
  ]

//  #uncover("6-")[Process:]
]

#slide[
  == Conditioning Probabilistic Programs

  $ p(x, y) = p(x) dot p(y | x) $

  Process:
  - draw $x$
  - draw $y | x$

  #v(1em)
  #side-by-side[
    #pause
    Condition on $x$ ("upstream"):
    - set $x = 5$
    - draw $y | x = 5$

    $p(y | x)$ is already known
  ][
    #pause
    Condition on $y$ ("downstream"):
    - set $y = 4$
    - draw $x | y = 4$ ???

    $p(x | y)$ is not explicitly given
  ]
]

#centered-slide[
  = Inference Methods
]

#slide[
  == Running a Probabilistic Program

  #side-by-side[
    Process:
    - draw $x$
    - draw $y | x$  
  ][
    Given: $y = 4$
  ][]

  sample from $p(x,y)$? $->$ run program!\ #pause
  sample from $p(x | y = 4$)?

  #pause
  Idea:
  - run the program many times: sample from $p(x,y)$\
  - select outcomes where $y = 4$: sample from $p(x | y = 4)$

  #pause
  $=>$ "rejection sampling"

  #pause
  How often is $y = 4$ by chance?\
  What if $y$ a dataset? What if $y$ is continuous?
]

#slide[
  == Computing Relative Probabilities

  #side-by-side[
    Process:
    - draw $x$
    - draw $y | x$  
  ][
    Given: $y = 4$
  ][]

  We can run the program to compute $p(x,y)$ for fixed $x$ and $y$.\
  #uncover("2-")[- easy to compute $p(x, y=4)$ for different $x$]
  #uncover("3-")[- still can't compute $p(x, y=4)$, but can compare different $x$:]

  #uncover("3-")[
    $ p(x_1 | y=4) / p(x_2 | y=4) = (p(x_1, y=4) / p(y=4)) / (p(x_2, y=4) / p(y=4)) = p(x_1, y=4) / p(x_2, y=4) $
  ]
]

#slide[
  == Better Sampling: Metropolis-Hastings Algorithm

  Idea: random walk, move between different values of $x$
  - use a _proposal distribution_: $g(x_(t + 1) | x_t)$
  - compare values using _score_: $f(x) = p(x, y=4)$

  #side-by-side[
    #pause
    #image("img/metropolis.png")
  ][
    #pause
    Metropolis-Hastings:
    - choose $x_0$ random
    - for each step $t$:
      - choose $x' | x_t tilde g$
      - compute $alpha = f(x') / f(x_t) g(x_t | x') / g(x' | x_t)$
      - draw random $u tilde "Uniform"(0,1)$:
        - if $u <= alpha$: $x_(t + 1) = x'$
        - if $u > alpha$: $x_(t + 1) = x_t$
  ]
]

#slide[
  == Markov-Chain Monte Carlo (MCMC)

  #only(1)[
    Theory: run chain as long as possible, take last state, repeat (slow)
    #align(center, image("img/mcmc.svg", height: 70%))
  ]
  #only(2)[
    Practice: "burn-in" / "tune" phase, then take all samples (correlated but faster)
    #align(center, image("img/mcmc_full.svg", height: 70%))
  ]
]

#slide[
  == Variational Inference: Intuition

  Idea: approximate the posterior through optimization / gradient descent

  #align(center)[
    #for i in (1,2,3,4,5) {
      only(i, image("img/vi_step" + str(i) + ".svg", height: 70%))
    }
  ]
]

#slide[
  == Variational Inference: Math

  Define a _variational family_: $q_phi (z)$
  - known shape (can be simpler than true posterior)
  - parameters $phi$

  #pause
  Optimize $phi$:
  - loss: #link("https://en.wikipedia.org/wiki/KL-divergence")[KL divergence]
    $D_"KL" (q_phi (z) || p(z | x)) = bb(E)_q [ log (q_(phi)(z)) / p(z | x) ] $ #pause
    - not tractable, but equivalent to "evidence lower bound"
      (#link("https://en.wikipedia.org/wiki/Evidence_lower_bound")[ELBO]):
  
  $ bb(E)_q [ log (q_(phi)(z)) / p(z | x) ] =
        bb(E)_q [ log (q_(phi)(z) p(x)) / p(z,x) ] =
        underbrace(bb(E)_q [ log (q_(phi)(z)) / p(z,x) ], #box[-"ELBO"\ (computable!)])
         + underbrace(log p(x), #box["evidence"\ (const!)])
      $#pause
  - use gradient descent (in practice: autodiff)
]

#slide[
  == Bonus: Why "ELBO"?

  "Evidence lower bound":

  $ D_"KL" (q_phi || p) = -"ELBO"(phi) + log p(x)\
    =>\
    D_"KL" (q_phi || p) + "ELBO"(phi) = log p(x)\
    =>\
    "ELBO"(phi) <= log p(x)
  $

  #pause
  #v(1fr)
  (should be "log-evidence lower bound")
]

#slide[
  == Comparison: Sampling vs Variational Inference

  #side-by-side[
    Sampling:
    - result: sample of $p(z | x)$
    - very flexible
    - can be slow on large data
    - can be tricky to get right
    - use: PyMC / numpyro / ...
  ][
    Variational Inference:
    - result: $q_phi(z)$
    - integrates with deep learning (VAE)
    - fast on large data, can be slow to converge
    - can be tricky to get right
    - use: pyro / numpyro
  ]
]
