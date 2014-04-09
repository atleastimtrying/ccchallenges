(function() {
  var App, Display, JSON;
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  JSON = (function() {

    function JSON(app) {
      this.app = app;
      this.ready = __bind(this.ready, this);
      $.get('people.json', this.ready);
    }

    JSON.prototype.ready = function(json) {
      this.json = json;
      return $(this.app).trigger('ready', this.json);
    };

    return JSON;

  })();

  Display = (function() {

    function Display(app) {
      this.app = app;
      this.buildPerson = __bind(this.buildPerson, this);
      this.buildDom = __bind(this.buildDom, this);
      this.element = $('#display');
      $(this.app).bind('ready', this.buildDom);
    }

    Display.prototype.buildDom = function(event, json) {
      var person, _i, _len, _ref, _results;
      _ref = json.data;
      _results = [];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        person = _ref[_i];
        _results.push(this.buildPerson(person));
      }
      return _results;
    };

    Display.prototype.buildPerson = function(json) {
      var div;
      div = $('<div class="person">');
      this.populatePerson(json, div);
      return this.element.append(div);
    };

    Display.prototype.populatePerson = function(json, div) {
      var key, value, _results;
      _results = [];
      for (key in json) {
        value = json[key];
        if (typeof value === 'string') div.append(this.buildString(key, value));
        if (typeof value === 'object') {
          _results.push(div.append(this.buildObject(key, value)));
        } else {
          _results.push(void 0);
        }
      }
      return _results;
    };

    Display.prototype.buildString = function(key, string) {
      return "<p><span>" + key + "</span><span>" + string + "</span></p>";
    };

    Display.prototype.buildObject = function(key, object) {
      var string, value;
      string = "<section><h3>" + key + "</h1>";
      for (key in object) {
        value = object[key];
        if (typeof value === 'string') string += this.buildString(key, value);
        if (typeof value === 'object') string += this.buildObject(key, value);
      }
      return string += '</section>';
    };

    return Display;

  })();

  App = (function() {

    function App() {
      this.display = new Display(this);
      this.json = new JSON(this);
    }

    return App;

  })();

  $(function() {
    return window.app = new App;
  });

}).call(this);
