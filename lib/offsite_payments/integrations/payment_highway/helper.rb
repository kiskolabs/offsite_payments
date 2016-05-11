module OffsitePayments #:nodoc:
  module Integrations #:nodoc:
    module PaymentHighway
      class Helper < OffsitePayments::Helper
        def initialize(order, merchantnumber, options = {})
          super
          add_field("sph-merchant", merchantnumber)
          add_field("sph-request-id", generate_request_id)
          add_field("sph-currency", options.fetch(:currency))
          add_field("sph-timestamp", Time.now.utc.xmlschema)
        end
        # Replace with the real mapping
        mapping :account, "sph-account"
        mapping :amount, "sph-amount"

        mapping :order, 'sph-order'

        mapping :customer, :first_name => '',
          :last_name  => '',
          :email      => '',
          :phone      => ''

        mapping :billing_address, :city     => '',
          :address1 => '',
          :address2 => '',
          :state    => '',
          :zip      => '',
          :country  => ''

        mapping :description, 'description'
        mapping :tax, ''
        mapping :shipping, ''
        mapping :language, "language"
        mapping :sph_account, "sph-account"
        mapping :account_key, "sph-account-key"
        mapping :account_secret, "sph-account-secret"

        def form_fields
          @fields.merge("signature" => generate_signature)
        end

        def generate_signature
          contents = ["POST"]
          contents << "/form/view/pay_with_card"
          contents << "sph-account=#{@fields["sph-account"]}"
          contents << "sph-merchant=#{@fields["sph-merchant"]}"
          contents << "sph-order=#{@fields["sph-order"]}"
          contents << "sph-request-id=#{@fields["sph-request-id"]}"
          contents << "sph-amount=#{@fields["sph-amount"]}"
          contents << "sph-currency=#{@fields["sph-currency"]}"
          contents << "sph-timestamp=#{@fields["sph-timestamp"]}"
          contents << "sph-success-url=#{success_url}"
          contents << "sph-failure-url=#{failure_url}"
          contents << "sph-cancel-url=#{cancel_url}"
          contents << "language=#{@fields['language']}"
          contents << "description=#{@fields['description']}"
          OpenSSL::HMAC.hexdigest('sha256', account_secret, contents.join("\n"))
        end

        private def generate_request_id
          SecureRandom.uuid
        end

        private def account_secret
          @fields['sph-account-secret']
        end

        private def success_url
          "#{service_url}/success"
        end

        private def failure_url
          "#{service_url}/failure"
        end

        private def cancel_url
          "#{service_url}/cancel"
        end

        private def service_url
          OffsitePayments::Integrations::PaymentHighway.service_url
        end
      end
    end
  end
end
