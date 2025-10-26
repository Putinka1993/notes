-- Patterns


-- ABC_XYZ amount and revenue

--Описание групп ABC-XYZ анализа
--AX — большая доля объема продаж/выручки, стабильный спрос.
--AY — большая доля объема продаж/выручки, колеблющийся спрос.
--AZ — большая доля объема продаж/выручки, непредсказуемый спрос.
--BX — средние объёмы продаж/выручки, стабильный спрос.
--BY — средние объёмы продаж/выручки, колеблющийся спрос.
--BZ — средние объёмы продаж/выручки, непредсказуемый спрос.
--CX — малозначительный объем продаж/выручки, стабильный спрос.
--CY — малозначительный объем продаж/выручки, колеблющийся спрос.
--CZ — малозначительный объем продаж/выручки, непредсказуемый спрос.

-- сделать представление таблиц , потом обьеденить их по одинаковому полю
-- select
--	abc.name ,
--	abc.abc_amount || xyz.XYZ as abc_xyz_amount ,
--	abc.abc_revenue || xyz.XYZ as abc_xyz_revenue
--from
--	result_abc as abc
--	join result_xyz as xyz
--		on xyz.name = abc.name
--order by
--	abc_xyz_revenue

--                                     XYZ COV(коэффицент вариации)

--Цель: оценить стабильность спроса (вариативность продаж).
--	•	X — стабильный спрос
--	•	Y — умеренно колеблющийся
--	•	Z — хаотичный, нестабильный
--
--🔧 Применение: планирование закупок, прогнозирование, логистика.
--Значения для определения групп товаров:
--
--Группа "X" --> товары с коэффициентом вариации до 10% включительно;
--Группа "Y" --> товары с коэффициентом до 20% включительно;
--Группа "Z" --> остальные товары.
--Подсказки:
--
--Получить данные с наименованием месяца продажи, наименованием пиццы и количеством проданных единиц;
--Пригодятся обобщенные табличные выражения;
--Для расчета стандартного отклонения и среднего значения используйте оконные функции:
--Функция для расчета стандартного отклонения: stddev_pop;
--Функция для расчета среднего значения: avg.
--Коэффициент вариации рассчитывается как "стандартное отклонение / среднее значение";
--Ожидаемый результат в виде таблицы представлен на следующем шаге.

with amount_table as (
	select
		month_year ,
		month ,
		name ,
		sum(quantity) as amount
	from
		pizza_full_data pfd
	group by
		month_year ,
		month ,
		name
	order by
		month_year ,
		name
), cov_table as (
	select
		name ,
		round(stddev_pop(amount) over(partition by name) / avg(amount) over(partition by name), 3) as cov ,
		case
			when round(stddev_pop(amount) over(partition by name) / avg(amount) over(partition by name), 3) <= 0.1
				then 'X'
			when round(stddev_pop(amount) over(partition by name) / avg(amount) over(partition by name), 3) <= 0.20
				then 'Y'
			else 'Z'
		end as XYZ
	from
		amount_table
	order by
		name
)
select
	name ,
	min(cov) as cov ,
	XYZ
from
	cov_table
group by
	name ,
	XYZ

    
-- =============================================
-- ABC-анализ с маржинальностью по лекарствам
-- =============================================
    
