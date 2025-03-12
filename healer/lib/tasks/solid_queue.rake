# rails solid_queue:load_schema

namespace :solid_queue do
  desc "Load SolidQueue schema into the queue database"
  task load_schema: :environment do
    config = ActiveRecord::Base.configurations.configs_for(env_name: Rails.env, name: "queue")

    ActiveRecord::Base.establish_connection(config)

    load(Rails.root.join("db/queue_schema.rb"))

    puts "SolidQueue schema loaded successfully."
  end
end
