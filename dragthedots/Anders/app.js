(function() {
  var App, Game, Timer;
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  Timer = (function() {

    function Timer(app) {
      this.app = app;
      this.stop = __bind(this.stop, this);
      this.start = __bind(this.start, this);
      this.end = __bind(this.end, this);
      this.tick = __bind(this.tick, this);
      this.going = false;
      this.count = 0;
    }

    Timer.prototype.tick = function() {
      var fraction;
      fraction = this.count / 10;
      $('.timer').html(fraction.toFixed(1));
      this.count += 1;
      if (this.going) return window.setTimeout(this.tick, 100);
    };

    Timer.prototype.end = function() {
      this.going = false;
      this.app.score = this.count / 10;
      return $(this.app).trigger('show', 'score');
    };

    Timer.prototype.start = function() {
      this.count = 0;
      this.going = true;
      return this.tick();
    };

    Timer.prototype.stop = function() {
      this.going = false;
      return this.count = 0;
    };

    return Timer;

  })();

  Game = (function() {

    function Game(app) {
      this.app = app;
      this.hitDetection = __bind(this.hitDetection, this);
      this.startGame = __bind(this.startGame, this);
      this.name = __bind(this.name, this);
      $(this.app).on('startGame', this.startGame);
      this.count = 8;
      this.timer = new Timer(this.app);
    }

    Game.prototype.name = function() {
      var count;
      count = this.count;
      return $(".table" + count).prev('h3').text();
    };

    Game.prototype.startGame = function(event, options) {
      if (options == null) {
        options = {
          count: this.count,
          layout: this.layout
        };
      }
      $('.screen').hide();
      $('#container').show();
      if (options.count) this.count = options.count;
      if (options.layout) this.layout = options.layout;
      $(this.app).trigger('show', 'game');
      $('#container .dot').remove();
      this.addDots();
      this.makeDotsDraggable();
      this.layoutDots();
      return this.timer.start();
    };

    Game.prototype.collide = function(item1, item2) {
      var dist, range, xs, ys;
      xs = item1.left - item2.left;
      xs = xs * xs;
      ys = item1.top - item2.top;
      ys = ys * ys;
      range = $('#container .dot').width();
      dist = Math.sqrt(xs + ys);
      return dist < range;
    };

    Game.prototype.hitDetection = function(event) {
      var dot, dot_value, dotid, newValue, target;
      dot = $(event.target);
      dotid = dot.attr('data-id');
      dot_value = dot.attr('data-value');
      target = $("[data-value=" + dot_value + "]").not("[data-id=" + dotid + "]");
      if (target[0] && this.collide(dot.offset(), target.offset())) {
        $(this.app).trigger('collide');
        newValue = parseInt(dot_value) + 1;
        target.attr('data-value', newValue).html(newValue);
        target.css({
          background: "hsl(" + (newValue * 30) + ",60%, 60%)"
        });
        dot.remove();
        $('body').css({
          'background-color': "hsl(" + (newValue * 30) + ",50%, 35%)"
        });
        $(this.app).trigger('stat_hit');
        if (dot_value === ("" + this.count)) return this.timer.end();
      } else {
        return $(this.app).trigger('stat_miss');
      }
    };

    Game.prototype.addDots = function() {
      var i, oldvalue, value, _ref;
      oldvalue = 1;
      value = 1;
      for (i = 0, _ref = this.count - 1; 0 <= _ref ? i <= _ref : i >= _ref; 0 <= _ref ? i++ : i--) {
        $('#container').append("<div class='dot' data-value='" + value + "' data-id='" + i + "' >" + value + "</div>");
        oldvalue = value;
        value = oldvalue + 1;
      }
      return $('#container').prepend('<div class="dot" data-value="1" data-id="1000" >1</div>');
    };

    Game.prototype.makeDotsDraggable = function() {
      return $('.dot').draggable({
        stop: this.hitDetection,
        containment: "#container",
        scroll: false
      });
    };

    Game.prototype.getCoors = function(e) {
      var coors, event, thisTouch;
      event = e.originalEvent;
      coors = [];
      if (event.targetTouches && event.targetTouches.length) {
        thisTouch = event.targetTouches[0];
        coors[0] = thisTouch.clientX;
        coors[1] = thisTouch.clientY;
      } else {
        coors[0] = event.clientX;
        coors[1] = event.clientY;
      }
      return coors;
    };

    Game.prototype.layoutDots = function() {
      var center, count, difference, edge, i, layouts, x, y, _ref;
      var _this = this;
      count = $('#container .dot').length;
      layouts = [];
      edge = Math.floor(Math.sqrt(count)) - 1;
      x = 0;
      y = 0;
      for (i = 0, _ref = count - 1; 0 <= _ref ? i <= _ref : i >= _ref; 0 <= _ref ? i++ : i--) {
        layouts.push({
          x: x,
          y: y
        });
        if (x < edge) {
          x += 1;
        } else {
          x = 0;
          y += 1;
        }
      }
      layouts = layouts.sort(function() {
        return 0.5 - Math.random();
      });
      difference = (edge + 1) / 2 * 60;
      center = {
        x: ($('#container').width() / 2) + difference,
        y: ($('#container').height() / 2) + difference
      };
      return $('#container .dot').each(function(index, dot) {
        var coords;
        coords = layouts[index];
        $(dot).css({
          left: center.x - coords.x * 70,
          top: center.y - coords.y * 70,
          background: "hsl(" + (index * 30) + ",60%, 60%)"
        });
        $(dot).css({
          background: index === 0 ? "hsl(30,60%, 60%)" : void 0
        });
        return $('body').css({
          'background-color': "hsl(" + (index * 30) + ",50%, 35%)"
        });
      });
    };

    return Game;

  })();

  App = (function() {

    function App() {
      this.show = __bind(this.show, this);
      var _this = this;
      this.game = new Game(this);
      $(this).trigger('startGame');
      $(this).on('show', this.show);
      $('.startGame').click(function() {
        return $(_this).trigger('startGame');
      });
    }

    App.prototype.show = function(event, label) {
      if (label === 'score') {
        $('.screen').hide();
        $('#score').show();
        return $('#scoreMessage').html("" + this.score + " seconds!");
      }
    };

    return App;

  })();

  $(function() {
    return window.app = new App();
  });

}).call(this);
