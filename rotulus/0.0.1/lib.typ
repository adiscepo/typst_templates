#import "theme.typ": *

// #let info-block(body, color: rgb("#000"), fill: gray.lighten(95%), stroke: 0.5pt + gray) = block(
#let info-block(title: none, body, color: gray) = {
  let stroke-thickness = 1.5pt
  v(2pt)
  block(
    breakable: false,
    // fill: fill,
    // stroke: stroke,
    fill: color.lighten(90%),
    stroke: (left: stroke-thickness + color.darken(20%)),
    // radius: 4pt,
    width: 100%,
    {
      set text(fill: color.darken(40%))
      let inset = (y: 12pt, left: 12pt, right: 10pt)
      stack(
        dir: ttb,
        if title != none {
          block(
            width: 100%,
            outset: (left: -stroke-thickness / 2),
            fill: color.lighten(50%),
            box(title, inset: (left: inset.left, y: 6pt)),
          )
        },
        box(
          inset: inset,
          body,
        ),
      )
    },
  )
  v(2pt)
}

#let rotulus(
  authors: (),
  title: [],
  subtitle: [],
  header: "",
  date: none,
  tags: (),
  heading-numbering: none,
  doc,
) = {
  set text(font: fonts.sans, size: sizes.body)
  set par(justify: true)
  set page(margin: (x:6em, y: 5em))
  set heading(numbering: heading-numbering)
  show heading: it => {
    if it.level == 1 {
      set text(size: sizes.h1, weight: "bold")
      it
    } else if it.level == 2 {
      set text(size: sizes.h2, weight: "bold")
      it
    } else if it.level == 3 {
      set text(size: sizes.h3, weight: "bold")
      it
    }
    v(1.5pt)
  }
  show raw: it => {
    set text(font: fonts.mono)
    if (it.block) {
      set text(size: sizes.code)
      box(
        width: 100%,
        inset: 10pt,
        fill: gray.lighten(95%),
        stroke: gray + 0.5pt,
        radius: 2pt,
        it,
      )
    } else {
      set text(size: sizes.code-inline)
      box(
        inset: (x: 5pt, y: 3pt),
        outset: (x: -2pt),
        baseline: 15%,
        fill: gray.lighten(95%),
        stroke: gray + 0.5pt,
        radius: 2pt,
        it,
      )
    }
  }

  // Header
  // Title
  {
    grid(
      columns: (5fr, 1fr),
      stack(
        dir: ttb,
        spacing: 15pt,
        align(left, text(size: sizes.title, weight: "bold", title)),
        align(left, text(size: sizes.subtitle, subtitle)),
      ),
      if date != none {
        date.display("[day]/[month]/[year]")
      },
    )
  }
  let colors = (blue, red, yellow, green, orange, purple)
  // Tags

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
              radius: (top-left: 4pt, bottom-right: 4pt, bottom-left: 4pt),
              stroke: 0.4pt + c.darken(90%),
              fill: c.lighten(90%),
              text(tag, fill: c.darken(85%), size: sizes.small),
            )
          }),
      )
   }
  show figure.where(kind: raw): it => {
    stack(
      spacing: 8pt,
      align(left, it.body),
      it.caption,
    )
  }
  show link: it => {
    underline(text(it, fill: blue))
  }


  doc
}
