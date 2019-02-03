Library "v30/bslDefender.brs"

function Main() as void

    '''''''''''''''''''''''''''''''''
    '''' GENERAL SETUP
    m.sWidth = 1280
    m.sHeight = 720

    '''''''''''''''''''''''''''''''''
    'Load up custom game paramters
    rg2dSetGameParameters()

    '''''''''''''''''''''''''''''''''
    ' Create Key Components

    ' Scoreboard, load saved scores if available
    m.scoreBoard = rg2dScoreBoard()
    m.scoreBoard.loadScoreBoard()

    m.port = CreateObject("roMessagePort")

    m.screen = CreateObject("roScreen", true, m.sWidth, m.sHeight)
    m.screen.SetAlphaEnable(true)
    m.screen.SetMessagePort(m.port)

    m.compositor = CreateObject("roCompositor")
    m.compositor.SetDrawTo(m.screen, &h000000FF)

    'PHysics model is passed as a global variable'
    m.pm = physModel(m.compositor)

    ' Settings
    m.settings = rg2dGameSettings()

    'm.settings.setControls("H") ' Change the controls to horizontal
    myCodes = m.settings.controlCodes

    ' Audio
    m.audioManager = audioManager()

    ' Load Sounds in to m.sounds array
    rg2dLoadSounds()

    ' Load images
    rg2dLoadSprites()

    ' Load fonts'
    rg2dLoadFonts()

    '''''''''''''''''''''''''''''''''
    '''' MAIN Menu
    rg2dSetupMainScreen()
    URLLibSetup()

    ' Get mouse messages'
    success = URLLibGetAsync("https://462fhdcle1.execute-api.us-east-1.amazonaws.com/default/MouseMessageMaker")

    ' Post user info'
    di = CreateObject("roDeviceInfo")

    myData = {}
    myData.msg_type = "open_channel"
    myData.channel_client_id  = di.GetChannelClientId()
    myData.user_country_code = di.GetUserCountryCode()
    myData.round_unlocked = m.localData.RoundUnlocked
    myData.medals_lightning = m.localData.medals.lightning
    myData.medals_sharpshooter = m.localData.medals.sharpshooter

    myDataString = FormatJSON(myData,0)

    ?"MyDataString"
    ?myDataString

    dbPostURL = "https://ohh7ckjw0g.execute-api.us-east-1.amazonaws.com/default/SnowBattleData_Test"

    rPost = URLLibPostStringAsync(dbPostURL, myDataString)

    ' Menu loop'
    while true
        event = m.port.GetMessage()

        if (type(event) = "roUniversalControlEvent") then
            id = event.GetInt()

            if (id = myCodes.MENU_UP_A) or (id = myCodes.MENU_UP_B) then

                rg2dPlaySound(m.sounds.navSingle)
                m.menuArray.moveSelectionUp()
                rg2dSetupMainScreen()

            else if(id = myCodes.MENU_DOWN_A) or (id = myCodes.MENU_DOWN_B)then

                rg2dPlaySound(m.sounds.navSingle)
                m.menuArray.moveSelectionDown()
                rg2dSetupMainScreen()

            else if(id = myCodes.SELECT1A_PRESSED) or (id = myCodes.SELECT1B_PRESSED) or (id = myCodes.SELECT2_PRESSED)

                rg2dMenuItemSelected()
                rg2dSetupMainScreen()

            else if(id = myCodes.BACK_PRESSED) then
                ' Exit Game
                return
            end if
        else if (type(event) = "roUrlEvent") then
          rcode = event.GetResponseCode()
          ?"Got URL EVENT ";rcode
          if(rcode = 201) then ' Successful Post'
            ?"Successful post"
            ?event.getstring()

          else if(rcode = 200) then ' Got data back'
            URLLibHandleUrlEvent(event)

            ?event.getstring()
            mouseMessageData = ParseJson(event.getstring())
            ?mouseMessageData
            if mouseMessageData <> invalid then
              setMouseMessageData(mouseMessageData)
            end if

          end if
        end if ' End roURLEvent'

    end while

end function

'' Main Menu helper function
function rg2dSetupMainScreen() as void

    g = GetGlobalAA()

    g.screen.clear(0)
    g.compositor.DrawAll()

    dfDrawImage(g.screen, "pkg:/images/snowbattle_bg_screenshot.jpg", 0, 0)

    numMenuOptions = g.menuArray.getCount()
    selectedMenuOption = g.menuArray.selectedIndex

    'font = g.font_registry.GetDefaultFont(56, True, false)
    titleFont = g.font_registry.GetFont("Almonte Snow", 96, false, false)
    font = g.font_registry.GetFont("FrozenRita", 48, false, false)

    regColor = &h96a3b7FF
    selColor = &h366cbcFF

    'TITLE'
    title = "Snow Battle"
    tWidth = titleFont.GetOneLineWidth(title, g.sWidth)
    tHeight = titleFont.GetOneLineHeight()
    tIndent = (g.sWidth - tWidth)/2
    tTopMargin = 70

    tPad = 20

    g.screen.DrawRect(tIndent-tPad, tTopMargin-tPad, tWidth + 2*tPad, tHeight + 2*tPad, &hFFFFFFEE)
    g.screen.DrawText(title, tIndent, tTopMargin, selColor,titleFont)


    topIndent = tTopMargin + tHeight + tPad + 50
    leftIndent = 400
    vertSpace = font.GetOneLineHeight() + 8
    g.screen.DrawRect(leftIndent-50, topIndent-30, 1280-2*(leftIndent-50), vertSpace*numMenuOptions + 50, &hFFFFFFDD)

    for t = 0 to (numMenuOptions -1)
        if(t = selectedMenuOption) then
            g.screen.DrawText(g.menuArray.getItemName(t),leftIndent + 20,topIndent + t*vertSpace,selColor,font)
        else
            g.screen.DrawText(g.menuArray.getItemName(t),leftIndent, topIndent + t*vertSpace,regColor,font)
        end if
    end for

    g.screen.swapBuffers()

    g.audioManager.playSong(g.songURLS.makeMyDay_local)


end function
