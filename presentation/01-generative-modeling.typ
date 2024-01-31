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

#title-slide[
  = Workshop Bayesian Corpus Studies

  #v(1em)
  Christoph Finkensiep\
  Würzburg, Feb 2024

  == Session 1: Generative Modeling
]

#centered-slide[
  = Motivation
]

#slide[
  == Corpus Studies

  #align(center)[
    #box[#image("img/bach.png", height:30%)] #h(1em)
    #box[#image("img/brain.jpg", height: 30%)] #h(1em)
    #box[#image("img/group.jpg", height: 30%)]
  ]
  #pause
  #align(center)[
    *#sym.arrow.t*
    
    #image("img/chorales.jpg", height: 30%)
  ]
]

#slide[
  == A Small Corpus Study

  #side-by-side[
    #align(center, image("img/rhythm1.svg", width: 60%))
  ][
    #align(center, image("img/rhythm2.svg", width: 60%))
  ]

  #v(2em)
  #align(center)[
    In which group are the patterns more regular?
  ]
]


#slide[
  == Corpus Studies

  #side-by-side(columns:(1.5fr, 1fr))[
    The classical approach:
    1. find / create a corpus
    2. "operationalize" the quantity of interest
    3. measure, do statistics
  ][
    #cetz.canvas(length: 2cm, {
      import cetz.draw: *
  
      set-style(content: (padding: 10pt))
  
      //content((-1,0), [model], name: "model", frame: "rect")
      content((0,-1), [observations], name: "obs")
      content((0,1), [conclusions], name: "z")
      line("obs.north", "z.south", mark: (end: ">"), name: "inf-line")
      //line("model.east", "inf-line")
      content("inf-line.mid", [_operationalize_], anchor: "west")
    })
    //#align(center, image("img/chorales.jpg", width: 40%))
  ]
  
  #pause
    #align(center, image("img/rhythm1.svg", width: 30%))
  
  #pause
  #place(horizon+center, dx: -6.9cm, dy: -2.5cm)[
    #rect(width: 11.7cm, height: 1cm, stroke:red)
  ]
  #place(horizon+center, dx: 0cm, dy: -2.5cm)[
    #text(red)[*???*]
  ]
]

#slide[
  == Problems with the Standard Approach

  #side-by-side(columns:(1fr, 1fr))[
    $ "reg"(x) = 1 / ("# unique beats in" x) $
    // - Do I really measure regularity?
    // - Should this be normalized or not?
    // - What is "regularity"?
      
  ][
    #uncover("2-")[
      Measure:
      - adequate?
      - arbitrary, ad-hoc?
      - overarching theory?
    ]
  ]

  #side-by-side[
    #align(center, image("img/rhythm1.svg", width: 70%))
  ][
    #uncover("3")[
      Stats:
      - which statistic?
        - arithmetic mean: $1/N sum_i x_i$

        - geometric mean: $root(N, product_i x_i)$
      - which test?
    ]
  ]
]

#let model_diag = cetz.canvas(length: 2cm, {
  import cetz.draw: *
  
  set-style(content: (padding: 10pt))
  
  content((-1,0), [model], name: "model", frame: "rect")
  content((0,-1), [observations], name: "obs")
  content((0,1), [conclusions], name: "z")
  line("obs.north", "z.south", mark: (end: ">"), name: "inf-line")
  line("model.east", "inf-line.mid")
  content("inf-line.mid", [_inference_], anchor: "west")
  
  set-style(stroke: gray)
  
  content((-2.5,1), [#text(gray)[entities, properties]], anchor: "east", name: "obj")
  line("model.west", "obj.east")
  content((-2.5,0), [#text(gray)[relations]], anchor: "east", name: "rel")
  line("model.west", "rel.east")
    content((-2.5,-1), [#text(gray)[assumptions]], anchor: "east", name: "assum")
  line("model.west", "assum.east")
})

#slide[
  == Alternative: Work with Models

  #pause

  #side-by-side(columns: (1fr, 10em))[
    Models
    
    #line-by-line(start:3)[
      - describe a segment of the world (simplified)
      - relevant *entities*, *properties* and *relations*
      - explicit *assumptions*
      - enable *simulation* and *inference*
    ]
    
    #only(7)[
      #align(center, model_diag)
    ]
  ][
    #block[
      #image("img/orrey.jpg", width:100%)
      #place(bottom + right, dx: -2pt, dy: -2pt)[
        #text(white, size: 9pt)[Birmingham Museums Trust, CC BY-SA 4.0]
      ]
    ]
  ]
]

