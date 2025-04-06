require 'rails_helper'

RSpec.describe "healer/error_events/index", type: :view do
  before(:each) do
    assign(:healer_error_events, [
      Healer::ErrorEvent.create!(),
      Healer::ErrorEvent.create!()
    ])
  end

  it "renders a list of healer/error_events" do
    render
    cell_selector = 'div>p'
  end
end
