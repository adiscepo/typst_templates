#import "../lib.typ": info-block, rotulus
#import "@spells/lazy:0.0.2": memory-cell, memory-stack
#import "@preview/meander:0.4.0"

#show: rotulus.with(
  authors: "Attilio",
  title: "Activation Records",
  subtitle: "Compilers",
  tags: ("compilers", "implementation", "risc-v", "code generation"),
)

= Introduction

#lorem(50)

== What is a compiler

#meander.reflow({
  import meander: *
  placed(right, boundary: contour.margin(x: 20pt, y: 10pt), memory-stack(
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
  ))
  container()
  content[
    #lorem(50)
    == Historical aspect

    #info-block(color: red, title: "Warning")[A *compiler* is different from an *interpreter*]
    #lorem(50)
    #info-block(color: purple)[A *compiler* is different from an *interpreter*]
    The register `a0`is used as the accumulator. You can find information about registers #link("_", "here")#footnote[#lorem(20)]
    #figure(
      ```py
      def sum(a: int, b:int) -> int:
        return a + b

      def main() -> int:
        sum(1, 4)
      ```,
      caption: "Hello world !"
    ) <code_intro>
  ]
})
#lorem(10)

=== An introductive example

#lorem(50)
```py
def foo() -> bool:
  print("Function")
  a: bool = True
  return a
```

= Compilers
#lorem(150)
