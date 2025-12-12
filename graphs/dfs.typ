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

#show link: set text(fill: blue)
#show link: underline

#let draw_step(greens: (), blues: (), highlighted: none, step_text: "", errors: ()) = {
    diagram(
      node-stroke: .1em,
      spacing: 2.5em,
      {
        let nodes = (
          ((-0.7, -0.3), "A"),
          ((0, 0.5), "B"),
          ((0.7, -0.3), "C"),
          ((0, -0.7), "D"),
        )

        for (pos, name) in nodes {
          let stroke-data = if name == highlighted {
            red
          } else {
            black
          }
          let display-color = if name in blues {
            blue.transparentize(50%)
          } else if name in greens {
            green.transparentize(50%)
          } else {
            white
          }

          if name in errors {
            display-color = display-color.mix(red)
          }
          node(pos, text(fill: stroke-data)[#name], name: name, fill: display-color, stroke: stroke-data)
        }

        let edges = (
          ("A", "B"),
          ("B", "C"),
          ("C", "A"),
          ("B", "D"),
        )

        for (from, to) in edges {
          edge(label(str(from)), label(str(to)))
        }
      }
    )
  }

= ~~Поиск в глубину~~

== Определение

#definition[
*Поиск в глубину* (Depth-First Search, DFS) — метод обхода графа, при котором мы идем так глубоко, как возможно по ветке графа, прежде чем вернуться назад.
]

Алгоритм DFS начинает обход с некоторой выбранной вершины. Он посещает вершину, затем рекурсивно обходит всех её непосещённых соседей. Когда все соседи текущей вершины посещены, происходит возврат (backtracking) к предыдущей вершине.

Визуально DFS можно представить как погружение в глубину графа, аналогично лабиринту, где мы идем вглубь до тех пор, пока не достигнем тупика, а затем возвращаемся и ищем другие пути.

==
#v(-1em)

#align(center)[
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

  #let draw_graph(path: (), visited: ()) = {
    for (pos, name) in nodes {
      let fill-color = if name in path {
        if name == path.last() {
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

    for i in range(0, path.len()-1){
      edge(label(str(path.at(i))), label(str(path.at(i+1))), "-|>", stroke: (paint: red, thickness: 0.8pt))
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
        draw_graph(path: (1, 2, 5))
      }
    ), 
    arrow(),
    diagram(
      node-stroke: .1em,
      spacing: 0.7em,
      {
        draw_graph(path: (1,2, 6), visited: (5,))
      }
    ),
    arrow(),
    arrow(),
    diagram(
      node-stroke: .1em,
      spacing: 0.7em,
      {
        draw_graph(path: (1,3,7), visited: (2,5,6))
      }
    ),
    $...$,
    diagram(
      node-stroke: .1em,
      spacing: 0.7em,
      {
        draw_graph(path: (1,4,10), visited: (2,5,6,3,7,8,9))
      }
    ),
  )
]

Порядок выхода из функции: ${5,6,2,7,8,3,9,10,4,1}$

#definition[

  Такой порядок обхода называется *прямым (префиксным) обходом дерева*
]


== Рекурсивная реализация

Рекурсивная реализация DFS использует стек вызовов функций для хранения текущего пути.

```cpp
vector<vector<int>> adj; // список смежности
vector<char> visited;

void dfs(int v) {
    visited[v] = true;
    for (int u : adj[v]) {
        if (!visited[u]) {
            dfs(u);
        }
    }
}
```

== Итеративная реализация

#text(size: 0.9em)[
```cpp
void dfs(int start){
    vector<char> visited(n, false);
    stack<int> s;
    s.push(start);
    visited[start] = true;

    while (!s.empty()){
        int v = s.top();
        s.pop();
        for (int u : adj[v])
            if (!visited[u]) {
                visited[u] = true;
                s.push(u);
            }
        }
    }
}
```
]

==
#v(-1em)
#warning[

  Если вы всё же используете python для спортивного программирования, то вы не можете позволить себе использовать рекурсивый dfs. Не будет хватать глубины рекурсии и затраты на вызов функции в питоне выше.
]

```python
def dfs(start, adj, n):
    visited = [False] * n
    stack = [start]
    visited[start] = True

    while stack:
        v = stack.pop()

        for u in adj[v]:
            if not visited[u]:
                visited[u] = True
                stack.append(u)
```

== Сложность

- *Временная сложность*: $O(V + E)$, где $V$ — количество вершин, $E$ — количество рёбер. Каждая вершина и каждое ребро посещается постоянное число раз.

