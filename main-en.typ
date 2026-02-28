// MIT No Attribution
// 
// Copyright (c) 2025 Gabriel Moreira
// 
// Permission is hereby granted, free of charge, to any person obtaining a copy of this
// software and associated documentation files (the "Software"), to deal in the Software
// without restriction, including without limitation the rights to use, copy, modify,
// merge, publish, distribute, sublicense, and/or sell copies of the Software, and to
// permit persons to whom the Software is furnished to do so.
// 
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED,
// INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A
// PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
// HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
// OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
// SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
// ---
// Content under CC-BY 4.0
// ---
// (Feel free to use)

#pdf.attach("main-en.typ")

#import "@preview/touying:0.6.1" as tou: *
#import "@preview/cetz:0.4.2"
#import "@preview/fletcher:0.5.8"
#import "@preview/pinit:0.2.2"
#import themes.metropolis: *

#set text(lang: "en")
#show raw: set text(font: "Fira Mono", 1.0em)

#let typst-logo(height: 1em) = box(image("/assets/typst-logo.png", height: height), height: height, radius: height * ((20pt + 0em)/(0pt + 3em.to-absolute())), clip: true)

#show link: set text(blue)

#show: metropolis-theme.with(
  // aspect-ratio: "16-9",
  footer: self => self.info.institution,
  config-info(
    title: v(-1em) + [Elembic],
    subtitle: [A vision for custom elements in Typst],
    author: [Gabriel Moreira\ GitHub: #link("https://github.com/PgBiel")[\@PgBiel]],
    date: datetime.today(),
  ),
  config-colors(
    primary: eastern.darken(10%),
    secondary: eastern.darken(30%),
    neutral-lightest: eastern.lighten(80%),
  ),

  config-common(
    handout: false // true // to disable pauses
  )
)
#set text(32pt)
#set text(font: "Fira Sans")

#let farrow = fletcher.edge.with("-|>")
#let fill-rest = block.with(height: 1fr, width: 100%)

#let alternatives-fn(fn, count: 0) = alternatives(..range(count).map(i => fn(i+1)))

#title-slide()


#show raw.where(block: true): it => {
  
    show strong: it => text(weight: "bold", it.body)
    it
}
#let code = block.with(fill: luma(245), radius: 10pt, inset: 20pt, width: 100%, height: 100%)

#let quick-example(example-code, n, override-input: none, override-output: none, preamble: none, style-input: it => it, style-output: it => it) = pad(x: -1cm, grid(
  columns: (1fr, 1fr),
  column-gutter: 0.5em,
  [
    #set text(31pt / 32pt * 1em)
    #show: block.with(fill: luma(245), radius: 10pt, inset: 20pt, width: 100%, height: 100%)
    #show: style-input

    // Fix slide overriding strong color
    #if override-input == none { example-code } else { override-input }
  ], (if n <= 1 { hide } else { x => x })({
    set text(30pt / 32pt * 1em)
    // Fix slide overriding strong color
    show strong: it => context text(weight: 400 + strong.delta, it.body)
    show: block.with(fill: luma(255), radius: 10pt, inset: 20pt, width: 100%, height: 100%)

    show: style-output
    // Evil bit hack: avoid interference between the heading here and our slide's heading by replacing it and its reference with text.
    let sanitized-input = example-code.text.replace(regex("(\\n|^)= (.+)|#heading\\[(.+)\\]"), c => "#block(text(1.4em, weight: \"bold\")[" + c.captures.join() + "])").replace("@sec", "Section 1").replace("<sec>", "")
    eval(
      preamble + if override-output != none { override-output } else { sanitized-input },
      mode: "markup"
    )
  })
))

= 1. Motivation

#focus-slide[Elements]

== Elements


- Give *names* to parts of a document's *structure*

== Elements - Example

#{
  show ref: [(Jones, 2023)]
 quick-example(```typ
= Introduction

Developers often face _this_ problem @jones2023.
```, 2) 
}

#pagebreak()
#{
  show cite: [(Jones, 2023)]
 quick-example(```typ
#heading[Introduction]

Developers often face #emph[this] problem #cite(<jones2023>).
```, 2) 
}

== Elements


- Semantics #pause
  - Meaning #meanwhile
  
#meanwhile

- Styling #pause
  - Appearance

== Styling

- Customizing the *appearance* of elements #pause
  - *In bulk*

#pagebreak()

- _Show rules:_ #alternatives[replace][#strike[replace] redefine] #pause

#pause

- _Set rules:_ modify

#pagebreak()

#text(1.6em, align(center)[Naming #sym.arrow.r Matching])

== Styling - Show rules

#let diff-highlight = highlight.with(fill: green.lighten(65%))

