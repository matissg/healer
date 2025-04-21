class OrdersController < ApplicationController
  include WithHealerMethods

  def new
    @order = Order.new
    @users = User.all
    # Product list fetched from external API source
    @products = Catalog.fetch("products") || []
  end

  def create
    @order = Order.new(order_params)
    @order.product_name = product.title
    @order.price = product.price
    @order.total = @order.quantity.to_i * product.price.to_f

    if @order.save
      redirect_to orders_path, notice: "Order was successfully created."
    else
      raise StandardError,
        "Invalid Order: #{@order.errors.full_messages}, Catalog fetched product data: #{product}"
    end
  end

  def index
    @orders = Order.all
  end

  private

  def product
    # Product by its ID fetched from external API source
    @product ||= Catalog.fetch("products/#{order_params[:product_catalog_guid]}")&.first
  end

  def order_params
    params.require(:order).permit(:user_id, :product_catalog_guid, :quantity)
  end
end
