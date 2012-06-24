module Paypalable
  class AdaptivePaymentsRequest < Request
    #Wrap standard Adaptive Payments requests

    class << self
      def pay(data)
        wrap_post(data, "/AdaptivePayments/Pay")
      end

      def payment_details(data)
        wrap_post(data, "/AdaptivePayments/PaymentDetails")
      end

      def set_payment_options(data)
        wrap_post(data, "/AdaptivePayments/SetPaymentOptions")
      end

      def get_payment_options(data)
        wrap_post(data, "/AdaptivePayments/GetPaymentOptions")
      end

      def get_shipping_addresses(data)
        wrap_post(data, "/AdaptivePayments/GetShippingAddresses")
      end

      def preapproval(data)
        wrap_post(data, "/AdaptivePayments/Preapproval")
      end

      def preapproval_details(data)
        wrap_post(data, "/AdaptivePayments/PreapprovalDetails")
      end

      def cancel_preapproval(data)
        wrap_post(data, "/AdaptivePayments/CancelPreapproval")
      end

      def convert_currency(data)
        wrap_post(data, "/AdaptivePayments/ConvertCurrency")
      end

      def refund(data)
        wrap_post(data, "/AdaptivePayments/Refund")
      end

      def execute_payment(data)
        wrap_post(data, "/AdaptivePayments/ExecutePayment")
      end

    end #class << self
  end # AdaptivePaymentsRequest
end # Paypalable
