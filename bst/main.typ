#import "@preview/pepentation:0.2.0": *

#show: setup-presentation.with(
  title-slide: (
    enable: true,
    title: "Двоичные деревья поиска",
    authors: ("Плотников Даниил Михайлович",),
    institute: "Санкт-Петербургский государственный университет",
  ),
  footer: (
    enable: true,
    title: "BST",
    institute: "СПбГУ",
    authors: ("Плотников",),
  ),
  //  theme: themes.theme-azure-breeze,
  table-of-contents: "detailed",
  header: true,
  locale: "RU",
)

#include "bst.typ"
#include "AVL.typ"
