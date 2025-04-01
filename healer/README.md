# Rails app

The main experiment app is available http://localhost:3000/ 
The app can be started manually by attaching shell to the "healer-rails-app-1" container and then

    cd workspace/healer
    bin/dev

The app runs on Ruby on Rails 8.1 and PostgreSQL (DB) in separate container to allow running RSpec tests before applying changed code.

## Tech stack

 - Ruby 3.4
 - Ruby on Rails 8.1
 - PostgreSQL 17