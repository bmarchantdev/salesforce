// Set the target Salesforce Sandbox instance
String sandboxInstance = 'https://test.salesforce.com';

// Set the Salesforce Production instance
String productionInstance = 'https://login.salesforce.com';

// Set the credentials for the Salesforce Production instance
String username = 'Bmarchant@nymtrust.com';
String password = 'password';

// Set the query to use to retrieve the records to transfer
String query = 'SELECT Id, Name FROM Account';

// Set the batch size for the query
Integer batchSize = 200;

// Authenticate with the Salesforce Production instance
System.debug('Authenticating with Salesforce Production...');
Auth.UsernamePassword auth = new Auth.UsernamePassword(username, password);

// Use the Partner API to access the Salesforce Production instance
Partner.SoapPort port = new Partner.SoapPort();
port.endpoint_x = productionInstance + '/services/Soap/u/42.0';
port.SessionHeader = new Partner.SessionHeader_element();
port.SessionHeader.sessionId = auth.getSessionId();

// Query for the records to transfer
System.debug('Querying for records to transfer...');
Partner.QueryResult result = port.query(query);

// Process the query results in batches
System.debug('Processing query results...');
Boolean done = false;
List<Partner.sObject> records = new List<Partner.sObject>();
while (!done) {
    records.clear();
    for (Integer i = 0; i < batchSize && i < result.records.size(); i++) {
        records.add(result.records[i]);
    }

    // Transfer the records to the Salesforce Sandbox instance
    System.debug('Transfering batch of records to Salesforce Sandbox...');
    Partner.SoapPort sandboxPort = new Partner.SoapPort();
    sandboxPort.endpoint_x = sandboxInstance + '/services/Soap/u/42.0';
    sandboxPort.SessionHeader = new Partner.SessionHeader_element();
    sandboxPort.SessionHeader.sessionId = auth.getSessionId();
    sandboxPort.create(records);

    // Check if there are more records to process
    if (result.done) {
        done = true;
    } else {
        result = port.queryMore(result.queryLocator);
    }
}