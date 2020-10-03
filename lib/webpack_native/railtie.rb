require 'rails'
require "open3"

class WebpackNative::Railtie < ::Rails::Railtie

  initializer 'Rails logger' do
    WebpackNative.logger = ActiveSupport::Logger.new(STDOUT)
  end

  initializer "webpack_native_set_manifest" do
    if Rails.env.production?
      require_relative 'generators/webpack_native/templates/webpack_native_helper.rb'
      Rails.configuration.x.webpack_native.webpack_manifest_file = WebpackNativeHelper.load_webpack_manifest
    end
  end

  def start_webpack
    Mutex.new.synchronize do
      Dir.chdir "#{Rails.root}/app/webpack_native" do
        # %x{ ./bin/webpack --watch --colors --progress }
        runner = WebpackNative::Runner.new('npm run build')
        runner.run
      end
    end
  end

  initializer "run_webpack_build_cmd" do
    config.after_initialize do
      if defined?(Rails::Server)
        Thread.new { start_webpack }
      end
    end
  end

end
