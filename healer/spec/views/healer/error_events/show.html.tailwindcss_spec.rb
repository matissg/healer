require 'rails_helper'

RSpec.describe "healer/error_events/show", type: :view do
  before(:each) do
    assign(:healer_error_event, Healer::ErrorEvent.create!())
  end

  it "renders attributes in <p>" do
    render
  end
end
