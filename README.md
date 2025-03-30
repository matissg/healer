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

LogAI demo app is available http://localhost:8050/
The app can be started manually by attaching shell to the "healer-logai-1" container and then

    cd workspace/logai
    bash start_logai.sh
The app runs on Python 3.10 and does not support newer Python versions at least for now.
