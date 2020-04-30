const path = require('path');
const Watchpack = require('watchpack');
const CopyPlugin = require("copy-webpack-plugin");
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
    contentBase: [outputPath],
  },
  plugins: [
    new SwiftWebpackPlugin({
      packageDirectory: __dirname,
      target: 'GitHubExampleWeb',
      dist: outputPath
    }),
    new CopyPlugin([staticPath]),
  ],
};
