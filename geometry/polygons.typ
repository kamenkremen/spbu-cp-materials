#import "@preview/pepentation:0.1.0": *
#import "@preview/cetz:0.4.2"

= Многоугольники

== Определение

#definition[

*Многоугольник* -- это замкнутая ломаная линия, состоящая из последовательности отрезков, соединяющих вершины. Вершины упорядочены, и первая соединяется с последней.

- *Простой многоугольник*: не пересекает сам себя.
- *Выпуклый многоугольник*: все внутренние углы <= 180°, и любая линия между двумя вершинами лежит внутри.
- *Вогнутый многоугольник*: имеет хотя бы один внутренний угол > 180°.
]

#align(center, grid(
  columns: 3,
  align: center,
  gutter: (4em, 2em),
  [
    Выпуклый
    #cetz.canvas({
      import cetz.draw: *
      let r = 1
      let cx = 1
      let cy = 1
      let points = (
        (cx + r, cy),
        (cx + r/2, cy + r * calc.sqrt(3)/2),
        (cx - r/2, cy + r * calc.sqrt(3)/2),
        (cx - r, cy),
        (cx - r/2, cy - r * calc.sqrt(3)/2),
        (cx + r/2, cy - r * calc.sqrt(3)/2)
      )
      for p in points {
        circle(p, radius: 0.05, fill: black)
      }
      for i in range(6) {
        let j = calc.rem(i + 1, 6)
        line(points.at(i), points.at(j), stroke: blue)
      }
      content((1,-0.2), "Гексагон", anchor: "north")
    })
  ],
  [
    Вогнутый
    #cetz.canvas({
      import cetz.draw: *
      let cx = 1.5
      let cy = 1
      let outer_r = 1
      let inner_r = 0.4
      let points = ()
      for i in range(5) {
        let angle = i * 72 * calc.pi / 180
        let outer_x = cx + outer_r * calc.cos(angle)
        let outer_y = cy + outer_r * calc.sin(angle)
        let inner_angle = angle + 36 * calc.pi / 180
        let inner_x = cx + inner_r * calc.cos(inner_angle)
        let inner_y = cy + inner_r * calc.sin(inner_angle)
        points.push((outer_x, outer_y))
        points.push((inner_x, inner_y))
      }
      for p in points {
        circle(p, radius: 0.05, fill: black)
      }
      for i in range(10) {
        let j = calc.rem(i + 1, 10)
        line(points.at(i), points.at(j), stroke: red)
      }
      content((1.5,-0.2), "Звезда", anchor: "north")
    })
  ],
  [
    Самопересекающийся
    #cetz.canvas({
      import cetz.draw: *
      let cx = 1
      let cy = 1
      let r = 1
      let points = ()
      for i in range(5) {
        let angle = i * 72 * calc.pi / 180
        points.push((cx + r * calc.cos(angle), cy + r * calc.sin(angle)))
      }
      for p in points {
        circle(p, radius: 0.05, fill: black)
      }
      // Pentagram connections: 0-2, 2-4, 4-1, 1-3, 3-0
      line(points.at(0), points.at(2), stroke: gray)
      line(points.at(2), points.at(4), stroke: gray)
      line(points.at(4), points.at(1), stroke: gray)
      line(points.at(1), points.at(3), stroke: gray)
      line(points.at(3), points.at(0), stroke: gray)
      content((1,-0.2), "Пентаграмма", anchor: "north")
    })
  ]
))

== Периметр многоугольника

#definition[

Периметр многоугольника -- это сумма длин всех его сторон. Для многоугольника с вершинами $P_1, P_2, ..., P_n$:

$P = Sigma_(i=1)^n "dist"(P_i, P_(i+1))$, где $P_(n+1) = P_1$, а $"dist"$ --- расстояние между точками.
]

