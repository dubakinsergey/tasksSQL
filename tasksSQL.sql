Схема БД состоит из четырех таблиц:
Product(maker, model, type)
PC(code, model, speed, ram, hd, cd, price)
Laptop(code, model, speed, ram, hd, price, screen)
Printer(code, model, color, type, price)
Таблица Product представляет производителя (maker), номер модели (model) и тип ('PC' - ПК, 'Laptop' - ПК-блокнот или 'Printer' - принтер). Предполагается, что номера моделей в таблице Product уникальны для всех производителей и типов продуктов. В таблице PC для каждого ПК, однозначно определяемого уникальным кодом – code, указаны модель – model (внешний ключ к таблице Product), скорость - speed (процессора в мегагерцах), объем памяти - ram (в мегабайтах), размер диска - hd (в гигабайтах), скорость считывающего устройства - cd (например, '4x') и цена - price (в долларах). Таблица Laptop аналогична таблице РС за исключением того, что вместо скорости CD содержит размер экрана -screen (в дюймах). В таблице Printer для каждой модели принтера указывается, является ли он цветным - color ('y', если цветной), тип принтера - type (лазерный – 'Laser', струйный – 'Jet' или матричный – 'Matrix') и цена - price.

——————————————————————
1.  Найдите номер модели, скорость и размер жесткого диска для всех ПК стоимостью менее 500 дол. Вывести: model, speed и hd

select model, speed, hd
from PC
where price < 500
——————————————————————
2.  Найдите производителей принтеров. Вывести: maker

select distinct maker
from Product
where type = 'Printer'
——————————————————————
3. Найдите номер модели, объем памяти и размеры экранов ПК-блокнотов, цена которых превышает 1000 дол.

select model, ram, screen
from Laptop
where price > 1000
——————————————————————
4.  Найдите все записи таблицы Printer для цветных принтеров.

select *
from Printer
where color = 'y'
——————————————————————
5. Найдите номер модели, скорость и размер жесткого диска ПК, имеющих 12x или 24x CD и цену менее 600 дол.

select model, speed, hd
from PC
where (cd = '12x' OR cd = '24x')
and price < 600
——————————————————————
6.  Для каждого производителя, выпускающего ПК-блокноты c объёмом жесткого диска не менее 10 Гбайт, найти скорости таких ПК-блокнотов. Вывод: производитель, скорость.

select distinct Product.maker, Laptop.speed
from Product
INNER JOIN Laptop ON Product.model = Laptop.model
Where Laptop.hd >= 10
——————————————————————
7. Найдите номера моделей и цены всех имеющихся в продаже продуктов (любого типа) производителя B (латинская буква).

select Product.model, price
from Product
Join PC ON
Product.model = PC.model
where Product.maker = 'B'
UNION
select Product.model, price
from Product
Join Laptop ON
Product.model = Laptop.model
where Product.maker = 'B'
UNION
select Product.model, price
from Product
Join Printer ON
Product.model = Printer.model
where Product.maker = 'B'
——————————————————————
8. Найдите производителя, выпускающего ПК, но не ПК-блокноты.

select Product.maker
from Product
where type = ('PC')
EXCEPT
select Product.maker
from Product
where type = ('Laptop')
——————————————————————
9. Найдите производителей ПК с процессором не менее 450 Мгц. Вывести: Maker

select distinct Product.maker
from Product
JOIN PC ON Product.model = PC.model
where PC.speed >= 450
——————————————————————
10. Найдите модели принтеров, имеющих самую высокую цену. Вывести: model, price

select model, price
from Printer
where price = (select MAX(price) from Printer)
——————————————————————
11. Найдите среднюю скорость ПК.

select AVG(speed)
from PC
——————————————————————
12. Найдите среднюю скорость ПК-блокнотов, цена которых превышает 1000 дол.

select AVG(speed)
from Laptop
where price > 1000
——————————————————————
13. Найдите среднюю скорость ПК, выпущенных производителем A

select AVG(speed)
from PC
JOIN Product ON PC.model = Product.model
WHERE Product.maker = 'A'
——————————————————————
14.  Найдите класс, имя и страну для кораблей из таблицы Ships, имеющих не менее 10 орудий.

select Ships.class, Ships.name, Classes.country
from Ships
Join Classes ON
Ships.class = Classes.class
where numGuns >= 10

——————————————————————
15. Найдите размеры жестких дисков, совпадающих у двух и более PC. Вывести: HD

select hd 
from PC
group by hd
having count(model) >= 2
——————————————————————

16. Найдите модели ПК-блокнотов, скорость которых меньше скорости каждого из ПК.
Вывести: type, model, speed

select distinct Product.type, Product.model, Laptop.speed
from Product
inner join Laptop 
on Laptop.model = Product.model
where speed < all (select speed from PC)

——————————————————————
17. Найдите производителей самых дешевых цветных принтеров. Вывести: maker, price

select distinct Product.maker, Printer.price
from Printer
INNER JOIN Product ON Printer.model = Product.model
where Printer.color = 'y'
and price = (select min(price) from printer where color = 'y')
——————————————————————
18. Для каждого производителя, имеющего модели в таблице Laptop, найдите средний размер экрана выпускаемых им ПК-блокнотов.
Вывести: maker, средний размер экрана

select Product.maker, AVG(screen) AS Avg_screen
from Laptop
inner join Product
ON Laptop.model = Product.model
group by Product.maker
——————————————————————
19. Найдите производителей, выпускающих по меньшей мере три различных модели ПК. Вывести: Maker, число моделей ПК

