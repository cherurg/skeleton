_ = require 'lodash'

_.mixin 'extendDefaults': (object, options) ->
  _.extend object, object.defaults, _.pick(options, _.keys object.defaults)

module.exports = _