module Paypalable
  class Middleware
    def initialize(app)
      @app = app
    end
  
    def call(env)
      if env["PATH_INFO"] =~ /^\/donations\/ipn/
        ipn = Paypalable::IpnNotification.new(env['rack.input'].read)
        ipn.send_back
        if ipn.verified?
          ipn_verified ipn, env
        else
          ipn_not_verified ipn, env
        end

        [200, {"Content-Type" => "text/html"}, []]
      else
        @app.call(env)
      end
    end
    
    def ipn_verified(ipn, env)
    end
    
    def ipn_not_verified(ipn, env)
    end
  end
end