#slide[
  == A Model of Rhythmic Regularity

  #side-by-side(columns:(1fr,1fr))[
    #align(center, model_diag)
  ][
    #align(center, image("img/rhythm1.svg", width: 60%))
  ]

  #side-by-side[
    #pause
    Entities and properties:#pause
    - pattern
    - note
    - group of patterns
      - regularity
  ][
    #pause
    Relations:#pause
    - patterns consist of notes
    - groups have patterns
    - regularity $<->$ patterns?
  ][
    #pause
    Inference:#pause
    - patterns $->$ regularity

    #pause
    Simulation:#pause
    - generate new patterns
  ]
]

#centered-slide[
  = Generative Models
]

#let genmod = cetz.canvas(length: 2cm, {
        import cetz.draw: *
        set-style(content: (padding: 10pt))
        
        content((0,1), [initial state], name: "z")
        content((0,-1), [observed outcome], name: "x")
        content((2,1), [parameters], name: "params")
        content((0,0), [process], name: "proc", frame: "rect")
        line("z.south", "proc.north")
        line("proc.south", "x.north", mark: (end: ">"))
        line("params.south", "proc.north-east")
      })

#slide[
  == The Process Behind the Data
    
  #side-by-side(columns:(1.2fr, 1fr))[
    #v(-0.4cm)
    #align(center, genmod)
  ][
    #uncover("2-")[
      Simulation:
      - run the process, change parameters
      Inference:
      - find plausible parameters
    ]
  ]

  #pause
  #pause

  #side-by-side(columns: (1fr, 2fr))[
    #align(center)[
      #box[
        #cetz.canvas(length: 2cm, {
          import cetz.draw: *
          set-style(content: (padding: 10pt))
          
          content((0,1), [regularity $r$], name: "z")
          content((0,-1), [observed patterns], name: "x")
          // content((2,1), [parameters], name: "params")
          content((0,0), [process], name: "proc", frame: "rect")
          line("z.south", "proc.north")
          line("proc.south", "x.north", mark: (end: ">"))
          // line("params.south", "proc.north-east")
        })
      ]
    ]
  ][
    #pause
    #align(center)[
      #box[
        #cetz.canvas(length: 2cm, {
          import cetz.draw: *
          set-style(content: (padding: 10pt))
          
          content((0,1), [regularity $r_1$], name: "z")
          content((0,-1), [patterns group 1], name: "x")
          // content((2,1), [parameters], name: "params")
          content((0,0), [process], name: "proc", frame: "rect")
          line("z.south", "proc.north")
          line("proc.south", "x.north", mark: (end: ">"))
          // line("params.south", "proc.north-east")
          
          content((4,1), [regularity $r_2$], name: "z2")
          content((4,-1), [patterns group 2], name: "x2")
          // content((2,1), [parameters], name: "params")
          content((4,0), [process], name: "proc2", frame: "rect")
          line("z2.south", "proc2.north")
          line("proc2.south", "x2.north", mark: (end: ">"))
          // line("params.south", "proc.north-east")

          line("z.east", "z2.west", mark: (start: ">", end: ">"))
          line("proc.east", "proc2.west")
        })
      ]
    ]
  ]
]

