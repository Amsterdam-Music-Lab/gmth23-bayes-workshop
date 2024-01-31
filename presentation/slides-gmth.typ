#import "@preview/polylux:0.3.1": *
#import themes.simple: *
#import "@preview/cetz:0.1.1"

#show: simple-theme

#set text(size: 20pt)
#set text(lang: "de")

#title-slide[
  = Modellbasierte Korpusforschung \ und Bayessche Statistik

  == Workshop
  
  Christoph Finkensiep #footnote[
    Universiteit van Amsterdam, #link("mailto:c.finkensiep@lva.nl")
  ],
  Martin Rohrmeier #footnote[
    École Polytechnique Fédérale de Lausanne, #link("mailto:martin.rohrmeier@epfl.ch")
  ]
  
  GMTH Jahreskongress, Freiburg 23.09.2023
]

#slide[
  == Agenda

  - Theorie
    - Modelle
    - Wahrscheinlichkeiten (basics)
    - Bayessche Inferenz
  - Praxis
    - Probabilistic Programming
    - Ausführliches Beispiel

  
  
  Vorwissen: Bruchrechnung, Dreisatz
]

#centered-slide[
  = Modelle, Wahscheinlichkeiten, Inferenz
]

#slide[
  == Das Problem
  
  Ich habe einen Datensatz erhoben / annotiert / berechnet. Was nun? 
  
  Statistik ist kompliziert...
  
  - viele verschiedene Methoden
  - Annahmen und Implikationen nicht offensichtlich
  - Was mache ich in komplexen Fällen?

]

#slide[
  == Der Ansatz

  #side-by-side(columns: (1fr, 10em))[
    Modelle!
    
    - beschreiben einen Ausschnitt der Welt (vereinfacht)
    - relevante *Objekte* und *Beziehungen*
    - explizite *Annahmen*
    - erlauben *Simulation* und *Inferenz*
    
      #set text(20pt)
      #align(
        center,
        cetz.canvas(length: 2cm, {
          import cetz.draw: *
          
          set-style(content: (padding: 10pt))
          
          content((-1,0), [Modell], name: "model", frame: "rect")
          content((0,-1), [Beobachtungen], name: "obs")
          content((0,1), [Schlüsse], name: "z")
          line("obs.top", "z.bottom", mark: (end: ">"), name: "inf-line")
          line("model.right", "inf-line")
          content("inf-line", [_Inferenz_], anchor: "left")

          set-style(stroke: gray)
          
          content((-2.5,1), text(gray)[Annahmen], anchor: "right", name: "assum")
          line("model.left", "assum.right")
          content((-2.5,0), text(gray)[Objekte], anchor: "right", name: "obj")
          line("model.left", "obj.right")
          content((-2.5,-1), text(gray)[Beziehungen], anchor: "right", name: "rel")
          line("model.left", "rel.right")
        })
      )
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
  == Basics: Verteilungen

  #v(-1em)
  Zufallsvariable $X$:
  
  #side-by-side(columns: (1fr,1fr,0fr))[
      diskret: "Massefunktion" $p(x)$

      #{
        let data = for s in range(2,13) { ((s, (6-calc.abs(s - 7)) / 36),) }
        set text(size: 15pt)
        cetz.canvas({
          import cetz.draw: *
          cetz.chart.columnchart(data,
                                 size: (auto, 5),
                                 y-tick-step: 0.1,                                 
                                 bar-style: (i) => if i in (2,4) {(fill:blue)} else {(fill:silver)})
          content((10,4), [$ sum_x p(x) = 1 $], frame: "rect", padding: 2pt, fill: white, stroke: none)
        })
      }
  ][
      kontinuierlich: "Dichtefunktion" $p(x)$

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
          content((8,4), [$ integral p(x) dif x = 1 $], frame: "rect", padding: 8pt, fill: white, stroke: none)
        })
      }
  ][
    #v(11em)
  ]

  #v(-1em)
  #side-by-side()[
    #align(horizon)[$ P(X in {4, 6}) = p(4) + p(6) $]
  ][
    #align(horizon)[$ P(2.5 <= X <= 4) = integral_(2.5)^4 p(x) dif x $]
  ]
]

