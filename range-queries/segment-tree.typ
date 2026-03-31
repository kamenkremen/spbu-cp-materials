#import "@preview/pepentation:0.2.0": *
#import "@preview/cetz:0.4.2": canvas, draw

#let draw-segment-tree() = {
  canvas(length: 0.7cm, {
    import draw: *

    let box-w = 1.3
    let box-h = 0.75
    let level-h = 1.7

    let internal-nodes = (
      ((0, 0), 64),
      ((-4, -level-h), 16),
      ((4, -level-h), 48),
      ((-6, -2*level-h), 4),
      ((-2, -2*level-h), 12),
      ((2, -2*level-h), 20),
      ((6, -2*level-h), 28),
    )

    let leaf-nodes = (
      (-7, -3*level-h, 1),
      (-5, -3*level-h, 3),
      (-3, -3*level-h, 5),
      (-1, -3*level-h, 7),
      (1, -3*level-h, 9),
      (3, -3*level-h, 11),
      (5, -3*level-h, 13),
      (7, -3*level-h, 15),
    )

    let edges = (
      ((0, 0), (-4, -level-h)),
      ((0, 0), (4, -level-h)),
      ((-4, -level-h), (-6, -2*level-h)),
      ((-4, -level-h), (-2, -2*level-h)),
      ((4, -level-h), (2, -2*level-h)),
      ((4, -level-h), (6, -2*level-h)),
      ((-6, -2*level-h), (-7, -3*level-h)),
      ((-6, -2*level-h), (-5, -3*level-h)),
      ((-2, -2*level-h), (-3, -3*level-h)),
      ((-2, -2*level-h), (-1, -3*level-h)),
      ((2, -2*level-h), (1, -3*level-h)),
      ((2, -2*level-h), (3, -3*level-h)),
      ((6, -2*level-h), (5, -3*level-h)),
      ((6, -2*level-h), (7, -3*level-h)),
    )

    for ((x1, y1), (x2, y2)) in edges {
      line((x1, y1 - box-h/2), (x2, y2 + box-h/2), stroke: (thickness: 1.5pt, paint: gray))
    }

    for ((x, y), val) in internal-nodes {
      rect(
        (x - box-w/2, y - box-h/2),
        (x + box-w/2, y + box-h/2),
        fill: blue.lighten(80%),
        stroke: (thickness: 2pt, paint: blue),
      )
      content((x, y), text(size: 1em, weight: "bold")[#val])
    }

    for (x, y, val) in leaf-nodes {
      rect(
        (x - box-w/2, y - box-h/2),
        (x + box-w/2, y + box-h/2),
        fill: green.lighten(80%),
        stroke: (thickness: 1.5pt, paint: green),
      )
      content((x, y), text(size: 1em, fill: green.darken(40%))[#val])
    }
  })
}

#let draw-query-example() = {
  canvas(length: 0.7cm, {
    import draw: *

    let box-w = 1.3
    let box-h = 0.75
    let level-h = 1.7

    let internal-nodes = (
      ((0, 0), 64, "used"),
      ((-4, -level-h), 16, "used"),
      ((4, -level-h), 48, "used"),
      ((-6, -2*level-h), 4, "skip"),
      ((-2, -2*level-h), 12, "used"),
      ((2, -2*level-h), 20, "used"),
      ((6, -2*level-h), 28, "skip"),
    )

    let leaf-nodes = (
      (-7, -3*level-h, 1, "skip"),
      (-5, -3*level-h, 3, "used"),
      (-3, -3*level-h, 5, "used"),
      (-1, -3*level-h, 7, "used"),
      (1, -3*level-h, 9, "used"),
      (3, -3*level-h, 11, "used"),
      (5, -3*level-h, 13, "skip"),
      (7, -3*level-h, 15, "skip"),
    )

    let edges = (
      ((0, 0), (-4, -level-h), "used"),
      ((0, 0), (4, -level-h), "used"),
      ((-4, -level-h), (-6, -2*level-h), "skip"),
      ((-4, -level-h), (-2, -2*level-h), "used"),
      ((4, -level-h), (2, -2*level-h), "used"),
      ((4, -level-h), (6, -2*level-h), "skip"),
      ((-6, -2*level-h), (-7, -3*level-h), "skip"),
      ((-6, -2*level-h), (-5, -3*level-h), "skip"),
      ((-2, -2*level-h), (-3, -3*level-h), "used"),
      ((-2, -2*level-h), (-1, -3*level-h), "used"),
      ((2, -2*level-h), (1, -3*level-h), "used"),
      ((2, -2*level-h), (3, -3*level-h), "used"),
      ((6, -2*level-h), (5, -3*level-h), "skip"),
      ((6, -2*level-h), (7, -3*level-h), "skip"),
    )

    for ((x1, y1), (x2, y2), state) in edges {
      let stroke-color = if state == "used" { blue } else { gray }
      let stroke-w = if state == "used" { 2.5pt } else { 1pt }
      line((x1, y1 - box-h/2), (x2, y2 + box-h/2), stroke: (thickness: stroke-w, paint: stroke-color))
    }

    for ((x, y), val, state) in internal-nodes {
      let fill-color = if state == "used" { blue.lighten(50%) } else { blue.lighten(80%) }
      let stroke-color = if state == "used" { blue.darken(20%) } else { blue }
      rect(
        (x - box-w/2, y - box-h/2),
        (x + box-w/2, y + box-h/2),
        fill: fill-color,
        stroke: (thickness: 2pt, paint: stroke-color),
      )
      content((x, y), text(size: 1em, weight: "bold")[#val])
    }

    for (x, y, val, state) in leaf-nodes {
      let fill-color = if state == "used" { green.lighten(50%) } else { green.lighten(80%) }
      let stroke-color = if state == "used" { green.darken(20%) } else { green }
      rect(
        (x - box-w/2, y - box-h/2),
        (x + box-w/2, y + box-h/2),
        fill: fill-color,
        stroke: (thickness: 1.5pt, paint: stroke-color),
      )
      content((x, y), text(size: 1em, fill: if state == "used" { green.darken(40%) } else { green.darken(20%) })[#val])
    }
  })
}

= Дерево отрезков

== Мотивация

Задача: есть массив $a$ длины $n$. Нужно:
- менять значение $a[i]$
- быстро вычислять функцию $F$ на отрезке $[l, r]$ (например, сумму, минимум, максимум)

#text(size: 0.9em)[
Наивное решение: обновление $O(1)$, запрос $O(n)$

Префиксные суммы: обновление $O(n)$, запрос $O(1)$ на префиксах

Разреженные таблицы: обновление $O(n)$, запрос $O(log n)$

*Нужна структура данных с $O(log n)$ на обе операции.*
]

== Структура дерева отрезков
#v(0.3em)
Дерево отрезков --- двоичное дерево, узлы которого хранят результаты применения операции к своим поддеревьям.

*Пример для массива $a = [1, 3, 5, 7, 9, 11, 13, 15]$:*
#v(0.3em)
#draw-segment-tree()

== Пример: запрос sum(2, 6)
#v(0.3em)
Запросим сумму элементов $a_2 + a_3 + a_4 + a_5 + a_6 = 3 + 5 + 7 + 9 + 11 = 35$
#v(0.3em)
#draw-query-example()

#v(0.3em)

== Реализация
Хранить дерево отрезков проще всего в массиве $t$ размера $4*n$. Корень дерева = $t[1]$. Левый ребенок вершины $v - t[2 * v]$, правый $- t[2 * v + 1]$.

== Построение

```cpp
void build(int v, int l, int r) {
    if (l == r) {
        tree[v] = a[l];
        return;
    }
    int mid = (l + r) / 2;
    build(v*2, l, mid);
    build(v*2+1, mid+1, r);
    tree[v] = merge(tree[v*2], tree[v*2+1]);
}
```

== Запрос на отрезке

```cpp
int query(int v, int l, int r, int ql, int qr) {
    if (ql > r || qr < l) return neutral;  // не пересекаются
    if (ql <= l && r <= qr) return tree[v]; // полностью внутри
    int mid = (l + r) / 2;
    return merge(query(v*2, l, mid, ql, qr),
                 query(v*2+1, mid+1, r, ql, qr));
}
```

*Рекурсия спускается только по нужным путям --- $O(log n)$*

== Обновление элемента

```cpp
void update(int v, int l, int r, int pos, int val) {
    if (l == r) {
        tree[v] = val;
        return;
    }
    int mid = (l + r) / 2;
    if (pos <= mid)
        update(v*2, l, mid, pos, val);
    else
        update(v*2+1, mid+1, r, pos, val);
    tree[v] = merge(tree[v*2], tree[v*2+1]);
}
```

*Время: $O(log n)$*

== Итеративная реализация

Дерево отрезков можно реализовать и без рекурсии, что обычно будет немного быстрее

== Итеративная реализация: построение

```cpp
void build(const vector<int>& a, int n) {
    for (int i = 0; i < n; i++)
        tree[n + i] = leafs[i];
    for (int i = n - 1; i > 0; i--)
        tree[i] = tree[i * 2 + 1] + tree[i * 2];
}
```

*Время: $O(n)$*

== Итеративная реализация: запрос

```cpp
int query(int l, int r) {
    l += n;
    r += n;
    long long ans = 0;
    while (l < r) {
        if (l & 1 == 1)
            ans += tree[l++];
        if (r & 1 == 1)
            ans += tree[--r];
        l >>= 1; r >>= 1;
    }
    return ans;
}
```

*Идея: два указателя $l$ и $r$ идут навстречу друг другу*

== Итеративная реализация: обновление

```cpp
// присвоить a[pos] = val
void update(int pos, int val) {
    pos += n;
    tree[pos] = val;
    for (v >>= 1; v > 0; v >>= 1)
        tree[v] = tree[v * 2] + tree[v * 2 + 1];
}
```

*Время: $O(log n)$*
