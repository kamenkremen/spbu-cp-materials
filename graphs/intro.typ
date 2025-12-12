#import "@preview/pepentation:0.1.0": *
#import "@preview/cetz:0.4.2"
#import "@preview/fletcher:0.5.8" as fletcher: diagram, node, edge

#let node = node.with(radius: 1em)

#let arrow(label: none, width: 7em) = box(
  inset: (x: 0.5em),
  cetz.canvas(length: 1em, {
    cetz.draw.set-style(
      stroke: (paint: blue, thickness: 1.5pt),
      mark: (fill: blue),
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

= Определения

== Граф
#v(-1em)
#definition[
*Обыкновенный граф* – совокупность множеств $G(V,E)$, где
- $V$ (Vertex) – множество вершин
- $E$ (Edge) – Множество ребер
- $E subset.eq V^2 = {{u, v} | u, v in V; u != v}$
]

#let nodes = (
  ((0, 0), "A"),
  ((1, 0), "B"),
  ((0, 1), "C"),
  ((1, 1), "D"),
  ((2, 0.5), "E")
)
#let edges = (
  ("A", "B", 5),
  ("A", "C", 1),
  ("B", "E", 7),
  ("C", "D", 7),
  ("D", "A", 0),
  ("D", "B", 6),
  ("E", "D", 3)
)

#let draw_base_graph(nodes: nodes, edges: edges) = {
    for (pos, name) in nodes {
      node(pos, name, name: name)
    }

    for (from, to, _) in edges {
      edge(label(str(from)), label(str(to)))
    }
}

Например:

$V = {
  #for (i, val) in nodes.enumerate() {
    val.at(1)
    if i != nodes.len() - 1 {
      $,$ 
    }
  }
}$, 

$E = {
  #for (i, (from, to, _)) in edges.enumerate() {
    $(from, to)$
    if i != edges.len() - 1 {
      $,$ 
    }
  }
}
$

#diagram(
  node-stroke: .1em,
  spacing: 2em,
  {
    draw_base_graph()
  }
)

== Полный граф
#v(-1em)
#definition[
*Полный граф* $K_n$ — граф в котором каждая пара вершин соединена ребром.
]

Полный граф $K_n$ имеет $C_n^2$ ребер. Каждая вершина имеет степень $n-1$.


#align(center, diagram({
  let nodes = ("A", "B", "C", "D", "E", "F", "G", "H")
  let edges = (
    (0, 1),(0, 2),(0, 3),(0, 4),(0, 5),(0, 6),(0, 7),
    (1, 0),(1, 2),(1, 3),(1, 4),(1, 5),(1, 6),(1, 7),
    (2, 1),(2, 0),(2, 3),(2, 4),(2, 5),(2, 6),(2, 7),
    (3, 1),(3, 2),(3, 0),(3, 4),(3, 5),(3, 6),(3, 7),
    (4, 1),(4, 2),(4, 3),(4, 0),(4, 5),(4, 6),(4, 7),
    (5, 1),(5, 2),(5, 3),(5, 4),(5, 0),(5, 6),(5, 7),
    (6, 1),(6, 2),(6, 3),(6, 4),(6, 5),(6, 0),(6, 7),
    (7, 1),(7, 2),(7, 3),(7, 4),(7, 5),(7, 6),(7, 0),
  )

	for (i, n) in nodes.enumerate() {
		let θ = 90deg - i*360deg/nodes.len()
		node((θ, 28mm), n, stroke: 0.5pt, name: str(i))
	}
    for from in range(0, nodes.len()){
      for to in range(0, nodes.len()){
        if from != to {
          let bend = if (to, from) in edges { 10deg } else { 0deg }
          edge(label(str(from)), label(str(to)), "-|>", bend: bend)
        }
      }
    }
}))

== Разряженные и плотные графы
#v(-1em)
#definition[
*Разряженный граф* - граф с относительно небольшим числом рёбер сравнительно с числом вершин (обычно $O(V)$).
]

#definition[
*Плотный граф* - граф с большим числом рёбер, близким к полному (обычно $O(V^2)$).
]

