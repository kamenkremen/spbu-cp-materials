#import "@preview/pepentation:0.1.0": *
#import "@preview/cetz:0.4.2"
#import "@preview/fletcher:0.5.8" as fletcher: diagram, node, edge

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

#let node = node.with(radius: 1em)

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

#show link: set text(fill: blue)
#show link: underline

#let draw_base_graph(nodes: nodes, edges: edges) = {
    for (pos, name) in nodes {
      node(pos, name, name: name)
    }

    for (from, to, _) in edges {
      edge(label(str(from)), label(str(to)))
    }
}

= Поиск в ширину

== Определение
#v(-1em)

#definition[
*Поиск в ширину* (Breadth-First Search, BFS) — метод обхода графа, при котором мы идем слоями по ребрам графа, начиная с ближайших соседей.
]

Алгоритм BFS начинает обход с некоторой выбранной вершины. Он использует очередь для посещения вершин по уровням: сначала все соседи текущей вершины, затем их соседи, и так далее.

Визуально BFS можно представить как распространение волны от начальной вершины, слой за слоем.

==

#align(center)[
  #v(-1em)
  #let node = node.with(radius: 0.9em)
  #let nodes = (
    ((0,0), 1),
    ((-2,1), 2),
    ((0,1), 3),
    ((2,1), 4),
    ((-2.5,2), 5),
    ((-1.5,2), 6),
    ((-0.5,2), 7),
    ((0.5,2), 8),
    ((1.5,2), 9),
    ((2.5,2), 10),
  )
  #let edges = (
    (1,2),
    (1,3),
    (1,4),
    (2,5),
    (2,6),
    (3,7),
    (3,8),
    (4,9),
    (4,10),
  )

  #let draw_graph(path: (), visited: (), arrow_path: ()) = {
    for (pos, name) in nodes {
      let fill-color = if name in path {
        if arrow_path.len() > 0 and name == arrow_path.last() {
          gray.transparentize(50%)
        }
        else {
          yellow.transparentize(50%)
        }
      } else if name in visited {
        green.transparentize(50%)
      } else { none }

      name = str(name)
      node(pos, name, name: name, fill: fill-color)
    }

    for (from, to) in edges {
      edge(label(str(from)), label(str(to)))
    }

    for i in range(0, arrow_path.len()-1){
      edge(label(str(arrow_path.at(i))), label(str(arrow_path.at(i+1))), "-|>", stroke: (paint: red, thickness: 0.8pt))
    }
  }
  #grid(
    align: horizon,
    columns: 5,
    "",
    row-gutter: 1em,
    diagram(
      node-stroke: .1em,
      spacing: 0.7em,
      {
        draw_graph(path: (1,), arrow_path: (1,))
      }
    ), 
    arrow(),
    diagram(
      node-stroke: .1em,
      spacing: 0.7em,
      {
        draw_graph(path: (1,2,3,4), arrow_path: (1,2))
      }
    ),
    arrow(),
    arrow(),
    diagram(
      node-stroke: .1em,
      spacing: 0.7em,
      {
        draw_graph(path: (1,2,3,4,5,6,7,8,9,10), arrow_path: (1,2,5))
      }
    ),
    arrow(),
    diagram(
      node-stroke: .1em,
      spacing: 0.7em,
      {
        draw_graph(path: (1,2,3,4), arrow_path: (1,2), visited: (5,6,7,8,9,10))
      }
    ),
    [#arrow()$...$]
  )
]

Порядок выхода из функции: ${5,6,7,8,9,10,2,3,4,1}$

#definition[

 Такой порядок обхода называется *уровневым (breadth-first) обходом дерева*
]

== Реализация
#v(-1em)
#text(size:0.9em)[
  ```cpp
  void bfs(int start) {
    queue<int> q;
    q.push(start);
    visited[start] = true;

    while (!q.empty()) {
      int v = q.front();
      q.pop();

      for (int u : adj[v]) {
        if (!visited[u]) {
          visited[u] = true;
          q.push(u);
        }
      }
    }
  }
  ```
]



== Сложность

- *Временная сложность*: $O(V + E)$, где $V$ — количество вершин, $E$ — количество рёбер. Каждая вершина и каждое ребро посещается постоянное число раз.

