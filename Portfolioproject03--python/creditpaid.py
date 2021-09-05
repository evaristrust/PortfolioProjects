import pandas as pd
import walter
from walter import df_frame
from creditout import total_credits
from creditout import cred_action
"""
columns:  'time_stamp', 'action', 'payer_name', 'credit_balance', 'total_repay'
"""
#Study of credits given out
cred_paid_df = df_frame[[ 'time_stamp', 'action', 'payer_name', 'credit_balance', 'total_repay']]

#analyse rows containing the credit repayment
cred_paid_action = cred_paid_df[cred_paid_df['action'] == 'Kwishyura ideni'].reset_index(0)

#Change total repay column dtype from object to int
repaid_col = cred_paid_action['total_repay']
repaid_col = pd.to_numeric(repaid_col)

#Get the total business credit on products
total_credits_repaid = repaid_col.sum()
total_imported = repaid_col.sum() # to be imported in sales

#create a function to allow more credit or not
#total_credits = the sum of all credits given out
#max_credit = the limit credit amount we can have in entirely in the business
#unpaid_credit = the difference btn total_credits and repaid credits
#absolute_extra = the absolute value of the difference btn max_credit and unpaid_credit
#(it can be negative or positive)
def allow_cred():
    max_credit = 15000
    unpaid_credit = total_credits - total_credits_repaid # difference btn credits and repaid credit (balance)
    absolute_extra = abs(max_credit - unpaid_credit)
    if unpaid_credit < max_credit:
        print('You are allowed to give credits of no more than {}RWF'.format(absolute_extra))
    else:
        print('No, you can\'t give credits... Reached maximum with extra amount of {}RWF'.format(absolute_extra))
    print('Your unpaid credit is {}RWF'.format(unpaid_credit))

allow_cred()

#Group by debtor_names with their credits paid, and balance and sort sum in descending
#set to_frame and rename the  product_cred_total to total and debtor_name to name
#descending order will show us those who ever took the huge debts
print('--'*20,'TOTAL CREDITS BY DEBTOR NAMES','--'*20)
debtors = cred_action.groupby(['debtor_name'], as_index=False)['product_cred_total'].sum()
debtors.rename(columns={'product_cred_total': 'Total Credit', 'debtor_name': 'Names'}, inplace=True)
debtors.index.name = 'Indices'
print(debtors.sort_values(by='Total Credit', ascending=False))

#Do the same for the credit repayment
print('\n','--'*20,'TOTAL PAYMENT BY DEBTOR NAMES','--'*20)
debt_payers = cred_paid_action.groupby(['payer_name'], as_index=False)['total_repay'].sum()
debt_payers.rename(columns={'total_repay': 'Total Repaid', 'payer_name': 'Names'}, inplace=True)
debt_payers.index.name = 'Indices'
print(debt_payers.sort_values(by='Total Repaid',ascending=False))
