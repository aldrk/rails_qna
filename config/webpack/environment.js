const { environment } = require('@rails/webpacker')

const webpack = require('webpack')

environment.loaders.get('sass').use.splice(-1, 0, {
    loader: 'resolve-url-loader',
    options: {
        attempts: 1
    }
})

environment.plugins.prepend('Provide', new webpack.ProvidePlugin({
        $: 'jquery',
        JQuery: 'jquery',
        jquery: 'jquery',
        'window.Tether': "tether",
        Popper: ['popper.js', 'default'], // for Bootstrap 4
    })
)

const aliasConfig = {
    'jquery': 'jquery/src/jquery',
    'jquery-ui': 'jquery-ui-dist/jquery-ui.js'
}

environment.config.set('resolve.alias', aliasConfig);

module.exports = environment
