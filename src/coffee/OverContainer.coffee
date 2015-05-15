Wrap = require './Wrap.coffee'
ee = require 'event-emitter'
Gate = require './Gate.coffee'

class OverContainer extends Wrap
  constructor: (type) ->
    super()
    @type = type
    @gate = new Gate @

  getModel: ->
    @arr.map (el) -> el.el.getModel()

  setModel: (modelContainer) ->
    modelContainer.forEach (model, i) =>
      @arr[i].el.setModel(model)

  add: (el) ->
    Wrap::add.call(@, el)
    el.emitter.on 'drawn', =>
      if overContainer.type is 'sender'
        @gate.send()

module.exports = OverContainer