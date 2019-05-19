#%%
import numpy as np
import sqlalchemy as db
import pandas as pd

engine = db.create_engine(
    'mssql+pyodbc://adminuser:Yxcvbnm@123@arpbpi.database.windows.net/ProMi?driver=ODBC+Driver+17+for+SQL+Server')
con = engine.connect()
metadata = db.MetaData(schema='DIM')

event_handover = db.Table('event_handover_of_work', metadata, autoload=True, autoload_with=engine)


def FetchDatabaseTable(connection, db_table):
    result_proxy = connection.execute(db.select([db_table]))
    result_set = result_proxy.fetchall()
    return result_set;

df = pd.DataFrame(FetchDatabaseTable(con, event_handover)) # type: pd.DataFrame

#%%
# sort by case_id and event_id
df = df.sort_values([2, 0])
df = df.reset_index(drop=True) # type: pd.DataFrame
backup = df.copy(deep=True)

#%%
# helper function
def compare_user(old_user, current_user):
    if 'user' in old_user and 'user' in current_user and old_user != current_user:
        return True
    else:
        return False

#%%
# algorithm for counting
old_user = df.iloc[0,3]
old_case_ID = df.iloc[0,2]
count = 0

for row in df.itertuples(index=True):
    index = row[0]
    current_user = row[4]
    current_case_ID = row[3]

    if old_case_ID == current_case_ID:
        if compare_user(old_user, current_user):
            count = count + 1
    else:
        old_case_ID = current_case_ID
        count = 0

    df.at[index, 4] = count
    old_user = current_user
    if index % 5000 == 0:
        print('you are at row ' + str(index))


#%%
# output to csv
df.to_csv(your_csv_filepath, index=False) # replace your_csv_file_path with a string ending with '.csv'