#slide[
  == Basics: Die Grundrechenarten

  

  #side-by-side(columns: (1fr, 1fr))[
    Gemeinsame Verteilung:
    $ p(x, y) $
  ][
    
    
      #table(columns: 5,
             stroke: none,
             [], [*c*], [*d*], [*e*], [...],
             [*Dur*], [0.5], [0.04], [0.02], [...],
             [*Moll*], [0.09], [0.12], [0.08], [...],
             )
  ]

  

  #side-by-side(columns: (1fr, 1fr))[
    Randverteilung:
    $ p(x) = sum_y p(x,y) $
  ][
      #v(1.2em)
      #table(columns: 7,
             stroke: none,
             [*Dur*], [0.7], h(1.5em),[*c*], [*d*], [*e*], [...],
             [*Moll*], [0.3], [],
             [#calc.round(0.5/0.7, digits: 2)],
             [#calc.round(0.04/0.7, digits: 2)],
             [#calc.round(0.02/0.7, digits: 2)],
             [...],
             )
  ]

  
  
  #side-by-side(columns: (1fr, 1fr))[
    Bedingte Verteilung:
    $ p(x|y) = p(x,y)/p(y) $
  ][
      #table(columns: 6,
             stroke: none,
             [], [*c*], [*d*], [*e*], [...], [],
             [*Dur*],
             [#calc.round(0.5/0.7, digits: 2)],
             [#calc.round(0.04/0.7, digits: 2)],
             [#calc.round(0.02/0.7, digits: 2)],
             [...],
             [$= 1$],
             [], [], [], [] ,[], [],
             [*Moll*],
             [#calc.round(0.09/0.3, digits: 2)],
             [#calc.round(0.12/0.3, digits: 2)],
             [#calc.round(0.08/0.3, digits: 2)],
             [...],
             [$= 1$],
             )
  ]
]

#slide[
  == Inferenz

  #v(-1em)

  #align(center)[
    #set text(size: 20pt)
    #box[
      #cetz.canvas(length: 2cm, {
        import cetz.draw: *
        set-style(content: (padding: 10pt))
        
        content((0,1), [Startzustand], name: "z")
        content((0,-1), [Ergebnis], name: "x")
        content((2,1), [Parameter], name: "params")
        content((0,0), [Prozess], name: "proc", frame: "rect")
        line("z.bottom", "proc.top")
        line("proc.bottom", "x.top", mark: (end: ">"))
        line("params.bottom", "proc.top-right")
      })
    ]
    
    #box[
      #cetz.canvas(length: 2cm, {
        import cetz.draw: *
        set-style(content: (padding: 10pt))
        
        content((4.5,1), [Idee / Ziel], name: "z_m")
        content((4.5,-1), [Werk], name: "x_m")
        content((6.5,-1), [Korpus], name: "xs_m")
        content((6.5,1), [Stil], name: "params_m")
        content((4.5,0), [Komposition], name: "proc_m", frame: "rect")
        line("z_m.bottom", "proc_m.top")
        line("proc_m.bottom", "x_m.top", mark: (end: ">"))
        line("proc_m.bottom", "xs_m.top-left", mark: (end: ">"))
        line("params_m.bottom", "proc_m.top-right")
      })
    ]
    
    #box[
      #cetz.canvas(length: 2cm, {
        import cetz.draw: *
        set-style(content: (padding: 10pt))

        content((9.5, 1), [_latente_ Variablen ($z$ / $theta$)], name: "latent")
        content((9.5, -1), [_beobachtete_ Variablen ($x$)], name: "obs")
        content((9.5, 0), [$ p(x | z) $], name: "likelihood", frame: "rect")
        line("latent.bottom", "likelihood.top")
        line("likelihood.bottom", "obs.top", mark: (end: ">"))
      })
    ]

    

    #v(1em)
    
    #align(center)[
      Inferenz
      
      #table(
        columns: 3,
        stroke: none,
        align(horizon)[$ p(z | x) $],
        align(horizon)[$ = p(x, z) / p(x) $],
        align(horizon)[$ = (p(x | z) dot p(z)) / p(x) $],
      )
    ]
    
  ]
]

