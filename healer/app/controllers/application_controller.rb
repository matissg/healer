require "timeout"

class ApplicationController < ActionController::Base
  private

  def path_from_controller_action(controller, action_name)
    controller = controller.underscore.gsub("_controller", "")
    Rails.application.routes.url_helpers.url_for(controller: controller, action: action_name, only_path: true)
  end
end
