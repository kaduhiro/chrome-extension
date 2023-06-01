import path from 'path';
import webpack from 'webpack';

const config: webpack.Configuration = {
  entry: {
    background: path.join('@', 'background'),
    content: path.join('@', 'content'),
    popup: path.join('@', 'popup'),
  },
  output: {
    path: path.join(__dirname, 'dist', 'js'),
    filename: '[name].bundle.js',
  },
  module: {
    rules: [
      {
        test: /\.ts$/,
        use: 'ts-loader',
        exclude: /node_modules/,
      },
    ],
  },
  resolve: {
    extensions: ['.ts', '.js'],
    alias: {
      '~': path.resolve(__dirname),
      '@': path.join(__dirname, 'src'),
    },
  },
  plugins: [
    new webpack.ProvidePlugin({
      process: 'process/browser',
      $: 'jquery',
      jQuery: 'jquery',
    }),
  ],
};

export default config;
