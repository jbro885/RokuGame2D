function createTank(playerNumber, isHumanPlayer, x, y, angle, faceRight, tank_type) as object

  g = GetGlobalAA()

  tank = collectiveRotationalPhysObj(x, y, 30, angle)

  tank.tank_type = tank_type


  spriteArray = g.iglooSprites.Lookup(tank.tank_type)

  if spriteArray = invalid then
    ?"Warning: Unhandled tank type requested ";tank.tank_type
  end if

  if faceRight then
    sTank = g.compositor.NewSprite(x, y, spriteArray[1], 2) ' Flip this one'
    tx = x - 15
    ty = y
  else
    sTank = g.compositor.NewSprite(x, y, spriteArray[0], 2)
    tx = x + 15
    ty = y
  end if


  sTurret1 = g.compositor.NewSprite(x, y, g.rCircleGrey8, 1)
  sTurret2 = g.compositor.NewSprite(x, y, g.rCircleGrey8, 1)
  sTurret3 = g.compositor.NewSprite(x, y, g.rCircleGrey8, 1)
  sTurret4 = g.compositor.NewSprite(x, y, g.rCircleGrey8, 1)
  sTurret5 = g.compositor.NewSprite(x, y, g.rCircleGrey8, 1)
  sTurret6 = g.compositor.NewSprite(x, y, g.rCircleGrey8, 1)

  ''
  tank.minX = 0.0
  tank.maxX = g.screen.GetWidth()
  tank.minY = 0.0
  tank.maxY = g.screen.GetHeight()
  tank.wallEnable = Invalid ' TODO Could maybe turn this off
  tank.size_x = 60
  tank.size_y = 60
  tank.vx = 0
  tank.vy = 0
  tank.maxvx = 10
  tank.maxvy = 10
  tank.turret = collectiveRotationalPhysObj(tx, ty, 0, pi()/6)
  tank.turret.createElement(sTurret1, 0, 21)
  tank.turret.createElement(sTurret2, 0, 24)
  tank.turret.createElement(sTurret3, 0, 27)
  tank.turret.createElement(sTurret4, 0, 30)
  tank.turret.createElement(sTurret5, 0, 33)
  tank.turret.createElement(sTurret6, 0, 36)
  tank.turret_spacing = 3
  tank.tank_turret_angle = pi()/6 ' angle up from front of tank
  tank.faceRight = faceRight
  tank.MIN_TURRET_ANGLE = 0
  tank.MAX_TURRET_ANGLE = pi()
  tank.MAX_TURRET_SPACING = 3
  tank.MIN_TURRET_SPACING = 0

  tank.activeProjectiles = []
  tank.shotsInTheHole = []
  tank.timeSinceFire = 0

  tank.health = 100
  tank.playerNumber = playerNumber
  tank.isHumanPlayer = isHumanPlayer

  tank.turret.updateDisplay()

  tank.state = "ALIVE"

  tank.createElement(sTank, 0.0, 0.0)

  ''''''''''''''''''''''''''''''''''''''''''''''''''''''
  ''''''''''''''''''''''''''''''''''''''''''''''''''''''
  '''''' Projectile Stuff
  ''''''''''''''''''''''''''''''''''''''''''''''''''''''
  tank.projectile_list = getProjectileList()
  tank.projectile_idx = 0

  'tank.projectile_selector = projectileSelector()
  'tank.projectile_selector.updateDisplay()
  'rProjectileSelector= CreateObject("roRegion", tank.projectile_selector.bm, 0, 0, tank.projectile_selector.width, tank.projectile_selector.height)
  'tank.sProjectileSelector = g.compositor.NewSprite(tank.x, tank.y, rProjectileSelector, 4)

  tank.shotTypeList = getShotTypeList()
  tank.shotTypeIdx = 0
  tank.shotSelector = shotSelector()
  tank.shotSelector.updateDisplay()
  rshotSelector= CreateObject("roRegion", tank.shotSelector.bm, 0, 0, tank.shotSelector.width, tank.shotSelector.height)
  tank.sShotSelector = g.compositor.NewSprite(tank.x, tank.y+30, rshotSelector, 4)

  '
  ' tank.select_projectile = function(idx)
  '   ?"Swapping projectile from ";m.projectile_list[m.projectile_idx]
  '   m.projectile_idx = idx mod m.projectile_list.Count()
  '   m.projectile_selector.setProjectileIdx(m.projectile_idx) ' Update selector'
  '   ?"-> To projectile ";m.projectile_list[m.projectile_idx]
  ' end function

  tank.selectShot = function(idx)
    ''?"Swapping Shot from ";m.shotTypeList[m.shotTypeIdx]
    m.shotTypeIdx = idx mod m.shotTypeList.Count()
    m.shotSelector.setShotTypeIdx(m.shotTypeIdx) ' Update selector'
    ''?"-> To projectile ";m.shotTypeList[m.shotTypeIdx]
  end function

  tank.fireProjectile = function(power as double) as object
    ?"Fire!!!! ";m.shotTypeList[m.shotTypeIdx]
    g = GetGlobalAA()

    shotArray = createShot(m, m.shotTypeList[m.shotTypeIdx], m.x, m.y, power, m.tank_turret_angle, m.faceRight)
    for each s in shotArray
      m.shotsInTheHole.push(s)
    end for

    shotArray = invalid

    m.timeSinceFire = 0.0

    return shotArray
  end function

  tank.hasActiveProjectiles = function() as boolean
    return m.activeProjectiles.count() > 0
  end function

  ' Implements << ProjectileOwner >> interface '
  tank.projectileNotification = function(proj, obj)
    ?"Tank got projectile notice. "
    if obj = invalid then ' Object timed out without hitting anything'
      ?"Got notice that projectile timed out"
      return invalid ' Return so that we don't try to access invalid object
    end if

    if obj.DoesExist("playerNumber") then
      n = obj.playerNumber
      ?"player ";m.playerNumber;" hit player ";n
    end if

    ' Remove projectile from active list'
    for i = 0 to m.activeProjectiles.count()
        'if(m.activeProjectiles[i] = proj) then
        if (m.activeProjectiles[i].x = proj.x) AND (m.activeProjectiles[i].y = proj.y)then
            m.activeProjectiles.Delete(i)
            exit for
        end if
    end for

  end function

  tank.runProjectileControl = function(dt)
    m.timeSinceFire += dt

    newState = "PROJECTILE_CONTROL"

    i = 0

    ' check for projectiles in the hole waiting to be shot.
    while i < m.shotsInTheHole.count()
      s = m.shotsInTheHole[i]
      if m.timeSinceFire > s.time then
        g = GetGlobalAA()
        g.pogProjs.addPhysObj(s.proj)
        g.wind.addObject(s.proj)
        m.activeProjectiles.push(s.proj)

        rg2dPlaySound(g.sounds.foomp12)

        m.shotsInTheHole.delete(i)
      else
        i += 1
      end if
    end while

    ' If they are all shot, then move on'
    if m.shotsInTheHole.count() = 0 then
       newState = "WAITING_IMPACT"
    end if

    return newState
  end function



