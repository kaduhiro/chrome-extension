import path from 'path';
import webpack from 'webpack';

const isDev = process.env.NODE_ENV !== 'production';

const getEntry = (name: string) => {
  return [path.join('@', name), ...(isDev ? [`mv3-hot-reload/${name}`] : [])];
};

const config: webpack.Configuration = {
  watch: isDev,
  mode: isDev ? 'development' : 'production',
  devtool: isDev ? 'cheap-module-source-map' : 'source-map',
  entry: {
    background: getEntry('background'),
    content: getEntry('content'),
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
