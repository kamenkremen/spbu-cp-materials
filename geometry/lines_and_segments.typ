#import "@preview/pepentation:0.1.0": *
#import "@preview/cetz:0.4.2"

= Прямые

== Определение

#definition[

   *Прямая* --- это алгебраическая линия первого порядка, множество точек на плоскости (или в пространстве), координаты которых удовлетворяют линейному уравнению первой степени.
]

#definition[

Прямая может быть задана уравнением $a x + b y + c = 0$.

Альтернативно, через две точки $A$ и $B$: $display((y - A_y)/(x - A_x)) = display((B_y - A_y)/(B_x - A_x))$
]

#align(center+horizon, cetz.canvas({
    import cetz.draw: *
    grid((-1,0), (7,4), step: 1, stroke: gray)
    line((-1,2/3), (7,10/3), stroke: blue)

    content((4,3.2), $x - 3y + 3 = 0$)
    content((4,1.2), $display((y-1)/x = 2/6)$)
    circle((0,1), radius: 0.05, fill: black)
    content((0,1), $A(0,1)$, anchor: "south-east")
    circle((6,3), radius: 0.05, fill: black)
    content((6,3), $B(6,3)$, anchor: "north-west")
}))

== Программное представление
```cpp
struct Line {
    double a, b, c;
    Line(double a = 0, double b = 0, double c = 0) : a(a), b(b), c(c) {}
    Line(const Point& p1, const Point& p2) {
        a = p2.y - p1.y;
        b = p1.x - p2.x;
        c = p1.y * p2.x - p1.x * p2.y;
    }
};

```
#v(-0.5em)
#remark[

Формула коэффициентов уравнения прямой по двум точкам:

$display(cases(
a dot "p1".x + b dot "p1".y + c = 0,

a dot "p2".x + b dot "p2".y + c = 0
)) => a ("p2".x - "p1".x) + b ("p2".y - "p1".y) = 0$

Поскольку уравнение однородное относительно $a$ и $b$, выбираем $a = "p2".y - "p1".y$, $b = "p1".x - "p2".x$

Тогда $c = -a dot "p1".x - b dot "p1".y = "p1".y dot "p2".x - "p1".x dot "p2".y$
]

== Параллельность прямых

#definition[

Две прямые параллельны, если их нормальные векторы коллинеарны:

$a_1 b_2 - a_2 b_1 = 0$.
]

```cpp
bool parallel(const Line& l1, const Line& l2) {
    return fabs(l1.a * l2.b - l1.b * l2.a) < EPS;
}
```

#align(center, cetz.canvas({
    import cetz.draw: *
    grid((0,0), (6,5), step: 1, stroke: gray)
    line((0,0), (6,3), stroke: blue)
    line((0,2), (6,5), stroke: red)
    content((3,0.5), $x - 2y = 0$, anchor: "south")
    content((2.5,4), $x - 2y + 4 = 0$, anchor: "south")
}))

== Пересечение прямых

#definition[

Точка пересечения прямых находится решением системы:

$display(cases(
  a_1 x + b_1 y + c_1 = 0,
  a_2 x + b_2 y + c_2 = 0
))$

Формула: $x = display((b_1 c_2 - b_2 c_1)/(a_1 b_2 - a_2 b_1))$, $y = display((a_2 c_1 - a_1 c_2)/(a_1 b_2 - a_2 b_1))$
]

```cpp
Point intersection(const Line& l1, const Line& l2) {
    double d = l1.a * l2.b - l1.b * l2.a;
    double dx = l1.b * l2.c - l1.c * l2.b;
    double dy = l1.c * l2.a - l1.a * l2.c;
    return Point(dx / d, dy / d);
}
```

#align(center, cetz.canvas({
    import cetz.draw: *
    grid((0,0), (4,2), step: 1, stroke: gray)
    line((0,0), (4,2), stroke: blue)
    line((0,2), (4,0), stroke: red)
    circle((2,1), radius: 0.05, fill: black)
    content((2,1), $(2,1)$, anchor: "north-east")
}))

