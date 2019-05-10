import pandas as pd
import dython.nominal as nl
import sqlalchemy as db

#df_01 = pd.read_csv('C:/Users/vince_000/Documents/BPI Challenge 2019/New_Exports/02_02_01/02_02_01_01/02_02_01_01.csv', encoding = 'utf-8')
#df_01 = df_01.filter(['case']).drop_duplicates()
#df_01['cluster'] = '02_02_01_01'
#
#df_02 = pd.read_csv('C:/Users/vince_000/Documents/BPI Challenge 2019/New_Exports/02_02_01/02_02_01_02/02_02_01_02.csv', encoding = 'utf-8')
#df_02 = df_02.filter(['case']).drop_duplicates()
#df_02['cluster'] = '02_02_01_02'
#
#
#df_03 = pd.read_csv('C:/Users/vince_000/Documents/BPI Challenge 2019/New_Exports/02_02_01/02_02_01_03/02_02_01_03.csv', encoding = 'utf-8')
#df_03 = df_03.filter(['case']).drop_duplicates()
#df_03['cluster'] = '02_02_01_03'
#
#
#df_all = df_01.merge(df_02,on = ['case','cluster'], how = 'outer')
#df_all = df_all.merge(df_03, on = ['case','cluster'], how = 'outer').drop_duplicates()
#
#df_all.to_csv('C:/Users/vince_000/Documents/BPI Challenge 2019/New_Exports/clusters_02_02_01.csv', index = False)


df_all = pd.read_csv('C:/Users/vince_000/Documents/BPI Challenge 2019/New_Exports/clusters_02_02_01.csv')

# Build database connection

engine = db.create_engine('mssql+pyodbc://adminuser:Yxcvbnm@123@arpbpi.database.windows.net/ProMi?driver=ODBC+Driver+17+for+SQL+Server')
con = engine.connect()
metadata = db.MetaData(schema = 'stg')

table = db.Table('case_table_filtered',metadata,autoload = True, autoload_with=engine)
ResultProxy = con.execute(db.select([table]))
ResultSet = ResultProxy.fetchall()
df_export = pd.DataFrame(ResultSet)
df_export.columns = ResultSet[0].keys()

df_val = df_all.merge(df_export, left_on= 'case', right_on = '_case_concept_name_')

column_name = ['_case_Spend_area_text_', '_case_Sub_spend_area_text_', '_case_Name_','_case_Vendor_']
theils_u = []
cramers_v = []

for c in column_name:
    theils_u.append(nl.theils_u(df_val['cluster'] , df_val[c]))
    cramers_v.append(nl.cramers_v(df_val[c], df_val['cluster'] ))
    
df_nominal_corr = pd.DataFrame({'column' : column_name, 'uncertainty coefficient': theils_u})

df_nominal_corr.to_csv('C:/Users/vince_000/Documents/GitHub/BPI_Challenge_2019/Python/Clustering/Correlation_to_Clustering_in_02_02_01/Correlation_to_Clustering_in_02_02_01.csv', index = False)

#group_analysis = df_val.filter(['_case_Vendor_', 'cluster', '_case_concept_name_']).groupby(['_case_Vendor_', 'cluster']).count()

#