#slide[
  == A Simple Example

  Linear Regression: $x$ is linearly related to $y$ #h(1fr) $y approx a dot x + b$ #h(1fr)

  //What is the generative model behind this idea?
  ~
  
  #side-by-side[
    #box(clip: true)[
      #v(-1.5em)
      #only("1-2", image("img/regplot_loudness_energy.svg", width:100%))
      #only("3-", image("img/regplot_loudness_energy_fit.svg", width:100%))
    ]
  ][
    #uncover("2-")[
      Observations: points ($x$ and $y$)

      Parameters: slope $a$, intercept $b$, variance $sigma^2$
    ]

    #uncover("3-")[
      Generative Process: #h(1em) // #uncover(4, text(red)[$<-$ this is "just" a model])
      - choose parameters $a$, $b$, $sigma$
      - for each point i:
        - choose $x_i$
        - compute $f(x_i) = a dot x_i + b$
        - pick $y_i tilde cal(N)(f(x_i), sigma)$
    ]
  ]
]

#slide[
  == A More Involved Example
  
  #side-by-side[
    #align(center, image("img/tree.jpg", width: 90%))
    $ I &--> I &I\
      I &--> V &I\
      ...
    $
  ][
    #pause
    Observations: chord sequences (pieces)

    #pause
    Parameters: Rules and probabilities

    #pause
    Process:
    - choose grammar rules $R$
    - choose rule probabilities $p_R$
    - for each piece $i$:
      - sample a derivation $d_i$
      - observe the resulting chord sequence

    #pause
    Inference:
    - most plausible derivation $d_i$ for each piece
    - most plausible rules and probabilities
  ]
]

#slide[
  == A _Generative_ Model of Rhythmic Regularity

  #align(center)[
  Generate this!

  #side-by-side[
    #image("img/rhythm1.svg", width: 60%)
    #uncover(1)[
      `abab`\
      `cbad`\
      `abba`
    ]
  ][
    #image("img/rhythm2.svg", width: 60%)
    #uncover(1)[
      `aaaa`\
      `caca`\
      `bbaa`
    ]
  ]

    Simplifying assumptions: always 4/4, we don't look inside "beats".
  ]
]

#slide[
  == Possible Solutions

  #side-by-side[
    Generate corpus:
    - for each group $g$:
      - choose regularity $r_g$:
      - for each pattern $i$:
        - sample pattern $p_(g i)$ using $r_g$

    #pause
    #align(center, image("img/bayesnet_rhythms.svg", width: 50%))
  ][
    #only(3)[
      Generate pattern (based on predecessor):
      - choose $b_1$ randomly
      - for each following beat $i$:
        - flip coin $(r_g)$:
          - heads: $b_i = b_(i-1)$
          - tails: choose new beat for $b_i$

      #align(center, image("img/bayesnet_markov.svg", width: 80%))        
    ]
    
    #only(4)[
      Generate pattern (based on position):
      - choose $b_1$ randomly
      - flip coin $(r_g)$:
        - heads:  $b_2 = b_1$
        - tails: new beat for $b_2$
      - flip coin $(r_g)$:
        - heads: repeat first half
        - tails:
          - repeat or new $b_3$ ...
          - repeat or new $b_4$ ...
          
      #v(-1em)
      #align(center, image("img/bayesnet_position.svg", width: 80%))        
    ]
    #only(5)[
      A more detailed model:
      #align(center, image("img/rhythm_tree.jpg", width: 90%))
      generate full rhythm, flip coins to repeat
    ]
  ]
]

#slide[
  == Advantages of Generative Models

  #side-by-side(columns: (1.5fr, 1fr))[
    Very Explicit:
    - write down the entire generative process
      - this is how you think/pretend it works
      - links entities (observations, parameters)
    #uncover("2-")[- can be discussed]
    #uncover("3-")[
      - can be used to understand a phenomenon better
        - What is regularity? Why is music regular?
    ]

    #uncover("4-")[
      Simulation:
      - run the generative process
      - manipulate process / parameters
    ]
    
    #uncover(5)[Inference: ???]
  ][
    #genmod
  ]
]

#centered-slide[
  = Inference
]

