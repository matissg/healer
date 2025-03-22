class DynamicMethod < ApplicationRecord
end

# == Schema Information
#
# Table name: dynamic_methods
#
#  id            :integer          not null, primary key
#  class_name    :string
#  method_name   :string
#  method_source :text
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
# Indexes
#
#  index_dynamic_methods_on_class_name_and_method_name  (class_name,method_name) UNIQUE
#