#grid(
  columns: (1fr, 2fr),
  gutter: 1em,
  align: (center+horizon, left),
  [
    #cetz.canvas({
      import cetz.draw: *
      line((1,2), (2,1), (3,1), (4,2), (4,3), (3,4), close: true, stroke: blue)
      circle((1,2), radius: 0.05, fill: black)
      content((0.9,2.1), $P_1(1,2)$, anchor: "east")
      circle((2,1), radius: 0.05, fill: black)
      content((1.8,1), $P_2(2,1)$, anchor: "east")
      circle((3,1), radius: 0.05, fill: black)
      content((3.2,1), $P_3(3,1)$, anchor: "west")
      circle((4,2), radius: 0.05, fill: black)
      content((4.1,2), $P_4(4,2)$, anchor: "west")
      circle((4,3), radius: 0.05, fill: black)
      content((4.1,3), $P_5(4,3)$, anchor: "west")
      circle((3,4), radius: 0.05, fill: black)
      content((3,4.1), $P_6(3,4)$, anchor: "south")
    })
  ],
  [
    Вычисление периметра:

    $"dist"(P_1, P_2) = sqrt(1+1) = sqrt(2) ≈ 1.41$

    $"dist"(P_2, P_3) = sqrt(1+0) = 1$

    $"dist"(P_3, P_4) = sqrt(1+1) = sqrt(2) ≈ 1.41$

    $"dist"(P_4, P_5) = sqrt(0+1) = 1$

    $"dist"(P_5, P_6) = sqrt(1+1) = sqrt(2) ≈ 1.41$

    $"dist"(P_6, P_1) = sqrt(4+4) = sqrt(8) ≈ 2.83$

    $"Сумма" approx 1.41 + 1 + 1.41 + 1 + 1.41 + 2.83 ≈ 8.66$
  ]
)

==

```cpp
double polygonPerimeter(const vector<Point>& p) {
    double perim = 0;
    int n = p.size();
    for (int i = 0; i < n; i++) {
        int j = (i + 1) % n;
        perim += dist(p[i], p[j]);
    }
    return perim;
}
```

== Площадь многоугольника

#definition[
Для многоугольника с вершинами $P_1, P_2, ..., P_n$ (в порядке обхода по часовой стрелке или против):

$S = display(1/2) |Sigma_(i=1)^n (x_i y_(i+1) - x_(i+1) y_i)|$

*Формула площади Гауса (shoelace/плетенка)* геометрически соответствует сумме площадей ориентированных треугольников от начала координат.
]

#grid(
  columns: (1fr, 2fr),
  gutter: 1em,
  align: (center, left),
  [
    #cetz.canvas({
      import cetz.draw: *
      line((0,0), (3,1), (4,2), close: true, fill: color.mix((red, 30%), white), stroke: none)
      line((0,0), (4,2), (4,3), close: true, fill: color.mix((orange, 30%), white), stroke: none)
      line((0,0), (4,3), (3,4), close: true, fill: color.mix((purple, 30%), white), stroke: none)
      line((0,0), (3,4), (1,2), close: true, fill: color.mix((teal, 30%), white), stroke: none)
      line((0,0), (2,1), (3,1), close: true, fill: green.transparentize(70%), stroke: none)
      line((0,0), (1,2), (2,1), close: true, fill: blue.transparentize(70%), stroke: none)
      line((1,2), (2,1), stroke: blue, thickness: 2pt)
      line((2,1), (3,1), stroke: blue, thickness: 2pt)
      line((3,1), (4,2), stroke: blue, thickness: 2pt)
      line((4,2), (4,3), stroke: blue, thickness: 2pt)
      line((4,3), (3,4), stroke: blue, thickness: 2pt)
      line((3,4), (1,2), stroke: blue, thickness: 2pt)
      circle((1,2), radius: 0.05, fill: black)
      content((0.9,2.1), $P_1(1,2)$, anchor: "east")
      circle((2,1), radius: 0.05, fill: black)
      content((1.8,1), $P_2(2,1)$, anchor: "east")
      circle((3,1), radius: 0.05, fill: black)
      content((3.2,1), $P_3(3,1)$, anchor: "west")
      circle((4,2), radius: 0.05, fill: black)
      content((4.1,2), $P_4(4,2)$, anchor: "west")
      circle((4,3), radius: 0.05, fill: black)
      content((4.1,3), $P_5(4,3)$, anchor: "west")
      circle((3,4), radius: 0.05, fill: black)
      content((3,4.1), $P_6(3,4)$, anchor: "south")
    })
  ],
  [
    Вычисление площади по формуле шнуровки:

    $P_1(1,2), P_2(2,1), P_3(3,1), P_4(4,2), P_5(4,3), P_6(3,4)$

    $Sigma = (1 dot 1 - 2 dot 2) + (2 dot 1 - 3 dot 1) + (3 dot 2 - 4 dot 1) + (4 dot 3 - 4 dot 2) + (4 dot 4 - 3 dot 3) + (3 dot 2 - 1 dot 4) = (1 - 4) + (2 - 3) + (6 - 4) + (12 - 8) + (16 - 9) + (6 - 4) = 11 => S = display(1/2) |11| = 5.5$
  ]
)

