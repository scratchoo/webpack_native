const path = require('path');
const MiniCssExtractPlugin = require("mini-css-extract-plugin");
const OptimizeCSSAssetsPlugin = require('optimize-css-assets-webpack-plugin');
const TerserJSPlugin = require('terser-webpack-plugin');
const { CleanWebpackPlugin } = require('clean-webpack-plugin');
const WebpackManifestPlugin = require('webpack-manifest-plugin');
const webpack = require('webpack');

const mode = "development";

module.exports = {

  watch: true,
  mode: mode,
  devtool: "cheap-module-eval-source-map",
  optimization: {
    minimizer: [
      new TerserJSPlugin({}),
      new OptimizeCSSAssetsPlugin({})
    ],
  },
  entry: {
    application: "./src/javascripts/application.js"
  },
  output: {
    filename: mode === 'production' ? "[name]-[contenthash].js" : '[name].js',
    path: path.resolve(__dirname, '../../public/webpack_native')
  },
  module: {
    rules: [
      {
        test: /\.m?js$/,
        exclude: /(node_modules|bower_components)/,
        use: {
          loader: 'babel-loader',
          options: {
            presets: ['@babel/preset-env']
          }
        }
      },
      {
        test: /\.css|.scss$/i,
        use: [
          // 'style-loader',
          // MiniCssExtractPlugin.loader,
          {
            loader: MiniCssExtractPlugin.loader,
            options: {
              hmr: true,
            },
          },
          { loader: 'css-loader', options: { importLoaders: 1 } },

          'sass-loader'
        ],
      },
      {
        test: /\.(png|jpg|gif|svg)$/i,
        use: [
          {
            loader: 'url-loader',
            options: {
              limit: 8192,
              name: mode === "production" ? "[name]-[hash:7].[ext]" : "[name].[ext]"
            },
          },
          // { loader: 'image-webpack-loader' }
        ],
      }
    ]
  },
  plugins: [
    new webpack.ProvidePlugin({
      // $: 'jquery',
      // jQuery: 'jquery'
    }),
    new WebpackManifestPlugin(),
    new CleanWebpackPlugin(),
    new MiniCssExtractPlugin({
      filename: mode === 'production' ? "[name]-[contenthash].css" : '[name].css',
    })
  ],
  // resolve: {
  //   alias: {},
  //   modules: [
  //     path.resolve(__dirname, '../../vendor/javascripts'),
  //     path.resolve(__dirname, '../../vendor/stylesheets',
  //     'node_modules'
  //   ]
  // }
}
