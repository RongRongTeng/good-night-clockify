# Good Night Clockify

- For user to manage sleep recod.
- For user to follow and unfollow other users.
- For user to see following users’ sleep records from the previous week.

## Requirement

- ruby 3.2.2
- rails 7.0.5
- postgres


### Update configuration files

```
setup .env file, refer to the example file at .env.example
```

### Install Gem and Setup Database

```
docker-compose build
docker-compose run --rm web bundle exec rake db:create
docker-compose run --rm web bundle exec rake db:migrate
```

### Run the server

Just run the command to start the server

```
docker-compose up
```

### Testing

```
docker-compose run --rm web bundle exec rspec 
```

### Try it! 🔥🔥

For more details, visit API Doc: http://localhost:3000/apipie

❗️All the following APIs need to be user authenticated❗️

You need to add `Authorization: Bearer <token>` in request header.

```
      GET  |  /api/:version/sleep_records(.json)        |  v1  |  List sleep records
      GET  |  /api/:version/sleep_records/:id(.json)    |  v1  |  Get a sleep record                   
     POST  |  /api/:version/sleep_records(.json)        |  v1  |  Create a sleep record             
PATCH|PUT  |  /api/:version/sleep_records/:id(.json)    |  v1  |  Update a sleep record 
   DELETE  |  /api/:version/sleep_records/:id(.json)    |  v1  |  Delete a sleep record 
      GET  |  /api/:version/followings(.json)           |  v1  |  List followings                      
     POST  |  /api/:version/followings(.json)           |  v1  |  Create a following
   DELETE  |  /api/:version/followings/:id(.json)       |  v1  |  Delete a following
      GET  |  /api/:version/followings/sleep_records    |  v1  |  List sleep records of followings
```

**Get token with**

1. Sign in user `POST /users/sign_in`

```ruby
# Request body example
{
  "user": {
    "email": "demo_user@example.com",
    "password": "password1234"
  }
}
```
2. Token is in the response header `Authorization` key


## Author

- **Ya-Rong, Teng** - [RongRongTeng](https://github.com/RongRongTeng)