== Доказательство

Площадь многоугольника можно разложить на сумму площадей треугольников, образованных фиксированной точкой и каждым ребром.

Поскольку формула инвариантна относительно сдвига, можно считать, что одна вершина находится в начале координат $(0,0)$ не умаляя общности.

Для треугольника с вершинами $(0,0)$, $(x_1, y_1)$, $(x_2, y_2)$ площадь $S = display(1/2) |x_1 y_2 - x_2 y_1|$.

Шнуровка для трёх точек: $x_0 y_1 - x_1 y_0 + x_1 y_2 - x_2 y_1 + x_2 y_0 - x_0 y_2 = 0·y_1 - x_1·0 + x_1·y_2 - x_2·y_1 + x_2·0 - 0·y_2 = x_1 y_2 - x_2 y_1$.

Таким образом, $S = display(1/2) |x_1 y_2 - x_2 y_1|$, что совпадает.

Для многоугольников площадь аддитивна, поэтому формула верна.

==

```cpp
double polygonArea(const vector<Point>& p) {
    double area = 0;
    int n = p.size();
    for (int i = 0; i < n; i++) {
        int j = (i + 1) % n;
        area += cross(p[i], p[j]);
    }
    return fabs(area) / 2;
}
```

#remark[

Знак площади зависит от порядка обхода: положительный для против часовой стрелки, отрицательный для по часовой. Формула инвариантна относительно сдвига начала координат.
]

== Центроид (центр масс)

#definition[

*Центроид* многоугольника --- это геометрический центр или центр масс фигуры, точка, в которой фигура находится в равновесии.

Для многоугольника центроид $(C_x, C_y)$:

$C_x = display(1/(6 S)) Sigma_(i=1)^n (x_i + x_(i+1)) (x_i y_(i+1) - x_(i+1) y_i)$

$C_y = display(1/(6 S)) Sigma_(i=1)^n (y_i + y_(i+1)) (x_i y_(i+1) - x_(i+1) y_i)$

Где $S$ -- площадь.
]

#align(center, grid(
  columns: (4fr, 5fr),
  align: (right, left+horizon),
  gutter: 2em,
  [
    #cetz.canvas({
      import cetz.draw: *
      circle((1,2), radius: 0.05, fill: black)
      content((0.9,2.1), $P_1$, anchor: "east")
      circle((2,1), radius: 0.05, fill: black)
      content((1.8,1), $P_2$, anchor: "east")
      circle((3,1), radius: 0.05, fill: black)
      content((3.2,1), $P_3$, anchor: "west")
      circle((4,2), radius: 0.05, fill: black)
      content((4.1,2), $P_4$, anchor: "west")
      circle((4,3), radius: 0.05, fill: black)
      content((4.1,3), $P_5$, anchor: "west")
      circle((3,4), radius: 0.05, fill: black)
      content((2.7,4), $P_6$, anchor: "east")
      line((1,2), (2,1), stroke: blue, thickness: 2pt)
      line((2,1), (3,1), stroke: blue, thickness: 2pt)
      line((3,1), (4,2), stroke: blue, thickness: 2pt)
      line((4,2), (4,3), stroke: blue, thickness: 2pt)
      line((4,3), (3,4), stroke: blue, thickness: 2pt)
      line((3,4), (1,2), stroke: blue, thickness: 2pt)
      circle((2.5, 2.5), radius: 0.05, fill: red)
      content((2.5, 2.7), $C$, anchor: "south")
    })
  ],
  [
    $C_x = display(89/(6 dot 5.5)) approx 2.70$

    $C_y = display(76/(6 dot 5.5)) approx 2.30$
  ]
))

== Доказательство

