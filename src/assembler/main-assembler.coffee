'use strict'

app = angular.module 'Assembler', []

app.controller 'AssemblerController', ($scope) ->
  { initContext, draw, setVideoData } = Chip8Renderer()

  initContext document.getElementById 'can'

  TICKS_PER_FRAME = 1

  self = @

  rafId = null

  editor = null
  errorLine = null

  @running = false

  @state = null

  assembler = Chip8Assembler()

  keyboard = Chip8Keyboard()
  (document.getElementById 'container').appendChild keyboard.getHtml()

  chip8 = Chip8()
  chip8.setKeyboard keyboard


  onChange = (text) ->
    if text.length == 0
    else
      try
        assembler.assemble text
        if errorLine != null
          editor.getSession().setAnnotations []
          errorLine = null
      catch ex
        if ex.coords?
          errorLine = ex.coords.line
          editor.getSession().setAnnotations([
            row: errorLine
            text: ex.message
            type: 'error'
          ])

    return


  setupEditor = ->
    editor = ace.edit 'editor'
    editor.getSession().setMode 'ace/mode/chip8'
    editor.setTheme 'ace/theme/monokai'
    editor.on 'input', -> onChange editor.getValue()
    return


  setupEditor()


  getState = ->
    programCounter = chip8.getProgramCounter()
    stackPointer = chip8.getStackPointer()
    I = chip8.getI()
    registers = Array::slice.call chip8.getRegisters(), 0
    stack = Array::slice.call chip8.getStack(), stackPointer

    {
      programCounter
      registers
      stackPointer
      I
      stack
    }


  @start = ->
    @reset()
    mainLoop = =>
      for i in [0...TICKS_PER_FRAME]
        chip8.tick()

      setVideoData chip8.getVideo()
      @state = getState()
      $scope.$apply() if not $scope.$$phase
      draw()

      rafId = requestAnimationFrame mainLoop
      return

    mainLoop()
    return


  @stop = ->
    @running = false
    cancelAnimationFrame rafId
    return


  @reset = ->
    @stop()
    text = editor.getValue()
    if text.length
      try
        program = assembler.assemble text
        self.loadProgram program
      catch ex

    chip8.reset()
    @state = getState()
    setVideoData chip8.getVideo()
    draw()


  @reset()


  @loadProgram = chip8.load


  @step = ->
    chip8.tick()
    @state = getState()
    setVideoData chip8.getVideo()
    draw()
    return


  return