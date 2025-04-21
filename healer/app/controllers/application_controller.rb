require "timeout"

class ApplicationController < ActionController::Base
  private

  def path_from_controller_action(controller, action_name)
    controller = controller.underscore.gsub("_controller", "")
    action = action_name == "create" ? "new" : action_name
    Rails.application.routes.url_helpers.url_for(controller: controller, action: action, only_path: true)
  end
end
