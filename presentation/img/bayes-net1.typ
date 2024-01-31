#import "@preview/cetz:0.1.2"

#set page(width: auto, height: auto, margin: 1pt)
#set text(size: 20pt)
#set text(lang: "en")

#cetz.canvas({
  import cetz.draw: *
  
  circle((0,0), radius: .5, name: "a")
  content((0,0), [$a$])
  circle((2,1), radius: .5, name: "b")
  content((2,1), [$b$])
  circle((4,0), radius: .5, name: "c")
  content((4,0), [$c$])
  line("a.top-right", "b.left", mark: (end: ">"))
  line("b.right", "c.top-left", mark: (end: ">"))
  line("a.right", "c.left", mark: (end: ">"))
})
