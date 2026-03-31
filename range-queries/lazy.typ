#import "@preview/pepentation:0.2.0": *
#import "@preview/cetz:0.4.2": canvas, draw

#let draw-lazy-example() = {
  canvas(length: 0.9cm, {
    import draw: *

    let box-w = 1.5
    let box-h = 0.85
    let level-h = 2.0

    // After range_add(2,5,+5): array becomes [1, 8, 10, 12, 14, 16, 13, 15]
    // Only nodes covering indices 2-5 are updated
    let updated-nodes = (
      ((0, 0), 89),         // [0,7]: 1+8+10+12+14+16+13+15
      ((-4, -level-h), 31), // [0,3]: 1+8+10+12
      ((4, -level-h), 58),  // [4,7]: 14+16+13+15
      ((-2, -2*level-h), 22), // [2,3]: 10+12
      ((2, -2*level-h), 30),   // [4,5]: 14+16
      ((-3, -3*level-h), 10),  // [2]: 10
      ((-1, -3*level-h), 12),  // [3]: 12
      ((1, -3*level-h), 14),   // [4]: 14
      ((3, -3*level-h), 16),   // [5]: 16
    )

    let regular-nodes = (
      ((-6, -2*level-h), 4),   // [0,1]: 1+3
      ((6, -2*level-h), 28),    // [6,7]: 13+15
      ((-7, -3*level-h), 1),   // [0]: 1
      ((-5, -3*level-h), 8),   // [1]: 8
      ((5, -3*level-h), 13),   // [6]: 13
      ((7, -3*level-h), 15),    // [7]: 15
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
      line((x1, y1 - box-h/2), (x2, y2 + box-h/2), stroke: (thickness: 1pt, paint: gray))
    }

    for ((x, y), val) in regular-nodes {
      rect(
        (x - box-w/2, y - box-h/2),
        (x + box-w/2, y + box-h/2),
        fill: blue.lighten(80%),
        stroke: (thickness: 1.5pt, paint: blue),
      )
      content((x, y), text(size: 0.85em, weight: "bold")[#val])
    }

    for ((x, y), val) in updated-nodes {
      rect(
        (x - box-w/2, y - box-h/2),
        (x + box-w/2, y + box-h/2),
        fill: orange.lighten(70%),
        stroke: (thickness: 1.5pt, paint: orange),
      )
      content((x, y), text(size: 0.85em, weight: "bold")[#val])
    }
  })
}

= Массовые операции

== Проблема

*Базовая версия:* обновление одного элемента за $O(log n)$

*Новая задача:* обновление целого отрезка за $O(log n)$

```cpp
// прибавить val ко всем элементам на [l, r]
void range_add(int l, int r, int val);
```

== Пример

#draw-lazy-example()

#v(0.2em)



== Отложенные операции
Идея: не применяем обновление сразу ко всем детям, а запоминаем его.

#text(size: 0.85em)[
Каждый узел хранит: \
- `tree[v]` --- значение на отрезке $[l, r]$ \
- `lazy[v]` --- отложенная операция, которую нужно применить к детям

*Когда спускаемся в ребёнка --- применяем накопленную операцию*
]

== Реализация: push

```cpp
void push(int v) {
    if (lazy[v] != 0) {
        tree[v*2] += lazy[v];
        lazy[v*2] += lazy[v];
        
        tree[v*2+1] += lazy[v];
        lazy[v*2+1] += lazy[v];
        
        lazy[v] = 0;
    }
}
```

== Реализация: range update

```cpp
void update(int v, int l, int r, int ql, int qr, int val) {
    if (ql > r || qr < l) return;          
    if (ql <= l && r <= qr) {              
        tree[v] += val * (r - l + 1);       
        lazy[v] += val;                     
        return;
    }
    push(v);                                
    int mid = (l + r) / 2;
    update(v*2, l, mid, ql, qr, val);
    update(v*2+1, mid+1, r, ql, qr, val);
    tree[v] = tree[v*2] + tree[v*2+1];
}
```

== Реализация: range query

```cpp
int query(int v, int l, int r, int ql, int qr) {
    if (ql > r || qr < l) return 0;         
    if (ql <= l && r <= qr) return tree[v]; 
    push(v);                                // проталкиваем перед запросом
    int mid = (l + r) / 2;
    return query(v*2, l, mid, ql, qr) +
           query(v*2+1, mid+1, r, ql, qr);
}
```

