#let background(with_logo: true) = {
 align(left, stack(
  dir: ltr,
  spacing: .5em, 
  rect(height: 1fr, 
    fill: blue, 
    stroke: blue), 
  align(bottom + left, if with_logo {image(height: 2cm, "logos/soft.png")}))) 
}
#set page(
  numbering: (..n) => {
    place(dx: 100%, dy:10pt,(text(size: 16pt,numbering("1 / 1", ..n))))
  },
  margin: (
    top: 1cm, 
    left: 3em,
    bottom: 2cm
  ),
  background: background()
)
#let dark_blue = 	rgb("#2b60b5");

#show list: set text(size: 18pt)
#set text(size: 24pt)
#show heading: set text(blue)
#show heading.where(level: 1): set text(size: 48pt)
#show heading.where(level: 2): set text(size: 36pt, dark_blue)

#let square_slide(ctx) = {
  set page(
    paper: "presentation-4-3",
  )
  ctx
}

#let wide_slide(ctx) = {
  set page(
    paper: "presentation-16-9",
  )
  ctx
}

#let titleframe(title, subtitle, authors) = {
    let authors = if type(authors) == dictionary {
      (..(authors,)).map(p => text(size: 16pt)[#p.title #p.name.first])
    } else {
      authors.map(p => text(size: 16pt)[#p.title #p.name.first]) 
    }

    
    align(center + horizon, 
      grid(
        gutter: 1em, 
        columns: (10cm, 60%), 
        align: (right, left), 
        [],
        {
          heading(level: 1, title)
          authors.join(linebreak())
          if subtitle != "" {heading(level: 2, subtitle)}
        },
      )
    )
}

#wide_slide(
  titleframe(
    "Compilers", 
    "Lecture 1- Introduction", 
    (
      (name : (
        first: "Antonio", 
        last: "Paolillo"
      ), 
      role: "template master", 
      organization: "vub", 
      title: "Prof."
    ),
    (
      (name : (
        first: "Attilio", 
        last: "Discepoli"
      ), 
      role: "template master", 
      organization: "vub", 
      title: "PhD Student")
    ))
  ) )

#set page(background: background(with_logo: false))


#wide_slide(
  [
  = What is a compiler

  A compiler is a program that transforms one language into another
    
  - High-level $->$ low-level
  - Text $->$ executable
  - Intent $->$ hardware behavior
  - Human meaning → machine constraints & behavior
  
  Examples:
  - gcc, rustc, javac, clang
  - Game engines (shader compilers)
  - Browsers (JavaScript JITs)
  
  In this course, our compiler will translate:
  ChocoPy → RISC-V assembly → Linux executable.  
] 
)




#wide_slide(
  [
    = Some code 
    #grid(
      columns: 2,
      align(center,
      {
      ```rust 
      fn main() {
        println!("hellow world!")
      }
      ```
        place(dy: -48pt, dx: 15pt, rect(stroke: 1.5pt + blue, width: 11cm))
        place(dy: -35pt, dx: 11.5cm, line(stroke: 1.5pt +blue))
        place(dy: -45pt, dx: 13cm, text(blue)[this is a macro])
      })
    )
    the above shows the usage of code blocks
  ]
)
// #titleframe("test", "other", ((name : (first: "esteban", last: "aguililla"), role: "template master", organization: "vub")))
