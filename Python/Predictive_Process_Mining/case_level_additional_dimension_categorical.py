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


# Merge the two datasets from database as input for classification
df_mergedSet = pd.merge(df_result, df_case_activity_count, on='_case_concept_name_')  # type: pandas.DataFrame

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
numeric_to_categorical(new_df, 'count_rework', [0, 1.5, 2.5, np.inf], ['<=1.5', '>1.5; <=2.5', '>2.5'])
numeric_to_categorical(new_df, 'CreateOrder_NetVal', [0, 623.5, 2331.5, 6094.5, 30622.5, np.inf], \
                       ['<=623.5', '>623.5;<=2331.5', '>2331.5;<=6094.5', '>6094.5;<=30622.5', '>30622.5'])
numeric_to_categorical(new_df, 'throughput_time_in_d', [0, 121.021, 190.354, 232.75, np.inf], \
                       ['<=121.021', '>121.021;<=190.354', '<=232.75', '>232.75'])
numeric_to_categorical(new_df, 'number_of_handovers', [0, 3.5, np.inf], ['<=3.5', '>3.5'])
numeric_to_categorical(new_df, 'number_of_orders_created_same_day_and_vendor', [0, 2.5, 4.5, 5.5, 19.5, 54, 85, np.inf], \
                       ['<=2.5', '<=4.5', '<=5.5', '<=19.5', '<=54', '<=85', '>8.5'])
new_df['retrospective_POI'] = new_df['retrospective_POI'].astype('category')
types = new_df.dtypes

# %%
y_column = 'is_compliant'
important_columns = ['_case_Item_Category_', 'count_rework', 'Cancel Goods Receipt', 'CreateOrder_NetVal', \
                     'number_of_orders_created_same_day_and_vendor', 'throughput_time_in_d', 'Record Goods Receipt', \
                     'Change Price', 'process_cluster', 'number_of_handovers', 'Cancel Invoice Receipt', \
                     'Receive Order Confirmation', 'retrospective_POI', 'Remove Payment Block', \
                     'Vendor creates invoice', '_case_Spend_classification_text_', '_case_Sub_spend_area_text_', \
                     'Change Approval for Purchase Order', y_column]

important_activities = ['Vendor creates invoice', 'Record Goods Receipt', 'Cancel Goods Receipt', \
                        'Cancel Invoice Receipt', 'Remove Payment Block', 'Change Price', \
                        'Receive Order Confirmation', 'Change Approval for Purchase Order']

for item in important_activities:
    numeric_to_categorical(new_df, item, [0, 0.5, np.inf], ['<=0.5', '>0.5'])


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
#
### wittgenstein rule set
#import wittgenstein as lw
##ripper_clf = lw.RIPPER() # Or irep_clf = lw.IREP() to build a model using IREP
#irep_clf = lw.IREP()
#df_concat = pd.concat([new_df, y], join = 'outer', axis = 1 )
#irep_clf.fit(df_concat,class_feat ='is_compliant' ) # Or call .fit with params train_X, train_y

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