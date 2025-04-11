**
1) С точки зрения потребления ресурсов выгоднее использовать формулу на этапе подготовки данных (в Power Query) и затем загрузить в модель просто значения, чем тащить все данные в Power BI и затем использовать формулу на языке DAX.
2) Проще сделать преобразования с помощью графического интерфейса в Power Query, чем писать формулу на языке DAX вручную.
3) Можно сразу отменить загрузку таблиц и убрать лишние столбцы и соответственно тоже не тащить в модель Power BI.
**

 
# USERELATIONSHIP(...)
USERELATIONSHIP('Calendar'[Date], 'NW_orders_total'[shipped_date])
Включает альтернативное (неактивное по умолчанию) отношение между 'Calendar'[Date] и 'NW_orders_total'[shipped_date].
В обычных моделях 'Calendar'[Date] чаще всего связано с 'NW_orders_total'[order_date], но этот код временно переключает связь на shipped_date

# CALCULATE(...)
CALCULATE изменяет контекст вычисления, применяя фильтры или альтернативные отношения.
Здесь он заставляет COUNTROWS('NW_orders_total') считать только те заказы, у которых shipped_date совпадает с Calendar[Date].

### посчетать количество заказов отправленных в каждый день из таблицы календаря
CALCULATE(COUNTROWS('NW_orders_total'), USERELATIONSHIP('Calendar'[Date], 'NW_orders_total'[shipped_date]))


# FILTER() 
this is mesuare, считает количество заказов (dist_cnt_orders), но только для тех товаров, 
у которых unit_price выше среднего ([OVERALL_AVG_PRICE])

Expensive_orders = 
CALCULATE(
    NW_orders_details_total[dist_cnt_orders],
    FILTER(
        products_dir,
        products_dir[unit_price] > [OVERALL_AVG_PRICE]
    )
)


# IF/OR

is_weekend = IF(or('Calendar'[День недели] = 5, 'Calendar'[День недели] = 6), "Weekend", "Work day")
IF('Calendar'[День недели] = 5 || 'Calendar'[День недели] = 6, "Weekend", "Work day")
