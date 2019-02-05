' Set global game parameters here.
function rg2dSetGameParameters() as void

    g = GetGlobalAA()

    g.USING_LB_CODE = false
    g.DEBUG = True

    g.highScoreRegister = "GameHighScores"

    g.menuArray = rg2dMenuItemList()
    g.menuArray.addItem("Play", "play")
    g.menuArray.addItem("Two Player Match", "two_player")
    g.menuArray.addItem("Just Here to Watch", "ai_v_ai")
    'g.menuArray.addItem("Options", "options")
    g.menuArray.addItem("Screen Saver", "screen_saver")
    g.menuArray.addItem("About", "about")

    g.layers = {}
    ' Front' 100
    g.layers.pauseScreen = 70
    g.layers.FastSnow = 60
    g.layers.playerControl = 50
    g.layers.Trees = 45
    g.layers.Flags = 43
    g.layers.snowsplosion = 42
    g.layers.Igloos = 41
    g.layers.Turret = 40
    g.layers.Projectiles = 30
    g.layers.MousePlane = 25
    g.layers.Windometer = 20
    g.layers.Terrain = 10
    g.layers.SlowSnow = 9
    'Back' 1

    'rg2dDeleteRegistry("mouse_msg")
    loadMouseMessages()

    ''''''''''''''''''''''''''''''''''
    ' Local Data'
    'rg2dDeleteRegistry("local_data")

    g.localDataKey = "local_data"
    localDataString = rg2dGetRegistryString(g.localDataKey)
    ?"Loaded local data -> ";localDataString
    if(localDataString <> "") then '' If it is not empty then parse to associative array
      g.localData = ParseJSON(localDataString) ' Pull everything from the registry'
    else ' if empty then create a new empty associative array
      g.localData = {}
    end if


    di = CreateObject("roDeviceInfo")

    ''Default localData"
    defaultLocalData = {}
    defaultLocalData.round_unlocked = 0
    defaultLocalData.num_opens = 0
    defaultLocalData.medals = {}
    defaultLocalData.medals.lightning = []
    defaultLocalData.medals.sharpshooter = []
    defaultLocalData.tournament_matches_played = []
    defaultLocalData.tournament_matches_won = []
    For i=0 to 5 step 1
      defaultLocalData.medals.lightning.push(false)
      defaultLocalData.medals.sharpshooter.push(false)
      defaultLocalData.tournament_matches_played.push(0)
      defaultLocalData.tournament_matches_won.push(0)
    End For
    defaultLocalData.two_player_matches = 0
    defaultLocalData.just_watching_matches = 0
    defaultLocalData.screen_saver_plays = 0
    defaultLocalData.channel_client_id  = di.GetChannelClientId()
    defaultLocalData.user_country_code = di.GetUserCountryCode()

    ' Apply defaults to any missing data fields'
    defaultKeys = defaultLocalData.keys()
    For each k in defaultKeys
      if not g.localData.DoesExist(k) then
      ?" Adding default value for field not in registry data ";k
        g.localData.AddReplace(k, defaultLocalData.lookup(k))
      end if
    End For

    g.localData.num_opens += 1

    ' Write back to registry, in case something changed'
    rg2dSaveRegistryData(g.localDataKey, g.localData)

    ' Constants'
    g.QUICK_GAME_TIME = 140 ' Seconds'
    g.MAX_WIND = 40

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


    g.regions = {}

    bmPauseScreen = CreateObject("roBitmap", "pkg:/components/sprites/Pause_Menu_Screen.png")
    g.rPauseScreen = CreateObject("roRegion", bmPauseScreen, 0, 0, 640, 200)

    g.rTruck = rg2dLoadRegion("pkg:/components/sprites/firetruck_spritesheetII.png", 0, 0, 49, 36)
    g.rBricks = rg2dLoadRegion("pkg:/components/sprites/texture_brick01_60p.png", 0, 0, 60, 60)
    g.rCircleFire16 = rg2dLoadRegion("pkg:/components/sprites/circle_fire_16p.png", 0, 0, 16, 16)
    g.rCircleGrey8 = rg2dLoadRegion("pkg:/components/sprites/circle_grey_8p.png", 0, 0, 8, 8)


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
    'g.SB.ice_see_you_A1 = CreateObject("roRegion", bmSnowBallIcons, 0, 96, 32, 32)
    'g.SB.ice_see_you_A2 = CreateObject("roRegion", bmSnowBallIcons, 32, 96, 32, 32)
    g.SB.ice_see_you_A1 = CreateObject("roRegion", bmSnowBallIcons, 64, 96, 32, 32)
    g.SB.ice_see_you_A2 = CreateObject("roRegion", bmSnowBallIcons, 96, 96, 32, 32)
    g.SB.digger_1 = CreateObject("roRegion", bmSnowBallIcons, 0, 128, 32, 32)
    g.SB.digger_shadow = CreateObject("roRegion", bmSnowBallIcons, 32, 128, 32, 32)

    bmMedals = CreateObject("roBitmap", "pkg:/components/sprites/Medals_300_50.png")
    g.medalSprites = {}
    g.medalSprites.quick_vic = CreateObject("roRegion", bmMedals, 0, 0, 50, 50)
    g.medalSprites.sharpshooter = CreateObject("roRegion", bmMedals, 50, 0, 50, 50)
    g.medalSprites.quick_vic_empty = CreateObject("roRegion", bmMedals, 100, 0, 50, 50)
    g.medalSprites.sharpshooter_empty = CreateObject("roRegion", bmMedals, 150, 0, 50, 50)


    bmSnowsplosion = CreateObject("roBitmap", "pkg:/components/sprites/snowsplosion_300_50.png")
    g.rSnowsplosion = []
    for i = 0 to 5 step 1
      g.rSnowsplosion[i] = CreateObject("roRegion", bmSnowsplosion, i*50, 0, 50, 50)
    end For

    bmTrees = CreateObject("roBitmap", "pkg:/components/sprites/tree_56_90.png")
    g.regions.tree_1_A = CreateObject("roRegion", bmTrees, 0, 0, 56, 90)

    bmIgloos = CreateObject("roBitmap", "pkg:/components/sprites/igloos_III_128_294.png")

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

    g.rIglooLock = rg2dLoadRegion("pkg:/components/sprites/igloo_lock_64_49.png", 0, 0, 64, 49)

    g.rFlagRed = rg2dLoadRegion("pkg:/components/sprites/Flag_red_white.png", 0, 0, 40, 30)
    g.rFlagBlue = rg2dLoadRegion("pkg:/components/sprites/Flag_orange_blue.png", 0, 0, 40, 30)
    g.rMouseUp = rg2dLoadRegion("pkg:/components/sprites/MouseUp_32.png", 0, 0, 32, 32)
    g.rMousePlaneStrings = rg2dLoadRegion("pkg:/components/sprites/MousePlaneWithLines_148_86.png", 0, 0, 148, 86)

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
    g.sounds.ouch2 = CreateObject("roAudioResource", "pkg:/components/audio/ouch2.wav")
    g.sounds.poof1 = CreateObject("roAudioResource", "pkg:/components/audio/poof1.wav")
    g.sounds.poof2 = CreateObject("roAudioResource", "pkg:/components/audio/poof2.wav")
    g.sounds.poof3 = CreateObject("roAudioResource", "pkg:/components/audio/poof3.wav")
    g.sounds.phaser1 = CreateObject("roAudioResource", "pkg:/components/audio/phaser1.wav")
    g.sounds.navSingle = CreateObject("roAudioResource", "navsingle")
    g.sounds.matchVictory = CreateObject("roAudioResource", "pkg:/components/audio/SnowBattleVictory.wav")
    g.sounds.metalAward = CreateObject("roAudioResource", "pkg:/components/audio/SnowBattleMedalAward.wav")
    g.sounds.randomizer = CreateObject("roAudioResource", "pkg:/components/audio/SnowBattle_Randomizer.wav")

    '?"Max Streams ";g.sounds.astroid_blast.maxSimulStreams()
    g.audioStream = 1
    g.maxAudioStreams = 1 'g.sounds.astroid_blast.maxSimulStreams()

    g.songURLS = {}
    g.songURLS.makeMyDay_local = "pkg:/components/audio/MakeMyDay.mp3"
    g.songURLS.sliding_local = "pkg:/components/audio/Sliding.mp3"
    g.songURLS.slowWalk_local = "pkg:/components/audio/SlowWalkShort.mp3"
    'g.songURLS.slowWalk = "https://s3.amazonaws.com/goodthinggames/snowballfight/SlowWalkShort.mp3"
    'g.songURLS.cosmic = "https://s3.amazonaws.com/goodthinggames/snowballfight/CosmicShort.mp3"
    g.songURLS.cosmic_local = "pkg:/components/audio/CosmicShort.mp3"
    g.songURLS.goingDown_local = "pkg:/components/audio/GoingDown.mp3"
    'g.songURLS.snowCannon2 = "https://s3.amazonaws.com/goodthinggames/snowballfight/SnowCannon2.mp3"
    'g.songURLS.snowCannon3 = "https://s3.amazonaws.com/goodthinggames/snowballfight/SnowCannon3.mp3"
    'g.songURLS.stuff = "https://s3.amazonaws.com/goodthinggames/snowballfight/Stuff.mp3"
    g.songURLS.stuff_local = "pkg:/components/audio/StuffShort.mp3"

    'g.songURLS.still = "http://cf-media.sndcdn.com/YOpYBdeBhkEr?Policy=eyJTdGF0ZW1lbnQiOlt7IlJlc291cmNlIjoiKjovL2NmLW1lZGlhLnNuZGNkbi5jb20vWU9wWUJkZUJoa0VyIiwiQ29uZGl0aW9uIjp7IkRhdGVMZXNzVGhhbiI6eyJBV1M6RXBvY2hUaW1lIjoxNTQ4Mjk2NDQxfX19XX0_&Signature=tH8BOlp8SxkoE9~0cOcoBPl2iUgKdwkkU2o9P9UEUYxTVGagFCDlUzQd1BP6JzoBfo~5G1bqE9LZBGhBDlOvEQEEzyrfVdMW0Ixa6jlfFSCoOG~dSNE4QFPsrpMuCz6RDRoWB1r9jBIX~mKVEReCt5Pu5Pq-2d1Be3A0sBf4tsYGNSpZ8xfqWCyj-1Ej4IHx~3BGgilGwdKqoWKgvqyrJcC1ckELk5AxwcChS8iQpjmW9Y89g~c9ufwNSaXJwdvc~85MQusgQCpUiSNo9ULzkr-tGboAkYdUJ35OXcM2sbzyufN1Vz-KQBMD262ldKGbKmSsnuqHj7FPSqw-KFmYuQ__&Key-Pair-Id=APKAJAGZ7VMH2PFPW6UQ"
    'g.songURLS.awesome = "http://cf-media.sndcdn.com/7sr6k4zORCj9?Policy=eyJTdGF0ZW1lbnQiOlt7IlJlc291cmNlIjoiKjovL2NmLW1lZGlhLnNuZGNkbi5jb20vN3NyNms0ek9SQ2o5IiwiQ29uZGl0aW9uIjp7IkRhdGVMZXNzVGhhbiI6eyJBV1M6RXBvY2hUaW1lIjoxNTQ4Mjk5NTM0fX19XX0_&Signature=X04MR0lY-vFezXWOq7lkRqNIQIb9h1S0fqseR9gFEl-9iNbpG81kExfxgnT-4GvYhVECxBnWnyIBavLtOg4ihXPuVuue-SdWfY1gQyuaRO2WPfj1GC~GbyULn3QkHtA1ktU9cALYEXHSpBgyCatgBMRR4MizYHoMztM9ndjoZe3bu7iDTR3hOazNDJgOXGZE1WzXmjKGarJwAOdhC6E5IxWwRssKGNoZjNCWn9F70~OmQ8DBTbQn8bpcK6WT~soGlkeYu12k1WSViEHitTf1LI6lgK9SCpnJYghVzumXMLsNey8Te7XrS7on4i9CeDV~Gifdg3GpAFsC2xk9oY0G5g__&Key-Pair-Id=APKAJAGZ7VMH2PFPW6UQ"

    g.audioManager.defaultBackupURL = g.songURLS.sliding_local

end function

function rg2dLoadFonts() as void
  g = GetGlobalAA()
  g.font_registry = CreateObject("roFontRegistry")

  g.font_registry.Register("pkg:/components/fonts/AlmonteSnow.ttf")
  g.font_registry.Register("pkg:/components/fonts/HannaHandwriting.ttf")
  g.font_registry.Register("pkg:/components/fonts/FrozenRita.ttf")
  g.font_registry.Register("pkg:/components/fonts/minya_nouvelle_rg.ttf")

end function

' Wrapper definition with function for generating a player
function playerDef(playerNumber, isHumanPlayer, tankType, name)
  pdef =  {playerNumber : playerNumber,
          isHumanPlayer : isHumanPlayer,
          tankType : tankType,
          name : name}

  '''' Generate player function
  pdef.generate = function() as object

    faceRight = true
    if(m.playerNumber = 2) then
      faceRight = False
    end if

    if(m.isHumanPlayer) then
            'createTank(playerNumber, isHumanPlayer, x, y, angle, faceRight, tank_type)'
      tank = createTank(m.playerNumber, true, 100, 200, 0, faceRight, m.tankType)
    else
      'AITankRanger(playerNumber, x, y, angle, faceRight, tank_type)'
      tank = AITankRandy(m.playerNumber, 100, 100,0, faceRight, m.tankType)
    end if

    tank.name = m.name

    return tank
  end function


  return pdef

