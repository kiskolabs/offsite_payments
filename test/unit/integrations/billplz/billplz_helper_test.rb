require 'test_helper'

class BillplzHelperTest < Test::Unit::TestCase
  include OffsitePayments::Integrations

  def setup
    @helper = Billplz::Helper.new('2', :amount => 500, :credential2 => "6pKF4jkv97zmqBJ3ZL8gUw5DfT2NMQ")
  end

  def test_basic_helper_fields
    assert_field 'collection_id', '2'
  end

  def test_customer_fields
    @helper.customer :first_name => 'Antti', :last_name => 'Akonniemi', :email => 'antti@example.com', :phone => "0401234556", :tellno => "0401234557", :company => "Kisko Labs"
    assert_field 'name', 'Akonniemi'
    assert_field 'email', 'antti@example.com'
  end

  def test_unknown_mapping
    assert_nothing_raised do
      @helper.company_address :address => '500 Dwemthy Fox Road'
    end
  end

end