#slide[
  == Der Satz von Bayes

  #place(top+left, dy:2cm)[
    $x$: beobachtete Variablen\
    $z$: latente Variablen
  ]

  #align(horizon)[#text(25pt)[$ p(z | x) = p(x, z) / p(x) = (p(x | z) dot p(z)) / p(x) $]]

  

  #place(top+left, dx: 2.5cm, dy: 6cm)[
    #cetz.canvas({
      cetz.draw.set-style(content: (padding: 2pt))
      cetz.draw.content((0,0), [posterior], name: "label")
      cetz.draw.line("label.bottom-right", (3,-1), mark: (end: ">"))
    })
    ]

  

  #place(top+right, dx: -3cm, dy: 5.5cm)[
    #cetz.canvas({
      cetz.draw.set-style(content: (padding: 2pt))
      cetz.draw.content((0,0), [prior], name: "label")
      cetz.draw.line("label.bottom-left", (-3,-1), mark: (end: ">"))
    })
  ]  

  

  #place(top+right, dx: -7.5cm, dy: 4cm)[
    #cetz.canvas({
      cetz.draw.set-style(content: (padding: 3pt))
      cetz.draw.content((0,0), [likelihood], name: "label")
      cetz.draw.line("label.bottom", (-1,-2), mark: (end: ">"))
    })
  ]
  
  

  #place(top+left, dx: 10cm, dy: 4cm)[
    #cetz.canvas({
      cetz.draw.set-style(content: (padding: 3pt))
      cetz.draw.content((0,0), [joint], name: "label")
      cetz.draw.line("label.bottom", (1,-2), mark: (end: ">"))
    })
  ]
  
  

  #place(bottom+center, dx: 1.5cm, dy: -3cm)[
    #cetz.canvas({
      cetz.draw.set-style(content: (padding: 2pt))
      cetz.draw.content((0,0), [evidence], name: "label")
      cetz.draw.line("label.top-left", (-2,1), mark: (end: ">"))
      cetz.draw.line("label.top-right", (2,1), mark: (end: ">"))
    })
  ]
]

#let (dur, moll) = (112, 36)
#let beta(a, b) = (x) => calc.pow(x, a - 1) * calc.pow(1 - x, b - 1)

#slide[
  == Beispiel: Dur oder Moll?

  #side-by-side(columns:(1fr, 1.5fr))[
    #side-by-side[
      Beobachtet:
      #table(
        columns: 2, stroke: none,
        [Dur:], [#dur],
        [Moll:], [#moll],
      )
    ][
      #table(
        columns: 2, stroke: none,
        [1], [Dur],
        [2], [Dur],
        [3], [Moll],
        [4], [Dur],
        [...]
      )
    ]

    
    
    Modell (Prozess):
    - wähle Wahrscheinlichkeit $theta$
    - für jedes Stück:
      - wirf Münze mit Wk. $theta$
        - Kopf: Dur
        - Zahl: Moll
  ][
    
    Likelihood:
    $ p(accent(x, arrow) | theta) = product_i p(x_i | theta) =
      product_i cases(theta & (x_i = "Dur"), 1-theta & (x_i = "Moll"))
    $

    #side-by-side[
      

      #{
        let bern(ps) = for p in ps { ((p, p, 1 - p),) }
        let bstyle(i) = if i==0 {
          (stroke: black, fill: blue)
        } else {
          (stroke: black, fill: orange)
        }
        set text(size: 15pt)
        cetz.canvas({
          cetz.chart.columnchart(bern((0.2, 0.35, 0.5, 0.7, 0.9)),
                                 size: (auto, 3),
                                 mode: "clustered",
                                 value-key: (1,2),
                                 y-tick-step: 0.2,
                                 x-label: $theta$,
                                 bar-style: bstyle)
          cetz.draw.content((0,3.5), anchor: "bottom-left")[
            #box(baseline: -2pt, rect(width: 5pt, height: 5pt, fill:blue, stroke:black)) Dur #h(1em)
            #box(baseline: -2pt, rect(width: 5pt, height: 5pt, fill:orange, stroke:black)) Moll
          ]
      // cetz.chart.columnchart(bern(0.2), size: (3, 3), y-tick-step: 0.2)
      // cetz.chart.columnchart(bern(0.2), size: (3, 3), y-tick-step: 0.2)
        })
      }
    ][
      

      #set text(size: 15pt)
      $ p(accent(x, arrow) | z) $
      #v(-7pt)
      #{
        let lk(theta) = calc.pow(theta, dur) * calc.pow(1 - theta, moll)
        let opt = dur / (dur + moll)

        cetz.canvas({
          import cetz.plot
          
          plot.plot(size: (6,3),
                    name: "ml-plot",
                    x-tick-step: 0.2,
                    // y-tick-step: 0.1
                    // y-max: 0.45,
                    x-label: $theta$,
                    y-label: $p$,
                    axis-style:"scientific", {
                      plot.add(lk, domain: (0, 1), samples: 200, style: (stroke: blue))
                      plot.add-anchor("opt-base", (opt, 0))
                      plot.add-anchor("opt-top", (opt, "max"))
          })
          //cetz.draw.line("ml-plot.opt-base", "ml-plot.opt-top")
        })
      }
    ]

    
    #v(-1em)
    $ max_theta p(accent(x, arrow) | theta) = #dur / (#dur + #moll) = #calc.round(dur/(dur+moll), digits: 3) $
  ]
]

