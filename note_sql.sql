-- Patterns

-- Напишите запрос, который возвращает САМЫЙ ДОРОГОЙ ПРОДУКТ В КАЖДОЙ КАТЕГОРИИ.
with d_rank as (
select
	c.category_name,
	p.product_name,
	p.unit_price ,
	dense_rank() over(partition by p.category_id order by p.unit_price DESC) as dns_rank
from
	products p
join
	categories c
	on p.category_id = c.category_id
	)
select
	category_name,
	product_name,
	unit_price
from
	d_rank
where
	dns_rank = 1
order by
	unit_price DESC




-- postgres admin

-- Таблица employees
id	name	department_id	salary	hire_date
1	Alice	1	            5000	2020-01-15
2	Bob	    2	            6000	2019-03-10
3	Charlie	3	            5500	2021-06-20
4	David	1	            5200	2018-07-30
5	Eva	    2	            6500	2022-01-25

-- Таблица departments
id	name
1	Sales
2	IT
3	HR
4	Marketing

1. SELECT
Выборка данных из таблицы.

-- PostgreSQL и MySQL
SELECT * FROM employees;
SELECT name, salary FROM employees WHERE department_id = 2;

2. WHERE
Условия для фильтрации записей.

-- PostgreSQL и MySQL
SELECT * FROM employees WHERE salary > 5500;
SELECT * FROM employees WHERE hire_date > '2020-01-01';

3. ORDER BY
Сортировка результатов по указанным полям.

-- PostgreSQL и MySQL
SELECT * FROM employees ORDER BY salary DESC;
SELECT name, hire_date FROM employees ORDER BY hire_date ASC;

4. LIMIT
Ограничение на количество возвращаемых строк.

-- PostgreSQL и MySQL
SELECT * FROM employees LIMIT 3;
SELECT name, salary FROM employees WHERE department_id = 1 LIMIT 1;

5. GROUP BY
Группировка строк и агрегирование данных.

-- PostgreSQL и MySQL
SELECT department_id, AVG(salary) FROM employees GROUP BY department_id;
SELECT department_id, COUNT(*) FROM employees GROUP BY department_id;

6. HAVING
Фильтрация агрегированных данных.

-- PostgreSQL и MySQL
SELECT department_id, AVG(salary) FROM employees GROUP BY department_id HAVING AVG(salary) > 5500;
SELECT department_id, COUNT(*) FROM employees GROUP BY department_id HAVING COUNT(*) > 1;

7. JOIN
Соединение таблиц для получения данных из нескольких источников.

-- INNER JOIN для выборки сотрудников с их департаментами
SELECT employees.name, departments.name AS dept_name
FROM employees
INNER JOIN departments ON employees.department_id = departments.id;

-- LEFT JOIN для выбора всех сотрудников и департаментов (даже если у департамента нет сотрудников)
SELECT employees.name, departments.name AS dept_name
FROM employees
LEFT JOIN departments ON employees.department_id = departments.id;

8. UNION
Объединение данных из двух запросов.

-- PostgreSQL и MySQL
SELECT name FROM employees WHERE department_id = 1
UNION
SELECT name FROM employees WHERE department_id = 2;

9. INSERT
Вставка новых записей.

-- PostgreSQL и MySQL
INSERT INTO employees (name, department_id, salary, hire_date)
VALUES ('Frank', 4, 7000, '2023-01-15');

10. UPDATE
Обновление существующих данных.

-- PostgreSQL и MySQL
UPDATE employees SET salary = salary + 500 WHERE department_id = 1;
UPDATE employees SET department_id = 4 WHERE id = 3;

11. DELETE
Удаление записей из таблицы.

-- PostgreSQL и MySQL
DELETE FROM employees WHERE salary < 5500;
DELETE FROM employees WHERE department_id = 3;

12. COUNT
Подсчет количества строк, удовлетворяющих условиям.

-- PostgreSQL и MySQL
SELECT COUNT(*) FROM employees;
SELECT COUNT(*) FROM employees WHERE department_id = 2;

13. AVG
Вычисление среднего значения для числового поля.

-- PostgreSQL и MySQL
SELECT AVG(salary) FROM employees;
SELECT department_id, AVG(salary) FROM employees GROUP BY department_id;

14. MAX и MIN
Нахождение максимального и минимального значений.

-- PostgreSQL и MySQL
SELECT MAX(salary) FROM employees;
SELECT MIN(salary) FROM employees WHERE department_id = 1;

15. DISTINCT
Удаление дубликатов из результатов выборки.

-- PostgreSQL и MySQL
SELECT DISTINCT department_id FROM employees;
SELECT DISTINCT department_id, COUNT(*) FROM employees GROUP BY department_id;

16. LIKE, REGEXP
мы хотим найти всех пользователей, чья почта лежит в домене второго уровня «hotmail».
-- PostgreSQL и MySQL
SELECT name, email FROM Users
WHERE email LIKE '%@hotmail.%'

Получим всех пользователей, чьи имена начинаются на «John»:
SELECT * FROM Users WHERE name REGEXP '^John'

Выведем все школьные предметы, название которых оканчивается на букву «e» или «y»:
SELECT * FROM  Subject WHERE name REGEXP '[ey]$'

Найдём всех пользователей, чей адрес электронной почты oканчивается на «@outlook.com» или на «@icloud.com»:
SELECT * FROM Users WHERE email REGEXP '@(outlook.com|icloud.com)$'

