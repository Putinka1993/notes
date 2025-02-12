import pandas as pd
from io import StringIO


                                                # READ JSON_INDEX #

json_buf3='{'0': {'col_A': 'a1', 'col_B': 'b1', 'col_C':'c1' },
						'1': {'col_A': 'a2', 'col_B': 'b2', 'col_C':'c2' } }'
df3 = pd.read_json(json_buf3, orient='index')

                                                # WRITE JSON_INDEX #
json_index = df.to_json(orient='index')
print(json_index)
{
	'0':{'color':'red','speed':56,'volume':80},
	'1':{'color':'green','speed':24,'volume':65},
	'2':{'color':'blue','speed':65,'volume':50}
}


                                                # READ CSV #
                                        # COMMA SEPAREITED VALUES #

csv_d1 = 'col_A, col_B, col_C\na1, b1, c1\na2, b2, c2'
df = pd.read_csv(StringIO(csv_d1))

df = pd.read_csv('c:/test.csv', sep=',', header=None, names=['a', 'b', 'c'], skiprows=[0, 2], nrows=7, na_values={'age': ['NA', -1, 'NaN']}, chunksize=2)

                                                # WRITE CSV #

df.to_csv('tmp.csv', na_rep=-100, sep=':', columns=['', '', ''], index=False, encoding='UTF-8')


                                                # READ JSON_SPLIT #

json_buf='{'columns':['col_A', 'col_B', 'col_C'],
		    'index': [0,1],
			'data':[['a1','b1','c1'],['a2','b2','c2']]}'
df1=pd.read_json(json_buf, orient='split')

                                                # WRITE JSON_SPLIT #

json_split = df.to_json(orient='split')


												# READ JSON_RECORDS #

json_buf2='[{'col_A': 'a1', 'col_B': 'b1', 'col_C':'c1'},
						{'col_A': 'a2', 'col_B': 'b2', 'col_C': 'c2'}]'
df2 = pd.read_json(json_buf2, orient='record')

												# WRITE JSON_RECORDS #

json_records = df.to_json(orient='records')

                                                # READ EXCEL #

xlsx = pd.ExcelFile('/path')
df1 = pd.read_excel(xlsx, sheet_name='page1')
df2 = pd.read_excel(xlsx, sheet_name='page2', header=1, skiprows=[11])

                                                # WRITE EXCEL #

writer = pd.ExcelWriter('path/')

df1.to_excel(writer, index=False, sheet_name='New_page1')
df2.to_excel(writer, index=False, sheet_name='New_page2')
writer.save()

with pd.ExcelWriter('output.xlsx') as writer:
    # Записываем DataFrame на лист
    df1.to_excel(writer, sheet_name='Sheet1')
    df2.to_excel(writer, sheet_name='Sheet2')

                                                # READ SQLITE3 #

import sqlalchemy as sql

connect = sql.create_engine('sqlite:////	path/')
df = pd.read_sql('select * from users where age >= 30', connect)

                                                # WRITE SQL #

df.to_sql('users_short', connect, index=False, if_exists='replace')