end function

' Wrapper definition with function for generating an AIRanger player'
'' Must be called in level setup so that compisitor for level has been set
function AIRangerPlayerDef(playerNumber, tankType, badness, name)
  pdef = playerDef(playerNumber, false, tankType, name)
  pdef.badness = badness

  pdef.generate = function() as object

    faceRight = true
    if(m.playerNumber = 2) then
      faceRight = False
    end if

    tank = AITankRanger(m.playerNumber, 100, 100,0, faceRight, m.tankType)
    tank.badness = m.badness
    tank.name = m.name

    return tank
  end function

  return pdef

end function

' Defines how a game will be played'
' tank1 & tank2 are player defninition objects with a generate() function'
function gameDefinition(rounds as integer, tank1, tank2, windspeed, levelPlayers, songURL) as object

  GDef = {rounds : rounds,
          tank1 : tank1,
          tank2 : tank2 }

  GDef.windspeed = windspeed ' INvalid selects random wind speed'
  GDef.levelPlayers = levelPlayers
  GDef.songURL = songURL

  return GDef

end function

function getAIPlayerDefForLevel(playerNumber, level as integer) as object

      pdef = invalid

      if level = 1 then
        pdef = PlayerDef(playerNumber, false, "igloo_blue", "Iceman")
      else if level = 2 then
        pdef = AIRangerPlayerDef(playerNumber, "igloo_green", 1.5, "Green Giant")
      else if level = 3 then
        pdef = AIRangerPlayerDef(playerNumber, "igloo_red", 1.0, "Rudolph")
      else if level = 4 then
        pdef = AIRangerPlayerDef(playerNumber, "igloo_pink", 0.5, "Popper")
      else if level = 5 then
        pdef = AIRangerPlayerDef(playerNumber, "igloo_grey", 0.3, "Ghost")
      else if level = 6 then
        pdef = AIRangerPlayerDef(playerNumber, "igloo_black", 0.1, "Jet")
      else
        ?"Warning got unhandled level ";level
      end if

      return pdef

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

    if(shortName = "play") then ' New Game
      yourName = "Player 1"

      gameDefs = []
      gameDefs.push( gameDefinition(1, playerDef(1, true, "igloo", yourName), getAIPlayerDefForLevel(2, 1), 0, false, g.songURLS.cosmic_local) )
      gameDefs.push( gameDefinition(1, playerDef(1, true, "igloo", yourName), getAIPlayerDefForLevel(2, 2), invalid, false, g.songURLS.makeMyDay_local ) )
      gameDefs.push( gameDefinition(1, playerDef(1, true, "igloo", yourName), getAIPlayerDefForLevel(2, 3), invalid, false, g.songURLS.stuff_local) )
      gameDefs.push( gameDefinition(1, playerDef(1, true, "igloo", yourName), getAIPlayerDefForLevel(2, 4), invalid, false, g.songURLS.stuff_local) )
      gameDefs.push( gameDefinition(1, playerDef(1, true, "igloo", yourName), getAIPlayerDefForLevel(2, 5), invalid,  true, g.songURLS.slowWalk_local) )
      gameDefs.push( gameDefinition(1, playerDef(1, true, "igloo", yourName), getAIPlayerDefForLevel(2, 6),       0,  true, g.songURLS.slowWalk_local) )

      stillAlive = True

      msg = invalid
      'msg = "You earned a Sharp Shooter Medal for your flawless match!"

      while stillAlive

        select = tournamentSelectScreen(gameDefs, g.localData.round_unlocked, msg)

        msg = invalid

        if select.idx = invalid then
          return
        end if

        stat = rg2dPlayGame(gameDefs[select.idx])
        g.localData.tournament_matches_played[select.idx] += 1

        ?"Game stats"
        ?stat

        if stat.winningPlayer = 1 then
          g.localData.tournament_matches_won[select.idx] += 1
          g.localData.round_unlocked = minFloat(maxFloat(g.localData.round_unlocked, select.idx+1),5)

          if (stat.game_time < g.QUICK_GAME_TIME) and (g.localData.medals.lightning[select.idx] = false)then
            g.localData.medals.lightning[select.idx] = true
            rg2dPlaySound(g.sounds.metalAward)
            msg = "You earned a Lighting Medal for a quick victory!"
          end if

          if (stat.tank1misscount = 0) and (g.localData.medals.sharpshooter[select.idx] = false) then
            g.localData.medals.sharpshooter[select.idx] = true
            rg2dPlaySound(g.sounds.metalAward)
            msg = "You earned a Sharp Shooter Medal for a flawless match!"
          end if

        end if

        ' Save the fact that we have progressed'
        rg2dSaveRegistryData(g.localDataKey, g.localData)
        sendLocaldata()

        if select.idx = gameDefs.count() then
          ?"YOU WINN!!!!"
          exit while
        end if

      end while


    else if(shortName = "two_player") then ' New Game
      iglooTypes = twoPlayerSelectScreen()

      if iglooTypes = invalid then
        return
      end if

      gdef = gameDefinition(1, playerDef(1, true, iglooTypes[0], "Player 1"), playerDef(2, true, iglooTypes[1], "Player 2"), invalid, false,  g.songURLS.sliding_local)
      stat = rg2dPlayGame(gdef)

      g.localData.two_player_matches += 1
      rg2dSaveRegistryData(g.localDataKey, g.localData)
      sendLocaldata()

    else if(shortName = "ai_v_ai") then ' New Game

      gdef = gameDefinition(1, getAIPlayerDefForLevel(1, rnd(6)), getAIPlayerDefForLevel(2, rnd(6)), invalid, false,  g.songURLS.slowWalk)
      stat = rg2dPlayGame(gdef)


      g.localData.just_watching_matches += 1
      rg2dSaveRegistryData(g.localDataKey, g.localData)
      sendLocaldata()

    else if(shortName = "options") then ' Settings
        '?"Going to settings screen"
        'rg2dPlaySound(m.sounds.warp_out)
        stat = rg2dOpenSettingsScreen(m.screen, m.port)
        'rg2dPlaySound(m.sounds.warp_in)

    else if(shortName = "screen_saver") then

        'rg2dPlaySound(m.sounds.warp_out)
        gdef = gameDefinition(1, getAIPlayerDefForLevel(1, rnd(6)), getAIPlayerDefForLevel(2, rnd(6)), invalid, false,  g.songURLS.sliding_local)
        stat = playScreenSaver(gdef)
        'rg2dPlaySound(m.sounds.warp_in)

        g.localData.screen_saver_plays += 1
        rg2dSaveRegistryData(g.localDataKey, g.localData)
        sendLocaldata()

    else if(shortName = "about") then

        'rg2dPlaySound(m.sounds.warp_out)
        stat = rg2dOpenCreditScreen()
        'rg2dPlaySound(m.sounds.warp_in)
    end if

