module WebpackNative::WebpackNativeHelper
  
  def webpack_stylesheet_tag(asset, **html_options)
    html_options = html_options.merge(
      href: webpack_stylesheet_path(asset),
      rel: "stylesheet"
    )
    tag.link(html_options).html_safe
  end

  def webpack_stylesheet_path(asset, **options)
    path_to_asset(webpack_native_lookup("#{asset.gsub('.css', '')}.css"), options)
  end

  def webpack_stylesheet_url(asset, **options)
    url_to_asset(webpack_native_lookup("#{asset.gsub('.css', '')}.css"), options)
  end

  def webpack_javascript_tag(asset, **html_options)
    html_options = html_options.merge(
      type: "text/javascript",
      src: webpack_javascript_path(asset)
    )
    content_tag("script".freeze, nil, html_options).html_safe
    # or tag.script(html_options).html_safe
  end

  def webpack_javascript_url(asset, **options)
    url_to_asset(webpack_native_lookup("#{asset.gsub('.js', '')}.js"), options)
  end
  def webpack_javascript_path(asset, **options)
    path_to_asset(webpack_native_lookup("#{asset.gsub('.js', '')}.js"), options)
  end

  def webpack_image_tag(image, **options)
    image_tag(webpack_native_lookup(image), **options)
  end

  def webpack_image_url(image, **options)
    image_url(webpack_native_lookup(image), **options)
  end

  def webpack_image_path(image, **options)
    image_path(webpack_native_lookup(image), **options)
  end
  
  # ====== Favicon helpers ======
  # usage:
  # <%= webpack_favicons('apple-touch-icon.png', 'favicon-32x32.png', 'favicon-16x16.png') %>
  # <%= webpack_webmanifest('manifest.webmanifest') %>
  
  # result:
  #<link rel="apple-touch-icon" sizes="180x180" href="/apple-touch-icon.png">
  #<link rel="icon" type="image/png" sizes="32x32" href="/favicon-32x32.png">
  #<link rel="icon" type="image/png" sizes="16x16" href="/favicon-16x16.png">
  #<link rel="manifest" href="/site.webmanifest">

  def webpack_favicons(*args)
    tags = []
    args.each do |favicon|
      
      filename = File.basename(favicon, ".*") # exclude the extension
      ext = File.extname(favicon)
      
      if ext == '.webmanifest'
        manifest = favicon
        html_options = {
          rel: 'manifest',
          href: manifest
        }
        
      else
        mimetypes = {
          '.png' => 'image/png',
          '.jpg' => 'image/jpg',
          '.jpeg' => 'image/jpeg',
          '.webp' => 'image/webp',
          '.tiff' => 'image/tiff',
          '.svg' => 'image/svg+xml',
          '.ico' => 'image/x-icon'
        }
        
        html_options = {
          rel: filename == 'apple-touch-icon' ? 'apple-touch-icon' : 'icon',
          type: mimetypes[ext],
          href: favicon
        }
        
        sizes = filename[/(.+)?([0-9]{2,3}x[0-9]{2,3})(.+)?/, 2]
        
        sizes = '180×180' if filename == 'apple-touch-icon'
          
        html_options = html_options.merge({sizes: sizes}) unless sizes.nil?
        
      end
       
      tags << tag.link(html_options)
      
    end
    
    return tags.join.html_safe
  
  end
  
  # ====== End favicon helpers ======

  private

    def webpack_native_lookup(file)
      "/webpack_native/#{webpack_manifest_file.fetch("#{file}")}"
    end

    def webpack_manifest_file
      # in production, webpack_manifest_file is initialized in railtie.rb file to load one time only, while in development we call load_webpack_manifest on each new request

      # so we always start by checking webpack_manifest_file from the initialized configuration, if not found (which is the case for development) we fetch get it from the filesystem

      Rails.configuration.x.webpack_native.webpack_manifest_file || load_webpack_manifest
    end

    def load_webpack_manifest
      # Set WEBPACK_MANIFEST_PATH to point to the manifest file
      webpack_manifest_path = Rails.root.join('public', 'webpack_native', 'manifest.json')
      JSON.parse(File.read(webpack_manifest_path))
    rescue Errno::ENOENT
      fail "The webpack manifest file does not exist. Hint: run webpack command."
    end

    # we make load_webpack_manifest method as a module function so we can call it from railtie.rb file withing the initializer.
    module_function :load_webpack_manifest

end