Центроид можно вычислить, разложив многоугольник на треугольники с вершиной в начале координат и взяв взвешенное среднее их центров.

Для треугольника с вершинами $(0,0)$, $(x_1, y_1)$, $(x_2, y_2)$ центроид находится в $(display((x_1 + x_2)/3), display((y_1 + y_2)/3))$.

Площадь треугольника $S_t = display(1/2) |x_1 y_2 - x_2 y_1|$.

Тогда вклад в центроид: $(S_t dot display((x_1 + x_2)/3), S_t dot display((y_1 + y_2)/3))$.

Суммируя по всем треугольникам и деля на общую площадь, получаем формулу.

==

```cpp
Point polygonCentroid(const vector<Point>& p) {
    double cx = 0, cy = 0, area = 0;
    int n = p.size();
    for (int i = 0; i < n; i++) {
        int j = (i + 1) % n;
        double cr = cross(p[i], p[j]);
        area += cr;
        cx += (p[i].x + p[j].x) * cr;
        cy += (p[i].y + p[j].y) * cr;
    }
    area /= 2;
    cx /= (6 * area);
    cy /= (6 * area);
    return Point(cx, cy);
}
```

== Выпуклость

#definition[

Многоугольник называется *выпуклым*, если он лежит по одну сторону от любой своей стороны, или, эквивалентно, если все его внутренние углы <= 180°.

Выпуклый многоугольник можно определить через ориентацию поворотов: все последовательные повороты (определяемые векторными произведениями) должны быть в одну сторону.

]

#grid(
  columns: (1fr, 1fr),
  gutter: 1em,
  align: center,
  [
    Выпуклый пятиугольник
    #cetz.canvas({
      import cetz.draw: *
      circle((1,0), radius: 0.05, fill: black)
      circle((3,0.5), radius: 0.05, fill: black)
      circle((2.5,2), radius: 0.05, fill: black)
      circle((0.5,2), radius: 0.05, fill: black)
      circle((0,1), radius: 0.05, fill: black)
      line((1,0), (3,0.5), stroke: blue)
      line((3,0.5), (2.5,2), stroke: blue)
      line((2.5,2), (0.5,2), stroke: blue)
      line((0.5,2), (0,1), stroke: blue)
      line((0,1), (1,0), stroke: blue)
    })
  ],
  [
    Вогнутый пятиугольник
    #cetz.canvas({
      import cetz.draw: *
      circle((0,0), radius: 0.05, fill: black)
      circle((3,0), radius: 0.05, fill: black)
      circle((2.5,1.5), radius: 0.05, fill: black)
      circle((1,1), radius: 0.05, fill: black)
      circle((0.5,2), radius: 0.05, fill: black)
      line((0,0), (3,0), stroke: red)
      line((3,0), (2.5,1.5), stroke: red)
      line((2.5,1.5), (1,1), stroke: red)
      line((1,1), (0.5,2), stroke: red)
      line((0.5,2), (0,0), stroke: red)
    })
  ]
)

==
```cpp
bool isConvex(const vector<Point>& p) {
    int n = p.size();
    if (n < 3) return false;
    bool sign = false;

    for (int i = 0; i < n; i++) {
        int j = (i + 1) % n;
        int k = (i + 2) % n;
        double cross = cross(p[j] - p[i], p[k] - p[j]);
        if (fabs(cross) > EPS) {
            if (sign == false) sign = cross > 0;
            else if (sign != (cross > 0)) return false;
        }
    }
    return true;
}
```

== Проверка простоты многоугольника

Простой многоугольник не пересекает сам себя. Проверяется пересечением всех пар несмежных ребер.

```cpp
bool isSimple(const vector<Point>& p) {
    int n = p.size();
    for (int i = 0; i < n; i++) {
        for (int j = i + 2; j < n; j++) {
            if (i == 0 && j == n - 1) continue; 
            Segment s1 = {p[i], p[(i+1)%n]};
            Segment s2 = {p[j], p[(j+1)%n]};
            if (segmentsIntersect(s1, s2)) return false;
        }
    }
    return true;
}
```

== Точка внутри многоугольника

Ранее мы уже решали задачу о проверке принадлежности точки прямоугольнику. Посмотрим как решается это задача в общем виде.

