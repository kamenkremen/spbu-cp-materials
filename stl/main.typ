#import "@local/pepentation:0.0.1": *
#import "@preview/cetz:0.4.2"
#import "@preview/cetz-plot:0.1.2"

#show: setup_presentation.with(
  title-slide: (
    enable: true,
    title: "Стандратная библиотека шаблонов C++",
    authors: ("Плотников Даниил Михайлович", ),
    institute: "Санкт-Петербургский государственный университет",
  ),
  footer: (
    enable: true,
    title: "STL C++",
    institute: "СПбГУ",
    authors: ("Плотников",),
  ),
  table-of-content: true, // Table of contents is interactive btw. You can click to move to a selected slide
  header: false,
  locale: "RU"
)

#show raw.where(block: false): box.with(
  fill: luma(240),
  inset: (x: 3pt, y: 0pt),
  outset: (y: 3pt),
  radius: 5pt,
)

#let warning(content) = {
  show raw.where(block: false): it => box(
    fill: luma(240).rgb().mix(red),
    inset: (x: 3pt, y: 0pt),
    outset: (y: 3pt),
    radius: 5pt,
    it.text
  )

  box(
    fill: red.transparentize(80%),
    radius: 1em,
    outset: 0.5em,
    text()[#content]
  )
}

#let remark(content) = {
  show raw.where(block: false): it => box(
    fill: luma(240).rgb().mix(orange.lighten(20%)),
    inset: (x: 3pt, y: 0pt),
    outset: (y: 3pt),
    radius: 5pt,
    it.text
  )

  box(
    fill: orange.transparentize(80%),
    radius: 1em,
    outset: 0.5em,
    text()[#content]
  )
}

== Организационные моменты
#show link: set text(fill: blue)
#show link: underline

- Про весь материал сегодняшней лекции можно почитать подробнее на #link("en.cppreference.com")[cppreference].
- Попрактивовать применения структур данных можно на #link("https://acmp.ru/asp/do/index.asp?main=topic&id_course=2&id_section=14&id_topic=12")[acmp]

= Ввод/Вывод

==
#v(-1em)
- С++ имеет высокий уровень обратной совместимости с С. В результате можно использовать как заголовочный файл ```cpp <iostream>```, так и ```cpp <stdio>```.
- При печати выгодно не писать символ по одному, а сразу целый буфер данных.
- Совокупность этих выктов вынуждает `cin` и `cout` синхронизировать буфер с ```c printf()``` и ```cpp scanf()```, что приводит к замедлению работы. Для отключения этого поведения нужно в начале функции ```cpp main()``` написать ```cpp std::sync_with_stdio(0)```.
- Так же входной и выходной буфер имеют определённую синхронизацию. Перед каждым вводом(`cin`) выходной буфер(`cout`) очищается. Это поведение так же можно отключить ```cpp std::cin.tie(0)```. \
 #warning[Не забывайте про это поведение при работе с интерактивными задачами.]
- Вызвать очиску буфера можно вручную ```cpp cout.flush()```/```cpp cin.flush()```
 #warning[Когда вы пишете ```cpp std::endl``` для переноса строки вы так же неявно вызываете очистку буфера. Это может оказаться критичным если в задаче много вывода. Рекомендуется писать ```cpp cout << "\n";```]

= Работа с данными
== Статические массивы
- Для масива фиксированной длины можно использовать стандартную структуру ```cpp int a[n]```, где `n` - переменная, объявленная при помощи ключевого слова ```cpp const```, либо литерал. \
 #remark[Некоторые компиляторы позволяют так создать массив с не известной на этапе компиляции длиной, но это поведение не является стандартом языка.]
- Так же можно создать массив в стиле ооп при помощи структуры ```cpp std::array<int, n> a(value)```, где value - значение которым надо заполнить массив изначально.
- К ```cpp std::array``` можно применять ряд методов:
 - ```cpp a.back()``` - получить последний элемент массива;
 - ```cpp a.front()``` - получить первый элемент массива;
 - ```cpp a.at(idx)``` - получить элемент массива на позвиции `idx` с проверкой на вылезание за границу массива.
 - ```cpp a.size()``` - получить размер массива.

== Динамические массивы
Если же размер массива не известен на этапе компиляции, то можно создать вектор(динаимческий массив): ```cpp vector<int> v(n, value)```.\
К вектору можно применять методы применимые к `std::array`, а так же:
- ```cpp v.push_back(value)``` - добавить значение в конец массива. Асимптотика --- $O(1)$.
- ```cpp v.emplace_back(value)``` - добавить значение в конец массива. В отличии от ```cpp push_back()``` создаёт объект сразу на месте и не вызывает ```cpp move()```. Почти не влияет, но иногда чуть быстрее. Асимптотика --- $O(1)$.
- ```cpp v.insert(pos, value)``` - добавить значение на позицию `pos`. Асимптотика --- $O(n)$.
- ```cpp v.emplace(pos, value)``` - добавить значение на позицию `pos`. Асимптотика --- $O(n)$.
- ```cpp v.pop_back(value)``` - удалить значение в конца массива.
- ```cpp v.erase(pos)``` - удалить значение на позиции `pos`. Асимптотика --- $O(n)$.

== Итераторы
У нас есть 3 способа описать массив с практически одинаквыми интерфейсами взаимодействия. На них можно применять одни и те же алгоритмы при помощи одних и тех же функций, меняя лишь тип данных в аргументах. Но что если нам нужно оперировать разными структурами, но выполнять одну и ту же задачу? Например поиск элемента? Хотелось бы иметь одну и ту же функцию ```cpp find()``` и для массива, и для списка и для дерева.\
 Для этого существую  итераторы. Разберёмся с ними на примере ```cpp int a[n]```. Будет писать итератор подходящий для функции ```cpp find()```.\
Рассмотим как выглядит поиск элемента для класического a[n].

==
#v(-1em)
- Как узнать где находится первый элемент массива? Это адрес массива ```cpp a```.
- Как узнать значение элемента массива? Предположим что за указателем `i` находится элемент массива `a`. Тогда ```cpp *i``` --- значение этого элемента. 
- Как происходит доступ к следующему элементу массива? Предположим что за указателем `i` находится элемент массива `a`. Тогда следующий элемент массива это `i+1`. 
- Как понять что мы дошли до конца массива? Все элементы в массиве хранятся последовательно. Значит следующий за последним элементом массива будет находиться в ячейка с адресом `a+n`.
```cpp
int target; //искомый элемент
//...
for(int* i = a; i < a+n; ++i) {
  if(*i == target){
    return i;
  }
}
```

