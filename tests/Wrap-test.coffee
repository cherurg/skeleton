mocha = require 'mocha'
should = require 'should'
Wrap = require '../src/coffee/Wrap.coffee'
_ = require 'lodash'


it 'Wrap', ->
  wrap = new Wrap()
  o1 = {}
  a = wrap.addElement o1
  a.should.be.an.instanceOf Object
  a.should.have.property 'el', o1
  a.should.have.property 'number', 0

  wrap.arr.should.have.length 1
  wrap.arr[0].should.have.property 'number', 0
  should(wrap.arr[0].el).be.ok

  o2 = {}
  b = wrap.addElement o2
  b.should.be.an.instanceOf Object
  b.should.have.property 'el', o2
  b.should.have.property 'number', 1
  wrap.arr.should.have.length 2
  wrap.arr[1].should.have.property 'number', 1
  should(wrap.arr[1].el).be.ok

  wrap.removeElement a.number
  wrap.arr.should.have.length 1
  wrap.arr.should.containEql b
  wrap.arr[0].should.have.property 'number', 1
  wrap.arr[0].should.have.property 'el', o2

  wrap.removeElement o2
  wrap.arr.should.have.length 0