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


result_activity_count = FetchDatabaseTable(con,event_activity_count)
df_result_activity_count = pd.DataFrame(result_activity_count)
df_result_activity_count.columns = result_activity_count[0].keys()

df_result_activity_count_filtered = df_result_activity_count.filter(['_case_concept_name_','_event_concept_name_'])

df_case_activity_count = df_result_activity_count_filtered.pivot_table(index = '_case_concept_name_', columns = '_event_concept_name_', aggfunc = len, fill_value = 0)

pd.merge(df_result,df_case_activity_count,on='_case_concept_name_')

# Drop the eventID and case_concept_name columns
df_result = df_result.drop(['_case_concept_name_'],axis = 1)

# Set the X and Y parameters for predictor and response variables
X = df_result.drop(['is_compliant'],axis = 1)
X_Categorical = X.filter(['_case_Document_Type_','_case_Item_Category_','_case_Spend_classification_text_','_case_Item_Type_','_case_Sub_spend_area_text_'])
x_numerical_columns = ['number_of_handovers','count_rework','material_count','sod_create_poi_and_gr','sod_create_poi_and_ir','Sum_IR','Sum_GR','CreateOrder_NetVal','GR_NetVal','IR_NetVal','Deviation','CancelGR_NetValue','CancelIR_NetValue']
X_Numerical = X.filter(x_numerical_columns ).values

y = df_result.filter(['is_compliant'])

pd.get_dummies(X_Categorical.iloc[:,0:4],prefix = X_Categorical.columns.values)
# Encoding categorical data
# Encoding the Independent Variable
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
X_CategoricalEncoded = onehotencoder.fit_transform(X_Categorical).toarray()

#Concatenation of the categorical and numerical dimensions
X_total = np.concatenate((X_Categorical,X_Numerical),axis=1)
categorical_column_names = list(onehotencoder.get_feature_names(X_Categorical.columns.values))
feature_names = x_numerical_columns + categorical_column_names

## Encoding the Dependent Variable
#labelencoder_y = LabelEncoder()
#y = labelencoder_y.fit_transform(y)


# Splitting the dataset into the Training set and Test set
from sklearn.model_selection import train_test_split
X_train, X_test, y_train, y_test = train_test_split(X_total, y, test_size = 0.20, random_state = 0)

# Feature Scaling
from sklearn.preprocessing import StandardScaler
sc = StandardScaler()
X_train = sc.fit_transform(X_train)
X_test = sc.transform(X_test)

# Fitting classifier to the Training set
from sklearn.tree import DecisionTreeClassifier
classifier = DecisionTreeClassifier(criterion = 'entropy',
                                    random_state = 0)
classifier.fit(X_train, y_train)

# Predicting the Test set results
y_pred = classifier.predict(X_test)

# Making the Confusion Matrix
from sklearn.metrics import confusion_matrix,accuracy_score
cm = confusion_matrix(y_test, y_pred)
acc = accuracy_score(y_test,y_pred)


from graphviz import Source, render

from sklearn.externals.six import StringIO  
from IPython.display import Image  
from sklearn.tree import export_graphviz
import pydotplus



dot_data = StringIO()

export_graphviz(classifier, out_file=dot_data,  
                filled=True, rounded=True,
                special_characters=True)

graph = pydotplus.graph_from_dot_data(dot_data.getvalue())  
Image(graph.create_png())
X_Categorical.columns.values


