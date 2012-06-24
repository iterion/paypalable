module ActiveRecord
  module Paypalable

    def self.included(base)
      base.extend ClassMethods
    end

    module ClassMethods
      def paypalable(options = {})
        attr_accessor :paypalable_options, :payment_response
        @paypalable_options = {
          payment_method: :payment_data
        }
        include ActiveRecord::Paypalable::InstanceMethods
      end
    end

    module InstanceMethods
      def payment_method
        @paypalable_options ||= {:payment_method => :payment_data}
        @paypalable_options[:payment_method]
      end

      def pay(host)
        @payment_response = ::Paypalable::AdaptivePaymentsRequest.pay paypal_payment_data host


        unless @payment_response.success?
          self.errors.add(:base, @payment_response.errors.first['message'])
        end
        
        @payment_response.success?
      end
      
      def paypal_payment_data(host)
        data = {
          "requestEnvelope" => {"errorLanguage" => "en_US"},
        }
        self.send(payment_method, data, host)
      end
      
    end #InstanceMethods
  end #Paypalable
end #ActiveRecord