end function

function twoPlayerSelectScreen() as object ' returns 2 element array of igloo types'
  g = GetGlobalAA()
  myCodes = g.settings.controlCodes

  playerSelect = 1
  idx1 = 0
  idx2 = 0

  idx = 0
  titleString = "Select Player 1 Igloo"

  iglooTypes = g.iglooSprites.keys()
  ''?"IGLOO TYPES ";iglooTypes

  drawTwoPlayerSelectScreen(titleString, idx1, idx2, playerSelect)

  while true
      event = m.port.GetMessage()

      if (type(event) = "roUniversalControlEvent") then
          id = event.GetInt()

          if (id = myCodes.MENU_UP_A) or (id = myCodes.MENU_UP_B) then
              rg2dPlaySound(m.sounds.navSingle)

              idx = (idx-1)
              if( idx < 0) then
                idx = iglooTypes.count()-1
              else if (idx > iglooTypes.count()-1) then
                idx = 0
              end if

              if playerSelect = 1 then
                idx1 = idx
              else
                idx2 = idx
              end if

              ''?titleString;" ";iglooTypes[idx]

              drawTwoPlayerSelectScreen(titleString, idx1, idx2, playerSelect)

          else if(id = myCodes.MENU_DOWN_A) or (id = myCodes.MENU_DOWN_B)then

              idx = (idx+1)
              if( idx < 0) then
                idx = iglooTypes.count()-1
              else if (idx > iglooTypes.count()-1) then
                idx = 0
              end if
              if playerSelect = 1 then
                idx1 = idx
              else
                idx2 = idx
              end if
              ''?titleString;" ";iglooTypes[idx]

              drawTwoPlayerSelectScreen(titleString, idx1, idx2, playerSelect)

          else if(id = myCodes.SELECT1A_PRESSED) or (id = myCodes.SELECT1B_PRESSED) or (id = myCodes.SELECT2_PRESSED)
              rg2dPlaySound(m.sounds.foomp12)

              if playerSelect = 1 then ' go on to player 2'
                sleep(500)
                titleString = "Select Player 2 Igloo"
                playerSelect = 2
                idx1 = idx
                idx = 0
                drawTwoPlayerSelectScreen(titleString, idx1, idx2, playerSelect)
              else

                playerSelect = 3
                drawTwoPlayerSelectScreen(titleString, idx1, idx2, playerSelect)
                sleep(700)
                returnTypes = []
                returnTypes.push(iglooTypes[idx1])' push player 1'
                returnTypes.push(iglooTypes[idx]) ' push player 2'

                ' TODO play "Let's go!" Sound'

                return returnTypes
              end if

          else if(id = myCodes.BACK_PRESSED) then
              ' Exit Game
              return invalid
          end if

      end if

  end while