== Угол между прямыми

#definition[

Угол $theta$ между двумя прямыми: $tan theta = display(|(a_1 b_2 - a_2 b_1)/(a_1 a_2 + b_1 b_2)|)$

Используется формула тангенса разности углов наклона.
]

```cpp
double angleBetweenLines(const Line& l1, const Line& l2) {
    double denom = l1.a * l2.a + l1.b * l2.b;
    double num = l1.a * l2.b - l2.a * l1.b;
    return fabs(atan2(num, denom));
}
```

#align(center, cetz.canvas({
    import cetz.draw: *
    grid((0,1), (6,5), step: 1, stroke: gray)
    arc(
      (3.15,3.3), 
      start: 62deg, 
      delta: 90deg,
      radius: .35,
      mode: "PIE",
      fill: color.mix((green, 20%), white),
      stroke: (paint: green),
    )
    line((2,1), (4,5), stroke: blue)
    line((0,4.5), (6,1.5), stroke: red)
    content((2.9,3.4), $theta$, anchor: "south")
}))

== Задача: Точка в прямоугольнике

Дан прямоугольник с вершинами $A$, $B$, $C$, $D$. Посчитать сколько точек из массива P находятся внутри прямоугольника. Будем считать что точка лежащая на стороне находится внутри прямоугольника.

#align(center, cetz.canvas({
    import cetz.draw: *
    grid((0,0), (6,6), step: 1, stroke: gray)
    line((2,1), (5,2), stroke: blue)
    line((5,2), (4,5), stroke: blue)
    line((4,5), (1,4), stroke: blue)
    line((1,4), (2,1), stroke: blue)
    content((2,1), $A$, anchor: "north-east")
    content((5,2), $B$, anchor: "south-west")
    content((4,5), $C$, anchor: "south-west")
    content((1,4), $D$, anchor: "south-east")
    circle((3,3), radius: 0.1, fill: green)
    content((3,3.15), $P_1$, anchor: "south")
    circle((1,2), radius: 0.1, fill: red)
    content((1,2.15), $P_2$, anchor: "south")
    circle((5,3), radius: 0.1, fill: red)
    content((5,3.15), $P_3$, anchor: "south")
    circle((3.5,1.5), radius: 0.1, fill: green)
    content((3.5,1.65), $P_4$, anchor: "south")
    circle((2,5), radius: 0.1, fill: red)
    content((2,5.15), $P_5$, anchor: "south")
}))

== Положение точки относительно прямой

#definition[

Для точки $(A_x, A_y)$ и прямой $a x + b y + c = 0$:

- Если $a A_x + b A_y + c > 0$, точка находится выше прямой (для стандартной ориентации).
- Если $a A_x + b A_y + c < 0$, точка находится ниже прямой.
- Если $a A_x + b A_y + c = 0$, точка лежит на прямой.
]

#align(center, grid(
  columns: 2,
  align: (center+horizon, left+horizon), 
  gutter: 1em,
  [
    $x + y - 4 = 0$
    #cetz.canvas({
      import cetz.draw: *
      grid((-1,0), (5,4), step: 1, stroke: gray)
      line((0,4), (4,0), stroke: blue)
      circle((2,3), radius: 0.05, fill: green)
      content((2,3), $A(2,3)$, anchor: "south-west")
      circle((1,2), radius: 0.05, fill: red)
      content((1,2), $B(1,2)$, anchor: "north-east")
      circle((3,1), radius: 0.05, fill: black)
      content((3,1), $C(3,1)$, anchor: "south-west")
    })
  ],
  [
    $A: 2+3-4 = 1$

    $B: 1+2-4 = -1$

    $C: 3+1-4 = 0$
  ]
))

== Зависимость знака от нормального вектора

#remark[

Знак выражения $a x + b y + c$ зависит от направления нормального вектора $(a, b)$.

Если поменять направление нормального вектора на противоположное $(-a, -b)$, то и знак изменится на противоположный.

