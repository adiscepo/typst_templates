
#let notojn(
  authors: (),
  title: [],
  subtitle: [],
  header: "",
  date: datetime.today(),
  doc
) = {
  set heading(
    numbering: "1.1"
  )

  set text(
    font: "Source Sans 3",
    weight: "regular"
  )

  show heading.where(level: 1): it => [
    #it #v(0.5em)
  ] 

  show link: it => {
    text(fill: blue, underline(it))
  } 

  show raw: it => {
    if (it.block) {
      block(
        width: 100%,
        inset: (x: 5pt, y: 10pt),
        radius: 2pt,
        fill: black.lighten(95%),
        stroke: 1pt + white.darken(10%),
        it
      )
    } else {
      box(
        fill: white.darken(5%),
        outset: (y: 3pt),
        inset: (x: 3pt),
        radius: 3pt,
        text(it)
      )
    }
  }

  if (type(authors) != array) {
    authors = (authors, )
  }
  if date == none {
    date = ""
  } else if (type(date) == datetime) {
    date = date.display("[day] [month repr:long] [year]")
  }

  set page(
    margin: (top: 2.5cm, bottom: 3cm, left: 3cm, right: 3cm),
    header: [
      #set text(10pt, weight: 400)
      #authors.join(", ")
      #h(1fr) #smallcaps(header)
      #if date.len() != 0 and (header != "" and header != none)  [
        —
      ]
      #if date != none [
       #date
      ]
      #v(-7pt)
      #line(length: 100%, stroke: 0.2pt)
    ],
    number-align: center,
    numbering: "1"
  )

  set par(
    first-line-indent: 0em,
    justify: true,
  )
  align(center, 
    v(1em) 
    + underline(offset: 5pt, text("" + title, 1.8em, weight: 900)) 
    + linebreak()
    + v(1pt) 
    + text(subtitle, 1em)
    + v(2em) 
  )
  doc
}


#let default-color = blue
#let frame(content, counter: none, title: none, fill-body: none, fill-header: none, radius: 0.2em) = {
  let header = none

  if fill-header == none and fill-body == none {
    fill-header = default-color.lighten(75%)
    fill-body = default-color.lighten(85%)
  }
  else if fill-header == none {
    fill-header = fill-body.darken(10%)
  }
  else if fill-body == none {
    fill-body = fill-header.lighten(50%)
  }

  if radius == none {
    radius = 0pt
  }

  if counter == none and title != none {
    header = [*#title.*]
  } else if counter != none and title == none {
    header = [*#counter.*]
  } else {
    header = [*#counter:* #title]
  }

  show stack: set block(breakable: false, above: 0.8em, below: 0.5em)

  stack(
    block(
      width: 100%,
      inset: (x: 0.6em, top: 0.7em, bottom: 0.7em),
      fill: fill-header,
      radius: (top: radius, bottom: 0cm),
      header,
    ),
    block(
      width: 100%,
      inset: (x: 0.6em, top: 0.8em, bottom: 0.8em),
      fill: fill-body,
      radius: (top: 0cm, bottom: radius),
      content,
    ),
  )
}

#let n = counter("notes")
#let noto(content, title: none, ..options) = {
  n.step()
  frame(
    counter: context n.display(x => "Note " + str(x)),
    title: title,
    content,
    ..options,
  )
}
