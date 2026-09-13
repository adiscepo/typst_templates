#import "@preview/hydra:0.6.0": hydra // Template pour les headers
#import "theme.typ": *

#let soluce = state("solution", false)

#let ulb-practicals(
  title: "",
  university: "UNIVERSITÉ LIBRE DE BRUXELLES, UNIVERSITÉ D’EUROPE",
  faculty: "Faculté des Sciences — Département d'Informatique",
  footer: "MEMBRE DE L’ACADÉMIE UNIVERSITAIRE WALLONIE-BRUXELLES ET DU PÔLE UNIVERSITAIRE EUROPÉEN BRUXELLES-WALLONIE",
  authors: (),
  course: "Définir le nom du cours avec l'attribut `course`",
  logo: "assets/ulb_logo.jpg",
  show_solution: false,
  body,
) = {
  if "solutions" in sys.inputs.keys() {
    if sys.inputs.solutions == "true" {
      show_solution = true
    } else if sys.inputs.solutions == "false" {
      show_solution = false
    }
  }
  soluce.update(d => show_solution)

  // Set the document's basic properties.
  set document(author: authors.map(a => a.name), title: title)
  set text(font: fonts.main)
  show math.equation: set text(font: fonts.sans, weight: 400)
  set heading(numbering: "1.1")
  set terms(hanging-indent: 30pt)
  set par(first-line-indent: 0pt, spacing: 11pt)
  set text(size: text-size.base, lang: "fr", hyphenate: true)
  show raw: set text(font: "New Computer Modern Mono", size: text-size.code)

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

  // Set the page properties (header and footer)
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

  // Set figure properties (full width)
  set figure.caption(separator: " - ")
  show figure.caption: it => smallcaps(it)
  show figure: it => {
    align(left, box(width: 100%, it.body))
    align(center, box(it.caption))
  }
  show figure.where(kind: raw): set figure(supplement: "Listing")

  // ---- The document starts here ----
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
  set enum(spacing: 12pt)
  counter(page).update(1)

  set heading(numbering: "1.1")

  // The actual content of the document
  body
}

#let exercice_counter = counter("exercices")

#let exercice(body, solution: content) = {
  exercice_counter.step()
  set list(marker: [---], indent: 10pt)
  block(breakable: false, {
    v(5pt)
    line(length: 100%, stroke: (thickness: 0.4pt))
    strong(text("Exercice " + context exercice_counter.display() + ".", fill: colors.ulb))
    {
      show text: it => emph(it)
      body
    }
    v(1pt)
    context if state("solution").get() {
      strong(text("Réponse", fill: colors.ulb) + " :")
      solution
    }
  })
}
