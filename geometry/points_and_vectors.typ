#import "@preview/pepentation:0.1.0": *
#import "@preview/cetz:0.4.2"

= Точки и векторы

== Основные понятия
  #definition[

    *Точка* --- пара вещественных чисел $(x, y)$, представляющая положение в плоскости.
  ]

  #definition[
    
    *Вектор* --- направленный отрезок от точки $A$ к точке $B$, обозначается $arrow(A B)$ или $(d x, d y)$, где $d x = B_x - A_x$, $d y = B_y - A_y$.
  ]

#grid(
  columns: (1fr, 1fr),
  align: (center, center),
  row-gutter: 1em,
  [
    Точка
    #cetz.canvas({
        import cetz.draw: *
        grid((0,0), (4,4), step: 1, stroke: gray)
        content((2,3), $P(2,3)$, anchor: "south-west")
        circle((2,3), radius: 0.05, fill: black)
    })
  ],
  [
    Вектор
    #cetz.canvas({
        import cetz.draw: *
        grid((0,0), (4,4), step: 1, stroke: gray)
        circle((1,1), radius: 0.05, fill: black)
        content((1,1), $A(1,1)$, anchor: "south-east")
        circle((3,3), radius: 0.05, fill: black)
        content((3,3), $B(3,3)$, anchor: "south-west")
        line((1,1), (3,3), mark: (end: ">"), stroke: blue)
        content((3,1), $arrow(A B) = (2,2)$, anchor: "south")
    })
  ]
)

== Программное представление точки

```cpp
struct Point {
    double x, y;
    Point(double x = 0, double y = 0) : x(x), y(y) {}
    Point operator+(const Vector& v) const { return Point(x + v.x, y + v.y); }
    Point operator-(const Vector& v) const { return Point(x - v.x, y - v.y); }
    bool operator==(const Point& p) const {
      return fabs(x - p.x) < EPS && fabs(y - p.y) < EPS; 
    }
};

double dist(const Point& a, const Point& b) {
    return hypot(a.x - b.x, a.y - b.y);
}
```

#warning[

В геометрических вычислениях избегайте прямого сравнения вещественных чисел с плавающей точкой. Используйте сравнение с epsilon: `fabs(a - b) < EPS`.
]

== Расстояние между точками

#definition[

*Расстояние между двумя точками $A$ и $B$* --- длина отрезка, соединяющего их.

Формула следует из теоремы Пифагора: расстояние -- гипотенуза прямоугольного треугольника с катетами $Delta x$ и $Delta y$.

]

```cpp
```

#remark[

`hypot(a, b)` вычисляет $sqrt(a^2 + b^2)$ с повышенной точностью, избегая переполнения промежуточных значений. Возвращает `double`.
]

#hint[

Для большей точности используйте `hypotl` с `long double`.
]


== Операции с векторами

#definition[

Пусть $arrow(u) = (u_x, u_y)$, $arrow(v) = (v_x, v_y)$. Рассмотрим операции с векторами.
]

#grid(
  columns: (1fr, 1fr),
  gutter: 1em,
  align: left,
  [
    Сложение: $arrow(u) + arrow(v) = (u_x + v_x, u_y + v_y)$
    #cetz.canvas({
        import cetz.draw: *
        grid((0,0), (6,4), step: 1, stroke: gray)
        line((1,1), (3,2), mark: (end: ">"), stroke: blue)
        line((2,3), (4,4), mark: (end: ">"), stroke: (dash: "dashed", paint: blue))
        content((2,1.5), $arrow(u)$, anchor: "north")
        line((1,1), (2,3), mark: (end: ">"), stroke: red)
        line((3,2), (4,4), mark: (end: ">"), stroke: (dash: "dashed", paint: red))
        content((1.5,2), $arrow(v)$, anchor: "east")
        line((1,1), (4,4), mark: (end: ">"), stroke: green)
        content((3,3), $arrow(u) + arrow(v)$, anchor: "south")
    })
  ],
  [
    Вычитание: $arrow(u) - arrow(v) = (u_x - v_x, u_y - v_y)$
    #cetz.canvas({
        import cetz.draw: *
        grid((0,0), (6,4), step: 1, stroke: gray)
        line((1,1), (4,2), mark: (end: ">"), stroke: blue)
        content((2.5,1.5), $arrow(u)$, anchor: "north")
        line((1,1), (3,3), mark: (end: ">"), stroke: red)
        content((2,2), $arrow(v)$, anchor: "east")
        line((3,3), (4,2), mark: (end: ">"), stroke: green)
        content((3.5,2.5), $arrow(u) - arrow(v)$, anchor: "south")
    })
  ],
)
==
#grid(
  columns: (1fr, 1fr),
  gutter: 1em,
  align: left,
  [
    Скаляр на вектор: $k arrow(v) = (k v_x, k v_y)$
    #cetz.canvas({
        import cetz.draw: *
        grid((0,0), (6,4), step: 1, stroke: gray)
        line((1,1), (5,3), mark: (end: ">"), stroke: (paint: green, thickness: 3pt))
        content((3,2.5), $2 arrow(v)$, anchor: "south")
        line((1,1), (3,2), mark: (end: ">"), stroke: blue)
        content((2,1.5), $arrow(v)$, anchor: "north")
    })
  ],
)

- Длина вектора: $|arrow(v)| = sqrt(v_x^2 + v_y^2)$
- Скалярное произведение: $arrow(u) dot arrow(v) = u_x v_x + u_y v_y = |u| |v| cos theta$
- Векторное произведение: $arrow(u) times arrow(v) = u_x v_y - u_y v_x = |u| |v| sin theta$

#remark[

Вообще говоря, формально векторное произведение определяется не так. Оно определено как вектор такой же длины, но перпендикулярный обоим исходным векторам.
]

== Программное представление вектора
```cpp
struct Vector {
    double x, y;
    Vector(double x = 0, double y = 0) : x(x), y(y) {}
    Vector operator+(const Vector& v) const { return Vector(x + v.x, y + v.y); }
    Vector operator-(const Vector& v) const { return Vector(x - v.x, y - v.y); }
    Vector operator*(double k) const { return Vector(x * k, y * k); }
    bool operator==(const Vector& v) const {
      return fabs(x - v.x) < EPS && fabs(y - v.y) < EPS; 
    }
};

double dot(const Vector& a, const Vector& b) { return a.x*b.x + a.y*b.y; }
double cross(const Vector& a, const Vector& b) { return a.x*b.y - a.y*b.x; }
double length(const Vector& v) { return hypot(v.x, v.y); }
```

== Угол между векторами

#definition[

*Угол $theta$ между векторами $arrow(u)$ и $arrow(v)$*: 

$cos theta = display( (arrow(u) dot arrow(v)) / (|arrow(u)| |arrow(v)|) )$
]

Формула следует из определения скалярного произведения: $arrow(u) dot arrow(v) = |u| |v| cos theta$.

```cpp
double angle(const Point& a, const Point& b) {
    return atan2(b.y - a.y, b.x - a.x);
}
```

#remark[

`atan2(y, x)` возвращает угол в радианах от оси OX к вектору $(x, y)$, в диапазоне $(-pi, pi]$. Обрабатывает все квадранты правильно. Возвращает `double`.
]

#hint[

Для большей точности используйте `atan2l` с `long double`.
]
