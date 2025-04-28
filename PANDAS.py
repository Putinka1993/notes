import numpy as np                                                                 # Structure DataFrame #
import pandas as pd

# Таблица employees
# Данные для сотрудников
employees_data = {
    'id': [1, 2, 3, 4, 5],
    'name': ['Alice', 'Bob', 'Charlie', 'David', 'Eva'],
    'department_id': [1, 2, 3, 1, 2],
    'salary': [5000, 6000, 5500, 5200, 6500],
    'hire_date': pd.to_datetime(['2020-01-15', '2019-03-10', '2021-06-20', '2018-07-30', '2022-01-25'])
}
employees = pd.DataFrame(employees_data)

# Таблица departments
# Данные для департаментов
departments_data = {
    'id': [1, 2, 3, 4],
    'name': ['Sales', 'IT', 'HR', 'Marketing']
}
departments = pd.DataFrame(departments_data)

# 1. head()
# Возвращает первые несколько строк DataFrame.

# Первые 3 строки
employees.head(3)

# 2. query()
# Фильтрация строк по условию.

# Фильтрация по зарплате
employees.query('salary > 5500 and hire_date == "2020-01-15"')
# Фильтрация по департаменту
employees.query('department_id == 2')
# фильтрация с пробелами
df.query('`Exchange Index` == "NASDAQ Composite"')
# фильтрация с использованием списка list
selected_list = ['1105042d-9197-4bcd-9668-bb5ab2a76221',
                 '2487e34e-728d-4d0b-818b-45f8f111f853',
                 'b5355c21-48ad-42e7-9ee6-ebe9085881a3']
od.query('product_uuid in @selected_list').head()

# Из таблицы customers выведите всех клиентов, имя которых начинается на букву А и имеет 5 и более букв в своем составе.
customers[(customers['customer_name'].str.split().str[0].str.len() == 5) & (customers['customer_name'].str.startswith('А'))]

# 3. sort_values()
# Сортировка данных по указанным столбцам.

# Сортировка по зарплате
employees.sort_values(by='salary', ascending=False)
# Сортировка по дате найма
employees.sort_values(by='hire_date')

# 4. iloc[] и loc[]
# Доступ к строкам и столбцам по индексам и меткам.

# Доступ к строкам по индексу
employees.iloc[0:3]
# Доступ к столбцам по метке
employees.loc[:, ['name', 'salary']]

# 5. groupby()
# Группировка данных по столбцу и применение агрегатных функций.

# Средняя зарплата по департаменту
employees.groupby('department_id')['salary'].mean()
# Количество сотрудников в каждом департаменте
employees.groupby('department_id').size()
# Скольких уникальных клиентов обслужил каждый сотрудник магазина? (таблица orders).
orders.groupby('salesman_id')['customer_id'].nunique()

# 6. agg()
# Применение нескольких агрегатных функций.

# Средняя и максимальная зарплата по департаментам
employees.groupby('department_id')['salary'].agg(['mean', 'max'])

# 7. merge()
# Объединение таблиц по общим значениям (аналог JOIN в SQL).

# Соединение таблиц employees и departments
employees_departments = employees.merge(departments, left_on='department_id', right_on='id', suffixes=('_emp', '_dept'))

# 8. concat()
# Объединение таблиц по строкам или столбцам.

# Объединение строк таблиц employees и departments (пример)
pd.concat([employees, employees], ignore_index=True)
# Объединение таблиц по столбцам
pd.concat([employees[['name']], departments[['name']]], axis=1)

# 9. assign()
# Создание нового столбца.

# Добавление столбца с бонусом (10% от зарплаты)
employees.assign(bonus=employees['salary'] * 0.1)

# 10. apply()
# Применение функции к значениям DataFrame или Series.

# Применение функции для увеличения зарплаты на 500
employees['salary'] = employees['salary'].apply(lambda x: x + 500)

# 11. drop()
# Удаление столбцов или строк.

# Удаление столбца "hire_date"
employees.drop(columns=['hire_date'])
# Удаление строк с конкретными индексами
employees.drop([0, 2])

# 12. count()
# Подсчет количества ненулевых значений.

# Подсчет количества сотрудников
employees['name'].count()
# Подсчет значений по департаменту
employees['department_id'].value_counts()

# 13. mean()
# Вычисление среднего значения для числовых столбцов.

# Средняя зарплата сотрудников
employees['salary'].mean()
# Средняя зарплата по каждому департаменту
employees.groupby('department_id')['salary'].mean()

