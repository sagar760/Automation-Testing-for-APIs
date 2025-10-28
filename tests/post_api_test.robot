*** Settings ***
Library    RequestsLibrary
Library    Collections

*** Variables ***
${BASE_URL}    https://reqres.in
${API_KEY}     reqres-free-v1

*** Test Cases ***

Create New User - Valid Data
    [Documentation]    Verify that a new user is created successfully with valid data.
    Create Session    reqres    ${BASE_URL}    headers={"x-api-key":"${API_KEY}"}    verify=False
    ${data}=    Create Dictionary    name=John    job=Engineer
    ${response}=    POST On Session    reqres    /api/users    json=${data}
    Should Be Equal As Integers    ${response.status_code}    201
    Dictionary Should Contain Key    ${response.json()}    id
    Log To Console    ${response.json()}

Create New User - Empty Body
    [Documentation]    Verify behavior when sending an empty JSON body.
    Create Session    reqres    ${BASE_URL}    headers={"x-api-key":"${API_KEY}"}    verify=False
    ${data}=    Create Dictionary
    ${response}=    POST On Session    reqres    /api/users    json=${data}
    Should Be Equal As Integers    ${response.status_code}    201
    Log To Console    ${response.json()}

Create New User - Missing Job
    [Documentation]    Verify API behavior when 'job' field is missing.
    Create Session    reqres    ${BASE_URL}    headers={"x-api-key":"${API_KEY}"}    verify=False
    ${data}=    Create Dictionary    name=Alice
    ${response}=    POST On Session    reqres    /api/users    json=${data}
    Should Be Equal As Integers    ${response.status_code}    201
    Log To Console    ${response.json()}

Create New User - Invalid Data Type
    [Documentation]    Verify API behavior when invalid data types are sent.
    Create Session    reqres    ${BASE_URL}    headers={"x-api-key":"${API_KEY}"}    verify=False
    ${data}=    Create Dictionary    name=12345    job=9999
    ${response}=    POST On Session    reqres    /api/users    json=${data}
    Should Be Equal As Integers    ${response.status_code}    201
    Log To Console    ${response.json()}

Create New User - Invalid Endpoint
    [Documentation]    Verify API behavior when invalid endpoint is used.
    Create Session    reqres    ${BASE_URL}    headers={"x-api-key":"${API_KEY}"}    verify=False
    ${data}=    Create Dictionary    name=John    job=Engineer
    ${response}=    POST On Session    reqres    /api/userz    json=${data}
    Should Be Equal As Integers    ${response.status_code}    404

Create New User - Without API Key
    [Documentation]    Verify unauthorized request returns an error.
    Create Session    reqres    ${BASE_URL}    verify=False
    ${data}=    Create Dictionary    name=John    job=Engineer
    ${response}=    POST On Session    reqres    /api/users    json=${data}
    Log To Console    ${response.json()}
    Dictionary Should Contain Key    ${response.json()}    error

Create New User - Large Payload
    [Documentation]    Verify API can handle a large payload.
    Create Session    reqres    ${BASE_URL}    headers={"x-api-key":"${API_KEY}"}    verify=False
    ${large_data}=    Evaluate    'A' * 1000
    ${data}=    Create Dictionary    name=John    job=${large_data}
    ${response}=    POST On Session    reqres    /api/users    json=${data}
    Should Be Equal As Integers    ${response.status_code}    201
    Log To Console    ${response.json()}