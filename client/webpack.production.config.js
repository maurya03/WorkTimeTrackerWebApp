const webpack = require("webpack");
const HtmlWebpackPlugin = require("html-webpack-plugin");
const path = require("path");
const MiniCssExtractPlugin = require("mini-css-extract-plugin");
const UglifyJsPlugin = require("uglifyjs-webpack-plugin");

module.exports = {
    mode: "production",
    performance: {
        hints: false,
        maxEntrypointSize: 512000,
        maxAssetSize: 512000
    },
    entry: {
        // vendor: ["babel-polyfill"],
        app: "./src/index.js"
    },
    output: {
        filename: "static/[name].[hash].js",
        path: path.resolve(__dirname, "dist"),
        publicPath: ""
    },
    resolve: {
        alias: {
            "react-dom": "@hot-loader/react-dom",
            rootpath: path.resolve(__dirname, "src")
        },
        extensions: [".json", ".js", ".jsx"]
    },
    devtool: false,
    module: {
        rules: [
            {
                test: /\.jsx?$/,
                exclude: /node_modules/,
                use: ["babel-loader"]
            },
            {
                test: /\.less$/,
                use: [
                    "style-loader",
                    {
                        loader: "css-loader",
                        options: {
                            importLoaders: 2
                        }
                    },
                    "postcss-loader",
                    "less-loader"
                ]
            },
            {
                test: /\.css$/,
                use: [
                    {
                        loader: "style-loader"
                    },
                    {
                        loader: "css-loader",
                        options: {
                            modules: true,
                            localsConvention: "camelCase",
                            sourceMap: true
                        }
                    }
                ]
            },
            {
                test: /\.(scss)$/,
                use: [
                    {
                        // Adds CSS to the DOM by injecting a `<style>` tag
                        loader: "style-loader"
                    },
                    {
                        // Interprets `@import` and `url()` like `import/require()` and will resolve them
                        loader: "css-loader"
                    },
                    {
                        // Loader for webpack to process CSS with PostCSS
                        loader: "postcss-loader",
                        options: {
                            postcssOptions: {
                                plugins: function () {
                                    return [require("autoprefixer")];
                                }
                            }
                        }
                    },
                    {
                        // Loads a SASS/SCSS file and compiles it to CSS
                        loader: "sass-loader"
                    }
                ]
            },
            { test: /\.png$/, loader: "url-loader?limit=100000" },
            {
                test: /\.(jpg|eot|svg|ttf|woff|woff2)(\?v=[0-9]\.[0-9]\.[0-9])?$/,
                loader: "file-loader?name=[hash].[ext]"
            }
        ]
    },
     optimization: {
    runtimeChunk: true,
  },

     externals: {
        Configurator: JSON.stringify(require("./config/appsettings.prod.json"))
    },
    plugins: [
        new webpack.DefinePlugin({
            "process.env": {
                NODE_ENV: JSON.stringify("production")
            }
        }),
        new HtmlWebpackPlugin({
            template: "public/index.html",
            favicon: "public/favicon.ico"
        }),
        // Create the stylesheet under 'styles' directory
        new MiniCssExtractPlugin({
            filename: "styles/styles.[hash].css"
        })
    ]
};