Поэтому важно заранее определить, какая сторона прямой считается "положительной".
]

#align(center, grid(
  columns: 2,
  gutter: 2em,
  [
    #cetz.canvas({
      import cetz.draw: *
      grid((-1,0), (5,4), step: 1, stroke: gray)
      
      for x in range(-1, 5) {
        for y in range(0, 4) {
          if calc.rem(x + y, 2) == 0 {
             let val = x + y - 3
             if val > 0 {
               content((x + 0.5, y + 0.5), text(fill: green)[$+$])
             } else {
               content((x + 0.5, y + 0.5), text(fill: red)[$-$])
             }
          }
        }
      }

      line((0,4), (4,0), stroke: blue)
      line((0.5,3.5), (1,4), stroke: (paint: green, thickness: 2pt), mark: (end: "triangle", fill: green))
      line((1.5,2.5), (2,3), stroke: (paint: green, thickness: 2pt), mark: (end: "triangle", fill: green))
      line((2.5,1.5), (3,2), stroke: (paint: green, thickness: 2pt), mark: (end: "triangle", fill: green))
      line((3.5,0.5), (4,1), stroke: (paint: green, thickness: 2pt), mark: (end: "triangle", fill: green))
    })
  ],
  [
    #cetz.canvas({
      import cetz.draw: *
      grid((-1,0), (5,4), step: 1, stroke: gray)

      for x in range(-1, 5) {
        for y in range(0, 4) {
          if calc.rem(x + y, 2) == 0 {
             let val = x + y - 3
             // Inverted logic
             if val > 0 {
               content((x + 0.5, y + 0.5), text(fill: red)[$-$])
             } else {
               content((x + 0.5, y + 0.5), text(fill: green)[$+$])
             }
          }
        }
      }

      line((0,4), (4,0), stroke: blue)
      line((0.5,3.5), (0,3), stroke: (paint: green, thickness: 2pt), mark: (end: "triangle", fill: green))
      line((1.5,2.5), (1,2), stroke: (paint: green, thickness: 2pt), mark: (end: "triangle", fill: green))
      line((2.5,1.5), (2,1), stroke: (paint: green, thickness: 2pt), mark: (end: "triangle", fill: green))
      line((3.5,0.5), (3,0), stroke: (paint: green, thickness: 2pt), mark: (end: "triangle", fill: green))
    })
  ]
))

== Алгоритм Коэна-Сазерленда

Не особо нужный в рамках спортивного программирования, но полезный в компьютерной графике алгоритм для отсечения отрезков использует кодирование, позволяющее легко понять как расположены объекты внутри прямоугольника.

Для быстрой проверки принадлежности точки прямоугольнику используется 4-битное кодирование:

#grid(
  columns: 2,
  align: (left, left),
  gutter: 2em,
  [
    #v(3em)
- Бит 0: слева от левой стороны
- Бит 1: справа от правой стороны
- Бит 2: ниже нижней стороны
- Бит 3: выше верхней стороны
],
  [Точка внутри, если код = 0
  #align(center,cetz.canvas({
    import cetz.draw: *
    line((0,1), (4,1), stroke: blue)
    line((3,0), (3,4), stroke: blue)
    line((4,3), (0,3), stroke: blue)
    line((1,4), (1,0), stroke: blue)
    content((1,1), "A", anchor: "south-west")
    content((3,1), "B", anchor: "south-east")
    content((3,3), "C", anchor: "north-east")
    content((1,3), "D", anchor: "north-west")

    content((0.5,0.5), "1100", fill: red)
    content((0.5,2), "1000", fill: red)
    content((0.5,3.5), "1010", fill: red)
    content((2,0.5), "0100", fill: red)
    content((2,2), "0000", fill: green)
    content((2,3.5), "0010", fill: red)
    content((3.5,0.5), "0101", fill: red)
    content((3.5,2), "0001", fill: red)
    content((3.5,3.5), "0011", fill: red)
  }))],
)

== Выбор векторов