- *Пространственная сложность*: $O(V)$ для хранения массива visited и стека/очереди рекурсии. В худшем случае (линейный граф) может потребоваться $O(V)$ стека.

DFS работает оптимально по времени для большинства задач на графах.

=== Практические задачи

- *Parity*: #link("https://acm.timus.ru/problem.aspx?space=1&num=1003")[Timus 1003]

- *Путешествие*: #link("https://codeforces.com/problemset/problem/1020/B")[Codeforces 1020B]

- *И коровы приходят домой*: #link("https://codeforces.com/problemset/problem/176/F")[Codeforces 176F]

== Компоненты связности

Дан неориентированный граф. Требуется найти все компоненты связности, А так же определить к какой из компонент относится каждая вершина.


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
Для поиска компонент связности используем DFS: запускаем обход от каждой непосещённой вершины, каждый такой обход посещает одну компоненту связности.

#hint[

  Нам требуется пометить к какой из компонент относится вершина. Как можно уникально обозначить компоненту? Можно просто в качестве "названия" компоненты использовать номер любой из вершин лежашей в ней.
]

```cpp
void dfs(int v, int u) {
    visited[v] = u;
    for (int i : adj[v]) {
        if (!visited[i]) {
            dfs(i, u);
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
  //Считывание
 
  int n = adj.size();
  visited.assign(n, 0);
  for (int i = 0; i < n; ++i) {
    if (!visited[i]) {
      dfs(i, i);
    }
  }

  //Вывод
}
```

#v(-1.5em)
#remark[Работает за $O(V+E)$.]

=== Практические задачи

- *Max Area of Island*: #link("https://leetcode.com/problems/max-area-of-island/")[LeetCode 695]

- *Компоненты графа*: #link("https://acmp.ru/index.asp?main=task&id_task=843")[acmp.ru 843]

- *Поиск компонент связности*: #link("https://codeforces.com/problemset/problem/920/D")[Codeforces 920D]

- *Присвоение компонент*: #link("https://codeforces.com/problemset/problem/145/E")[Codeforces 145E]

- *Остров*: #link("https://acmp.ru/index.asp?main=task&id_task=47")[acmp.ru 47]

== Топологическая сортировка

#definition[

*Топологическая сортировка* --- упорядочение вершин ориентированного графа без циклов, при котором для каждого ребра $(u,v)$ вершина $u$ идёт перед $v$.
]

Дан ориентированный ацикличный граф (*DAG - Directed Acyclic Graph*). Требуется вывести топологическую сортировку вершин. Например, модель одевания одежды: 

#align(center, diagram(
  node-stroke: .1em,
  spacing: 1em,
  {
    let nodes = (
      ((0, 0), "Носки"),
      ((1, 0), "Трусы"),
      ((2, 0), "Майка"),
      ((0, 1), "Брюки"),
      ((2, 1), "Рубашка"),
      ((0, 2), "Ремень"),
      ((-1, 2), "Ботинки"),
      ((1, 2), "Пиджак")
    )

    let edges = (
      ("Носки", "Ботинки"),
      ("Трусы", "Майка"),
      ("Трусы", "Брюки"),
      ("Майка", "Рубашка"),
      ("Майка", "Пиджак"),
      ("Рубашка", "Пиджак"),
      ("Брюки", "Ремень"),
      ("Ремень", "Пиджак"),
      ("Брюки", "Ботинки"),
    )

    for (pos, name) in nodes {
      node(pos, name, radius: auto, corner-radius: 1em, name: name)
    }

    for (from, to) in edges {

      edge(label(from), label(to), "-|>")
    }
  }
))

#v(-0.5em)
Возможный порядок: Носки, Трусы, Брюки, Майка, Ремень, Рубашка, Ботинки, Пиджак.

=== Решение

Для решения используем DFS: обходим граф, и добавляем вершину в список после посещения всех её соседей. Переворачиваем список для получения топологического порядка.