-- Создание агрегированной таблицы
WITH agregation_table AS (
    SELECT
        d.dr_ndrugs AS ndrugs,        -- Название/код лекарства
        d.dr_czak AS purch,           -- Цена закупки за единицу
        d.dr_croz AS retail,          -- Розничная цена за единицу
        SUM(d.dr_kol) AS sum_count,   -- Общее количество
        SUM(d.dr_croz * d.dr_kol) AS sum_retail, -- Сумма продаж
        SUM(d.dr_czak * d.dr_kol) AS sum_purch,  -- Сумма закупки
        ROUND(SUM(d.dr_croz * d.dr_kol - d.dr_czak * d.dr_kol) / SUM(d.dr_croz * d.dr_kol), 2) * 100 AS perc_margin
    FROM drugs d
    GROUP BY
        d.dr_ndrugs,
        d.dr_czak,
        d.dr_croz
) -- Формирование финальной таблицы с ABC-анализом
, final_table AS (
    SELECT
        ndrugs,
        purch,
        retail,
        sum_count,
        ROUND(sum_count / SUM(sum_count) OVER() * 100.0, 2) AS perc_count,
        ROUND(SUM(sum_count) OVER(ORDER BY sum_count DESC) / SUM(sum_count) OVER() * 100.0, 2) AS cumsum_COUNT,
        CASE
            WHEN SUM(sum_count) OVER(ORDER BY sum_count DESC) / SUM(sum_count) OVER() * 100.0 <= 80 THEN 'A'
            WHEN SUM(sum_count) OVER(ORDER BY sum_count DESC) / SUM(sum_count) OVER() * 100.0 <= 95 THEN 'B'
            ELSE 'C'
        END AS ABC_count_purch,
        ROUND(sum_retail / SUM(sum_retail) OVER() * 100.0, 2) AS perc_RETAIL,
        ROUND(SUM(sum_retail) OVER(ORDER BY sum_retail DESC) / SUM(sum_retail) OVER() * 100.0, 2) AS cumsum_RETAIL,
        CASE
            WHEN SUM(sum_retail) OVER(ORDER BY sum_retail DESC) / SUM(sum_retail) OVER() * 100.0 <= 80 THEN 'A'
            WHEN SUM(sum_retail) OVER(ORDER BY sum_retail DESC) / SUM(sum_retail) OVER() * 100.0 <= 95 THEN 'B'
            ELSE 'C'
        END AS ABC_retail,
        perc_margin,
        ROUND(perc_margin / SUM(perc_margin) OVER() * 100.0, 2) AS portion_MARGIN,
        ROUND(SUM(perc_margin) OVER(ORDER BY perc_margin DESC) / SUM(perc_margin) OVER() * 100.0, 2) AS cumsum_MARGIN,
        CASE
            WHEN ROUND(SUM(perc_margin) OVER(ORDER BY perc_margin DESC) / SUM(perc_margin) OVER() * 100.0, 2) <= 80 THEN 'A'
            WHEN ROUND(SUM(perc_margin) OVER(ORDER BY perc_margin DESC) / SUM(perc_margin) OVER() * 100.0, 2) <= 95 THEN 'B'
            ELSE 'C'
        END AS ABC_margin
    FROM agregation_table
) -- Финальный выбор и сортировка
SELECT
    ndrugs,
    purch,
    retail,
    sum_count,
    perc_margin,
    ABC_count_purch,
    ABC_retail,
    ABC_margin
FROM final_table
ORDER BY
    ABC_margin ASC,
    ABC_retail ASC,
    ABC_count_purch ASC,
    perc_margin DESC;
    

🔹 Ключевые моменты:
	1.	perc_margin — маржинальность одного препарата.
	2.	portion_MARGIN — доля от суммарной маржи всех препаратов.
	3.	ABC классификация — A/B/C по количеству, рознице и марже.
	4.	Сортировка позволяет сначала видеть препараты с высокой маржинальностью, потом по продажам и количеству.




--                                     ABC amount and revenue

--Цель: определить важность товаров по вкладу в прибыль/выручку.
    --	•	A — самые ценные (≈80% прибыли, ≈20% товаров)
--	•	B — средние по значимости
--	•	C — наименее важные (много, но приносят мало)
--
--🔧 Применение: приоритет управления запасами, ценообразование, фокус продаж.

