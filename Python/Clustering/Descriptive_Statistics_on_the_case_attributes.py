import pandas as pd
import numpy as np
import sqlalchemy as db
import seaborn as sns
import matplotlib.pyplot as plt


# Load the data from database
    
# Build database connection

engine = db.create_engine('mssql+pyodbc://adminuser:Yxcvbnm@123@arpbpi.database.windows.net/ProMi?driver=ODBC+Driver+17+for+SQL+Server')
con = engine.connect()
metadata = db.MetaData(schema = 'PROM')

# Get Clusters table from database

table = db.Table('case_clustering_with_compliance',metadata,autoload = True, autoload_with=engine)
ResultProxy= con.execute(db.select([table]))
ResultSet = ResultProxy.fetchall()
df_export = pd.DataFrame(ResultSet)
df_export.columns = ResultSet[0].keys()

g = sns.countplot(y = "level_1_cluster_name", 
             data = df_export)

plt = df_export['level_1_cluster_name'].value_counts().plot(kind = 'barh', color = 'blue')




for index, row in df_export['level_1_cluster_name']:
    g.text(row.name, row.tip, round(ro))