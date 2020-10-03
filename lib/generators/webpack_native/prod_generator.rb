class WebpackNative::ProdGenerator < Rails::Generators::Base

  def generate_production_assets
    compiling_notice = "Compiling for production..."
    puts "\n" + "\e[36m#{compiling_notice}\e[0m" + "\n\n"

    Mutex.new.synchronize do
      Dir.chdir "#{Rails.root}/app/webpack_native" do
        result = %x{ npm run build:prod }
        puts "\n"
        puts result
      end
    end
  end

end
