' Set global game parameters here.
function rg2dSetGameParameters() as void

    g = GetGlobalAA()

    g.USING_LB_CODE = false
    g.DEBUG = True

    g.highScoreRegister = "GameHighScores"

    g.menuArray = rg2dMenuItemList()
    g.menuArray.addItem("New Game", "new_game")
    g.menuArray.addItem("Options", "options")
    g.menuArray.addItem("High Scores", "high_scores")
    g.menuArray.addItem("About", "about")

end function

'
' Load all Sprites Used in the game
'
function rg2dLoadSprites() as void
    g = GetGlobalAA()

    if(g.DEBUG) then
      ?"Loading Sprites..."
    end if

    bmScore = CreateObject("roBitmap", "pkg:/components/sprites/Numbers_Spritesheet_32.png")

    g.rScore = []
    g.rScore[0] = CreateObject("roRegion", bmScore, 0*32, 0, 32, 32)
    g.rScore[1] = CreateObject("roRegion", bmScore, 1*32, 0, 32, 32)
    g.rScore[2] = CreateObject("roRegion", bmScore, 2*32, 0, 32, 32)
    g.rScore[3] = CreateObject("roRegion", bmScore, 3*32, 0, 32, 32)
    g.rScore[4] = CreateObject("roRegion", bmScore, 4*32, 0, 32, 32)
    g.rScore[5] = CreateObject("roRegion", bmScore, 5*32, 0, 32, 32)
    g.rScore[6] = CreateObject("roRegion", bmScore, 6*32, 0, 32, 32)
    g.rScore[7] = CreateObject("roRegion", bmScore, 7*32, 0, 32, 32)
    g.rScore[8] = CreateObject("roRegion", bmScore, 8*32, 0, 32, 32)
    g.rScore[9] = CreateObject("roRegion", bmScore, 9*32, 0, 32, 32)


    bmPauseScreen = CreateObject("roBitmap", "pkg:/components/sprites/Pause_Menu_Screen.png")
    g.rPauseScreen = CreateObject("roRegion", bmPauseScreen, 0, 0, 640, 200)

    g.rTruck = rg2dLoadRegion("pkg:/components/sprites/firetruck_spritesheetII.png", 0, 0, 49, 36)
    g.rBricks = rg2dLoadRegion("pkg:/components/sprites/texture_brick01_60p.png", 0, 0, 60, 60)
    g.rCircleFire16 = rg2dLoadRegion("pkg:/components/sprites/circle_fire_16p.png", 0, 0, 16, 16)
    g.rCircleGrey8 = rg2dLoadRegion("pkg:/components/sprites/circle_grey_8p.png", 0, 0, 8, 8)

    ' Kenny's stuff
    bmSnowBallIcons = CreateObject("roBitmap", "pkg:/components/sprites/SnowballSelectIcons.png")
    g.SB = {}
    g.SB.standard_1  = CreateObject("roRegion", bmSnowBallIcons, 0, 0, 32, 32)
    g.SB.standard_3s = CreateObject("roRegion", bmSnowBallIcons, 32, 0, 32, 32)
    g.SB.standard_5s = CreateObject("roRegion", bmSnowBallIcons, 64, 0, 32, 32)
    g.SB.standard_3p = CreateObject("roRegion", bmSnowBallIcons, 96, 0, 32, 32)
    g.SB.standard_5p = CreateObject("roRegion", bmSnowBallIcons, 128, 0, 32, 32)
    g.SB.pellet_1  = CreateObject("roRegion", bmSnowBallIcons, 0, 32, 32, 32)
    g.SB.pellet_3s = CreateObject("roRegion", bmSnowBallIcons, 32, 32, 32, 32)
    g.SB.pellet_5s = CreateObject("roRegion", bmSnowBallIcons, 64, 32, 32, 32)
    g.SB.pellet_3p = CreateObject("roRegion", bmSnowBallIcons, 96, 32, 32, 32)
    g.SB.pellet_5p = CreateObject("roRegion", bmSnowBallIcons, 128, 32, 32, 32)
    g.SB.baked_alaska_1 = CreateObject("roRegion", bmSnowBallIcons, 0, 64, 32, 32)

    g.rSnowBall = rg2dLoadRegion("pkg:/components/sprites/snowball_p21.png", 0, 0, 21, 21)
    g.rSnowBallFire = rg2dLoadRegion("pkg:/components/sprites/snowball_fire_p21.png", 0, 0, 21, 21)
    g.rSnowBall11 = rg2dLoadRegion("pkg:/components/sprites/snowball_p11.png", 0, 0, 11, 11)
    g.rSnowBall5 = rg2dLoadRegion("pkg:/components/sprites/snowball_p5.png", 0, 0, 5, 5)
    'g.rTerrain_ice = rg2dLoadRegion("pkg:/components/sprites/terrain_ice_288_44.png", 0, 0, 288, 44)
    'g.rIgloo_right = rg2dLoadRegion("pkg:/components/sprites/igloo2_right_63_42.png", 0, 0, 63, 42)
    'g.rIgloo_left = rg2dLoadRegion("pkg:/components/sprites/igloo2_left_63_42.png", 0, 0, 63, 42)

    bmIgloos = CreateObject("roBitmap", "pkg:/components/sprites/igloos_II_128_294.png")

    g.iglooSprites = {}
    g.iglooSprites.igloo = []
    g.iglooSprites.igloo.push(CreateObject("roRegion", bmIgloos, 0, 0, 63, 42))' left'
    g.iglooSprites.igloo.push(CreateObject("roRegion", bmIgloos, 64, 0, 63, 42))' right'

    g.iglooSprites.igloo_blue = []
    g.iglooSprites.igloo_blue.push(CreateObject("roRegion", bmIgloos, 0, 42, 63, 42))' left'
    g.iglooSprites.igloo_blue.push(CreateObject("roRegion", bmIgloos, 64, 42, 63, 42))' right'

    g.iglooSprites.igloo_green = []
    g.iglooSprites.igloo_green.push(CreateObject("roRegion", bmIgloos, 0, 42*2, 63, 42))' left'
    g.iglooSprites.igloo_green.push(CreateObject("roRegion", bmIgloos, 64, 42*2, 63, 42))' right'

    g.iglooSprites.igloo_red = []
    g.iglooSprites.igloo_red.push(CreateObject("roRegion", bmIgloos, 0, 42*3, 63, 42))' left'
    g.iglooSprites.igloo_red.push(CreateObject("roRegion", bmIgloos, 64, 42*3, 63, 42))' right'

    g.iglooSprites.igloo_pink = []
    g.iglooSprites.igloo_pink.push(CreateObject("roRegion", bmIgloos, 0, 42*4, 63, 42))' left'
    g.iglooSprites.igloo_pink.push(CreateObject("roRegion", bmIgloos, 64, 42*4, 63, 42))' right'

    g.iglooSprites.igloo_grey = []
    g.iglooSprites.igloo_grey.push(CreateObject("roRegion", bmIgloos, 0, 42*5, 63, 42))' left'
    g.iglooSprites.igloo_grey.push(CreateObject("roRegion", bmIgloos, 64, 42*5, 63, 42))' right'

    g.iglooSprites.igloo_black = []
    g.iglooSprites.igloo_black.push(CreateObject("roRegion", bmIgloos, 0, 42*6, 63, 42))' left'
    g.iglooSprites.igloo_black.push(CreateObject("roRegion", bmIgloos, 64, 42*6, 63, 42))' right'


    '
    '
    ' g.rIgloo_left = CreateObject("roRegion", bmIgloos, 0, 0, 63, 42)
    ' g.rIgloo_right = CreateObject("roRegion", bmIgloos, 64, 0, 63, 42)
    ' g.rIgloo_blue_left = CreateObject("roRegion", bmIgloos, 0, 42, 63, 42)
    ' g.rIgloo_blue_right = CreateObject("roRegion", bmIgloos, 64, 42, 63, 42)

    g.rFlagRed = rg2dLoadRegion("pkg:/components/sprites/Flag_red_white.png", 0, 0, 40, 30)
    g.rFlagBlue = rg2dLoadRegion("pkg:/components/sprites/Flag_orange_blue.png", 0, 0, 40, 30)
    g.rMouseUp = rg2dLoadRegion("pkg:/components/sprites/MouseUp_32.png", 0, 0, 32, 32)

    bmChevrons = CreateObject("roBitmap", "pkg:/components/sprites/chevrons.png")
    g.rChevronGreenLeft = CreateObject("roRegion", bmChevrons, 0, 0, 30, 30)
    g.rChevronGreyLeft = CreateObject("roRegion", bmChevrons, 30, 0, 30, 30)
    g.rChevronGreyRight = CreateObject("roRegion", bmChevrons, 60, 0, 30, 30)
    g.rChevronGreenRight = CreateObject("roRegion", bmChevrons, 90, 0, 30, 30)
    g.rWindometerText = rg2dLoadRegion("pkg:/components/sprites/windometer_text.png", 0, 0, 124, 19)

    g.terrain_ice = createTerrain("pkg:/components/sprites/terrain_ice_288_44.png")

    bmFlakes = CreateObject("roBitmap", "pkg:/components/sprites/flakes_32p_8x.png")
    g.rFlakesArray = []
    For i=0 to 7 step 1
      g.rFlakesArray[i] = CreateObject("roRegion", bmFlakes, i*32, 0, 32, 32)
    End For

    if(g.USING_LB_CODE) then
        LBLoadSprites()
    end if