#slide[
  == Quantifying Uncertainty

  #v(-1.5em)
  "Random variable" $X$: uncertain quantity or property
  #uncover("2-")[- future event (coin flip)]
  #uncover("3-")[- unobservable (regularity of a corpus)]
  
  #side-by-side(columns: (1fr,1fr,0fr))[
    #only("4-")[
      discrete: mass function $p(x)$

      #{
        let data = for s in range(2,13) { ((s, (6-calc.abs(s - 7)) / 36),) }
        set text(size: 15pt)
        cetz.canvas({
          import cetz.draw: *
          cetz.chart.columnchart(data,
                                 size: (auto, 5),
                                 y-tick-step: 0.1,                                 
                                 bar-style: (i) => if i in (2,4) {(fill:blue)} else {(fill:silver)})
          content((10,4), only(8)[$ sum_x p(x) = 1 $], frame: "rect", padding: 2pt, fill: white, stroke: none)
        })
      }
    ]
  ][
    #only("6-")[
      continuous: density function $p(x)$

      #{
        set text(size: 15pt)
        let f(x) = calc.exp(-calc.pow(x - 3, 2)) / calc.sqrt(2 * calc.pi)
        cetz.canvas({
          import cetz.plot
          import cetz.draw: *
          plot.plot(size: (10,5),
                    x-tick-step: 1,
                    y-tick-step: 0.1,
                    y-max: 0.45,
                    axis-style:"scientific", {
                      plot.add(f, domain: (0, 6), fill:true, style: (stroke: black, fill: silver))
                      plot.add(f, domain: (2.5, 4), fill: true, style: (stroke: black, fill: blue))
          })
          content((8,4), only(8)[$ integral p(x) dif x = 1 $], frame: "rect", padding: 8pt, fill: white, stroke: none)
        })
      }
    ]
  ][
    #v(11em)
  ]

  #v(-1.5em)
  #side-by-side()[
    #uncover("5-")[#align(horizon)[$ P(X in {4, 6}) = p(4) + p(6) $]]
  ][
    #uncover("7-")[#align(horizon)[$ P(2.5 <= X <= 4) = integral_(2.5)^4 p(x) dif x $]]
  ]
]

#slide[
  == Distributions over Several Variables
  
  Several variables: *joint* distribution
  $ p(x, y, z) $

  #pause

  "don't care": *marginal* distribution
  $ p(x,y) &quad #text[ignore $z$]\
    p(x)   &quad #text[ignore $y$ and $z$]
  $

  #pause
  
  "observation": *conditional* distribution
  $ p(x | y,z) &quad #text[$x$ given $y$ and $z$]\
    p(x,z | y) &quad #text[$x$ and $z$ given $y$]\
    p(y | x)   &quad #text[$y$ given $x$ (ignoring $z$)]
  $
]

#slide[
  == Inference

  #v(-1em)

  #align(center)[
    #set text(size: 20pt)
    #box[#genmod]
    #pause
    #only("-4")[
    #box(width: 12em)[
      #cetz.canvas(length: 2cm, {
        import cetz.draw: *
        set-style(content: (padding: 10pt))
        
        content((4.5,1), [regularity], name: "z_m")
        content((4.5,-1), [patterns], name: "x_m")
        // content((6.5,-1), [corpus], name: "xs_m")
        // content((6.5,1), [style], name: "params_m")
        content((4.5,0), [process], name: "proc_m", frame: "rect")
        line("z_m.south", "proc_m.north")
        line("proc_m.south", "x_m.north", mark: (end: ">"))
        // line("proc_m.south", "xs_m.north-west", mark: (end: ">"))
        // line("params_m.south", "proc_m.north-east")
      })
    ]]
    #only("5")[
    #box(width: 12em)[
      #cetz.canvas(length: 2cm, {
        import cetz.draw: *
        set-style(content: (padding: 10pt))
        
        content((4.5,1), [idea / goal], name: "z_m")
        content((4.5,-1), [piece], name: "x_m")
        content((6.5,-1), [corpus], name: "xs_m")
        content((6.5,1), [style], name: "params_m")
        content((4.5,0), [composing], name: "proc_m", frame: "rect")
        line("z_m.south", "proc_m.north")
        line("proc_m.south", "x_m.north", mark: (end: ">"))
        line("proc_m.south", "xs_m.north-west", mark: (end: ">"))
        line("params_m.south", "proc_m.north-east")
      })
    ]
    ]
    #pause
    #box[
      #cetz.canvas(length: 2cm, {
        import cetz.draw: *
        set-style(content: (padding: 10pt))

        content((9.5, 1), [_latent_ variables ($z$ / $theta$)], name: "latent")
        content((9.5, -1), [_observed_ variables ($x$)], name: "obs")
        content((9.5, 0), [$ p(x | z) $], name: "likelihood", frame: "rect")
        line("latent.south", "likelihood.north")
        line("likelihood.south", "obs.north", mark: (end: ">"))
      })
    ]

    #pause

    #v(1em)
    
    #align(center)[
      The Inference Button™:

      $ underbrace(p(x, z), #[model \ $p(z) dot p(x|z)$]) --> underbrace(p(z | x), #[posterior\ distribution]) $
    ]
  ]
]