'm.turret.angle'
'        ^
'       270
'        |
' <-180--+---360/0->
'        |
'        90
'        V
  tank.set_turret_angle = function(angle) as void
    p = pi()
    m.tank_turret_angle = minFloat(maxFloat( angle ,m.MIN_TURRET_ANGLE),m.MAX_TURRET_ANGLE)
    If m.faceRight then
      m.turret.angle = 2*p - m.tank_turret_angle
    else
      m.turret.angle = p + m.tank_turret_angle
    End If

  end function

  ' Override update display to also update the turret & flag display as well. '
  tank.updateDisplay = function() as void

    turret_shift = 10

    if(m.faceRight) then
      m.turret.x = m.x - turret_shift
    else
      m.turret.x = m.x + turret_shift
    end if

    m.turret.y = m.y

    for each e in m.turret.elementArray
        e.updatePosition(m.turret.x, m.turret.y, m.turret.angle)
    end for

    m.turret.updateDisplay()

    ' Updated each element's position
    for each e in m.elementArray
        e.updatePosition(m.x, m.y, m.angle)
    end for

    for each e in m.elementArray
        e.updateDisplay()
    end for

    'Flag Update
    desired_flag_position = (m.health/100.0)
    d = desired_flag_position - m.bmFlag.flagHeight
    ' ?"desired_flag_position";desired_flag_position
    ' ?"m.bmFlag.flagHeight";m.bmFlag.flagHeight
    ' ?"d";d

    flag_rate = 0.01 ' Percent per update cycle'
    if( d = 0.0) then
      'Nothing to do '
      ''?"Equal"
    else if (abs(d) < 2*flag_rate ) then
      m.setFlagPosition(desired_flag_position)
      ''?"Close enough"
    else ' slowly move toward desire position'
      new_pos = m.bmFlag.flagHeight + sgn(d)*flag_rate
      m.setFlagPosition(new_pos)
      m.bmFlag.updateDisplay()
      ''?"Moving"
    end if

  end function

  'Set Turret Spacing
  tank.set_turret_spacing = function(dist) as void
    m.turret_spacing = maxFloat(minFloat(dist, m.MAX_TURRET_SPACING), m.MIN_TURRET_SPACING)
    rad = 21
    for each e in m.turret.elementArray
      e.radius = rad
      rad += dist
    end for
  end function

  tank.set_turret_angle(tank.tank_turret_angle) ' Update display'

  'Flag
  if faceRight then
    bmFlag = flag(tank.x-100, tank.y-380, 100, 400, &hDD1111FF)
    bmFlag.flagRight = true
  else
    bmFlag = flag(tank.x, tank.y-380, 100, 400, &hDD1111FF)
    bmFlag.flagRight = false
  end if
  bmFlag.setFlagPosition(0.98)
  bmFlag.updateDisplay()
  rFlag = CreateObject("roRegion", bmFlag.bm, 0, 0, bmFlag.width, bmFlag.height)
  tank.sFlag = g.compositor.NewSprite(bmFlag.x, bmFlag.y, rFlag, 1)

  tank.bmFlag = bmFlag
  tank.setFlagPosition = function(value)
    m.bmFlag.setFlagPosition(value)
  end function

  tank.takeDamage = function(damage_points) as void
    m.health -= damage_points
    ''?"Taking damage ";damage_points
    ''?" Health = ";m.health
    ''?" Flag = ";m.bmFlag.flagHeight

  end function

  ' Power bar '
  bmPowerBar = uiExtender(30,100)
  bmPowerBar.updateDisplay()
  rPowerBar = CreateObject("roRegion", bmPowerBar.bm, 0, 0, bmPowerBar.width, bmPowerBar.height)
  tank.sPowerBar = g.compositor.NewSprite(tank.x, tank.y+30, rPowerBar, 3)

  tank.bmPowerBar = bmPowerBar
  tank.setPowerBar = function(value)
    m.bmPowerBar.setValue(value)
  end function
  tank.getPowerBarValue = function()
    return m.bmPowerBar.value
  end function

  tank.setPosition = function(x,y) as void
    m.x = x
    m.y = y

    if m.faceRight then
      m.sFlag.MoveTo(m.x-100,m.y-380)
    else
      m.sFlag.MoveTo(m.x,m.y-380)
    end if

    m.sPowerBar.MoveTo(m.x, m.y+30)
    'm.sProjectileSelector.MoveTo(m.x-32, m.y+30)
    m.sShotSelector.MoveTo(m.x-32, m.y+30)

  end function

  ''''''''''''''''''''''''''''''''''''''''''''''''''''''
  ' AI
  tank.calculateNextShot = function(target) as object 'argument target is a tank object'
    shot = {}
    shot.angle = 60 * (pi()/(180 + rnd(3)-2))
    shot.power = 450 + (rnd(100)-50)
    shot.powerBar = ((shot.power-300)/200)

    return shot
  end function

  ' Return our new tank!'
  return tank