end function

'
' Load all sounds used in the game
'
function rg2dLoadSounds() as void
    g = GetGlobalAA()

    if(g.DEBUG) then
      ?"Loading Sounds..."
    end if

    g.sounds ={}
    'g.sounds.foomp = CreateObject("roAudioResource", "pkg:/components/audio/foomp.wav")
    'g.sounds.foompB = CreateObject("roAudioResource", "pkg:/components/audio/foompB.wav")
    g.sounds.foomp12 = CreateObject("roAudioResource", "pkg:/components/audio/foomp12.wav")
    g.sounds.ouch1 = CreateObject("roAudioResource", "pkg:/components/audio/ouch1.wav")
    g.sounds.poof1 = CreateObject("roAudioResource", "pkg:/components/audio/poof1.wav")
    g.sounds.navSingle = CreateObject("roAudioResource", "navsingle")

    '?"Max Streams ";g.sounds.astroid_blast.maxSimulStreams()
    g.audioStream = 1
    g.maxAudioStreams = 1 'g.sounds.astroid_blast.maxSimulStreams()

end function

'
' Use this to set custom actions when a menu item is selected
'
function rg2dMenuItemSelected() as void

    g = GetGlobalAA()

    if(g.DEBUG) then
      ?"Menu Item Selected ...";
    end if

    selectedMenuOption = g.menuArray.selectedIndex

    shortName = g.menuArray.getSelectedItemShortName()

    if(g.DEBUG) then
      ?"->";shortName
    end if

    if(shortName = "new_game") then ' New Game

        stat = rg2dPlayGame()

    else if(shortName = "options") then ' Settings
        '?"Going to settings screen"
        'rg2dPlaySound(m.sounds.warp_out)
        stat = rg2dOpenSettingsScreen(m.screen, m.port)
        'rg2dPlaySound(m.sounds.warp_in)

    else if(shortName = "high_scores") then

        'rg2dPlaySound(m.sounds.warp_out)
        stat = rg2dOpenHighScoresScreen(m.screen, m.port)
        'rg2dPlaySound(m.sounds.warp_in)

    else if(shortName = "about") then

        'rg2dPlaySound(m.sounds.warp_out)
        stat = rg2dOpenCreditScreen(m.screen, m.port)
        'rg2dPlaySound(m.sounds.warp_in)
    end if

