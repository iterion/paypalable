module ActiveRecord
  module Paypalable

    def self.included(base)
      base.extend ClassMethods
    end

    module ClassMethods
      def paypalable(payment_method = :payment_data)
        @payment_method = payment_method.to_sym
        include ActiveRecord::Paypalable::InstanceMethods
      end
    end

    module InstanceMethods
      def pay(host)
        Request.pay paypal_payment_data host
      end
      
      def paypal_payment_data(host)
        data = {
          "requestEnvelope" => {"errorLanguage" => "en_US"},
          "currencyCode"=>"USD",
          "actionType"=>"PAY"
        }
        self.send(:payment_data, data, host)
      end
      
    end #InstanceMethods
  end #Paypalable
end #ActiveRecord