#align(center)[
  #let nodes = (
    ((0, 0), "A"),
    ((1, 0), "B"),
    ((2, 0), "C"),
    ((0, 1), "D"),
    ((1, 1), "E"),
    ((2, 1), "F"),
    ((1, 1.8), "G"),
  )

  #let edges = (
    ("A", "B"),
    ("B", "C"),
    ("D", "E"),
    ("D", "G"),
    ("E", "F"),
    ("G", "F"),
    ("C", "F"),
    ("B", "E"),
  )

  #let draw_topsort_graph(path: (), finished: ()) = {
    for (pos, name) in nodes {
      let fill_col = if name in finished {
        green.transparentize(50%) 
      } else if name in path{ 
        if name == path.last() {
          gray.transparentize(50%)
        }
        else {
          yellow.transparentize(50%)
        }
      }
      node(pos, name, name: name, fill: fill_col)
    }

    for (from, to) in edges {
      edge(label(from), label(to), "-|>")
    }

    for i in range(0, path.len()-1){
      edge(label(path.at(i)), label(path.at(i+1)), "-|>", stroke: (paint: red, thickness: 0.8pt))
    }
  }


  #grid(
    align: horizon,
    columns: 5,
    box()[
      #diagram(
        node-stroke: .1em,
        spacing: 1em,
        {
          draw_topsort_graph(path: ("G"))

        }
      )

      ${}$
    ], 
    arrow(),
    box()[
      #diagram(
        node-stroke: .1em,
        spacing: 1em,
        {
          draw_topsort_graph(path: ("G", "F"))
        }
      )

      ${}$
    ], 
    arrow(),
    box()[
      #diagram(
        node-stroke: .1em,
        spacing: 1em,
        {
          draw_topsort_graph(finished: ("G", "F"))
        }
      )

      ${F, G}$
    ], 
  )
]

==
#v(-1em)
#align(center)[
  #let nodes = (
    ((0, 0), "A"),
    ((1, 0), "B"),
    ((2, 0), "C"),
    ((0, 1), "D"),
    ((1, 1), "E"),
    ((2, 1), "F"),
    ((1, 1.8), "G"),
  )

  #let edges = (
    ("A", "B"),
    ("B", "C"),
    ("D", "E"),
    ("D", "G"),
    ("E", "F"),
    ("G", "F"),
    ("C", "F"),
    ("B", "E"),
  )

  #let draw_topsort_graph(path: (), finished: ()) = {
    for (pos, name) in nodes {
      let fill_col = if name in finished {
        green.transparentize(50%) 
      } else if name in path{ 
        if name == path.last() {
          gray.transparentize(50%)
        }
        else {
          yellow.transparentize(50%)
        }
      }
      node(pos, name, name: name, fill: fill_col)
    }

    for (from, to) in edges {
      edge(label(from), label(to), "-|>")
    }

    for i in range(0, path.len()-1){
      edge(label(path.at(i)), label(path.at(i+1)), "-|>", stroke: (paint: red, thickness: 0.8pt))
    }
  }

  #grid(
    align: horizon,
    columns: 7,
    row-gutter: 1em,
    "",
    box()[
      #diagram(
        node-stroke: .1em,
        spacing: 1em,
        {
          draw_topsort_graph(path: ("A"), finished: ("G", "F"))
        }
      )

      ${F, G}$
    ], 
    arrow(),
    box()[
      #diagram(
        node-stroke: .1em,
        spacing: 1em,
        {
          draw_topsort_graph(path: ("A", "B", "C"), finished: ("G", "F"))
        }
      )

      ${F, G}$
    ], 
    arrow(),
    box()[
      #diagram(
        node-stroke: .1em,
        spacing: 1em,
        {
          draw_topsort_graph(path: ("A", "B", "E"), finished: ("G", "F", "C"))
        }
      )

      ${F, G, C}$
    ], 
    arrow(),
    arrow(),
    box()[
      #diagram(
        node-stroke: .1em,
        spacing: 1em,
        {
          draw_topsort_graph(path: ("A", "B", "E"), finished: ("G", "F", "C"))
        }
      )

      ${F, G, C}$
    ], 
    arrow(),
    box()[
      #diagram(
        node-stroke: .1em,
        spacing: 1em,
        {
          draw_topsort_graph(path: ("D"), finished: ("G", "F", "C", "A", "B", "E"))
        }
      )

      ${F, G, C, E, B, A}$
    ], 
    arrow(),
    box()[
      #diagram(
        node-stroke: .1em,
        spacing: 1em,
        {
          draw_topsort_graph(finished: ("G", "F", "C", "A", "B", "E", "D"))
        }
      )

      ${F, G, C, E, B, A, D}$
    ], 
  )
]

==
#v(-1em)
```cpp
vector<vector<int>> adj;
vector<char> visited;
vector<int> order;

void dfs(int v) {
    visited[v] = true;
    for (int u : adj[v]) {
        if (!visited[u]) {
            dfs(u);
        }
    }
    order.push_back(v);
}
```
#remark[Работает за $O(V+E)$.]

=== Практические задачи

- *Course Schedule*: #link("https://leetcode.com/problems/course-schedule/")[LeetCode 207]

- *Course Schedule II*: #link("https://leetcode.com/problems/course-schedule-ii/")[LeetCode 210]