#align(center, grid(columns: 2, gutter: 5em,
[
*Разряженный:* 

#diagram(
  node-stroke: .1em,
  spacing: 2em,
  {
    node((0,0), "A", name: "A")
    node((1,0), "B", name: "B")
    node((0,1), "C", name: "C")
    node((1,1), "D", name: "D")
    node((2,0.5), "E", name: "E")
    edge(label("A"), label("B"))
    edge(label("B"), label("E"))
    edge(label("A"), label("C"))
    edge(label("C"), label("D"))
  }
)
],
[
*Плотный:*

#diagram(
  node-stroke: .1em,
  spacing: 2em,
  {
    node((0,0), "A", name: "A")
    node((1,0), "B", name: "B")
    node((0,1), "C", name: "C")
    node((1,1), "D", name: "D")
    node((2,0.5), "E", name: "E")
    edge(label("A"), label("B"))
    edge(label("A"), label("C"))
    edge(label("A"), label("D"))
    edge(label("A"), label("E"))
    edge(label("B"), label("C"))
    edge(label("B"), label("D"))
    edge(label("B"), label("E"))
    edge(label("C"), label("D"))
    edge(label("C"), label("E"))
    edge(label("D"), label("E"))
  }
)
]
))

== Пути
#v(-1em)
#definition[
*Путь* ведет из одной вершины в другую и проходит по ребрам графа. 
]

#definition[
*Длиной пути* называется количество ребер в нем.
]

#definition[
*Циклом* называется путь, в котором последняя вершина совпадает с первой.
]

#align(center, grid(
  columns: 2,
  gutter: 7em,
  [
    *Путь:*

    #diagram(
      node-stroke: .1em,
      spacing: 2em,
      {
        draw_base_graph()

        edge(label("A"), label("B"), "-|>", stroke: (paint: red, thickness: 0.8pt))
        edge(label("B"), label("E"), "-|>", stroke: (paint: red, thickness: 0.8pt))
        edge(label("E"), label("D"), "-|>", stroke: (paint: red, thickness: 0.8pt))
        edge(label("D"), label("C"), "-|>", stroke: (paint: red, thickness: 0.8pt))
      }
    )
  ],
  [
    *Цикл:*

    #diagram(
      node-stroke: .1em,
      spacing: 2em,
      {
        draw_base_graph()

        edge(label("A"), label("B"), "-|>", stroke: (paint: red, thickness: 0.8pt))
        edge(label("B"), label("E"), "-|>", stroke: (paint: red, thickness: 0.8pt))
        edge(label("E"), label("D"), "-|>", stroke: (paint: red, thickness: 0.8pt))
        edge(label("D"), label("A"), "-|>", stroke: (paint: red, thickness: 0.8pt))
      }
    )
  ],
))

== Связность

#definition[

  Граф называется *связным*, если между любыми двумя вершинами существует путь.
Связные части графа называются его *компонентами связности*.
]


#align(center, diagram(
  node-stroke: .1em,
  spacing: 2em,
  {
    let nodes = (
      ((0, 0), "A", blue.transparentize(50%)),
      ((1, 0), "B", blue.transparentize(50%)),
      ((0, 1), "C", blue.transparentize(50%)),
      ((2, 0), "D", green.transparentize(50%)),
      ((3, 0), "E", green.transparentize(50%)),
      ((2, 1), "F", green.transparentize(50%)),
      ((3, 1), "G", green.transparentize(50%)),
      ((4, 0.5), "H", red.transparentize(50%)),
    )

    let edges = (
      ("A", "B", 0),
      ("B", "C", 0),
      ("C", "A", 0),
      ("D", "E", 0),
      ("D", "F", 0),
      ("F", "G", 0),
      ("G", "E", 0),
    )

    for ((x, y), name, fill) in nodes {
      node((x, y), name, name: name, fill: fill)
    }

    for (from, to, _) in edges {
      edge(label(str(from)), label(str(to)))
    }
  }
))

Компонены связности на графе сверху: ${A, B, C}$, ${D, E, F, G}$, ${H}$

== Дерево
#definition[

*Дерево* - связный граф без циклов.
] 


#align(center, diagram(
  node-stroke: .1em,
  spacing: 2em,
  {
    let edges = (
      ("A", "B", 0),
      ("A", "C", 0),
      ("B", "D", 0),
      ("B", "E", 0),
    )

    draw_base_graph(edges: edges)
  }
))

== Лоза

#definition[*Лоза (бамбук)* - дерево, в котором каждая вершина имеет степень не более двух, представляющее собой линейную структуру (цепь вершин без ветвления).]

#align(center, diagram(
  node-stroke: .1em,
  spacing: 0.5em,
  {
    let nodes = (
      ((0, 0), "A"),
      ((1, 1), "B"),
      ((2, 2), "C"),
      ((3, 3), "D"),
      ((4, 4), "E"),
    )

    let edges = (
      ("A", "B", 0),
      ("B", "C", 0),
      ("C", "D", 0),
      ("D", "E", 0),
    )

    draw_base_graph(edges: edges, nodes: nodes)
  }
))

== Ориентированный граф

#definition[

