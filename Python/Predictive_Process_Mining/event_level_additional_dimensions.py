# -*- coding: utf-8 -*-
"""
Created on Fri May 10 14:23:41 2019

@author: anshu
"""

# Importing the libraries
import numpy as np
import sqlalchemy as db
import pandas as pd
import seaborn as sn
import matplotlib.pyplot as plt
from scipy import stats

# Build database connection

engine = db.create_engine('mssql+pyodbc://adminuser:Yxcvbnm@123@arpbpi.database.windows.net/ProMi?driver=ODBC+Driver+17+for+SQL+Server')
con = engine.connect()
metadata = db.MetaData(schema = 'DIM')

# Get the additional dimensions from SQL for event level

#event_handover_of_work = db.Table('event_handover_of_work',metadata,autoload = True, autoload_with=engine)
#event_retrospective_po_items = db.Table('event_retrospective_po_items',metadata,autoload = True, autoload_with=engine)
#event_missing_material_info = db.Table('event_missing_material_info',metadata,autoload = True, autoload_with=engine)
#event_resource_workload = db.Table('event_resource_workload',metadata,autoload = True, autoload_with=engine)
#event_rework = db.Table('event_rework',metadata,autoload = True, autoload_with=engine)

event_consolidated_dimensions = db.Table('event_consolidated_dimensions',metadata,autoload = True, autoload_with=engine)

def FetchDatabaseTable(con,table_name):

    ResultProxy= con.execute(db.select([table_name]))
    ResultSet = ResultProxy.fetchall()
    return ResultSet;

# Fetch the Handover of work dimension and load into dataframe
#result_set_handover_of_work = FetchDatabaseTable(con,event_handover_of_work)
#df_event_handover_of_work = pd.DataFrame(result_set_handover_of_work)
#df_event_handover_of_work.columns = result_set_handover_of_work[0].keys()
#print (df_event_handover_of_work)
#
## Fetch the Retrospective PO items dimension and load into dataframe
#result_retrospective_po_items = FetchDatabaseTable(con,event_retrospective_po_items)
#df_retrospective_po_items = pd.DataFrame(result_retrospective_po_items)
#df_retrospective_po_items.columns = result_retrospective_po_items[0].keys()
#print(df_retrospective_po_items)
#
## Fetch the missing material info dimension and load into dataframe
#result_missing_material_info = FetchDatabaseTable(con,event_missing_material_info)
#df_missing_material_info = pd.DataFrame(result_missing_material_info)
#df_missing_material_info.columns = result_missing_material_info[0].keys()
#
## Fetch the resource workload of each user  and load into dataframe - Query executing
#result_resource_workload = FetchDatabaseTable(con,event_resource_workload)
#df_resource_workload = pd.DataFrame(result_resource_workload)
#df_resource_workload.columns = result_resource_workload[0].keys()
#
#
## Fetch the rework bit of each event  and load into dataframe - Load in python
#result_rework = FetchDatabaseTable(con,event_rework)
#df_rework = pd.DataFrame(result_rework)
#df_rework.columns = result_rework[0].keys()


#Merge the dataframes into one dataframe 
#pd.merge(df_event_handover_of_work,df_rework,on='_eventID__')
#print(df_event_handover_of_work.columns)
#.merge(df_missing_material_info,on='_eventID__').merge(df_resource_workload,on='_eventID__')

#Fetch the consolidated dimensions table
result = FetchDatabaseTable(con,event_consolidated_dimensions)
df_result = pd.DataFrame(result)
df_result.columns = result[0].keys()


