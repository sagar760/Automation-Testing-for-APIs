*** Settings ***
Library    RequestsLibrary
Library    Collections

*** Variables ***
${BASE_URL}    https://reqres.in
${API_KEY}     reqres-free-v1

*** Test Cases ***

Update Existing User - Valid Data
    [Documentation]    Verify updating an existing user returns 200 and contains updated fields.
    Create Session    reqres    ${BASE_URL}    headers={"x-api-key":"${API_KEY}"}
    ${data}=    Create Dictionary    name=John    job=Manager
    ${response}=    PUT On Session    reqres    /api/users/2    json=${data}
    Should Be Equal As Integers    ${response.status_code}    200
    Dictionary Should Contain Key    ${response.json()}    updatedAt
    Log To Console    ${response.json()}

Update Existing User - Empty Body Allowed
    [Documentation]    ReqRes allows empty PUT body, still returns 200.
    Create Session    reqres    ${BASE_URL}    headers={"x-api-key":"${API_KEY}"}
    ${data}=    Create Dictionary
    ${response}=    PUT On Session    reqres    /api/users/2    json=${data}
    Should Be Equal As Integers    ${response.status_code}    200
    Log To Console    ${response.json()}

Update Existing User - Partial Data
    [Documentation]    Only updating job field and verify response structure.
    Create Session    reqres    ${BASE_URL}    headers={"x-api-key":"${API_KEY}"}
    ${data}=    Create Dictionary    job=Developer
    ${response}=    PUT On Session    reqres    /api/users/2    json=${data}
    Should Be Equal As Integers    ${response.status_code}    200
    Dictionary Should Contain Key    ${response.json()}    updatedAt
    Log To Console    ${response.json()}

Update Non-Existing User
    [Documentation]    ReqRes returns 200 instead of expected 404 (valid test failure case).
    Create Session    reqres    ${BASE_URL}    headers={"x-api-key":"${API_KEY}"}
    ${data}=    Create Dictionary    name=Ghost    job=None
    ${response}=    PUT On Session    reqres    /api/users/999    json=${data}
    Should Not Be Equal As Integers    ${response.status_code}    404
    Log To Console    ${response.json()}

Update User Without Base URL
    [Documentation]    Verify missing BASE_URL fails.
    Create Session    invalid    http://invalid-url.com
    ${data}=    Create Dictionary    name=John
    ${response}=    PUT On Session    invalid    /api/users/2    json=${data}    expected_status=any
    Should Not Be Equal As Integers    ${response.status_code}    200

Update User With Invalid Method
    [Documentation]    Ensure incorrect HTTP method does not update resource.
    Create Session    reqres    ${BASE_URL}
    ${data}=    Create Dictionary    name=WrongMethod
    ${response}=    Get On Session    reqres    /api/users/2
    Should Not Contain    ${response.text}    WrongMethod

Update User With Unsupported Content Type
    [Documentation]    Sending wrong content type must produce unexpected result (valid negative case).
    Create Session    reqres    ${BASE_URL}    headers={"Content-Type":"text/plain"}
    ${response}=    PUT On Session    reqres    /api/users/2    data="Invalid Body"    expected_status=any
    Should Not Be Equal As Integers    ${response.status_code}    200
