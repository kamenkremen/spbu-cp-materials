#import "@preview/pepentation:0.1.0": *

#show: setup-presentation.with(
  title-slide: (
    enable: true,
    title: "Теория графов",
    authors: ("Плотников Даниил Михайлович", ),
    institute: "Санкт-Петербургский государственный университет",
  ),
  footer: (
    enable: true,
    title: "Теория графов",
    institute: "СПбГУ",
    authors: ("Плотников", ),
  ),
  table-of-contents: true,
  header: true,
  locale: "RU"
)


#include "intro.typ"
#include "dfs.typ"
#include "bfs.typ"