Для удобства проверки принадлежности точки многоугольнику, упорядочим вершины так, чтобы внутренняя сторона была с положительной стороны каждого ребра.

*Алгоритм:*
1. Найти центр прямоугольника (среднее всех вершин)
2. Отсортировать вершины по полярному углу относительно центра
3. При обходе против часовой стрелки внутренность будет слева (положительная сторона)

==

#align(center, grid(
  columns: 2,
  gutter: 3em,
  [
    До сортировки
    #cetz.canvas({
      import cetz.draw: *
      grid((0,0), (6,6), step: 1, stroke: gray)
      
      line((0,3), (6,3), stroke: (paint: black, thickness: 1pt), mark: (end: "triangle", fill: black))
      line((3,0), (3,6), stroke: (paint: black, thickness: 1pt), mark: (end: "triangle", fill: black))
      content((6,3), $x$, anchor: "south-west")
      content((3,6), $y$, anchor: "south-west")
      
      line((3,3), (2,1), stroke: (paint: gray, dash: "dashed"))
      line((3,3), (5,2), stroke: (paint: gray, dash: "dashed"))
      line((3,3), (4,5), stroke: (paint: gray, dash: "dashed"))
      line((3,3), (1,4), stroke: (paint: gray, dash: "dashed"))

      circle((2,1), radius: 0.08, fill: black)
      content((2,1.2), $A$, anchor: "south")
      circle((5,2), radius: 0.08, fill: black)
      content((5,2.2), $B$, anchor: "south")
      circle((4,5), radius: 0.08, fill: black)
      content((4,5.2), $C$, anchor: "south")
      circle((1,4), radius: 0.08, fill: black)
      content((1,4.2), $D$, anchor: "south")
      
      circle((3,3), radius: 0.08, fill: red)
      content((3.2,3.2), $O$, anchor: "south-west")
    })
  ],
  [
    После сортировки по углу
    #cetz.canvas({
      import cetz.draw: *
      grid((0,0), (6,6), step: 1, stroke: gray)
      
      line((0,3), (6,3), stroke: (paint: black, thickness: 1pt), mark: (end: "triangle", fill: black))
      line((3,0), (3,6), stroke: (paint: black, thickness: 1pt), mark: (end: "triangle", fill: black))
      content((6,3), $x$, anchor: "south-west")
      content((3,6), $y$, anchor: "south-west")
      
      circle((3,3), radius: 0.08, fill: red)
      content((3.2,3.2), $O$, anchor: "south-west")
      
      line((2,1), (5,2), stroke: (paint: blue, thickness: 2pt), mark: (end: "triangle", fill: blue))
      line((5,2), (4,5), stroke: (paint: blue, thickness: 2pt), mark: (end: "triangle", fill: blue))
      line((4,5), (1,4), stroke: (paint: blue, thickness: 2pt), mark: (end: "triangle", fill: blue))
      line((1,4), (2,1), stroke: (paint: blue, thickness: 2pt), mark: (end: "triangle", fill: blue))
      
      line((3.5,1.5), (3.2,2.1), stroke: (paint: green, thickness: 2pt), mark: (end: "triangle", fill: green))
      line((4.5,3.5), (3.9,3.3), stroke: (paint: green, thickness: 2pt), mark: (end: "triangle", fill: green))
      line((2.5,4.5), (2.8,3.9), stroke: (paint: green, thickness: 2pt), mark: (end: "triangle", fill: green))
      line((1.5,2.5), (2.1,2.7), stroke: (paint: green, thickness: 2pt), mark: (end: "triangle", fill: green))

      circle((2,1), radius: 0.08, fill: black)
      content((1.8,0.8), $P_0: -2.03$, anchor: "north")
      circle((5,2), radius: 0.08, fill: black)
      content((3.8,1.5), $P_1: -0.46$, anchor: "north-west")
      circle((4,5), radius: 0.08, fill: black)
      content((4,5), $P_2: 1.11$, anchor: "south")
      circle((1,4), radius: 0.08, fill: black)
      content((2,4.3), $P_3: 2.68$, anchor: "south-east")
    })
  ]
))