end function

'' Draw
function drawTwoPlayerSelectScreen(titleString, idx1, idx2, playerSelect) as void
  g = GetGlobalAA()
  myCodes = g.settings.controlCodes

  bgColor = &hf2f7ffFF
  maskColor = &hf2f7ffAA ' Same as bg Color but with alpha'
  fontColor = &h3764adFF
  g.screen.clear(bgColor)

  fontTitle = g.font_registry.GetFont("Almonte Snow", 72, true, false)
  fontHeader = g.font_registry.GetFont("Almonte Snow", 48, true, false)
  'fontTitle = g.font_registry.GetDefaultFont(56, True, false)
  'fontHeader = g.font_registry.GetDefaultFont(30, True, false)

  tWidth = fontTitle.GetOneLineWidth(titleString, 1280)
  indent = (1280-tWidth)/2
  g.screen.DrawText(titleString,indent,100,fontColor,fontTitle)

  iglooSpriteTypes = g.iglooSprites.keys()

  x1 = 400
  x2 = 800
  y_ = 260

  g.screen.DrawText("Player 1",x1-50,200,fontColor,fontHeader)
  g.screen.DrawText("Player 2",x2-50,200,fontColor,fontHeader)
  g.screen.DrawText("Vs.",(x1+x2)/2,300,fontColor,fontHeader)

  For i=0 to iglooSpriteTypes.count()-1 step 1

    if playerSelect = 1 or (i = idx1) then '' Only draw player 1 igloos on player 1 selection, except for selected igloo
      g.screen.DrawObject(x1, y_, g.iglooSprites.lookup(iglooSpriteTypes[i])[0])
      if (i <> idx1) then
        g.screen.DrawRect(x1, y_, 64, 49, maskColor)
      end if
    end if

    if playerSelect < 3 or (i = idx2) then '' Only draw player 2 igloos on player 1 or 2 selection, except for selected igloo
      g.screen.DrawObject(x2, y_, g.iglooSprites.lookup(iglooSpriteTypes[i])[0])
      if (i <> idx2) then
        g.screen.DrawRect(x2, y_, 64, 49, maskColor)
      end if
    end if

    y_ += 60
  End For

  if playerSelect = 1 then ' Grey out player 2 selection'
    g.screen.DrawRect(x2, 260, 64, 49*iglooSpriteTypes.count(), maskColor)
  end if


  g.screen.swapBuffers()
