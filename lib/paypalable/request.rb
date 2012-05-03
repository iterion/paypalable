require 'json'
require 'net/http'
require 'net/https'

module Paypalable
  class NoDataError < Exception; end

  class Request
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

      def wrap_post(data, path)
        raise NoDataError unless data

        Response.new(post(data, path))
      end

      def rescue_error_message(e, message = nil)
        {"responseEvelope" => {"ack" => "Failure"}, "error" => [{"message" => (message ||= e)}]}
      end
    
      def post(data, path)
        api_request_data = data.to_json
        url = URI.parse Config.api_base_url
        http = Net::HTTP.new(url.host, 443)
        http.use_ssl = true
        http.verify_mode = ::OpenSSL::SSL::VERIFY_PEER

        if Config.ssl_cert_file
          cert = File.read(::Paypalable::Config.ssl_cert_file)
          http.cert = OpenSSL::X509::Certificate.new(cert)
          http.key = OpenSSL::PKey::RSA.new(cert)
        end
        http.ca_path = Config.ssl_cert_path unless Config.ssl_cert_path.nil?

        begin
          response_data = http.post(path, api_request_data, Config.headers)
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
        end #begin
      end #post
    end #class << self
  end
end