#slide[
  == Make it Bayessch

  #side-by-side(columns:(1fr, 1.5fr))[
    $ p(theta | accent(x, arrow)) = (p(accent(x, arrow) | theta) dot p(theta)) / p(accent(x, arrow)) $

    
    
    Modell:
    - wähle $theta tilde op("Uniform")(0, 1)$\
      (oder $theta tilde op("Beta")(0.5, 0.5)$)
    - für jedes Stück $i$:
      - wähle $x_i tilde op("Bernoulli")(theta)$

    #v(1em)
      Problem:

      $ p(accent(x, arrow)) = integral p(accent(x, arrow), theta) dif theta "???" $
  ][
    #set text(size: 15pt)

    
    
    #v(-3cm)
    #cetz.canvas({
      import cetz.plot
      import cetz.draw: *
      // cetz.draw.set-style(content: (padding: 3pt))

      group(name: "prior-g", {
        anchor("default", (0,0))
        plot.plot(size: (6,2),
                  name: "prior",
                  x-tick-step: 0.2,
                  y-tick-step: 1,
                  y-max: 1.2,
                  y-min: 0,
                  x-label: $theta$,
                  y-label: $p$,
                  axis-style:"school-book", {
                    plot.add((x) => 1, domain: (0, 1), style: (stroke: blue))
        })
        content("prior.top", anchor: "bottom", [$ p(theta) = op("Uniform")(0, 1) $])
      })

      set-origin("prior-g.bottom-right")
      group(name: "posterior-g", anchor: "bottom-left", {
        anchor("default", (0,0))
        plot.plot(size: (6,2),
                  name: "posterior",
                  x-tick-step: 0.2,
                  // y-tick-step: 1,
                  // y-max: 1.2,
                  y-min: 0,
                  x-label: $theta$,
                  y-label: $p$,
                  axis-style:"school-book", {
                    plot.add(beta(dur+1, moll+1), domain: (0, 1), samples: 200, style: (stroke: blue))
        })
        content("posterior.top", anchor: "bottom", [$ p(theta | accent(x, arrow)) $])
      })
    })

    
    
    #v(1em)
    #cetz.canvas({
      import cetz.plot
      import cetz.draw: *

      group(name: "prior-g", {
        anchor("default", (0,0))
        plot.plot(size: (6,2),
                  name: "prior",
                  x-tick-step: 0.2,
                  y-tick-step: 100,
                  // y-max: 1.2,
                  y-min: 0,
                  x-label: $theta$,
                  y-label: $p$,
                  axis-style:"school-book", {
                    plot.add(beta(0.5, 0.5), domain: (0.01, 0.99), samples: 200, style: (stroke: blue))
        })
        content("prior.top", anchor: "bottom", [$ p(theta) = op("Beta")(0.5, 0.5)$])
      })

      set-origin("prior-g.bottom-right")
      group(name: "posterior-g", anchor: "bottom-left", {
        anchor("default", (0,0))
        plot.plot(size: (6,2),
                  name: "posterior",
                  x-tick-step: 0.2,
                  // y-tick-step: 1,
                  // y-max: 1.2,
                  y-min: 0,
                  x-label: $theta$,
                  y-label: $p$,
                  axis-style:"school-book", {
                    plot.add(beta(dur+0.5, moll+0.5), domain: (0, 1), samples: 200, style: (stroke: blue))
        })
        content("posterior.top", anchor: "bottom", [$ p(theta | accent(x, arrow)) $])
      })
    })

    

    #v(1em)
    #cetz.canvas({
      import cetz.plot
      import cetz.draw: *
      //cetz.draw.set-style(content: (padding: 3pt))

      group(name: "prior-g", {
        anchor("default", (0,0))
        plot.plot(size: (6,2),
                  name: "prior",
                  x-tick-step: 0.2,
                  y-tick-step: 100,
                  // y-max: 1.2,
                  y-min: 0,
                  x-label: $theta$,
                  y-label: $p$,
                  axis-style:"school-book", {
                    plot.add(beta(dur / 4 + 1, moll / 4 + 1), domain: (0.01, 0.99), samples: 200, style: (stroke: blue))
        })
        content("prior.top", anchor: "bottom", [ $p(theta | accent(x, arrow) times 1/4)$ ])
      })

      set-origin("prior-g.bottom-right")
      group(name: "posterior-g", anchor: "bottom-left", {
        anchor("default", (0,0))
        plot.plot(size: (6,2),
                  name: "posterior",
                  x-tick-step: 0.2,
                  // y-tick-step: 1,
                  // y-max: 1.2,
                  y-min: 0,
                  x-label: $theta$,
                  y-label: $p$,
                  axis-style:"school-book", {
                    plot.add(beta(dur * 4 + 1, moll * 4 + 1), domain: (0, 1), samples: 200, style: (stroke: blue))
        })
        content("posterior.top", anchor: "bottom", [ $p(theta | accent(x, arrow) times 4)$])
      })
    })
  ]
]

