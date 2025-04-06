require 'rails_helper'

RSpec.describe "healer/error_events/new", type: :view do
  before(:each) do
    assign(:healer_error_event, Healer::ErrorEvent.new())
  end

  it "renders new healer_error_event form" do
    render

    assert_select "form[action=?][method=?]", healer_error_events_path, "post" do
    end
  end
end
