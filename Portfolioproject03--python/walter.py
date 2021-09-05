# importing the required libraries
import gspread
import pandas as pd
from pandas import Series, DataFrame
from oauth2client.service_account import ServiceAccountCredentials

# define the scope
scope = ['https://spreadsheets.google.com/feeds','https://www.googleapis.com/auth/drive']

# add credentials to the account
creds = ServiceAccountCredentials.from_json_keyfile_name('keys.json', scope)

# authorize the clientsheet
client = gspread.authorize(creds)

# get the instance of the Spreadsheet
sheet = client.open('CHEZ WALTER')

# get the first sheet of the Spreadsheet
my_sheet = sheet.get_worksheet(0)

#access the number of columns
# cols = my_sheet.col_count
# print(cols)

#Get all records of the sheet
sheet_records = my_sheet.get_all_records()
# print(sheet_records) #this will print dictionary

#change the dictionary into a Dataframe
df_frame = pd.DataFrame.from_dict(sheet_records)

#setting new columns names
my_columns = [

    'time_stamp', 'action', 'product_sold_name', 'quantity_sold',
    'case_sold?', 'unit_sell_price', 'total_sell_price', 'product_purchase_name',
    'quantity_purchase', 'case_purchase?', 'unit_purchase_price', 'total_purchase_price',
    'new_purchase_name', 'quantity_new_purchase', 'case_new_purchase?', 'new_purchase_unit_priced',
    'new_purchase_total', 'tool_name', 'tool_quantity', 'case_tool?', 'tool_unit_price',
    'tool_total_price', 'product_credited', 'product_cred_quantity', 'product_cred_case?',
    'product_cred_unit_price', 'product_cred_total', 'debtor_name', 'payer_name', 'credit_balance',
    'total_repay', 'service_name', 'service_amount', 'control_amount', 'withdraw', 'wreceipt_no', 'deposit', 'dreceipt_no', 'dmaged_product_name', 'amount_dmaged'
]

#setting axis into our dataframe for better readability
#Original names of the columns in the df are in the local language that the form filler understands
#The new columns names are for the ease of data analysis using English... Quite a simple translation haha right?
df_frame.set_axis(my_columns, axis='columns', inplace=True)

#drop the new entries that was entered for trial and reset the index
df_frame = df_frame.drop([74, 75]).reset_index(drop=True)#ideni japhet and kurangura urwagwa...