end function


' Stuff that needs to be done at the start of each game goes here.
function rg2dGameInit() as void
    g = GetGlobalAA()

    g.bgColor = &h114488FF

end function


'''''''''' OUTER LOOP STUFF
' Stuff to be done at the start of each level goes here.
function rg2dLoadLevel(level as integer) as void
    g = GetGlobalAA()

    g.bgColor = &h114488FF

    '''''''''''''''''''''
    '''''' WIND '''''''''
    g.wind = windMaker()
    g.wind.setWindAcc(rnd(50)-25,0)

    g.windViewer = windicator(g.wind, 500, 100)
    g.windViewer.updateDisplay()

    '''''''''''''''''''''
    '''''' TANKS
    g.tank1 = createTank(1, true, 100, g.sHeight-200, 0, true, "igloo_pink")
    g.tank2 = AITankRanger(2, g.sWidth-100, g.sHeight-200,0, false, "igloo_green")

    g.tank2.badness = 0.0

    g.tank1.bmFlag.setFlagImage(g.rFlagRed)
    g.tank2.bmFlag.setFlagImage(g.rFlagBlue)

    g.pogTanks = g.pm.createPhysObjGroup()
    g.pogProjs = g.pm.createPhysObjGroup()
    g.pogTerr = g.pm.createPhysObjGroup()

    g.pogTanks.addPhysObj(g.tank1)
    g.pogTanks.addPhysObj(g.tank2)

    '''''''''''''''''''''
    '''''' Collisions
    cpTankProj = g.pm.createCollisionPair(g.pogTanks,g.pogProjs)

    cpTankProj.overlapCallback = function(t,p) as integer
      if(p.ttl > 14) then
        ?"Projectile must be firing still!";p.ttl
        return 1
      end if
      if p.state = "ALIVE" then
        g = GetGlobalAA()
        ?"Projectile Hit Tank!"
        t.takeDamage(p.damage_power)
        p.ttl = 0.0
        p.state = "DEAD"
        p.NotifyOwnerOfCollision(t)
        rg2dPlaySound(g.sounds.ouch1)
      end if
      return 1 ' Indicate not to perform normal collision
    end function

    if(g.DEBUG) then
      ?"rg2dLoadLevel()..."
    end if

    ''''''''''''''''''''''''''
    ''''' TERRAIN
    cpProjTerr = g.pm.createCollisionPair(g.pogProjs,g.pogTerr)
    cpProjTerr.overlapCallback = function(p,t) as integer
      ?"Projectile hitting ICE"
      if p.state = "ALIVE" then
        g = GetGlobalAA()
        p.ttl = 0.1
        p.state = "DEAD"
        p.NotifyOwnerOfCollision(t)
        rg2dPlaySound(g.sounds.poof1)
      end if
      return 1
    end function

    td = terrainDefinition()
    randomizeTerrainDefinition(td, 10)

    terrain = laydownTerrainInOneSprite(g.pm, g.compositor, g.terrain_ice, td)

    ''' mouse
    g.sMouse = g.compositor.NewSprite(600,g.sHeight-td.getHeightAtXPoint(600)-20,g.rMouseUp,1)

    g.tank1.setPosition(100, g.sHeight-td.getHeightAtXPoint(100) - 16)
    g.tank2.setPosition(g.sWidth-100, g.sHeight-td.getHeightAtXPoint(g.sWidth-100) - 16)
    g.tank1.updateDisplay()
    g.tank2.updateDisplay()


    ''''''''''''''''''''''''''
    ''''' Initialize State
    g.gameState = rg2dGameState("ENTER")
    g.player_turn = 1

    ' Make snow '
    g.snowMaker = snowMaker(g.wind, g.compositor)
    if(rnd(4) <> 1) ' 1 in 4 chance of snow'
      g.snowMaker.randomInit(20 + rnd(30), g.rFlakesArray) ' Randomize snow severity'
    end if


