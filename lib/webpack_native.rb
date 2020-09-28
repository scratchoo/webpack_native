require "webpack_native/version"
require 'generators/webpack_native/templates/webpack_native_helper'
require 'webpack_native/railtie' if defined?(Rails)

module WebpackNative
  # require the webpack_helper file which is within templates folder
end

# include WebpackNativeHelper for ActionView
ActiveSupport.on_load :action_view do
  ::ActionView::Base.send :include, WebpackNativeHelper
end