#hint[
При сортировке по углу против часовой стрелки, векторное произведение $(P_(i+1) - P_i) times (Q - P_i) > 0$ для точек $Q$ внутри многоугольника.
]

== Ориентация точек

#definition[
Ориентация трех точек $A$, $B$, $C$ -- направление поворота от $arrow(A B)$ к $arrow(B C)$.
- Положительная: против часовой стрелки (CCW)
- Отрицательная: по часовой стрелке (CW)
- Нулевая: коллинеарны
]
Вычисляется через векторное произведение: $(B - A) times (C - B)$
```cpp
int orientation(const Point& a, const Point& b, const Point& c) {
    double val = cross(b - a, c - b);
    if (fabs(val) < EPS) return 0;
    return val > 0 ? 1 : 2;
}
```
#align(center, grid(
  columns: 3,
  align: center,
  gutter: 4em,
  [
    Положительная CCW
    #cetz.canvas({
      import cetz.draw: *
      circle((0,0), radius: 0.05, fill: black)
      content((-0.1,0), $A$, anchor: "south-east")
      circle((2,0), radius: 0.05, fill: black)
      content((2.1,0), $B$, anchor: "south-west")
      circle((1,1.5), radius: 0.05, fill: black)
      content((0.8,1.5), $C$, anchor: "south")
      line((0,0), (2,0), stroke: blue)
      line((2,0), (1,1.5), stroke: blue)
    })
  ],
  [
    Отрицательная CW
    #cetz.canvas({
      import cetz.draw: *
      circle((0,1.5), radius: 0.05, fill: black)
      content((-0.1,1.5), $A$, anchor: "north-east")
      circle((2,1.5), radius: 0.05, fill: black)
      content((2.1,1.5), $B$, anchor: "north-west")
      circle((1,0), radius: 0.05, fill: black)
      content((0.7,0), $C$, anchor: "north")
      line((0,1.5), (2,1.5), stroke: red)
      line((2,1.5), (1,0), stroke: red)
    })
  ],
  [
    Коллинеарны
    #cetz.canvas({
      import cetz.draw: *
      circle((0,0.75), radius: 0.05, fill: black)
      content((0,0.85), $A$, anchor: "south-east")
      circle((1,0.75), radius: 0.05, fill: black)
      content((1,0.85), $B$, anchor: "south")
      circle((2,0.75), radius: 0.05, fill: black)
      content((2,0.85), $C$, anchor: "south-west")
      line((0,0.75), (1,0.75), stroke: gray)
      line((1,0.75), (2,0.75), stroke: gray)
    })
  ]
))

==
```cpp
vector<Point> createRectangle(const Point& A, const Point& B, const Point& C, const Point& D) {
    vector<Point> pts = {A, B, C, D};
    Point center = {0, 0};
    for (auto& p : pts) {
        center.x += p.x;
        center.y += p.y;
    }
    center.x /= 4;
    center.y /= 4;

    sort(pts.begin(), pts.end(), [&](const Point& p1, const Point& p2) {
        double ang1 = atan2(p1.y - center.y, p1.x - center.x);
        double ang2 = atan2(p2.y - center.y, p2.x - center.x);
        return ang1 < ang2;
    });
    return pts;
}
```


== Подсчёт точек
Остаётся только посчитать сколько точек находятся с положительной стороны относительно всех сторон подставляя значения. Это шаг без дополнительной теоретической базы :)

==
```cpp
bool pointInPolygon(const Point& p, const vector<Point>& poly) {
    for (int i = 0; i < poly.size(); ++i) {
        Point a = poly[i], b = poly[(i+1) % poly.size()];
        if (cross(b - a, p - a) < -EPS) return false;
    }
    return true;
}

int countPointsInside(const vector<Point>& P, const vector<Point>& rect) {
    int count = 0;
    for (const auto& p : P) {
        if (pointInPolygon(p, rect)) {
            count++;
        }
    }
    return count;
}
```

