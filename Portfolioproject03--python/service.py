import pandas as pd
import walter
from walter import df_frame
"""
columns:  'time_stamp', 'action', 'service_name', 'service_amount'
"""

service_df = df_frame[['time_stamp', 'action', 'service_name', 'service_amount']]

#analyse paid services == 'Kwishyura Serivice'
service_action = service_df[service_df['action'] == 'Kwishyura Serivice'].reset_index(0)

#Change the dtype in serive amount column from object to int
service_total_col = service_action['service_amount']
service_total_col = pd.to_numeric(service_total_col)

#Group by service_name with service_amount
service_name_group = service_action.groupby('service_name')['service_amount'].sum()

#Check the most services paid
service_name_group_high = service_name_group.sort_values(ascending=False)
# print(service_name_group_high)

#checking the total service up to date
funded_cash = 88000 #remove cash paid not from sales [house rent and ipatante]
total_service =  service_action['service_amount'].sum() - funded_cash
# print(service_action)
