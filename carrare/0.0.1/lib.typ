#import "@preview/hydra:0.6.2": anchor, hydra
#import "./theme.typ": fonts

#let carrare(
  title: "Title",
  subtitle: "Subtitle",
  domain: "Domain",
  date: datetime.today().display("[Year]"),
  numbering: "1.1",
  authors: ("",),
  tags: ("",),
  content,
) = {
  if type(authors) == str {
    authors = (authors,)
  }
  set page(
    margin: 6em,
    header: context {
      anchor()
      let page_nb = here().page()
      if page_nb != 1 {
        stack(
          dir: ltr,
          align(left, text(size: 8pt, font: fonts.secondary, domain)),
          align(right, text(size: 8pt, font: fonts.secondary, authors.join(", "))),
        )
      }
    },
    footer: context {
      let page_nb = here().page()
      if page_nb != 1 {
        stack(
          dir: ltr,
          align(left, text(size: 8pt, font: fonts.secondary, title)),
          align(right, text(size: 8pt, font: fonts.secondary, emph(hydra(1)))),
        )
        // line(length: 100%)
      }
      align(center, move(
        dy: if (page_nb > 1) { -20pt } else { 0pt },
        text(size: 12pt, font: fonts.secondary, weight: 900, str(page_nb)),
      ))
    },
  )
  set document(
    title: title,
    author: authors,
    keywords: domain,
  )
  set par(justify: true)
  set text(font: fonts.primary)
  show link: underline
  show ref: it => {
    if it.element.depth >= 3 {
      // For the level
      str(it.element.level) + "-" + it.element.body
    } else {
      it
    }
  }
  show footnote.entry: it => {
    show super: set text(size: 12pt)
    set text(8pt)
    // it.fields()
    text(it.note + " ") + it.note.body
    v(-3pt)
  }
  set heading(numbering: numbering)
  show heading: it => {
    if it.level <= 2 {
      let midline(..o) = line(..o, stroke: (thickness: 3pt))
      let offset = 30pt
      block[
        #set text(font: fonts.secondary)
        /// Maybe there is a better way to do that: I'm checking if there is a number (i.e the
        /// user didn't set numbering to none for the heading; if there is a numbering, we store
        /// it value in number otherwise number is the empty string
        #let number = if counter(heading).get() != (0,) { counter(heading).display() } else { "" }
        #box(midline(length: offset)) #text(weight: 300, baseline: 1.5pt, it.body) #box(
          width: 1fr,
          midline(length: 100%),
        ) #text(
          number,
          baseline: 3.5pt,
          size: 12pt,
        )
      ]
      v(15pt)
    } else {
      block[
        - #it.body
      ]
    }
  }
  // show figure: set align(left)
  set figure.caption(position: top, separator: ". ")
  show table: it => {
    set align(left)
    set text(font: fonts.tertiary)
    it
  }
  show figure.caption: it => {
    set align(left)
    it
  }
  show figure.caption: it => {
    set text(font: fonts.secondary)
    strong(emph(it))
  }

  stack(
    dir: ltr,
    stack(
      dir: ttb,
      spacing: 15pt,
      align(horizon, text(font: fonts.secondary, size: 2em, strong(title))),
      if (subtitle != none) {
        align(horizon, text(font: fonts.secondary, size: 1.2em, subtitle))
      },
    if tags != none {
      // Tags
      let colors = (blue, red, yellow, green, orange, purple)
      if tags.len() > 0 {
        stack(
          dir: ltr,
          spacing: 5pt,
          ..tags
            .enumerate()
            .map(((i, tag)) => {
              let c = colors.at(calc.rem(i, colors.len()))
              box(
                inset: (x: 4pt),
                outset: (y: 4pt),
                stroke: 0.4pt + c.darken(50%),
                fill: c.lighten(90%),
                text(tag, font: fonts.tertiary, size: 0.7em, fill: c.darken(75%)),
              )
            }),
        )
      }
    },
    ),
    align(right, stack(
      spacing: 6pt,
      dir: ttb,
      text(font: fonts.secondary, weight: "light", size: 12pt, domain),
      text(font: fonts.secondary, weight: "light", size: 12pt, date),
    )),
  )
  content
}