- *Пространственная сложность*: $O(V)$ для хранения массива visited и очереди. В худшем случае (линейный граф) может потребоваться $O(V)$ очереди.

BFS работает оптимально по времени для невзвешенных графов, находя кратчайшие пути по количеству рёбер.

=== Практические задачи

- *Binary Tree Level Order Traversal*: #link("https://leetcode.com/problems/binary-tree-level-order-traversal/")[LeetCode 102]

- *Binary Tree Zigzag Level Order Traversal*: #link("https://leetcode.com/problems/binary-tree-zigzag-level-order-traversal/")[LeetCode 103]

- *Walls and Gates*: #link("https://leetcode.com/problems/walls-and-gates/")[LeetCode 286]

- *Поиск в ширину*: #link("https://acmp.ru/?main=task&id_task=87")[acmp.ru 87]

== Компоненты связности

Дан неориентированный граф. Требуется найти все компоненты связности, а также определить к какой из компонент относится каждая вершина.

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

Компоненты связности графа сверху: ${A, B, C}$, ${D, E, F, G}$, ${H}$.

==
#v(-1em)
```cpp
void bfs(int v, int u) {
    queue<int> q;
    q.push(v);
    visited[v] = u;

    while (!q.empty()) {
        int w = q.front();
        q.pop();
        for (int i : adj[w]) {
            if (!visited[i]) {
                visited[i] = u;
                q.push(i);
            }
        }
    }
}
```
==
#v(-1em)
```cpp
vector<vector<int>> adj;
vector<int> visited;

int main(){
  // Считывание

  int n = adj.size();
  visited.assign(n, 0);
  for (int i = 0; i < n; ++i) {
    if (!visited[i]) {
      bfs(i, i);
    }
  }

  // Вывод
}
```

#v(-1em)
#remark[Работает за $O(V+E)$.]

=== Практические задачи

- *Number of Islands*: #link("https://leetcode.com/problems/number-of-islands/")[LeetCode 200]

- *Assigning Components*: #link("https://www.spoj.com/problems/PT07Y/")[SPOJ "PT07Y"]

- *Граф*: #link("https://acmp.ru/index.asp?main=task&id_task=713")[acmp.ru 713]

- *Телефонный справочник*: #link("https://acm.timus.ru/problem.aspx?space=1&num=1002")[Timus 1002]

== Лабиринт

  Вы находитесь в лабиринте, карту которого можно расположить на тетрадном листе. В клетки либо можно находиться самому, либо в ней находится стена. Ваша задача --- найти кратчайший путь из лабиринта.

  На примере снизу требуется найти кратчайший путь от клетки S, до клетки E.

#align(center, table(
  fill: (x, y) => {
    let maze = (
      (0, 0, 1, 0, 0),
      (0, "S", 1, 0, 1),
      (1, 0, 0, 0, 0),
      (0, 0, 1, 1, 0),
      (1, 0, 0, "E", 0),
    )
    let val = maze.at(y).at(x)
    if val == "S" { blue.transparentize(50%) }
    else if val == "E" { red.transparentize(50%) }
    else if val == 1 { black }
    else { white }
  },
  columns: (2em, )*5,
  rows: 2em,
  align: center+horizon,
  [], [], [], [], [],
  [], [*S*], [], [], [],
  [], [], [], [], [],
  [], [], [], [], [],
  [], [], [], [*E*], []
))

=== Решение

#definition[

*Алгоритм Ли (волновой алгоритм)* - применение BFS для поиска кратчайшего пути в матрице, например в лабиринте.
]

Представим сетку матрицу граф, где каждая клетка - вершина, соседние клетки соединены рёбрами (обычно 4 направления: вверх, вниз, влево, вправо).

BFS "волна" распространяется от старта, каждая волна - новый уровень расстояния. В таблице ниже показан шаг-за-шага прогресс волнового алгоритма на данном лабиринте.

Запишем в стартовую клетку 0, а затем будем запускать бфс и записывать значение на 1 больше во все соседние клетки.

==

