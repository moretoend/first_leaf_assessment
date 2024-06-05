# Firstleaf Take Home Project

This is a project aiming Users creation and listing.

The main goal is to enroll new users and guarantee all of them has a unique key and an account key generated from an outside tool.

## How to start application

### > DISCLAIMER 👀: I've commited .env file ONLY this test purposes. I would never do it on Production (I hope) 🤣

This application is upon Docker and Docker compose, so only a few commands to have things up:

1. First of all, we have Environment variables to configure. We have a sample file called _env. You can create a copy
```
copy _env .env
```

2. Now you need to fill all the variables

3. First is to build your image:
```
docker compose build
```

4. Now start your application with everything on background:
```
docker compose up -d
```

5. It will start you application on `http://localhost:3005`
   
6. If you are on development environment, you can run a task to create fake data
```
docker compose exec web rake dev:prime
```

6. If you want to execute the specs, you can run:
```
docker compose exec web rspec
```

## How to test it?

This application has only two endpoints, one to list all users and another to create a new.

### Listing Users

Endpoint: `GET /api/users`

Accepted Query Parameters: `email, full_name and/or metadata`

Sample success response:
```
Request: GET /api/users?email=test

Response status: 200

Response body:
{
  "users": [
    {
      "email": "test@test.com",
      "phone_number": "22 1232 54341 1123",
      "full_name": "Testing someone",
      "key": "pZdTooPg9wtASRkeZucAQtPzKj4kJ4rfvJ5wnvmaR3bqZsJiRH1p0ZrzEDwAjCBmXczWhlskZOliOob0T2uxvXhFqJ7Bol8obXz2",
      "account_key": "cda73aba3816c76067082ae7b60f3ce281bd48a2053a719e1a1a28fe0580bae8",
      "metadata": "female, age 52, social worker, master researcher"
    },
    ...
  ]
}
```

Sample of response for unpermitted params:
```
Request: GET /api/users?invalid_param1=test1&invalid_param2=test2

Response status: 422

Response body
{
	"errors": [
		"Unpermitted parameters were sent: invalid_param1, invalid_param2"
	]
}
```

### Creating an User

Endpoint: `POST /api/users`

Accepted Body Params: `email, full_name, password, phone_number, metadata`

Sample request:
```
Endpoint: POST /api/users

Headers: Content-Type=application/json

Body:
{
	"email": "test@test.com",
	"full_name": "Testing someone",
	"password": "123456",
	"phone_number": "22 1232 54341 1123",
	"metadata": "female, age 52, social worker, master researcher"
}
```

Response for Success:
```
Endpoint: POST /api/users

Status: 201

Response body:
{
  "email": "test@test.com",
  "phone_number": "22 1232 54341 1123",
  "full_name": "Testing someone",
  "key": "pZdTooPg9wtASRkeZucAQtPzKj4kJ4rfvJ5wnvmaR3bqZsJiRH1p0ZrzEDwAjCBmXczWhlskZOliOob0T2uxvXhFqJ7Bol8obXz2",
  "account_key": "cda73aba3816c76067082ae7b60f3ce281bd48a2053a719e1a1a28fe0580bae8",
  "metadata": "female, age 52, social worker, master researcher"
}
```

Response for invalid data:
```
Endpoint: POST /api/users

Status: 422

Response body:
{
	"errors": [
		"Email has already been taken",
		"Phone number is missing"
	]
}
```

Response for unpermitted body parameters:
```
Endpoint: POST /api/users

Status: 422

Response body:
{
	"errors": [
		"Unpermitted parameters were sent: invalid_param1, invalid_param2"
	]
}
```

## Technologies

- Sidekiq
- Rails
- PostgreSQL
- Redis
- RSpec

## Assignment
Today, we're going to design an application that will function as a user
service. Feel free to add or replace gems on the project. This service
supports new user creation and returning users that are currently in the
system. For the initial release, your task is to build two API endpoints:

`GET /api/users`

`POST /api/users`

### User Model

The user records must be stored in a database that supports SQL queries. Each
user has the following attributes which must conform to the rules described
below:

| Field Name   | Properties                                                |
| ------------ | --------------------------------------------------------- |
| id           | integer, primary key, not null, unique, auto-incrementing |
| email        | string, max 200 characters, not null, unique              |
| phone_number | string, max 20 characters, not null, unique               |
| full_name    | string, max 200 characters                                |
| password     | string, max 100 characters, not null                      |
| key          | string, max 100 characters, not null, unique              |
| account_key  | string, max 100 characters, unique                        |
| metadata     | string, max 2000 characters                               |

### GET /api/users

- [x] Return all current user records, most recently created first.
- [x] Optional query paramaters to filter results matching `email`, `full_name`,
    and `metadata`. Return in most recently created first order. Example:
    `/api/users?full_name=Smith&metadata=male`.
