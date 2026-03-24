#import "@preview/pepentation:0.2.0": *
#import "@preview/cetz:0.4.2"
#import "@preview/fletcher:0.5.8" as fletcher: diagram, node, edge

#show: setup-presentation.with(
  title-slide: (
    enable: true,
    title: "Поиск путей в графе",
    subtitle: "Кратчайшие пути",
    authors: ("Плотников Даниил Михайлович", ),
    institute: "Санкт-Петербургский государственный университет",
  ),
  footer: (
    enable: true,
    title: "Поиск путей в графе",
    institute: "СПбГУ",
    authors: ("Плотников", ),
  ),
  table-of-contents: "detailed",
  header: true,
  locale: "RU"
)


#include "recap.typ"
#include "dijkstra.typ"
#include "bellman-ford.typ"
#include "floyd-warshall.typ"

== Сравнение алгоритмов и их применение

#table(
  columns: (auto, auto, auto, auto),
  align: center,
  table.header(
    [*Алгоритм*], [*Время*], [*Отриц. веса*], [*Примечание*]
  ),
  [Дейкстра], [$O((V+E) log V)$], [только $>= 0$], [быстрый, для разреженных графов],
  [Беллман-Форд], [$O(V dot E)$], [да], [универсальный, находит циклы],
  [Флойд-Уоршелл], [$O(V^3)$], [да], [все пары, плотные графы],
)

*Выводы:*
- Неотрицательные веса → Дейкстра.
- Отрицательные веса → Беллман-Форд.
- Все пары → Флойд-Уоршелл.
