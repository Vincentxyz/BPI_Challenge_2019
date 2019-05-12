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

event_consolidated_dimensions = db.Table('event_consolidated_dimensions',metadata,autoload = True, autoload_with=engine)

def FetchDatabaseTable(con,table_name):

    ResultProxy= con.execute(db.select([table_name]))
    ResultSet = ResultProxy.fetchall()
    return ResultSet;

#Fetch the consolidated dimensions table
result = FetchDatabaseTable(con,event_consolidated_dimensions)
df_result = pd.DataFrame(result)
df_result.columns = result[0].keys()

# Drop the eventID and case_concept_name columns
df_result = df_result.drop(['_eventID__','_case_concept_name_'],axis = 1)

# Set the X and Y parameters for predictor and response variables
X = df_result.drop(['is_compliant'],axis = 1).values
y = df_result.filter(['is_complaint']).values

# Encoding categorical data
# Encoding the Independent Variable
from sklearn.preprocessing import LabelEncoder, OneHotEncoder

labelencoder_event_concept_name = LabelEncoder()
X['_event_concept_name_'] = labelencoder_event_concept_name.fit_transform(X['_event_concept_name_'])

labelencoder_event_User = LabelEncoder()
X['_event_User_'] = labelencoder_event_User.fit_transform(X['_event_User_'])

labelencoder_event_spend_text = LabelEncoder()
X['_case_Spend_classification_text_'] = labelencoder_event_spend_text.fit_transform(X['_case_Spend_classification_text_'])

labelencoder_item_type = LabelEncoder()
X['_case_Item_Type_'] = labelencoder_item_type.fit_transform(X['_case_Item_Type_'])

labelencoder_Sub_spend_area_text = LabelEncoder()
X['_case_Sub_spend_area_text_'] = labelencoder_Sub_spend_area_text.fit_transform(X['_case_Sub_spend_area_text_'])

labelencoder_case_Name = LabelEncoder()
X['_case_Name_'] = labelencoder_case_Name.fit_transform(X['_case_Name_'])

labelencoder_case_Vendor_ = LabelEncoder()
X['_case_Vendor_'] = labelencoder_case_Vendor_.fit_transform(X['_case_Vendor_'])

labelencoder_case_Document_Type = LabelEncoder()
X['_case_Document_Type_'] = labelencoder_case_Document_Type.fit_transform(X['_case_Document_Type_'])

labelencoder_case_Item_Category = LabelEncoder()
X['_case_Item_Category_'] = labelencoder_case_Item_Category.fit_transform(X['_case_Item_Category_'])



onehotencoder = OneHotEncoder(categorical_features = [0])
X = onehotencoder.fit_transform(X).toarray()


# Encoding the Dependent Variable
labelencoder_y = LabelEncoder()
y = labelencoder_y.fit_transform(y)


# Encoding categorical data
# Encoding the Independent Variable
from sklearn.preprocessing import LabelEncoder, OneHotEncoder
labelencoder_X = LabelEncoder()

X[:, 0] = labelencoder_X.fit_transform(X[:, 0])
onehotencoder = OneHotEncoder(categorical_features = [0])
X = onehotencoder.fit_transform(X).toarray()
# Encoding the Dependent Variable
labelencoder_y = LabelEncoder()
y = labelencoder_y.fit_transform(y)