--Значения для определения групп товаров:
--
--Группа "A" --> товары с накопительной долей продаж/выручки до 80% включительно;
--Группа "B" --> товары с накопительной долей продаж/выручки до 95% включительно;
--Группа "C" --> остальные товары.
--
--Получить данные с наименованием, объемом проданных товаров и объемом выручки.
--Пригодятся обобщенные табличные выражения.
--Для расчета накопительного итога и суммарного количества проданных товаров используйте оконные функции.
--Ожидаемый результат в виде таблицы представлен на следующем шаге.
with group_name as (
	select
		name ,
		sum(price * quantity) as revenue ,
		sum(quantity) as amount
	from
		pizza_full_data
	where year = 2015
	group by
		name
)
select
	name ,
	case
		when round(sum(amount) over(order by amount desc rows between unbounded preceding and current row) / sum(amount) over() * 100.0,3) <= 80 then 'A'
		when round(sum(amount) over(order by amount desc ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) / sum(amount) over() * 100.0,3) <= 95 then 'B'
		else 'C'
	end as abc_amount ,
	case
		when round(sum(revenue) over(order by revenue desc ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) / sum(revenue) over() * 100.0,3) <= 80 then 'A'
		when round(sum(revenue) over(order by revenue desc ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) / sum(revenue) over() * 100.0,3) <= 95 then 'B'
		else 'C'
	end as abc_revenue
from
	group_name




--                                                   LTV КОГОРТНЫЙ АНАЛИЗ АНАЛОГ
--Берём номер карты и дату покупки.
--Для каждой карты находим её первый месяц покупки — это и есть когорта клиента.
--Считаем, **сколько дней прошло с первой покупки** клиента. Это называется **"возраст клиента"**.
--Смотрим, какой самый "дальний возраст" клиента в днях от первой покупки — нужно для ограничения диапазонов.
--Каждое значение делится на количество клиентов в когорте, чтобы получить средний доход на одного клиента.

WITH data_cohort AS (
    SELECT
        card,
        datetime,
        FIRST_VALUE(to_char(datetime, 'YYYY-MM')) OVER (PARTITION BY card ORDER BY datetime) AS cohort,
        EXTRACT(days FROM datetime - FIRST_VALUE(datetime) OVER (PARTITION BY card ORDER BY datetime)) AS df_days,
        summ
    FROM checks
    WHERE card LIKE '2000%'
    ORDER BY card
)
SELECT
    cohort,
    COUNT(DISTINCT card) AS cnt_customer,
    MAX(df_days) AS max_df_days,
    ROUND(SUM(CASE WHEN df_days = 0 THEN summ END) / COUNT(DISTINCT card)) AS "0_day",
    ROUND(CASE WHEN MAX(df_days) > 0 THEN SUM(CASE WHEN df_days <= 30 THEN summ END) / COUNT(DISTINCT card) END) AS "30_day",
    ROUND(CASE WHEN MAX(df_days) > 30 THEN SUM(CASE WHEN df_days <= 60 THEN summ END) / COUNT(DISTINCT card) END) AS "60_day",
    ROUND(CASE WHEN MAX(df_days) > 60 THEN SUM(CASE WHEN df_days <= 90 THEN summ END) / COUNT(DISTINCT card) END) AS "90_day",
    ROUND(CASE WHEN MAX(df_days) > 90 THEN SUM(CASE WHEN df_days <= 180 THEN summ END) / COUNT(DISTINCT card) END) AS "180_day",
    ROUND(CASE WHEN MAX(df_days) > 180 THEN SUM(CASE WHEN df_days <= 300 THEN summ END) / COUNT(DISTINCT card) END) AS "300_day",
    ROUND(CASE WHEN MAX(df_days) > 300 THEN SUM(CASE WHEN df_days <= 400 THEN summ END) / COUNT(DISTINCT card) END) AS "400_day"
FROM data_cohort
GROUP BY cohort
ORDER BY cohort

with diff_table as (	
	select
		distinct
		ord.customer_id ,
		ord.check_id ,
		pr.category_id ,
		ord.order_date ,
		first_value(to_char(ord.order_date, 'YYYY-MM-DD')) over(partition by ord.customer_id order by ord.order_date) as cohort_first ,
		last_value(to_char(ord.order_date, 'YYYY-MM-DD')) over(partition by ord.customer_id order by ord.order_date) as cohort_last ,
		ord.order_date - first_value(ord.order_date) over(partition by ord.customer_id, pr.category_id order by ord.order_date) as diff_days
	from
		sales.orders as ord 
		join 
			sales.order_details as ord_d
			on
				ord.check_id = ord_d.check_id
		join
			sales.products as pr
			on
				ord_d.product_uuid = pr.product_uuid
)
select
	customer_id ,
	category_id ,
	count(distinct check_id) as cnt_orders
