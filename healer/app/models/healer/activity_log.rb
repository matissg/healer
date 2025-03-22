class Healer::ActivityLog < ApplicationRecord
  self.table_name = "healer_activity_logs"
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
