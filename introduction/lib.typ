#let primary = rgb("#003366")    // Dark blue
#let secondary = rgb("#00CCCC")  // Teal
#let accent = rgb("#FF9900")     // Orange

#let create_header() = {
  context {
    let current_slide = query(selector(heading).before(here())).len()

    let slides = query(selector(heading))
    let section = ""
    let circles = ""
    let headers = ()
    let text_color = rgb("#8996B3")
    for i in range(0, slides.len()) {
      let slide = slides.at(i)
      if slide.level == 1 {
        let outset = (left: 0.1cm, bottom: 0.1cm, top: 0.1cm)
        let alignment = center

        if headers.len() == 1 {
          alignment = left
          outset = (left: 0.5cm, bottom: 0.1cm, top: 0.1cm)
        }

        headers.push([
          #box(
            width: 100%,
            outset: outset
          )[
            #align(alignment,
            grid(
              align: (left,left),
              text(fill: text_color)[#section],
              v(0.5em),
              text(fill: text_color)[#circles]
            )
          )
        ]])  
        section = slide.body
        circles = ""
        text_color = rgb("#8996B3")
        continue
      }

      if i < current_slide {
        circles += "●"
      }
      else if i == current_slide {
        circles += "◉"
        text_color = white;
      }
      else {
        circles += "○"
      }
    }

    headers.push([
      #box(
        width: 100%,
        outset: (right: 0.5cm, bottom: 0.1cm, top: 0.1cm)
      )[
        #align(right,
        grid(
          align: (left,left),
          text(fill: text_color)[#section],
          v(0.5em),
          text(fill: text_color)[#circles]
        )
      )
    ]])  

    grid(
      columns: headers.len(),
      ..headers.slice(1),
    )
  }
}

#let setup_presentation(
  content,
  title_long: none,
  title_short: none,
  institute_long: none,
  institute_short: none,
  authors_long: (),
  authors_short: (),
  date: none,
  height: 12cm,
  theme: (
    primary: rgb("#003365"),
    secondary: rgb("#00649F"),
  ),
  table_of_content: true,
  header: true,
) = {
  set page(
    width: height * 16 / 10,
    height: height,
    margin: (
      top: {if header {3em} else {0em}},
      right: 1em, left: 1em, bottom: 3em),
    footer: context{
      if here().page() == 1 {
        []
      } else {
        grid(
          columns: 3,
          inset: -1pt, 
          align: (left + horizon, center + top, top),
          box(
            fill: rgb(theme.primary),
            width: 100%,
            height: 100%,
            outset: (left: 0.5cm, top: 0.1cm),
          )[
            #text(fill: white)[#authors_short.join(", ")~~~(#institute_short)]
          ],
          box(
            fill: rgb("#0064A0"),
            width: 100%,
            height: 100%,
            outset: (top: 0.1cm),
          )[
            #align(horizon, text(fill: white)[
              #title_short
            ])
          ],
          box(
            fill: rgb(theme.primary),
            width: 100%,
            height: 100%,
            outset: (top: 0.1cm, right: 1cm),
          )[
            #grid(
              columns: 2, 
              align: (center+horizon, right+horizon),
              box(width: 100%, height: 100%)[#align(horizon, text(fill: white)[#date])],
              box(width: 100%, height: 100%)[
                 #align(horizon, text(fill: white)[
                  #counter(page).display("1/1", both: true); 
                ])
              ])
            ],
          )
        }
      },
      header: context{
        if header {
          grid(
            box(
              width: 100%,
              outset: (left: 2em, right: 2em, top: 1em, bottom: 0.2em),
              fill: rgb("#142d69"),
              create_header()
            ),
          )
        }
      },
    )

    // Title page
    {
      set page(header: none, footer: none)
      align(center + horizon, box(
        fill: theme.primary,
        radius: 15pt,
        inset: 2em,
        width: 100%,
        text(size: 2.2em, weight: "bold", fill: white)[#title_long],
      ))
      align(center, text(size: 1.8em)[#authors_long.join(", ")])
      align(center, text(size: 1.4em)[#institute_long])
    }

    //Table of content
    if table_of_content {
      set page(
        header: none, 
      )

      show outline.entry.where(level: 1): set text(size: 1.6em)
      show outline.entry.where(level: 2): set text(size: 1.2em)

      show outline.entry: it => {
        // Check if the heading's body is empty
        if it.element.body == [] {
          none  // Skip this entry
        } else {
          it    // Show this entry normally
        }
      }

      set align(center)
      text(size: 2.2em)[*Оглавление*]
      columns(2, outline(title: none))
    }

    //Section slide
    show heading.where(level: 1): x => {
      pagebreak(weak: true)

      set page(header: none)

      let name = x.body.text

      align(center + horizon, box(
        fill: theme.primary,
        radius: 15pt,
        inset: 2em,
        width: 100%,
        text(size: 2.2em, weight: "bold", fill: white)[#name],
      ))
    }

    // Main slide
    show heading.where(level: 2): x => {
      pagebreak(weak: true)
      set align(center)
      set text(size: 20pt)
      box(
        inset: 0.2em,
        text(weight: "bold")[#x.body],
      )
    }

    content
  }