== Расстояние и проекция точки на прямую

#grid(
  columns: 2,
  gutter: 3em,
  [
    #definition[
*Ближайшая точка на прямой (проекция)* --- точка пересечения прямой с перпендикуляром, опущенным из $P$ на прямую.

Расстояние от точки $P$ до прямой $a x + b y + c = 0$:

$d = display(abs(a P_x + b P_y + c) / sqrt(a^2 + b^2))$
]
  ],
  [
    #align(center, cetz.canvas({
      import cetz.draw: *
      line((0,1), (4,3), stroke: blue)
      circle((1,3.5), radius: 0.05, fill: black)
      content((1,3.6), $P_1$, anchor: "south")
      circle((1.8,1.9), radius: 0.05, fill: red)
      content((1.7,1.8), $Q_1$, anchor: "north")
      line((1,3.5), (1.8,1.9), stroke: (paint: green, dash: "dashed"))
      content((1.4,2.85), $d_1$, anchor: "west")
      circle((3,1.5), radius: 0.05, fill: black)
      content((3,1.3), $P_2$, anchor: "north")
      circle((2.6,2.3), radius: 0.05, fill: red)
      content((2.6,2.4), $Q_2$, anchor: "south")
      line((3,1.5), (2.6,2.3), stroke: (paint: green, dash: "dashed"))
      content((2.9,2.0), $d_2$, anchor: "west")
    }))
  ]
)
```cpp
double distPointToLine(const Point& p, const Line& l) {
    return fabs(l.a * p.x + l.b * p.y + l.c) / hypot(l.a, l.b);
}
Point closestPointOnLine(const Point& p, const Line& l) {
    double denom = l.a * l.a + l.b * l.b;
    double x = (l.b * (l.b * p.x - l.a * p.y) - l.a * l.c) / denom;
    double y = (l.a * (l.a * p.y - l.b * p.x) - l.b * l.c) / denom;
    return Point(x, y);
}
```

== Отражение точки относительно прямой

#definition[

*Отражение точки $P$ относительно прямой $L$* --- единственная точка $P''$ такая, что $L$ является серединным перпендикуляром отрезка $P P''$.

Вычисляется через проекцию: $P'' = 2 P' - P$, где $P'$ -- проекция $P$ на $L$.
]

```cpp
Point reflectPointOverLine(const Point& p, const Line& l) {
    Point proj = closestPointOnLine(p, l);
    return Point(2 * proj.x - p.x, 2 * proj.y - p.y);
}
```

#align(center, cetz.canvas({
    import cetz.draw: *
    grid((0,1), (4,5), step: 1, stroke: gray)
    line((0,2), (4,4), stroke: blue)
    circle((1.5,4), radius: 0.05, fill: black)
    content((1.5,4.1), $P$, anchor: "south")
    circle((2.5,2), radius: 0.05, fill: red)
    content((2.5,1.9), $P''$, anchor: "north")
    circle((2,3), radius: 0.05, fill: green)
    content((1.7,2.9), $P'$, anchor: "south")
    line((1.5,4), (2.5,2), stroke: (paint: purple, dash: "dashed"))
}))

= Отрезки

=== Определение

#definition[

*Отрезок* -- это часть прямой, ограниченная двумя точками $A$ и $B$.
]

```cpp
struct Segment {
    Point a, b;
    Segment(Point a = {0, 0}, Point b = {0, 0}) : a(a), b(b) {}
};
```

#align(center, cetz.canvas({
    import cetz.draw: *
    grid((0,0), (6,4), step: 1, stroke: gray)
    line((0,0.5), (6,3.5), stroke: blue)
    line((1,1), (5,3), stroke: green)
    circle((1,1), radius: 0.05, fill: black)
    content((1,1), $A(1,1)$, anchor: "south-east")
    circle((5,3), radius: 0.05, fill: black)
    content((5,3), $B(5,3)$, anchor: "north-west")
    content((3,2.5), $[A B]$, anchor: "south")
}))