end function

function switchActivePlayer() as void
    g = GetGlobalAA()
    If g.player_turn = 1 then
      g.player_turn = 2
    else
      g.player_turn = 1
    End If
end function

' Stuff to be done at the start of each update loop goes here.
' TODO ?? dt is in seconds, but button_hold_time is in milliseconds'
function rg2dInnerGameLoopUpdate(dt as float, button, button_hold_time) as object
    g = GetGlobalAA()
    if(g.DEBUG and (dt > 0.040)) then
      ?"rg2dInnerGameLoopUpdate(";dt;")..."
    end if

    angle_inc = pi()/180

    If g.player_turn = 1 then
      active_player = g.tank1
      inactive_player = g.tank2
    else
      active_player = g.tank2
      inactive_player = g.tank1
    End If

    PBT = 2000 'Powerbar period in milliseconds '

    if active_player.isHumanPlayer then

      if(button.bUp) then
          active_player.set_turret_angle(active_player.tank_turret_angle + angle_inc)
          ?"Angle Up ";active_player.tank_turret_angle

      else if(button.bDown) then
          active_player.set_turret_angle(active_player.tank_turret_angle - angle_inc)
          ?"Angle Up ";active_player.tank_turret_angle

      else if(button.bRight) then
          ?"Trucking Left"
          'g.wind.offsetWind(10,0)
          'active_player.select_projectile(active_player.projectile_idx+1)
      else if(button.bLeft) then
          ?"Trucking Right"
          'g.wind.offsetWind(-10,0)

          'active_player.select_projectile(active_player.projectile_idx-1)

      end if

      ' Start of Turn state transitions'
      if g.gameState.state = "ENTER" then
        g.gameState.setState("RANDOMIZE_PROJECTILE")

      else if g.gameState.state = "RANDOMIZE_PROJECTILE" then
        if(g.gameState.framesInState > 50) then
          g.gameState.setState("IDLE")
        end if
        if(g.gameState.framesInState mod 5) = 0 then ' Shuffle projectile type again'
          active_player.selectShot(active_player.shotTypeIdx + rnd(3))
        end if
      end if

      ' SELECT BUTTON DOWN'
      if(button.bSelect1) then
        if g.gameState.state = "IDLE" then
          ?"Prepping to fire"
          'g.projectileInFlight = Invalid
          g.gameState.setState("POWER_SELECT")
          g.power_select = 0
        else if g.gameState.state = "POWER_SELECT" then
          p1 = (button_hold_time MOD (2*PBT)) ' Power as a sawtooth wave'
          p2 = (2*PBT) - p1 'Cross over sawtooth'
          pwr = minFloat(p1,p2)

          g.power_select =  (pwr/PBT)
          active_player.setPowerBar(g.power_select)
        end if
      else
        if g.gameState.state = "POWER_SELECT" then
          g.gameState.setState("FIRE")
        end if
      end if

      ' SELECT BUTTON RELEASED'
      if g.gameState.state = "FIRE" ' Player just let go of fire button'
        g.gameState.setState("PROJECTILE_CONTROL")
        newProj = active_player.fireProjectile(350 + g.power_select * 200)

      else if g.gameState.state = "PROJECTILE_CONTROL"
        newState = active_player.runProjectileControl(dt)
        g.gameState.setState(newState) ' Let the projectile control determine when to transition

      else if g.gameState.state = "WAITING_IMPACT"
        if active_player.hasActiveProjectiles() = False
          g.gameState.setState("IMPACTED")
          g.wind.clearDead()
        end if

      else if g.gameState.state = "IMPACTED"
        switchActivePlayer()
        g.gameState.setState("ENTER")
      end if

    else ''''''''''''''''   AI Player''''''''''''''''''''''''''''''''

      if g.gameState.state = "ENTER" then
        g.gameState.setState("RANDOMIZE_PROJECTILE")
      else if g.gameState.state = "RANDOMIZE_PROJECTILE" then

        if(g.gameState.framesInState > 50) then
          g.gameState.setState("IDLE")
        end if

        if(g.gameState.framesInState mod 5) = 0 then
          active_player.selectShot(active_player.shotTypeIdx + rnd(3))
        end if

      else if g.gameState.state = "IDLE" then
        ?"IDLE"
        g.gameState.setState("CALCULATING")
      else if g.gameState.state = "CALCULATING"
        ?" - CALCULATING"
        active_player.shot = active_player.calculateNextShot(inactive_player)
        g.gameState.setState("AIMING")
      else if g.gameState.state = "AIMING" 'Animate turret aiming
        ?" - AIMING from ";active_player.tank_turret_angle;" to ";active_player.shot.angle
        da = active_player.shot.angle - active_player.tank_turret_angle
        if abs(da) <= angle_inc then
          active_player.set_turret_angle(active_player.shot.angle)
          g.gameState.setState("POWER_SELECT")
        else
          active_player.set_turret_angle(active_player.tank_turret_angle + sgn(da)*angle_inc)
        end if

      else if g.gameState.state = "POWER_SELECT" ' Animate power select bar'
        ?" - POWER_SELECT"

        desired_val = minFloat(maxFloat(active_player.shot.powerBar, 0.1), 0.9)
        dp =  desired_val - active_player.getPowerBarValue()

        pwr_inc = (1.0/PBT)*(dt*1000)

        if (abs(dp) <= pwr_inc) then
          active_player.setPowerBar(active_player.shot.powerBar)
          g.gameState.setState("FIRE")
        else
          active_player.setPowerBar(active_player.getPowerBarValue() + sgn(dp)*pwr_inc)
        end if

      else if g.gameState.state = "FIRE"
        ?" - POWER_SELECT"
        newProj = active_player.fireProjectile(active_player.shot.power)
        g.gameState.setState("PROJECTILE_CONTROL")

      else if g.gameState.state = "PROJECTILE_CONTROL"
        newState = active_player.runProjectileControl(dt)
        g.gameState.setState(newState) ' Let the projectile control determine when to transition

      else if g.gameState.state = "WAITING_IMPACT"
        ''?" - WAITING_IMPACT"
        if active_player.hasActiveProjectiles() = False
          g.gameState.setState("IMPACTED")
          g.wind.clearDead()
        end if
      else if g.gameState.state = "IMPACTED"
        switchActivePlayer()
        g.gameState.setState("ENTER")
      end if

    end if

    'Progress Game State'
    g.gameState.tick(dt) ' Calling this to update state counters

    'Update wind'
    g.windViewer.updateDisplay() ' Update to current wind conditions'

    ' Update snow
    g.snowMaker.run(dt)

    ' TODO create level status object'
    stat = {}
    stat.level_complete = false
    stat.game_complete = false

    if (g.tank1.health <= 0) OR (g.tank2.health <= 0) then
      stat.level_complete = true
    end if

    return stat

end function
