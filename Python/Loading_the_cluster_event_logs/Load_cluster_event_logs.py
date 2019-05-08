import pandas as pd
import numpy as np
import sqlalchemy as db



path = 'C:/Users/vince_000/Documents/BPI Challenge 2019/New_exports/'


# Load the data from database
    
# Build database connection

engine = db.create_engine('mssql+pyodbc://adminuser:Yxcvbnm@123@arpbpi.database.windows.net/ProMi?driver=ODBC+Driver+17+for+SQL+Server')
con = engine.connect()
metadata = db.MetaData(schema = 'PROM')

# Specify clusters

cluster = ['01_01_01', '01_01_02', '01_02_01','01_02_02','01_02_03', '02_01','02_02_01', '02_02_02', '02_02_03','03','04']



for c in cluster:

    sqlstring = 'SELECT Event_Log_All._case_concept_name_, _event_concept_name_, _event_time_timestamp_, sorting'
    sqlstring += ' FROM PROM.Event_Log_All JOIN stg.case_clustering ON Event_log_All._case_concept_name_ = case_clustering._case_concept_name_'
    sqlstring += " AND final_cluster ='" + c + "'"
    sqlstring += ' JOIN stg.case_compliance ON Event_log_All._case_concept_name_ = case_compliance._case_concept_name_ AND is_compliant = 1'
    
    
    # Get event log from database
    try:
        
        ResultProxy = con.execute(sqlstring)
        ResultSet = ResultProxy.fetchall()
        df_export = pd.DataFrame(ResultSet)
        df_export.columns = ResultSet[0].keys()
        
        
        df_export.to_csv(path + c + '.csv', index = False)
    
    except: 
        print('Cluster ' + c + ' could not be loaded')