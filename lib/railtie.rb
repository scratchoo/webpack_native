require 'rails'

class WebpackNative::Railtie < ::Rails::Railtie

  initializer "webpack_native_set_manifest" do

    def load_webpack_manifest
      # Set WEBPACK_MANIFEST_PATH to point to the manifest file
      webpack_manifest_path = Rails.root.join('public', 'webpack_native', 'manifest.json')
      JSON.parse(File.read(webpack_manifest_path))
    rescue Errno::ENOENT
      fail "The webpack manifest file does not exist. Hint: run webpack command."
    end

    if Rails.env.production?
      # require_relative 'generators/webpack_native/templates/webpack_native_helper.rb'
      Rails.configuration.x.webpack_native.webpack_manifest_file = load_webpack_manifest
    end
  end

  def start_webpack
    Mutex.new.synchronize do
      Dir.chdir "#{Rails.root}/app/webpack_native" do
        %x{ npm run build }
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
