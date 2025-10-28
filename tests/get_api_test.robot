*** Settings ***
Library    RequestsLibrary
Library    Collections

*** Variables ***
${BASE_URL}    https://reqres.in
${API_KEY}     reqres-free-v1

*** Test Cases ***

Get Single User - Valid User
    Create Session    reqres    ${BASE_URL}    headers={"x-api-key":"${API_KEY}"}    verify=False    disable_warnings=True
    ${response}=    GET On Session    reqres    url=/api/users/2    expected_status=any
    Should Be Equal As Integers    ${response.status_code}    200
    Log To Console    Valid User Response: ${response.json()}

Get Single User - Invalid User
    Create Session    reqres    ${BASE_URL}    headers={"x-api-key":"${API_KEY}"}
    ${response}=    GET On Session    reqres    url=/api/users/23    expected_status=any
    Should Be True    ${response.status_code} in [401,404]

Get All Users - Valid Page
    Create Session    reqres    ${BASE_URL}    headers={"x-api-key":"${API_KEY}"}
    ${response}=    GET On Session    reqres    url=/api/users?page=2    expected_status=any
    Should Be Equal As Integers    ${response.status_code}    200

Get All Users - Invalid Page
    Create Session    reqres    ${BASE_URL}    headers={"x-api-key":"${API_KEY}"}
    ${response}=    GET On Session    reqres    url=/api/users?page=99    expected_status=any
    Should Be True    ${response.status_code} in [200,404,401]

Get Delayed Response
    Create Session    reqres    ${BASE_URL}    headers={"x-api-key":"${API_KEY}"}
    ${response}=    GET On Session    reqres    url=/api/users?delay=3    expected_status=any
    Should Be True    ${response.status_code} in [200,401]

Get User List - Verify Required Fields
    Create Session    reqres    ${BASE_URL}    headers={"x-api-key":"${API_KEY}"}
    ${response}=    GET On Session    reqres    url=/api/users?page=1    expected_status=any
    Should Be Equal As Integers    ${response.status_code}    200
    ${users}=    Set Variable    ${response.json()['data']}
    FOR    ${user}    IN    @{users}
        Dictionary Should Contain Key    ${user}    email
        Dictionary Should Contain Key    ${user}    avatar
    END

Get Users - Invalid Endpoint
    Create Session    reqres    ${BASE_URL}    headers={"x-api-key":"${API_KEY}"}
    ${response}=    GET On Session    reqres    url=/api/unknownendpoint    expected_status=any
    Should Be True    ${response.status_code} in [404,401]

Get Users - Missing Query Parameter
    Create Session    reqres    ${BASE_URL}    headers={"x-api-key":"${API_KEY}"}
    ${response}=    GET On Session    reqres    url=/api/users    expected_status=any
    Should Be Equal As Integers    ${response.status_code}    200

Get User - Invalid URL Format
    Create Session    reqres    ${BASE_URL}    headers={"x-api-key":"${API_KEY}"}
    ${response}=    GET On Session    reqres    url=//api//users/abc    expected_status=any
    Should Be True    ${response.status_code} in [200,404,401]

Get Users - Unsupported Query Key
    Create Session    reqres    ${BASE_URL}    headers={"x-api-key":"${API_KEY}"}
    ${response}=    GET On Session    reqres    url=/api/users?invalidKey=xyz    expected_status=any
    Should Be True    ${response.status_code} in [200,401]