# 14. max() и min()
# Нахождение максимального и минимального значений.

# Максимальная зарплата
employees['salary'].max()
# Минимальная зарплата в департаменте с ID = 1
employees[employees['department_id'] == 1]['salary'].min()

# 15. drop_duplicates()
# Удаление дубликатов в данных.

# Удаление дубликатов по столбцу "department_id"
employees.drop_duplicates(subset='department_id')

# 16. df.pivot_table()
# сводная таблица

data = {'animal': ['cat', 'cat', 'snake', 'dog', 'dog', 'cat', 'snake', 'cat', 'dog', 'dog'],
        'age': [2.5, 3, 0.5, np.nan, 5, 2, 4.5, np.nan, 7, 3],
        'visits': [1, 3, 2, 3, 2, 3, 1, 1, 2, 1],
        'priority': ['yes', 'yes', 'no', 'yes', 'no', 'no', 'no', 'yes', 'no', 'no']}

labels = ['a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j']
df = pd.DataFrame(data, index=labels)

result = df.pivot_table(values='age',
              index='animal',
              columns='visits',
              aggfunc='mean')

# visits	1	2	3
# animal
# cat	    2.5	NaN	2.5
# dog	    3.0	6.0	NaN
# snake	    4.5	0.5	NaN

# DataFrame(data=None, index=None, columns=None, dtype=None, copy=False)
d = {'price': [1, 2, 3],
     'count': [10, 20, 30],
     'percent': [24, 51, 71]}
df = pd.DataFrame(d, index=['a', 'b', 'c'])

# 17. df.filter()
# Теперь выведем все столбцы, которые содержат, например, 'да'. Используем для этого параметр like
df.filter(like='да', axis=1)
# Или выведем все строки, содержащие в метках индекса 'S&P'
df.filter(like='S&P', axis=0)
# по двум значениям в индексе начинаются на буквы M или S.
df.filter(regex='^(M|S)', axis=0)
# Или, например, найдем все строки, содержащие индексы Доу Джонса
df.filter(regex='^DJ', axis=0)
# Можем вывести, например, все столбцы, которые заканчиваются на 'кр'
df.filter(regex='кр$', axis=1)

# 18. df.isin()
mask = df['биржевой индекс'].isin(['ASX Australia', 'Hang Seng', 'SENSEX India', 'Shanghai Composite'])

# 19. df['field'].where(df['field'] > 100, 'result')
df['цвет'] = df['изм %'].where(df['изм %'].str.contains('−'), 'green')





                                                            # DATETIME #

s1 = pd.Series(['01 Jan 2022', '02-02-2022', '20220303', '2022/04/04', '2022-05-05', '2022-06-06T12:20'])
result = pd.to_datetime(s1, format='mixed')
# rangetime установить диапозон времени
s1 = pd.Series([1,10,3,np.nan], index=pd.to_datetime(['2022-01-01', '2022-01-03', '2022-01-06', '2022-01-08']))
s1.asfreq(freq='D').fillna(method='ffill')
# 2022-01-01     1.0
# 2022-01-02     1.0
# 2022-01-03    10.0
# 2022-01-04    10.0
# 2022-01-05    10.0
# 2022-01-06     3.0
# 2022-01-07     3.0
# 2022-01-08     3.0
# Freq: D, dtype: float64
                                                               # DESCRIBE #
df = pd.DataFrame({'visits_2021' : [100, 200, 300, 50, 40],
                   'visits_2020' : [90, 100, np.nan, 10, 80],
                   'visits_2019' : [10, np.nan, 20, 16, 80]},
                  index=['Moscow', 'Kazan', 'Ufa', 'Yakutsk', 'Novosibirsk'])

df.describe()
# df.T.describe() если нужно получить среднее значение с индексов

#       visits_2021	visits_2020	visits_2019
# count	5.000000	4.000000	4.000000
# mean	138.000000	70.000000	31.500000
# std	110.544109	40.824829	32.593455
# min	40.000000	10.000000	10.000000
# 25%	50.000000	62.500000	14.500000
# 50%	100.000000	85.000000	18.000000
# 75%	200.000000	92.500000	35.000000
# max	300.000000	100.000000	80.000000

                                                                # ADD function #
dt1 = {'visits': [200, 150, 400]}
dt2 = {'visits': [80, np.nan, 200]}

df1 = pd.DataFrame(dt1, index=['St.Petersburg', 'Saratov', 'Sochi'])
df2 = pd.DataFrame(dt2, index=['St.Petersburg', 'Saratov', 'Sochi'])