#align(center, cetz.canvas({
    import cetz.draw: *
    grid((-1,-1), (6,5), step: 1, stroke: gray)
    line((1,1), (4,1), stroke: blue)
    line((4,1), (4,4), stroke: blue)
    line((4,4), (2,2), stroke: blue)
    line((2,2), (0,4), stroke: blue)
    line((0,4), (1,1), stroke: blue)
    content((1,1), $A$, anchor: "north-east")
    content((4,1), $B$, anchor: "north-west")
    content((4,4), $C$, anchor: "south-west")
    content((2,2), $D$, anchor: "north")
    content((0,4), $E$, anchor: "south-east")
    circle((2,3), radius: 0.1, fill: red)
    content((2,3.15), $P_1$, anchor: "south")
    circle((0,1), radius: 0.1, fill: red)
    content((0,1.15), $P_2$, anchor: "south")
    circle((5,2), radius: 0.1, fill: red)
    content((5,2.15), $P_3$, anchor: "south")
    circle((1,2), radius: 0.1, fill: green)
    content((1,2.15), $P_4$, anchor: "south")
    circle((2,1), radius: 0.1, fill: green)
    content((2,1.15), $P_5$, anchor: "south")
}))

== Метод лучей (Ray Casting)

Провести луч из точки вправо, посчитать пересечения с ребрами. Нечетное число -- внутри.
#grid(
  columns: (2fr, 1fr),
  align: horizon,

  align(center, cetz.canvas({
    import cetz.draw: *

    grid((-1,1), (9,9), step: 1, stroke: gray)

    line((2,2), (8,2), stroke: blue)
    line((8,2), (8,8), stroke: blue)
    line((8,8), (4,4), stroke: blue)
    line((4,4), (0,8), stroke: blue)
    line((0,8), (2,2), stroke: blue)

    circle((2,2), radius: 0.05, fill: black)
    content((2,2), $A$, anchor: "north-east")
    circle((8,2), radius: 0.05, fill: black)
    content((8,2), $B$, anchor: "north-west")
    circle((8,8), radius: 0.05, fill: black)
    content((8,8), $C$, anchor: "south-west")
    circle((4,4), radius: 0.05, fill: black)
    content((4,4), $D$, anchor: "north")
    circle((0,8), radius: 0.05, fill: black)
    content((0,8), $E$, anchor: "south-east")

    // Rays
    line((2,7), (9,7), stroke: (paint: red, thickness: 0.1), mark: (end: "triangle", fill: red))
    line((2,5), (9,5), stroke: (paint: green, thickness: 0.1), mark: (end: "triangle", fill: green))
    line((2,4), (9,4), stroke: (paint: green, thickness: 0.1), mark: (end: "triangle", fill: green))
    line((2,3), (9,3), stroke: (paint: green, thickness: 0.1), mark: (end: "triangle", fill: green))

    circle((2,7), radius: 0.1, fill: red)
    content((2,7.3), $P_1$, anchor: "south")
    circle((2,5), radius: 0.1, fill: green)
    content((2,5.3), $P_2$, anchor: "south")
    circle((2,4), radius: 0.1, fill: green)
    content((2,4.3), $P_3$, anchor: "south")
    circle((2,3), radius: 0.1, fill: green)
    content((2,3.3), $P_4$, anchor: "south")

    // Intersection points
    circle((7,7), radius: 0.1, fill: black)
    circle((8,7), radius: 0.1, fill: black)
    circle((3,5), radius: 0.1, fill: black)
    circle((5,5), radius: 0.1, fill: black)
    circle((8,5), radius: 0.1, fill: black)
    circle((8,4), radius: 0.1, fill: black)
    circle((8,3), radius: 0.1, fill: black)
  })),
  remark[

    Следует игнорировать касания в вершинах, либо считать их дважды.
  ]
)

== Код метода лучей (Ray Casting)

```cpp
bool pointInPolygon(const Point& q, const vector<Point>& p) {
    int n = p.size();
    bool inside = false;
    for (int i = 0, j = n - 1; i < n; j = i++) {
        if ((p[i].y > q.y) != (p[j].y > q.y) &&
            (q.x < p[i].x+(p[j].x-p[i].x)*(q.y-p[i].y)/(p[j].y-p[i].y)))
            inside = !inside;
    }
    return inside;
}
```

