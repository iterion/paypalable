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
        wrap_post "/AdaptivePayments/Pay", host
      end

      # def payment_details(data)
      #   wrap_post "/AdaptivePayments/PaymentDetails"
      # end
      # 
      # def set_payment_options(data)
      #   wrap_post "/AdaptivePayments/SetPaymentOptions"
      # end
      # 
      # def get_payment_options(data)
      #   wrap_post "/AdaptivePayments/GetPaymentOptions"
      # end
      # 
      # def get_shipping_addresses(data)
      #   wrap_post "/AdaptivePayments/GetShippingAddresses"
      # end
      # 
      # def preapproval(data)
      #   wrap_post "/AdaptivePayments/Preapproval"
      # end
      # 
      # def preapproval_details(data)
      #   wrap_post "/AdaptivePayments/PreapprovalDetails"
      # end
      # 
      # def cancel_preapproval(data)
      #   wrap_post "/AdaptivePayments/CancelPreapproval"
      # end
      # 
      # def convert_currency(data)
      #   wrap_post "/AdaptivePayments/ConvertCurrency"
      # end
      # 
      # def refund(data)
      #   wrap_post "/AdaptivePayments/Refund"
      # end
      # 
      # def execute_payment(data)
      #   wrap_post "/AdaptivePayments/ExecutePayment"
      # end

      def wrap_post(path, host)
        ::Paypalable::Response.new(post(paypal_payment_data(host), path))
      end

      def rescue_error_message(e, message = nil)
        {"responseEvelope" => {"ack" => "Failure"}, "error" => [{"message" => (message ||= e)}]}
      end

      def post(data, path)
        api_request_data = data.to_json
        url = URI.parse ::Paypalable::Config.api_base_url
        http = Net::HTTP.new(url.host, 443)
        http.use_ssl = true
        http.verify_mode = ::OpenSSL::SSL::VERIFY_PEER

        if ::Paypalable::Config.ssl_cert_file
          cert = File.read(::Paypalable::Config.ssl_cert_file)
          http.cert = OpenSSL::X509::Certificate.new(cert)
          http.key = OpenSSL::PKey::RSA.new(cert)
        end
        http.ca_path = ::Paypalable::Config.ssl_cert_path unless ::Paypalable::Config.ssl_cert_path.nil?

        begin
          response_data = http.post(path, api_request_data, ::Paypalable::Config.headers)
          return JSON.parse(response_data.body)
        rescue Net::HTTPBadGateway => e
          rescue_error_message(e, "Error reading from remote server.")
        rescue Exception => e
          case e
          when Errno::ECONNRESET
            rescue_error_message(e, "Connection Reset. Request invalid URL.")
          else
            rescue_error_message(e)
          end
        end
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