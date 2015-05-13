config = require './NetConfig.coffee'
socket = require('socket.io-client')(config.host)

class Gate
  constructor: (skeleton) ->
    @skeleton = skeleton
    if @skeleton.type is 'receiver'
      socket.on 'data', @receive.bind(@)

  send: ->
    return unless @skeleton.type is 'sender'
    socket.emit 'data', @skeleton.getModel()

  receive: (model) ->
    @skeleton.setModel(model)

module.exports = Gate;