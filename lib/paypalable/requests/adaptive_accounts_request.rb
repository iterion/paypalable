module Paypalable
  class AdaptiveAccountsRequest < Request
    #Wrap standard Adaptive Accounts requests
    #abstraction of:
    #https://cms.paypal.com/us/cgi-bin/?cmd=_render-content&content_ID=developer/e_howto_api_ACGettingStarted
    #https://svcs.sandbox.paypal.com/AdaptiveAccounts

    class << self
      def create_account(data) 
        wrap_post(data, "/AdaptiveAccounts/CreateAccount")
      end

      def create_account(data) 
        wrap_post(data, "/AdaptiveAccounts/GetVerifiedStatus")
      end
      
    end #class << self
  end # AdaptivePaymentsRequest
end # Paypalable
