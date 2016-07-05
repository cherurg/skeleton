extend = require 'lodash/extend'
pick = require 'lodash/pick'
keys = require 'lodash/keys'
clone = require 'lodash/clone'
isNumber = require 'lodash/isNumber'
isString = require 'lodash/isString'
sortBy = require 'lodash/sortBy'
each = require 'lodash/each'
filter = require 'lodash/filter'
isFunction = require 'lodash/isFunction'

_ = {extend, pick, keys, clone, isNumber, isString, sortBy, each, filter, isFunction}

_.extendDefaults = (object, options) ->
  extend object, object.defaults, pick(options, keys object.defaults)


module.exports = _