#{
  show ref: [(Jones, 2023)]
 quick-example(```typ
= Introduction

Developers often face _this_ problem @jones2023.
```, 2) 
  pagebreak()
  show raw.line.where(number: 1): diff-highlight
  quick-example(```typ
#show emph: highlight
  
= Introduction

Developers often face _this_ problem @jones2023.
```, 2)
}

== Styling - Set rules

#{
  show ref: [(Jones, 2023)]
 quick-example(```typ
= Introduction

Developers often face _this_ problem @jones2023.
```, 2) 
  pagebreak()
  show raw.line.where(number: 1): diff-highlight
  show raw.line.where(number: 2): diff-highlight
  show raw.line.where(number: 3): diff-highlight
  quick-example(```typ
= 1. Introduction

Developers often face _this_ problem @jones2023.
```, 
override-input: ```typ
#set heading(
  numbering: "1."
)
  
= Introduction

Developers face _this_ problem *very* often @jones2023.
```,
2)
}

#focus-slide[Templates]

== Templates

- Templates are *collections of styles* #pause
  - Redefine #sym.arrow.r _Show rules_
  - Change #sym.arrow.r _Set rules_

#pagebreak()

- Enforce *guidelines*

  - Style *existing elements*

== Templates - "Contract"

#{
  set align(center)
  import fletcher:  *
  fletcher.diagram(
    spacing: 120pt,
    node[*Template*],
    edge(bend: 30deg, "<-")[Elements],
    
    edge(bend: -30deg, "->")[Styles],
    node((2, 0))[*User*]
  )
}

== Elements

- Provided by Typst #pause

- New elements? #pause

  - Warning boxes

  - Theorems and lemmas

  
== Custom elements - Example

#code[```typ
#let warn(body, fill: yellow) = {
  align(
    center,
    block(fill: fill, inset: 10pt, body)
  )
}
```]

== Custom elements - Example

#quick-example(
  ```typ
#let warn(body, fill: yellow) = align(center, block(fill: fill, inset: 10pt, body))

#warn[Be careful!]
  ```,
  override-input: ```typ

#warn[Be careful!]
```, 2)

#pagebreak()

#code[```typ
#set warn(fill: teal)

#warn[Be careful!]
```]


#pagebreak()
```sh
Error: only element functions can be used as selectors
```

// Idea: no semantics, only styles

= 2. Elembic

== About Elembic

- Typst Universe package

- Create new elements
  - Show / set rules

- For packages and templates

== About Elembic - Name

#text(1.6em, align(center)[#[*elem*]ent + alem#[*bic*]]) #pause

#align(center)[An experiment with elements]

#pagebreak()

#align(center, image("alembic-cut.jpg"))

== About Elembic - Users

- Packages
  - `lilaq`
  - `itemize`
  - And more!

== Usage - Import

#code[```typ
#import "@preview/elembic:1.1.1" as e: (
  field,
  types
)
```]

== Usage - Declaring

// Example todo

#code[```typ
#let warn = e.element.declare(
  "warn",
  prefix: "@preview/my-template,v1",
  doc: "A warning box in the document.",
  ...
)
```]

#let just-code-slide(body) = {
  empty-slide[
    #show: pad.with(top: -2.5em, bottom: -0.8em)
    #code(body)
  ]
}

#just-code-slide[```typ
#let warn = e.element.declare(...,
  fields: (
    field(
      "body",
      types.option(content),
      doc: "Contents",
      required: true
    ), ...
  ), ...
)
```]


#pagebreak()

#just-code-slide[```typ
#let warn = e.element.declare(...,
  fields: (
    ...,
    field(
      "fill",
      types.option(types.paint),
      doc: "Background",
      default: yellow,
    )
  ), ...
)
```]

#pagebreak()


#just-code-slide[```typ
#let warn = e.element.declare(...,
  display: it => align(
    center, 
    block(
      fill: it.fill, 
      inset: 20pt, 
      it.body
    )
  )
)
```
]

== Example - Set rule

// #[
// #import "@preview/elembic:1.1.1" as e: field, types
//  #let warn = e.element.declare(
//     "warn",
//     prefix: "@preview/my-template,v1",
//     doc: "A warning box in the document.",
//     fields: (
//       field("body", types.option(content), doc: "Box contents", required: true),
//       field("fill", types.option(types.paint), doc: "Box fill"),
//     ),
//     display: it => block(fill: it.fill, inset: 20pt, it.body)
//   ) 

//   #show: e.set_(warn, fill: green)
//   #warn[abc]
// ]

#quick-example(
  ```typ
