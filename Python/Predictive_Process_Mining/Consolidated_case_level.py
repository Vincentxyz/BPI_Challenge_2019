# -*- coding: utf-8 -*-
"""
Created on Tue May 14 13:22:40 2019

@author: anshu
"""

# -*- coding: utf-8 -*-
"""
Created on Sat May 11 20:37:37 2019

@author: anshu
"""

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

case_consolidated_dimensions = db.Table('case_consolidated_dimensions',metadata,autoload = True, autoload_with=engine)
event_activity_count = db.Table('event_activity_count',metadata,autoload = True, autoload_with=engine)

def FetchDatabaseTable(con,table_name):

    ResultProxy= con.execute(db.select([table_name]))
    ResultSet = ResultProxy.fetchall()
    return ResultSet;

#Fetch the consolidated dimensions table
result = FetchDatabaseTable(con,case_consolidated_dimensions)
df_result = pd.DataFrame(result)
df_result.columns = result[0].keys()

#Fetch the activity count table
result_activity_count = FetchDatabaseTable(con,event_activity_count)
df_result_activity_count = pd.DataFrame(result_activity_count)
df_result_activity_count.columns = result_activity_count[0].keys()

#Filter the activity count on case concept and event concept name 
df_result_activity_count_filtered = df_result_activity_count.filter(['_case_concept_name_','_event_concept_name_'])
#Pivot_table to get the case level count from event data
df_case_activity_count = df_result_activity_count_filtered.pivot_table(index = '_case_concept_name_', columns = '_event_concept_name_', aggfunc = len, fill_value = 0)

#Merge the two datasets from database as input for classification
df_mergedSet = pd.merge(df_result,df_case_activity_count,on='_case_concept_name_')

# Set the X and Y parameters for predictor and response variables
#Categorical and numerical features seperation
X = df_mergedSet.drop(['is_compliant'],axis = 1)
x_categorical_columns = ['_case_Document_Type_','_case_Item_Category_','_case_Spend_classification_text_','_case_Item_Type_','_case_Sub_spend_area_text_']
X_Categorical = X.filter(x_categorical_columns)
x_numerical_columns = ['number_of_handovers','count_rework','material_count','sod_create_poi_and_gr','sod_create_poi_and_ir','Sum_IR','Sum_GR','CreateOrder_NetVal','GR_NetVal','IR_NetVal','Deviation','CancelGR_NetValue','CancelIR_NetValue']
X_Numerical = X.filter(x_numerical_columns)

numerical_categorical = x_categorical_columns + x_numerical_columns + ['_case_concept_name_','_case_Name_','_case_Vendor_']
X_Activity = X.drop(numerical_categorical,axis = 1) 
activity_names = X_Activity.columns.values
X_Numerical = pd.concat([X_Numerical,X_Activity],axis = 1).values

#Response variable - Y
y = df_result.filter(['is_compliant'])


# Encoding categorical data using Label Encoder and OneHotEncoder
from sklearn.preprocessing import LabelEncoder, OneHotEncoder

labelencoder_event_spend_text = LabelEncoder()
X['_case_Spend_classification_text_'] = labelencoder_event_spend_text.fit_transform(X['_case_Spend_classification_text_'])

labelencoder_item_type = LabelEncoder()
X['_case_Item_Type_'] = labelencoder_item_type.fit_transform(X['_case_Item_Type_'])

labelencoder_Sub_spend_area_text = LabelEncoder()
X['_case_Sub_spend_area_text_'] = labelencoder_Sub_spend_area_text.fit_transform(X['_case_Sub_spend_area_text_'])


labelencoder_case_Document_Type = LabelEncoder()
X['_case_Document_Type_'] = labelencoder_case_Document_Type.fit_transform(X['_case_Document_Type_'])

labelencoder_case_Item_Category = LabelEncoder()
X['_case_Item_Category_'] = labelencoder_case_Item_Category.fit_transform(X['_case_Item_Category_'])


onehotencoder = OneHotEncoder()
#Onehotencoding for categorical parameters
X_CategoricalEncoded = onehotencoder.fit_transform(X_Categorical).toarray()

#Concatenation of the categorical and numerical dimensions
X_total = np.concatenate((X_CategoricalEncoded,X_Numerical),axis=1)

#Feature name of the columns used later for visualisation of decision tree
categorical_column_names = list(onehotencoder.get_feature_names(X_Categorical.columns.values))
feature_names = x_numerical_columns + categorical_column_names + list(activity_names)
import re
new_list_features = [re.sub("[:\-() ]&","_",x) for x in feature_names]

# Splitting the dataset into the Training set and Test set
from sklearn.model_selection import train_test_split
X_train, X_test, y_train, y_test = train_test_split(X_total, y, test_size = 0.20)

# Feature Scaling - Standardization of thr training and test data
from sklearn.preprocessing import StandardScaler
sc = StandardScaler()
X_train = sc.fit_transform(X_train)
X_test = sc.transform(X_test)

# Fitting classifier to the Training set with balanced weight
from sklearn.tree import DecisionTreeClassifier
classifier = DecisionTreeClassifier(criterion = 'entropy',
                                    random_state = 0,
                                    class_weight='balanced')
classifier.fit(X_train, y_train)

# Predicting the Test set results
y_pred = classifier.predict(X_test)

# Making the Confusion Matrix
from sklearn.metrics import confusion_matrix,accuracy_score
cm = confusion_matrix(y_test, y_pred)
acc = accuracy_score(y_test,y_pred)

#Grpahviz visulaisation
from graphviz import Source, render

from sklearn.externals.six import StringIO  
from IPython.display import Image  
from sklearn.tree import export_graphviz
import pydotplus

dot_data = StringIO()

export_graphviz(classifier, out_file='dot_data.dot',  
                filled=True, rounded=True,
                special_characters=True,feature_names =new_list_features )

graph = pydotplus.graph_from_dot_data(dot_data.getvalue())  

Image(graph.create_png())


#important features
for name, importance in zip(feature_names, classifier.feature_importances_):
    print(name, importance)
    
#Applying k-fold cross validation
from sklearn.model_selection import cross_val_score
accuracies = cross_val_score(estimator = classifier,X = X_train,Y=y_train,cv = 10)
accuracies.mean()
accuracies.sd()

#Applying Grid search to find best model and best parameters
#balanced tree
from sklearn.model_selection import GridSearchCV
parameters = [{'criterion' : ["gini","entropy"]},
              {'max_features': [3,5,10]},
              {'min_samples_leaf': [1,5,10]},
              {'max_depth': [2,4,8,16,None]},
              {'class_weight': "balanced"}]

grid_search = GridSearchCV(estimator = classifier,
                           param_grid = parameters,
                           scoring = 'accuracy',
                           cv = 10,
                           n_jobs = -1)
grid_search = grid_search.fit(X_train, y_train)
best_accuracy = grid_search.best_score_
best_parameters = grid_search.best_params_





