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

  == Session 2: Bayesian Inference
]

#slide[
  #align(center, image("img/spam2.jpg"))

  #pause
  #place(horizon+center, dy: 0.5em, text(red, 40pt, rotate(0deg)[*Spam or not?*]))
]

#slide[
  == The Old Question

  #side-by-side[
    Generating emails:#pause

    1. decide intention (spam or not)

    #pause
    2. write email
      - if spam:
        - generic information (made-up)
        - makes reader click on a link
      - if not spam:
        - specific information for reader
        - legitimate request

    #pause
    3. send!
  ][
    #align(center)[
      #only(5, image("img/spam2.jpg", height: 80%))
    ]
  ]
]

#slide[
  == Operations on Distributions

  #set table(inset:7pt)

  *joint* distribution:
  $ p(x, y, z) $

  #pause

  from joint to *marginal* distribution:
  $ p(x,y) = sum.integral_z p(x,y,z) #h(5em) p(y) = sum.integral_(x,z) p(x,y,z) $

  #pause
  
  from joint to *conditional* distribution ("chain rule"):
  $ p(x,z | y) = p(x,y,z)/p(y) #h(5em) p(y | x,z) = p(x,y,z)/p(x,z) $
]

#slide[
  == The Rule of Bayes (Bayes' Theorem)

  #place(top+left, dy:2cm)[
    $x$: observed variables\
    $z$: latent variables
  ]

  #align(horizon)[#text(25pt)[$ p(z | x) = p(x, z) / p(x) = (p(x | z) dot p(z)) / p(x) $]]

  #pause

  #place(top+left, dx: 2.5cm, dy: 6cm)[
    #cetz.canvas({
      cetz.draw.set-style(content: (padding: 2pt))
      cetz.draw.content((0,0), [posterior], name: "label")
      cetz.draw.line("label.south-east", (3,-1), mark: (end: ">"))
    })
    ]

  #pause

  #place(top+right, dx: -3cm, dy: 5.5cm)[
    #cetz.canvas({
      cetz.draw.set-style(content: (padding: 2pt))
      cetz.draw.content((0,0), [prior], name: "label")
      cetz.draw.line("label.south-west", (-3,-1), mark: (end: ">"))
    })
  ]  

  #pause

  #place(top+right, dx: -7.5cm, dy: 4cm)[
    #cetz.canvas({
      cetz.draw.set-style(content: (padding: 3pt))
      cetz.draw.content((0,0), [likelihood], name: "label")
      cetz.draw.line("label.south", (-1,-2), mark: (end: ">"))
    })
  ]
  
  #pause

  #place(top+left, dx: 10cm, dy: 4cm)[
    #cetz.canvas({
      cetz.draw.set-style(content: (padding: 3pt))
      cetz.draw.content((0,0), [joint], name: "label")
      cetz.draw.line("label.south", (1,-2), mark: (end: ">"))
    })
  ]
  
  #pause

  #place(bottom+center, dx: 1.5cm, dy: -3cm)[
    #cetz.canvas({
      cetz.draw.set-style(content: (padding: 2pt))
      cetz.draw.content((0,0), [evidence], name: "label")
      cetz.draw.line("label.north-west", (-2,1), mark: (end: ">"))
      cetz.draw.line("label.north-east", (2,1), mark: (end: ">"))
    })
  ]
]


