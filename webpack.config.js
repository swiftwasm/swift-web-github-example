const path = require('path');
const Watchpack = require('watchpack');
const HtmlWebpackPlugin = require('html-webpack-plugin');
const SwiftWebpackPlugin = require('@swiftwasm/swift-webpack-plugin')

const outputPath = path.resolve(__dirname, 'dist');
const staticPath = path.join(__dirname, 'static');

module.exports = {
  entry: './js/index.js',
  mode: 'development',
  output: {
    filename: 'main.js',
    path: outputPath,
  },
  devServer: {
    inline: true,
    watchContentBase: true,
    contentBase: [
      staticPath,
      outputPath,
    ],
  },
  plugins: [
    new SwiftWebpackPlugin({
      packageDirectory: __dirname,
      target: '__PROJECT_NAME__Web',
      dist: outputPath
    }),
    new HtmlWebpackPlugin({
      template: path.join(staticPath, 'index.html'),
    }),
  ],
};
