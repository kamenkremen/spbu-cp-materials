#import "@preview/pepentation:0.1.0": *
#import "@preview/cetz:0.4.2"

#show: setup-presentation.with(
  title-slide: (
    enable: true,
    title: "Геометрия",
    authors: ("Плотников Даниил Михайлович", ),
    institute: "Санкт-Петербургский государственный университет",
  ),
  footer: (
    enable: true,
    title: "Геометрия",
    institute: "СПбГУ",
    authors: ("Плотников", ),
  ),
  table-of-contents: true,
  header: false,
  locale: "RU"
)

#show link: set text(fill: blue)
#show link: underline

#include "points_and_vectors.typ"
#include "lines_and_segments.typ"
#include "polygons.typ"
#include "hull.typ"