#slide[
  #let neg(x) = $accent(#x, "-")$
  == Finding Spam

  - 10% of my email is spam
  - 90% of all spam emails contain the word "urgent"
  - 20% of all non-spam emails contain the word "urgent"

  #pause
  I get an email containing the word "urgent". Is it spam or not?

  #pause
  #align(center)[
    #table(columns:3)[
    ][*$s$*][*#neg[s]*][
      *$u$*
    ][9%][18%][
      *#neg[u]*
    ][1%][72%]
  ]

  #pause
  $ p(s|u) = p(u,s)/p(u) = p(u,s) / (p(u,s) + p(u,#neg[s])) = 0.09 / (0.09 + 0.18) = 0.09 / 0.27 = 1/3
  $
]

#slide[
  == Finding the Posterior Distribution

  #place(top+left, dy:2cm)[
    $x$: observed variables\
    $z$: latent variables\
    #uncover("2-")[$D$: data]
  ]

  #place(bottom+left, dy: 0cm)[
    #uncover("3-")[
      #align(left)[
        #text(green)[*constant*]\
        #text(blue)[*distribution*]\
        #text(orange)[*function*]
      ]
    ]
  ]

  #only(1, align(horizon)[#text(25pt)[$ p(z | x) = p(x, z) / p(x) = (p(x | z) dot p(z)) / p(x) $]])
  #only("2-", align(horizon)[#text(25pt)[$ p(z | x=D) = p(x=D, z) / p(x=D) = (p(x=D | z) dot p(z)) / p(x=D) $]])

  #pause
  #pause
  
  #place(top+left, dx: 1.5cm, dy: 5cm)[
    #cetz.canvas({
      cetz.draw.set-style(content: (padding: 2pt))
      cetz.draw.content((0,0), name: "label", anchor:"south")[
        #alternatives-match(position: center+bottom, (
          "-3": [posterior],
          "4-": align(center)[$Z -> bb(P)$\ #text(blue)[posterior]],
        ))
      ]
      cetz.draw.line("label.south-east", (3,-1), mark: (end: ">"))
    })
    ]

  #place(top+right, dx: -2cm, dy: 4cm)[
    #cetz.canvas({
      cetz.draw.set-style(content: (padding: 2pt))
      cetz.draw.content((0,0), name: "label", anchor:"south")[
        #alternatives-match(position: center+bottom, (
          "-3": [prior],
          "4-": align(center)[$Z -> bb(P)$\ #text(blue)[prior]],
        ))
      ]
      cetz.draw.line("label.south-west", (-2,-1), mark: (end: ">"))
    })
  ]  

  #place(top+right, dx: -7.5cm, dy: 3cm)[
    #cetz.canvas({
      cetz.draw.set-style(content: (padding: 3pt))
      cetz.draw.content((0,0), name: "label", anchor:"south")[
        #alternatives-match(position: center+bottom, (
          "-3": [likelihood],
          "4-": align(center)[$Z -> bb(R)$\ #text(orange)[likelihood]],
        ))
      ]
      cetz.draw.line("label.south", (0,-2), mark: (end: ">"))
    })
  ]
  
  #place(top+left, dx: 10cm, dy: 3cm)[
    #cetz.canvas({
      cetz.draw.set-style(content: (padding: 3pt))
      cetz.draw.content((0,0), name: "label", anchor:"south")[
        #alternatives-match(position: center+bottom, (
          "-3": [join],
          "4-": align(center)[$Z -> bb(R)$\ #text(orange)[joint]],
        ))
      ]
      cetz.draw.line("label.south", (1,-2), mark: (end: ">"))
    })
  ]
  
  #place(bottom+center, dx: 1.5cm, dy: -2cm)[
    #cetz.canvas({
      cetz.draw.set-style(content: (padding: 2pt))
      cetz.draw.content((0,0), name: "label", anchor:"north")[
        #alternatives-match(position: center+top, (
          "-3": [evidence],
          "4-": align(center)[#text(green)[evidence]\ $bb(P)$],
        ))
      ]
      cetz.draw.line("label.north-west", (-2,1), mark: (end: ">"))
      cetz.draw.line("label.north-east", (2,1), mark: (end: ">"))
    })
  ]
]

#slide[
  == The Problem

  Computing $p(x=D)$ is hard (often impossible)!

  #pause

  Solutions:
  #side-by-side[
    sample from $p(z | x)$
    #image("img/sample_hist.svg", width: 100%)
  ][
    approximate $p(z | x)$
    #image("img/vi_step3.svg", width: 100%)
  ]
]
