// Step 1: Authenticate with Salesforce and obtain an access token
// Replace {user_id} with the ID of the user whose username you want to retrieve, and {access_token} with the access token
// Need to automate above ^
GET https://your-salesforce-instance.salesforce.com/services/data/v48.0/sobjects/User/{user_id}
Authorization: Bearer {access_token}

// Step 2: Use the describeGlobal() method to retrieve a list of all objects in your Salesforce instance
String describeGlobalURL = 'https://your-salesforce-instance.salesforce.com/services/data/v48.0/sobjects';
HttpResponse describeGlobalResponse = Http.send(new HttpRequest()
    .setMethod('GET')
    .setEndpoint(describeGlobalURL)
    .setHeader('Authorization', 'Bearer ' + accessToken)
);

// Parse the response to retrieve the list of objects
Map<String, Object> describeGlobalResponseMap = (Map<String, Object>)JSON.deserializeUntyped(describeGlobalResponse.getBody());
List<Object> sobjects = (List<Object>)describeGlobalResponseMap.get('sobjects');

// Step 3: For each object in the list, use the describeObjects() method to retrieve a description of the object and its fields
List<Map<String, Object>> objectList = new List<Map<String, Object>>();
for (Object sobject : sobjects) {
    // Retrieve the object name and make a request to the describeObjects() method
    Map<String, Object> sobjectMap = (Map<String, Object>)sobject;
    String objectName = (String)sobjectMap.get('name');
    String describeObjectURL = 'https://your-salesforce-instance.salesforce.com/services/data/v48.0/sobjects/' + objectName + '/describe';
    HttpResponse describeObjectResponse = Http.send(new HttpRequest()
        .setMethod('GET')
        .setEndpoint(describeObjectURL)
        .setHeader('Authorization', 'Bearer ' + accessToken)
    );

    // Parse the response to retrieve the object description and its fields
    Map<String, Object> describeObjectResponseMap = (Map<String, Object>)JSON.deserializeUntyped(describeObjectResponse.getBody());
    Map<String, Object> objectInfo = new Map<String, Object>();
    objectInfo.put('name', objectName);
    objectInfo.put('fields', describeObjectResponseMap.get('fields'));

    // Add the object info to the list
    objectList.add(objectInfo);
}

// Step 4: Store the object and field information in a data structure, such as a list or a map
Map<String, List<Map<String, Object>>> objectMap = new Map<String
