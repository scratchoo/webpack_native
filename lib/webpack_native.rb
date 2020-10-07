require "webpack_native/version"
require 'webpack_native/webpack_native_helper'
require 'webpack_native/runner'
require 'webpack_native/railtie' if defined?(Rails)

module WebpackNative
  # require the webpack_helper file which is within templates folder
  def self.logger
    @@logger ||= defined?(Rails) ? ActiveSupport::Logger.new(STDOUT) : nil
  end

  def self.logger=(logger)
    @@logger = logger
  end
end

# include WebpackNativeHelper for ActionView
ActiveSupport.on_load :action_view do
  ::ActionView::Base.send :include, WebpackNative::WebpackNativeHelper
end
