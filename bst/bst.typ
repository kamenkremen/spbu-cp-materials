#import "@preview/tdtr:0.5.4": *

= Двоичное дерево поиска
== Интуиция
Представим обычный остортированный массив и задачу о поиске элемента в этом массиве.
Эффективное решение довольно очевидно: использовать двоичный поиск. Но что если нам нужно иметь возсожность добавлять/удалять элементы из этого массива? Эффективный поиск за $O(log n)$ будет негативно сбалансирован добавлением/удалением за $O(n)$.

Попробуем изменить наш подход. Рассмотрим как выглядит операции поиска в этом массиве.

#align(center, table(
  columns: 7,
  $4$, $5$, $8$, $11$, $12$, $17$, $18$,
))

==

#align(center, table(
  columns: 7,
  $4$, $5$, $8$, $11$, $12$, $17$, $18$,
))

Ниже расположены все возможные пути двоичного поиска на массиве.

#tidy-tree-graph(
  draw-node: tidy-tree-draws.horizontal-draw-node,
  text-size: 1em,
  node-inset: 8pt,
  spacing: (4em, 2em),
  node-width: 1.2em,
  node-height: 1.2em,
)[
  - $11$
    + $<11$
    - $5$
      + $<5$
      - $4$
      + $>5$
      - $8$
    + $>11$
    - $17$
      + $<17$
      - $12$
      + $>17$
      - $18$
]

А что если мы запишем массив как это дерево? Рассмотрим его свойства.

==

#grid(
  columns: 2,
  column-gutter: 2em,
  box[
    Рассмотрим какие свойства имеет это дерево по построению:
    1. Левый потомок и все его потомки будут иметь значение меньше чем текущая вершина.
    2. Правый потомок и все его потомки будут иметь значение больше чем текущая вершина.
    3. Глубина дерева не будет превышать $log n$, где $n$ --- количество вершин

    Значит, опираясь на эти свойства, мы можем однозначно найти место для вставки и вставить новый элемент за $O(log n)$, а так же проверить наличие и удалить элемент за те же $O(log n)$
  ],
  align(horizon, box(height: 80%, tidy-tree-graph(
    text-size: 1em,
    node-inset: 8pt,
    spacing: (1em, 1em),
    node-width: 1.2em,
    node-height: 1.2em,
  )[
    - $11$
      - $5$
        - $4$
        - $8$
      - $17$
        - $12$
        - $18$
  ])),
)

== Структура данных

```cpp
struct Node {
    int value;
    Node* left;
    Node* right;

    Node(int v) : value(v), left(nullptr), right(nullptr) {}
};
```

==

== Вставка

```cpp
Node* insert(Node* node, int value) {
    if (node == nullptr) {
        return new Node(value);
    }
    if (value < node->value) {
        node->left = insert(node->left, value);
    } else {
        node->right = insert(node->right, value);
    }
    return node;
}
```

==

== Поиск

```cpp
Node* search(Node* node, int value) {
    if (node == nullptr || node->value == value) {
        return node;
    }
    if (value < node->value) {
        return search(node->left, value);
    }
    return search(node->right, value);
}
```

==

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

Попробуем добавить элементы 7, 14 и 6\
На диаграммах ниже зеленая вершина обозначает что наше значение больше текущей вершины, значит спуск совершается вправо. Синий значит действие противоположное. Желтым помечена текущая вершина.

#align(center)[
  #grid(
    columns: 3,
    column-gutter: 3em,
    align: center,
    [
      7 \
      #tree[
        - $11$ <blue>
          - $5$ <green>
            - $4$
            - $8$ <blue>
              - $7$ <yellow>
              + 1 <nil>
              - 1 <nil>
          - $17$
            - $12$
            - $18$
      ]
    ],
    [
      14 \
      #tree[
        - $11$ <green>
          - $5$
            - $4$
            - $8$
              - $7$
              + 1 <nil>
              - 1 <nil>
          - $17$ <blue>
            - $12$ <green>
              + 1 <nil>
              - 1 <nil>
              - 14 <yellow>
            - $18$
      ]
    ],
    [
      14 \
      #tree[
        - $11$ <blue>
          - $5$ <green>
            - $4$
            - $8$ <blue>
              - $7$ <blue>
                - $6$ <yellow>
                + 1 <nil>
                - 1 <nil>
              + 1 <nil>
              - 1 <nil>
          - $17$
            - $12$
              + 1 <nil>
              - 1 <nil>
              - 14
            - $18$
      ]
    ],
  )
]

==

#grid(
  columns: (80%, 100%),
  box[
    Снова рассмотрим свойства:\
    Свойства 1,2 мы сохранили успешно.\
    Однако, со свойством 3 есть существенная проблема. Путь $11->5->7->7->6$ имеет длину $5$, однако количество вершин $10$, $log_2 10 approx 4$. В худшем случае дерево станет лозой, и тогда все операции будут $O(n)$. Решение этой проблемы называется балансировкой.

    #align(center)[
      Пример лозы(также называют бамбуком):

      #tree(
        spacing: (0.5em, 0.5em),
        node-width: 1.2em,
        node-height: 1.2em,
      )[
        - $11$
          - $8$
            - $7$
              - $6$
                - $5$
                + 1 <nil>
                - 1 <nil>
              + 1 <nil>
              - 1 <nil>
            + 1 <nil>
            - 1 <nil>
          + 1 <nil>
          - 1 <nil>
      ]
    ]
  ],
  tree(
    spacing: (0.5em, 0.5em),
    node-width: 1.2em,
    node-height: 1.2em,
  )[
    - $11$
      - $5$
        - $4$
        - $8$
          - $7$
            - $6$
            + 1 <nil>
            - 1 <nil>
          + 1 <nil>
          - 1 <nil>
      - $17$
        - $12$
          + 1 <nil>
          - 1 <nil>
          - 14
        - $18$
  ],
)

=== Структура данных

```cpp
struct Node {
    int value;
    Node* left;
    Node* right;

    Node(int v) : value(v), left(nullptr), right(nullptr) {}
};
```

=== Вставка

```cpp
Node* insert(Node* node, int value) {
    if (node == nullptr) {
        return new Node(value);
    }
    if (value < node->value) {
        node->left = insert(node->left, value);
    } else {
        node->right = insert(node->right, value);
    }
    return node;
}
```

=== Поиск

```cpp
Node* search(Node* node, int value) {
    if (node == nullptr || node->value == value) {
        return node;
    }
    if (value < node->value) {
        return search(node->left, value);
    }
    return search(node->right, value);
}
```

=== Удаление

```cpp
Node* remove(Node* node, int value) {
    if (node == nullptr) return nullptr;
    
    if (value < node->value) {
        node->left = remove(node->left, value);
    } else if (value > node->value) {
        node->right = remove(node->right, value);
    } else {
        // Нашли узел для удаления
        // ...
    }
    return node;
}
```

===

```cpp
// Случай: нет левого ребёнка
if (node->left == nullptr) {
    Node* temp = node->right;
    delete node;
    return temp;
}
// Случай: нет правого ребёнка
if (node->right == nullptr) {
    Node* temp = node->left;
    delete node;
    return temp;
}
```

===

```cpp
// Случай: два ребёнка
// Ищем минимальный элемент в правом поддереве
Node* minLarger = node->right;
while (minLarger->left != nullptr) {
    minLarger = minLarger->left;
}
node->value = minLarger->value;
node->right = remove(node->right, minLarger->value);
```