==
#v(-1em)
Попробуем абстрагироваться от конкретного указателя и представим такой тип данных:
- Мы можем узнать какой итератор соответствует первому элементу структуры при помощи функции ```cpp a.begin()```
- Мы можем получить данные лежашие за итератором вызвав оператор ```cpp *i```
- Мы можем получить следующий итератор при помощи функции ```cpp i.next()```
- Мы можем узнать какой итератор соответствует концу структуры при помощи функции ```cpp a.end()```.
Тогда наша функция будет выглядеть как:
```cpp
for(iterator i = a.begin(); i != a.end(); i = i.next()) {
  if(*i == target){
    return i;
  }
}
```

==
#v(-1em)
Пользуясь уже реализованным классом `std::iterator` из с++ цикл будет выглядеть подобным образом:
```cpp
for (std::vector<int>::iterator it = a.begin(); it != a.end(); ++it)
```
Или же для статического массива:
```cpp
for (std::array<int, 5>::iterator it = a.begin(); it != a.end(); ++it)
```
Написание подобного является очень громоздким. Поэтому в с++ есть синтаксических сахар для класических ForEach циклов.
```cpp
for (int i : a)
```
#remark[Тогда в переменной `i` у нас будет *копия* элемента. Если хотим изменять, то пишем ```cpp int& i```.]

Иногда описание типа тоже является громоздким, тогда пишем:
```cpp
for(auto& el : a)
```

== Заголовочный файл ```cpp <algorithm>```
Существенная часть типовых алгоритмов уже реализованы в стандратной библиотехе шаблонов используя итераторы. Аргументами здесь является отрезок итераторов $[l,r)$ 
- ```cpp find(..., val)```, ```cpp find_if(..., val)```, ```cpp find_if_not(..., val)``` -- найти первое входжеие значения
- ```cpp find_last(..., val)```, ... -- найти последнее вхождение значение
- ```cpp count(..., val)```, ```cpp count_if(..., val)``` --- посчитать количество вхождений значения
- ```cpp fill(..., val)``` -- заполнить значением
- ```cpp reverse(...)``` -- развернуть элементы
- ```cpp max_element(...)``` -- максимальный элемент
- ```cpp min_element(...)``` -- минимальный элемент

==
- ```cpp next_permutation(...)``` -- получить лексикографически следующую перестановку
- ```cpp accumulate(..., init)``` --- посчитать сумму элементов. Начальное значение -- `init`
- ```cpp sort(...)``` --- отсоритровать
- ```cpp lower_bound(..., val)``` --- возвращает итератор первого элемента не меньшего значения в отсортированном массиве за $O(log n)$
- ```cpp upper_bound(..., val)``` --- возвращает итератор первого элемента большего значения в отсортированном массиве за $O(log n)$
- ```cpp binary_search(..., val)``` --- проверяет есть ли элемент со значением `val` в остортированно массиве за $O(log n)$
Так же в этой библиотеке есть пару полезных функций по типу ```cpp max(a, b)```, ```cpp min(a,b)```.

== Передача функций. Лямбды.
Иногда при работе с этими функциями требуется изменить операцию. Например вместо суммы получить произведение всех чисел. Функции для которых это логично принимают так же дополнительный аргумент(который впрочем можно опустить). Разберём этот пример.
```cpp
int multiply(int lhs, int rhs) {
    return lhs*rhs;
}
 
int main(){
    vector<int> v{1, 2, 3, 4, 5, 6, 7, 8, 9, 10};
    int product = std::accumulate(v.begin(), v.end(), 1, multiply);
    cout << "product: " << product << '\n'; //product: 3628800
}
```

==
#v(-1em)
Иногда написание функции далеко от места её вызова может запутать. В таком случае можно использовать лямбда функции. Для этого примера это будет выглядеть так.
```cpp
int main(){
    std::vector<int> v{1, 2, 3, 4, 5, 6, 7, 8, 9, 10};
    int product = std::accumulate(v.begin(), v.end(), 1,
      [](int lhs, int rhs){return lhs*rhs;}
    );
    std::cout << "product: " << product << '\n';
}
```

 О ужас! ```cpp auto a = [](){};``` это реальное выражение из языка с++... Давайте разбираться что это под капотом.

==
#v(-1em)
Пусть структура представляющая лямбда функцию будет хранить данные, к которым она имеет доступ из вне, и саму функцию. Давайте напишем такую структуру для этого примера:
```cpp
int value = 42;
int& ref_to_value = value;

auto lambda = [value, &ref_to_value](int offset) {
  ref_to_value = 100;
  return value + offset; 
};
```
Лямбда хочет получить доступ к переменным `value` и `ref_to_value`, вызвать функцию с агрументом ```cpp int offset``` и телом: 
```cpp
  ref_to_value = 100;
  return value + offset; 
```

==
#v(-1em)

Называется наша выдумка замыканием, и для примера выглядит подобным образом:
```cpp
class __CompilerGeneratedClosureType {
private:
    int m_captured_value; 
    int& m_captured_ref; 

public:
    __CompilerGeneratedClosureType(int value, int& ref_to_value)
        : m_captured_value(value), m_captured_ref(ref_to_value) {
    }

    int operator()(int offset) const {
        m_captured_ref = 100;
        return m_captured_value + offset;
    }
};
```

==
#v(-1em)

И так, резюмирая страшный `[](){}`:
- внутри `[]` располагаются "захваты". Можно задать дефолтное поведение если написать ```cpp [=]```, чтобы захватить все доступные переменные по значению, и ```cpp [&]```, чтобы захватить все значение по ссылке. Если есть исколючения то можно написать ```cpp [&, value]```.
- внутри `()` располагаются аргументы функции.
- внутри `{}` располагается тело функции.
- вызвать такую функцию можно так же как и обычную применив к объекту ```cpp operator()```

==
#v(-1em)
Особенно часто использование таких функций пригождается при сортировке. Изначально функция ```cpp sort()``` сортирует массив по неубыванию, но нам может быть удобно сортировать по невозрастанию. Тогда хочется сделать так:
```cpp
sort(a.begin(), a.end(), 
  [](const auto &lhs, const auto &rhs){return lhs > rhs;}
)
```
#v(2em)
#remark[Писать свою функцию вовсе не обязательно. Для этого есть итераторы обратногo порядка:
```cpp
sort(a.rbegin(), a.rend())
```
Так наша функция будет думать что массив изначально развёрнут и она ставит наименьший элемент на позицию `0`, однака фактически происходит наоборот.]

