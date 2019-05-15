require 'test_helper'

class BillplzNotificationTest < Test::Unit::TestCase
  include OffsitePayments::Integrations

  def setup
    @billplz = Billplz::Notification.new(http_params)
  end

  def test_accessors
    assert @billplz.complete?
    assert_equal "2", @billplz.collection_id
  end

  private
  def http_params
    {"collection_id"=>"2", "paid_at"=>"1336058061", "paid"=>true}
  end
end
