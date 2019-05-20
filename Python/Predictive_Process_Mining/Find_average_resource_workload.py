import pandas as pd
import numpy as np
import sqlalchemy as db


# Load the data from database
    
# Build database connection

engine = db.create_engine('mssql+pyodbc://adminuser:Yxcvbnm@123@arpbpi.database.windows.net/ProMi?driver=ODBC+Driver+17+for+SQL+Server')
con = engine.connect()
metadata = db.MetaData(schema = 'DIM')

event_resource_workload = db.Table('event_resource_workload',metadata,autoload = True, autoload_with=engine)
ResultProxy = con.execute(db.select([event_resource_workload]))
ResultSet = ResultProxy.fetchall()
df_export = pd.DataFrame(ResultSet)
df_export.columns = ResultSet[0].keys()


# --------------- Case Level -----------------

case_2_d_workload = df_export.filter(['_case_concept_name_', '_event_concept_name_', 'task_load_past_two_days'])
avg_2_d = df_export.pivot_table(index = '_case_concept_name_', columns = '_event_concept_name_', values = 'task_load_past_two_days',aggfunc= np.mean, fill_value = 0)
avg_2_d.columns = 'workload_avg_2_d_' + avg_2_d.columns
max_2_d = df_export.pivot_table(index = '_case_concept_name_', columns = '_event_concept_name_', values = 'task_load_past_two_days',aggfunc= np.max, fill_value = 0)
max_2_d.columns = 'workload_max_2_d_' + max_2_d.columns

case_7_d_workload = df_export.filter(['_case_concept_name_', '_event_concept_name_', 'task_load_past_two_days'])
avg_7_d = df_export.pivot_table(index = '_case_concept_name_', columns = '_event_concept_name_', values = 'task_load_past_seven_days',aggfunc= np.mean, fill_value = 0)
avg_7_d.columns = 'workload_avg_7_d_' + avg_7_d.columns
max_7_d = df_export.pivot_table(index = '_case_concept_name_', columns = '_event_concept_name_', values = 'task_load_past_seven_days',aggfunc= np.max, fill_value = 0)
max_7_d.columns = 'workload_max_7_d_' + max_7_d.columns

case_workload = avg_2_d.merge(max_2_d, on = '_case_concept_name_')
case_workload = case_workload.merge(avg_7_d, on = '_case_concept_name_' )
case_workload = case_workload.merge(max_7_d, on = '_case_concept_name_' )

case_workload['_case_concept_name_'] = case_workload.index
#case_workload.to_sql(name = 'case_aggregated_resource_workload', con = con, schema = 'DIM', if_exists = 'replace', index = False)

case_workload.to_csv('case_aggregated_resource_workload.csv', index = False)

# --------------- Event Level -----------------
i =0

event_avg_workload_2d = pd.DataFrame(columns = avg_2_d.columns)

for i in range(0,len(df_export)):
    case_concept_name = df_export['_case_concept_name_'][i]
    event_id = df_export['_eventID__'][i]
    event = df_export[df_export['_case_concept_name_'] == case_concept_name]
    event = event[event['_eventID__'] <= event_id]
    lines_2_d_workload = event.filter(['_case_concept_name_', '_event_concept_name_', 'task_load_past_two_days'])
    workload_pivoted_2d = lines_2_d_workload.pivot_table(index = '_case_concept_name_', columns = '_event_concept_name_', values = 'task_load_past_two_days',aggfunc= np.mean, fill_value = 0)
    event_avg_workload_2d = pd.concat([event_avg_workload_2d,workload_pivoted_2d], axis = 0)


