import pandas as pd
import numpy as np
import sqlalchemy as db


# Load the data from database
    
# Build database connection

engine = db.create_engine('mssql+pyodbc://adminuser:Yxcvbnm@123@arpbpi.database.windows.net/ProMi?driver=ODBC+Driver+17+for+SQL+Server')
con = engine.connect()
metadata = db.MetaData(schema = 'PROM')

ResultProxy = con.execute(db.select([event_resource_workload]))
ResultSet = ResultProxy.fetchall()
df_export = pd.DataFrame(ResultSet)
df_export.columns = ResultSet[0].keys()

df_export = df_export.filter(['_case_concept_name_', '_event_concept_name_', 'task_load_past_two_days'])

#df_avg = df_export.groupby(by = ['_case_concept_name_', '_event_concept_name_'],).agg({'task_load_past_two_days': 'avg'})
df_export.pivot_table(index = '_case_concept_name_', columns = '_event_concept_name_', values = 'task_load_past_two_days',aggfunc= numpy.mean, fill_value = 0)
