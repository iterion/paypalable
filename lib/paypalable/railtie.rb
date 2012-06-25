require 'rails'

class Paypalable::Railtie < Rails::Railtie
  config.paypalable = Paypalable::Config

  initializer "paypalable.active_record" do |app|
    ActiveSupport.on_load :active_record do
      include ActiveRecord::Paypalable
    end
  end
end