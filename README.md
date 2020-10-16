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
gem 'webpack_native', '~> 0.4.5'
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
npm run build --mode=production
```

The same command exist for development (in case you need it) just replace :prod by :dev (yep! you guessed it already.)

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/scratchoo/webpack_native.


## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