#remark[

Первое условие $(p[i].y > q.y) != (p[j].y > q.y)$ проверяет, что ребро от $p[j]$ к $p[i]$ пересекает горизонтальную линию на высоте $q.y$ (одна вершина выше, другая ниже).

Второе условие вычисляет $x$-координату точки пересечения ребра с этой горизонтальной линией и проверяет, что она правее $q.x$.

Если оба условия истинны, луч пересекает ребро, и флаг `inside` инвертируется.
]

== Определение намотки (Winding Number)

#definition[

*Намотка (winding number)* точки $q$ относительно замкнутой кривой $gamma$ — это число полных оборотов, которое делает кривая вокруг точки, нормированное на $2pi$.

Математически: $w(q, gamma) = display(1/(2pi)) integral_gamma display(d theta)$, где $d theta$ — дифференциал угла от вектора от $q$ к точке на кривой.

Для многоугольника с вершинами $P_1, ..., P_n$ намотка вычисляется как сумма углов между векторами $arrow(P_i - q)$ и $arrow(P_(i+1) - q)$.
]

== Метод ненулевой намотки (Winding Number)

Посчитать суммарный угол, на который "наматывается" многоугольник вокруг точки.

Если |w| >= 1 -- внутри.

#grid(
  columns: (1fr, 1fr),
  gutter: 1em,
  align: (center, left),

  cetz.canvas({
    import cetz.draw: *

    grid((0,0), (5,5), step: 1, stroke: gray)

    line((1,1), (4,1), stroke: blue)
    line((4,1), (4,4), stroke: blue)
    line((4,4), (2,2), stroke: blue)
    line((2,2), (0,4), stroke: blue)
    line((0,4), (1,1), stroke: blue)

    circle((1,1), radius: 0.05, fill: black)
    content((1,1), $A$, anchor: "north-east")
    circle((4,1), radius: 0.05, fill: black)
    content((4,1), $B$, anchor: "north-west")
    circle((4,4), radius: 0.05, fill: black)
    content((4,4), $C$, anchor: "south-west")
    circle((2,2), radius: 0.05, fill: black)
    content((2,2), $D$, anchor: "north")
    circle((0,4), radius: 0.05, fill: black)
    content((0,4), $E$, anchor: "south-east")

    line((2.5,4.5), (1,1), stroke: red, thickness: 0.5pt)
    line((2.5,4.5), (4,1), stroke: red, thickness: 0.5pt)
    line((2.5,4.5), (4,4), stroke: red, thickness: 0.5pt)
    line((2.5,4.5), (2,2), stroke: red, thickness: 0.5pt)
    line((2.5,4.5), (0,4), stroke: red, thickness: 0.5pt)

    circle((2.5,4.5), radius: 0.1, fill: red)
    content((2.5,4.7), $Q$, anchor: "south")

  }),

  [
    Для точки $Q$ снаружи многоугольника сумма углов $w = theta_1 + theta_2 + ... = 0$.

    Для точки внутри $|w| >= 1$.
  ]
)

==

```cpp
double windingNumber(const Point& q, const vector<Point>& p) {
    double wn = 0;
    int n = p.size();
    for (int i = 0; i < n; i++) {
        Point a = p[i] - q;
        Point b = p[(i + 1) % n] - q;
        double ang1 = angle(Point(0, 0), a);
        double ang2 = angle(Point(0, 0), b);
        double ang = ang2 - ang1;
        while (ang > PI) ang -= 2 * PI;
        while (ang < -PI) ang += 2 * PI;
        wn += ang;
    }
    return wn / (2 * PI);
}
```

== Триангуляция многоугольника

#definition[

*Триангуляция многоугольника* -- это разбиение многоугольника на треугольники путём добавления непересекающихся диагоналей. Любая простой многоугольник на плоскости может быть триангулирована.

Для выпуклого многоугольника триангуляция тривиальна: все диагонали из одной вершины. Для вогнутого требуется более сложный алгоритм, такой как отсечение ушей (ear clipping).
]