В *ориентированном графе* по каждому ребру можно проходить только в одном направлении.
]

#align(center, diagram(
  node-stroke: .1em,
  spacing: 2em,
  {
    draw_base_graph()

    for (from, to, _) in edges {
      edge(label(str(from)), label(str(to)), "-|>")
    }
  }
))

== Взвешенный граф

#definition[

Во *взвешенном графе* каждому ребру сопоставлен вес. Часто веса интерпретируются как длины ребер, а длиной пути считается сумма весов составляющих его ребер.
]

#align(center, diagram(
  node-stroke: .1em,
  spacing: 2em,
  {
    draw_base_graph()

    for (from, to, weight) in edges {
      edge(
        label(str(from)), label(str(to)), 
        label: weight, 
        label-pos: 50%,
        label-side: center,
      ) 
    }
  }
))

== Смежность
#definition[

Две вершины называются *соседними*, или *смежными*, если они соединены ребром. *Степенью* вершины называется число соседних с ней вершин
]

#align(center, diagram(
  node-stroke: .1em,
  spacing: 2em,
  {
    let edges = (
      ("A", "B", 5),
      ("A", "C", 1),
      ("B", "E", 7),
      ("C", "D", 7),
      ("D", "A", 0),
      ("D", "A", 0),
    )

    draw_base_graph(edges: edges)

    let degrees = (
      (3, -.5),
      (2, -.5),
      (2, .5),
      (2, .5),
      (1, -.5),
    )

    for (i, (val, dy)) in degrees.enumerate() {
      let (x,y) = nodes.at(i).at(0)
      node((x,y + dy), text(fill: blue)[#val], stroke: 0em)
    }
  }
))

== Смежность в орграфах
#definition[

В ориентированных графах степень вершины делится на *полустепень захода* (in-degree) и *полустепень выхода* (out-degree).
]
#v(-0.5em)
#definition[

*Полустепень захода* $deg^-(v)$ — число входящих ребер в вершину $v$.
]
#v(-0.5em)
#definition[

*Полустепень выхода* $deg^+(v)$ — число исходящих ребер из вершины $v$.
]
#v(-0.5em)
#definition[

*Общая степень*: $deg(v) = deg^-(v) + deg^+(v)$.
]
#v(-0.5em)
#align(center, grid(
  columns: 2,
  gutter: 1em,
  align(horizon)[
    #text(blue)[$deg(v)$]

    #text(green.darken(30%))[$deg^+(v)$]

    #text(red)[$deg^-(v)$]
  ]
  ,
  diagram(
  node-stroke: .1em,
  spacing: 1em,
  {
    draw_base_graph()

    let degrees = (
      ((3, 2, 1), -.6),
      ((3, 1, 2), -.6),
      ((2, 1, 1), .6),
      ((4, 2, 2), .6),
      ((2, 1, 1), -.6),
    )

    for (i, ((d, dp ,dm), dy)) in degrees.enumerate() {
      let (x,y) = nodes.at(i).at(0)
      node((x,y + dy), 
      [
        #text(fill: blue)[#d]#text(fill: green)[#dp]#text(fill: red)[#dm]
      ], stroke: 0em)
    }

    for (from, to, _) in edges {
      edge(label(str(from)), label(str(to)), "-|>")
    }
  }
)
))

== Двудольность

#definition[

Граф называется *двудольным*, если его вершины можно раскрасить в два цвета, так что цвета любых двух соседних вершин различны.
]

#align(center, diagram(
  node-stroke: .1em,
  spacing: 2em,
  {
    let nodes = (
      ((0, 0), "A", blue),
      ((1, 0), "B", blue),
      ((2, 0), "C", green),
      ((0, 1), "D", green),
      ((1, 1), "E", green),
      ((2, 1), "F", blue),
    )
    let edges = (
      ("A", "D", 5),
      ("A", "E", 1),
      ("B", "E", 7),
      ("C", "B", 7),
      ("E", "F", 0),
      ("C", "F", 0),
    )

    for ((x, y), name, color) in nodes {
      node((x, y), name, name: name, fill: color.transparentize(50%))
    }

    for (from, to, _) in edges {
      edge(label(str(from)), label(str(to)))
    }
  }
))


= Хранениe графа
== Список смежности
#definition[

*Список смежности* --- один из способов представления графа в виде коллекции списков вершин. Каждой вершине графа соответствует список, состоящий из «соседей» этой вершины. 
]

#align(center, grid(
  columns: 2,
  gutter: 5em,
  table(
    columns:2,
    "A", "B, C, D",
    "B", "A, D, E",
    "C", "A, D",
    "D", "A, B, C, E",
    "E", "B, D",
  ),
  diagram(
    node-stroke: .1em,
    spacing: 2em,
    {
      draw_base_graph()
    }
  )
))