end function ' End Tank Class'


'''''''' Create an AI tank that shoots randomly
function AITankRandy(playerNumber, x, y, angle, faceRight, tank_type)
  isHumanPlayer = false

  randy = createTank(playerNumber, isHumanPlayer, x, y, angle, faceRight, tank_type)

  randy.projectileNotification = function(proj, obj)
    ?" RANDY Got notice."
    if obj = invalid then ' Object timed out without hitting anything'
      return invalid
    end if
    if obj.DoesExist("playerNumber") then
      n = obj.playerNumber
      ?"Randy (";m.playerNumber;") hit player ";n
    end if

    ' Remove projectile from active list'
    for i = 0 to m.activeProjectiles.count()
        'if(m.activeProjectiles[i] = proj) then
        if (m.activeProjectiles[i].x = proj.x) AND (m.activeProjectiles[i].y = proj.y)then
            m.activeProjectiles.Delete(i)
            exit for
        end if
    end for

  end function

  randy.calculateNextShot = function() as object
    shot = {}
    shot.angle = 60 * (pi()/(180 + rnd(3)-2))
    shot.power = 450 + (rnd(100)-50)
    shot.powerBar = ((shot.power-300)/200)

    return shot
  end function

  return randy

end function


'''''''' Create an AI tank that shoots based on range to target
function AITankRanger(playerNumber, x, y, angle, faceRight, tank_type)
  isHumanPlayer = false

  ranger = createTank(playerNumber, isHumanPlayer, x, y, angle, faceRight, tank_type)

  'OVERRIDE notification with AI code'
  ranger.projectileNotification = function(proj, obj)
    ?"Ranger Got notice."
    if m.last_shot_target <> invalid then ' we can calulate miss distance'
      if(m.faceRight) then
        m.last_shot_miss_distance = proj.x - m.last_shot_target.x
      else
        m.last_shot_miss_distance = m.last_shot_target.x - proj.x
      end if
      ?"last_shot_miss_distance ";m.last_shot_miss_distance
    end if

    if obj = invalid then ' Object timed out without hitting anything'
      return invalid
    end if

    if obj.DoesExist("playerNumber") then
      n = obj.playerNumber
      ?"Randy (";m.playerNumber;") hit player ";n
      m.last_shot_hit = true
    else
      m.last_shot_hit = false
    end if

    ' Remove projectile from active list'
    for i = 0 to m.activeProjectiles.count()
        'if(m.activeProjectiles[i] = proj) then
        if (m.activeProjectiles[i].x = proj.x) AND (m.activeProjectiles[i].y = proj.y)then
            m.activeProjectiles.Delete(i)
            exit for
        end if
    end for

  end function

  ranger.badness = .5 ' TODO make this setable'

  ranger.last_shot = invalid
  ranger.last_shot_hit = false
  ranger.last_shot_miss_distance = invalid ' projectile_ground_range - target_ground_range'
  ranger.last_shot_target = invalid

  ranger.calculateNextShot = function(target) as object
    shot = {}

    m.last_shot_target = target

    if m.last_shot = invalid then
      shot.angle = 45 * (pi()/180)' Choose high loft to avoid terrain'

      R = abs(m.x - target.x) ' pixels'
      Gy = getProjectileGY() 'pixels /sec^2 ?????'
      D = sin(2 * shot.angle ) ''

      vel = sqr( (R * Gy)/D )

      ?"**** Aiming at something ";R;" pixels away. Power = ";vel

      shot.power = vel ' Yeah... bad variable naming, sorry physicists.'
      shot.powerBar = ((shot.power-300)/200)

    else
      shot = m.last_shot
      ?"**** Last Shot Power";shot.power
      if(m.last_shot_hit) then
        'Nothing to do here now '
      else
        if m.last_shot_miss_distance > 0 then ' Too far'
          shot.power -= 10
        else ' Not far enough'
          shot.power += 10
        end if
      end if
    end if
    ''Shake things up a bit
    shot.power += m.badness * (rnd(50)-25) ' Max +/- 25 vel error'
    shot.angle += m.badness * (5*rnd(0) - 2.5) * (pi()/180) ' Max +/- 5 deg angle error'

    ?"**** Shot Power";shot.power
    m.last_shot = shot

    return shot
  end function

  return ranger

end function