#align(center)[
  #let maze(step, content) = {
    let content_grid = range(5).map(y => 
      range(5).map(x => content.at(y * 5 + x))
    )

    table(
      fill: (x, y) => {
        let maze = (
          (0, 0, 1, 0, 0),
          (0, "S", 1, 0, 1),
          (1, 0, 0, 0, 0),
          (0, 0, 1, 1, 0),
          (1, 0, 0, "E", 0),
        )
        let val = maze.at(y).at(x)
        let fill-color = if val == "S" { blue.transparentize(50%) }
        else if val == "E" { red.transparentize(50%) }
        else if val == 1 { black }
        else {white}

        if content_grid.at(y).at(x) == step {
          fill-color = yellow.transparentize(50%).mix(fill-color)
        }
        fill-color
      },
      columns: (1.5em, )*5,
      rows: 1.5em,
      align: center+horizon,
      ..content
    )
  }

  #grid(
    columns: 7,
    gutter: 1em,
    align: horizon,
    "",
    maze(1,
      ([], [], [], [], [],
      [], [*0*], [], [], [],
      [], [], [], [], [],
      [], [], [], [], [],
      [], [], [], [], [])
    ),
    arrow(),
    maze([*1*],
      ([], [*1*], [], [], [],
      [*1*], [*0*], [], [], [],
      [], [*1*], [], [], [],
      [], [], [], [], [],
      [], [], [], [], [])
    ),
    arrow(),
    maze([*2*],
      ([*2*], [*1*], [], [], [],
      [*1*], [*0*], [], [], [],
      [], [*1*], [*2*], [], [],
      [], [*2*], [], [], [],
      [], [], [], [], [])
    ),
    arrow(),
    arrow(),
    maze([*3*],
      ([*2*], [*1*], [], [], [],
      [*1*], [*0*], [], [], [],
      [], [*1*], [*2*], [*3*], [],
      [*3*], [*2*], [], [], [],
      [], [*3*], [], [], [])
    ),
    arrow(),
    maze([*4*],
      ([*2*], [*1*], [], [], [],
      [*1*], [*0*], [], [*4*], [],
      [], [*1*], [*2*], [*3*], [*4*],
      [*3*], [*2*], [], [], [],
      [], [*3*], [*4*], [], [])
    ),
    arrow(),
    maze([*5*],
      ([*2*], [*1*], [], [*5*], [*6*],
      [*1*], [*0*], [], [*4*], [],
      [], [*1*], [*2*], [*3*], [*4*],
      [*3*], [*2*], [], [], [*5*],
      [], [*3*], [*4*], [*5*], [*6*])
    ),
  )
]

==
#v(-1em)
#text(size: 0.8em)[
```cpp
int dx[4] = {0,1,0,-1};
int dy[4] = {1,0,-1,0};
void bfs() {
    queue<pair<int,int>> q;
    q.push({sx, sy});
    dist[sx][sy] = 0;

    while (!q.empty()) {
        auto [x, y] = q.front();
        q.pop();
        if (x == ex && y == ey) return dist[x][y];

        for (int d = 0; d < 4; d++) {
            int nx = x + dx[d], ny = y + dy[d];
            if (nx >= 0 && nx < n && ny >= 0 && ny < m &&
                grid[nx][ny] == 0 && dist[nx][ny] == -1) {
                dist[nx][ny] = dist[x][y] + 1;
                q.push({nx, ny});
            }
        }
    }
}
```
]

=== Восстановление пути

После выполнения BFS матрица `dist` содержит расстояния от стартовой позиции. Для восстановления пути производим обратный обход: начиная с конечной позиции, ищем соседние клетки с расстоянием на 1 меньшим, пока не достигнем стартовой.

#align(center)[
  #let content = ([*2*], [*1*], [], [*5*], [*6*],
  [*1*], [*0*], [], [*4*], [],
  [], [*1*], [*2*], [*3*], [*4*],
  [*3*], [*2*], [], [], [*5*],
  [], [*3*], [*4*], [*5*], [*6*])
  #let content_grid = range(5).map(y => 
      range(5).map(x => content.at(y * 5 + x))
    )

  #table(
    fill: (x, y) => {
      let maze = (
        (0, 0, 1, 0, 0),
        (0, "S", 1, 0, 1),
        (1, 0, 0, 0, 0),
        (0, 0, 1, 1, 0),
        (1, 0, 0, "E", 0),
      )
      let val = maze.at(y).at(x)
      let fill-color = if val == "S" { blue.transparentize(50%) }
      else if val == "E" { red.transparentize(50%) }
      else if val == 1 { black }
      else {white}

      fill-color
    },
    columns: (1.5em, )*5,
    rows: 1.5em,
    align: center+horizon,
    ..content
  )
]

