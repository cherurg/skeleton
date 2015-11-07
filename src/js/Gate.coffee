config = require './NetConfig.coffee'
socket = require('socket.io-client')(config.host)

class Gate
  constructor: (overContainer) ->
    @container = overContainer
    if @container.type is 'receiver'
      socket.on 'data', @receive.bind(@)

  send: ->
    return unless @container.type is 'sender'
    socket.emit 'data', @container.getModel()

  receive: (model) ->
    @container.setModel(model)

  getSocket: () -> socket

module.exports = Gate;