#centered-slide[
  = Probabilistic Programming
]

#slide[
  == Ein Modell als Programm

  #side-by-side(columns: (1fr, 1.5fr))[
    Tonart wählen:
    
    - wähle $theta tilde op("Uniform")(0, 1)$
    - für jedes Stück $i$:
      - wähle $x_i tilde op("Bernoulli")(theta)$

    #only(2)[#fit-to-height(1fr)[#align(center, image("img/samples.svg"))]]
  ][
    #only(1)[
      ```python
      def generate_keys(n):
        theta = uniform(0, 1)
        xs = []
        for i in range(n):
          maj = bernoulli(theta)
          xs.append("d" if maj else "m")
        return xs
      ```
    ]
    #only("2-")[
      ```python
      import pymc as pm
      import arviz as az

      keys = [0, 0, 1, 0, ...]
      
      with pm.Model() as model:
        theta = pm.Uniform("theta", 0, 1)
        pm.Bernoulli("obs", p=theta, observed=keys)
      
      with model:
        idata = pm.sample(5000, chains=2)
      
      az.plot_posterior(idata)
      ```
    ]
  ]
]

#focus-slide(background: black)[
  Ausführliches Beispiel: Notebook

  #link("https://github.com/Amsterdam-Music-Lab/gmth23-bayes-workshop/")[
    #image("img/qr-repo.png", width:8cm)
  ]
]

#slide[
  == Modellvergleich

  #align(center)[
    #{
      set text(size:15pt)
      cetz.canvas(length: 2cm, {
        import cetz.draw: *
        
        content((0,1), [$m$], name: "m", frame: "circle", padding: 3pt)
        content((-1,0), [$p(x|m_1)$], name: "m1", frame: "rect", padding: 7pt)
        content((1,0), [$p(x|m_2)$], name: "m2", frame: "rect", padding: 7pt)
        content((0,-1), [$x$], name: "x", frame: "circle", padding: 3pt)

        line("m.bottom-left", "m1.top", mark: (end: ">"))
        line("m.bottom-right", "m2.top", mark: (end: ">"))
        line("m1.bottom", "x.top-left", mark: (end: ">"))
        line("m2.bottom", "x.top-right", mark: (end: ">"))
      })
    }
  ]

  $ "Bayes Factor:" K = p(x | m_1) / p(x | m_2) = (p(m_1 | x) dot p(m_2)) / (p(m_2 | x) dot p(m_1))  $
]

#slide[
  == Weiterführendes Material

  #show link: underline

  - #link("https://www.pymc.io/")[PyMC] -- viel Material für Einsteiger
  - #link("https://pyro.ai")[pyro] -- Beispiele und Tutorials für Variational Inference
  - #link("https://num.pyro.ai/en/stable/")[numpyro] -- komplexere Modelle, setzt etwas pyro voraus
  - #link("https://www.pymc.io/projects/docs/en/stable/learn/books.html")[Bücher] über Bayesian Statistics
]