#  example 1
result = df1.add(df2, fill_value=0)
#  example 2
result = df1 + df2.fillna(0)
# result
# >>> 	       visits
# St.Petersburg	280.0
# Saratov	    150.0
# Sochi	        600.0

                                                            # INDEX RENAME MAP #

users.index = users.index.map(lambda x: x[:5].upper())
users.rename(index={'Vallera' : 'Leonid'})

                                                            # COLUMNS RENAME MAP #

users.columns = users.columns.map(lambda x: x+'$'.lower())
users.rename(columns={'Male' : 'Fale'})
                                                               # APPLY FUNC #
# EXAMPLE 1
def apply_func(row):
    if row['age'] < 25:
        return 'A'
    elif 40 > row['age'] > 25:
        return 'B'
    else:
        return 'C'

_df['group'] = _df.apply(apply_func, axis=1)

# EXAMPLE 2 lambda
df['class'] = df.apply(lambda row: row['class'].upper(), axis=1)

# EXAMPLE 3
def pay_cash_sms(row):
    if row['city'] == 'Moscow':
        return int(row['balance'] - (row['sms'] * 3))

_df['balance'] = _df.apply(pay_cash_sms, axis=1)

                                                                 #      loc       FUNCTION     #

# EXAMPLE 1
# изменить по одному параметру значения в столбце
df.loc[df['city'] == 'Moscow', 'balance'] *= 3
# EXAMPLE 2
# изменить значение по более точному параметру.
df.loc[(df['city'] == 'Vladivostok') & (df['name'] == 'Sergey') & (df['surname'] == 'Girev'), 'city'] = 'Kazan'
# EXAMPLE 3
ind_name = pd.Index(['Moscow', 'Vladivostok', 'Ufa', 'Kazan'])
data = {'col_1': [0, 1, 2, 3],
             'col_2': [4, 5, 6, 7],
             'col_3': [8, 9, 10, 11],
             'col_4': [12, 13, 14, 15]}
df1 = pd.DataFrame(data, index=ind_name)
# df1
# >>>            col_1 col_2 col_3 col_4
#       Moscow       0     4     8    12
#  Vladivostok       1     5     9    13
#          Ufa       2     6    10    14
#        Kazan       3     7    11     1
# result = df1.loc[['Moscow', 'Kazan'], ['col_2', 'col_4']]
# >>>           col_2     col_4
#     Moscow        4        12
#      Kazan        7        15
# EXAMPLE 4
data = {'name': ['Ivan', 'Maxim', 'Anya'],
              'age': [30, 25, 24],
              'cash': [200000, 30000, 50000]}
df1 = pd.DataFrame(data, index=['a', 'b', 'c'])
# df1
# >>>         name   age      cash
#       a     Ivan    30    200000
#       b    Maxim    25     30000
#       c     Anya    24     50000
# temp_df1 = df1.loc[ df1[' age '] > 24,  ['cash', 'age'] ]
# temp_df1
# >>>         cash   age
#       a   200000    30
#       b    30000    25
#  EXAMPLE 5
# df1.loc[ 'a', 'd' ]
# df1.loc[ 'a' : 'c', ]
# _df.loc[_df['age'] > 30]
# _df.loc[['a', 'd'], :].sum(axis=0)
# f_b = df.loc[(df['balance'] > 2000) & (df['tarif'] == 'Всё за 500')]

                                                                # iloc #

# df1.iloc[0]
# >>>    name      Ivan
#         age        30
#        cash    200000
#       Name: a, dtype: object
# df1.iloc[[0, 2], [1, 2]]
# >>>      age     cash
#      a    30   200000
#      c    24    50000

                                                         # AT func #

df.at[22, 'city'] = 'Kazan'

                                                         # ROUND #
_df['balance_usd'] = (_df['balance'] / 60).round(2)

                                                        # SORTED_VALUES #

df_sorted = df.sort_values(by='sms_volume', ascending=False)
# two parametres
df.sort_values(by=['StationCapacity', 'Name'], ascending=[False, True], inplace=True)

                                                        # FILL EMPTY VALUES #
df.fillna('PIPKa')
df.fillna(df.mean())
df.fillna(method='ffill', limit=2) #ffill = forward fill
df.fillna(method='bfill', limit=1) #bfill = back fill

                                                        # REPLACE #
