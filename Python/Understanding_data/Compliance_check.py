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

# Get Clusters table from database

case_compliance = db.Table('case_compliance',metadata,autoload = True, autoload_with=engine)
ResultProxy= con.execute(db.select([case_compliance]))
ResultSet = ResultProxy.fetchall()
df_case_compliance = pd.DataFrame(ResultSet)
df_case_compliance.columns = ResultSet[0].keys()

# Divide into cases with one vs. multiple GRs/Invoices
multi_inv = df_case_compliance.loc[df_case_compliance['Sum_IR'] > 1]

sn.distplot(multi_inv['is_compliant'],axlabel='Compliance of cases, when checking that the sum of invoices/GRs is equal to the PO item worth')