#import "@preview/elembic:1.1.1" as e: field, types
 #let warn = e.element.declare(
    "warn",
    prefix: "@preview/my-template,v1",
    doc: "A warning box in the document.",
    fields: (
      field("body", types.option(content), doc: "Box contents", required: true),
      field("fill", types.option(types.paint), doc: "Box fill", default: yellow),
    ),
    display: it => align(center, block(fill: it.fill, inset: 20pt, it.body))
  ) 

  #warn[Be careful!]
  ```,
  override-input: ```typ

  #warn[Be careful!]
  ```,
  2
)

#pagebreak()

#let preamble = ```
#import "@preview/elembic:1.1.1" as e: field, types
 #let warn = e.element.declare(
    "warn",
    prefix: "@preview/my-template,v1",
    doc: "A warning box in the document.",
    fields: (
      field("body", types.option(content), doc: "Box contents", required: true),
      field("fill", types.option(types.paint), doc: "Box fill", default: yellow),
    ),
    display: it => align(center, block(fill: it.fill, inset: 20pt, it.body))
  )

```.text
#let elem-example(b, ..args) = quick-example(preamble: preamble, b, 2, ..args)

#let highlight-lines(body, lines: ()) = {
  lines.fold(body, (acc, l) => {
    show raw.line.where(number: l): diff-highlight
    acc
  })
}

#[
#show: highlight-lines.with(lines: range(1, 5))
#elem-example(
  ```typ
  #show: e.set_(
    warn,
    fill: teal
  )

  #warn[Be careful!]
  ```
)
]

== Example - Show rule
#elem-example(```typ
#warn[Be careful!]
```)
#pagebreak()
#[
  #show: highlight-lines.with(lines: range(1, 5))
  #elem-example(```typ
  #show: e.show_(
    warn,
    it => [*_#it;_*]
  )

  #warn[Be careful!]
  ```)
]

== Performance and Semantics

- *No state!*
  - No relayouts
  - Rules are scoped

#focus-slide[References and outlines]

#let preamble = ```
#import "@preview/elembic:1.1.1" as e: field, types
#show: e.prepare()
 #let warn = e.element.declare(
    "warn",
    prefix: "@preview/my-template,v1",
    doc: "A warning box in the document.",
    fields: (
      field("body", types.option(content), doc: "Box contents", required: true),
      field("fill", types.option(types.paint), doc: "Box fill", default: yellow),
      field("inset", length, doc: "Box inset", default: 20pt),
    ),
    reference: (
      supplement: [Warning],
      numbering: "1"
    ),
    outline: auto,
    display: it => align(center, block(fill: it.fill, inset: it.inset, [*Warning #e.counter(it).display():* #it.body]))
  )
  #e.counter(warn).update(0)

```.text

#let elem-example = elem-example.with(preamble: preamble)

== References

#code(```typ
#let warn = e.element.declare(
  ...,
  display: it => (/* center + fill */)[
    *Warning #e.counter(it).display():*
    #it.body
  ]
)
```)

#pagebreak()
#code(```typ
#let warn = e.element.declare(
  ...,
  reference: (
    supplement: [Warning],
    numbering: "1"
  ),
  outline: auto,
)
```)

#pagebreak()

#code(```typ
#show: e.prepare()
```)

== References - Example

#elem-example(```typ
#warn[Careful!]
```)

#pagebreak()

#highlight-lines(lines: (4,))[
#elem-example(```typ
See @care:

#warn(
  label: <care>
)[Careful!]
```)
]

== Outline


#elem-example(
  ```typ
  #show: e.set_(warn, inset: 10pt)
  #warn[Careful!]
  #warn[Do this!]
  ```,
  override-input: ```typ
  #warn[Careful!]
  #warn[Do this!]
  ```,
)

#highlight-lines(lines: range(1, 7), elem-example(
  ```typ
#show: e.set_(warn, inset: 10pt)

= Contents

#outline(
  target: selector(e.selector(
    warn,
    outline: true
  )).after(<start>).before(<end>),
  title: none
)

#metadata(0) <start>
#warn[Careful!]
#warn[Do this!]
#metadata(0) <end>
```,
  override-input: ```typ
#outline(
  target: e.selector(
    warn,
    outline: true
  )
)

#warn[Careful!]
#warn[Do this!]
```))

== Other features

- Conditional set rules #pause

- Revokable rules #pause

- Ancestry selectors

== Perspectives

- Bug fixes #pause

- Built-in custom types?

#focus-slide[
  #v(-2em)
  Thank you!

  #import "@preview/tiaoma:0.3.0"
  #let pres-url = "https://github.com/PgBiel/elembic-pres-2026"
  #tiaoma.qrcode("https://google.com")
  #scale(350%, block(fill: white, inset: 5pt, tiaoma.qrcode(pres-url, options: (option-1: 4))) + v(10pt, weak: true) + text(0.15em)[
    #show link: set text(white)
    Made with Typst\ 
    #link(pres-url)
  ])
]