#remark[В ориентированном случае обычно хранят ребро только для вершины из которой оно исходит. Во взвешанном случае так же в пару к вершине записывают вес.]

== Матрица смежности
#definition[

  *Матрица смежности* --- один из способов представления графа в виде матрицы.

  $A_(i,j) = display(cases(
    1 "if" (i, j) in E,
    0
  ))$
]

#align(center, grid(
  columns: 2,
  gutter: 5em,
  table(
    columns: 6,
    "", "A", "B", "C", "D", "E",
    "A", $0$, $1$, $1$, $1$, $0$,
    "B", $1$, $0$, $0$, $1$, $1$,
    "C", $1$, $0$, $0$, $1$, $1$,
    "D", $1$, $1$, $1$, $0$, $1$,
    "E", $0$, $0$, $1$, $1$, $0$,
  ),
  diagram(
    node-stroke: .1em,
    spacing: 2em,
    {
      draw_base_graph()
    }
  )
))

#remark[В ориентированном случае обычно хранят ребро только для вершины из которой оно исходит. Во взвешанном случае вместо единицы записывают вес.]

== Матрица инцидентности
#definition[

  *Матрица инцидентности* — матрица размера $V times E$, где строки соответствуют вершинам, столбцы — ребрам. Элемент матрицы равен 1, если вершина инцидентна ребру (для ориентированных графов: 1 для исходящего ребра, -1 для входящего).

]

#align(center, grid(
  columns: 2,
  gutter: 2em,
  table(
    columns: 8,
    "", "(A,B)", "(A,C)", "(B,E)", "(C,D)", "(D,A)", "(D,B)", "(E,D)",
    "A", $1$, $1$, $0$, $0$, $-1$, $0$, $0$,
    "B", $-1$, $0$, $1$, $0$, $0$, $-1$, $0$,
    "C", $0$, $-1$, $0$, $1$, $0$, $0$, $0$,
    "D", $0$, $0$, $0$, $-1$, $1$, $1$, $-1$,
    "E", $0$, $0$, $-1$, $0$, $0$, $0$, $1$,
  ),
  diagram(
    node-stroke: .1em,
    spacing: 2em,
    {
      draw_base_graph()

      for (from, to, _) in edges {
        edge(label(str(from)), label(str(to)), "-|>")
      }
    }
  )
))

#remark[В неориентированном случае обычно хранят 1 вместо -1. Во взвешанном случае вместо единицы записывают вес.]


== Сравнение

#align(center, table(
  columns: 4,
  "Операция", [Матрица\ смежности], [Список\ смежности], [Матрица\ инцидентности],
  "Память", $O(V^2)$, $O(V + E)$, $O(V times E)$,
  "Проверка существования ребра", $O(1)$, $O(V)$ , $O(E)$,
  "Получение списка соседей", $O(V)$, $O(1)$, $O(E)$,
  "Добавление ребра", $O(1)$, [$O(1)$ #footnote[\* Амортизированная временная сложность для списка смежности при добавлении ребра без проверки дубликатов.]], $O(V times E)$,
  "Удаление ребра", $O(1)$, $O(V)$ , $O(V times E)$,
  "Добавление вершины", $O(V^2)$, $O(1)$, $O(E)$,
  "Удаление вершины", $O(V^2)$, $O(E)$, $O(V times E)$
))

== Когда что использовать?

*Список смежности:*
- Для разреженных графов (малое число рёбер).
- Когда требуется быстрый обход соседей вершин.
- Подходит для динамических графов (частое добавление/удаление рёбер).
- Рекомендуется как дефолт для большинства задач на графы.

*Матрица смежности:*
- Для плотных графов (большое число рёбер близкое к $V^2$).
- Когда нужны быстрые проверки существования рёбер между любыми двумя вершинами.
- Полезна если граф редко изменяется, но расчёты проводятся многократно.
- Хороша для небольших графов из-за квадратичного потребления памяти.

==

*Матрица инцидентности:*
- Для теоретических расчётов (ранг графа, линейные теоремы).
- Когда анализируется инцидентность рёбер и вершин.
- В приложениях сетевого моделирования или физики.
- Редко используется на практике из-за потребления памяти и сложности изменений.

*Общие рекомендации:*
- Выбирать представление исходя из типичных операций (обход, проверка рёбер, изменения).
- Учитывать ограничения по памяти — список смежности наиболее экономный.

#hint[

  В рамках соревновательного программирования, *список смежности* --- почти всегда верный выбор
]
