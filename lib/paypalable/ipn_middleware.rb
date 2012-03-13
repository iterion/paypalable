module Paypalable
  class Middleware
    def initialize(app)
      @app = app
    end
  
    def call(env)
      if env["PATH_INFO"] =~ /^\/donations\/ipn/
        ipn = Paypalable::IpnNotification.new
        ipn.send_back(env['rack.request.form_vars'])
        if ipn.verified?
          ipn_verified ipn
        else
          ipn_not_verified ipn
        end

        [200, {"Content-Type" => "text/html"}, []]
      else
        @app.call(env)
      end
    end
    
    def ipn_verified(ipn)
    end
    
    def ipn_not_verified(ipn)
    end
  end
end