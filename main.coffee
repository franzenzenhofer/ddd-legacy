_DEBUG_ = false
d = (m, debug = _DEBUG_ ) -> console.log(m) if _DEBUG_

randomInt = (min,max) ->
  min = Math.floor(min)
  max = Math.floor(max)
  return Math.floor(Math.random() * (max - min + 1)) + min

two = new Two(
  fullscreen: true
  ).appendTo(document.body)

#d(two)
#console.log(two.height/17)
gravity = Math.floor(two.height/10)
d("gravity:"+gravity)
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
  d("x:"+x)
  d("y"+y)
  d("r"+r)
  circle = two.makeCircle(x, y, r)
  circle.fill = Please.make_color()
  circle.stroke = 'black'#Please.make_color()
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
 dot.two.translation.set(dot.p2.body.position[0],dot.p2.body.position[1])
 return dot

createEndDot = (world = world, two = two, x,y,r=20,m=0) ->

  randomX = (x) ->
    #alert(w)
    if x > two.width/2-40 and x < two.width+(40*2)
      randomX(randomInt(0,two.width))
      #debugger;
    else
      return x

  if not (x and y)
    y = randomInt(0,two.height)
    x = randomInt(0,two.width)#x = randomX(randomInt(0,two.width))

  #console.log(x)
  #console.log(two.width)
  #console.log(two.width/2-50)
  #console.log(two.width-(two.width/2-50))
  #console.log('----')
  end_dot = createDot(world, two, x,y,r,m)
  end_dot.p2.shape.sensor = true
  end_dot.p2.body.damping = 0
  end_dot.p2.body.ID = "ENDDOT"
  end_dot.two.fill = 'black'
  #drawDot(end_dot, world, two)
  return end_dot



do init = () ->
  setWorldColor()
  end_dot = createEndDot(world, two)
  dot = createDot(world, two, two.width/2,-30,10,1)
  dot.p2.body.velocity = [0,gravity]
  dot.p2.body.ID = "DOT"
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
  #console.log('restart')
  init()

isDotOutOfBounds = (dot, world = world, two = two) ->
  d(two.height+50)
  if dot.p2.body.position[1]>two.height+50 or dot.p2.body.position[0]<-50 or dot.p2.body.position[0]>two.width+50
    d('outbounds')
    #debugger;
    return true
  else
    d('inbounds')
    return false



two.bind('update', (frameCount) ->
  drawDot(dot)
  #drawLine(line)
  world.step(1/60)
  if _game_won_ > -1
    if _game_won_ is 0
      restart(true)
      _game_won_ = -1
    else
      _game_won_ = _game_won_ - 1

  if _game_won_ is -1 and isDotOutOfBounds(dot, world, two) is true
    #debugger
    restart(false)

)

world.on("beginContact",(e) ->
  d(e)
  if (e.bodyB.ID is 'ENDDOT' or e.bodyB.ID is 'DOT' ) and (e.bodyA.ID is 'ENDDOT' or e.bodyA.ID is 'DOT' )
    d(end_dot)
    end_dot.two.fill = 'white'
    end_dot.two.stroke = 'white'
    _game_won_ = 10
)


#tap stuff
mc = new Hammer.Manager(document.body)
Tap = new Hammer.Tap({interval:0})
mc.add(Tap)
mc.on('tap',(e)->
  #alert(1)
  #console.log(e)
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
