require 'json'
require 'net/http'
require 'net/https'

module Paypalable
  class NoDataError < Exception; end

  class Request
    class << self
      def wrap_post(data, path)
        raise NoDataError unless data

        Paypalable::Response.new(post(data, path))
      end

      def rescue_error_message(e, message = nil)
        {"responseEvelope" => {"ack" => "Failure"}, "error" => [{"message" => (message ||= e)}]}
      end
    
      def post(data, path)
        api_request_data = data.to_json
        url = URI.parse Paypalable::Config.api_base_url
        http = Net::HTTP.new(url.host, 443)
        http.use_ssl = true
        http.verify_mode = ::OpenSSL::SSL::VERIFY_PEER

        #set up connecting with a cert file if we have one
        if Paypalable::Config.ssl_cert_file
          cert = File.read(::Paypalable::Config.ssl_cert_file)
          http.cert = OpenSSL::X509::Certificate.new(cert)
          http.key = OpenSSL::PKey::RSA.new(cert)
        end
        http.ca_path = Paypalable::Config.ssl_cert_path unless Paypalable::Config.ssl_cert_path.nil?

        begin
          response_data = http.post(path, api_request_data, Paypalable::Config.headers)
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
