// Generated by CoffeeScript 1.8.0
(function() {
  'use strict';
  ace.define('ace/mode/chip8', function(require_, exports, module) {
    var HighlightRules, Mode, TextMode, Tokenizer, oop;
    oop = require_('ace/lib/oop');
    TextMode = require_('./text').Mode;
    Tokenizer = require_('ace/tokenizer').Tokenizer;
    HighlightRules = require_('ace/mode/chip8-rules').Chip8HighlightRules;
    Mode = function() {
      this.$tokenizer = new Tokenizer(new HighlightRules().getRules());
    };
    oop.inherits(Mode, TextMode);
    exports.Mode = Mode;
  });

}).call(this);