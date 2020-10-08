class WebpackNative::DevGenerator < Rails::Generators::Base

  def generate_development_assets
    compiling_notice = "Compiling for development..."
    puts "\n" + "\e[36m#{compiling_notice}\e[0m" + "\n\n"

    Mutex.new.synchronize do
      Dir.chdir "#{Rails.root}/app/webpack_native" do
        Dir.mkdir('src/images') unless Dir.exist?('src/images')
        %x{ yarn install }
        result = %x{ npm run build:dev }
        puts "\n"
        puts result
      end
    end
  end

end
