require "test_helper"

describe VipTicket do
  let(:vip_ticket) { VipTicket.new }

  it "must be valid" do
    vip_ticket.must_be :valid?
  end
end