- *Parallel Courses*: #link("https://leetcode.com/problems/parallel-courses/")[LeetCode 1136]

- *Topological Sort*: #link("https://www.spoj.com/problems/TOPOSORT/")[SPOJ "TOPOSORT"]
  
== Поиск циклов

Дан ориентированный граф. Требуется определить, содержит ли он цикл.

#definition[
*Цикл* в графе — это путь, в котором первая и последняя вершина совпадают, и все рёбра уникальны.
]

В ориентированном графе наличие циклов означает, что некоторые алгоритмы не применимы.

Задача важна для проверки ацикличности (DAG — Directed Acyclic Graph), что является основой для многих задач, таких как планирование, зависимости в программном обеспечении и т.п.

==

Для поиска циклов в ориентированном графе с помощью DFS мы используем три состояния вершин:
- *Белый* (не посещена)
- *Серый* (обрабатывается — находится в текущем пути обхода)
- *Чёрный* (посещена и обработана)

При обходе соседей из текущей вершины:
- Если сосед белый, запускаем DFS на нём
- Если сосед серый, обнаружен цикл
- Если сосед чёрный, продолжаем

#warning[
  Для неориентированных графов родитель должен быть исключён из проверки.
]

==

#v(-1.5em)
#align(center+horizon)[
  #let nodes = (
    ((0,0), 1),
    ((1, 0), 2),
    ((2, 0), 3),
    ((0, 1), 4),
    ((1, 1), 5),
    ((2, 1), 6)
  )
  #let edges = (
    (1, 2),
    (1, 4),
    (2, 3),
    (3, 6),
    (6, 5),
    (5, 2),
  )

  #let draw_base_graph(path, visited) = {
    for (pos, name) in nodes {
      name = str(name)
      node(pos, name, name: name)
    }

    for (from, to) in edges {
      edge(label(str(from)), label(str(to)), "-|>")
    }

    for (pos, name) in visited {
      node(pos, text(fill:white)[#str(name)], fill: black)
    }

    for (pos, name) in path {
      node(pos, str(name), fill: gray.transparentize(50%))
    }
  }

  #grid(
    align: horizon,
    columns: 5,
    row-gutter: 1em,
    "",
    diagram(
      node-stroke: .1em,
      spacing: 2em,
      {
        let (pos, name) = nodes.at(0)
        node(pos, str(name), fill: yellow.transparentize(50%))
        let path = ()
        let visited = ()

        draw_base_graph(path, visited)

        //edge(label("1"), label("2"), "-|>", stroke: (paint: red, thickness: 0.8pt))
        //edge(label("2"), label("5"), "-|>", stroke: (paint: red, thickness: 0.8pt))
      }
    ), 
    arrow(),
    diagram(
      node-stroke: .1em,
      spacing: 2em,
      {
        let (pos, name) = nodes.at(3)
        node(pos, str(name), fill: yellow.transparentize(50%))
        let path = ()
        let visited = ()

        path.push(nodes.at(0))

        draw_base_graph(path, visited)

        edge(label("1"), label("4"), "-|>", stroke: (paint: red, thickness: 0.8pt))
        //edge(label("2"), label("5"), "-|>", stroke: (paint: red, thickness: 0.8pt))
      }
    ), 
    arrow(),
    arrow(),
    diagram(
      node-stroke: .1em,
      spacing: 2em,
      {
        let (pos, name) = nodes.at(4)
        node(pos, str(name), fill: yellow.transparentize(50%))
        let path = ()
        let visited = ()

        visited.push(nodes.at(3))

        path.push(nodes.at(0))
        path.push(nodes.at(1))
        path.push(nodes.at(2))
        path.push(nodes.at(5))

        draw_base_graph(path, visited)

        edge(label("1"), label("2"), "-|>", stroke: (paint: red, thickness: 0.8pt))
        edge(label("2"), label("3"), "-|>", stroke: (paint: red, thickness: 0.8pt))
        edge(label("3"), label("6"), "-|>", stroke: (paint: red, thickness: 0.8pt))
        edge(label("6"), label("5"), "-|>", stroke: (paint: red, thickness: 0.8pt))
      }
    ), 
    arrow(),
    diagram(
      node-stroke: .1em,
      spacing: 2em,
      {
        let (pos, name) = nodes.at(4)
        node(pos, str(name), fill: yellow.transparentize(50%))
        let path = ()
        let visited = ()

        visited.push(nodes.at(3))

        path.push(nodes.at(0))
        path.push(nodes.at(1))
        path.push(nodes.at(2))
        path.push(nodes.at(5))

        draw_base_graph(path, visited)

        let (pos, name) = nodes.at(1)
        node(pos, str(name), fill: red.transparentize(50%))

        edge(label("1"), label("2"), "-|>", stroke: (paint: red, thickness: 0.8pt))
        edge(label("2"), label("3"), "-|>", stroke: (paint: red, thickness: 0.8pt))
        edge(label("3"), label("6"), "-|>", stroke: (paint: red, thickness: 0.8pt))
        edge(label("6"), label("5"), "-|>", stroke: (paint: red, thickness: 0.8pt))
        edge(label("5"), label("2"), "-|>", stroke: (paint: red, thickness: 0.8pt))
      }
    ), 
  )
]