== Операции с отрезками

#definition[

Для отрезка $[A B]$:

- Длина: $sqrt((B_x - A_x)^2 + (B_y - A_y)^2)$
- Деление в отношении $m:n$: $(display((n A_x + m B_x)/(m+n)), display((n A_y + m B_y)/(m+n)))$
]

```cpp
double segmentLength(const Point& a, const Point& b) {
    return hypot(b.x - a.x, b.y - a.y);
}

Point segmentMidpoint(const Point& a, const Point& b) {
    return Point((a.x + b.x) / 2, (a.y + b.y) / 2);
}

Point divideSegment(const Point& a, const Point& b, double m, double n) {
    return Point((n*a.x + m*b.x) / (m + n), (n*a.y + m*b.y) / (m + n));
}
```

== Пересечение отрезков

Два отрезка $[A B]$ и $[C D]$ пересекаются, если:

1. Ориентации $A,B,C$ и $A,B,D$ различны
2. Ориентации $C,D,A$ и $C,D,B$ различны

Исключение: если все четыре точки коллинеарны, нужно проверить перекрытие.
#v(3em)

#align(center, grid(
  columns: 4,
  align: center,
  gutter: 1em,
  [
    Пересекающиеся
    #cetz.canvas({
      import cetz.draw: *
      circle((0,0), radius: 0.05, fill: black)
      content((0,0), $A$, anchor: "south-east")
      circle((3,2), radius: 0.05, fill: black)
      content((3,2), $B$, anchor: "north-west")
      circle((0,2), radius: 0.05, fill: black)
      content((0,2), $C$, anchor: "north-east")
      circle((3,0), radius: 0.05, fill: black)
      content((3,0), $D$, anchor: "south-west")
      line((0,0), (3,2), stroke: blue, thickness: 2pt)
      line((0,2), (3,0), stroke: red, thickness: 2pt)
    })
  ],
  [
    Параллельные
    #cetz.canvas({
      import cetz.draw: *
      circle((0,0), radius: 0.05, fill: black)
      content((0,0), $A$, anchor: "south-east")
      circle((3,0), radius: 0.05, fill: black)
      content((3,0), $B$, anchor: "south-west")
      circle((0,1), radius: 0.05, fill: black)
      content((0,1), $C$, anchor: "north-east")
      circle((3,1), radius: 0.05, fill: black)
      content((3,1), $D$, anchor: "north-west")
      line((0,0), (3,0), stroke: blue, thickness: 2pt)
      line((0,1), (3,1), stroke: red, thickness: 2pt)
    })
  ],
  [
    Касание в конце
    #cetz.canvas({
      import cetz.draw: *
      circle((0,0), radius: 0.05, fill: black)
      content((0,0), $A$, anchor: "south-east")
      circle((3,1), radius: 0.05, fill: black)
      content((3,1), $B$, anchor: "north-west")
      circle((3,1), radius: 0.05, fill: black)
      content((3.1,1), $C$, anchor: "south-west")
      circle((0,2), radius: 0.05, fill: black)
      content((0,2), $D$, anchor: "north-east")
      line((0,0), (3,1), stroke: blue, thickness: 2pt)
      line((3,1), (0,2), stroke: red, thickness: 2pt)
    })
  ],
  [
    Коллинеарные (перекрываются)
    #cetz.canvas({
      import cetz.draw: *
      circle((0,1), radius: 0.05, fill: black)
      content((0,1), $A$, anchor: "south-east")
      circle((2,1), radius: 0.05, fill: black)
      content((2,1), $B$, anchor: "south")
      circle((1,1), radius: 0.05, fill: black)
      content((1,1.1), $C$, anchor: "south")
      circle((3,1), radius: 0.05, fill: black)
      content((3,1), $D$, anchor: "south-west")
      line((0,1), (2,1), stroke: blue, thickness: 2pt)
      line((1,1), (3,1), stroke: red, thickness: 2pt)
    })
  ]
))
