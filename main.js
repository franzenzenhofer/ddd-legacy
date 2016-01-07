// Generated by CoffeeScript 1.10.0
(function() {
  var _DEBUG_, _game_won_, _level_, addDotByEvent, createDot, createEndDot, createFixedDot, d, dot, drawDot, end_dot, gravity, init, isDotOutOfBounds, randomInt, removeDot, restart, setLevelCounter, setWorldColor, two, user_dots, world;

  _DEBUG_ = false;

  d = function(m, debug) {
    if (debug == null) {
      debug = _DEBUG_;
    }
    if (_DEBUG_) {
      return console.log(m);
    }
  };

  randomInt = function(min, max) {
    min = Math.floor(min);
    max = Math.floor(max);
    return Math.floor(Math.random() * (max - min + 1)) + min;
  };

  two = new Two({
    fullscreen: true
  }).appendTo(document.body);

  gravity = Math.floor(two.height / 10);

  world = new p2.World({
    gravity: [0, gravity]
  });

  _game_won_ = -1;

  _level_ = 0;

  end_dot = {};

  dot = {};

  user_dots = [];

  setLevelCounter = function(l, color) {
    var level_element;
    if (l == null) {
      l = 0;
    }
    if (color == null) {
      color = Please.make_color();
    }
    level_element = document.getElementById('level');
    if (!level_element && l === 0) {
      return false;
    }
    if (!level_element) {
      level_element = document.createElement('h2');
      level_element.id = 'level';
      document.body.appendChild(level_element);
    }
    level_element.setAttribute('style', 'color:' + color + ';');
    if (l !== 0) {
      return level_element.innerHTML = "" + l;
    } else {
      return level_element.innerHTML = '' + l;
    }
  };

  setWorldColor = function(color) {
    if (color == null) {
      color = Please.make_color();
    }
    return window.document.body.style.background = color;
  };

  createDot = function(world, two, x, y, r, m) {
    var circle, circleBody, circleShape;
    if (x == null) {
      x = 70;
    }
    if (y == null) {
      y = 200;
    }
    if (r == null) {
      r = 10;
    }
    if (m == null) {
      m = 1;
    }
    x = Math.floor(x);
    y = Math.floor(y);
    r = Math.floor(r);
    circle = two.makeCircle(x, y, r);
    circle.fill = Please.make_color();
    circle.stroke = 'black';
    circle.linewidth = 2;
    circleShape = new p2.Circle({
      radius: r
    });
    circleShape.material = new p2.Material();
    circleBody = new p2.Body({
      mass: m,
      position: [x, y],
      damping: 0,
      angularDamping: 0
    });
    circleBody.ID = false;
    circleBody.addShape(circleShape);
    world.addBody(circleBody);
    return {
      two: circle,
      p2: {
        shape: circleShape,
        body: circleBody
      }
    };
  };

  createFixedDot = function(world, two, dot, w, h, r, m) {
    var new_dot;
    if (m == null) {
      m = 0;
    }
    new_dot = createDot(world, two, w, h, r, m);
    world.addContactMaterial(new p2.ContactMaterial(dot.p2.shape.material, new_dot.p2.shape.material, {
      restitution: 0.9,
      stiffness: Number.MAX_VALUE
    }));
    return new_dot;
  };

  drawDot = function(dot, world, two) {
    if (world == null) {
      world = world;
    }
    if (two == null) {
      two = two;
    }
    dot.two.translation.set(Math.floor(dot.p2.body.position[0]), Math.floor(dot.p2.body.position[1]));
    return dot;
  };

  createEndDot = function(world, two, x, y, r, m) {
    if (world == null) {
      world = world;
    }
    if (two == null) {
      two = two;
    }
    if (y == null) {
      y = randomInt(0, two.height);
    }
    if (r == null) {
      r = 20;
    }
    if (m == null) {
      m = 0;
    }
    if (!x) {
      if (Math.random() < 0.5) {
        x = randomInt(0, Math.floor(two.width / 2) - 15);
      } else {
        x = randomInt(Math.floor(two.width / 2) + 15, two.width);
      }
    }
    end_dot = createDot(world, two, x, y, r, m);
    end_dot.p2.shape.sensor = true;
    end_dot.p2.body.damping = 0;
    end_dot.p2.body.ID = "ENDDOT";
    end_dot.two.fill = 'black';
    return end_dot;
  };

  (init = function() {
    var hard_dots, hd, hd_x, hd_y, i, ref, x;
    setWorldColor();
    end_dot = createEndDot(world, two);
    dot = createDot(world, two, two.width / 2, -30, 10, 1);
    hard_dots = _level_ - 5;
    if (hard_dots > 0) {
      for (x = i = 0, ref = hard_dots; 0 <= ref ? i < ref : i > ref; x = 0 <= ref ? ++i : --i) {
        hd_x = randomInt(0, two.width);
        hd_y = randomInt(50, two.height);
        if (!(hd_x > end_dot.p2.body.position[0] - 35 && hd_x < end_dot.p2.body.position[0] + 35 && hd_y > end_dot.p2.body.position[1] - 35 && hd_y < end_dot.p2.body.position[1] + 35)) {
          hd = createFixedDot(world, two, dot, hd_x, hd_y, 30);
          user_dots.push(hd);
        }
      }
    }
    if (two.height > gravity * 10) {
      dot.p2.body.velocity = [0, Math.floor(two.height / 7)];
    } else {
      dot.p2.body.velocity = [0, Math.floor(two.height / 9)];
    }
    dot.p2.body.ID = "DOT";
    window.scrollTo(0, 1);
    return two.play();
  })();

  removeDot = function(dot) {
    return world.removeBody(dot.p2.body);
  };

  restart = function(won) {
    var doties, i, len;
    if (won == null) {
      won = false;
    }
    two.pause();
    two.clear();
    removeDot(end_dot);
    removeDot(dot);
    for (i = 0, len = user_dots.length; i < len; i++) {
      doties = user_dots[i];
      removeDot(doties);
    }
    user_dots = [];
    if (won === true) {
      _level_ = _level_ + 1;
    } else {
      _level_ = _level_ - 1;
      if (_level_ < 0) {
        _level_ = 0;
      }
    }
    setLevelCounter(_level_);
    return init();
  };

  isDotOutOfBounds = function(dot, world, two) {
    if (world == null) {
      world = world;
    }
    if (two == null) {
      two = two;
    }
    if (dot.p2.body.position[1] > two.height + 50 || dot.p2.body.position[0] < -50 || dot.p2.body.position[0] > two.width + 50) {
      return true;
    } else {
      return false;
    }
  };

  two.bind('update', function(frameCount) {
    drawDot(dot);
    world.step(1 / 60);
    if (_game_won_ > -1) {
      if (_game_won_ === 0) {
        restart(true);
        _game_won_ = -1;
      } else {
        _game_won_ = _game_won_ - 1;
      }
    }
    if (_game_won_ === -1 && isDotOutOfBounds(dot, world, two) === true) {
      return restart(false);
    }
  });

  world.on("beginContact", function(e) {
    if ((e.bodyB.ID === 'ENDDOT' || e.bodyB.ID === 'DOT') && (e.bodyA.ID === 'ENDDOT' || e.bodyA.ID === 'DOT')) {
      end_dot.two.fill = 'white';
      end_dot.two.stroke = 'white';
      return _game_won_ = 15;
    }
  });

  addDotByEvent = function(e) {
    var ref, ref1, ref2, ref3, x, y;
    e.preventDefault();
    e.stopPropagation();
    x = (ref = e != null ? e.pageX : void 0) != null ? ref : e != null ? (ref1 = e.touches[0]) != null ? ref1.pageX : void 0 : void 0;
    y = (ref2 = e != null ? e.pageY : void 0) != null ? ref2 : e != null ? (ref3 = e.touches[0]) != null ? ref3.pageY : void 0 : void 0;
    if ((x != null) && (y != null)) {
      user_dots.push(createFixedDot(world, two, dot, x, y, 30));
      return true;
    } else {
      return false;
    }
  };

  document.body.addEventListener('mousedown', function(e) {
    return addDotByEvent(e);
  });

  document.body.addEventListener('touchstart', function(e) {
    return addDotByEvent(e);
  });

  document.body.addEventListener('click', function(e) {
    return e.preventDefault();
  });


  /*
  createLine = (world, two, x = 120, y = 450, w = 700, h = 20, m = 0, a = 45) ->
    rect = two.makeRectangle(x, y, w, h);
    rect.fill = 'rgb(0, 200, 255)';
    rect.opacity = 0.75;
    rect.rotation = a
    rect.noStroke()
  
    boxShape = new p2.Box({ width: w, height: h, angle: a})
    boxBody = new (p2.Body)(
      mass: m
      position: [
        x
        y
      ]
      angle: 45
      angularVelocity: 0
    )
  
    boxShape.material = new p2.Material()
    boxBody.addShape(boxShape)
    world.addBody(boxBody)
  
    return {
      two: rect
      p2:
        shape: boxShape
        body: boxBody
    }
   */

}).call(this);
