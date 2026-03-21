#import "@preview/pepentation:0.1.0": *
#import "@preview/cetz:0.4.2"

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
= Выпуклая оболочка

== Определение

#definition[

*Выпуклая оболочка* множества точек $S$ --- это наименьший выпуклый многоугольник, содержащий все точки из $S$. Другими словами, это пересечение всех выпуклых множеств, содержащих $S$.
]

#definition[
Множество называется *выпуклым*, если вместе с любыми двумя точками содержит и весь отрезок между ними.
]

#align(center, cetz.canvas({
    import cetz.draw: *
    grid((0,0), (6,4), step: 1, stroke: gray)
    // Points
    circle((1,1), radius: 0.05, fill: black)
    circle((2,0.5), radius: 0.05, fill: black)
    circle((3,1), radius: 0.05, fill: black)
    circle((4,0.5), radius: 0.05, fill: black)
    circle((5,2), radius: 0.05, fill: black)
    circle((3,3), radius: 0.05, fill: black)
    circle((1.5,2.5), radius: 0.05, fill: black)
    circle((4.5,3.5), radius: 0.05, fill: black)

    // Convex hull
    line((1,1), (2,0.5), stroke: (paint: blue, thickness: 2pt))
    line((2,0.5), (4,0.5), stroke: (paint: blue, thickness: 2pt))
    line((4,0.5), (5,2), stroke: (paint: blue, thickness: 2pt))
    line((5,2), (4.5,3.5), stroke: (paint: blue, thickness: 2pt))
    line((4.5,3.5), (3,3), stroke: (paint: blue, thickness: 2pt))
    line((3,3), (1.5,2.5), stroke: (paint: blue, thickness: 2pt))
    line((1.5,2.5), (1,1), stroke: (paint: blue, thickness: 2pt))

    content((3,0.2), "Выпуклая оболочка", anchor: "north")
}))

== Свойства выпуклой оболочки

- Выпуклая оболочка всегда выпукла и содержит все исходные точки.
- Вершины оболочки --- это точки из исходного множества.
- Выпуклая оболочка однозначно определена.
- Для $n$ точек в общем положении оболочка имеет $O(n)$ вершин.

== Алгоритм Грэхема

Алгоритм Грэхема строит выпуклую оболочку за $O(n log n)$ времени.

Шаги:
1. Выберем $p_0$ с минимальным y и x.
2. Отсортировать остальные точки по полярному углу относительно $p_0$. Если углы равны, ближе к $p_0$ идут первыми.
3. Итеративно строить оболочку: для каждой точки проверять, не нарушает ли она выпуклость, удаляя предыдущие точки при необходимости.