- [x] 200 OK Response for all success cases.
- [x] 422 Unprocessable Entity for malformed query parameters such as
  unsearchable fields (ie. `key`) or not existing ones (ie. `cellphone`).
- [x] 5xx for server errors.

### POST /api/users

- [x] Create a new user record in the database.
- [x] On success, return JSON object of user that was just created.
- [x] On success, return status code 201 Created.
- [x] On failure, return status code 422 Unprocessable Entity with a list of all
    the errors.
- [x] 5xx for server errors.
- [x] Endpoint can only accept `email`, `phone_number`, `full_name`, `password`,
    and `metadata` fields.
- [x] `key` field should be generated server side when user is created.
- [x] `password` should be stored hashed with a salt value.
- [x] `account_key` field should be generated from [Account Key Service](#account-key-service).

### JSON Specifications

- [x] On creation of a new user, the response object should be in the following
    format:
```
{
 email: "user@example.com",
 phone_number: "5551235555",
 full_name: "Joe Smith",
 key: "72ae25495a7981c40622d49f9a52e4f1565c90f048f59027bd9c8c8900d5c3d8",
 account_key: "b97df97988a3832f009e2f18663ac932",
 metadata: "male, age 32, unemployed, college-educated"
}
```
- [x] On returning found users, the response object should be in the following
    format:
```
{
 users: [
   {
     email: "user@example.com",
     phone_number: "5551235555",
     full_name: "Joe Smith",
     key: "72ae25495a7981c40622d49f9a52e4f1565c90f048f59027bd9c8c8900d5c3d8",
     account_key: "b97df97988a3832f009e2f18663ac932",
     metadata: "male, age 32, unemployed, college-educated"
   }
 ]
}
```
- [x] Errors should be returned as:
```
{
 errors: [
   "Phone number is too long",
   "Email is missing"
 ]
}
```

### Account Key Service

Account Keys are generated for a user by an external service. This service
expects the `email` and `key` fields to be POSTed, and in return the service
will respond with the appropriate `account_key` to be saved to the user.

**External service:** https://w7nbdj3b3nsy3uycjqd7bmuplq0yejgw.lambda-url.us-east-2.on.aws/v1/account

**Example transaction:**
```
curl -H "Content-Type: application/json" -X POST https://w7nbdj3b3nsy3uycjqd7bmuplq0yejgw.lambda-url.us-east-2.on.aws/v1/account -d "{\"email\":\"user@example.com\",\"key\":\"72ae25495a7981c40622d49f9a52e4f1565c90f048f59027bd9c8c8900d5c3d8\"}"

Response: {"email":"user@example.com","account_key":"b97df97988a3832f009e2f18663ac932"}
```

The service is designed to be somewhat unreliable, so it is important to
interact with the service in a background process and then update the user
record when that background process is complete. If an error occurs, the
application should retry on some reasonable schedule.

- [x] Create Access Key service library,
- [x] On user create, trigger Sidekiq job for access Account Key service.
- [x] Perform retry on failure from Account Key service.
- [x] Update user model with `account_key` value.

### Testing
#### User Model
- [x] Verify that all defined columns necessary exist.
- [x] Verify that columns have proper validation on the model.
- [x] Coverage should be 100% for app/models/user.rb.

#### User Service Routing
- [ ] Verify that the GET /api/users endpoint routes to the appropriate method.
- [ ] Verify that the POST /api/users endpoint routes to the appropriate method.

#### User Controller
- [x] Verify that a request without a query parameter returns all users in the
    database using the specified JSON format, ordered by most recently created
    first.
- [x] Verify that a request with a query parameter returns all users in the
    database filtered by the query paramater, using the specified JSON format,
    ordered by most recently created first.
- [x] Verify that creating a new user works with unique values specified, and
    returns a single User JSON object and a 201 Created status header.
- [x] Verify that creating a new user with non-unique values specified, returns
    a 422 Unprocessable Entity status, and an array of errors in the specified
    JSON format.
- [x] Verify that a new user that is created has a random key generated for it on
    the server side.
- [x] Verify that a new user that is created has it's password stored in a hashed
    manner, with a salt value.
- [x] Verify that a new user that is created has an access_key created for it by
    accessing the Account Key service.


## Getting Started

### What's Provided
- Rails
- Postgresql

- Ensure that docker-compose is installed [Docker Compose](https://docs.docker.com/compose/install/#prerequisites)

- Start docker containers
  ```bash
  docker-compose build
  docker-compose up
  ```

- Setup test databases (use another bash console)
  ```bash
  docker-compose run web rails db:create
  docker-compose run web rails db:migrate
  ```

- Test site lives at `localhost:3005`

- Sidekiq lives at `localhost:3005/sidekiq`

### Environment
- Initial Rails 7.1.3 API application