end function


''
function tournamentSelectScreen(gameDefs, numUnlocked, msg) as object

  g = GetGlobalAA()
  myCodes = g.settings.controlCodes

  idx = numUnlocked

  iglooTypes = g.iglooSprites.keys()
  ''?"IGLOO TYPES ";iglooTypes

  drawTournamentSelectScreen(gameDefs, idx, numUnlocked, msg)

  select = {}
  select.idx = idx

  while true
      event = m.port.GetMessage()

      if (type(event) = "roUniversalControlEvent") then
          id = event.GetInt()

          if (id = myCodes.MENU_LEFT_A) or (id = myCodes.MENU_LEFT_B) then
              rg2dPlaySound(m.sounds.navSingle)

              if( idx > 0) then
                idx = (idx-1)
              else
                rg2dPlaySound(m.sounds.navSingle)
              end if

              drawTournamentSelectScreen(gameDefs, idx, numUnlocked, msg)

          else if(id = myCodes.MENU_RIGHT_A) or (id = myCodes.MENU_RIGHT_B)then

              if (idx < numUnlocked) and (idx < 5) then
                idx = (idx+1)
              else
                rg2dPlaySound(m.sounds.navSingle)
              end if

              drawTournamentSelectScreen(gameDefs, idx, numUnlocked, msg)

          else if(id = myCodes.SELECT1A_PRESSED) or (id = myCodes.SELECT1B_PRESSED) or (id = myCodes.SELECT2_PRESSED)
              rg2dPlaySound(m.sounds.foomp12)

              select.idx = idx

              return select

          else if(id = myCodes.BACK_PRESSED) then
              ' Exit Game
              select.idx = invalid
              return select
          end if

      end if

  end while

