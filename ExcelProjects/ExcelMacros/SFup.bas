import simple_salesforce 
import openpyx1

Sub SFup()

    username = "Enter your salesforce username here."
    password = "Enter your salesforce password here."
    security_token = "Enter your salesforce security_token here."

    sf = simple_salesforce.Salesforce(username=username, password=password, security_token=security_token)

    # Open the Excel workbook and retrieve the data range
    wb = openpyxl.load_workbook("C:\\path\\to\\workbook.xlsx")
    ws = wb.active
    data = ws.values

    # Loop through the data range and insert each row into the custom object in Salesforce
    for row in data:
    sf.CustomObject__c.create(
        Field1__c = row[0],
        Field2__c = row[1],
        Field3__c = row[2],
        ...
    )

End Sub