== `std::pair` и `std::tuple`
#v(-1em)
Множество алгоритмов требуют групировку данных для своей работы. Например, метод сканирующей прямой. Тогда можно написать свою структуру:
```cpp
struct event{
  int moment;
  int type;
}
```
Чтобы использовать функции из заговочного файла ```cpp <algorithm>``` потребуется реализовывать различные методы (например, ```cpp operator<``` для сортировки), или обязаельно передавать функцию (например, аккумулятор для ```cpp accumulate()```). Чтобы этого не делать можно использовать уже реализованные класс `std::pair`.

В нашем примере этот класс будет выглядеть как ```cpp std::pair<int, int>```. Создать объект можно либо через функцию ```cpp std::make_pair(a,b)``` либо через конструктор ```cpp {a,b}```

== 
#v(-1em)
Объявить пару можно следующим образом:
```cpp
std::pair<int, int> p;
p = {1,2};
```
Обратиться к переменным внутри пары можно следующими образам:
```cpp
int f = p.first, s = p.second;
```
либо
```cpp
auto [f, s] = p;
```
Последнее особенно удобно внутри циклов ForEach:
```cpp
std::vector<std::pair<int, int>> v;
//...
for(auto [f,s] : v){
  //...
}
```

==

#v(-1em)
Но что если нам нужно сгрупировать не 2 переменные, а 4? Это будет выглядеть как
```cpp std::pair<int std::pair<int, std::pair<int, int>>>```. Разумеется так делать никто не хочет и не делает. Для такого есть класс ```cpp tuple<int, int, int int>```.

Аналогичная работа с ним:
```cpp
std::tuple<int, int, int, int> t{1, 2, 3, 4};
int fi = std::get<0>(t); 
int se = std::get<1>(t);
int th = std::get<2>(t);
int fo = std::get<3>(t);
auto [first, second, third, fourth] = t;
for(auto [a,b,c,d] : t) {
  //...
}
```

==
#v(-1em)
Для этих классов не реализованны операции по типу суммы, но есть сравнения при помощи загаловочного файла ```cpp <functional>``` и объектов ```cpp std::greater<pair<int,int>>```, ```cpp std::less<...>``` и т.д.

Применение будет выглядеть следующим образом:
```cpp
std::sort(v.begin(), v.end(), std::greater<pair<int,int>>())
```
Для невозрастающей последовательности можно просто опустить аргумент функции.


= Структуры данных

== `std::string`

В языке С строки представляли собой не более чем массив из символов с `'\0'` в конце. Однако это не очень удобно во многом и тяжело унифицировать отностительно других данных. Поэтому в с++ добавили структуру ```cpp std::string```. Для неё реализован объектно ориентированный интерфейс в виде методов:
- Сравнения: `==`, `!=`, `<`, `>`, `<=`, `>=`;
- Конкатенация: `+`, `+=`;
- Поиск и замена: ```cpp .find()```, ```cpp rfind()```, ```cpp replace()```;
- Подстроки: ```cpp substr()```;
- Доступ к элементам: `[]`, ```cpp .at()```, ```cpp .front()```, ```cpp .back()```
- Размер: ```cpp .size()```, ```cpp length()```, ```cpp capacity()```

==
#v(-1em)
Строки реализацию поиска элемента, псокольку мы можем искать не только один символ, но и подстроку, что требует других, более сложных алгоритмов

Обычно поиск выглядит вот так:
```cpp
if(std::find(s.begin(), s.end(), 'a') != s.end()){
  //Ура! Нашли!
}
```
Но для строк так же можно написать:
```cpp
if(s.find('a') != std::string::npos){
  //Ура! Нашли!
}
```

== `std::set` и `std::unordered_set`
`std::set` представляет собой математическое множесто. Под капотом реализовано при помощи красно-чёрного дерева. 

`std::unordered_set` представляет собой математическое множесто. Под капотом реализовано при помощи хэш таблицы.

Как можно заметить, это очень похожие структуры которые отличаются только реализацией под капотом и как результат деталями использования. Сейчас речь пойдёт об общем применении математического множества.

==
#v(-1em)

Пример использования множества:
#grid(
  columns: 2,
  align: (left, right),
  box(width: 100%)[
```cpp
std::set<int> s;
//std::unordered_set<int> s; 
s.insert({1, 2, 7, 2 42, 5, 64});
if(s.find(1) != s.end()){
    std::cout << "hooray!\n";
}
if(s.find(3) == s.end()){
    std::cout << "oh :(\n";
}
s.erase(7);
for(auto el : s){
    std::cout << el << " ";
}
```],
box(width: 100%)[
  #set align(center)
  #align(center)[Вывод для `std::set`]
  #show raw.where(block: true): box.with(
    fill: rgb("#222436"),
    inset: (x: 1em, y: 0pt),
    outset: (y: 1em),
    radius: 5pt,
  )
  #{
    set text(fill:white)
    ```
hooray!
oh :(
1 2 5 42 64 
    ```
    }
    Вывод для `std::unordered_set`
    #{
      set text(fill:white)
      ```
hooray!
oh :(
64 5 42 2 1 
      ```
      }
    ]
)

==
#v(-1em)
#align(center)[
  Сравнение `std::set` и `std::unordered_set` \
  $n$ - мощность множества на момент операции 
#table(
  columns: 5,
  table.cell(rowspan:2)[Операция], table.cell(colspan:2)[Асимптотика в худшем случае], table.cell(colspan:2)[Асимптотика в среднем],
  [~~~~~~std::set~~~~~~], "std::unordered_set", [~~~~~~std::set~~~~~~], "std::unordered_set",
  "Добавление", $O(log n)$, $O(n)$, $O(log n)$, $O(1)$,
  "Удаление", $O(log n)$, $O(n)$, $O(log n)$, $O(1)$,
  "Поиск", $O(log n)$, $O(n)$, $O(log n)$, $O(1)$,
)
]
Помимо разницы в асимтотиках, `std::set` так же выполняет одну дополнительную функцию -- данные в нём упорядочены, в то время как для `std::unordered_set` расположение данных непредсказуемо.

#warning[Использование `std::unordered::set` может привести к неожиданному превышению времени выполнения из-за особенностей хэшей. Во избежании этого стоит пользоваться своим хэшем. Подробнее можно почитать в #link("https://codeforces.com/blog/entry/62393?locale=ru")[блоге на codeforces].]

