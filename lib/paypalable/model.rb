module ActiveRecord
  module Paypalable

    def self.included(base)
      base.extend ClassMethods
    end

    module ClassMethods
      def paypalable(options = {})
        attr_accessor :paypalable_options, :payment_response
        @paypalable_options = options.reverse_merge!({
          payment_method: :payment_data
        })
        include ActiveRecord::Paypalable::InstanceMethods
      end
    end

    module InstanceMethods
      def payment_method
        @paypalable_options[:payment_method]
      end

      def pay(host)
        @payment_response = ::Paypalable::Request.pay paypal_payment_data host

        unless @payment_response.success?
          self.errors = self.errors + @payment_response.errors
        end

        @payment_response
      end
      
      def paypal_payment_data(host)
        data = {
          "requestEnvelope" => {"errorLanguage" => "en_US"},
          "currencyCode"=>"USD",
          "actionType"=>"PAY"
        }
        self.send(payment_method, data, host)
      end
      
    end #InstanceMethods
  end #Paypalable
end #ActiveRecord