#grid(
  columns: (1fr, 1fr),
  gutter: 1em,
  align: center,
  [
    #cetz.canvas({
      import cetz.draw: *
      let points = (
        (0,0), (2,-1), (4,0), (4,2), (2,3), (0,2)
      )
      for i in range(6) {
        let j = calc.rem(i + 1, 6)
        line(points.at(i), points.at(j), stroke: blue)
      }
      for i in range(2, 5) {
        line(points.at(0), points.at(i), stroke: red, thickness: 1.5pt)
      }
      for p in points {
        circle(p, radius: 0.05, fill: black)
      }
    })
  ],
  [
    #cetz.canvas({
      import cetz.draw: *
      let points = (
        (0,0), (1,0), (2,0.5), (1.5,1.5), (2.5,1), (3,2), (2.5,2.5), (3.5,3), (2,3.5), (1,3), (0,2.5)
      )
      for i in range(11) {
        let j = calc.rem(i + 1, 11)
        line(points.at(i), points.at(j), stroke: blue)
      }
      line(points.at(1), points.at(3), stroke: red, thickness: 1.5pt)
      line(points.at(4), points.at(6), stroke: red, thickness: 1.5pt)
      line(points.at(3), points.at(6), stroke: red, thickness: 1.5pt)
      line(points.at(8), points.at(6), stroke: red, thickness: 1.5pt)
      line(points.at(9), points.at(6), stroke: red, thickness: 1.5pt)
      line(points.at(9), points.at(3), stroke: red, thickness: 1.5pt)
      line(points.at(10), points.at(3), stroke: red, thickness: 1.5pt)
      line(points.at(10), points.at(1), stroke: red, thickness: 1.5pt)
      for p in points {
        circle(p, radius: 0.05, fill: black)
      }
    })
  ]
)

== Алгоритм отсечения ушей (Ear Clipping)

*Ухо* -- это вершина $v_i$, для которой треугольник $v_(i-1), v_i, v_(i+1)$ не содержит других вершин многоугольника и диагональ $v_(i-1)v_(i+1)$ лежит внутри многоугольника.

Алгоритм:

1. Построить список вершин.
2. Пока в списке больше 3 вершин:
   - Найти ухо.
   - Добавить диагональ из предыдущей и следующей вершин уха.
   - Удалить ухо из списка.

Работает за $O(n^2)$ в худшем случае, но часто быстрее.

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

#grid(
  columns: (15fr, 1fr, 15fr),
  gutter: 1em,
  align: center+horizon,
  [
    #cetz.canvas({
      import cetz.draw: *
      circle((0,0), radius: 0.05, fill: black)
      content((-0.2,0), $A$, anchor: "east")
      circle((3,0), radius: 0.05, fill: black)
      content((3.2,0), $B$, anchor: "west")
      circle((2.5,1.5), radius: 0.05, fill: black)
      content((2.7,1.5), $C$, anchor: "west")
      circle((1,1), radius: 0.05, fill: black)
      content((0.8,1.2), $D$, anchor: "east")
      circle((0.5,2), radius: 0.05, fill: black)
      content((0.3,2.2), $E$, anchor: "south")
      line((0,0), (3,0), stroke: blue)
      line((3,0), (2.5,1.5), stroke: red)
      line((2.5,1.5), (1,1), stroke: red)
      line((1,1), (0.5,2), stroke: blue)
      line((0.5,2), (0,0), stroke: blue)
    })
  ],
  arrow(),
  [
    #cetz.canvas({
      import cetz.draw: *
      circle((0,0), radius: 0.05, fill: black)
      content((-0.2,0), $A$, anchor: "east")
      circle((3,0), radius: 0.05, fill: black)
      content((3.2,0), $B$, anchor: "west")
      circle((1,1), radius: 0.05, fill: black)
      content((0.8,1.2), $D$, anchor: "east")
      circle((0.5,2), radius: 0.05, fill: black)
      content((0.3,2.2), $E$, anchor: "south")
      line((0,0), (3,0), stroke: blue)
      line((3,0), (1,1), stroke: green)
      line((1,1), (0.5,2), stroke: blue)
      line((0.5,2), (0,0), stroke: blue)
    })
  ]
)

==
#v(-1em)

