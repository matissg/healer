class InventoryAdjustmentListener
  include WisperNext.subscriber(:async)

  def order_created(payload)
    Notification.create!(message: "Inventory adjusted for Order ##{payload[:order_id]}")
  end
end
