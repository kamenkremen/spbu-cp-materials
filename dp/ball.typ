#import "@preview/cetz:0.4.2": canvas, draw

#let ball-frame(depth) = {
  let h-factor = 1.6 
  
  let step-w = 4.5
  let step-h = 1.5
  
  let ball-r = 0.7
  
  let color-ball = orange
  let color-line = gray
  
  let jump-colors = (
    "1": blue,
    "2": green.darken(20%),
    "3": red
  )
  
  let dp-values = ("1", "1", "2", "4", "7")

  let last = false
  if depth == "n" {
    last = true
    dp-values = ($"dp"_(i-3)$, $"dp"_(i-2)$, $"dp"_(i-1)$, $$)
    depth = 3
  }

  canvas({
    import draw: *
    
    let max-steps-visible = 4
    let start-idx = calc.max(0, depth - 3)
    let end-idx = depth
    
    for i in range(start-idx, end-idx + 1) {
      let rel-x = i - start-idx 
      let x = rel-x * step-w
      let y = (max-steps-visible - rel-x) * step-h 

      line((x, y + step-h), (x + step-w, y + step-h), stroke: 2pt + color-line)
      line((x + step-w, y + step-h), (x + step-w, y), stroke: 2pt + color-line)
      
      let label-text = i 
      if last {
         if i == depth { label-text = $i$ }
         else { label-text = $i - #(depth - i)$ }
      }

      content(
        (x + step-w + 0.1, y + step-h/2), 
        anchor: "west", 
        text(fill: gray, size: 9pt)[#label-text]
      )

      let val-array = ()
      if i == depth {
        if i > 2 {
          val-array.push(dp-values.at(i - 3))
          val-array.push(" + ")
        }
        if i > 1 {
          val-array.push(dp-values.at(i - 2))
          val-array.push(" + ")
        }
        if i > 0 {
          val-array.push(dp-values.at(i - 1))
        }
      } else if i < dp-values.len() {
          val-array.push(dp-values.at(i))
      } else {
         val-array.push("...") 
      }
      
      let val-color = if i == depth { orange } else { black }

      content(
        (x + step-w/2, y + step-h - 0.6), 
        text(fill: val-color, weight: "bold", size: 14pt)[#val-array.join()]
      )
      
      if i != depth {
         content(
            (x + step-w/2, y + step-h - 1.1),
            text(fill: gray, size: 8pt)[путей]
         )
      }
    }

    let ball-rel-x = depth - start-idx
    let ball-x = ball-rel-x * step-w + step-w/2
    let ball-y = (max-steps-visible - ball-rel-x) * step-h + step-h + ball-r
    let ball-center = (ball-x, ball-y)

    for jump in (1, 2, 3) {
      let source-idx = depth - jump
      
      if source-idx >= 0 and source-idx >= start-idx {
         let current-color = jump-colors.at(str(jump))
         
         // Стиль для пунктира
         let line-style = (
            stroke: (paint: current-color, dash: "dashed", thickness: 1.5pt),
         )
         
         // Стиль для стрелки
         let arrow-style = (
            mark: (end: ">", fill: current-color, scale: 1.0)
         )
      
         let src-rel-x = source-idx - start-idx
         let src-x = src-rel-x * step-w + step-w/2
         let src-y = (max-steps-visible - src-rel-x) * step-h + step-h
         let src-pt = (src-x, src-y)
         
         let height-offset = 2.0 + (jump * 0.5)
         let x-offset = (2 - jump) * 0.3
         
         let dst-pt = (ball-x + x-offset, ball-y + ball-r)
         
         let gap-size = 0.2
         let stop-pt = (dst-pt.at(0), dst-pt.at(1) + gap-size)

         let shift-factor = if jump == 1 { 0.3 } else { 0.6 }
         let c1-x = src-x + ((ball-x - src-x) * shift-factor)
         
         let c1 = (c1-x, src-y + height-offset)
         let c2 = (ball-x + x-offset, ball-y + height-offset)
         
         bezier(src-pt, stop-pt, c1, c2, ..line-style)
         
         line(stop-pt, dst-pt, 
              stroke: (paint: current-color.transparentize(100%), thickness: 0pt), 
              ..arrow-style)
      }
    }

    circle(ball-center, radius: ball-r, fill: color-ball, stroke: none)
  })
}
