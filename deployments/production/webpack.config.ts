import merge from 'webpack-merge';
import webpack from 'webpack';

import config from '../..//webpack.config';

const productionConfig: webpack.Configuration = merge(config, {
  mode: 'production',
  devtool: 'source-map',
});

export default productionConfig;
