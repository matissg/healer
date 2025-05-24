# AI agent driven error mitigation demo app

This Ruby on Rails app demonstrates how AI agent can mitigate application errors in autonomous manner.

# Install

 1. Install [Docker desktop](https://www.docker.com/products/docker-desktop/)
 2. Install [VS Code with Devcontainer extension](https://code.visualstudio.com/docs/devcontainers/containers#_installation)
 3. Clone the repo with `git clone git@github.com:matissg/healer.git`
 4. Open the repo in VS Code, run the **Dev Containers: Open Folder in Container...** command from the Command Palette (F1) or quick actions Status bar item, and select "Catalog Container". When done, run the same command and select "Rails Container". If you want to explore LogAI, run the same command and select "LogAI Container".

# Explore

When all containers are installed and launched the main experiment app is visible http://localhost:3000/  

## Catalog API app

The Catalog app simulates Product list endpoint which can be queried by the main app.
The app can be started manually by attaching shell to the "healer-catalog-1" container and then

    cd workspace/catalog
    bin/dev
The app intentionally runs on Ruby on Rails 7.1 and SQLite (DB).


## Rails app

The main experiment app is available http://localhost:3000/ 
The app can be started manually by attaching shell to the "healer-rails-app-1" container and then

    cd workspace/healer
    bin/dev
The app runs on Ruby on Rails 8.1 and PostgreSQL (DB) in separate container to allow running RSpec tests before applying changed code.

## LogAI demo app (optional)

LogAI demo app (a clone of [Salesforce LogAI](https://github.com/salesforce/logai)) is available http://localhost:8050/
The app can be started manually by attaching shell to the "healer-logai-1" container and then

    cd workspace/logai
    bash start_logai.sh
The app runs on Python 3.10 and does not support newer Python versions at least for now.
LogAI is licensed under [BSD 3-Clause License](https://github.com/salesforce/logai/blob/main/LICENSE.txt)

# Experiment

There are three experiments available for this demo app. For the Healer service to call OpenAI correctly, you will need to modify `healer/config/initializers/openai.rb` with your OpenAI account credentials. You can generate your `healer/config/master.key` with

    bin/rails credentials:edit

Please, refer to https://guides.rubyonrails.org/security.html#custom-credentials for setting your credentials.

## 1. Functionality gap

The first scenario is based on the "Orders" view, where all orders are displayed in a table, and for each order, a User object is associated. The problem is that for each order in the table row, the user record is queried from the database, creating a so-called N+1 query issue.

To run this scenario, please, in `WithHealerMethods` module set TIMEOUT_SEC to 0.01. The Healer service will trigger the source code correction procedure due to Timeout error.

## 2. Data integrity error

The second scenario is based on the "Orders" view, where all orders are displayed in a table, and for each order, a User object is associated. The scenario demonstrates the Healer service’s capability to resolve data integrity issues. The prerequisite step is required to execute the given scenario. After attaching the shell to "healer-rails-app-1" container, the given commands must be executed in the terminal:

    cd workspace/healer
    bin/rails c
    Order.first.user.destroy!

To visually observe the error in the "Customer Orders" application, refer to the line in `healer/app/controllers/concernswith_healer_methods.rb` file must be temporarily removed:

    rescue_from StandardError, with: :resolve_error

After this change, the Healer service is deactivated and does not rescue errors, with the error visible in the UI.

## 3. Interoperability error

The third scenario is based on the "New Order" view, where options for "Product" fields are fetched from the external API service "Catalog". After attaching the shell to "healer-rails-app-1" container, a simple request can be executed to verify the API is operational:

Returned response contains data about the first product from the catalog, for example:

    {
    "id":1,
    "brand":"Nike",
    "name":"Sleek Copper Table",
    "price":"1234.0",
    "stock":395,
    "created_at":"2025-03-15T15:38:34.906Z",
    "updated_at":"2025-03-15T15:38:34.906Z"
    }

This will cause an error, because in the OrdersController "create" method expects "title", not "name" attribute:

    @order.product_name = product.title
