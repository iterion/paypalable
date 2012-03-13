require 'rails'

class Paypalable::Railtie < Rails::Railtie
  config.paypalable = Paypalable::Config

  initializer "paypalable.configure" do |app|
    app.config.middleware.insert_before 0, (app.config.paypalable_middleware || Paypalable::Middleware)
  end

  initializer "paypalable.active_record" do |app|
    ActiveSupport.on_load :active_record do
      include ActiveRecord::Paypalable
    end
  end
end