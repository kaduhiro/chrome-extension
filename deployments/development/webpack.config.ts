import path from 'path';
import merge from 'webpack-merge';
import webpack from 'webpack';

import config from '../../webpack.config';

const developmentConfig: webpack.Configuration = merge(config, {
  watch: true,
  mode: 'development',
  devtool: 'cheap-module-source-map',
  entry: {
    background: [path.join('@', 'background'), 'mv3-hot-reload/background'],
    content: [path.join('@', 'content'), 'mv3-hot-reload/content'],
    popup: path.join('@', 'popup'),
  },
});

export default developmentConfig;
