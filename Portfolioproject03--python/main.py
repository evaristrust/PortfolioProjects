#This is not part of my project
#It's the addition learning tip on how to read and write in the google spreadsheet
# importing the required libraries
import gspread
import pandas as pd
from oauth2client.service_account import ServiceAccountCredentials

from googleapiclient.discovery import build
from google.oauth2 import service_account

SERVICE_ACCOUNT_FILE = 'keys.json'
# If modifying these scopes, delete the file token.json.
SCOPES = ['https://www.googleapis.com/auth/spreadsheets']

creds = None
creds = service_account.Credentials.from_service_account_file(
        SERVICE_ACCOUNT_FILE, scopes=SCOPES)

# The ID spreadsheet.
MY_SPREADSHEET_ID = '1cUJDTyyz-P8HcVIqfeGszODFppu_vbpVCH-gdxP8SI4'
service = build('sheets', 'v4', credentials=creds)

# Call the Sheets API
sheet = service.spreadsheets()
results = sheet.values().get(spreadsheetId=MY_SPREADSHEET_ID,
                            range='responses!A1:AI4101').execute()
# values = results.get('values', [])

print(results)
