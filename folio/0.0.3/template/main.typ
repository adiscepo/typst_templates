#import "../lib.typ": *

#show: folio.with(
  title: "A comment on the Unix operating system",
  subtitle: "First edition",
  //subtitle: "Introduction to compiling tools",
  subslide-numbering: "(i)",
  authors: ((name : "John Lions", title: "Professor")),
  location: "The 	University of New South Wales", 
  title-color: black
)

= What is a compiler ?
=== Examples:

- *gcc, rustc, javac, clang*
- Game _engines_ (shader compilers)
- Browsers (JavaScript JITs)

In this course, our compiler will translate:#linebreak()
	*ChocoPy* → *RISC-V* assembly → *Linux* executable.

== Why study compilers ?
- Understand how programming really works
- Write safer, *faster*, more predictable code
- Learn fundamental CS: automata, parsing, semantics
- Build a #strike[production] compiler
- Gain a “compiler mindset”:
  - parse anything $arrow.r$ How SQL optimizers use the same techniques as compilers?
  - design good languages
  - understand performance $arrow.r$ Compilers shape the limits of hardware utilization.
  - reason about correctness
=== Compilers are everywhere:
	IDEs, databases, AI frameworks, browsers, GPUs#footnote[Graphical Processing Unit].
Compiler stacks are more relevant that ever (MLIR, heterogeneity, etc.)

== _Example_ of *compilation* with `gcc`

- Preprocessing: `cpp -E hello.c > hello.i`
- Compilation to assembly: `gcc -S hello.c`
- Assemble: `gcc -c hello.s`
- Link: `gcc hello.o -o hello`
- Run: `./hello`
1. Compile
+ Link
+ Execute

```c
#include <stdio.h>

int main() {
  printf("Hello World\n");
  return 0;
}
```

#definition("Compilation")[In computing, a compiler is software that translates computer code written in one programming language (the source language) into another language (the target language).]
#frame("Example")[ programming language (the source language) into another language (the target language).]
