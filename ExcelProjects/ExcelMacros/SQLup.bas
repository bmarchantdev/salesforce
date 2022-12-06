
Sub ImportADODB()
   Dim cn As ADODB.Connection
   Set cn = New ADODB.Connection
End Sub

Sub SendExcelDataToSQL()

    ' Declare variables for the SQL server, database, and table where the data will be sent
    Dim SQL_Server As String
    Dim SQL_Database As String
    Dim SQL_Table As String
    
    ' Set the values for the SQL server, database, and table where the data will be sent
    SQL_Server = "Enter the name of your SQL server here"
    SQL_Database = "Enter the name of your SQL database here"
    SQL_Table = "Enter the name of your SQL table here"
    
    ' Create a connection to the SQL server and database
    Dim cn As ADODB.Connection
    Set cn = New ADODB.Connection
    cn.Open "Provider=SQLOLEDB;Data Source=" & SQL_Server & ";Initial Catalog=" & SQL_Database & ";Integrated Security=SSPI;"
    
    ' Create a recordset based on the active worksheet in Excel
    Dim rs As ADODB.Recordset
    Set rs = New ADODB.Recordset
    rs.Open ActiveSheet.UsedRange, cn, adOpenKeyset, adLockOptimistic
    
    ' Loop through the recordset and insert each row into the SQL table
    Do While Not rs.EOF
       cn.Execute "INSERT INTO " & SQL_Table & " VALUES(" & rs.Fields(0) & ", " & rs.Fields(1) & ", " & rs.Fields(2) & ", ...)"
       rs.MoveNext
    Loop
    
    ' Close the recordset and connection
    rs.Close
    cn.Close
    
End Sub
    