== 
#v(-1em)
Как `std::set`, так и `std::multiset` при добавлении повторного элемента теряют его. Если это не поведение которые требуется в задаче, то следует использовать `std::multiset` и `std::unordered_multiset`.

#grid(
  columns: 2,
  align: (left, right),
  box(width: 100%)[
```cpp
std::multiset<int> s;
s.insert({1, 1, 2, 2, 5, 5, 64});
for(auto el : s){
    std::cout << el << " ";
}
std::cout << '\n';
s.erase(2);
if(s.find(2) == s.end()){
  std::cout << "oh :(\n";
}
s.extract(5);
for(auto el : s){
    std::cout << el << " ";
}
```],
box(width: 100%)[
  #set align(center + horizon)
  #align(center)[Вывод]
  #show raw.where(block: true): box.with(
    fill: rgb("#222436"),
    inset: (x: 1em, y: 0pt),
    outset: (y: 1em),
    radius: 5pt,
  )
  #{
    set text(fill:white)
    box()[
      ```
1 1 2 2 5 5 64 
oh :(
1 1 5 64 
      ```
    ]
  }
]
)

==
#v(-1em)
Если порядок элементов важен, и при этом он должен отличаться от стандартного, то можно передать компаратор в качестве аргумента шаблона при создании множества:
```cpp
std::set<int, std::less<int>> s;
```

== `std::map` и `std::unordered_map`
Иногда хочется иметь такой массив, в котором индексами будут являться не целые положительные числа, а, например, строки. Для такого используются ассоциативные массивы, словари или же математические отображения. Всё это выполняет роль одной и той же структуры.

В с++ эту функцию выполняют `std::map` и `std::unordered_map`. Отличия в них аналогичны отличиям `std::set` и `std::unordered_set`, так что это сравнение опустим и перейдём к применению. Точно так же сущестуют классы `std::multimap` и `std::unordered_map`, но лично мне всегда удобнее было хранить вектор значений.

Изменение порядка элементов в `std::map` тоже работает аналогичным образом.

==
#v(-1em)

#grid(
  columns: 2,
  align: (left, right),
  box(width: 100%)[
    ```cpp
    map<string, int> m;
    m["three"] = 3;
    m["seven"] = 7;

    for(auto [key, value] : m){
        cout << key << "->" << value << '\n';
    }
    cout << '\n';

    cout << m["three"] << ' ' << m["one"] << '\n';

    string check[2] = {"present", "not present"};
    cout << check[m.find("one") == m.end()] << '\n'
         << check[m.find("two") == m.end()]; 

    ```
  ],
  box()[
    #set align(center + horizon)
    #align(center)[Вывод]
    #show raw.where(block: true): box.with(
      fill: rgb("#222436"),
      inset: (x: 1em, y: 0pt),
      outset: (y: 1em),
      radius: 5pt,
    )
    #{
      set text(fill:white)
      box()[
        ```
        seven->7
        three->3

        3 0
        present
        not present
        ```
      ]
    }
  ]
)

== FIFO и LIFO структуры
Эти классы структуру в с++ представленны в достаточно удобном формате
- LIFO (Last In -- First Out) -- `std::stack`, `std::vector`, `std::deque`
- FIFO (First In -- First Out) -- `std::queue`, `std::deque`
- FIFO с приоритетом -- `std::priority_queue`
Работа с ними выглядит довольно похоже. Разберёмся поочереди.

==
#v(-1em)
*`std::stack`* - класическая реализация стэка. Часто его любят представлять стопкой блинов. Вы можете положить блин наверх, и взять блин сверху. Для того чтобы взять блин из середины, требуется сначала снять все блины выше нашей цели.

#v(2em)

#align(center)[
  #cetz.canvas(length: 1cm, {
    import cetz.draw: *
    
    let stack-color = rgb("#4A90E2")
    let highlight-color = rgb("#E74C3C")
    let text-color = rgb("#2C3E50")
    let flow-color = text-color.lighten(25%)

    translate((0, 0))
    content((1, -1), [*Начальный стэк*], anchor: "north")
    
    rect((0, 0), (2, 1), fill: stack-color.lighten(60%), stroke: stack-color)
    content((1, 0.5), [15])
    
    rect((0, 1), (2, 2), fill: stack-color.lighten(60%), stroke: stack-color)
    content((1, 1.5), [7])
    
    line((-0.6, 1.5), (-0.2, 1.5), stroke: highlight-color, mark: (end: ">"))
    content((-1.6, 1.5), [*Top*], anchor: "west")
    
    translate((5, 0))
    content((1, -1), [*push(42)*], anchor: "north")
    
    rect((0, 0), (2, 1), fill: stack-color.lighten(60%), stroke: stack-color)
    content((1, 0.5), [15])
    
    rect((0, 1), (2, 2), fill: stack-color.lighten(60%), stroke: stack-color)
    content((1, 1.5), [7])
    
    rect((0, 2), (2, 3), fill: highlight-color.lighten(70%), stroke: highlight-color)
    content((1, 2.5), [42])
    
    line((2.6, 2.5), (2.2, 2.5), stroke: highlight-color, mark: (end: ">"))
    content((2.75, 2.5), [*Top*], anchor: "west")
    
    translate((5, 0))
    content((1, -1), [*pop()*], anchor: "north")
    
    rect((0, 0), (2, 1), fill: stack-color.lighten(60%), stroke: stack-color)
    content((1, 0.5), [15])
    
    rect((0, 1), (2, 2), fill: stack-color.lighten(60%), stroke: stack-color)
    content((1, 1.5), [7])
    
    line((2.6, 1.5), (2.2, 1.5), stroke: highlight-color, mark: (end: ">"))
    content((2.75, 1.5), [*Top*], anchor: "west")
    
    rect((0.5, 3), (1.5, 4), fill: highlight-color.lighten(80%), 
         stroke: (paint: highlight-color, dash: "dashed"))
    content((1, 3.5), [42], fill: gray)
    
    line((1, 2.2), (1, 2.8), stroke: highlight-color, mark: (end: ">"), dash: "dotted")

    translate((-12, 0))
    line((4.3, 1.5), (6.7, 1.5), stroke: flow-color, stroke-width: 1.5pt, mark: (end: ">"))
    line((9.3, 1.5), (11.7, 1.5), stroke: flow-color, stroke-width: 1.5pt, mark: (end: ">"))
  })
]

==
#v(-1em)

Как илюстрация с предыдущего слайда будет выглядеть на с++:

#grid(
  columns: 2,
  align: (left, right),
  box(width: 100%)[
    ```cpp
    std::stack<int> s;
    s.push(15);
    s.push(7);
    std::cout << s.top() << '\n';
    s.push(42);
    std::cout << s.top() << '\n';
    s.pop();
    std::cout << s.top() << '\n';
    ```
  ],
  box()[
    #set align(center + horizon)
    #align(center)[Вывод]
    #show raw.where(block: true): box.with(
      fill: rgb("#222436"),
      inset: (x: 1em, y: 0pt),
      outset: (y: 1em),
      radius: 5pt,
    )
    #{
      set text(fill:white)
      box(width: 100%)[
        ```
        7
        42
        7
        ```
      ]
    }
  ]
)
С точки зрения теории наиболее эффективный способ реализовать такую структуру это сипользовать список. Однако как, показывает практика, список почти никогда не является хорошим выбором. Интересные примеры по этому поводу написана Бьёрном Страустоупом(создателем языка с++), это даже упомниается на сайте iso cpp. Можно почитать #link("https://isocpp.org/blog/2014/06/stroustrup-lists")[тут] и посмотреть #link("https://www.youtube.com/watch?v=OB-bdWKwXsU")[тут]. 

==
#v(-1em)
Под капотом это на самом деле ни что иное как `std::vector`. Нужно просто хранить указатель на конец стека отдельно от конца массива. Что на самом деле и так происходит. Что мешает использовать вектор вместо стека? Ничего. 

#grid(
  columns: 2,
  align: (left, right),
  box(width: 100%)[
    ```cpp
    std::vector<int> v;
    v.push_back(15);
    v.push_back(7);
    std::cout << v.back() << '\n';
    v.push_back(42);
    std::cout << v.back() << '\n';
    v.pop_back();
    std::cout << v.back() << '\n';
    ```
  ],
  box()[
    #set align(center + horizon)
    #align(center)[Вывод]
    #show raw.where(block: true): box.with(
      fill: rgb("#222436"),
      inset: (x: 1em, y: 0pt),
      outset: (y: 1em),
      radius: 5pt,
    )
    #{
      set text(fill:white)
      box(width: 100%)[
        ```
        7
        42
        7
        ```
      ]
    }
  ]
)

==
#v(-1em)
*`std::queue`* - класическая реализация очереди. Очередь удобнее всего представлять в виде... Очереди на кассе в магазине. Кто первый пришёл, тот первый и купит товар.

#v(3em)

#align(center)[
  #cetz.canvas(length: 0.9cm, {
    import cetz.draw: *
    
    let queue-color = rgb("#4A90E2")  
    let highlight-color = rgb("#E74C3C")
    let front-color = rgb("#2C3E50")
    let flow-color = front-color.lighten(25%)
    
    translate((0, 0))
    content((2.25, -0.5), [*Начальная очередь*], anchor: "north", size: 11pt)
    
    rect((0, 0), (1.2, 1.2), fill: queue-color.lighten(60%), stroke: queue-color)
    content((0.6, 0.6), [15], size: 11pt)
    
    rect((1.2, 0), (2.4, 1.2), fill: queue-color.lighten(60%), stroke: queue-color)
    content((1.8, 0.6), [7], size: 11pt)
    
    rect((2.4, 0), (3.6, 1.2), fill: queue-color.lighten(60%), stroke: queue-color)
    content((3, 0.6), [23], size: 11pt)
    
    rect((3.6, 0), (4.8, 1.2), fill: queue-color.lighten(60%), stroke: queue-color)
    content((4.2, 0.6), [8], size: 11pt)
    
    // Указатели
    line((0.6, 1.6), (0.6, 1.2), stroke: front-color, mark: (end: ">"), stroke-width: 1.5pt)
    content((0.6, 1.8), [*Start*], anchor: "south", fill: front-color, size: 10pt)
    
    line((4.2, 1.6), (4.2, 1.2), stroke: highlight-color, mark: (end: ">"), stroke-width: 1.5pt)
    content((4.2, 1.8), [*End*], anchor: "south", fill: highlight-color, size: 10pt)
    
    translate((6, 0))
    content((3, -0.5), [*push(42)*], anchor: "north", size: 11pt)
    
    rect((0, 0), (1.2, 1.2), fill: queue-color.lighten(60%), stroke: queue-color)
    content((0.6, 0.6), [15], size: 11pt)
    
    rect((1.2, 0), (2.4, 1.2), fill: queue-color.lighten(60%), stroke: queue-color)
    content((1.8, 0.6), [7], size: 11pt)
    
    rect((2.4, 0), (3.6, 1.2), fill: queue-color.lighten(60%), stroke: queue-color)
    content((3, 0.6), [23], size: 11pt)
    
    rect((3.6, 0), (4.8, 1.2), fill: queue-color.lighten(60%), stroke: queue-color)
    content((4.2, 0.6), [8], size: 11pt)
    
    rect((4.8, 0), (6, 1.2), fill: highlight-color.lighten(70%), stroke: highlight-color, stroke-width: 1.5pt)
    content((5.4, 0.6), [*42*], size: 11pt, weight: "bold")
    
    line((0.6, 1.6), (0.6, 1.2), stroke: front-color, mark: (end: ">"), stroke-width: 1.5pt)
    content((0.6, 1.8), [*Start*], anchor: "south", fill: front-color, size: 10pt)
    
    line((5.4, 1.6), (5.4, 1.2), stroke: highlight-color, mark: (end: ">"), stroke-width: 1.5pt)
    content((5.4, 1.8), [*End*], anchor: "south", fill: highlight-color, size: 10pt)
    
    translate((7, 0))
    content((3, -0.5), [*pop()*], anchor: "north", size: 11pt)
    
    rect((0, 0), (1.2, 1.2), fill: highlight-color.lighten(85%), 
         stroke: (paint: highlight-color, dash: "dashed", thickness: 1.5pt))
    content((0.6, 0.6), [15], fill: gray, size: 11pt)
    
    rect((1.2, 0), (2.4, 1.2), fill: queue-color.lighten(60%), stroke: queue-color)
    content((1.8, 0.6), [7], size: 11pt)
    
    rect((2.4, 0), (3.6, 1.2), fill: queue-color.lighten(60%), stroke: queue-color)
    content((3, 0.6), [23], size: 11pt)
    
    rect((3.6, 0), (4.8, 1.2), fill: queue-color.lighten(60%), stroke: queue-color)
    content((4.2, 0.6), [8], size: 11pt)
    
    rect((4.8, 0), (6, 1.2), fill: queue-color.lighten(60%), stroke: queue-color)
    content((5.4, 0.6), [42], size: 11pt)
    
    line((1.8, 1.6), (1.8, 1.2), stroke: front-color, mark: (end: ">"), stroke-width: 1.5pt)
    content((1.8, 1.8), [*Start*], anchor: "south", fill: front-color, size: 10pt)
    
    line((5.4, 1.6), (5.4, 1.2), stroke: highlight-color, mark: (end: ">"), stroke-width: 1.5pt)
    content((5.4, 1.8), [*End*], anchor: "south", fill: highlight-color, size: 10pt)
    
    translate((-13, 0))
    line((4.9, 0.6), (5.9, 0.6), stroke: flow-color, stroke-width: 1.5pt, mark: (end: ">"))
    line((12.1, 0.6), (12.9, 0.6), stroke: flow-color, stroke-width: 1.5pt, mark: (end: ">"))
  })
]

