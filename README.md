# Good Night Clockify

- For users to manage sleep records.
- For a user to follow and unfollow other users.
- To see following users’ sleep records from the previous week.

## Requirement

- Ruby 3.2.2
- Rails 7.0.5
- Postgres

## Installation and Setup

#### 1. Update configuration files

Setup `.env` file, refer to the example file at `.env.example`

#### 2. Install Gem and Setup Database

```
docker-compose build
docker-compose run --rm web bundle exec rake db:create
docker-compose run --rm web bundle exec rake db:migrate
docker-compose run --rm web bundle exec rake db:seed 
```

#### 3. Run the server

  Just run the command to start the server

```
docker-compose up
```

#### 4. Testing

```
docker-compose run --rm web bundle exec rspec 
```

## Usage

To use the API, make sure you are authenticated. Include the following header in your requests:
```
Authorization: Bearer <token>
```

---

Here are the available API endpoints:
```
      GET  |  /api/:version/sleep_records(.json)             |  v1  |  List sleep records
      GET  |  /api/:version/sleep_records/:id(.json)         |  v1  |  Get a sleep record                   
     POST  |  /api/:version/sleep_records(.json)             |  v1  |  Create a sleep record             
PATCH|PUT  |  /api/:version/sleep_records/:id(.json)         |  v1  |  Update a sleep record 
   DELETE  |  /api/:version/sleep_records/:id(.json)         |  v1  |  Delete a sleep record 
      GET  |  /api/:version/followings(.json)                |  v1  |  List followings                      
     POST  |  /api/:version/followings(.json)                |  v1  |  Create a following
   DELETE  |  /api/:version/followings/:id(.json)            |  v1  |  Delete a following
      GET  |  /api/:version/followings/sleep_records(.json)  |  v1  |  List sleep records of followings
```
For more details, please refer to the [API Documentation](http://localhost:3000/apipie).

---

To obtain a token:

1. Sign in the user using `POST /users/sign_in`

```ruby
# Request body example
{
  "user": {
    "email": "demo_user@example.com",
    "password": "password1234"
  }
}
```
2. The token will be available in the response header under the key `Authorization`.

## More Information

### ERD
<img width="680" alt="ERD" src="https://github.com/RongRongTeng/good-night-clockify/assets/33305342/bc4751dc-e1f9-4523-bc0b-10e194e26eb5">

### Better in the future

- **Sorting**

  Clients can pass parameters to sort sleep records.

- **Timezone Considerations**

  The application currently considers listing sleep records from the previous week according to the UTC timezone. However, to address the timezone problem, the following options are available:

  - **Prefer timezone**

    Users can set their preferred timezone in the settings.

  - **Date Range Filter**

    Clients have the option to specify a date range filter in order to retrieve sleep records. This filter allows users to define a desired time period, and it can also include the user's timezone information for accurate results.


## Author

- **Ya-Rong, Teng** - [RongRongTeng](https://github.com/RongRongTeng)
