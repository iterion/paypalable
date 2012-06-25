module Paypalable
  class Middleware
    class << self
      def call(env)
        ipn = Paypalable::IpnNotification.new(env['rack.input'].read)
        ipn.send_back
        if ipn.verified?
          ipn_verified ipn, env
        else
          ipn_not_verified ipn, env
        end

        [200, {"Content-Type" => "text/html"}, []]
      end
      
      def ipn_verified(ipn, env)
      end
      
      def ipn_not_verified(ipn, env)
      end
    end #eigenclass
  end #Middleware
end