==
#v(-1em)
Как илюстрация с предыдущего слайда будет выглядеть на с++:

#grid(
  columns: 2,
  align: (left, right),
  box(width: 100%)[
    ```cpp
    std::queue<int> q;
    q.push(15); q.push(7);
    q.push(23); q.push(8);

    std::cout << q.front() << " < > "
              << q.back() << '\n';
    q.push(42);
    std::cout << q.front() << " < > " 
              << q.back() << '\n';
    q.pop();
    std::cout << q.front() << " < > "
              << q.back() << '\n';
    ```
  ],
  box()[
    #set align(center + horizon)
    #align(center)[Вывод]
    #show raw.where(block: true): box.with(
      fill: rgb("#222436"),
      inset: (x: 1em, y: 0pt),
      outset: (y: 1em),
      radius: 5pt,
    )
    #{
      set text(fill:white)
      box(width: 100%)[
        ```
        15 < > 8
        15 < > 42
        7 < > 42
        ```
      ]
    }
  ]
)

Ну может здесь нам удобно будет применить список? Нет, это тоже `std::vector`. Только здесь нужна небольшая обёртка в виде колцевого буфера, так что просто использовать вектор не так удобно. 

==
#v(-1em)
*`std::dequeue`* - класическая реализация двусторонней очереди. Это обычная очередь, но мы можем ивлекать элементы не только сверху, но и справа.

#align(center)[
  #cetz.canvas(length: 0.9cm, {
    import cetz.draw: *

    let queue-color = rgb("#4A90E2")
    let highlight-color = rgb("#E74C3C")
    let front-color = rgb("#2C3E50")
    let flow-color = front-color.lighten(25%)

    let top_y = 1.9
    let bot_y = -1.9

    translate((0, 0))
    content((2.4, 1.5), [*Начальный deque*], anchor: "south", size: 11pt)
    rect((0, 0), (1.2, 1.2), fill: queue-color.lighten(60%), stroke: queue-color)
    content((0.6, 0.6), [15], size: 11pt)
    rect((1.2, 0), (2.4, 1.2), fill: queue-color.lighten(60%), stroke: queue-color)
    content((1.8, 0.6), [7], size: 11pt)
    rect((2.4, 0), (3.6, 1.2), fill: queue-color.lighten(60%), stroke: queue-color)
    content((3, 0.6), [23], size: 11pt)
    rect((3.6, 0), (4.8, 1.2), fill: queue-color.lighten(60%), stroke: queue-color)
    content((4.2, 0.6), [8], size: 11pt)
    line((0.6, -0.35), (0.6, 0), stroke: front-color, mark: (end: ">"), stroke-width: 1.5pt)
    content((0.6, -0.8), [*Start*], anchor: "north", fill: front-color, size: 10pt)
    line((4.2, -0.35), (4.2, 0), stroke: highlight-color, mark: (end: ">"), stroke-width: 1.5pt)
    content((4.2, -0.8), [*End*], anchor: "north", fill: highlight-color, size: 10pt)
    translate((7, top_y))
    content((3, 1.65), [*push_front(99)*], anchor: "south", size: 11pt)
    rect((0, 0), (1.2, 1.2), fill: highlight-color.lighten(70%), stroke: highlight-color, stroke-width: 1.5pt)
    content((0.6, 0.6), [*99*], size: 11pt, weight: "bold")
    rect((1.2, 0), (2.4, 1.2), fill: queue-color.lighten(60%), stroke: queue-color)
    content((1.8, 0.6), [15], size: 11pt)
    rect((2.4, 0), (3.6, 1.2), fill: queue-color.lighten(60%), stroke: queue-color)
    content((3, 0.6), [7], size: 11pt)
    rect((3.6, 0), (4.8, 1.2), fill: queue-color.lighten(60%), stroke: queue-color)
    content((4.2, 0.6), [23], size: 11pt)
    rect((4.8, 0), (6, 1.2), fill: queue-color.lighten(60%), stroke: queue-color)
    content((5.4, 0.6), [8], size: 11pt)
    line((0.6, -0.35), (0.6, 0), stroke: front-color, mark: (end: ">"), stroke-width: 1.5pt)
    content((0.6, -0.65), [*Start*], anchor: "north", fill: front-color, size: 10pt)
    line((5.4, -0.35), (5.4, 0), stroke: highlight-color, mark: (end: ">"), stroke-width: 1.5pt)
    content((5.4, -0.65), [*End*], anchor: "north", fill: highlight-color, size: 10pt)
    translate((7, 0))
    content((3, 1.65), [*pop_back()*], anchor: "south", size: 11pt)
    rect((0, 0), (1.2, 1.2), fill: queue-color.lighten(60%), stroke: queue-color)
    content((0.6, 0.6), [99], size: 11pt)
    rect((1.2, 0), (2.4, 1.2), fill: queue-color.lighten(60%), stroke: queue-color)
    content((1.8, 0.6), [15], size: 11pt)
    rect((2.4, 0), (3.6, 1.2), fill: queue-color.lighten(60%), stroke: queue-color)
    content((3, 0.6), [7], size: 11pt)
    rect((3.6, 0), (4.8, 1.2), fill: queue-color.lighten(60%), stroke: queue-color)
    content((4.2, 0.6), [23], size: 11pt)
    rect((4.8, 0), (6, 1.2), fill: highlight-color.lighten(85%),
         stroke: (paint: highlight-color, dash: "dashed", thickness: 1.5pt))
    content((5.4, 0.6), [8], fill: gray, size: 11pt)
    line((0.6, -0.35), (0.6, 0), stroke: front-color, mark: (end: ">"), stroke-width: 1.5pt)
    content((0.6, -0.65), [*Start*], anchor: "north", fill: front-color, size: 10pt)
    line((4.2, -0.35), (4.2, 0), stroke: highlight-color, mark: (end: ">"), stroke-width: 1.5pt)
    content((4.2, -0.65), [*End*], anchor: "north", fill: highlight-color, size: 10pt)
    translate((-7, bot_y - top_y)) // перейти к (7, bot_y)
    content((3, -0.85), [*push_back(42)*], anchor: "north", size: 11pt)
    rect((0, 0), (1.2, 1.2), fill: queue-color.lighten(60%), stroke: queue-color)
    content((0.6, 0.6), [15], size: 11pt)
    rect((1.2, 0), (2.4, 1.2), fill: queue-color.lighten(60%), stroke: queue-color)
    content((1.8, 0.6), [7], size: 11pt)
    rect((2.4, 0), (3.6, 1.2), fill: queue-color.lighten(60%), stroke: queue-color)
    content((3, 0.6), [23], size: 11pt)
    rect((3.6, 0), (4.8, 1.2), fill: queue-color.lighten(60%), stroke: queue-color)
    content((4.2, 0.6), [8], size: 11pt)
    rect((4.8, 0), (6, 1.2), fill: highlight-color.lighten(70%), stroke: highlight-color, stroke-width: 1.5pt)
    content((5.4, 0.6), [*42*], size: 11pt, weight: "bold")
    line((0.6, 1.45), (0.6, 1.2), stroke: front-color, mark: (end: ">"), stroke-width: 1.5pt)
    content((0.6, 1.7), [*Start*], anchor: "south", fill: front-color, size: 10pt)
    line((5.4, 1.45), (5.4, 1.2), stroke: highlight-color, mark: (end: ">"), stroke-width: 1.5pt)
    content((5.4, 1.7), [*End*], anchor: "south", fill: highlight-color, size: 10pt)
    translate((7, 0))
    content((3, -0.85), [*pop_front()*], anchor: "north", size: 11pt)
    rect((0, 0), (1.2, 1.2), fill: highlight-color.lighten(85%),
         stroke: (paint: highlight-color, dash: "dashed", thickness: 1.5pt))
    content((0.6, 0.6), [15], fill: gray, size: 11pt)
    rect((1.2, 0), (2.4, 1.2), fill: queue-color.lighten(60%), stroke: queue-color)
    content((1.8, 0.6), [7], size: 11pt)
    rect((2.4, 0), (3.6, 1.2), fill: queue-color.lighten(60%), stroke: queue-color)
    content((3, 0.6), [23], size: 11pt)
    rect((3.6, 0), (4.8, 1.2), fill: queue-color.lighten(60%), stroke: queue-color)
    content((4.2, 0.6), [8], size: 11pt)
    rect((4.8, 0), (6, 1.2), fill: queue-color.lighten(60%), stroke: queue-color)
    content((5.4, 0.6), [42], size: 11pt)
    line((1.8, 1.45), (1.8, 1.2), stroke: front-color, mark: (end: ">"), stroke-width: 1.5pt)
    content((1.8, 1.7), [*Start*], anchor: "south", fill: front-color, size: 10pt)
    line((5.4, 1.45), (5.4, 1.2), stroke: highlight-color, mark: (end: ">"), stroke-width: 1.5pt)
    content((5.4, 1.7), [*End*], anchor: "south", fill: highlight-color, size: 10pt)
    translate((-14, -bot_y)) 
    line((4.9, 0.6), (6.8, top_y + 0.6), stroke: flow-color, stroke-width: 1.5pt, mark: (end: ">"))
    line((13.1, top_y + 0.6), (13.95, top_y + 0.6), stroke: flow-color, stroke-width: 1.5pt, mark: (end: ">"))
    line((4.9, 0.6), (6.8, bot_y + 0.6), stroke: flow-color, stroke-width: 1.5pt, mark: (end: ">"))
    line((13.1, bot_y + 0.6), (13.95, bot_y + 0.6), stroke: flow-color, stroke-width: 1.5pt, mark: (end: ">"))
  })
]
Код выглядит аналогично очереди, так что его опустим.

