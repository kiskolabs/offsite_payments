require 'test_helper'

class BillplzModuleTest < Test::Unit::TestCase
  include OffsitePayments::Integrations

  def test_notification_method
    assert_instance_of Billplz::Notification, Billplz.notification({"collection_id"=>"2", "paid_at"=>"1336058061", "paid"=>"true"})
  end
end
