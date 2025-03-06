
# посчетать количество заказов отправленных в каждый день из таблицы календаря
**CALCULATE(COUNTROWS('NW_orders_total'), USERELATIONSHIP('Calendar'[Date], 'NW_orders_total'[shipped_date]))**

**USERELATIONSHIP('Calendar'[Date], 'NW_orders_total'[shipped_date])
Включает альтернативное (неактивное по умолчанию) отношение между 'Calendar'[Date] и 'NW_orders_total'[shipped_date].
В обычных моделях 'Calendar'[Date] чаще всего связано с 'NW_orders_total'[order_date], но этот код временно переключает связь на shipped_date**

**CALCULATE(...)
CALCULATE изменяет контекст вычисления, применяя фильтры или альтернативные отношения.
Здесь он заставляет COUNTROWS('NW_orders_total') считать только те заказы, у которых shipped_date совпадает с Calendar[Date].**