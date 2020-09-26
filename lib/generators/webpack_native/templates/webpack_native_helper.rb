module WebpackNativeHelper

  def webpack_stylesheet_url(asset, **html_options)
    html_options = html_options.merge(
      href: "/webpack_native/#{webpack_manifest_file.fetch("#{asset}.css")}",
      rel: "stylesheet"
    )
    tag.link(html_options).html_safe
  end

  def webpack_javascript_url(asset, **html_options)
    html_options = html_options.merge(
      type: "text/javascript",
      src: "/webpack_native/#{webpack_manifest_file.fetch("#{asset}.js")}"
    )
    content_tag("script".freeze, nil, html_options).html_safe
    # or tag.script(html_options).html_safe
  end

  def webpack_image_url(file_name, **options)
    image_tag("/webpack_native/#{file_name}", **options)
  end

  private

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