```cpp
bool pointInTriangle(Point q, Point a, Point b, Point c) {
    double area = fabs(cross(b - a, c - a));
    double area1 = fabs(cross(q - a, b - a));
    double area2 = fabs(cross(q - b, c - b));
    double area3 = fabs(cross(q - c, a - c));
    return fabs(area - (area1 + area2 + area3)) < EPS;
}
```
#remark[

  Для проверки принадлежности здесь считается сумма площадей треугольников образованных точкой и сторонами треугольника. Если точка внутри, то площадь совпадёт с площадью треугольника.

  #grid(
    columns: (1fr, 1fr),
    gutter: 1em,
    align: center,
    [
      #cetz.canvas({
        import cetz.draw: *

        let A = (0, 0)
        let B = (4, 0)
        let C = (2, 3)

        let P_in = (2, 1)

        line(A, B, P_in, close: true, fill: color.mix((purple, 30%), white), stroke: none)
        line(B, C, P_in, close: true, fill: color.mix((blue, 30%), white), stroke: none)
        line(C, A, P_in, close: true, fill: color.mix((green, 30%), white), stroke: none)

        line(P_in, A, stroke: (paint: color.red.lighten(30%), thickness: 1pt))
        line(P_in, B, stroke: (paint: color.red.lighten(30%), thickness: 1pt))
        line(P_in, C, stroke: (paint: color.red.lighten(30%), thickness: 1pt))

        line(A, B, stroke: blue, thickness: 2pt)
        line(B, C, stroke: blue, thickness: 2pt)
        line(C, A, stroke: blue, thickness: 2pt)

        circle(A, radius: 0.05, fill: black)
        content((-0.2, 0), $A$)
        circle(B, radius: 0.05, fill: black)
        content((4.2, 0), $B$)
        circle(C, radius: 0.05, fill: black)
        content((2, 3.3), $C$)

        circle(P_in, radius: 0.05, fill: green)
        content((2.2, 1.2), $P_"in"$)
      })
    ],
    [
      #cetz.canvas({
        import cetz.draw: *

        let A = (0, 0)
        let B = (4, 0)
        let C = (2, 3)

        let P_out = (1, 2)

        line(A, B, P_out, close: true, fill: color.mix((purple, 30%), white), stroke: none)
        line(B, C, P_out, close: true, fill: color.mix((blue, 30%), white), stroke: none)
        line(C, A, P_out, close: true, fill: color.mix((green, 30%), white), stroke: none)

        line(P_out, A, stroke: (paint: color.red.lighten(30%), thickness: 1pt))
        line(P_out, B, stroke: (paint: color.red.lighten(30%), thickness: 1pt))
        line(P_out, C, stroke: (paint: color.red.lighten(30%), thickness: 1pt))

        line(A, B, stroke: blue, thickness: 2pt)
        line(B, C, stroke: blue, thickness: 2pt)
        line(C, A, stroke: blue, thickness: 2pt)

        circle(A, radius: 0.05, fill: black)
        content((-0.2, 0), $A$)
        circle(B, radius: 0.05, fill: black)
        content((4.2, 0), $B$)
        circle(C, radius: 0.05, fill: black)
        content((2, 3.3), $C$)

        circle(P_out, radius: 0.05, fill: red)
        content((1.2, 2.2), $P_"out"$)
      })
    ]
  )
]

==

```cpp
bool isEar(int i, const vector<Point>& p) {
    int n = p.size();
    int prev = (i - 1 + n) % n;
    int next = (i + 1) % n;
    for (int j = 0; j < n; j++) {
        if (j == i || j == prev || j == next) continue;
        if (pointInTriangle(p[j], p[prev], p[i], p[next])) return false;
    }
    return true;
}
```

==
#v(-1em)

#text(size: 0.8em)[
```cpp
vector<pair<int,int>> triangulate(const vector<Point>& poly) {
    int n = poly.size();
    vector<pair<int,int>> diagonals;
    set<int> indices;
    for (int i = 0; i < n; i++) indices.insert(i);
    while (n > 3) {
        bool found = false;
        for (int i = 0; i < n; i++) {
            if (isEar(indices[i], poly)) {
                int prev = (i - 1 + n) % n;
                int next = (i + 1) % n;
                diagonals.push_back({indices[prev], indices[next]});
                indices.erase(indices.begin() + i);
                n--;
                found = true;
                break;
            }
        }
        assert(found);
    }
    return diagonals;
}
```
]
