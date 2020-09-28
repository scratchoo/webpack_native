class WebpackNative::InstallGenerator < Rails::Generators::Base

  # our templates location:
  source_root File.expand_path('templates', __dir__)

  def debug
    puts "generator working"
  end
  
  # desc "Generates webpack_native foldere with basic files package.json webpack.config.js as well as the src folder with stylesheets & javascripts & images folders"
  #
  # # Note: everything we we will copy to our Rails app is within 'templates' folder
  #
  # # (1) we copy webpack_native folder into Rails /app folder
  # def add_webpack_native_folder
  #   directory 'webpack_native', 'app/webpack_native'
  # end
  #
  # # (2) insert necessary helpers in the layouts/application.html.erb to render the <link> and <javascript> tags
  # def inject_stylesheets_and_javascript_tags
  #   application_layout = "#{Rails.root}/app/views/layouts/application.html.erb"
  #
  #   stylesheets_tag = "<%= webpack_stylesheet_url 'application', media: 'all', 'data-turbolinks-track': 'reload' %>"
  #
  #   javascripts_tag = "<%= webpack_javascript_url 'application', 'data-turbolinks-track': 'reload' %>"
  #
  #   inject_into_file application_layout, "\n\t\t#{stylesheets_tag}\n\t\t#{javascripts_tag}\n", :before => '</head>'
  # end
  #
  # # (3) run 'npm install' inside app/webpack_native folder to install the base modules
  # def run_npm_install
  #   Dir.chdir "#{Rails.root}/app/webpack_native" do
  #     %x{ npm install }
  #   end
  # end
  #
  # # this step was moved to railtie class, it's better to run webpack within the gem after initialize than injecting the code in config.ru
  # # (4) When the server starts, start webpack in a separate thread (this should be done in config.ru)
  # # def inject_webpack_command
  # #   webpack_command = <<-RUBY
  # #   Thread.new do
  # #     Dir.chdir "#{Rails.root}/app/webpack_native" do
  # #       %x{ npm run build }
  # #     end
  # #   end
  # #   RUBY
  # #
  # #   # https://stackoverflow.com/questions/8543904/how-to-run-my-ruby-code-after-rails-server-start
  # #   config_ru = "#{Rails.root}/config.ru"
  # #
  # #   inject_into_file config_ru, webpack_command, before: 'run Rails.application'
  # # end

end
