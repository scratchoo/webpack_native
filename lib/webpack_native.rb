# require the webpack_helper file which is within templates folder
require 'generators/webpack_native/templates/webpack_native_helper'
require 'railtie' if defined?(Rails)
require "webpack_native/version"

class WebpackNative::Error < StandardError; end
# Your code goes here...

# include WebpackNativeHelper for ActionView
require 'active_support/lazy_load_hooks'
ActiveSupport.on_load :action_view do
  ::ActionView::Base.send :include, WebpackNativeHelper
end
