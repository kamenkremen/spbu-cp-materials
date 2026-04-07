#import "@preview/tdtr:0.5.4": *
#import "@preview/cetz:0.4.2" 

#let tree = tidy-tree-graph.with(
  text-size: 1em,
  node-inset: 8pt,
  spacing: (1em, 1em),
  node-width: 1.2em,
  node-height: 1.2em,
  draw-node: (
    tidy-tree-draws.label-match-draw-node.with(
      matches: (
        blue: (fill: color.blue.lighten(50%)),
        green: (fill: color.green),
        yellow: (fill: color.yellow),
        nil: (post: x => none),
      ),
      default: (fill: white),
    ),
  ),
  draw-edge: (
    tidy-tree-draws.label-match-draw-edge.with(
      matches: (
        nil: (post: x => none),
      ),
    ),
  ),
)

#let arrow(label: none, width: 7em) = box(
  inset: (x: 0.5em),
  cetz.canvas(length: 1em, {
    cetz.draw.set-style(
      stroke: (paint: black, thickness: 1.5pt),
      mark: (fill: black),
    )
    cetz.draw.line(
      (0, 0), (2, 0),
      mark: (end: ">"),
    )
    if label != none {
      cetz.draw.content((1, 0.4), text(size: 0.8em, label))
    }
  })
)

= AVL деревья

== Баланс в AVL

#grid(
  columns: (60%, 40%),
  box[
    AVL деревья поддерживают следующий инвариант: для каждой вершины $"BF" <= 1$, где $"BF" = h("left") - h("right")$ \

    *Почему это важно?*

    Если высота дерева $h = O(log n)$, то все операции работают за $O(log n)$. \

    *Как поддерживается?*

    После каждой вставки/удаления поднимаемся обратно и пересчитываем высоты. Если $|"BF"| > 1$, выполняем вращение.
  ],
  align(horizon, tidy-tree-graph(
    text-size: 1.2em,
    node-inset: 6pt,
    spacing: (2em, 1.5em),
    node-width: 1.5em,
    node-height: 1.5em,
  )[
    - $8$
      - $5$
        - $4$
        - $7$
      - $11$
        - $10$
        - $20$
  ]),
)

Пустые поддеревья имеют высоту $0$.

== Баланс-фактор

#align(horizon)[
  #grid(
    columns: (70%, 35%),
    box[
      Для каждой вершины храним высоту поддерева:

      #align(center, table(
        columns: 5,
        [$11$], [$5$], [$17$], [$12$], [$18$],
        [2], [1], [1], [0], [0],
      ))

      Баланс-факторы:
      - $11: h(L) - h(R) = 2 - 2 = 0$
      - $5: h(L) - h(R) = 1 - 0 = 1$
      - $17: h(L) - h(R) = 1 - 1 = 0$
    ],
    tree(
      text-size: 1.1em,
      node-inset: 6pt,
      spacing: (1.5em, 1.2em),
      node-width: 1.2em,
      node-height: 1.2em,
    )[
      - $11$
        - $5$
          - $4$
            - $3$ <yellow>
            + 1 <nil>
            - 1 <nil>
          + 1 <nil>
          - 1 <nil>
        - $17$
          - $12$
          - $18$
    ],
  )
]

Если добавить $3$ как левый ребёнок $4$:
- $4: h(L) - h(R) = 1 - 0 = 1$
- $5: h(L) - h(R) = 2 - 0 = 2$  Нарушен!

== Вращения

#grid(
  columns: 2,
  column-gutter: 2em,
  align: center,
  box(width: 100%)[
      *Правое вращение*

      #grid(
        columns: 3,

        tree(
          spacing: (1em, 1em),
          node-width: 1.2em,
          node-height: 1.2em,
        )[
          - A
            - B
              - C
              + 1 <nil>
              - 1 <nil>
            + 1 <nil>
            - 1 <nil>
        ],
        [
          #v(2em)
          #arrow()
        ],
        tree(
          spacing: (1em, 1em),
          node-width: 1.2em,
          node-height: 1.2em,
        )[
          - B
            - A
            - C
        ]
      )

      #grid(
        columns: 3,

        tree(
          spacing: (1em, 1em),
          node-width: 1.2em,
          node-height: 1.2em,
        )[
          - A
            - B
              - C
                - T3
                - T4
              - T2
            - T1
        ],
        [
          #v(2em)
          #arrow()
        ],
        tree(
          spacing: (1em, 1em),
          node-width: 1.2em,
          node-height: 1.2em,
        )[
          - B
            - A
              - T1
              - T2
            - C
              - T3
              - T4
        ]
      )
  ],
  box(width: 100%)[
      *Левое вращение*

      #grid(
        columns: 3,

        tree(
          spacing: (1em, 1em),
          node-width: 1.2em,
          node-height: 1.2em,
        )[
          - A
            + 1 <nil>
            - 1 <nil>
            - B
              + 1 <nil>
              - 1 <nil>
              - C
        ],
        [
          #v(2em)
          #arrow()
        ],
        tree(
          spacing: (1em, 1em),
          node-width: 1.2em,
          node-height: 1.2em,
        )[
          - B
            - A
            - C
        ]
      )

      #grid(
        columns: 3,

        tree(
          spacing: (1em, 1em),
          node-width: 1.2em,
          node-height: 1.2em,
        )[
          - A
            - T1
            - B
              - T2
              - C
                - T3
                - T4
        ],
        [
          #v(2em)
          #arrow()
        ],
        tree(
          spacing: (1em, 1em),
          node-width: 1.2em,
          node-height: 1.2em,
        )[
          - B
            - A
              - T1
              - T2
            - C
              - T3
              - T4
        ]
      )
  ],
)

=== Всегда ли верно?

#align(center,
  tree()[
    - A
      - B
        + 1 <nil>
        - 1 <nil>
        - D
      + 1 <nil>
      - 1 <nil>
    ]
)

#align(center, box(width: 100%, grid(
  columns: 5,
  tree()[
    - A
      - B
        + 1 <nil>
        - 1 <nil>
        - D
      + 1 <nil>
      - 1 <nil>
  ],
  [
    #v(2em)
    #arrow()
  ],
  tree()[
    - B
      + 1 <nil>
      - 1 <nil>
      - A
        + 1 <nil>
        - 1 <nil>
        - D
  ],
  [
    #v(2em)
    #arrow()
  ],
  tree()[
    - A
      - B
      - D
  ]
)))

