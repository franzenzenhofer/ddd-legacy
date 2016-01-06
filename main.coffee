_DEBUG_ = false
d = (m, debug = _DEBUG_ ) -> console.log(m) if _DEBUG_

randomInt = (min,max) ->
  min = Math.floor(min)
  max = Math.floor(max)
  return Math.floor(Math.random() * (max - min + 1)) + min

two = new Two(
  fullscreen: true
  ).appendTo(document.body)

gravity = Math.floor(two.height/10)

world = new p2.World(
  gravity:[0, gravity]
)

_game_won_ = -1

end_dot = {}
dot = {}
user_dots = []


setWorldColor = (color = Please.make_color()) ->
  window.document.body.style.background = color

createDot = (world, two, x = 70, y = 200, r = 10, m = 1)  ->
  x = Math.floor(x)
  y = Math.floor(y)
  r = Math.floor(r)
  circle = two.makeCircle(x, y, r)
  circle.fill = Please.make_color()
  circle.stroke = 'black'
  circle.linewidth = 2;

  circleShape = new p2.Circle({ radius: r })
  circleShape.material = new p2.Material()
  circleBody = new p2.Body(
    mass:m,
    position:[x,y]
    damping: 0
    angularDamping: 0
    )
  circleBody.ID=false

  circleBody.addShape(circleShape)
  world.addBody(circleBody)
  return {
    two: circle
    p2:
      shape: circleShape
      body: circleBody
  }

createFixedDot = (world, two, dot, w,h,r,m=0) ->
  new_dot = createDot(world, two, w,h,r,m)
  world.addContactMaterial(new p2.ContactMaterial(dot.p2.shape.material, new_dot.p2.shape.material, {
                restitution : 0.9,
                stiffness : Number.MAX_VALUE
            }))
  return new_dot

drawDot = (dot, world = world, two = two) ->
 dot.two.translation.set( Math.floor(dot.p2.body.position[0]),Math.floor(dot.p2.body.position[1]))
 return dot

createEndDot = (world = world, two = two, x = randomInt(0,two.width),y=randomInt(0,two.height),r=20,m=0) ->

  end_dot = createDot(world, two, x,y,r,m)
  end_dot.p2.shape.sensor = true
  end_dot.p2.body.damping = 0
  end_dot.p2.body.ID = "ENDDOT"
  end_dot.two.fill = 'black'

  return end_dot



do init = () ->
  setWorldColor()
  end_dot = createEndDot(world, two)
  dot = createDot(world, two, two.width/2,-30,10,1)
  if(two.height > gravity*10)
    dot.p2.body.velocity = [0,Math.floor(two.height/7)]
  else
    dot.p2.body.velocity = [0,Math.floor(two.height/9)]
  dot.p2.body.ID = "DOT"
  window.scrollTo(0, 1)
  two.play()

removeDot = (dot) ->
  #two.remove(dot.two)
  world.removeBody(dot.p2.body)



restart = (won = false) ->
  two.pause()
  two.clear()
  removeDot(end_dot)
  removeDot(dot)
  for doties in user_dots
    removeDot(doties)
  init()

isDotOutOfBounds = (dot, world = world, two = two) ->
  if dot.p2.body.position[1]>two.height+50 or dot.p2.body.position[0]<-50 or dot.p2.body.position[0]>two.width+50

    return true
  else
    return false



two.bind('update', (frameCount) ->
  drawDot(dot)

  world.step(1/60)
  if _game_won_ > -1
    if _game_won_ is 0
      restart(true)
      _game_won_ = -1
    else
      _game_won_ = _game_won_ - 1

  if _game_won_ is -1 and isDotOutOfBounds(dot, world, two) is true

    restart(false)

)

world.on("beginContact",(e) ->
  if (e.bodyB.ID is 'ENDDOT' or e.bodyB.ID is 'DOT' ) and (e.bodyA.ID is 'ENDDOT' or e.bodyA.ID is 'DOT' )
    end_dot.two.fill = 'white'
    end_dot.two.stroke = 'white'
    _game_won_ = 15
)


#tap stuff
mc = new Hammer.Manager(document.body)
Tap = new Hammer.Tap({interval:1})
mc.add(Tap)
mc.on('tap',(e)->

  user_dots.push(createFixedDot(world, two, dot, e.pointers[0].pageX,e.pointers[0].pageY,30))
  )

#drawLine = (line) ->
#  line.two.translation.set(line.p2.body.position[0],# line.p2.body.position[1])

###
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
###
#line = createLine(world, two)
##d(line)
