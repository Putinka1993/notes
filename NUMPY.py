import numpy as np

# создаст одномерный массив с порядковыми числами от 0 до 1_000_000
array = np.arange(1_000_000)
# массив из 0 (НУЛЕЙ)
zero_arr = np.zeros(5)
zero_arr
>>> array([0., 0., 0., 0., 0.])
zero_arr_in_arr = np.zeros((2, 5))
zero_arr_in_arr
>>> array([[0., 0., 0., 0., 0.],
		       [0., 0., 0., 0., 0.]])
# массив из 1 (едениц)
ones_arr = np.ones(5)
ones_arr
>>> array([1., 1., 1., 1., 1.])
ones_arr_in_arr = np.zeros((2, 5))
ones_arr_in_arr
>>> array([[1., 1., 1., 1., 1.],
		       [1., 1., 1., 1., 1.]])
#  массив из любых символов и букв
any_character_arr = np.full(5, 'P')
any_character_arr
>>> array(['P', 'P', 'P', 'P', 'P'], dtype='<U1')
any_character_arr_in_arr = np.full((2, 2), 'F')
any_character_arr_in_arr
>>> array([['F', 'F'],
		       ['F', 'F']], dtype='<U1')

#                              RANDOM ARR, MATRIX
arr1 = np.random.randint(-10, 10, size=7)
arr1
>>> array([ 5, -6,  6, -9,  8,  9, -9])
matrix = np.random.randint(-10, 10, size=(3, 3))
matrix
>>> array([[ -3, -10,   2],
		       [ -1,   5,  -9],
		       [  4,  -6,   2]])

#                  умножить каждый элемент
m1 = np.array([4, 5, 9])
m1 * 2
>>> array([ 8, 10, 18])
#                  умножить по элементно
arr1 = np.array([1, 2, 3])
arr2 = np.array([4, 5, 6])
np.multiply(arr1, arr2)
>>> array([ 4 10 18 ])

#                  поделить поэлементно
m1 = np.array([6, 4, 8])
m2 = np.array([3, 2, 2])
np.divide(m1, m2)
>>> array([2., 2., 4.])

# узнать остаток от числа
10 - m1
>>> array([6, 5, 1])
# сравнить каждый элемент массива с каждым элементом другого массива
temp0308 = [36.5, 36.7, 36.6]
temp0408 = [36.6, 36.6, 36.6]
m1_temp0308 = np.array(temp0308)
m1_temp0408 = np.array(temp0408)
m1_temp0308 > m1_temp0408
>>> array([False,  True, False])
# сравнить элементы на bool
m1 = np.array([0, 10, 3, 14])
m2 = np.array([13, 5, 6, 10])
np.greater(m1, m2)
>>> array([False,  True, False,  True])
# вывести индекс в двумерном массиве допустим числа [1, 6, 11, 16]
array = np.array([[1,  2,  3,  4,  5],
								  [6,  7,  8,  9, 10],
								  [11, 12, 13, 14, 15],
								  [16, 17, 18, 19, 20]])
array[:, 0]
>>> array([ 1,  6, 11, 16])
# вывести несколько индексов в двумерном массиве допустим [[2, 3],
#                                                         [7, 8],
#                                                         [12, 13],
#                                                         [17, 18]]
array[:, 1:3]
>>> array([[ 2,  3],
	         [ 7,  8],
           [12, 13],
           [17, 18]])
# [[14, 15],
#  [19, 20]]
array[2:, 3:]
>>> array([[14, 15],
		       [19, 20]])
#                    транспонирование T or transponse
arr1 = np.arange(15).reshape((3, 5))
arr1
>>> array([[ 0,  1,  2,  3,  4],
	         [ 5,  6,  7,  8,  9],
           [10, 11, 12, 13, 14]])
arr1.T # or arr1.transpose()
>>> array([[ 0,  5, 10],
           [ 1,  6, 11],
           [ 2,  7, 12],
           [ 3,  8, 13],
           [ 4,  9, 14]])
# func maximum, minimum
m1 = np.array([1, 2, 3, 4])
m2 = np.array([0, 4, 1, 6])
np.maximum(m1, m2)
>>> array([1, 4, 3, 6])
np.minimum(m1, m2)
>>> array([0, 2, 1, 4])
#                 найти индекс минимального и максимального значения
arr1 = np.array([0, -5, 10, 4])
arr1.argmin()
>>> 1
arr1.argmax()
>>> 2
#                             sum сложение по оси axis=
m2d = np.arange(12).reshape((2, 6))
m2d
>>> array([[ 0,  1,  2,  3,  4,  5],
       [ 6,  7,  8,  9, 10, 11]])
#                              сложение по столбцам
m2d.sum(axis=0)
>>> array([ 6,  8, 10, 12, 14, 16])
# сложение по строчкам
m2d.sum(axis=1)
>>> array([15, 51])

#                                SORT
d2m = np.array([random.randint(-50, 50) for i in range(15)]).reshape((3, 5))
d2m
>>> array([[  5, -45,  -5,  -5,  15],
       [  9,  12, -16, -34,  35],
       [ 32,  -1, -16, -45, -15]])
d2m.sort()                    # по оси X
d2m
>>> array([[-45,  -5,  -5,   5,  15],
       [-34, -16,   9,  12,  35],
       [-45, -16, -15,  -1,  32]])
d2m.sort(0)                   # по оси Y
d2m
>>> array([[-45, -16, -15,  -1,  15],
       [-45, -16,  -5,   5,  32],
       [-34,  -5,   9,  12,  35]])
