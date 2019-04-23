# Importing the libraries
import numpy as np
import sqlalchemy as db
import pandas as pd


# Build database connection

engine = db.create_engine('mssql+pyodbc://adminuser:Yxcvbnm@123@arpbpi.database.windows.net/ProMi?driver=ODBC+Driver+17+for+SQL+Server')
con = engine.connect()
metadata = db.MetaData(schema = 'PTP')

# Get Clusters table from database

clusters = db.Table('Clusters_04_Consignment',metadata,autoload = True, autoload_with=engine)
ResultProxy= con.execute(db.select([clusters]))
ResultSet = ResultProxy.fetchall()
df_clusters = pd.DataFrame(ResultSet)
df_clusters.columns = ResultSet[0].keys()

# Decision Tree

# Cutting irrelevant columns

df_clusters = df_clusters.iloc[:, [1,2,3,4,6,10,11,12,13,16]]


# Encoding categorical data
# Encoding the Independent Variable
from sklearn.preprocessing import LabelEncoder, OneHotEncoder
from collections import defaultdict
 
d = defaultdict(LabelEncoder)
# Encoding the variable
df_clusters_encoded = df_clusters.apply(lambda x: d[x.name].fit_transform(x))
 


 

# Creating Train and Test Set
X = df_clusters_encoded.iloc[:, 0:9].values
y = df_clusters_encoded.iloc[:, 9].values

#One-hot encoding
onehotencoder = OneHotEncoder(categorical_features = "all")
X = onehotencoder.fit_transform(X).toarray()


# Splitting the dataset into the Training set and Test set
from sklearn.cross_validation import train_test_split
X_train, X_test, y_train, y_test = train_test_split(X, y, test_size = 0.2, random_state = 0)


# Fitting classifier to the Training set
from sklearn.tree import DecisionTreeClassifier,export_graphviz
classifier = DecisionTreeClassifier(criterion = 'gini', max_depth = 4, max_features=3)
classifier.fit(X_train, y_train)

# Predicting the Test set results
y_pred = classifier.predict(X_test)

# Making the Confusion Matrix
from sklearn.metrics import confusion_matrix
cm = confusion_matrix(y_test, y_pred)

export_graphviz(classifier,out_file='tree.dot')

from graphviz import Source, render

render('dot','png','tree.dot')

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