==
#v(-1em)
*`std::priority_queue`* -- приоритетная очередь. Это очередь в которой сначала обслуживается самый важный клиент. Под капотом представляет из себя max_heap. Значит что добавление и удаление работают за $O(log n)$, а посмотреть наибольший элемент за $O(1)$. Данные не обязательно будут отсортированы на каждом шаге, но наибольший элемент всегда в начале.

#v(2em)
#align(center)[
  #cetz.canvas(length: 0.9cm, {
    import cetz.draw: *

    let queue-color = rgb("#4A90E2")
    let highlight-color = rgb("#E74C3C")
    let front-color = rgb("#2C3E50")
    let flow-color = front-color.lighten(25%)
    let top-color = highlight-color

    translate((0, 0))
    content((2.5, -1), [*Начальная priority_queue*], anchor: "south", size: 11pt)
    rect((0, 0), (1.2, 1.2), fill: queue-color.lighten(60%), stroke: queue-color)
    content((0.6, 0.6), [23], size: 11pt)
    rect((1.2, 0), (2.4, 1.2), fill: queue-color.lighten(60%), stroke: queue-color)
    content((1.8, 0.6), [8], size: 11pt)
    rect((2.4, 0), (3.6, 1.2), fill: queue-color.lighten(60%), stroke: queue-color)
    content((3.0, 0.6), [15], size: 11pt)
    rect((3.6, 0), (4.8, 1.2), fill: queue-color.lighten(60%), stroke: queue-color)
    content((4.2, 0.6), [7], size: 11pt)
    line((0.6, 1.45), (0.6, 1.2), stroke: top-color, mark: (end: ">"), stroke-width: 1.5pt)
    content((0.6, 1.7), [*Top*], anchor: "south", fill: top-color, size: 10pt)
    translate((7, 0))
    content((3.0, -1), [*push(42)*], anchor: "south", size: 11pt)
    rect((0, 0), (1.2, 1.2), fill: highlight-color.lighten(70%), stroke: highlight-color, stroke-width: 1.5pt)
    content((0.6, 0.6), [*42*], size: 11pt, weight: "bold")
    rect((1.2, 0), (2.4, 1.2), fill: queue-color.lighten(60%), stroke: queue-color)
    content((1.8, 0.6), [23], size: 11pt)
    rect((2.4, 0), (3.6, 1.2), fill: queue-color.lighten(60%), stroke: queue-color)
    content((3.0, 0.6), [15], size: 11pt)
    rect((3.6, 0), (4.8, 1.2), fill: queue-color.lighten(60%), stroke: queue-color)
    content((4.2, 0.6), [7], size: 11pt)
    rect((4.8, 0), (6.0, 1.2), fill: queue-color.lighten(60%), stroke: queue-color)
    content((5.4, 0.6), [8], size: 11pt)
    line((0.6, 1.45), (0.6, 1.2), stroke: top-color, mark: (end: ">"), stroke-width: 1.5pt)
    content((0.6, 1.7), [*Top*], anchor: "south", fill: top-color, size: 10pt)
    translate((7, 0))
    content((3.0, -1), [*pop()*], anchor: "south", size: 11pt)
    rect((0, 0), (1.2, 1.2), fill: queue-color.lighten(60%), stroke: queue-color)
    content((0.6, 0.6), [23], size: 11pt)
    rect((1.2, 0), (2.4, 1.2), fill: queue-color.lighten(60%), stroke: queue-color)
    content((1.8, 0.6), [15], size: 11pt)
    rect((2.4, 0), (3.6, 1.2), fill: queue-color.lighten(60%), stroke: queue-color)
    content((3.0, 0.6), [7], size: 11pt)
    rect((3.6, 0), (4.8, 1.2), fill: queue-color.lighten(60%), stroke: queue-color)
    content((4.2, 0.6), [8], size: 11pt)
    line((0.6, 1.45), (0.6, 1.2), stroke: top-color, mark: (end: ">"), stroke-width: 1.5pt)
    content((0.6, 1.7), [*Top*], anchor: "south", fill: top-color, size: 10pt)
    translate((-14, 0))
    line((4.9, 0.6), (6.9, 0.6), stroke: flow-color, stroke-width: 1.5pt, mark: (end: ">"))
    line((13.1, 0.6), (13.9, 0.6), stroke: flow-color, stroke-width: 1.5pt, mark: (end: ">"))
  })
]