end function

''
function drawTournamentSelectScreen(gameDefs, idxSelected, numUnlocked, msg) as void
  g = GetGlobalAA()
  myCodes = g.settings.controlCodes

  bgColor = &hf2f7ffFF
  maskColor = &hf2f7ffAA ' Same as bg Color but with alpha'
  fontColor = &h3764adFF
  g.screen.clear(bgColor)
  dfDrawImage(g.screen, "pkg:/images/snowbattle_bg_screenshot2.jpg", 0, 0)

  titleFont = g.font_registry.GetFont("Almonte Snow", 96, false, false)
  fontNames = g.font_registry.GetFont("Minya Nouvelle", 24, false, false)
  fontMsg = g.font_registry.GetFont("Minya Nouvelle", 32, false, false)

  regColor = &h96a3b7FF
  selColor = &h366cbcFF
  selBorderColor = &hAA5511FF

  'TITLE'
  title = "Tournament Mode"
  tWidth = titleFont.GetOneLineWidth(title, g.sWidth)
  tHeight = titleFont.GetOneLineHeight()
  tIndent = (g.sWidth - tWidth)/2
  tTopMargin = 70

  tPad = 20

  g.screen.DrawRect(tIndent-tPad, tTopMargin-tPad, tWidth + 2*tPad, tHeight + 2*tPad, &hFFFFFFEE)
  g.screen.DrawText(title, tIndent, tTopMargin, selColor,titleFont)

  ' msg'
  if msg <> invalid then
    mPad = 20

    mWidth = fontMsg.GetOneLineWidth(msg, g.sWidth)
    mHeight = fontMsg.GetOneLineHeight()
    mIndent = (g.sWidth - mWidth)/2
    mTopMargin = tTopMargin + tHeight + tPad + 2*mPad
    msgColor = &h996c6cFF


    g.screen.DrawRect(mIndent-mPad, mTopMargin-mPad, mWidth + 2*mPad, mHeight + 2*mPad, &hFFFFFFEE)
    g.screen.DrawText(msg, mIndent, mTopMargin, msgColor, fontMsg)
  end if


  iglooSpriteTypes = g.iglooSprites.keys()

  dx = 190
  x_ = (g.sWidth - 6*dx)/2 + 50
  y = 400


  g.screen.DrawRect(x_-60, y-20 - 60, 6*dx + 20, 220, &hFFFFFFEE)

  For i=0 to gameDefs.count()-1 step 1

      if (i = idxSelected) then
        g.screen.DrawRect(x_-5, y-5, 74, 59, selBorderColor)
        g.screen.DrawRect(x_, y, 64, 49, selColor)
      end if

      g.screen.DrawObject(x_, y, g.iglooSprites.lookup(gameDefs[i].tank2.tanktype)[0])
      'if (i <> idxSelected) then
      ''  g.screen.DrawRect(x_, y, 64, 49, maskColor)
      'end if

      '' Draw medals
      if(g.localData.medals.lightning[i]) then
        g.screen.DrawObject(x_-15, y-60, g.medalSprites.quick_vic)
      else
        g.screen.DrawObject(x_-15, y-60, g.medalSprites.quick_vic_empty)
      end if

      if(g.localData.medals.sharpshooter[i]) then
        g.screen.DrawObject(x_+35, y-60, g.medalSprites.sharpshooter)
      else
        g.screen.DrawObject(x_+35, y-60, g.medalSprites.sharpshooter_empty)
      end if

      if (i > numUnlocked) then
        g.screen.DrawObject(x_, y, g.rIglooLock)
        g.screen.DrawText("?", x_+15, y+64,regColor,fontNames)
      else
        name_width = fontNames.GetOneLineWidth(gameDefs[i].tank2.name, 300)
        dx_font = (name_width - 64)/2
        g.screen.DrawText(gameDefs[i].tank2.name, x_-dx_font, y+64,regColor,fontNames)
      end if

      x_ += dx
  End For

  g.screen.swapBuffers()

end function


' Stuff that needs to be done at the start of each game goes here.
function rg2dGameInit(gdef) as void
    g = GetGlobalAA()

    g.bgColor = &h114488FF

    g.gameTimer = CreateObject("roTimespan")

end function

' Just load terrain, nothing else'
function loadScreenSaver() as void
  g = GetGlobalAA()


  g.pogTerr = g.pm.createPhysObjGroup()

  '''''''''''''''''''''
  '''''' WIND '''''''''
  g.wind = windMaker()
  g.wind.setWindAcc(rnd(50)-25,0)

  'g.windViewer = windicator(g.wind, 500, 100)
  'g.windViewer.updateDisplay()

  '' Terrain
  NUM_TERRAIN_SECTIONS = 10

  td = terrainDefinition()
  randomizeTerrainDefinition(td, NUM_TERRAIN_SECTIONS)

  g.terrain = laydownTerrainInOneSprite(g.pm, g.compositor, g.terrain_ice, td)

  '' Snow
  ' Make snow '
  g.snowMaker = snowMaker(g.wind, g.compositor)
  g.snowMaker.randomInit(20 + rnd(30), g.rFlakesArray) ' Randomize snow severity'

end function


