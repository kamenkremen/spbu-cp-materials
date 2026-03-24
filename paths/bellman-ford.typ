#import "@preview/pepentation:0.2.0": *
#import "@preview/cetz:0.4.2"
#import "@preview/fletcher:0.5.8" as fletcher: diagram, node, edge

#let node = node.with(radius: 1em)

#show link: set text(fill: blue)
#show link: underline

#let nodes = (
  ((0, 0), "S"),
  ((2, 0), "A"),
  ((4, 0), "B"),
  ((2, 2), "C"),
)
#let edges = (
  ("S", "A", 4),
  ("S", "C", 2),
  ("A", "B", -3),
  ("A", "C", 1),
  ("C", "A", 3),
  ("C", "B", 2),
)

= Алгоритм Беллмана-Форда

== Постановка задачи

#definition[
Задача о кратчайших путях с одним источником для графов с произвольными весами (в том числе отрицательными):

Дан взвешенный ориентированный граф $G(V, E)$ с весами рёбер $w: E -> ZZ$ и выделенная вершина $s$. Для каждой вершины $v in V$ требуется найти длину кратчайшего пути от $s$ к $v$.
]

#remark[
В отличие от алгоритма Дейкстры, алгоритм Беллмана-Форда работает с произвольными весами рёбер.
]

== Идея алгоритма

#hint[
Основная идея — динамическое программирование по количеству рёбер в пути.
]

#definition[
Кратчайший путь без циклов (простой путь) содержит не более $|V| - 1$ рёбер.
]

#warning[
Если есть отрицательный цикл, достижимый из источника, то кратчайший путь не определён.
]

== DP постановка

Построим динамику:
- Состояние: $"dp"_k(v)$ — длина кратчайшего пути от $s$ к $v$, содержащего не более $k$ рёбер
- База DP: $"dp"_0(s) = 0$, $"dp"_0(v) = +infinity$ для $v != s$
- Переход: 

Чтобы найти путь к $v$ за $k+1$ ребро, рассмотрим последнее ребро $(u, v)$:

#grid(
  columns: 2,
  column-gutter: 2em,
  align: center + horizon,
  block(stroke: black, inset: 1em, radius: 5pt)[
    Не использовать ребро $(u, v)$:
    $"dp"_(k-1)(v)$
  ],
  block(stroke: green, inset: 1em, radius: 5pt, fill: green.lighten(90%))[
    Использовать ребро $(u, v)$:
    $"dp"_(k-1)(u) + w(u, v)$
  ]
)

Рекуррентное соотношение:
#align(center)[
$ "dp"_(k)(v) = min("dp"_(k-1)(v), "min"_(u:" (u,v)" in E) "dp"_(k-1)(u) + w(u, v))$
]

== Пример

Начнём из вершины S (источник).

#align(center)[
#grid(
  columns: 2,
  column-gutter: 2em,
  align: center + horizon,
  [
    #diagram(
      node-stroke: .1em,
      spacing: 2em,
      {
        for (pos, name) in nodes {
          node(pos, name, name: name)
        }
        for (from, to, w) in edges {
          let w-color = if w < 0 { red } else { black }
          edge(label(str(from)), label(str(to)), label: str(w), stroke: (paint: w-color))
        }
      }
    )
  ],
  [
    #table(
      columns: 5,
      align: center,
      table.header(
        table.cell(fill: gray.lighten(80%))[$k$ \ $v$], $S$, $A$, $B$, $C$
      ),
      table.cell(fill: gray.lighten(90%))[$0$],
      $0$, $infinity$, $infinity$, $infinity$,
      
      table.cell(fill: gray.lighten(90%))[$1$],
      $0$, $4$, $1$, $2$,

      table.cell(fill: gray.lighten(90%))[$2$],
      $0$, $3$, $1$, $2$,

      table.cell(fill: gray.lighten(90%))[$3$],
      $0$, $3$, $1$, $2$,
    )
  ]
)
]

#remark[
На самом деле, после итерации 2 ничего не меняется, потому что кратчайший путь содержит 2 ребра.
]

== Оптимизация

Заметим, что нам не нужно хранить всю таблицу --- достаточно только текущего и предыдущего состояния.

```cpp
vector<long long> dist(n, INF);
dist[s] = 0;
for (int i = 0; i < n - 1; ++i) {
    for (auto [u, v, w] : edges) {
        if (dist[u] != INF && dist[u] + w < dist[v]) {
            dist[v] = dist[u] + w;
        }
    }
}
```
#v(-1em)
#remark[
После $|V| - 1$ итерации все кратчайшие пути найдены (если нет отрицательных циклов).
]

== Проверка на отрицательные циклы

После основных итераций делаем ещё одну проверку:

```cpp
for (int i = 0; i < n; ++i) {
    for (auto [u, v, w] : edges) {
        if (dist[u] != INF && dist[u] + w < dist[v]) {
            // Отрицательный цикл обнаружен!
            dist[v] = -INF;
        }
    }
}
```

#warning[
Если на $(|V|)$-й итерации происходит улучшение — есть отрицательный цикл, достижимый из $s$.
]

== Сложность

- *Временная сложность*: $O(V \cdot E)$ — $|V| - 1$ итерация, на каждой просматриваем все $E$ рёбер
- *Пространственная сложность*: $O(V)$ для хранения расстояний

== Восстановление пути

Для восстановления пути храним массив `parent`. Инициализируем `parent[s] = -1`, для остальных вершин `parent[v] = -1`. При релаксации ребра $(u -> v)$, если `dist[u] + w < dist[v]`, обновляем `dist[v]` и записываем `parent[v] = u`. После завершения алгоритма путь от $s$ к вершине $t$ восстанавливается двигаясь от $t$ к $s$ по массиву `parent`.

==

```cpp
vector<int> parent(n, -1);

for (auto [u, v, w] : edges) {
    if (dist[u] != INF && dist[u] + w < dist[v]) {
        dist[v] = dist[u] + w;
        parent[v] = u;
    }
}
```

==

```cpp
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
При наличии отрицательного цикла, достижимом из $s$, некоторые вершины могут получить значение $-infinity$, и путь до них неоднозначен.
]
== Когда использовать

#table(
  columns: (auto, auto),
  [*Алгоритм Дейкстры*], [*Алгоритм Беллмана-Форда*],
  [$O((V+E) log V)$], [$O(V \cdot E)$],
  [Только неотрицательные веса], [Произвольные веса],
  [Проще, быстрее], [Медленнее, но универсальнее],
  [Нет проверки циклов], [Может detect negative cycles],
)

#hint[
Если все веса неотрицательны — используйте Дейкстру. Если есть отрицательные веса — Беллман-Форд.
]

== Практические задачи

- *Network Delay Time*: #link("https://leetcode.com/problems/network-delay-time/")[LeetCode 743]

- *Shortest Path in Binary Matrix*: #link("https://leetcode.com/problems/shortest-path-in-binary-matrix/")[LeetCode 1293]

- *Отрицательный цикл*: #link("https://acmp.ru/?main=task&id_task=175")[acmp.ru 175]