Найдём всех пользователей, чей номер телефона не содержит цифр «2» и «8»
SELECT * FROM Users WHERE phone_number REGEXP '^[^28]*$'

Найдём всех пользователей, чей номер телефона начинается на «+7»
SELECT name, phone_number FROM Users WHERE phone_number REGEXP '^\\+7'

17. COALESCE
is null то 0 если нет то оставляем значение
COALESCE(COUNT(p.passenger), 0) AS count
аналог case
CASE
    WHEN COUNT(p.passenger) IS NULL THEN 0
    ELSE COUNT(p.passenger)
END AS count

18. IN и COMMON TABLE EXPRASSION CTE (подзапрос)
SELECT * FROM Users WHERE id IN # тело подзапроса #(
    SELECT DISTINCT owner_id FROM Rooms WHERE price >= 150
) # body CTE #

19. узнать сколько лет по дате
--- MYSQL
SELECT TIMESTAMPDIFF(YEAR, '2003-07-03 14:10:26', NOW());
-- format string
SELECT  CAST("2022-06-16 16:37:23" AS DATETIME) AS datetime_1,
        CAST("2014/02/22 16*37*22" AS DATETIME) AS datetime_2,
        CAST("20220616163723" AS DATETIME) AS datetime_3,
        CAST("2021-02-12" AS DATE) AS date_1,
        CAST("160:23:13" AS TIME) AS time_1,
        CAST("89" AS YEAR) AS year

---POSTGRES
SELECT DATE_PART('year', NOW()) - DATE_PART('year', TIMESTAMP '2003-07-03 14:10:26');
SELECT EXTRACT(YEAR FROM AGE(NOW(), TIMESTAMP '2003-07-03 14:10:26'));
-- format string
SELECT
    '2022-06-16 16:37:23'::TIMESTAMP AS datetime_1,
    NULLIF('2014/02/22 16*37*22', '')::TIMESTAMP AS datetime_2, -- Некорректная строка, для примера результат будет NULL
    TO_TIMESTAMP('20220616163723', 'YYYYMMDDHH24MISS') AS datetime_3,
    '2021-02-12'::DATE AS date_1,
    '160:23:13'::TIME AS time_1,
    '89'::YEAR AS year -- Год в виде двух символов, PostgreSQL преобразует в полный год.


-- type data
CREATE TABLE users (
    user_id INT PRIMARY KEY,
    username VARCHAR(50),
    email VARCHAR(100) UNIQUE,
    birth_date DATE,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    is_active BOOLEAN DEFAULT TRUE
);

-- group by
-- В части SELECT необходимо указывать поля, которые указываются в GROUP BY,
-- или агрегирующие функции(SUM(), MAX(),MIN(),AVG(), COUNT()), например:
SELECT user_id, event_date, SUM(revenue)
FROM game_events
GROUP BY user_id, event_date


-- auto increment
CREATE TABLE employee (
   employ_id SERIAL PRIMARY KEY,
   fname VARCHAR(30),
   lname VARCHAR(30)
);

-- show table
desc person;

-- add values
insert into person
	(person_id, fname, lname, gender, birth_date)
	values (null, 'William', 'Turner', 'M', '1972-05-27');

-- show select values
select person_id, fname, lname, birth_date
	from person
	where person_id = 1;

-- update
UPDATE person
	SET adress = '1225 Tremont St.',
		city = 'Boston',
		state = 'MA',
		country = 'USA',
		postal_code = '02138'
	WHERE person_id = 1;

-- uniq values
SELECT DISTINCT event_name
FROM game_events

-- delete
delete from person
	where person_id = 2;


### Создание базы данных

MySQL:
CREATE DATABASE db_name;
PostgreSQL:
CREATE DATABASE db_name;
### Удаление базы данных

MySQL:
DROP DATABASE db_name;
PostgreSQL:
DROP DATABASE db_name;
### Выбор базы данных

MySQL:
USE db_name;
PostgreSQL: (в PostgreSQL нет аналогичной команды, подключение к базе осуществляется через команду \c)
\c db_name
### Показать все базы данных

MySQL:
SHOW DATABASES;
PostgreSQL:
\l
### Создать таблицу

MySQL:
CREATE TABLE table_name (
    column1 datatype,
    column2 datatype,
    ...
);
PostgreSQL:
CREATE TABLE table_name (
    column1 datatype,
    column2 datatype,
    ...
);

### Просмотр таблицы

MySQL:
desc person;
PostgreSQL:
select * from person;

### Вставка записи

MySQL:
INSERT INTO table_name (column1, column2, ...)
VALUES (value1, value2, ...);
PostgreSQL:
INSERT INTO table_name (column1, column2, ...)
VALUES (value1, value2, ...);
### Обновление записи

MySQL:
UPDATE table_name
SET column1 = new_value1, column2 = new_value2, ...
WHERE condition;
PostgreSQL:
UPDATE table_name
SET column1 = new_value1, column2 = new_value2, ...
WHERE condition;
### Выбрать данные

MySQL:
SELECT column1, column2, ...
FROM table_name
WHERE condition;
PostgreSQL:
SELECT column1, column2, ...
FROM table_name
WHERE condition;
### Уничтожить запись

MySQL:
DELETE FROM table_name
WHERE condition;
PostgreSQL:
DELETE FROM table_name
WHERE condition;
### Очистка таблицы

MySQL:
TRUNCATE TABLE table_name;
PostgreSQL:
TRUNCATE TABLE table_name;