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
from sklearn.tree import _tree # IMPORTANT: _tree, NOT tree

def tree_to_table(tree, feature_names): # tree: DecisionTreeClassifier, feature_names: list of feature names
    features_with_values = pd.DataFrame(columns=['feature','value'])
    tree_ = tree.tree_
    feature_name = [
        feature_names[i] if i != _tree.TREE_UNDEFINED else "undefined!"
        for i in tree_.feature
    ]

    def recurse(node, depth, features_with_values):
        
        if tree_.feature[node] != _tree.TREE_UNDEFINED:
            name = feature_name[node]
            threshold = tree_.threshold[node]
            features_with_values = features_with_values.append({'feature' : name, 'value' : threshold}, ignore_index= True)
            features_with_values = features_with_values.append(recurse(tree_.children_left[node], depth + 1, features_with_values))
            features_with_values = features_with_values.append({'feature' : name, 'value' : threshold}, ignore_index= True)
            features_with_values = features_with_values.append(recurse(tree_.children_right[node], depth + 1, features_with_values))
            
            return features_with_values

    features_with_values = recurse(0, 1, features_with_values).drop_duplicates()
    
    features_with_values.sort_values(['feature', 'value'])
    
    return features_with_values

# %%
def get_category_names(numerical_range):

    category_names = []
    
    category_names.append('<=' + str(numerical_range[1]))
    
    for i in range(2,len(numerical_range)-1):
        category_names.append('>' + str(numerical_range[i-1]) + ';<=' + str(numerical_range[i]))
        
    category_names.append('>' + str(numerical_range[len(numerical_range)-2]))
    
    return category_names


# %%


def numeric_to_categorical(dataframe, column_name):

    numerical_range = get_value_list(column_name)
    category_names = get_category_names(numerical_range)
    dataframe[column_name] = pd.cut(dataframe[column_name], numerical_range, labels=category_names, \
                                    right=False, include_lowest=True)


# %%


def get_value_list(feature_name):
    value_list = [0]
    value_list = value_list + list(features_with_values[features_with_values['feature'] == feature_name].sort_values('value')['value'])
    value_list.append(np.inf)
    
    return value_list

# %%

new_df = df_mergedSet.copy(deep=True)  # type: pandas.Dataframe

numericals_and_activities = list(activity_names) + x_numerical_columns

features_with_values = tree_to_table(classifier,new_list_features)

features = list(features_with_values['feature'].drop_duplicates())

for i in range(0, len(features)):
    
    if features[i] in numericals_and_activities:
        numeric_to_categorical(new_df, features[i])
        
#new_df['retrospective_POI'] = new_df['retrospective_POI'].astype('category')
types = new_df.dtypes

# %%
y_column = 'is_compliant'

important_columns = []

for i in range(0, len(features)):
    
    if features[i] in numericals_and_activities:
        important_columns.append(features[i])
        
for i in range(0, len(x_categorical_columns)):
    if x_categorical_columns[i] in [element[0:len(x_categorical_columns[i])] for element in features]:
        important_columns.append(x_categorical_columns[i])


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
y = pd.cut(y['is_compliant'], [0, 0.5, 1.5], labels=['compliant', 'not_compliant'], \
                                    right=False, include_lowest=True)
#numeric_to_categorical(y, 'is_compliant', [0, 0.5, 1.5], ['compliant', 'not_compliant'])
new_df.dtypes
y.dtypes


#%%
#df_result['is_compliant'] = 1 - df_result.filter(['is_compliant'])

base_value = df_result.filter(['is_compliant']).values.mean()

rel_columns = important_columns[:len(important_columns)-1]

column = []
value = []
incompliance_ratio = []
change = []

for i in range(0,len(rel_columns)):
    for j in new_df[rel_columns[i]].unique():
        col = rel_columns[i]
        column.append(col)
        value.append(j)
        ratio = df_result[new_df[col] == j].filter(['is_compliant']).values.mean()
        incompliance_ratio.append(ratio)
        change.append((ratio-base_value)/base_value)
        
change_overview = pd.DataFrame({'column' : column, 'value': value, 'imcompl. ratio': incompliance_ratio, 'change to total incompl.': change})

change_overview.to_csv('compliance_change_overview.csv', index = False)