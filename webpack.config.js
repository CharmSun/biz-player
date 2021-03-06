/**
 * build config
 */
var path = require('path'),
    webpack = require('webpack'),
    ExtractTextPlugin = require("extract-text-webpack-plugin");

var config = {
    entry: path.join(__dirname, 'src/main'),
    output: {
        path: path.join(__dirname, 'dist'),
        filename: 'biz-player.js'
    },
    module: {
        loaders: [
            {
                test: /\.css$/i,
                loader: ExtractTextPlugin.extract('style-loader', 'css-loader')
            },
            {
                test: /\.(jpe?g|png|gif)$/i,
                loaders: ['url?limit=10000&name=images/[hash:8].[name].[ext]']
            },
            {
                test: /\.tpl$/i,
                loader: "mustache-loader"
            }
        ]
    },
    plugins: [
        new webpack.optimize.UglifyJsPlugin({
            compress: {
                warnings: false
            }
        }),
        new ExtractTextPlugin('biz-player.css')
    ],
    devtool: '#source-map'
};

module.exports = config;
