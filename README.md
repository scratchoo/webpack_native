# WebpackNative

This gem is for you if:

- You want something fast in compilation.
- You want something easy, no complicated DSL.
- You want to use the same tool for handling all your assets (webpack does the job already).
- You want all your files including the configuration to be in on place (and you just don't like spending time trying to remember where should you put the providePlugin!).
- You want to write pure webpack code (yes webpack is easy, if you don't believe me, [go get my book](https://www.apress.com/us/book/9781484258958) and jump start in a record time).
- last but not least, If you can't wait anymore several days for others to answer your question about why your compilation is failing in production, not everybody knows how the asset pipeline works internally! using this gem just means you are using webpack :)

Briefly, You want more control, and you feel that pure vanilla webpack can give you that, and save you tons of time!

These reasons should be enough to use this gem, but at the end it's more a subject of taste than reasons, everyone has to choose what a delicious food means!

## Want to use ONLY WebpackNative in your project?

If you want to use WebpackNative alone on your new project you can skip the default Rails javascript and the asset pipeline using:

```
rails new app_name -d postgresql --skip-javascript --skip-sprockets
```

**Note:** in case you skipped sprockets, don't forget to remove `<%= stylesheet_link_tag    'application', media: 'all' %>` line from you application layout.

If have an existing project and you want to remove the asset pipeline from your app follow this [tutorial](https://andre.arko.net/2020/07/09/rails-6-with-webpack-in-appassets-and-no-sprockets/)

and to remove webpacker, the answers here may help:

[https://stackoverflow.com/questions/49107973/how-to-completely-remove-webpack-and-all-its-dependencies-from-rails-app](https://stackoverflow.com/questions/49107973/how-to-completely-remove-webpack-and-all-its-dependencies-from-rails-app)

[https://github.com/rails/webpacker/issues/1333](https://github.com/rails/webpacker/issues/1333)

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'webpack_native', '~> 0.5.7'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install webpack_native

### Note

The entry point 'application.js' only includes Turbolinks and Rails UJS by default, if you are going to use active storage or action cable, you may need to add them manually

```
cd app/webpack_native
yarn add package-name ...
```

Then require them in application.js, Hint: you can copy that from webpacker `app/javascript/packs/application.js` :)


## Usage

Once the installation finished, run the following command:

    $ rails g webpack_native:install

This will generate a webpack_native folder, that's where all your assets will go (under a src folder), in plus everything else is there too, the package.json, the webpack config file, the node_modules folder will be there as well.

For both development and production, the output will be in /public/webpack_native

In the application layout, the following will be added for you:

```
<%= webpack_stylesheet_tag 'application', media: 'all', 'data-turbolinks-track': 'reload' %>

"<%= webpack_javascript_tag 'application', 'data-turbolinks-track': 'reload' %>
```

Images are accessible in views using `webpack_image_tag`, just put your images under app/webpack_native/src/images and call it from a view like this:

```
<%= webpack_image_tag('cat.jpg') %>
```

You can also pass other options like you would do with `image_tag`, for example:

```
<%= webpack_image_tag 'beautiful-illustration.png', class: 'responsive-img' %>
```

**Note:** if you were using webpack_native version 0.4.3 or earlier, you should replace `webpack_stylesheet_url`, `webpack_javascript_url` and `webpack_image_url` respectively by `webpack_stylesheet_tag`, `webpack_javascript_tag` and `webpack_image_tag`

Using `webpack_***_url` will return the url string to the asset element and not the tag, the same applies for `webpack_***_path`, so consider using webpack_***_tag whenever you need to output a tag.

### You may not like...

Because you will be using vanilla webpack, to install a JS module/package you will need to `cd` (aka: change directory) to app/webpack_native, then run your `yarn add {package-name}` or `npm install {package-name}`

It's not a big deal, but for some... it might be!

### Compile for production

Once you are ready to go for production, just run

```
rails g webpack_native:prod
```

This is just a shortcut (should we call it so?) to

```
cd app/webpack_native
npm run build:prod
```

Which (in itself) is the equivalent of:

```
cd app/webpack_native
webpack --mode=production
```

The same command exist for development (in case you need it) just replace :prod by :dev (yep! you guessed it already.)

### Gzip and Brotli compression in production

By default, the configuration uses compressionPlugin to compress JS, CSS etc (when compiling for production), so in addition to the minified static files, you will have extra .gz and .br files which will be primarily sent by your server to the user's browser in case it's configured to do so, an example of enabling compression for Nginx would be as follows:

```
server {
  listen 80;
  server_name www.website.com;
  root /app/public/path;
  # ...
  # ...
  location ~ ^/(webpack_native)/ {
    gzip_static on; # turn on gzip compression (supported out of the box)
    brotli_static on; # add this if you want to support brotli as well (but you need to install brotli module)
    expires max;
    add_header Cache-Control public;
  }
}
```

webpack_native use zopfli algorithm to produce gzip files, yep zopfli compression is better than the standard gzip algorithm (while the usage + browsers support are the same) but Brotli compression is by far much better (browsers support is good but not fully!).

In case you want to add Brotli compression to your server, you will need to install brotli module and enable it (in your nginx configuration for example), installation and usage of Brotli module can be found [here](https://github.com/google/ngx_brotli)

### Favicon

If you have a set of favicons (maybe with a site.webmanifest file) you can simply put them under **app/webpack_native/src/favicons** folder and just add the following line to your html layout:

```
<%= webpack_favicons('apple-touch-icon.png', 'favicon-32x32.png', 'favicon-16x16.png', 'site.webmanifest') %>
```
That will generate the following markup:

```
<link rel="apple-touch-icon" sizes="180x180" href="/apple-touch-icon.png">
<link rel="icon" type="image/png" sizes="32x32" href="/favicon-32x32.png">
<link rel="icon" type="image/png" sizes="16x16" href="/favicon-16x16.png">
<link rel="manifest" href="/site.webmanifest">
```

the content of site.webmanifest would be something like:

```
{
  "name":"",
  "short_name":"",
  "icons":
    [
      {"src":"/android-chrome-192x192.png","sizes":"192x192","type":"image/png"},
      {"src":"/android-chrome-512x512.png","sizes":"512x512","type":"image/png"}
    ],
  "theme_color":"#ffffff",
  "background_color":"#ffffff",
  "display":"standalone"
}
```

So, in total you will have the following files in your images folder:

apple-touch-icon.png (180x180)

favicon-32x32.png (32x32)

favicon-16x16.png (16x16)

android-chrome-512x512.png (512x512)

android-chrome-192x192.png (192x192)

site.webmanifest

you can generate all these formats easily using the online favicon generator: https://favicon.io

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/scratchoo/webpack_native.


## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
