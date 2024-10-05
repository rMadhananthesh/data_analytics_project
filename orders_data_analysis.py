!pip install kaggle
import kaggle
!kaggle datasets download ankitbansal06/retail-orders -f orders.csv

from sqlalchemy import create_engine 
!pip install sqlalchemy pymysql


import zipfile
zip_ref = zipfile.ZipFile('orders.csv.zip') 
zip_ref.extractall() # extract file to dir
zip_ref.close() 

import pandas as pd

data=pd.read_csv('orders.csv',na_values=['Not Available','unknown'])
data['Ship Mode'].unique()
data.head(15)

data.rename(columns={'Order Id':'order_id'})

data.columns=data.columns.str.lower()
data.columns=data.columns.str.replace(' ','_')

data['discount']=data['list_price']*data['discount_percent']*.01
data.head()

data['sale_price']=data['list_price']-data['discount']
data.head()

data['profit']=data['sale_price']-data['cost_price']
data.head()

data.dtypes
data['order_date']=pd.to_datetime(data['order_date'],format='%d-%m-%Y')
data.head()

data.drop(columns=['list_price','discount_percent','cost_price'],inplace=True)
data


user = "root" 
password = "root" 
host = "localhost"  
db_name = 'project1' 
port = 3306 
sqlEngine       = create_engine(f'mysql+pymysql://{user}:{password}@{host}/{db_name}', pool_recycle=port)
dbConnection    = sqlEngine.connect() 

query = 'SELECT * FROM t1'
df = pd.read_sql(query, sqlEngine)


data.to_sql('df_orders',con=dbConnection,index=False)



















