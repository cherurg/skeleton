#config = require './NetConfig.coffee'

class Gate
  constructor: (overContainer, socket) ->
    @socket = socket
    @container = overContainer
    if @container.type is 'receiver' and @socket?
      @socket.on 'plot-data', @receive.bind(@)

  send: ->
    return unless @container.type is 'sender' and @socket?
    @socket.emit 'plot-data', @container.getModel()

  receive: (model) ->
    @container.setModel(model)

  getSocket: () -> if @socket? then @socket

module.exports = Gate;
