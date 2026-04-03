#import "theme/colors.typ": blue

#let frame(
  title,
  title-color: blue,
  title-text-color: white,
  content-color: blue.lighten(85%),
  content-text-color: blue.darken(10%),
  content: [],
) = block(
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

// Representation of a memory stack
// +-------+
// |   a   |
// +-------+
// |   b   |
// +-------+
// |   c   |
// +-------+
// |   d   | Oxffec0
// +-------+
// | value | label
// +-------+

#let memory-cell(
  content,
  fill: none,
  stroke: none,
  height: auto,
  text-color: black,
  inset: 5pt,
) = {
  (
    type: "cell",
    content: content,
    fill: fill,
    stroke: stroke,
    height: height,
    text-color: text-color,
    inset: inset,
  )
}


#let memory-stack(
  values, // array of content/strings to display in stack
  labels: (:), // dictionary mapping index to label (e.g., ("0": "0x1000", "3": "SP")) The key must be a string
  width: 3cm,
  height: 0.8cm,
  stroke-color: black,
  fill-color: none,
  label-gap: 0.2cm,
  label-position: ltr,
  dir: ttb
) = {
  set text(size: 0.8em)
  // Expand values array to handle (count, value) tuples
  let expanded = ()
  for val in values {
    if type(val) == array and val.len() == 2 and type(val.at(0)) == int {
      // Format: (count, content)
      let (count, content) = val
      for _ in range(count) {
        expanded.push(content)
      }
    } else {
      expanded.push(val)
    }
  }

  for (pos, lab) in labels {
    if pos == "start" {
      labels.insert("0", lab)
      _ = labels.remove("start") // the assignation to _ is to prevent the spilling of the value in the display
    }
    if pos == "end" {
      labels.insert(str(expanded.len() - 1), lab)
      _ = labels.remove("end")
    }
  }

  let n = expanded.len()
  if n == 0 {
    return none
  }

  box( // to be unbreakable
    stack(
      // columns: 2,
      // column-gutter: label-gap,
      spacing: label-gap,
      dir: label-position,
      // Stack boxes
      stack(
        dir: dir,
        spacing: 0pt,
        ..expanded
          .enumerate()
          .map(((i, val)) => {
            let is-cell = type(val) == dictionary and "type" in val and val.type == "cell"

            let cell-fill = if is-cell { val.fill } else { fill-color }
            let cell-stroke = if is-cell and val.stroke != none { val.stroke } else { stroke-color + 1pt }
            let cell-height = if is-cell and val.height != auto { val.height } else { height }
            let cell-inset = if is-cell { val.inset } else { 5pt }
            let cell-content = if is-cell { val.content } else { val }
            let cell-text-color = if is-cell { val.text-color } else { black }

            box(
              width: width,
              height: cell-height,
              stroke: cell-stroke,
              fill: cell-fill,
              inset: cell-inset,
              align(center + horizon, text(fill: cell-text-color, cell-content)),
            )
          }),
      ),
      // Labels column
      stack(
        dir: dir,
        spacing: 0pt,
        ..expanded
          .enumerate()
          .map(((i, val)) => {
            let is-cell = type(val) == dictionary and "type" in val and val.type == "cell"
            let cell-height = if is-cell and val.height != auto { val.height } else { height }

            box(
              height: cell-height,
              align(left + horizon, {
                if str(i) in labels.keys() {
                  labels.at(str(i))
                }
              }),
            )
          }),
      ),
    ),
  )
}

/*

Example of process format

#memory-stack(
  (
    memory-cell("Text", fill: blue.lighten(70%), height: 1cm),
    memory-cell("Data", fill: blue.lighten(70%), height: 1cm),
    memory-cell("Heap", fill: blue.lighten(70%)),
    memory-cell([$arrow.b$], stroke: (left: (dash: "dashed"), right: (dash: "dashed"))),
    memory-cell([$arrow.t$], stroke: (left: (dash: "dashed"), right: (dash: "dashed"))),
    memory-cell("Stack", fill: green.lighten(80%)),
    memory-cell("Kernel"),
  ),
  labels: ("0": "0x0000", "end": "0xFFFF"),
)

*/
