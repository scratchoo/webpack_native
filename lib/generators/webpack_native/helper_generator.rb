class WebpackNative::HelperGenerator < Rails::Generators::Base

  # our templates location:
  source_root File.expand_path('templates', __dir__)

  #this is used to generate/add the helper file to rails project
  def add_webpack_helper
    template "webpack_native_helper.rb", File.join("app/helpers", "webpack_native_helper.rb")
  end

  # include_webpack_helper in application_controller.rb
  def include_webpack_helper
    application_controller = "#{Rails.root}/app/controllers/application_controller.rb"

    include_webpack_helper = "\n\tinclude WebpackNativeHelper"

    class_declaration = 'class ApplicationController < ActionController::Base'

    inject_into_file application_controller, include_webpack_helper, after: class_declaration
  end

end
