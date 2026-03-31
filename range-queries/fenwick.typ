#import "@preview/pepentation:0.2.0": *
#import "@preview/cetz:0.4.2": canvas, draw

#let draw-fenwick-query() = {
  canvas(length: 0.7cm, {
    import draw: *

    let cell-w = 2.2
    let cell-h = 1.0
    let step = 4

    // Array cells showing sum(7) = t[7] + t[6] + t[4]
    let cells = (
      ((1*step, 0), 1, none),
      ((2*step, 0), 3, none),
      ((3*step, 0), 5, none),
      ((4*step, 0), 16, "used"),
      ((5*step, 0), 9, none),
      ((6*step, 0), 20, "used"),
      ((7*step, 0), 13, "used"),
      ((8*step, 0), 64, none),
    )

    for ((x, y), val, state) in cells {
      let (fill, stroke) = if state == "used" {
        (orange.lighten(70%), orange)
      } else {
        (blue.lighten(80%), blue)
      }
      rect(
        (x - cell-w/2, y - cell-h/2),
        (x + cell-w/2, y + cell-h/2),
        fill: fill,
        stroke: (thickness: 2pt, paint: stroke),
      )
      content((x, y), text(size: 1.2em, weight: "bold")[#val])
    }

    // Arrows showing the path 7 -> 6 -> 4 -> 0
    let arrow-y = -cell-h/2 - 0.8
    content((7*step, arrow-y), text(size: 0.9em)[7])
    content((7*step + 0.3, arrow-y), text(size: 0.8em)[→])
    content((6*step, arrow-y), text(size: 0.9em)[6])
    content((6*step + 0.3, arrow-y), text(size: 0.8em)[→])
    content((4*step, arrow-y), text(size: 0.9em)[4])
    content((4*step + 0.3, arrow-y), text(size: 0.8em)[→])
    content((0, arrow-y), text(size: 0.9em)[0])
  })
}

= Дерево Фенвика

== Идея

Дерево Фенвика --- альтернатива дереву отрезков

Идея: заведем некоторую функцию $F(i) <= i$, тогда дерево Фенвика - массив $t$, $t_i = Sigma^i_(k=F(i)) a_k$

То есть $t_i$ отвечает за сумму на $[F(i), i]$

Тогда сумма на префиксе $"sum"(r) = t_r + "sum"(F(r) - 1)$

Будем рассматривать вариант `F(i) = x - (x & -x) + 1`.
`x & -x` это младший бит x. Значит мы просто зануляем младший бит x применением фукнции.

== Структура
тут должна была быть картинка, но я её не нарисовал.

== Реализация

```cpp
// добавить val к a[pos]
void add(int pos, int val) {
    for (; pos <= n; pos += pos & -pos)
        t[pos] += val;
}

```
== Реализация суммы
```cpp
// сумма на [1, pos]
int sum(int pos) {
    int res = 0;
    for (; pos > 0; pos -= pos & -pos)
        res += t[pos];
    return res;
}

// запрос на [l, r]
int range_sum(int l, int r) {
    return sum(r) - sum(l - 1);
}
```

*Время: $O("log" n)$ на обе операции*

== Построение

```cpp
void build() {
    for (int i = 1; i <= n; i++)
        t[i] = a[i];
    for (int i = 1; i <= n; i++) {
        int j = i + (i & -i);
        if (j <= n)
            t[j] += t[i];
    }
}
```

_Время: $O(n)$_ \
_Альтернатива:_ добавлять элементы по одному через `add()` --- тоже $O(n)$
