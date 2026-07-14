require "test_helper"

describe StandardTicket do
  let(:standard_ticket) { StandardTicket.new }

  it "must be valid" do
    standard_ticket.must_be :valid?
  end
end
