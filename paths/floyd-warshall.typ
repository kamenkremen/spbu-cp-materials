#import "@preview/pepentation:0.2.0": *
#import "@preview/cetz:0.4.2"
#import "@preview/fletcher:0.5.8" as fletcher: diagram, node, edge

#let node = node.with(radius: 1em)

#show link: set text(fill: blue)
#show link: underline

#let nodes = (
  ((0, 0), "A"),
  ((2, 0), "B"),
  ((0, 2), "C"),
  ((2, 2), "D"),
)
#let edges = (
  ("A", "B", 3),
  ("A", "C", 5),
  ("B", "D", 2),
  ("C", "B", -2),
  ("C", "D", 1),
)

= Алгоритм Флойда-Уоршелла

== Постановка задачи

#definition[
*Задача о кратчайших путях для всех пар* (All-Pairs Shortest Paths, APSP):

Дан взвешенный ориентированный граф $G(V, E)$ с весами рёбер $w: E -> ZZ$. Для каждой пары вершин $(u, v)$ требуется найти длину кратчайшего пути от $u$ к $v$.
]

#remark[
В отличие от алгоритмов Дейкстры и Беллмана-Форда, алгоритм Флойда-Уоршелла находит кратчайшие пути между всеми парами вершин за один запуск.
]

== Идея алгоритма

#hint[
Основная идея — динамическое программирование по промежуточным вершинам.
]

== DP постановка

Построим динамику:
- Состояние: $"dp"_k(i,j)$ — длина кратчайшего пути от $i$ к $j$, где все промежуточные вершины принадлежат множеству ${1, 2, ..., k}$
- База DP: $"dp"_0(i,j)$ — длина кратчайшего пути без промежуточных вершин (только direct edge или $infinity$)
- Переход: ?

== Переход

Путь от $i$ к $j$ с промежуточными вершинами из множества ${1..k}$:

#grid(
  columns: 2,
  column-gutter: 2em,
  align: center + horizon,
  block(stroke: black, inset: 1em, radius: 5pt)[
    Не использовать вершину $k$:
    $"dp"_(k-1)(i,j)$
  ],
  block(stroke: green, inset: 1em, radius: 5pt, fill: green.lighten(90%))[
    Использовать вершину $k$:
    $"dp"_(k-1)(i,k) + "dp"_(k-1)(k,j)$
  ]
)

Рекуррентное соотношение:
#align(center)[
$ "dp"_(k)(i,j) = min("dp"_(k-1)(i,j), "dp"_(k-1)(i,k) + "dp"_(k-1)(k,j))$
]

== Пример

Рассмотрим граф:

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
    *Начальная матрица:*
    #table(
      columns: 5,
      align: center,
      table.header(
        table.cell(fill: gray.lighten(80%))[], [A], [B], [C], [D]
      ),
      [A], $0$, $3$, $5$, $infinity$,
      [B], $infinity$, $0$, $infinity$, $2$,
      [C], $infinity$, $-2$, $0$, $1$,
      [D], $infinity$, $infinity$, $infinity$, $0$,
    )
  ]
)
]

== Реализация

```cpp
const long long INF = 1e18;
vector<vector<long long>> dist(n, vector<long long>(n, INF));

for (int i = 0; i < n; ++i) dist[i][i] = 0;
for (auto [u, v, w] : edges) dist[u][v] = w;

for (int k = 0; k < n; ++k)
    for (int i = 0; i < n; ++i)
        for (int j = 0; j < n; ++j)
            if (dist[i][k] + dist[k][j] < dist[i][j])
                dist[i][j] = dist[i][k] + dist[k][j];
```

#remark[
Три вложенных цикла — это и есть алгоритм Флойда-Уоршелла. Очень компактный!
]

== Сложность

- *Временная сложность*: $O(V^3)$ — три вложенных цикла по $V$
- *Пространственная сложность*: $O(V^2)$ для матрицы расстояний

#remark[
Для плотных графов (много рёбер) — Флойд-Уоршелл. Для разреженных — Дейкстра $V$ раз.
]

== Отрицательные циклы

#warning[
Алгоритм Флойда-Уоршелла также может обнаруживать отрицательные циклы!

После выполнения, если $"dp"_n(i,i) < 0$ для какого-то $i$, то в графе есть отрицательный цикл, достижимый из $i$.
]

```cpp
bool hasNegativeCycle = false;
for (int i = 0; i < n; ++i) {
    if (dist[i][i] < 0) {
        hasNegativeCycle = true;
        break;
    }
}
```

== Восстановление пути

Для восстановления конкретного пути храним матрицу `next`. Изначально, если есть ребро $i -> j$, полагаем `next[i][j] = j`, иначе `next[i][j] = -1`. При релаксации через $k$: если `dist[i][k] + dist[k][j] < dist[i][j]`, то обновляем `dist[i][j]` и устанавливаем `next[i][j] = next[i][k]`.

== 

```cpp
vector<vector<int>> next(n, vector<int>(n, -1));
for (int i = 0; i < n; ++i)
    for (int j = 0; j < n; ++j)
        if (dist[i][j] != INF && i != j)
            next[i][j] = j;

for (int k = 0; k < n; ++k)
    for (int i = 0; i < n; ++i)
        for (int j = 0; j < n; ++j)
            if (dist[i][k] + dist[k][j] < dist[i][j]) {
                dist[i][j] = dist[i][k] + dist[k][j];
                next[i][j] = next[i][k];
            }
```
==
```cpp
vector<int> get_path(int i, int j) {
    if (dist[i][j] == INF) return {};
    if (next[i][j] == -1) return {};
    vector<int> path;
    int cur = i;
    while (cur != j) {
        path.push_back(cur);
        cur = next[cur][j];
    }
    path.push_back(j);
    return path;
}
```

#remark[
Матрица `next` добавляет $O(V^2)$ памяти, что совпадает с пространственной сложностью алгоритма.
]


== Практические задачи

- *Shortest Path Distance Between All Pairs*: #link("https://leetcode.com/problems/find-the-city-with-the-smallest-number-of-neighbors-at-a-threshold-distance/")[LeetCode 1334]

- *Evaluate Division*: #link("https://leetcode.com/problems/evaluate-division/")[LeetCode 399] (похожая задача)

- *Флойд-Уоршелл*: #link("https://acmp.ru/?main=task&id_task=175")[acmp.ru 175]
