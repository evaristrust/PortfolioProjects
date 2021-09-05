import pandas as pd
import walter
from walter import df_frame
"""
columns:  'time_stamp', 'action', 'tool_name', 'tool_quantity', 'case_tool?', 'tool_unit_price',
'tool_total_price'
"""

tools_df = df_frame[['time_stamp', 'action', 'tool_name', 'tool_quantity', 'case_tool?',
                        'tool_unit_price','tool_total_price']]

#analyse tools that were purchased for work action == 'Kugura igikoresho'
tools_action = tools_df[tools_df['action'] == 'Kugura igikoresho'].reset_index(0)

#Change the dtype in tools column from object to int
tools_total_col = tools_action['tool_total_price']
tools_total_col = pd.to_numeric(tools_total_col)

#Group by tool_name with the tool_total_price
tool_name_group = tools_action.groupby('tool_name')['tool_total_price'].sum()

#Check the most purchased product
tool_name_group_high = tool_name_group.sort_values(ascending=False)
# print(tool_name_group_high)

#checking the total purchase up to date
funded_cash = 9000 + 3000 + 2500 + 2000  #remove cash that received from outside
total_tools =  tools_action['tool_total_price'].sum() - funded_cash
# print(total_tools)
