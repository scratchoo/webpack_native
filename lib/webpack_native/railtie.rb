require 'rails'
require "open3"
require "fileutils"

class WebpackNative::Railtie < ::Rails::Railtie

  initializer 'Rails logger' do
    WebpackNative.logger = ActiveSupport::Logger.new(STDOUT)
  end

  # Zeitwerk raise an error: set_autoloads_in_dir': wrong constant name Path-dirname inferred by Module from directory (Zeitwerk::NameError) ---> app/webpack_native/node_modules/path-dirname
  # to prevent Zeitwerk from eager loading webpack_native folder we use this:
  initializer "zeitwerk_prevent_loading_webpack_native" do
    if Rails.autoloaders.zeitwerk_enabled?
      Rails.autoloaders.main.ignore(Rails.root.join('app/webpack_native'))
    end
  end

  initializer "webpack_native_set_manifest" do
    if Rails.env.production?

      # create public/webpack_native if it doesn't exist:

      webpack_native_folder = "#{Rails.root}/public/webpack_native"

      unless File.directory?(webpack_native_folder)
        FileUtils.mkdir_p(webpack_native_folder)
      end

      # create manifest.json file if it doesn't exist with an empty json {} to prevent raising error in WebpackNativeHelper.load_webpack_manifest if a restart of a service happen (i.e delayed_job restart) that causes rails to load

      manifest_path = "#{Rails.root}/public/webpack_native/manifest.json"

      unless File.file?(manifest_path)
        FileUtils.touch manifest_path
        File.write manifest_path, "{}"
      end
      require_relative 'webpack_native_helper'
      Rails.configuration.x.webpack_native.webpack_manifest_file = WebpackNative::WebpackNativeHelper.load_webpack_manifest

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
      if defined?(Rails::Server) && Rails.env.development?
        Thread.new { start_webpack }
      end
    end
  end

end
