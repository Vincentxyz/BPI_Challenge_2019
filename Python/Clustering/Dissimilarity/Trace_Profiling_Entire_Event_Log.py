import pandas as pd
import numpy as np
from sklearn.metrics.pairwise import euclidean_distances
import sqlalchemy as db



def calculate_wss(df):
    df_pivot = df.pivot_table(index = '_case_concept_name_', columns = '_event_concept_name_', aggfunc= len, fill_value = 0)
    
    center = []
    
    for i in range(0,len(df_pivot.columns)):
        center.append(np.mean(df_pivot.iloc[:,i]))
        
    df_center = pd.DataFrame(center).transpose()
    
    dist = euclidean_distances(X = df_pivot, Y = df_center)
    dist_squared = np.power(dist, 2)
    wss = np.sum(dist_squared)
    return wss

# Load the data from database
    
# Build database connection

engine = db.create_engine('mssql+pyodbc://adminuser:Yxcvbnm@123@arpbpi.database.windows.net/ProMi?driver=ODBC+Driver+17+for+SQL+Server')
con = engine.connect()
metadata = db.MetaData(schema = 'PROM')

# Get event log from database

table = db.Table('Event_Log_All',metadata,autoload = True, autoload_with=engine)
ResultProxy= con.execute(db.select([table]))
ResultSet = ResultProxy.fetchall()
df_export = pd.DataFrame(ResultSet)
df_export.columns = ResultSet[0].keys()


#df_export = pd.read_csv('C:/Users/DEVMEYE3/Documents/Master/BPI Challenge 2019/Exports/CLUSTER_02_02_compliant_INV_before_GR_without_SRM.txt', sep = ',', encoding = 'utf-8')


df_total = df_export.filter(items = ['_case_concept_name_', '_event_concept_name_'])

# Calculate total within-sum-of-squares

wss_total = calculate_wss(df_total)


# Split into companies
    
df_companyID_0000 = df_total[df_export._case_Company_ == 'companyID_0000']
df_companyID_0001 = df_total[df_export._case_Company_ == 'companyID_0001']
df_companyID_0003 = df_total[df_export._case_Company_ == 'companyID_0003']

wss_company = 0

if df_companyID_0000.empty == False:
    wss_company += calculate_wss(df_companyID_0000)
    
if df_companyID_0001.empty == False:
    wss_company += calculate_wss(df_companyID_0001)
    
if df_companyID_0003.empty == False:
    wss_company += calculate_wss(df_companyID_0003)
    
    

# Split into document types
    
df_framework_order = df_total[df_export._case_Document_Type_ == 'Framework order']
df_standard_po = df_total[df_export._case_Document_Type_ == 'Standard PO']
df_ec_purchase_order = df_total[df_export._case_Document_Type_ == 'EC Purchase order']

wss_document_type = 0

if df_framework_order.empty == False:
    wss_document_type += calculate_wss(df_framework_order)
    
if df_standard_po.empty == False:
    wss_document_type += calculate_wss(df_standard_po)
    
if df_ec_purchase_order.empty == False:
    wss_document_type += calculate_wss(df_ec_purchase_order)

# Split into spend classification
    
df_npr = df_total[df_export._case_Spend_classification_text_ == 'NPR']
df_pr = df_total[df_export._case_Spend_classification_text_ == 'PR']
df_other = df_total[df_export._case_Spend_classification_text_ == 'OTHER']
df_empty = df_total[df_export._case_Spend_classification_text_ == '']

wss_spend_classification = 0

if df_npr.empty == False:
    wss_spend_classification += calculate_wss(df_npr)
    
if df_pr.empty == False:
    wss_spend_classification += calculate_wss(df_pr)
    
if df_other.empty == False:
    wss_spend_classification += calculate_wss(df_other)
    
if df_empty.empty == False:
    wss_spend_classification += calculate_wss(df_empty)
    
    
    
# Split into item type
    
df_standard = df_total[df_export._case_Item_Type_ == 'Standard']
df_third_party = df_total[df_export._case_Item_Type_  == 'Third-party']
df_subcontracting = df_total[df_export._case_Item_Type_  == 'Subcontracting']
df_service = df_total[df_export._case_Item_Type_  == 'Service']
df_consignment = df_total[df_export._case_Item_Type_  == 'Consignment']
df_limit = df_total[df_export._case_Item_Type_  == 'Limit']

wss_item_type = 0

if df_standard.empty == False:
    wss_item_type += calculate_wss(df_standard)
    
if df_third_party.empty == False:
    wss_item_type += calculate_wss(df_third_party)
    
if df_subcontracting.empty == False:
    wss_item_type += calculate_wss(df_subcontracting)
    
if df_service.empty == False:
    wss_item_type += calculate_wss(df_service)
    
if df_consignment.empty == False:
    wss_item_type += calculate_wss(df_consignment)

if df_limit.empty == False:
    wss_item_type += calculate_wss(df_limit)






# Summary

print('Total WSS: \t\t\t\t' + str(wss_total))
print('Company WSS: \t\t\t\t' + str(wss_company))
print('Document Type WSS: \t\t\t\t' + str(wss_document_type))
print('Spend_classification split WSS: \t' + str(wss_spend_classification))
print('Item Type WSS: \t\t\t\t' + str(wss_item_type))





