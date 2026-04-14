#import "@preview/hydra:0.6.2": hydra, anchor

#let carrare(
  title: "Title",
  domain: "Domain",
  date: datetime.today().display("[Year]"),
  numbering: "1.1",
  content,
) = {
  set page(margin: 6em, header: anchor(), footer: context {
    let page_nb = here().page()
    if page_nb != 1 {
      stack(
        dir: ltr,
        align(left, text(size: 8pt, font: "URW Gothic", title)),
        align(right, text(size: 8pt, font: "URW Gothic", emph(hydra(1)))),
      )
      // line(length: 100%)
    }
    align(center, move(dy: if (page_nb > 1) { -20pt } else { 0pt }, text(size: 12pt, font: "URW Gothic", weight: 900, str(page_nb))))
  })
  set par(justify: true)
  set text(font: "CenturySchL")
  show raw: set text(font: "0xProto Nerd Font Mono")
  set heading(numbering: numbering)
  show heading: it => {
    let midline(..o) = line(..o, stroke: (thickness: 3pt))
    let offset = 30pt
    block[
      #set text(font: "URW Gothic")
      /// Maybe there is a better way to do that: I'm checking if there is a number (i.e the
      /// user didn't set numbering to none for the heading; if there is a numbering, we store
      /// it value in number otherwise number is the empty string
      #let number = if counter(heading).get() != (0,) { counter(heading).display() } else { "" }
      #box(midline(length: offset)) #text(weight: 300, it.body) #box(width: 1fr, midline(length: 100%)) #text(
        number,
        size: 12pt,
      )
    ]
    v(15pt)
  }

  set par(first-line-indent: 0pt)
  stack(
    dir: ltr,
    align(horizon, text(font: "URW Gothic", size: 2em, strong(title))),
    align(right, stack(
      spacing: 6pt,
      dir: ttb,
      text(font: "URW Gothic", weight: "light", size: 12pt, domain),
      text(font: "URW Gothic", weight: "light", size: 12pt, date),
    )),
  )
  v(12pt)
  content
}
