class Order < ApplicationRecord
  include WisperNext.publisher

  EVENTS = WisperNext::Events.new
  EVENTS.subscribe(OrderConfirmationListener.new)

  belongs_to :user

  after_create :publish_order_created_event

  validates :total, numericality: { greater_than: 0 }

  private

  def publish_order_created_event
    EVENTS.broadcast(:order_created, order_id: id, order_email: user.email, at: Time.now)
  end
end

# == Schema Information
#
# Table name: orders
#
#  id                   :bigint           not null, primary key
#  price                :decimal(10, 2)
#  product_catalog_guid :bigint
#  product_name         :string           not null
#  quantity             :integer          default(1), not null
#  total                :decimal(10, 2)   not null
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  user_id              :bigint           not null
#
# Indexes
#
#  index_orders_on_user_id  (user_id)
#
