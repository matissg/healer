require "rails_helper"

RSpec.describe OrdersController, type: :controller do
  describe "GET #index" do
    it "returns a success response" do
      get :index
      expect(response).to be_successful
      expect(response).to render_template(:index)
    end
  end

  describe "GET #new" do
    it "returns a success response" do
      get :new
      expect(response).to be_successful
      expect(response).to render_template(:new)
    end
  end

  describe "POST #create" do
    let(:user) { create(:user) }

    let(:params) do
      {order: {user_id: user.id, product_catalog_guid: 1, quantity: 1}}
    end

    it "creates a new Order" do
      post :create, params: params

      expect(Order.count).to eq(1)
      expect(Order.last.user_id).to eq(user.id)
      expect(response).to redirect_to(orders_path)
      expect(flash[:notice]).to eq("Order was successfully created.")
    end
  end
end
