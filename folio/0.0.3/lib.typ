#let dark-blue = rgb("1C559C")
#let darker-blue = rgb("0b2c74")
#let light-blue = rgb("3FA3D2")
#let background = rgb("F3ECE2")
#let secondary = rgb("f75d2f")
#let solutions_color = red.darken(25%)

#let layouts = (
  "small": ("height": 9cm, "space": 1.4cm),
  "medium": ("height": 10.5cm, "space": 1.6cm),
  "large": ("height": 12cm, "space": 1.8cm),
)
#let layout-space = state("space", v(-0.8cm))

#show outline.entry: it => {
  show linebreak: [ ]
  it
}

#let title-slide(content) = {
  let book = false // set this to false to remove the book texture
  set page(footer: none)
  set page(background: {
    if book {
      stack(
        image(width: 100%, height: 100%, "assets/book.jpg"),
        place(dy: -16.7cm, align(left, rect(height: 1fr, width: 4em, fill: dark-blue))),
        place(dy: -16.7cm, dx: 4em, rect(
          fill: background.transparentize(40%),
          width: 100%,
          height: 100%,
        )),
      )
    } else {
      align(left, rect(height: 100%, width: 4em, fill: dark-blue))
    }
  })
  set align(horizon + center)
  context layout-space.get()
  content
  pagebreak(weak: true)
}

#let soluce = state("solution", false);

#let folio(
  content,
  title: none,
  subtitle: none,
  date: none,
  location: "",
  authors: (),
  logo: none,
  layout: "medium",
  ratio: 16 / 9,
  title-color: none,
  subslide-numbering: none,
  show_solution: false,
  wide-title: false,
  mode: "slides",
) = {
  if "solutions" in sys.inputs.keys() {
    if sys.inputs.solutions == "true" {
      show_solution = true
    } else if sys.inputs.solutions == "false" {
      show_solution = false
    }
  }
  soluce.update(d => show_solution)

  // Page setup
  set page(
    paper: "presentation-16-9",
    fill: background,
    margin: (
      right: 2em,
      left: 2.5em,
      top: 3em,
      bottom: 2em,
    ),
    numbering: (..n) => {
      place(dx: 95%, dy: 0pt, (text(size: 12pt, fill: dark-blue, numbering("1/1", ..n))))
    },
  )

  set text(
    // font: "Futura",
    font: "IBM Plex Sans",
    size: 16pt,
    weight: 500,
  )

  set outline(target: heading.where(level: 1), title: none)
  set bibliography(title: none)

  // Title styling
  show title: set text(weight: "bold", fill: rgb("1C559C"))

  // Title slide
  if title != none {
    if (type(authors) != array) {
      authors = (authors,)
    }
    if logo == none {
      logo = "assets/logo.png"
    }
    title-slide[
      #if show_solution {
        place(
          top,
          dx: 35pt,
          dy: 5pt,
          rotate(
            -5deg,
            block(
              stroke: 2pt + secondary,
              inset: 1em,
              text(
                fill: secondary,
                weight: "bold",
                font: "New Computer Modern Mono",
                size: 24pt,
              )[SOLUTIONS INCLUDED],
            ),
          ),
        )
      }
      #let columns = {
        if (wide-title) {
          (10%, 1fr)
        } else {
          (45%, 1fr)
        }
      }
      #align(center + horizon, grid(
        columns: columns,
        h(1fr),
        align(left, stack(
          v(1fr),
          spacing: .8em,
          {
            set par(leading: .3em)
            upper(text(size: 50pt, title, spacing: .5em))
            v(1em)
          },
          text(subtitle, light-blue, weight: "bold", size: 40pt),
          v(1.5fr),
          ..authors.map(a => if title in a.keys() {
            text(weight: "bold", size: 16pt, light-blue)[#a.name]
            text(weight: "bold", size: 16pt, light-blue)[, #a.title]
          } else {
            text(weight: "bold", size: 16pt, light-blue)[#a.name]
          }),
          v(0.5fr),
          text(size: 16pt, light-blue, location, weight: "medium"),
          v(1.5fr),
          image(height: 1.6cm, logo),
          v(0fr),
        )),
      ))
    ]
  }

  counter(page).update(1)

  // Heading styles
  show heading.where(level: 1): x => {
    pagebreak()
    set text(size: 36pt, weight: "bold", fill: dark-blue)
    x
    parbreak()
  }

  show heading.where(level: 2): x => {
    set text(size: 30pt, weight: "bold", fill: dark-blue)
    parbreak()
    x
    parbreak()
  }

  show heading.where(level: 3): x => {
    parbreak()
    set text(size: 20pt, weight: "bold", fill: darker-blue)
    x
    parbreak()
  }

  // List styling
  set list(
    marker: text(fill: darker-blue, sym.circle.filled),
    body-indent: 1em,
  )

  // Enum styling
  set enum(
    body-indent: 1em,
    numbering: (..nums, last) => {
      text(
        fill: darker-blue,
        size: 14pt,
        weight: "bold",
        numbering(("1", "1").at(nums.pos().len(), default: "I)"), last),
      )
    },
  )

  // Strong text
  show strong: set text(fill: darker-blue, weight: "bold")

  // Raw/code blocks
  // show raw: set text(font: "New Computer Modern Mono")
  show raw: it => {
    if (it.block) {
      block(
        width: 100%,
        inset: (x: 15pt, y: 15pt),
        radius: 5pt,
        fill: background.lighten(40%),
        stroke: 1pt + background.darken(10%),
        it,
      )
    } else {
      box(
        fill: background.lighten(30%),
        stroke: 0.5pt + background.darken(10%),
        baseline: 15%,
        outset: (y: 3pt),
        inset: (x: 6pt, y: 2pt),
        radius: 3pt,
        it,
      )
    }
  }

  // Table styling
  set table(stroke: 1pt + background.darken(10%), fill: background.lighten(30%))
  set table.cell(inset: 10pt)
  show table: set text(15pt, fill: background.darken(80%))

  // Link styling
  show link: it => {
    set text(fill: dark-blue)
    underline(it)
  }

  content
}

