#import "@preview/pepentation:0.2.0": *
#import "@preview/cetz:0.4.2"
#import "@preview/fletcher:0.5.8" as fletcher: diagram, node, edge

#let node = node.with(radius: 1em)

#show link: set text(fill: blue)
#show link: underline

#let nodes = (
  ((0, 0), "A"),
  ((2, 0), "B"),
  ((0, 1.5), "C"),
  ((2, 1.5), "D"),
  ((3, 0.75), "E"),
)
#let edges = (
  ("A", "B", 4),
  ("A", "C", 2),
  ("B", "C", 1),
  ("C", "B", 1),
  ("B", "D", 3),
  ("B", "E", 5),
  ("C", "D", 4),
  ("D", "E", 2),
)

= Алгоритм Дейкстры

#let draw_graph(distances: (), processed: (), current: none, queue-edges: ()) = {
  for (pos, name) in nodes {
    let fill-color = if current == name {
      gray.transparentize(50%)
    } else if name in processed {
      green.transparentize(50%)
    } else { none }

    let display-dist = if name in distances {
      str(distances.at(name))
    } else { $infinity$ }
    
    node(pos, text(size: 0.9em, [#name \ #display-dist]), name: name, fill: fill-color)
  }

  for (from, to, w) in edges {
    let stroke-color = if (from, to) in queue-edges {
      orange
    } else { black }
    let text-color = if (from, to) in queue-edges {
      orange
    } else { black }
    edge(label(str(from)), label(str(to)), label-pos: 50%, label-side: center, label: text(text-color, str(w)), stroke: (paint: stroke-color, thickness: 1.5pt))
  }
}

#let step = (distances, processed, current, queue-list) => {
  let queue-edges = if queue-list.len() == 0 {
    ()
  } else {
    queue-list.map(x => (x.at(0), x.at(1)))
  }
  let queue-text = if queue-list.len() == 0 {
    "пусто"
  } else {
    queue-list.map(x => {
      x.at(0) + "→" + x.at(1) + "(" + str(x.at(2)) + ")"
    }).join(", ")
  }
  table.cell()[
    #diagram(
      node-stroke: .08em,
      spacing: 0.9em,
      {
        draw_graph(distances: distances, processed: processed, current: current, queue-edges: queue-edges)
      }
    )
    #align(center)[#info[ #queue-text]]
  ]
}

== Постановка задачи

#definition[
*Задача о кратчайших путях с одним источником* (Single-Source Shortest Paths, SSSP):

Дан взвешенный ориентированный граф $G(V, E)$ с весами рёбер $w: E -> RR$ и выделенная вершина $s$. Для каждой вершины $v in V$ требуется найти длину кратчайшего пути от $s$ к $v$.
]

== Идея алгоритма

Алгоритм Дейкстры работает по принципу "жадного" выбора: мы поддерживаем множество вершин $U$, для которых уже вычислены длины кратчайших путей до них из $s$. На каждой итерации основного цикла выбирается вершина $u in.not U$, которой на текущий момент соответствует минимальная оценка кратчайшего пути. Вершина $u$ добавляется в множество $U$ и производится релаксация всех исходящих из неё рёбер. 

== Пример

Рассмотрим граф:

#align(center)[
#diagram(
  node-stroke: .08em,
  spacing: 1em,
  {
    draw_graph(distances: ("A": 0), processed: (), current: "A")
  }
)
]

Начнём из вершины A (источник).

=== Пример: пошаговая демонстрация

#align(horizon)[
#table(
  columns: (auto, auto, auto),
  align: center,
  step(("A": 0), (), "A", (("A", "C", 2), ("A", "B", 4))),
  step(("A": 0, "B": 4, "C": 2), ("A",), "C", (("C", "B", 1), ("A", "B", 4), ("C", "D", 4))),
  step(("A": 0, "B": 3, "C": 2, "D": 6), ("A", "C"), "B", (("B", "D", 3), ("B", "E", 5))),
  )
]

==

#align(horizon)[
  #table(
    columns: (auto, auto, auto),
    align: center,
    step(("A": 0, "B": 3, "C": 2, "D": 6, "E": 8), ("A", "C", "B"), "D", (("D", "E", 2), ("B", "E", 5))),
    step(("A": 0, "B": 3, "C": 2, "D": 6, "E": 8), ("A", "C", "B", "D"), "E", (("B", "E", 5),)),
    step(("A": 0, "B": 3, "C": 2, "D": 6, "E": 8), ("A", "C", "B", "D", "E"), "E", ()),
  )
  
  #v(2em)
  #align(center)[
    #table(
      columns: 6,
      align: center,
      "Вершина", "A", "B", "C", "D", "E",
      "Расстояние от A", "0", "3", "2", "6", "8",
    )
  ]
]

== Ограничения

#warning[
Алгоритм Дейкстры работает только с неотрицательными весами рёбер!

