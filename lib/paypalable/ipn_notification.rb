require 'net/http'
require 'net/https'
require 'json'

module Paypalable
  class IpnNotification
    def send_back(data)
      data = "cmd=_notify-validate&#{data}"
      url = URI.parse Paypalable::Config.paypal_base_url
      http = Net::HTTP.new(url.host, 443)
      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_PEER
      http.ca_path = Paypalable::Config.ssl_cert_path unless Paypalable::Config.ssl_cert_path.nil?

      if Paypalable::Config.ssl_cert_file
        cert = File.read(Paypalable::Config.ssl_cert_file)
        http.cert = OpenSSL::X509::Certificate.new(cert)
        http.key = OpenSSL::PKey::RSA.new(cert)
      end

      path = "#{Paypalable::Config.paypal_base_url}/cgi-bin/webscr"
      response_data = http.post(path, data).body

      @verified = response_data == "VERIFIED"
    end

    def verified?
      @verified
    end

  end
end