// Solution boxes
#let solution(title: "Solution: ", no_title: false, new_page: false, content) = {
  context if soluce.get() {
    set text(fill: solutions_color)
    show strong: set text(fill: solutions_color)
    set list(
      marker: text(fill: solutions_color, sym.circle.filled),
      body-indent: 1em,
    )
    set enum(
      numbering: (..nums, last) => {
        text(
          fill: solutions_color,
          size: 14pt,
          weight: "bold",
          numbering(("1", "1").at(nums.pos().len(), default: "I)"), last),
        )
      },
    )
    if new_page == true [
      #pagebreak()
    ]
    block(
      if title.len() == 0 {} else { title } + content,
    )
  }
}

#let todo(message, title: "TODO") = {
  set text(fill: white)
  box(
    stroke: 1pt + red,
    fill: red,
    inset: 2pt,
    outset: 2pt,
  )[
    #title : #message
  ]
}


#let frame(
  title,
  content,
  title-color: rgb("C9A97E"),
  title-text-color: white,
  content-color: rgb("EDE2D4"),
  content-text-color: rgb("48361E"),
) = {
  block(
    breakable: false,
    stack(
      dir: ttb,
      rect(radius: (top: 5pt), fill: title-color, width: 100%, inset: 10pt)[
        #set text(size: 16pt, fill: title-text-color)
        #title
      ],
      rect(radius: (bottom: 5pt), fill: content-color, width: 100%, inset: (x: 15pt, y: 20pt))[
        #set text(size: 16pt, fill: content-text-color)
        #content
      ],
    ),
  )
}

#let def-counter = counter("definition")

#let definition(head, body) = {
  context let id = def-counter.get()
  def-counter.step()
  frame(
    [ Definition #context def-counter.display(): #head],
    body,
    title-color: dark-blue,
    content-color: dark-blue.lighten(80%),
    content-text-color: rgb("071C4B"),
  )
}
