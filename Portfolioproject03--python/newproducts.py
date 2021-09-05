import pandas as pd
import walter
from walter import df_frame
"""
columns:  'time_stamp', 'action', 'new_purchase_name', 'quantity_new_purchase', 'case_new_purchase?', 'new_purchase_unit_priced',
'new_purchase_total'
"""

new_df = df_frame[['time_stamp', 'action', 'new_purchase_name', 'quantity_new_purchase',
                       'case_new_purchase?', 'new_purchase_unit_priced', 'new_purchase_total']]

#analyse paid services == 'Kwishyura Serivice'
new_action = new_df[new_df['action'] == 'Kurangura igicuruzwa gishya'].reset_index(0)

#Change the dtype in new_purchase_total column from object to int
new_total_col = new_action['new_purchase_total']
new_total_col = pd.to_numeric(new_total_col)

#checking the total of new purchased products up to date
total_new =  new_action['new_purchase_total'].sum()
