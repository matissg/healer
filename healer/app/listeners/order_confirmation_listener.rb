class OrderConfirmationListener
  include WisperNext.subscriber(:async)

  def order_created(payload)
    puts "Confirmation email sent to #{payload[:order_email]} for Order ##{payload[:order_id]}"
  end
end
