# Catalog API app

The Catalog app simulates Product list endpoint which can be queried by the main app.
The app can be started manually by attaching shell to the "healer-catalog-1" container and then

    cd workspace/catalog
    bin/dev

The app runs on http://localhost:3001/ and is intended as API only app. 

The app can be rebuilt with

    bin/setup

## Tech stack

 - Ruby 3.3
 - Ruby on Rails 7.1
 - SQLite