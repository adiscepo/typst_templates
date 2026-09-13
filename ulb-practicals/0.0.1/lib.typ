#import "@preview/hydra:0.6.0": hydra // Template pour les headers
#import "theme.typ": *

#let ulb-practicals(
  title: "",
  university: "UNIVERSITÉ LIBRE DE BRUXELLES, UNIVERSITÉ D’EUROPE",
  faculty: "Faculté des Sciences — Département d'Informatique",
  footer: "MEMBRE DE L’ACADÉMIE UNIVERSITAIRE WALLONIE-BRUXELLES ET DU PÔLE UNIVERSITAIRE EUROPÉEN BRUXELLES-WALLONIE",
  authors: (),
  course: "INFO-F-201 — Systèmes d'exploitation",
  logo: "assets/ulb_logo.jpg",
  body,
) = {
  // Set the document's basic properties.
  set document(author: authors.map(a => a.name), title: title)
  set text(font: fonts.main)
  show math.equation: set text(font: fonts.sans, weight: 400)
  set heading(numbering: "1.1")
  set terms(hanging-indent: 30pt)
  set par(first-line-indent: 0pt, spacing: 11pt)
  set text(size: text-size.base, lang: "fr")
  // show "«": it => {it + h(2pt)}
  // show "»": it => {h(2pt) + it}
  show heading: it => {
    let size = if it.level == 1 {
      text-size.lg
    } else if it.level == 2 {
      12pt
    } else {
      text-size.base
    }
    v(0.3em)
    text(it, size: size)
    v(0.5em)
  }
  set page(
    numbering: "1",
    margin: (x: 65pt, y: 94.7pt),
    number-align: center,
    header-ascent: 23pt,
    header: [
      #grid(
        columns: (0.9fr, 0.1fr),
        block[
          #text(
            university,
            size: 12pt,
            fill: colors.ulb_dark,
            font: fonts.sans,
          )
          #v(1pt)
          #text(
            faculty,
            size: 9pt,
            weight: "extrabold",
            fill: colors.ulb,
            font: fonts.sans,
          )
        ],
        box(width: 1fr) + image(logo, width: 75%),
      )
    ],
    footer: context [
      #set align(center)
      #counter(page).display("1")
      #set align(left)
      #pad(y: 15pt, text(footer, size: 6pt, fill: colors.ulb_dark, font: fonts.sans))
    ],
  )

  v(45pt)
  // Title page.
  align(center)[
    #stack(
      text(course, size: text-size.base),
      v(text-size.xs),
      text(title, size: text-size.xl),
    )
  ]
  set par(justify: true)

  // Author information.
  pad(
    20pt,
    align(center, box(
      width: 318pt,
      for (i, author) in authors.enumerate() {
        text(author.name + " (" + author.office + ")", size: 12pt)
        h(35pt / 2)
        if (calc.rem-euclid(i, 2) == 1) {
          linebreak()
        }
      },
    )),
  )

  // Abstract page.
  counter(page).update(1)

  // Table of contents.
  // outline(depth: 2, title: "Table of Contents")

  // set text(size: 12pt, spacing: 3pt)
  set enum(spacing: 12pt)
  // set par(first-line-indent: 0pt, leading: 0.5em) // Espacement entre les lignes
  counter(page).update(1)

  // set page(header: context {
  //   if calc.odd(here().page()) {
  //     align(right, emph(hydra(1)))
  //   } else {
  //     align(left, emph(hydra(2)))
  //   }
  //   line(length: 100%)
  // })
  set heading(numbering: "1.1")
  // show heading.where(level: 1): it => pagebreak(weak: true) + it
  body
}
