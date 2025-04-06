require 'rails_helper'

RSpec.describe "healer/error_events/edit", type: :view do
  let(:healer_error_event) {
    Healer::ErrorEvent.create!()
  }

  before(:each) do
    assign(:healer_error_event, healer_error_event)
  end

  it "renders the edit healer_error_event form" do
    render

    assert_select "form[action=?][method=?]", healer_error_event_path(healer_error_event), "post" do
    end
  end
end