'''''''''' OUTER LOOP STUFF
' Stuff to be done at the start of each level goes here.
function rg2dLoadLevel(gdef, level as integer) as void
    g = GetGlobalAA()

    '''''''''''''''''''''
    '''''' WIND '''''''''
    g.wind = windMaker()
    if gdef.windspeed = invalid then
      g.wind.setWindAcc(rnd(g.MAX_WIND*2)-g.MAX_WIND,0)
    else
      g.wind.setWindAcc(gdef.windspeed,0)
    end if
    ?"Wind speed is ";g.wind.ax

    g.windViewer = windicator(g.wind, 500, 100)
    g.windViewer.updateDisplay()

    '''''''''''''''''''''
    '''''' TANKS
    g.tank1 = gdef.tank1.generate()
    g.tank2 = gdef.tank2.generate()

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
        ''?"Projectile must be firing still!";p.ttl
        return 1
      end if
      if p.state = "ALIVE" then
        g = GetGlobalAA()
        ?"Projectile Hit Tank!"
        t.takeDamage(p.damage_power)
        p.ttl = 0.0
        p.state = "DEAD"
        p.NotifyOwnerOfCollision(t)
        rg2dPlaySound(g.sounds.poof2)
        g.explosionGroup.addPhysObj(createExplosion(p.x, p.y))

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
      ''?"Projectile hitting ICE"
      if p.state = "ALIVE" then

        g = GetGlobalAA()
        if p.isDigger then
          ''?"We have a digger here"
          ''?"p: (";p.x;" ";p.y;")"

          if p.x_atTargetY = invalid and p.target <> invalid then ' check to see if we passed targets Y'
            if p.y > p.target.y then
              p.x_atTargetY = p.x
            end if
          end if

          ' If it is off screen -> ttl = 0.1'
          if (p.x < 0) or (p.x > g.sWidth) or (p.y < 0) or (p.y > g.sHeight) then
            ?"Offscreen, kill it!"
            p.ttl = 0.1
            p.state = "DEAD"
            p.NotifyOwnerOfCollision(t)
            rg2dPlaySound(g.sounds.poof3)
            g.explosionGroup.addPhysObj(createExplosion(p.x, p.y))
          ' else -> put mark on the terrain'
          else
            if (g.terrain.td.getheightatxpoint(p.x) - (g.sHeight - p.y)) > 5 then ' Make sure it's fully under the ground
              g.terrain.bm.DrawObject(p.x-16, p.y-16, g.SB.digger_shadow)
              g.terrain.bm.DrawObject(p.x + (p.vx*0.01)-16, p.y + (p.vy*0.01) - 16, g.SB.digger_shadow)
              g.terrain.bm.DrawObject(p.x - (p.vx*0.01)-16, p.y - (p.vy*0.01) - 16, g.SB.digger_shadow)
            end if
          end if
        else ' Normal collision'
          p.ttl = 0.1
          p.state = "DEAD"
          p.NotifyOwnerOfCollision(t)
          rg2dPlaySound(g.sounds.poof3)
          g.explosionGroup.addPhysObj(createExplosion(p.x, p.y))
        end if
      end if

      return 1
    end function


    NUM_TERRAIN_SECTIONS = 10

    td = terrainDefinition()
    randomizeTerrainDefinition(td, NUM_TERRAIN_SECTIONS)

    if gdef.levelPlayers then ' Make the first & last sections the same height'
      h = minFloat(td.sectionList[0].height, td.sectionList[NUM_TERRAIN_SECTIONS-1].height)
      td.setSectionHeight(0, h)
      td.setSectionHeight(NUM_TERRAIN_SECTIONS-1, h)
      ' Make sure neither are up against s steep cliff'
      td.setSectionHeight(1, minFloat(td.sectionList[1].height, h + 20))
      td.setSectionHeight(NUM_TERRAIN_SECTIONS-2, minFloat(td.sectionList[NUM_TERRAIN_SECTIONS-2].height, h + 20))

    end if

    g.terrain = laydownTerrainInOneSprite(g.pm, g.compositor, g.terrain_ice, td)

    ''' mouse
    g.mouseController = mouseController()
    msg = g.tank1.name + " vs "  + g.tank2.name + "! " + g.mouseController.getRandomMessage("match_start")
    g.mouseController.startPlaneBanner(msg)

    'g.sMouse = g.compositor.NewSprite(600,g.sHeight-td.getHeightAtXPoint(600)-20,g.rMouseUp,1)

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

    'splosion'
    g.explosionGroup = g.pm.createPhysObjGroup()

    g.gameTimer.mark() ' Start Game timer'


end function '  Load level '

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

    ' TODO create level status object'
    stat = {}
    stat.level_complete = false
    stat.game_complete = false
    stat.game_ending  = false
    stat.game_time = invalid

    angle_inc = pi()/180

    If g.player_turn = 1 then
      active_player = g.tank1
      inactive_player = g.tank2
    else
      active_player = g.tank2
      inactive_player = g.tank1
    End If

    PBT = 2000 'Powerbar period in milliseconds '
    SHOT_RANDOMIZATION_TIME = 0.8

    if g.gameState.state = "EXITING"

      if g.gameState.subState = "ENTRY" then
        g.audioManager.stop()
        msg = ""

        if (g.tank1.health <= 0) then
          msg = g.tank2.name + " Wins! "
        else if (g.tank2.health <= 0) then
          msg = g.tank1.name + " Wins! "
        end if

        msg += g.mouseController.getRandomMessage("match_over")

        g.mouseController.startPlaneBanner(msg)
        g.gameState.setSubState("PAUSE")

      else if g.gameState.subState = "PAUSE" then

      if g.gameState.timeInSubState > 0.5 then
        rg2dPlaySound(g.sounds.matchVictory)
        g.gameState.setSubState("FLYING")
      end if

      else if g.gameState.subState = "FLYING" then
        ' TODO Upate mouse controller
        if g.gameState.timeInSubState > 5.0 then
          g.gameState.setSubState("DONE")
        end if

     ''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
      else if g.gameState.subState = "DONE" '''''''''''''''''''''''''''''''''''' Exit this match
        stat.level_complete = true
        stat.game_complete = true ' Always returning control to menu'

        if (g.tank1.health <= 0) then
          stat.winningPlayer = 2
        else if (g.tank2.health <= 0) then
          stat.winningPlayer = 1
        end if

      end if

    else ' Handle player input' TODO Move this to separate function

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
            inactive_player.takeDamage(10)
        else if(button.bLeft) then
            ?"Trucking Right"
            'g.wind.offsetWind(-10,0)

            'active_player.select_projectile(active_player.projectile_idx-1)
            g.mouseController.startPlaneBanner("TESTING TESTING 1,2,3...")
        end if

        ' Start of Turn state transitions'
        if g.gameState.state = "ENTER" then
          if(g.gameState.timeInState > 0.2) then
            g.gameState.setState("TURN_BUFFER")
          end if

        else if g.gameState.state = "TURN_BUFFER" then
          g.gameState.setState("RANDOMIZE_PROJECTILE")
          rg2dPlaySound(g.sounds.randomizer)

        else if g.gameState.state = "RANDOMIZE_PROJECTILE" then
          if(g.gameState.timeInState > SHOT_RANDOMIZATION_TIME) then
            g.gameState.setState("IDLE")
          end if
          if(g.gameState.framesInState mod 5) = 0 then ' Shuffle projectile type again'
            active_player.selectShot(active_player.shotTypeIdx + 3 + rnd(3))
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
          if active_player.hasActiveProjectiles() then
            active_player.updateProjectilesInFlight(dt)
          else
            g.gameState.setState("IMPACTED")
            g.wind.clearDead()
          end if

        else if g.gameState.state = "IMPACTED"
          switchActivePlayer()
          g.gameState.setState("ENTER")
        end if

      else ''''''''''''''''   AI Player''''''''''''''''''''''''''''''''

        if g.gameState.state = "ENTER" then
          if(g.gameState.timeInState > 0.2) then
            g.gameState.setState("TURN_BUFFER")
          end if

        else if g.gameState.state = "TURN_BUFFER" then
          g.gameState.setState("RANDOMIZE_PROJECTILE")
          rg2dPlaySound(g.sounds.randomizer)

        else if g.gameState.state = "RANDOMIZE_PROJECTILE" then

          if(g.gameState.timeInState > SHOT_RANDOMIZATION_TIME) then
            g.gameState.setState("IDLE")
          end if

          if(g.gameState.framesInState mod 5) = 0 then
            active_player.selectShot(active_player.shotTypeIdx +  3 + rnd(3))
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
          ''?" - POWER_SELECT"

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
          ''?" - POWER_SELECT"
          newProj = active_player.fireProjectile(active_player.shot.power)
          g.gameState.setState("PROJECTILE_CONTROL")

        else if g.gameState.state = "PROJECTILE_CONTROL"
          newState = active_player.runProjectileControl(dt)
          g.gameState.setState(newState) ' Let the projectile control determine when to transition

        else if g.gameState.state = "WAITING_IMPACT"
          ''?" - WAITING_IMPACT"
          if active_player.hasActiveProjectiles() then
            active_player.updateProjectilesInFlight(dt)
          else
            g.gameState.setState("IMPACTED")
            g.wind.clearDead()
          end if
        else if g.gameState.state = "IMPACTED"
          switchActivePlayer()
          g.gameState.setState("ENTER")
        end if

      end if  ' End of player handling'

    end if ' end of if EXIT'

    'Handle tank blinking'
    if g.tank1.blinkTime > 0.0 then
      ''?" Tank 1 blinking ";g.tank1.blinkTime
      g.tank1.blinkTime -= dt
      if g.tank1.blinkTime <= 0.0 then ' Time to stop blinking'
        g.tank1.setVisibilily(true)
        g.tank1.blinkTime = 0.0
      else ' blink on'
        g.tank1.setVisibilily(NOT g.tank1.isVisible)
      end if
    end if

    if g.tank2.blinkTime > 0.0 then
      ''?" Tank 2 blinking ";g.tank2.blinkTime
      g.tank2.blinkTime -= dt
      if g.tank2.blinkTime <= 0.0 then ' Time to stop blinking'
        g.tank2.setVisibilily(true)
        g.tank2.blinkTime = 0.0
      else ' blink on'
        g.tank2.setVisibilily(NOT g.tank2.isVisible)
      end if
    end if

    'Handle explosions'
    for each e in g.explosionGroup.physObjList
        e.updateState(dt)
    end for

    'Progress Game State'
    g.gameState.tick(dt) ' Calling this to update state counters

    'Update wind'
    g.windViewer.updateDisplay() ' Update to current wind conditions'

    ' Update snow
    g.snowMaker.run(dt)

    'Update Mouse'
    g.mouseController.update(dt)

    ' If one player is dead, then begin exiting the level'
    if (g.tank1.health <= 0) OR (g.tank2.health <= 0) then
      stat.game_time = g.gameTimer.TotalSeconds()
      stat.game_ending = true
      g.gameState.setState("EXITING")
    end if

    return stat

end function
