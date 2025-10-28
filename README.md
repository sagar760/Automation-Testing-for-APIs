# Automation-Testing-for-APIs
This repository contains API automation test suites created using **Robot Framework** and **Reqres.in** public API.

The project includes automated test coverage for:
-  GET User
-  POST Create User
-  PUT Update User

##  Chosen Endpoints from ReqRes API

| HTTP Method | Endpoint | Description |
|------------|-----------|-------------|
| GET | /api/users?page=2 | Fetch paginated users list |
| GET | /api/users/2 | Fetch a single valid user |
| GET | /api/users/23 | Fetch non-existing user |
| POST | /api/users | Create new user |
| PUT | /api/users/2 | Update existing user |

Reference: https://reqres.in/

##  Project Structure

ROBOT-API-TESTING
│
├── tests
│ ├── get_api_test.robot
│ ├── post_api_test.robot
│ └── put_api_test.robot
│
├── log.html
├── output.xml
└── report.html


##  Installation & Setup

###  Prerequisites
- Python 3.x installed → https://www.python.org/downloads/
- pip installed

###  Install dependencies
pip install robotframework
pip install robotframework-requests
pip install robotframework-jsonlibrary

Run all suites
robot -d Reports tests

Run tests individually
robot tests/get_api_test.robot
robot tests/post_api_test.robot
robot tests/put_api_test.robot