#[
  #let points = ((0,0), (2,0), (4,0), (3,1),  (1,1),  (2,2), (3,3), (1,3))

  #let draw_hull(hull, conflict) = {

    cetz.canvas({
      import cetz.draw: *
      grid((0,0), (4,4), step: 1, stroke: gray)

      for i in range(hull.len()-2) {
        let side = (hull.at(i), hull.at(i+1))
        line(points.at(side.at(0)), points.at(side.at(1)), stroke: (paint: if side == conflict {red} else {green}, thickness: 2pt))
      }

      line(points.at(hull.at(hull.len()-2)), points.at(hull.last()), stroke: (dash: "dashed", paint: blue, thickness: 2pt))

      for i in range(8) {
        circle(points.at(i), radius: 0.05, fill: black)
      }
    })
  }

  #align(center, grid(
    columns: 3,
    gutter: 2em,
    align: center+horizon,
    cetz.canvas({
      import cetz.draw: *
      grid((0,0), (4,4), step: 1, stroke: gray)
      for i in range(8) {
        circle(points.at(i), radius: 0.05, fill: if i == 0 {red} else {black})
      }
      content((0,-0.2), $p_0$, anchor: "north")
      content((2,-0.2), "1", anchor: "north")
      content((4,-0.2), "2", anchor: "north")
      content((3,1.2), "3", anchor: "south")
      content((1,1.2), "4", anchor: "south")
      content((2,2.2), "5", anchor: "south")
      content((3,3.2), "6", anchor: "south")
      content((1,3.2), "7", anchor: "south")
    }),
    arrow(),
    draw_hull((0, 1, 2, 6, 7, 0, 0), ()),
  ))

  ==
  #align(left, grid(
    columns: 7,
    gutter: 1em,
    align: center+horizon,
    "",
    draw_hull((0, 1 ), ()),
    arrow(),
    draw_hull((0, 1, 2), ()),
    arrow(),
    draw_hull((0, 1, 2, 3, 4), ()),
    arrow(),
    arrow(),
    draw_hull((0, 1, 2, 3, 4), ()),
    arrow(),
    draw_hull((0, 1, 2, 3, 4, 4), ()),
  ))

  ==
  #align(left, grid(
    columns: 7,
    gutter: 1em,
    align: center+horizon,
    "",
    draw_hull((0, 1, 2, 3, 4, 4), ()),
    arrow(),
    draw_hull((0, 1, 2, 3, 4, 5), (3,4) ),
    arrow(),
    draw_hull((0, 1, 2, 3, 5), () ),
    arrow(),
    arrow(),
    draw_hull((0, 1, 2, 3, 5, 6), (3, 5) ),
    arrow(),
    draw_hull((0, 1, 2, 3, 6), (2, 3) ),
    arrow(),
    draw_hull((0, 1, 2, 6, 6), ()),
  ))

  ==
  #align(left, grid(
    columns: 7,
    gutter: 1em,
    align: center+horizon,
    "",
    draw_hull((0, 1, 2, 6, 7), ()),
    arrow(),
    draw_hull((0, 1, 2, 6, 7, 7), ()),
    arrow(),
    draw_hull((0, 1, 2, 6, 7, 0, 0), ()),
  ))
]

=== Выбор $p_0$
```cpp
int findMinIndex(const vector<Point>& pts) {
    int n = pts.size();
    int minIdx = 0;
    for (int i = 1; i < n; i++) {
        if (pts[i].y < pts[minIdx].y || (pts[i].y == pts[minIdx].y && pts[i].x < pts[minIdx].x)) {
            minIdx = i;
        }
    }
    return minIdx;
}
```
 
=== Сортировка

```cpp
void sortByPolarAngle(vector<Point>& pts, const Point& p0) {
    sort(pts.begin() + 1, pts.end(), [&](const Point& a, const Point& b) {
        double ang1 = angle(p0, a);
        double ang2 = angle(p0, b);
        if (fabs(ang1 - ang2) < EPS) return dist(p0, a) < dist(p0, b);
        return ang1 < ang2;
    });
}
```

=== Построение оболочки

```cpp
vector<Point> buildHull(const vector<Point>& pts) {
    vector<Point> hull;
    for (auto& p : pts) {
        while (hull.size() >= 2 && orientation(hull[hull.size()-2], hull.back(), p) != 2) {
            hull.pop_back();
        }
        hull.push_back(p);
    }
    return hull;
}
```

=== Основная функция

```cpp
vector<Point> convexHull(vector<Point> pts) {
    int n = pts.size();
    if (n <= 1) return pts;

    int minIdx = findMinIndex(pts);
    swap(pts[0], pts[minIdx]);

    Point p0 = pts[0];
    sortByPolarAngle(pts, p0);

    return buildHull(pts);
}
```

==
Это не единственный способ нахождения минимальной Выпуклой оболочки, однако самый применяемый в рамках спортивного программирования. Если интересуют другие способы, то можно почитать про:
- #link("https://ru.algorithmica.org/cs/convex-hulls/jarvis/")[Алгоритм Джарвиса (заворачивания подарка)]
- #link("https://wiki.algocode.ru/index.php?title=%D0%90%D0%BB%D0%B3%D0%BE%D1%80%D0%B8%D1%82%D0%BC_%D0%AD%D0%BD%D0%B4%D1%80%D1%8E")[Алгоритм Эндрю] как модификация алгоритма джарвиса. Так же он применяется для триангуляции.