select maker, count(model)
from Product
where type = 'pc'
group by maker
having count(model) >= 3
——————————————————————
20. Найдите максимальную цену ПК, выпускаемых каждым производителем, у которого есть модели в таблице PC.
Вывести: maker, максимальная цена.

SELECT Product.maker, MAX(PC.price) AS max_price
FROM Product
INNER JOIN PC ON Product.model = PC.model
GROUP BY Product.maker
——————————————————————
21. Для каждого значения скорости ПК, превышающего 600 МГц, определите среднюю цену ПК с такой же скоростью. Вывести: speed, средняя цена.

Select speed, AVG(price) as avg_price
from PC
WHERE speed > 600
GROUP BY speed
——————————————————————
22. Найдите производителей, которые производили бы как ПК
со скоростью не менее 750 МГц, так и ПК-блокноты со скоростью не менее 750 МГц.
Вывести: Maker

select maker
from Product
join PC ON
Product.model = PC.model
where PC.speed >= 750
INTERSECT 
select maker
from Product
join Laptop ON
Product.model = Laptop.model
where laptop.speed >= 750
——————————————————————
23. Перечислите номера моделей любых типов, имеющих самую высокую цену по всей имеющейся в базе данных продукции.

SELECT model
FROM (
 SELECT model, price
 FROM pc
 UNION
 SELECT model, price
 FROM Laptop
 UNION
 SELECT model, price
 FROM Printer
) t1
WHERE price = (
 SELECT MAX(price)
 FROM (
  SELECT price
  FROM pc
  UNION
  SELECT price
  FROM Laptop
  UNION
  SELECT price
  FROM Printer
  ) t2
 )
——————————————————————
24. Найдите среднюю цену ПК и ПК-блокнотов, выпущенных производителем A (латинская буква). Вывести: одна общая средняя цена

SELECT AVG(price) AS AVG_price
FROM (
    SELECT price
    FROM PC
    WHERE model IN (
        SELECT model
        FROM Product
        WHERE maker = 'A'
    )
    UNION ALL
    SELECT price
    FROM Laptop
    WHERE model IN (
        SELECT model
        FROM Product
        WHERE maker = 'A'
    )
) AS subquery
——————————————————————
25. Найдите средний размер диска ПК каждого из тех производителей, которые выпускают и принтеры. Вывести: maker, средний размер HD.

select maker, AVG(hd) AS avg_size_hd
from Product
JOIN PC ON 
Product.model = PC.model
WHERE maker IN
(select maker
from Product
where type = 'Printer')
GROUP BY maker
——————————————————————
26. Используя таблицу Product, определить количество производителей, выпускающих по одной модели.

select COUNT(maker)
from Product
WHERE maker IN
(
select maker
from Product
GROUP BY maker
having COUNT(model) = 1
)
——————————————————————
27. Для классов кораблей, калибр орудий которых не менее 16 дюймов, укажите класс и страну.

select class, country
from Classes
where bore >= 16
——————————————————————
28. Укажите корабли, потопленные в сражениях в Северной Атлантике (North Atlantic). Вывод: ship.

select ship
from Outcomes
where result = 'sunk' AND battle = 'North Atlantic'
——————————————————————
29. В таблице Product найти модели, которые состоят только из цифр или только из латинских букв (A-Z, без учета регистра).
Вывод: номер модели, тип модели.

select model, type
from Product
where model NOT LIKE '%[^0-9]%' OR model NOT LIKE '%[^a-zA-Z]%'
——————————————————————
30. Перечислите названия головных кораблей, имеющихся в базе данных (учесть корабли в Outcomes)

Select name
from ships
where class = name
union
select ship as name
from classes,outcomes
where classes.class = outcomes.ship
——————————————————————
31. Найдите страны, имевшие когда-либо классы обычных боевых кораблей ('bb') и имевшие когда-либо классы крейсеров ('bc').

select country
from Classes
where type = ('bb')
INTERSECT
select country
from Classes
where type = ('bc')
——————————————————————
32. Найти производителей, которые выпускают более одной модели, при этом все выпускаемые производителем модели являются продуктами одного типа.
Вывести: maker, type

select maker, MAX(type)
from Product
group by maker
HAVING COUNT(distinct type) = 1 AND COUNT(model) > 1
——————————————————————
33. Найдите названия кораблей, потопленных в сражениях, и название сражения, в котором они были потоплены.

select Outcomes.ship, Outcomes.battle
from Outcomes 
where result = 'sunk'
——————————————————————
34. Найдите названия всех кораблей в базе данных, начинающихся с буквы R.

select name
from Ships
WHERE name LIKE 'R%'
UNION
select ship
from Outcomes
WHERE ship LIKE 'R%'
——————————————————————
35. Найдите названия всех кораблей в базе данных, состоящие из трех и более слов (например, King George V).
Считать, что слова в названиях разделяются единичными пробелами, и нет концевых пробелов.

select name
from Ships
where name LIKE '% % %'
union
select ship
from Outcomes
where ship LIKE '% % %'
——————————————————————

36. Найдите названия кораблей с орудиями калибра 16 дюймов (учесть корабли из таблицы Outcomes).
select Ships.name
from Ships
join Classes ON Ships.class = Classes.class
where bore = 16
UNION
select ship
from Outcomes
join Classes ON Outcomes.ship = Classes.class
where bore = 16
——————————————————————
37. Найдите сражения, в которых участвовали корабли класса Kongo из таблицы Ships.

select distinct Outcomes.battle
from Outcomes
JOIN Ships ON Outcomes.ship = Ships.name
where Ships.class = 'Kongo'
——————————————————————