#                              UNIQ
names = np.array(['Alexey', 'Kirill', 'Ivan', 'Dima', 'Kirill', 'Ivan'])
u_names = np.unique(names)
u_names
>>> array(['Alexey', 'Dima', 'Ivan', 'Kirill'], dtype='<U6')
m1 = np.array([1, 2, 1, 3, 0, 1, 2])
np.unique(m1)
>>> array([0, 1, 2, 3])
#                               in1d
names = np.array(['Ivan', 'Alexey', 'Ivan', 'Kirill', 'Dima', 'Alexey'])
np.in1d(names, ['Ivan', 'Kirill'])
>>> array([ True, False,  True,  True, False, False])

#                               DIAG
matrix = np.array([random.randint(-10, 10) for _ in range(16)]).reshape((4, 4))
matrix
>>> array([[ -7,   1,  -6,   2],
		       [ -2,  10,  -3,   4],
		       [  1,   0,   0,  -9],
		       [-10,   2,  -2,   9]])
np.diag(matrix)         # главная диагональ
>>> array([-7, 10,  0,  9])
np.diag(matrix, k=1)    # взять на 1 уровень выше диагональ
>>> array([ 1, -3, -9])
np.diag(matrix, k=-1)   # взять на 1 уровень ниже диагональ
>>> array([-2,  0, -2])

#                   работа с масками 'MASK mask and WHERE where'
m1 = np.array([10, -5, 3, -2, -1, 50])
#                  WHERE
#                   изменить положительные и отрицательные числа
#                   то есть выполнить два условия
np.where(m1 > 0, 100, -100)          # WHERE     <<<-----
>>> array([ 100, -100,  100, -100, -100,  100])
#                   выполнить 1 условие
np.where(m1 < 0, 100, m1)
>>> array([ 10, 100,   3, 100, 100,  50])
np.where(m1 > 0, m1 ** 2, m1)
>>> array([ 100,   -5,    9,   -2,   -1, 2500])
np.where(m1 < 0, np.abs(m1), m1)
>>> array([10,  5,  3,  2,  1, 50])
np.where((m1 == 3) | (m1 == -1), -100, m1)
>>> array([  10,   -5, -100,   -2, -100,   50])

#                              MASK
mask1 = m1 > 0
mask2 = m1 < 0
m1[mask1]
>>> array([10,  3, 50])
m1[mask2]
>>> array([-5, -2, -1])
# вывести числа маски Анастасия
users_list = ['Сергей', 'Анастасия', 'Алексей', 'Евгения', 'Андрей']
arr = np.array(users_list)
visits=np.array([
                 [1,2,1,0,0,1,1],
                 [0,0,1,0,3,1,2],
                 [2,1,0,2,0,2,1],
                 [1,2,1,0,1,1,1],
                 [1,2,1,0,0,1,0],
])
mask = arr == 'Анастасия'
visits[mask]
>>> array([[0, 0, 1, 0, 3, 1, 2]])
# аперанды | &
mask = (users == 'Сергей') | (users == 'Алексей')
mask
>>> array([ True, False,  True, False, False])
mask2 = (users == 'Сергей') & (users == 'Алексей')
mask2
>>> array([False, False, False, False, False])
#                                 ANY, ALL
bool_arr1 = np.array([False, True, False, True])
bool_arr2 = np.array([True, True, True, True])
bool_arr1.all()
>>> False
bool_arr1.any()
>>> True
bool_arr2.all()
>>> True
bool_arr2.any()
>>> True

# вытащить несколько любых индексов строк
visits[[4, 4, 0]]
>>> array([[1, 2, 1, 0, 0, 1, 0],
	         [1, 2, 1, 0, 0, 1, 0],
		       [1, 2, 1, 0, 0, 1, 1]])
# выбрать колонки и строки еще один метод
#        ROW     ROW    COL
visits[[0, 2, 4]][:, [1, 2, 3]]
>>> array([[2, 1, 0],
       [1, 0, 2],
       [2, 1, 0]])

# создание матрицы из массива RESHAPE
m1 = np.arange(18)
resh_m1 = np.reshape(3, 6)
resh_m1
>>> array([[ 0,  1,  2,  3,  4,  5],
       [ 6,  7,  8,  9, 10, 11],
       [12, 13, 14, 15, 16, 17]])
# создание ДВУМЕРНОЙ матрицы из тогоже массива
resh_two_demens = m1.reshape((3, 2, 3))
>>> array([[[ 0,  1,  2],
        [ 3,  4,  5]],

       [[ 6,  7,  8],
        [ 9, 10, 11]],

       [[12, 13, 14],
        [15, 16, 17]]])

# ОКРУГЛЕНИЕ ROUNDING
np.round([4.5]) # в меньшую
>>> [4.]
np.round([4.6]) # в большую
>>> [5.]
np.ceil([4.4]) # в большую
>>> [5.]
np.floor([4.6]) # в меньшую
>>> [4.]

# посмотреть вложенность и размер вложенных массивов
lst = [[1, 2, 3], [4, 5, 6]]
lst.shape
>>> (2, 3) # глубина 2, размер 3

# тип данных в массиве
array.dtype
>>> dtype('int64')

# принудительно задать тип данных в массиве
array = np.array([9, 8, 7], dtype=np.float64)
array.dtype
>>>dtype('float64')
# сменить тип данных в массиве (создается отдельный массив)
array2 = array.astype(np.int64)
array2.dtype
>>> dtype('int64')