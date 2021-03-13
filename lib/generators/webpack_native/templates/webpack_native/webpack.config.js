const path = require('path');
const MiniCssExtractPlugin = require("mini-css-extract-plugin");
const OptimizeCSSAssetsPlugin = require('optimize-css-assets-webpack-plugin');
const TerserJSPlugin = require('terser-webpack-plugin');
const { CleanWebpackPlugin } = require('clean-webpack-plugin');
const CompressionPlugin = require('compression-webpack-plugin');
const zopfli = require('@gfx/zopfli');
const WebpackManifestPlugin = require('webpack-manifest-plugin');
const webpack = require('webpack');

module.exports = (env, options) => {

  const devMode = options.mode !== 'production';

  return {

    devtool: devMode ? "cheap-module-eval-source-map" : undefined,
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
      filename: '[name]-[contenthash].js',
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
          test: /\.(png|jpg|jpeg|gif|svg|ttf|woff2|woff|eot|ico|webmanifest)$/i,
          use: [
            {
              loader: 'url-loader',
              options: {
                limit: false,
                name: '[name]-[hash:7].[ext]'
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
        filename: '[name]-[contenthash].css',
      }),
      // In production, compress static files to .gz (using zopfli) and .br (using brotli) format
      !devMode && new CompressionPlugin({
        filename: '[path][base].gz[query]',
        compressionOptions: {
          numiterations: 15
        },
        algorithm(input, compressionOptions, callback) {
          return zopfli.gzip(input, compressionOptions, callback);
        },
        test: /\.(js|css|html|svg|ico|eot|ttf|otf|map)$/,
        threshold: 10240,
        minRatio: 0.8,
        deleteOriginalAssets: false
      }),
      !devMode && new CompressionPlugin({
        filename: '[path][base].br',
        algorithm: 'brotliCompress',
        test: /\.(js|css|html|svg|ico|eot|ttf|otf|map)$/,
        compressionOptions: {
          level: 11,
        },
        threshold: 10240,
        minRatio: 0.8,
      })
    ].filter(Boolean), // filter(Boolean) to prevent false values when it's devMode
    // resolve: {
    //   alias: {},
    //   modules: [
    //     path.resolve(__dirname, '../../vendor/javascripts'),
    //     path.resolve(__dirname, '../../vendor/stylesheets',
    //     'node_modules'
    //   ]
    // }

  };

};