==
#v(-1em)
```cpp
vector<vector<int>> adj;
vector<int> color; // 0 - white, 1 - grey, 2 - black

bool has_cycle(int v) {
    color[v] = 1; // grey
    for (int u : adj[v]) {
        if (color[u] == 0) {
            if (has_cycle(u)) return true;
        } else if (color[u] == 1) {
            return true; // back edge to grey
        }
    }
    color[v] = 2; // black
    return false;
}
```
#remark[Работает за $O(V+E)$]

=== Практические задачи

- *Find Eventual Safe States*: #link("https://leetcode.com/problems/find-eventual-safe-states/")[LeetCode 802]

- *Redundant Connection*: #link("https://leetcode.com/problems/redundant-connection/")[LeetCode 684]

- *Redundant Connection II*: #link("https://leetcode.com/problems/redundant-connection-ii/")[LeetCode 685]

- *Account Merge*: #link("https://leetcode.com/problems/accounts-merge/")[LeetCode 721]

== Проверка двудольности графа

Дан неориентированный граф. Требуется определить, является ли он двудольным.

#align(center, diagram(
  node-stroke: .1em,
  spacing: 2em,
  {
    let nodes = (
      ((0, 0), "A", blue.transparentize(50%)),
      ((1, 0), "B", blue.transparentize(50%)),
      ((2, 0), "C", blue.transparentize(50%)),
      ((0.5, 1.5), "D", green.transparentize(50%)),
      ((1.5, 1.5), "E", green.transparentize(50%)),
    )
    let edges = (
      ("A", "D", 0),
      ("A", "E", 0),
      ("B", "D", 0),
      ("B", "E", 0),
      ("C", "D", 0),
      ("C", "E", 0),
    )

    for ((x, y), name, fill) in nodes {
      node((x, y), name, name: name, fill: fill)
    }

    for (from, to, _) in edges {
      edge(label(str(from)), label(str(to)))
    }
  }
))

Граф выше является двудольным, вершины разделены на два множества: ${A, B, C}$ и ${D, E}$.

Эта проверка полезна во многих задачах соревновательного программирования, таких как задачи о назначении, моделирование противоречий или определение возможности разделения ресурсов на две группы без конфликтов.

=== Решения

1. Выбираем неокрашенную вершину, красим её в цвет 1
2. В процессе обхода красим соседей в противоположный цвет
3. Если обнаруживаем вершину, окрашенную в "неправильный" цвет — граф не является двудольным
4. Повторяем для всех компонент связности

#align(center, grid(
  columns: 5,
  align: center+horizon,
  gutter: 1em,
  draw_step(greens: ("A",)),
  arrow(),
  draw_step(highlighted: "A", greens: ("A",), blues: ("B", "C")),
  arrow(),
  draw_step(highlighted: "B", greens: ("A", "D"), blues: ("B", "C"), errors: ("C",)),
))

==
#v(-1em)
```cpp
vector<vector<int>> adj;
vector<int> color; // 0 - not colored, 1 - color1, 2 - color2

bool is_bipartite(int v, int c) {
    color[v] = c;
    for (int u : adj[v]) {
        if (color[u] == 0) {
            if (!is_bipartite(u, 3 - c)) return false;
        } else if (color[u] == c) {
            return false; // same color
        }
    }
    return true;
}
```

#remark[Работает за $O(V+E)$.]

=== Практические задачи

- *Bipartite Graph Check*: #link("https://acmp.ru/index.asp?main=task&id_task=987")[acmp.ru 987]

- *Двудольный граф*: #link("https://acmp.ru/index.asp?main=task&id_task=455")[acmp.ru 455]

- *Graph Coloring*: #link("https://www.spoj.com/problems/COLOR/")[SPOJ "COLOR"]

- *Even Edge*: #link("https://acm.timus.ru/problem.aspx?space=1&num=1837")[Timus 1837]
