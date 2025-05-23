require "rails_helper"

RSpec.describe Healer::ErrorEvent, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end

# == Schema Information
#
# Table name: healer_error_events
#
#  id                                                    :bigint           not null, primary key
#  class_name(The class name where the error occurred)   :string           not null
#  error(The error details)                              :json             not null
#  method_name(The method name where the error occurred) :string           not null
#  method_source(The source code of the method)          :text
#  prompt(The prompt for AI agent)                       :json             not null
#  response(The response from AI agent)                  :json             not null
#  success(The success status of the mitigation)         :boolean          default(FALSE), not null
#  created_at                                            :datetime         not null
#  updated_at                                            :datetime         not null
#
# Indexes
#
#  index_healer_error_events_on_class_name_and_method_name  (class_name,method_name) UNIQUE
#
