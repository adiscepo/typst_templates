#import "@preview/hydra:0.6.0": hydra // Template pour les headers

#let ulb-thesis-proposal(
  title: "",
  abstract: "",
  authors: (),
  logo: "assets/ulb_logo.jpg",
  body
) = {
  // Set the document's basic properties.
  set document(author: authors.map(a => a.name), title: title)
  show math.equation: set text(font: "STIX Two Math", weight: 400)
  set text(font: "Linux Libertine")
  set heading(numbering: "1.1")
  set par(first-line-indent: 0pt)
  set text(size: 1.1em)
  show heading: it => {
    v(10pt)
    text(it)
    v(5pt)
  }

  // Title page.
  v(0.25fr)
  align(center, text(weight: "regular", ("Université Libre de Bruxelles"), size: 2em))
  v(0.15fr)
  align(center, line(length: 75%))
  align(center)[
    #text(2em, weight: 700, smallcaps(title))
  ]

  // Author information.
  pad(
    top: 0.7em,
    align(center, 
    box(
      width: 70%,
      grid(
          columns: (1fr, 1fr),
          gutter: 5em,
          align(left,
            emph(authors.at(0).status) + ":" + linebreak() + authors.at(0).name
          ),
          align(right,
            emph(authors.at(1).status) + ":" + linebreak() + authors.at(1).name
          ),
        )
      )
    )  
  )

  // Logo
  if logo != none {
    v(0.50fr)
    align(center, image(logo, width: 26%))
    v(0.25fr)
  } else {
    v(0.75fr)
  }

  pagebreak()

  // Abstract page.
  set page(numbering: "I", number-align: center)
  if (abstract != "") {
  v(1fr)
  align(center)[
    #heading(
      outlined: false,
      numbering: none,
      text(0.85em, smallcaps[Abstract]),
    )
  ]
  abstract
  v(1.618fr)
  pagebreak()
  }
  counter(page).update(1)

  // Table of contents.
  outline(depth: 2, title: "Table of Contents")

  set text(size: 12pt, spacing: 3pt)
  set enum(spacing: 40pt)
  set page(numbering: "1", number-align: center, margin: (top : 2.5cm, left: 3.5cm, right: 3cm, bottom: 2.5cm))
  set par(first-line-indent: 0pt, leading: 0.5em) // Espacement entre les lignes
  counter(page).update(1)
  
  set page(header: context {
    if calc.odd(here().page()) {
      align(right, emph(hydra(1)))
    } else {
      align(left, emph(hydra(2)))
    }
    line(length: 100%)
  })
  set heading(numbering: "1.1")
  // show heading.where(level: 1): it => pagebreak(weak: true) + it
  body
}