==
#v(-1em)
Как илюстрация с предыдущего слайда будет выглядеть на с++:

#grid(
  columns: 2,
  align: (left, right),
  box(width: 100%)[
    ```cpp
    std::priority_queue<int> s;
    s.push(23); s.push(8);
    s.push(15); s.push(7);
    std::cout << s.top() << '\n';
    s.push(42);
    std::cout << s.top() << '\n';
    s.pop();
    std::cout << s.top() << '\n';

    ```
  ],
  box()[
    #set align(center + horizon)
    #align(center)[Вывод]
    #show raw.where(block: true): box.with(
      fill: rgb("#222436"),
      inset: (x: 1em, y: 0pt),
      outset: (y: 1em),
      radius: 5pt,
    )
    #{
      set text(fill:white)
      box(width: 100%)[
        ```
        23
        42
        23
        ```
      ]
    }
  ]
)

== `std::bitset`
`std::bitset` представляет собой последовательность из битов фиксированой длины. К битам можно применять обычные логические и побитовые операции.

#grid(
  columns: 2,
  align: (left, right),
  box(width: 100%)[
    ```cpp
    std::bitset<4> b1{0xA};
    std::cout << b1 << "\n";
    b1 |= 0b0100; assert(b1 == 0b1110);
    b1 &= 0b0011; assert(b1 == 0b0010);
    b1 ^= std::bitset<4>{0b0110};
    std::cout << b1 << "\n";
    b1.reset(); assert(b1 == 0);
    b1.set(); 
    assert(b1.all() && b1.any() && !b1.none());
    b1.flip(3);
    b1[0] = false;
    std::cout << b1 << "\n";
    ```
  ],
  box(width: 40%)[
    #set align(center + horizon)
    #show raw.where(block: true): box.with(
      fill: rgb("#222436"),
      inset: (x: 1em, y: 0pt),
      outset: (y: 1em),
      radius: 5pt,
    )
    Вывод
    #v(0em)
    #{
      set text(fill:white)
      box()[
        ```
        1010
        0100
        0111
        0110
        ```
      ]
    }
  ]
)

= Прочее
#v(-1em)
Если требуется создать свою кучу, то можно это можно сделать на основе `std::vector` при помощи ряда функций из ```cpp <algorithm>```, о которых я умолчал ранее:
- ```cpp make_heap(begin, end)``` -- создать кучу на отрезке $["begin", "end")$
- ```cpp push_heap(value)``` -- добавить элемент сохранив свойства кучи;
- ```cpp pop_heap()``` -- удалить элемент сохранив свойства кучи;
- ```cpp sort_heap(begin, end)``` -- отсортировать элементы кучи. Работает чуть лучше обычной сортировки, но работает только на кучах;
- ```cpp is_heap(begin, end)``` -- проверить является ли отрезок кучей;
- ```cpp is_heap_until(begin, end)``` -- возвращает последний итератор на котором всё ещё выполняются свойста кучию
Чаще всего когда нужна куча используются `std::priority_queue`, либо `std::set`

==
#v(-1em)

Препроцессор с++ позволяет написать небольшие макросы для удобства написания кода. Ниже пару примеров из моего шаблона. Он использует не только препроцессор, но и другие возможности языка.

#table(
  columns: 2,
  "Макрос", "Пример использования",
  ```cpp #define all(x) x.begin(), x.end()```, ```cpp sort(all(v))```,
  ```cpp#define YES cout << "YES\n"```, ```cpp if(flag) YES; ```,
  ```cpp typedef long long ll```, ```cpp ll counter = 0;```
)

#warning[Можно написать ```cpp #define int long long``` чтобы никогда не задумывать о переполнении, но это может привести к неожиданному певышению ограничения по памяти или ошибкам при работе с побитовым представлением]

==
#v(-1em)
#warning[Всё что описано далее следует использовать только после дополнительного предварительного изучения поведения.]
- `std::_Rb_tree` -- голая реализация красно чёрного дерева
- `std::_Hashtable` -- голая реализация хэш-таблицы
- Флаги компиляции которые могут ускорить выполнение програмы, при этом не требует изменение параметров запуска команды g++:
 - ```cpp #pragma GCC optimize("Ofast,no-stack-protector,unroll-loops,fast-math")```
 - ```cpp #pragma GCC target("avx,avx2,sse,sse2,sse3,sse3,sse4.1,sse4.2")```
 - ```cpp #pragma GCC target("popcnt,abm,mmx,tune=native")```
- `__int128` -- целое число которое хранится в 128 битах
