import pandas as pd
import dython as dt

df_01 = pd.read_csv('C:/Users/vince_000/Documents/BPI Challenge 2019/New_Exports/02_02_01/02_02_01_01/02_02_01_01.csv', encoding = 'utf-8')
df_01 = df_01.filter(['case']).drop_duplicates()
df_01['cluster'] = '02_02_01_01'

df_02 = pd.read_csv('C:/Users/vince_000/Documents/BPI Challenge 2019/New_Exports/02_02_01/02_02_01_02/02_02_01_02.csv', encoding = 'utf-8')
df_02 = df_02.filter(['case']).drop_duplicates()
df_02['cluster'] = '02_02_01_02'


df_03 = pd.read_csv('C:/Users/vince_000/Documents/BPI Challenge 2019/New_Exports/02_02_01/02_02_01_03/02_02_01_03.csv', encoding = 'utf-8')
df_03 = df_03.filter(['case']).drop_duplicates()
df_03['cluster'] = '02_02_01_03'


df_all = df_01.merge(df_02,on = ['case','cluster'], how = 'outer')
df_all = df_all.merge(df_03, on = ['case','cluster'], how = 'outer').drop_duplicates()

