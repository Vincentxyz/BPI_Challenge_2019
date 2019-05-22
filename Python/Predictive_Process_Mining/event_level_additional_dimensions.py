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

event_consolidated_dimensions = db.Table('event_consolidated_dimensions',metadata,autoload = True, autoload_with=engine)
#event_activity_count = db.Table('event_activity_count',metadata,autoload = True, autoload_with=engine)
event_activity_count = db.Table('event_activity_count',metadata,autoload = True, autoload_with=engine)

def FetchDatabaseTable(con,table_name):

    ResultProxy= con.execute(db.select([table_name]))
    ResultSet = ResultProxy.fetchall()
    return ResultSet;

#Fetch the consolidated dimensions table
result = FetchDatabaseTable(con,event_consolidated_dimensions)
df_result = pd.DataFrame(result)
df_result.columns = result[0].keys()

#Fetch the activity count table
#result_activity_count = FetchDatabaseTable(con,event_activity_count)
#df_event_activity_count = pd.DataFrame(result_activity_count)
#df_event_activity_count.columns = result_activity_count[0].keys()
df_event_activity_count = pd.read_csv('input_for_decision_tree.csv')


#Merge the two datasets from database as input for classification
df_mergedSet = df_result.merge(df_event_activity_count,on='_eventID__')

df_result.columns
df_event_activity_count.dtypes

# Set the X and Y parameters for predictor and response variables
#Categorical and numerical features seperation
X = df_mergedSet.drop(['is_compliant'],axis = 1)
x_categorical_columns = ['_case_Document_Type_','_case_Item_Category_','_case_Spend_classification_text_','_case_Item_Type_','_case_Sub_spend_area_text_', 'process_cluster']
X_Categorical = X.filter(x_categorical_columns)

# Switch the commenting in the next to lines to include additional compliance values or not
#x_numerical_columns = ['resource_count_case','is_material_missing','event_retrospective_POI','rework_count',,'CreateOrder_NetVal']
x_numerical_columns = ['is_material_missing','material_count','event_retrospective_POI','rework_count','CreateOrder_NetVal','user_count','sod_create_poi_and_gr','sod_create_poi_and_ir', 'throughput_time_in_d', 'task_load_past_seven_days', 'task_load_past_two_days']

   # values still missing for event level dimensions 'material_count','sod_create_poi_and_gr','sod_create_poi_and_ir','CreateOrder_NetVal','retrospective_POI','throughput_time_in_d']
X_Numerical = X.filter(x_numerical_columns)

numerical_categorical = x_categorical_columns + x_numerical_columns + ['_event_concept_name_','_case_concept_name__x', '_eventID__', 'sequence_number_x','_case_concept_name__y','_event_time_timestamp_', 'sequence_number_y']
#numerical_categorical = x_categorical_columns + x_numerical_columns + ['_case_concept_name_','_case_Name_','_case_Vendor_' + '_eventID__']
X_Activity = X.drop(numerical_categorical,axis = 1) 
activity_names = X_Activity.columns.values
X_Numerical = pd.concat([X_Numerical,X_Activity],axis = 1).values

#Response variable - Y
y = 1 - df_result.filter(['is_compliant'])


# Encoding categorical data using OneHotEncoder
from sklearn.preprocessing import OneHotEncoder

onehotencoder = OneHotEncoder()

#Onehotencoding for categorical parameters
X_CategoricalEncoded = onehotencoder.fit_transform(X_Categorical).toarray()

#Concatenation of the categorical and numerical dimensions
X_total = np.concatenate((X_CategoricalEncoded,X_Numerical),axis=1)

#Feature name of the columns used later for visualisation of decision tree
categorical_column_names = list(onehotencoder.get_feature_names(X.filter(x_categorical_columns).columns.values))
feature_names = categorical_column_names + x_numerical_columns + list(activity_names)
import re
new_list_features = [re.sub("[:\-() ]&","_",x) for x in feature_names]

# Splitting the dataset into the Training set and Test set
from sklearn.model_selection import train_test_split
X_train, X_test, y_train, y_test = train_test_split(X_total, y, test_size = 0.20, random_state = 0)



# Fitting classifier to the Training set with balanced weight
from sklearn.tree import DecisionTreeClassifier
classifier = DecisionTreeClassifier(criterion = 'gini',
                                    class_weight='balanced'
                                     , max_depth = 6
                                     , random_state = 0)

classifier.fit(X_train, y_train)


# Predicting the Test set results
y_pred = classifier.predict(X_test)
y_pred_train = classifier.predict(X_train)


# Making the Confusion Matrix
from sklearn.metrics import confusion_matrix,accuracy_score, balanced_accuracy_score
cm = confusion_matrix(y_test, y_pred)
acc_test = balanced_accuracy_score(y_test,y_pred)
acc_train  = balanced_accuracy_score(y_train,y_pred_train)

#Precision score
from sklearn.metrics import precision_score,recall_score,f1_score
precisionScore = precision_score(y_test, y_pred)
recallScore = recall_score(y_test, y_pred)
f1Score = f1_score(y_test, y_pred)
#Grpahviz visulaisation
from graphviz import Source, render

from sklearn.externals.six import StringIO  
from IPython.display import Image  
from sklearn.tree import export_graphviz
import pydotplus

dot_data = StringIO()

export_graphviz(classifier, out_file=dot_data,  
                filled=True, rounded=True,
                special_characters=False,feature_names =new_list_features )

graph = pydotplus.graph_from_dot_data(dot_data.getvalue())  

Image(graph.create_png())


df_feature_importances = pd.DataFrame({'feature_name': feature_names, 'importance': classifier.feature_importances_})
feature_value_more_than_0 = df_feature_importances[df_feature_importances['importance'] > 0.0009]
feature_value_more_than_0.to_csv('event_feature_importances.csv')

#Applying k-fold cross validation

from sklearn.model_selection import cross_val_score

#---------------Cross Validation Recall -----------------

recall = cross_val_score(estimator = classifier,X = X_total,y=y,cv = 5, scoring = 'recall')
mean_recall = recall.mean()
std_recall =recall.std()

#---------------Cross Validation Precision -----------------

precision = cross_val_score(estimator = classifier,X = X_total,y=y,cv = 5, scoring = 'precision')
mean_precision = precision.mean()
std_precision = precision.std()

#---------------Cross Validation F1-Score -----------------

f1_score = cross_val_score(estimator = classifier,X = X_total,y=y,cv = 5, scoring = 'f1_weighted')
mean_f1 = f1_score.mean()
std_f1 = f1_score.std()