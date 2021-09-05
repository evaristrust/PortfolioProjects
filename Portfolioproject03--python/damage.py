import pandas as pd
import walter
from walter import df_frame
"""
columns:  'time_stamp', 'action', 'dmaged_product_name', 'amount_dmaged'
"""

damage_df = df_frame[['time_stamp', 'action', 'dmaged_product_name', 'amount_dmaged']]

#analyse damaged products == 'Ibyangiritse'
damage_action = damage_df[damage_df['action'] == 'Ibyangiritse'].reset_index(0)

#Change the dtype in amount damaged column from object to int
damage_total_col = damage_action['amount_dmaged']
damage_total_col = pd.to_numeric(damage_total_col)

#Group by dmaged_product_name with amount_dmaged
dmaged_product_name_group = damage_action.groupby('dmaged_product_name')['amount_dmaged'].sum()

#Check the most services paid
dmaged_product_name_group_high = dmaged_product_name_group.sort_values(ascending=False)
# print(dmaged_product_name_group_high)

#checking the total service up to date
total_damaged =  damage_action['amount_dmaged'].sum()
# print(total_damaged)