==
#v(-1.5em)
```cpp
vector<pair<int,int>> path(int sx, int sy, int ex, int ey) {
    vector<pair<int,int>> path;
    int x = ex, y = ey;
    while (x != sx || y != sy) {
        path.push_back({x, y});
        for (int d = 0; d < 4; d++) {
            int nx = x + dx[d], ny = y + dy[d];
            if (nx >= 0 && nx < n && ny >= 0 && ny < m &&
                dist[nx][ny] == dist[x][y] - 1) {
                x = nx; y = ny;
                break;
            }
        }
    }
    path.push_back({sx, sy});
    reverse(path.begin(), path.end());
    return path;
}
```

=== Практические задачи

- *Лабиринт*: #link("https://leetcode.com/problems/the-maze/")[LeetCode 490]

- *Кратчайший путь в двоичной матрице*: #link("https://leetcode.com/problems/shortest-path-in-binary-matrix/")[LeetCode 1091]

- *Klorox*: #link("https://www.spoj.com/problems/KLORO/")[SPOJ "KLORO"]

- *Графы*: #link("https://acmp.ru/index.asp?main=task&id_task=712")[acmp.ru 712]

== Кратчайший путь в невзвешенном графе

Дан невзвешенный граф. Требуется найти кратчайший путь (по количеству рёбер) между двумя вершинами start и end.

#align(center, diagram(
  node-stroke: .1em,
  spacing: 2em,
  {
    node((0,0), "A", name: "A", fill: blue.transparentize(50%))
    node((2,0), "B", name: "B")
    node((1,1), "C", name: "C")
    node((2,1), "D", name: "D")
    node((4,0.5), "E", name: "E", fill: red.transparentize(50%))

    edge(label("A"), label("B"))
    edge(label("A"), label("C"))
    edge(label("B"), label("E"))
    edge(label("B"), label("C"))
    edge(label("B"), label("D"))
    edge(label("C"), label("D"))
    edge(label("D"), label("E"))

    node((0, 0.4), stroke: none, text(fill: blue)[Start])
    node((4, 0.1), stroke: none, text(fill: red)[End])
  }
))
=== Решение

В стартовую вершину запишем 0. Во все последущие посещённые вершины будет записывать значение на 1 больше, чем в вершине из которой мы пришли.

#align(center, diagram(
  node-stroke: .1em,
  spacing: 2em,
  {
    let nodes = (
      ((0, 0), "A"),
      ((1, 0), "B"),
      ((0, 1), "C"),
      ((1, 1), "D"),
      ((2, 0.5), "E")
    )
    let edges = (
      ("A", "B", 5),
      ("A", "C", 1),
      ("B", "E", 7),
      ("C", "D", 7),
      ("D", "A", 0),
      ("D", "B", 6),
      ("E", "D", 3)
    )

    draw_base_graph()

    let distances = (
      (0, -.5),
      (1, -.5),
      (1, .5),
      (1, .5),
      (2, -.5),
    )

    for (i, (val, dy)) in distances.enumerate() {
      let (x,y) = nodes.at(i).at(0)
      node((x,y + dy), text(fill: blue)[#val], stroke: 0em)
    }
  }
))

Расстояния от вершины A --- B:1, C:1, D:1, E:2.

==
#v(-1em)
```cpp
vector<int> dist(n, -1);
dist[start] = 0;
queue<int> q;
q.push(start);

while (!q.empty()) {
    int v = q.front();
    q.pop();
    for (int u : adj[v]) {
        if (dist[u] == -1) {
            dist[u] = dist[v] + 1;
            q.push(u);
        }
    }
}
```

#remark[Работает за $O(V+E)$.]

=== Практические задачи

- *Лестница слов*: #link("https://leetcode.com/problems/word-ladder/")[LeetCode 127]

- *Минимальная генетическая мутация*: #link("https://leetcode.com/problems/minimum-genetic-mutation/")[LeetCode 433]

- *Расстояние в графе*: #link("https://acmp.ru/?main=task&id_task=48")[acmp.ru 48]

- *Открыть замок*: #link("https://leetcode.com/problems/open-the-lock/")[LeetCode 752]

- *Обход графа*: #link("https://acmp.ru/?main=task&id_task=711")[acmp.ru 711]
