import pandas as pd
import walter
from walter import df_frame
"""
columns:  'time_stamp', 'action', 'product_purchase_name',
'quantity_purchase', 'case_purchase?', 'unit_purchase_price', 'total_purchase_price'
"""

purchase_df = df_frame[['time_stamp', 'action', 'product_purchase_name',
                                     'quantity_purchase', 'case_purchase?', 'unit_purchase_price',
                                     'total_purchase_price']]

#analyse the purchase (Kurangura)
purchase_action = purchase_df[purchase_df['action'] == 'Kurangura'].reset_index(0)

#Change the dtype in total purchase column from object to int
purchase_total_col = purchase_action['total_purchase_price']
purchase_total_col = pd.to_numeric(purchase_total_col)

#Group by product_purchase_name with the total_purchase_price
product_name_group = purchase_action.groupby('product_purchase_name')['total_purchase_price'].sum()

#Check the most purchased product
product_name_group_high = product_name_group.sort_values(ascending=False)
# print(product_name_group_high)

#checking the total purchase up to date
total_purchase =  purchase_action['total_purchase_price'].sum()
# print(total_purchase)
