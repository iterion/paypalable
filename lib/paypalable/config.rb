module Paypalable
  module Config
    PAYPAL_BASE_URL_MAPPING = {
      :production => "https://www.paypal.com",
      :sandbox => "https://www.sandbox.paypal.com",
      :beta_sandbox => "https://www.beta-sandbox.paypal.com"
    } unless defined? PAYPAL_BASE_URL_MAPPING

    API_BASE_URL_MAPPING = {
      :production => "https://svcs.paypal.com",
      :sandbox => "https://svcs.sandbox.paypal.com",
      :beta_sandbox => "https://svcs.beta-sandbox.paypal.com"
    } unless defined? API_BASE_URL_MAPPING
    
    class << self
      attr_accessor :paypal_base_url, :api_base_url, :ssl_cert_path, :ssl_cert_file, :username, :password, :application_id, :signature
      
      def paypal_environment=(env)
        @paypal_base_url = PAYPAL_BASE_URL_MAPPING[env]
        @api_base_url = API_BASE_URL_MAPPING[env]
      end

      def init!
        @ssl_cert_path = nil
        @ssl_cert_file = nil
        @signature = nil
      end
      
      def headers
        @headers = {
          "X-PAYPAL-SECURITY-USERID" => @username,
          "X-PAYPAL-SECURITY-PASSWORD" => @password,
          "X-PAYPAL-APPLICATION-ID" => @application_id,
          "X-PAYPAL-REQUEST-DATA-FORMAT" => "JSON",
          "X-PAYPAL-RESPONSE-DATA-FORMAT" => "JSON"
        }
        @headers.merge!({"X-PAYPAL-SECURITY-SIGNATURE" => @signature}) if @signature
      end
    end
    init!
  end
end