from
	diff_table
where 
	diff_days between 1 and 90
group by
	customer_id ,
	category_id
having 
	count(distinct check_id) > 2
order by
	count(distinct check_id) desc;



    
-- Посчитаем доходы и расходы по месяцам нарастающим итогом (кумулятивно):
SELECT
	"year" ,
	"month" ,
	income ,
	expense ,
	sum(income) over(order by "year" , "month" rows between unbounded preceding and current row) as t_income ,
	sum(expense) over(order by "year" , "month" rows between unbounded preceding and current row) as t_expense ,
	round(
		sum(income) over(order by "year" , "month" rows between unbounded preceding and current row)
		-
		sum(expense) over(order by "year" , "month" rows between unbounded preceding and current row)
		) as t_profit
from
	expenses

-- Накопительная выручка
-- Рассчитаем выручку компании накопительным итогом по месяцам в совокупности за все годы
-- (без разделения на отдельные годы)
WITH data_sum AS (
    SELECT
        EXTRACT(YEAR FROM o.order_date) AS year_order,
        EXTRACT(MONTH FROM o.order_date) AS year_month_num,
        TO_CHAR(o.order_date, 'Month') AS month_order,
        ROUND(SUM(od.unit_price * od.quantity)) AS revenue
    FROM orders o
    JOIN order_details od ON o.order_id = od.order_id
    GROUP BY
        EXTRACT(YEAR FROM o.order_date),
        EXTRACT(MONTH FROM o.order_date),
        TO_CHAR(o.order_date, 'Month')
    ORDER BY
        EXTRACT(YEAR FROM o.order_date),
        EXTRACT(MONTH FROM o.order_date),
        TO_CHAR(o.order_date, 'Month')
)
SELECT
    year_order,
    year_month_num,
    month_order,
    revenue,
    SUM(revenue) OVER (ORDER BY year_order, year_month_num ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS cum_revenue
FROM data_sum
ORDER BY year_order, year_month_num

-- Напишите запрос, который возвращает САМЫЙ ДОРОГОЙ ПРОДУКТ В КАЖДОЙ КАТЕГОРИИ.
-- если был самый дешевый то в оконной функции в order by мы бы оставили обычную сортировку
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

-- Этот запрос рассчитывает ПРОЦЕНТНОЕ СООТНОШЕНИЯ КОЛ-ВА ТОВАРА для каждого продукта в рамках его категории.
select
	p.product_name ,
	p.category_id,
	p.units_in_stock,
	sum(p.units_in_stock) over(partition by p.category_id) as Total_Category_sum,
	round(p.units_in_stock * 100.0 / sum(p.units_in_stock) over(partition by p.category_id)) as per
from
	products p
order by
	p.category_id ,
	per DESC

-- 1.Сколько всего продуктов входит в категорию(cnt_product);
-- 2.Средняя цена продукта по его категории(avg_units_stock);
-- 3.Какое отклонение в цене каждого продукта относительно средней по категории(diff).
select
	p.product_name ,
	p.category_id,
	p.units_in_stock,
	count(p.product_name ) over(partition by p.category_id) as cnt_product,
	round(avg(p.unit_price) over(partition by p.category_id)) as average,
	round(p.unit_price - avg(p.unit_price) over(partition by p.category_id)) * 100.0
		/ avg(p.unit_price) over(partition by p.category_id) as DIFF
from
	products p
order by
	p.category_id ,
	p.unit_price ,
	p.product_name

-- вывести зарплаты разбитые по городам сколько процентов составляет его зарплата от максимальной в городе
with t_salary as (
	SELECT
		name ,
		city ,
		salary ,
		last_value(salary) over(partition by city order by salary rows between unbounded preceding and unbounded following) as max_salary_city
	from
		employees
	order by
		city ,
		salary
)
select
	name ,
	city ,
	salary ,
	round((salary / max_salary_city) * 100.0) as percent
from
	t_salary


-- вывести таблицу с ОТСОРТИРОВАННЫМ столбцом ЗАРПЛАТЫ по ДЕПОРТАМЕНТУ ,
-- вывести минимальную и максимальную зарплату в депортаменте
select
	name ,
	department ,
	salary ,
	first_value(salary) over(partition by department order by salary rows between unbounded preceding and unbounded following) as low ,
	last_value(salary) over(partition by department order by salary rows between unbounded preceding and unbounded following) as high
from
	employees
order by
	department ,
	salary ,
	id


--  вывести столбец ЗАРПЛАТЫ отсортированный по всем ДЕПОРТАМЕНТАМ ,
-- вывести предыдущую и следующую по величине зарплату в процентах (на сколько больше), имя и депортамент
with t_sal as (
	select
		name ,
		department ,
		salary ,
		lag(salary, 1) over() as prev_salary ,
		lag(name, 1) over() as prev_name ,
		lag(department, 1) over() as prev_department
	FROM
		employees e
	order by
		salary ,
		id
)
select
	name ,
	department ,
	salary ,
	prev_name ,
	prev_department ,
	prev_salary ,
	round((salary - prev_salary) * 100.0 / prev_salary) as diff_percent
from
	t_sal




-- FRAMES
Определение фрейма:
ROWS|RANGE|GROUPS BETWEEN X AND Y

ROWS — определение фрейма относительно текущей строки, ROWS оперирует индивидуальными записями.

Начало фрейма (X) может быть:

CURRENT ROW — фрейм начинается с текущей строки;
N PRECEDING— фрейм начинается с N-й строки перед текущей;
N FOLLOWING — фрейм начинается с N-й строки после текущей;
UNBOUNDED FOLLOWING — фрейм начинается с границы секции.
Конец фрейма (Y) может быть:

CURRENT ROW — фрейм до текущей строки;
N PRECEDING — фрейм до N-й строки перед текущей;
N FOLLOWING — фрейм до N-й строки после текущей;
UNBOUNDED FOLLOWING — фрейм до границы секции.
Пример (1): фрейм включает только две предыдущие записи и текущую строку

ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
Пример (2): фрейм включает текущую строку и все последующие

ROWS BETWEEN CURRENT ROW AND UNBOUNDED FOLLOWING
Функции, поддерживающие фреймы:

функции смещения FIRST_VALUE(), LAST_VALUE(), NTH_VALUE();
все функции агрегации;
Остальные функции работают со всей партицией (PARTITION BY) либо со всеми выбранными записями.



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


FRAMES

В общем случае определение фрейма выглядит так:

{ ROWS | GROUPS | RANGE } BETWEEN frame_start AND frame_end [ EXCLUDE exclusion ]
Фрейм по умолчанию:

RANGE BETWEEN unbounded preceding AND current row EXCLUDE no others
Только у некоторых функций фрейм настраивается:

функции смещения first_value(), last_value(), nth_value();
все функции агрегации: count(), avg(), sum(), ...
У остальных функций фрейм всегда равен секции.

Тип фрейма

Строковые (rows) оперируют отдельными записями.
Групповые (groups) оперируют группами записей с одинаковым набором значений столбцов из order by;
Диапазонные (range) оперируют группами записей, у которых значение столбца из order by попадает в указанный диапазон.
Границы фрейма (frame_start / frame_end)

unbounded preceding
N preceding
current row
N following
unbounded following
Инструкции unbounded preceding и unbounded following всегда означают границы секции. current row для строковых фреймов означает текущую запись, а для груповых и диапазонных — текущую запись и все равные ей (по значениям из order by). N preceding и N following означают:

для строковых фреймов — количество записей до / после текущей;
для групповых фреймов — количество групп до / после текущей;
для диапазонных фреймов — диапазон значений относительно текущей записи.
Исключения (exclusion)

NO OTHERS. Ничего не исключать. Вариант по умолчанию.
CURRENT ROW. Исключить текущую запись.
GROUP. Исключить текущую запись и все равные ей (по значению столбцов из order by).
TIES. Оставить текущую запись, но исключить равные ей.
Фильтрация

Отфильтровать фрейм для отдельной оконной функции можно через инструкцию FILTER или вложенный CASE:

func(column) FILTER (WHERE condition) OVER window

func(
  CASE WHEN condition THEN expression ELSE other END
) OVER window