При наличии отрицательных весов алгоритм может дать неверный ответ.
]

#align(center)[
#let nodes = (
  ((0, 0), "S"),
  ((2, 0), "A"),
  ((1, 1.5), "B"),
)
#let edges = (
  ("S", "A", 2),
  ("S", "B", 5),
  ("A", "B", -4),
)

#diagram(
  node-stroke: .1em,
  spacing: 2.5em,
  {
    for (pos, name) in nodes {
      node(pos, name, name: name)
    }
    for (from, to, w) in edges {
      edge(label(str(from)), label(str(to)), label: str(w), stroke: (paint: black))
    }
  }
)
]

Алгоритм Дейкстры даст $S -> B = 5$, но правильный ответ: $2 + (-4) = -2$

== Реализация

```cpp
vector<int> dist(n, INF);
vector<bool> used(n, false);
priority_queue<pair<int, int>, vector<pair<int, int>>, greater<pair<int, int>>> pq;
```

#remark[
В коде используется `greater<>` для создания min-heap вместо max-heap (по умолчанию в C++).

Альтернатива `greater<>` — хранить отрицательные значения: `pq.push({-dist[v], v})`.
]

==

```cpp
dist[s] = 0;
pq.push({0, s});
while (!pq.empty()) {
    auto [d, v] = pq.top();
    pq.pop();
    if (used[v]) continue;
    used[v] = true;
    for (auto [to, w] : g[v]) {
        if (dist[v] + w < dist[to]) {
            dist[to] = dist[v] + w;
            pq.push({dist[to], to});
        }
    }
}
```

== Сложность

- *Временная сложность*: $O((V + E) log V)$ — каждая вершина извлекается из очереди 1 раз, каждое ребро рассматривается 1 раз

- *Пространственная сложность*: $O(V + E)$ для хранения графа и расстояний


#info[
В плотном графе ($E approx V^2$) сложность можно улучшить до $O(V^2)$ используя обычный массив вместо priority queue.
]

== Доказательство корректности

#definition[
*Теорема.* Пусть $w >= 0$ для всех рёбер. После извлечения вершины $v$ из приоритетной очереди, $d(v) = d^*(s, v)$, где $d^*$ — длина кратчайшего пути.
]

*Доказательство.* Индукция по количеству извлечённых вершин.

*База.* После первой итерации $d(s) = 0 = d^*(s, s)$.

==

*Шаг.* Пусть после $k$ итераций для всех извлечённых вершин $d = d^*$. Рассмотрим $(k+1)$-ю вершину $v$. Все вершины в очереди имеют $d >= d(v)$.

Возьмём кратчайший путь $P = s -> ... -> x -> v$. Вершины на $P$ кроме $v$ уже извлечены. Пусть $x$ — предпоследняя. Тогда $x$ обработана, и алгоритм установил $d(v) <= d(x) + w = d^*(s, x) + w = d^*(s, v)$.

Так как $d(v)$ минимально в очереди, $d(v) >= d^*(s, v)$. Следовательно, $d(v) = d^*(s, v)$.

#remark[
Ключевое свойство: при неотрицательных весах, если мы достаём вершину с минимальным distance из очереди, то никакой другой путь не может дать меньшее расстояние — потому что любой другой путь должен пройти через вершину с расстоянием не меньше текущей.
]

== Восстановление пути

Для восстановления пути храним массив предков `parent`. При релаксации ребра $(v -> u)$, если `dist[v] + w < dist[to]`, устанавливаем `parent[to] = v`. После завершения алгоритма путь от $s$ к $t$ восстанавливается двигаясь от $t$ к $s$ по массиву `parent` и разворачиванием.

==

```cpp
vector<int> parent(n, -1);
if (dist[v] + w < dist[to]) {
    dist[to] = dist[v] + w;
    parent[to] = v;
    pq.push({dist[to], to});
}
vector<int> get_path(int t) {
    if (dist[t] == INF) return {};
    vector<int> path;
    for (int v = t; v != -1; v = parent[v])
        path.push_back(v);
    reverse(path.begin(), path.end());
    return path;
}
```

#remark[
Восстановление одного пути требует $O(L)$ времени и $O(V)$ дополнительной памяти.
]


== Практические задачи

- *Network Delay Time*: #link("https://leetcode.com/problems/network-delay-time/")[LeetCode 743]

- *Find the City With the Smallest Number of Neighbors*: #link("https://leetcode.com/problems/find-the-city-with-the-smallest-number-of-neighbors-at-a-threshold-distance/")[LeetCode 1334]

- *Min Cost to Reach Destination*: #link("https://leetcode.com/problems/minimum-cost-to-reach-destination-in-time/")[LeetCode 1928]

- *Кратчайший путь*: #link("https://acmp.ru/?main=task&id_task=164")[acmp.ru 164]