#slide[
  == Back to our Corpus Study

  #side-by-side[
    Variables:
    - regularity $r = ?$
    - corpus $C$ #uncover("3-", $= [#[`*rrr`, `*nnn`, `*rnr`]]$)

    #uncover("2-")[
      Model:
      - choose $r$ #uncover("4-", text(blue)[$tilde$ unknown distribution])
      - for each pattern:
        - beat 1 random
        - for beat 2-4:
          - flip coin ($r$): #uncover("5-", text(blue)[$tilde "Bernoulli"(r)$])
            - heads: repeat
            - tails: don't repeat
    ]
  ][
    #align(center, image("img/rhythm2.svg", width: 80%))
  ]
]

#let heads = 5
#let tails = 4

#slide[
  == Looking at the Likelihood

  The probability of the data depends on $r$:
  $ p(C | r) = p([#[`*rrr`, `*nnn`, `*rnr`]] | r) = r^5 dot (1-r)^4 $

  #pause
  #align(center)[
  #{
    let lk(theta) = calc.pow(theta, heads) * calc.pow(1 - theta, tails)
    let opt = heads / (heads + tails)
    
    cetz.canvas({
      import cetz.plot
      
      plot.plot(size: (10,5),
        name: "ml-plot",
        x-tick-step: 0.2,
        y-tick-step: 0.1,
        y-max: lk(opt)*1.2,
        x-label: $r$,
        y-label: $p(C | r)$,
        axis-style:"scientific", {
          plot.add(lk, domain: (0, 1), samples: 50, style: (stroke: orange))
          plot.add-anchor("opt-base", (opt, 0))
          plot.add-anchor("opt-north", (opt, "max"))
        })
      cetz.draw.line("ml-plot.opt-base", "ml-plot.opt-north")
    })
  }
  ]
  
  #pause
  #v(-1em)
  $ arg max_r  p(C | r) = 5/9 $
]