df.replace('NaN', 1)
df.replace({-9999 : 'NaN', -6666 : 0})
df['Веб-сайт'] = df['Веб-сайт'].replace({r'\.рф': '.ru', r'\.om': '.com', r'\.cm': '.com'}, regex=True)
df['fuel_rate'].replace(to_replace='[.,]', value='.', regex=True)


                                                        # MAP #
airport_data = pd.DataFrame({'airline': ['Air China', 'Jet Airways', 'Aeroflot', 'easyJet'], 'planes': [10, 4, 30, 2]})
country = {'Air China': 'China', 'Jet Airways': 'India', 'Aeroflot': 'Russia', 'easyJet': 'United Kingdom'}
airport_data['country'] = airport_data['airline'].map(country) # create new columns and fill values with use key

df.users.map(lambda x: x + ' #')

                                                            # STR #
names['user'].str.replace('@', '')
_df.loc[:, 'driver'] = _df[~_df['driver'].str.contains('уволен')]
_df.loc[:, 'driver'] = _df['driver'].str.replace('Водитель ', '')
filtered_df = df[(df['car'].str.len() == 6) & (df['car'].str[0].str.isalpha())]
result = _df[ ~ ((_df['car'].str.len() == 6) & (_df['car'].str[0].str.isalpha()))]
def f(x):
    return x.replace('@', '')
names['user'] = names['user'].map(f)

                                                             # ISIN #
df_t[df_t['Unnamed: 0'].isin(['Свердловская область', 'Магаданская область',
                              'Сахалинская область', 'Калужская область','Ярославская область', 'Кировская область' ])]

                                                        # UNSTACK MULTIINDEX #
result_df = task2_df.unstack() # работа с мультииндексами приобразовать в столбцы ( что бы изи делать все )
# random work with multiindex
df3 = df3_task[(df3_task[('Capacity', 'count')]) & (df3_task[('rating', 'mean')] >= 5)]
df3.sort_values(by=[('Capacity', 'count'), ('rating', 'mean')], ascending=False)

                                                        # RESET_INDEX #
df.reset_index()

                                                         # DROP and DROPNA DELETE ROW #
df.drop([0], inplace=True)
#dropna
df.dropna(how='all', thresh=2)
# drop_dublicates
df.drop_duplicates()
df.drop_duplicates(['name']) # drop last values duplicates columns
df.drop_duplicates(['name'], keep='last') # drop forward values duplicates columns

                                                        # DROP and DROPNA DELETE COLOMUNS #
df.drop(['color', 'value'], axis=1, inplace=True)
#dropna
df.dropna(axis=1, how='all', thresh=2)

                                                      # DUPLICATED #
df[df.duplicated()] # отоброзить дубликаты

_df[_df.duplicated(keep=False)] # отоброзить все дубликаты
                                                       # AGG #
df.agg(['sum', 'mean', 'std'])
#  >>>             0           1      2           3
#   sum    93.000000  113.000000   51.0  172.000000
#  mean    31.000000   37.666667   17.0   57.333333
#   std    29.512709   15.176737    7.0   35.360053

                                                # CUT CATEGORIES DIFF #

# самое главное в использовании функции cut это правильно выбрать интервал
# example 1
grades = [8, 9, 2, 0, 3, 8, 3, 9, 6, 5, 7, 0, 3, 0, 6, 7, 3, 9, 3, 5, 1, 4, 6, 5, 7, 5, 7, 6, 4, 6, 6, 1, 9, 1, 5, 8, 4, 6, 8, 5, 9, 5, 7, 9, 9, 1, 1, 0, 1, 0]
s1 = pd.Series(grades, index=[f'visitor {i}' for i in range(1, len(grades)+1)])
categ = [-1, 4, 7, 10]
criteries = ['Плохо', 'Так себе', 'Отлично']
result = pd.cut(s1, categ, labels=criteries)
print(result.value_counts())
# example 2
# задать категорию возраста, и присвоить новый столбец
df['group'] = pd.cut(df['age'], bins=[0, 25, 40, float('inf')], labels=['A', 'B', 'C'])

                                                # MERGE #

df_result = pd.merge(df1, df2, how='inner', on='ID')

                                                # JOIN #

df_result = df1.join(df2, how='inner', on='ID', lsuffix='_left', rsuffix='_right')
df4 = df1.join([df2, df3], how='outer')

                                                # CONCAT #

# example 1
s1 = pd.Series(['a', 'b'])
s2 = pd.Series(['c', 'd'])
pd.concat([s1, s2])
# 0    a
# 1    b
# 0    c
# 1    d
# dtype: object

