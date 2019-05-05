import pandas as pd
import numpy as np
from sklearn.metrics.pairwise import euclidean_distances
import sqlalchemy as db




# Load the data from database
    
# Build database connection

engine = db.create_engine('mssql+pyodbc://adminuser:Yxcvbnm@123@arpbpi.database.windows.net/ProMi?driver=ODBC+Driver+17+for+SQL+Server')
con = engine.connect()
metadata = db.MetaData(schema = 'PROM')

# Get event log from database

table = db.Table('Event_Log_All',metadata,autoload = True, autoload_with=engine)
ResultProxy= con.execute(db.select([table]))
ResultSet = ResultProxy.fetchall()
df_export = pd.DataFrame(ResultSet)
df_export.columns = ResultSet[0].keys()

df_pivot = df_export.pivot_table(index = '_case_concept_name_', columns = '_event_concept_name_', aggfunc= len, fill_value = 0)
