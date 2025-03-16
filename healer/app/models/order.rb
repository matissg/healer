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
