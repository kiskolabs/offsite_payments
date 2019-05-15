module OffsitePayments #:nodoc:
  module Integrations #:nodoc:
    module Billplz
      mattr_accessor :service_url

      def self.notification(post)
        Notification.new(post)
      end

      class Helper < OffsitePayments::Helper
        def initialize(order, options = {})
          if Rails.env.production?
            self.service_url = "https://#{options[:credential2]}:@www.billplz.com/api/v3/bills"
          else
            self.service_url = "https://#{options[:credential2]}:@billplz-staging.herokuapp.com/api/v3/bills"
          end
          super
        end

        # Mappings
        mapping :customer, :last_name  => "name",
                           :email      => "email"
        mapping :order, 'collection_id'
        mapping :notify_url, "callback_url"
        mapping :description, "description"
      end

      class Notification < OffsitePayments::Notification
        def complete?
          params['paid'] == true
        end

        # Order id
        def collection_id
          params['collection_id']
        end

        # When was this payment received by the client.
        def received_at
          params['paid_at']
        end

        private

        def parse(post)
          post.each do |key, value|
            params[key] = value
          end
        end
      end
    end
  end
end
