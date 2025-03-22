require 'rails_helper'

RSpec.describe Healer::ActivityLog, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end

# == Schema Information
#
# Table name: healer_activity_logs
#
#  id          :integer          not null, primary key
#  action_name :string
#  result      :json
#  created_at  :datetime         not null
#
# Indexes
#
#  index_healer_activity_logs_on_created_at  (created_at)
#