# example 2
pd.concat([s1, s2], ignore_index=True)
# 0    a
# 1    b
# 2    c
# 3    d
# dtype: object

# example 3
pd.concat([s1, s2], keys=['s1', 's2'])
# s1  0    a
#     1    b
# s2  0    c
#     1    d
# dtype: object

# example 3
df3 = pd.DataFrame([['c', 3, 'cat'], ['d', 4, 'dog']],
                   columns=['letter', 'number', 'animal'])
# df3
#   letter  number animal
# 0      c       3    cat
# 1      d       4    dog
pd.concat([df1, df3], sort=False)
#   letter  number animal
# 0      a       1    NaN
# 1      b       2    NaN
# 0      c       3    cat
# 1      d       4    dog

                                            # pattern FINDALL #
s1 = pd.Series(['teach pandas at stepik.com', 'help@stepik.com', 'user@t.co', 'lovepandas@google.com'])
pattern ='[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}'
s1.str.findall(pattern)

# 0                         []
# 1          [help@stepik.com]
# 2                [user@t.co]
# 3    [lovepandas@google.com]
# dtype: object

                                                # isna #

col_deleted = [col for col in df.columns if ~df[col].isna().all()]

                                              # ASTYPE изменить тип ИНДЕКСА type labels #

_s1.index = _s1.index.astype(int)
df['StationCapacity'] = df['StationCapacity'].astype(int)
df['fuel_rate'] = df['fuel_rate'].replace(to_replace='[.,]', value='.', regex=True).astype(float)

                                            # изменить НАЗВАНИЕ индексов (labels) #
df1 = pd.DataFrame({'user_name': ['Ivan', 'Alex', 'Ugen'],
                    'clicks': [2, 5, 8],
                    'time_interval': [3, 6, 9]}, [0, 1, 2])
# df1
# >>>     user_name  clicks  time_interval
#     0        Ivan       2              3
#     1        Alex       5              6
#     2        Ugen       8              9
labels = pd.Index(['one', 'two', 'three'])
values = df1.values # забираем значения
olumns = df1.columns # забираем название столбцов
rest_df1 = pd.DataFrame(values, labels, columns)
# rest_df1
# >>>     user_name   clicks   time_interval
#    one       Ivan        2               3
#    two       Alex        5               6
#  three       Ugen        8               9

                                                         # изменить название столбцов LABELS #
                                                # new name
df1.columns = ['user_name', 'user_clicks', 'time_interval']
# df1.columns
# >>> Index(['user_name', 'user_clicks', 'time_interval'], dtype='object')

                                           # преобразование таблицы df.REINDEX([' ',.....]) #
df.reindex(['e', 'b', 'c', 'd', 'a'], axis=1)

df2 = df1.reindex(['user_name', 'time_interval'])
# df2
# >>>      user_name   time_interval
#     0         Ivan               3
#     1         Alex               6
#     2         Ugen               9

                                                        # DROP!!!  #
df3 = df1.drop([0, 2], axis=0)
# df3
# >>>     user_name   user_clicks   time_interval
#    1         Alex             5               6

                                           # DROP + inplace=True (для дропа без присваивания) #
# df1.drop([0, 2], axis=0, inplace=True)
# df1
# >>>      user_name user_clicks time_interval
#    1          Alex           5             6

                                                          # dtypes #
# df.dtypes
 # преобразования типов
df['Температура'] = pd.to_numeric(df['Температура'], errors='coerce')
df['Давление'] = pd.to_numeric(df['Давление'], errors='coerce')
df['Дата'] = pd.to_datetime(df['Дата'], errors='coerce')

                                                        # RANDOM EXAMPLE #
def solution(_df):
    # ваш код здесь)
    count_sms = _df['sms'].sum()
    _df['sms_volume'] = list(map(lambda x: x / count_sms, _df['sms']))
    result = _df.sort_values(by='sms_volume', ascending=False)
    return result.head(3)

                                                        # MASK #
# определить выбросы
mask = np.abs(df) > 1
df[mask] # df[mask] = 0
df[mask.any(1)]
df[mask] = np.sign(df)

                                                        # DUMMIES GET_DUMMIES MATRIX FICTION #

m = pd.get_dummies(df['Genre'], prefix='genre')
pref_lang = _df['lang'].str.get_dummies(sep=',').add_prefix('lang_')
df.join(m)
tarif = pd.from_dummies(_df[['tarif_demo', 'tarif_premium', 'tarif_regular']], sep='_')
result = pd.DataFrame(_df['account'], columns=['account']).join(tarif)
