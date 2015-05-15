mocha = require 'mocha'
should = require 'should'
Wrap = require '../src/coffee/Wrap.coffee'
_ = require 'lodash'

describe 'Wrap', ->

  wrap = new Wrap
  o1 = {}
  o2 = {}

  it 'add', ->
    a = wrap.addElement o1
    a.should.be.an.instanceOf Object
    a.should.be.equal o1

    wrap.arr.should.have.length 1
    wrap.arr[0].should.be.equal o1
    should(wrap.arr[0]).be.ok

    o2 = {}
    b = wrap.addElement o2
    b.should.be.an.instanceOf Object
    b.should.be.equal o2
    wrap.arr.should.have.length 2
    should(wrap.arr[1]).be.ok

  it 'each', ->
    wrap.each (el, i) ->
      el.test = i

    wrap.arr[0].test.should.be.equal 0
    wrap.arr[1].test.should.be.equal 1

  it 'remove', ->
    wrap.removeElement 0
    wrap.arr.should.have.length 1
    wrap.arr.should.containEql o2
    wrap.arr[0].should.be.equal o2

    wrap.removeElement o2
    wrap.arr.should.have.length 0

  it 'removeAll', ->
    wrap.add {}
    wrap.removeAll()
    wrap.arr.length.should.be.equal 0

  it 'empty', ->
    wrap.empty().should.be.ok