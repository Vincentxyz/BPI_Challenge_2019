# %%
# Importing the libraries
import numpy as np
import sqlalchemy as db
import pandas as pd
import seaborn as sn
import matplotlib.pyplot as plt
from scipy import stats

# Build database connection

engine = db.create_engine(
    'mssql+pyodbc://adminuser:Yxcvbnm@123@arpbpi.database.windows.net/ProMi?driver=ODBC+Driver+17+for+SQL+Server')
con = engine.connect()
metadata = db.MetaData(schema='DIM')

# Get the additional dimensions from SQL for event level

case_consolidated_dimensions = db.Table('case_consolidated_dimensions', metadata, autoload=True, autoload_with=engine)
# event_activity_count = db.Table('event_activity_count',metadata,autoload = True, autoload_with=engine)
case_activity_count = db.Table('case_activity_count', metadata, autoload=True, autoload_with=engine)

case_aggregated_resource_workload = db.Table('case_aggregated_resource_workload',metadata,autoload = True, autoload_with=engine)

def FetchDatabaseTable(con, table_name):
    ResultProxy = con.execute(db.select([table_name]))
    ResultSet = ResultProxy.fetchall()
    return ResultSet;

# %%
# Fetch the consolidated dimensions table
result = FetchDatabaseTable(con, case_consolidated_dimensions)
df_result = pd.DataFrame(result)
df_result.columns = result[0].keys()

# Fetch the activity count table
result_activity_count = FetchDatabaseTable(con, case_activity_count)
df_case_activity_count = pd.DataFrame(result_activity_count)
df_case_activity_count.columns = result_activity_count[0].keys()

# Filter the activity count on case concept and event concept name
# df_result_activity_count_filtered = df_result_activity_count.filter(['_case_concept_name_','_event_concept_name_'])
# Pivot_table to get the case level count from event data
# df_case_activity_count = df_result_activity_count_filtered.pivot_table(index = '_case_concept_name_', columns = '_event_concept_name_', aggfunc = len, fill_value = 0)

#Fetch the workload table
result_case_aggregated_resource_workload = FetchDatabaseTable(con,case_aggregated_resource_workload)
df_case_aggregated_resource_workload = pd.DataFrame(result_case_aggregated_resource_workload)
df_case_aggregated_resource_workload.columns = result_case_aggregated_resource_workload[0].keys()

#Filter the activity count on case concept and event concept name 
#df_result_activity_count_filtered = df_result_activity_count.filter(['_case_concept_name_','_event_concept_name_'])
#Pivot_table to get the case level count from event data
#df_case_activity_count = df_result_activity_count_filtered.pivot_table(index = '_case_concept_name_', columns = '_event_concept_name_', aggfunc = len, fill_value = 0)



# Merge the two datasets from database as input for classification
df_mergedSet = pd.merge(df_result, df_case_activity_count, on='_case_concept_name_')  # type: pandas.DataFrame
df_mergedSet = pd.merge(df_mergedSet,df_case_aggregated_resource_workload,on='_case_concept_name_')

# Delete objects to free up memory
del case_activity_count, case_consolidated_dimensions, df_case_activity_count, result, result_activity_count

# %%
'''
column_names = list(df_mergedSet.columns.values)
for column_name in column_names:
    df_mergedSet[column_name] = df_mergedSet[column_name].astype('category')
'''

# %%


def numeric_to_categorical(dataframe, column_name, numerical_range, category_names):
    dataframe[column_name] = pd.cut(dataframe[column_name], numerical_range, labels=category_names, \
                                    right=False, include_lowest=True)


# %%
new_df = df_mergedSet.copy(deep=True)  # type: pandas.Dataframe
numeric_to_categorical(new_df, 'count_rework', [0, 1.5,  np.inf], ['<=1.5', '>1.5'])
numeric_to_categorical(new_df, 'CreateOrder_NetVal', [0, 2331.5, 6097.5, 12729.5, np.inf], \
                       ['<=2331.5',  '>2331.5;<=6097.5', '>6097.5;<=12729.5', '>12729.5'])
numeric_to_categorical(new_df, 'throughput_time_in_d', [0, 14.687, 41.812, 91.125, 100.667, np.inf], \
                       ['<=14.687', '>14.687;<=41.812','>41.812;<=91.125', '>91.125;<=100.667','>100.667'])
numeric_to_categorical(new_df, 'number_of_handovers', [0, 3.5, 4.5, 8.5, np.inf], \
                       ['<=3.5', '>3.5; <= 4.5', '>4.5; <= 8.5','>8.5'])
numeric_to_categorical(new_df, 'number_of_orders_created_same_day_and_vendor', [0,4.5, 6.5, 8.5, 54, np.inf], \
                       ['<=4.5', '>4.5;<=6.5', '>6.5;<=8.5', '>8.5;<=54', '>54'])


numeric_to_categorical(new_df, 'workload_max_2_d_Clear Invoice', [0, 2830.5, np.inf], \
                       ['<=2830.5', '>2830.5'])