#let beta(a, b) = (x) => calc.pow(x, a - 1) * calc.pow(1 - x, b - 1)
#slide[
  == Make it Bayesian

  #side-by-side(columns:(1fr, 1.5fr))[
    $ underbrace(p(r, C), p(r) dot p(C|r)) --> p(r | C)
    $

    #pause
    
    Model:
    - choose #text(blue)[$r tilde #alternatives-match(("1-3": [$op("Uniform")(0, 1)$], "4-": [$op("Beta")(0.5, 0.5)$]))$]
    - for each pattern $i$:
      - choose #text(blue)[$accent(c_i, ->) tilde 3 times op("Bernoulli")(r)$]

    #v(1em)
    #only(6)[
      Problem:

      //      $ p(C) = integral p(C, r) dif r "???" $
      #align(center)[How do we compute this?]
    ]
  ][
    #set text(size: 15pt)

    #pause
    
    #v(-3cm)
    #cetz.canvas({
      import cetz.plot
      import cetz.draw: *
      // cetz.draw.set-style(content: (padding: 3pt))

      group(
        name: "prior-g",
        anchor: "east",
        {
        //anchor("default", (0,0))
        plot.plot(size: (6,2),
                  name: "prior",
                  x-tick-step: 0.2,
                  y-tick-step: 1,
                  y-max: 1.2,
                  y-min: 0,
                  x-label: $r$,
                  y-label: $p$,
                  axis-style:"school-book", {
                    plot.add((x) => 1, domain: (0, 1), style: (stroke: blue))
        })
        content("prior.north", anchor: "south", [$ p(r) $])
      })

      group(
        name: "posterior-g",
        anchor: "west",
        {
        //anchor("default", (0,0))
        plot.plot(size: (6,2),
                  name: "posterior",
                  x-tick-step: 0.2,
                  y-tick-step: 1,
                  // y-max: 1.2,
                  y-min: 0,
                  x-label: $r$,
                  y-label: $p$,
                  axis-style:"school-book", {
                    plot.add(beta(heads+1, tails+1), domain: (0, 1), samples: 200, style: (stroke: blue))
        })
        content("posterior.north", anchor: "south", [$ p(r | C) $])
      })
    })

    #pause
    
    #v(1em)
    #cetz.canvas({
      import cetz.plot
      import cetz.draw: *

      group(name: "prior-g", anchor: "east", {
        plot.plot(size: (6,2),
                  name: "prior",
                  x-tick-step: 0.2,
                  y-tick-step: 100,
                  // y-max: 1.2,
                  y-min: 0,
                  x-label: $r$,
                  y-label: $p$,
                  axis-style:"school-book", {
                    plot.add(beta(0.5, 0.5), domain: (0.01, 0.99), samples: 200, style: (stroke: blue))
        })
        content("prior.north", anchor: "south", [$ p(r) $])
      })

      group(name: "posterior-g", anchor: "west", {
        plot.plot(size: (6,2),
                  name: "posterior",
                  x-tick-step: 0.2,
                  y-tick-step: 1,
                  // y-max: 1.2,
                  y-min: 0,
                  x-label: $r$,
                  y-label: $p$,
                  axis-style:"school-book", {
                    plot.add(beta(heads+0.5, tails+0.5), domain: (0, 1), samples: 200, style: (stroke: blue))
        })
        content("posterior.north", anchor: "south", [$ p(r | C) $])
      })
    })

    #pause

    #v(1em)
    #cetz.canvas({
      import cetz.plot
      import cetz.draw: *
      //cetz.draw.set-style(content: (padding: 3pt))

      group(name: "prior-g", anchor: "east", {
        plot.plot(size: (6,2),
                  name: "prior",
                  x-tick-step: 0.2,
                  y-tick-step: 100,
                  // y-max: 1.2,
                  y-min: 0,
                  x-label: $r$,
                  y-label: $p$,
                  axis-style:"school-book", {
                    plot.add(beta(heads / 4 + 1, tails / 4 + 1), domain: (0.01, 0.99), samples: 200, style: (stroke: blue))
        })
        content("prior.north", anchor: "south", [ $p(r | C times 1/4)$ ])
      })

      group(name: "posterior-g", anchor: "west", {
        plot.plot(size: (6,2),
                  name: "posterior",
                  x-tick-step: 0.2,
                  // y-tick-step: 1,
                  // y-max: 1.2,
                  y-min: 0,
                  x-label: $r$,
                  y-label: $p$,
                  axis-style:"school-book", {
                    plot.add(beta(heads * 4 + 1, tails * 4 + 1), domain: (0, 1), samples: 200, style: (stroke: blue))
        })
        content("posterior.north", anchor: "south", [ $p(r | C times 4)$])
      })
    })
  ]
]

#slide[
  == Summary: The Three Ingredients

  #align(center+horizon)[
    #v(-5em)
    #side-by-side(columns:(1fr, 0.2fr, 0.5fr, 0.2fr, 1fr))[
      #genmod
    ][
      $+$
    ][
      $ p(x, z) $
    ][
      $-->$
    ][
      $ p(z | x) $
    ]    
    #side-by-side(columns:(1fr, 0.2fr, 0.5fr, 0.2fr, 1fr))[
      generative process\
      (series of decisions)
    ][][
      decision probabilities
    ][][
      inference:\ conditioning
    ]
  ]
]

#slide[
  == Practical Exercises

  https://github.com/Amsterdam-Music-Lab/gmth23-bayes-workshop

  #align(center, image("img/qr-repo.png", width:8cm))
]
