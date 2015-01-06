'use strict'

describe 'assembler', ->
  assembler = window.Chip8Assembler()
  assemble = assembler.assemble

  splitWords = (words) ->
    bytes = []
    words.forEach (word) ->
      bytes.push (word >> 8), (word & 0xFF)
      return
    bytes

  describe 'labels', ->
    it 'throws an error if a label is declared twice', ->
      expect -> assemble 'label1:\nlabel1:'
      .toThrow Error "label 'label1' declared twice"


  describe 'jump', ->
    it 'encodes one jump', ->
      expect assemble 'label1:\njump label1'
      .toEqual splitWords [0x1000 | 0x0200 | 0]

    it 'encodes more jumps', ->
      expect assemble 'label1:\njump label1\nlabel2:\njump label2'
      .toEqual splitWords [0x1000 | (0x0200 + 0), 0x1000 | (0x0200 + 2)]

    it 'encodes jumps to labels not yet declared', ->
      expect assemble 'label1:\njump label2\nlabel2:\njump label1'
      .toEqual splitWords [0x1000 | (0x0200 + 2), 0x1000 | (0x0200 + 0)]


  describe 'sei', ->
    it 'encodes', ->
      expect assemble 'sei vA 31'
      .toEqual splitWords [0x3000 | 0x0A00 | 31]