numeric_to_categorical(new_df, 'workload_avg_7_d_Create Purchase Order Item', [0, 74.5, np.inf], \
                       ['<=74.5', '>74.5'])

numeric_to_categorical(new_df, 'workload_avg_2_d_Record Goods Receipt', [0,26.5, np.inf], \
                       ['<=26.5', '>26.5'])
numeric_to_categorical(new_df, 'workload_avg_7_d_Change Quantity', [0,10.5, np.inf], \
                       ['<=10.5', '>10.5'])
numeric_to_categorical(new_df, 'workload_max_7_d_Change Price', [0,263.5, np.inf], \
                       ['<=263.5', '>263.5'])
numeric_to_categorical(new_df, 'workload_avg_7_d_Receive Order Confirmation', [0,0.5, np.inf], \
                       ['<=0.5', '>0.5'])
numeric_to_categorical(new_df, 'workload_max_2_d_Record Goods Receipt', [0,98, np.inf], \
                       ['<=98', '>98'])
numeric_to_categorical(new_df, 'workload_max_7_d_Record Invoice Receipt', [0,1089.5, np.inf], \
                       ['<=1089.5', '>1089.5'])
numeric_to_categorical(new_df, 'workload_max_7_d_Remove Payment Block', [0,1419, np.inf], \
                       ['<=1419', '>1419'])
numeric_to_categorical(new_df, 'workload_max_2_d_Remove Payment Block', [0,754.5, np.inf], \
                       ['<=754.5', '>754.5'])
numeric_to_categorical(new_df, 'workload_avg_2_d_Create Purchase Order Item', [0,263.5, np.inf], \
                       ['<=263.5', '>263.5'])
new_df['retrospective_POI'] = new_df['retrospective_POI'].astype('category')
types = new_df.dtypes


# %%
y_column = 'is_compliant'
important_columns = ['_case_Item_Category_', 'count_rework',  'CreateOrder_NetVal', \
                     'number_of_orders_created_same_day_and_vendor', 'throughput_time_in_d',  \
                     'process_cluster', 'number_of_handovers', 'Cancel Invoice Receipt', \
                      'retrospective_POI',  'workload_max_2_d_Clear Invoice', 'workload_avg_7_d_Create Purchase Order Item', \
                     '_case_Spend_classification_text_', '_case_Sub_spend_area_text_', \
                     'Change Approval for Purchase Order', 'workload_avg_2_d_Record Goods Receipt', \
                     'workload_avg_7_d_Change Quantity', 'workload_max_7_d_Change Price', 'workload_avg_7_d_Receive Order Confirmation', \
                     'workload_max_2_d_Record Goods Receipt', 'workload_max_7_d_Record Invoice Receipt', \
                     'workload_max_7_d_Remove Payment Block','workload_max_2_d_Remove Payment Block', \
                     'workload_avg_2_d_Create Purchase Order Item', y_column]

important_activities = ['Cancel Invoice Receipt']
# %%
#for item in important_activities:
  #  numeric_to_categorical(new_df, item, [0, 0.5, np.inf], ['<=0.5', '>0.5'])
numeric_to_categorical(new_df, 'Cancel Invoice Receipt', [0, 0.5, np.inf], \
                       ['<=0.5', '>0.5'])

# %%
i = 0
column_names = list(new_df.columns.values)

for column_name in column_names:
    if column_name not in important_columns:
        new_df = new_df.drop(column_name, axis=1)
        print('dropped: ' + column_name)
        i = i + 1

print('dropped: ' + str(i) + ' columns')
column_names = list(new_df.columns.values)
types = new_df.dtypes

del i

# %%
for column_name in column_names:
    if str(new_df[column_name].dtype) != 'category':
        print(column_name)
        new_df[column_name] = new_df[column_name].astype('category')

types = new_df.dtypes

#%%
y = 1 - df_result.filter(['is_compliant'])
y['is_compliant'].unique()
numeric_to_categorical(y, 'is_compliant', [0, 0.5, 1.5], ['compliant', 'not_compliant'])
new_df.dtypes
y.dtypes

#%%
#
new_df = new_df.drop('is_compliant', axis = 1)


#%%
df_result['is_compliant'] = 1 - df_result.filter(['is_compliant'])

base_value = df_result.filter(['is_compliant']).values.mean()

rel_columns = important_columns[:len(important_columns)-1]

column = []
value = []
compliance_ratio = []
change = []

for i in range(0,len(rel_columns)):
    for j in new_df[rel_columns[i]].unique():
        col = rel_columns[i]
        column.append(col)
        value.append(j)
        ratio = df_result[new_df[col] == j].filter(['is_compliant']).values.mean()
        compliance_ratio.append(ratio)
        change.append((ratio-base_value)/base_value)
        
change_overview = pd.DataFrame({'column' : column, 'value': value, 'compliance_ratio': compliance_ratio, 'change': change})

change_overview.to_csv('compliance_change_overview.csv')