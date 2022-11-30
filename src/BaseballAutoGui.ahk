#include %A_ScriptDir%\src\gui\MC_GuiObject.ahk
#include %A_ScriptDir%\src\player\BaseballAutoPlayer.ahk

Class BaseballAutoGui{
    width:=330
    maxGroupWidth := this.width-20
    CONST_SIZE_LOG_HEIGHT:=170
    CONST_SIZE_CONFIG_HEIGHT:=160
    __NEW( title ){
        this.guiMain := new MC_GuiObj(title)
        this.mainHeight:=this.init()
        ; this.guiMain.Show()
        this.guiMain.OnEvent("Close", "this.guiClosed")
        ; myGui.OnEvent("Close", "myGui_Close")
        ; myGui_Close(thisGui) {  ; Declaring this parameter is optional.
        ; if MsgBox("Are you sure you want to close the GUI?",, "y/n") = "No"
        ; return true  ; true = 1
    }

    show( posX, posY){
        this.guiMain.Show( "x" posX . "y" . posY . "w" this.width . " h" . this.mainHeight )
    }
    changeContents( onlyMain ){
        if( onlyMain ){
            this.guiMain.Show( "w" . this.width . " h" . this.mainHeight )
        }else{
            this.guiMain.Show( "w" . this.width . " h" . this.totalHeight )
        }

    }
    getTitle(){
        return this.guiMain.getTitle()
    }
    getName(){
        return this.guiMain.getName()
    }

    init(){
        mainHeight:=5
        mainHeight+=this.initConfigButton(mainHeight)
        mainHeight+=this.initPlayerWindow(mainHeight)
        mainHeight+=this.initOptionWindow(mainHeight)
        mainHeight+=this.initButtonWindow(mainHeight)
        mainHeight+=this.initWindowStatistic(mainHeight)
        mainHeight+=this.initLogWindow(mainHeight)
        ; mainHeight+=this.initConfigWindow(mainHeight)+5
        this.totalHeight:=mainHeight+this.initConfigWindow(mainHeight)+5
        return mainHeight
    }

    initConfigButton( _height ){
        currentWindowHeight:=15
        this.guiMain.Add("Button", "Clear", "x" this.maxGroupWidth -90 " y0 w50", "StatClearButton",0)
        this.guiMain.Add("Button", "Save", "x" this.maxGroupWidth -40 " y0 w50", "SavePlayerButton",0)

        this.guiMain.Controls["SavePlayerButton"].BindMethod(this.savePlayerByGui.Bind(this))
        this.guiMain.Controls["StatClearButton"].BindMethod(this.clearStatsByGui.Bind(this))
        return currentWindowHeight
    }
    initPlayerWindow( _height ){
        global baseballAutoConfig

        playerCount:=baseballAutoConfig.players.Length()
        currentWindowHeight:=playerCount*20 +30

        this.guiMain.addGroupBox("Players", 10, _height , this.maxGroupWidth, currentWindowHeight , , true )

        for index, player in baseballAutoConfig.players
        {
            guiLable:=player.getKeyEnable()
            if ( index = 1 ){
                option:=% "xs+5 ys+20 disabled"
            }else{
                option:="xp y+10"
            }
            if ( player.getEnabled() ){
                option:= % option " checked"
            }
            this.guiMain.Add("CheckBox", index " :", option, guiLable,0)
        }
        for index, player in baseballAutoConfig.players
        {
            guiLable:=player.getKeyAppTitle()
            if ( index = 1 ){
                option:="xs+45 ys+15 w60 r1"
            }else{
                option:="xp y+2 wp r1"
            }
            this.guiMain.Add("Edit", player.getAppTitle(), option, guiLable,0)
        }

        targetTitle:=""
        for index, singleText in BaseballAutoPlayer.AVAILABLE_ROLES
        {
            targetTitle:=targetTitle singleText "|"
        }
        for index, player in baseballAutoConfig.players
        {
            guiType:="ComboBox"
            guiTitle:=targetTitle
            guiLable:=player.getKeyRole()
            if ( index = 1 )
                option:="xs+110 ys+15 +Center w50"
            else
                option:="xp y+2 wp"

            this.guiMain.Add(guiType, guiTitle, option, guiLable,0)
            this.guiMain.Controls[guiLable].select(player.getRole())
        }

        targetTitle:=""
        for index, singleText in BaseballAutoPlayer.AVAILABLE_PLAY_TYPE
        {
            targetTitle:=targetTitle singleText "|"
        }

        for index, player in baseballAutoConfig.players
        {
            guiType:="ComboBox"
            guiTitle:=targetTitle
            guiLable:=player.getKeyBattleType()
            option:="xp y+2 wp"
            if ( index = 1 ){
                option:="xs+165 ys+15 +Center w50 h100"
            }
            this.guiMain.Add(guiType, guiTitle, option, guiLable,0)
            this.guiMain.Controls[guiLable].select(player.getBattleType())
        }

        for index, player in baseballAutoConfig.players
        {
            guiType:="Text"
            guiTitle:=player.getResult()
            guiLable:=player.getKeyResult()
            option:="xp y+10 wp hp Right"
            if( index = 1 ){
                option:="xs+220 ys+20 w20 Right"
            }
            this.guiMain.Add(guiType, guiTitle, option, guiLable,0)
        }

        for index, player in baseballAutoConfig.players
        {
            guiType:="Text"
            guiTitle:=player.getStatus()
            guiLable:=player.getKeyStatus()
            option:="xp y+10 wp hp +Center"
            if( index = 1 ){
                option:="xs+245 ys+20 w60 +Center"
            }
            this.guiMain.Add(guiType, guiTitle, option, guiLable,0)
        }

        return currentWindowHeight
    }
    applyPlayerDescripter(){
        global baseballAutoConfig

        PLAYER_KEY:="PLAYERS_CONFIG"

        for index, element in baseballAutoConfig.players
        {
            ; if( index =2 )
            ; break
            keyForPlayer:=% "player" index
            ; ToolTip, % keyForPlayer "Enabled key and value =" isObject(element) "   " element["ENABLE"]

            this.guiMain.Controls[ keyForPlayer "Enabled" ].Set(element["ENABLE"])
            this.guiMain.Controls[ keyForPlayer "Id" ].setText(element["TITLE"])
            this.guiMain.Controls[ keyForPlayer "Role" ].select(element["ROLE"])
        }
    }

    initButtonWindow(_height){
        currentWindowHeight=50
        this.guiMain.addGroupBox("Buttons", 10, _height , this.maxGroupWidth, currentWindowHeight , , true )

        this.guiMain.Add("Button", "시작[F9]", "w90 h30 xs+10 ys+15 section", "GuiStartButton", 0)
        this.guiMain.Controls["GuiStartButton"].BindMethod(this.startByGui.Bind(this))

        this.guiMain.Add("Button", "종료[F10]", "w90 h30 xs ys +Hidden", "GuiStopButton", 0)
        this.guiMain.Controls["GuiStopButton"].BindMethod(this.stopByGui.Bind(this))

        vIcon_resume=%A_ScriptDir%\Resource\Image\resume.png
        vIcon_pause=%A_ScriptDir%\Resource\Image\pause.png

        this.guiMain.Add("Picture", vIcon_resume, "w24 h24 x+5 yp+4 +Hidden", "GuiResumeButton", 0)
        this.guiMain.Add("Picture", vIcon_pause, "w24 h24 xp yp +Hidden", "GuiPauseButton", 0)

        this.guiMain.Controls["GuiResumeButton"].BindMethod(this.resumeByGui.Bind(this))
        this.guiMain.Controls["GuiPauseButton"].BindMethod(this.pauseByGui.Bind(this))

        this.guiMain.Add("Button", "리로드[F12]", "w80 h30 X+5 yp-4 ", "GuiReloadButton", 0)
        this.guiMain.Controls["GuiReloadButton"].BindMethod(this.reloadByGui.Bind(this))

        this.guiMain.Add("Button", "설정", "w40 h30 X+5 ", "GuiConfigButton", 0)
        this.guiMain.Add("Button", "패스", "w40 h30 X+5 ", "GuiWaitResultButton", 0)

        this.guiMain.Controls["GuiConfigButton"].BindMethod(this.configByGui.Bind(this))
        this.guiMain.Controls["GuiWaitResultButton"].BindMethod(this.waitingResultByGui.Bind(this))

        return currentWindowHeight

    }
    updateStatusColor( statusLabel, status , changeColor:=0 ){
        if( changeColor = 1 ){
            this.guiMain.Controls[statusLabel].SetOptions("+cBlue")
        }else if( changeColor = 2 ){
            this.guiMain.Controls[statusLabel].SetOptions("+cPurple")
        }else if( changeColor = 3 ){
            this.guiMain.Controls[statusLabel].SetOptions("+cRed")
        }else{
            this.guiMain.Controls[statusLabel].SetOptions("+cBlack")
        }
        this.guiMain.Controls[statusLabel].setText(status)
    }
    updateStatus( statusLabel, status ){
        if( statusLabel = "")
            return
        this.guiMain.Controls[statusLabel].setText(status)
    }
    initWindowStatistic(_height){
        global baseballAutoConfig

        currentPlayer:=baseballAutoConfig.players[1]

        currentWindowHeight:=50
        this.guiMain.addGroupBox("Main Statstics", 10, _height , this.maxGroupWidth, currentWindowHeight , , true )

        existIndex:=1
        for index, value in BaseballAutoPlayer.AVAILABLE_MODES
        { 
            if( value = "등반" or value ="로얄"){
                continue
            }
            guiTitle:=% value ":"
            if ( existIndex = 1 ){
                option:=% "xs+10 ys+15 section"
            }else{
                if(existIndex=6 or existIndex = 11){
                    option:=% "xs y+4"
                }else{
                    option:=% "x+30 yp"
                }
            } 
            ; this.guiMain.Add("Text", "단독 활성화 : ", "xs+5 yp+20 section")
            this.guiMain.Add("Text", guiTitle, option)
            existIndex++
        } 

        existIndex:=1
        for index, value in BaseballAutoPlayer.AVAILABLE_MODES
        { 
            if( value = "등반" or value ="로얄"){
                continue
            }
            ; guiTitle:=% index ". " value
            guiTitle:=currentPlayer.countPerMode[value]
            guiLabel:=% "Statistic" index "Result"
            if ( existIndex = 1 ){
                option:=% "xs+28 ys w22 right section"
            }else{
                if(existIndex=6 or existIndex = 11){
                    option:=% "xs y+4 wp right"
                }else{
                    option:=% "x+36 yp wp right"
                }
            } 
            this.guiMain.Add("Text", guiTitle, option, guiLabel,0)
            BaseballAutoPlayer.STASTICS_KEY_MAP[value]:=guiLabel 
            existIndex++
        } 
        return currentWindowHeight
    }
    initLogWindow(_height){
        currentWindowHeight:=this.CONST_SIZE_LOG_HEIGHT
        ; this.guiMain.Add("Edit", "Logs", "Readonly xp y+5 w" this.maxGroupWidth-1 " h" currentWindowHeight-30 , "GuiLoggerLogging",0)
        this.guiMain.Add("logEdit", "Logs", "Readonly x10 y" _height+5 " w" this.maxGroupWidth-1 " h" currentWindowHeight-5 , "GuiLoggerLogging",0)
        ; this.guiMain.addGroupBox("Logs", 10, _height , this.maxGroupWidth, currentWindowHeight , , true )

        ; this.guiMain.Add("Text", "GoodDay", "x+15 	yp w100", "GuiLoggerSubTitle",0)

        return currentWindowHeight+5
    }

    guiLog( title, subTitle, logMessage ){
        currentLog:=this.guiMain.Controls["GuiLoggerLogging"].get()
        StringLen, length, currentLog
        if( length > 1000000 ){
            currentLog:=""
        }
        this.guiMain.Controls["GuiLoggerLogging"].set( logMessage currentLog )
    }
    initConfigWindow(_height){
        global baseballAutoConfig
        currentWindowHeight:=this.CONST_SIZE_CONFIG_HEIGHT
        ; currentWindowHeight:=300

        this.guiMain.addGroupBox("Config", 10, _height , this.maxGroupWidth, currentWindowHeight , , true )
        ; this.guiMain.Add("CheckBox", "Pushbullet ", "xs+5 ys+20 h10", "configPushbulletEnabled",0)
        ; this.guiMain.Add("Button", "Save", "x" this.maxGroupWidth -45 " yp+10 w50", "buttonConfigSave",0)

        this.guiMain.Add("Text", "단독 활성화 : ", "xs+5 yp+20 section")

        memberIndex:=1
        for index, value in BaseballAutoPlayer.AVAILABLE_MODES
        { 
            if( value = "등반" or value ="로얄"){
                continue
            }
            guiLabel :=% "AloneMode" index "CheckBox"
            if ( memberIndex = 1 ){
                baseballAutoConfig.standaloneEnabledModeMap[value]:=true
                option:=% "xs+5 y+5 checked disabled"
            }else{
                if(memberIndex=7 or memberIndex = 13){
                    option:=% "xs+5 y+5"
                }else{
                    option:="x+0 yp"
                }
                if( value = "클협" ){
                    baseballAutoConfig.standaloneEnabledModeMap[value]:=false
                    option:= % option " disabled"
                }else if ( baseballAutoConfig.standaloneEnabledModeMap[value] ){
                    option:= % option " checked"
                }
            } 

            this.guiMain.Add("CheckBox", value, option, guiLabel,0)
            memberIndex++
        } 

        this.guiMain.Add("Text", "단독 순서 : ", "xs y+13") 
        this.guiMain.Add("Edit", baseballAutoConfig.standAloneModeOrderString, "xs y+3 h17 w" this.maxGroupWidth-10, "configJobOrder")

        ; baseballAutoConfig.delaySecForClick
        ; baseballAutoConfig.delaySecChangeWindow
        ; baseballAutoConfig.delaySecSkip
        ; baseballAutoConfig.delaySecReboot
        this.guiMain.Add("Text", "딜레이 : ", "xs y+13")
        this.guiMain.Add("Text", "클릭: ", "xs y+3 section")
        this.guiMain.Add("Edit", baseballAutoConfig.delaySecForClick, "x+0 ys-2 w20 h15 +Right", "delayForClickConfigEdit")
        this.guiMain.Add("Text", "초 화면: ", "x+0 ys+0")
        this.guiMain.Add("Edit", baseballAutoConfig.delaySecChangeWindow, "x+0 ys-2 w20 h15 Right", "delayForChangeWindowConfigEdit")
        this.guiMain.Add("Text", "초 스킵: ", "x+0 ys+0")
        this.guiMain.Add("Edit", baseballAutoConfig.delaySecSkip, "x+0 ys-2 w20 h15 Right", "delayForSkipConfigEdit")
        this.guiMain.Add("Text", "초 리붓: ", "x+0 ys+0")
        this.guiMain.Add("Edit", baseballAutoConfig.delaySecReboot, "x+0 ys-2 w20 h15 Right", "delayForRebootConfigEdit")
        this.guiMain.Add("Text", "초 ", "x+0 ys+0")

        return currentWindowHeight
    }

    initOptionWindow( _height ){
        global baseballAutoConfig

        currentWindowHeight=40
        this.guiMain.addGroupBox("Options", 10, _height , this.maxGroupWidth, currentWindowHeight , , true )

        option:="xs+10 ys+20"
        if( baseballAutoConfig.usingEquipmentForRankingBattleFlag){
            option:= % option " checked"
        }
        this.guiMain.Add("Checkbox", "랭킹장비", option, "RankingBattleEquipmentCheckBox", 0)

        option:="x+10 yp"
        if( baseballAutoConfig.usingBoostItemFlag){
            option:= % option " checked"
        }
        this.guiMain.Add("Checkbox", "부스터", option, "BoosterChk", 0)

        option:="x+10 yp"
        if( baseballAutoConfig.usingStageModeEquipmentFlag){
            option:= % option " checked"
        }
        this.guiMain.Add("Checkbox", "스테장비", option, "StageEquipChk", 0)

        return currentWindowHeight
    }
    getUsingEquipment(){
        return this.guiMain.Controls["RankingBattleEquipmentCheckBox"].get()
    } 
    setUsingEquipment(bool){
        ; configFile 에서 설정되는 부분
        this.guiMain.Controls["RankingBattleEquipmentCheckBox"].set(bool)
    }

    getUseStageEquip(){
        return this.guiMain.Controls["StageEquipChk"].get()
    }

    setUseStageEquip( bool ) {
        ; configFile 에서 설정되는 부분
        this.guiMain.Controls["StageEquipChk"].set(bool)
    }

    getUseBooster() {
        return this.guiMain.Controls["BoosterChk"].get()
    }
    setUseBooster( bool ) {
        ; configFile 에서 설정되는 부분
        this.guiMain.Controls["BoosterChk"].set(bool)
    }

    getPaused(){
        return this.BoolPaused
    }
    startByGui() {
        global baseballAuto

        baseballAuto.start()
    }
    guiClosed(){

        msgbox "Closed"
    }
    stopByGui() {
        global baseballAuto
        baseballAuto.tryStop()
    }

    configByGui( thisGui ){

        this.changeContents( this.toggleConfig)
        this.toggleConfig?this.toggleConfig:=false:this.toggleConfig:=true

    }
    byePlayerFunction(){
        global globalCurrentPlayer, baseballAutoConfig
        targetAppTiile:=globalCurrentPlayer.getAppTitle()
        if( targetAppTiile = "" ){

            player:=baseballAutoConfig.getDefaultPlayer()
            targetAppTiile:=player.getAppTitle()
        }
        if not ( targetAppTiile =""){
            winmove, %targetAppTiile%,,3841,0
        }
        ; MsgBox, % "Target App=" targetAppTiile

    }

    hiPlayerFunction(){
        global globalCurrentPlayer, baseballAutoConfig
        targetAppTiile:=globalCurrentPlayer.getAppTitle()
        if( targetAppTiile = "" ){

            player:=baseballAutoConfig.getDefaultPlayer()
            targetAppTiile:=player.getAppTitle()
        }
        if not ( targetAppTiile =""){
            winmove, %targetAppTiile%,,0,0
        }
        ; winmove, %targetAppTiile%,,0,0
    }

    reloadByGui() {
        global baseballAuto, baseballAutoConfig
        baseballAuto.reload()

        title := this.getTitle()
        WinGetPos, posx, posy, width, height, %title%
        baseballAutoConfig.setLastGuiPosition(posx, posy)

        Reload
    }
    clearStatsByGui(){

        global baseballAutoConfig

        for index,player in baseballAutoConfig.players
        {
            player.setResult(0)
            if( index = 1){
                for key in player.countPerMode
                {
                    player.setCurrentModeResult(key,0)
                }
            }
        }
    }
    savePlayerByGui(){
        this.saveGuiConfigs()
        ToolTip, Player Saved
        Sleep , 500
        ToolTip
    }

    saveGuiConfigs(){
        global baseballAutoConfig
        memberIndex:=1

        for index, value in BaseballAutoPlayer.AVAILABLE_MODES
        { 
            if( value = "등반" or value ="로얄"){
                continue
            }
            guiLabel :=% "AloneMode" index "CheckBox" 
            baseballAutoConfig.standaloneEnabledModeMap[value]:=this.guiMain.Controls[guiLabel].get()
            memberIndex++
        } 

        baseballAutoConfig.setStandAloneModeOrderString(this.getJobOrder())
        baseballAutoConfig.enabledPlayers:=[]
        for index,player in baseballAutoConfig.players
        {
            this.getGuiInfo(player)
            player.setStandAloneModeOrder(baseballAutoConfig.standAloneModeOrderString)
            player.setStandAloneModeEnableMap(baseballAutoConfig.standaloneEnabledModeMap)
            if( player.getEnabled() ){
                baseballAutoConfig.enabledPlayers.push(player)
            }
        }
        baseballAutoConfig.setUsingEquipmentForRankingBattleFlag(this.getUsingEquipment())
        baseballAutoConfig.setUsingBoostItemFlag(this.getUseBooster())
        baseballAutoConfig.setUsingStageModeEquipmentFlag(this.getUseStageEquip())

        baseballAutoConfig.setDelySecForClick(this.getGuiValueDelayForClick())
        baseballAutoConfig.setDelaySecChangeWindow(this.getGuiValueDelayForChangeWindow())
        baseballAutoConfig.setDelaySecSkip(this.getGuiValueDelayForSkip())
        baseballAutoConfig.setDelaySecReboot(this.getGuiValueDelayForReboot())

        baseballAutoConfig.saveConfigFile()
    }
    rolePassByGui(){
        global globalContinueFlag
        globalContinueFlag:=true
        ToolTip, " JUST NEXT PLAYER"
        Sleep , 500
        ToolTip
    }
    roleAllowByGui(){
        global globalCurrentPlayer
        globalCurrentPlayer["status"]:="AUTO_PLAYING"
        ToolTip, % globalCurrentPlayer.getAppTitle() " Already AutoPlaying()"
        Sleep , 500
        ToolTip
    }
    waitingResultByGui(){
        global baseballAuto 
        baseballAuto.setWantToResult(true)

        ToolTip, 종료 또는 Mode Skip을 요청합니다.
        Sleep , 1000
        ToolTip
    }
    getGuiInfo(player){
        player.setEnabled(this.guiMain.Controls[player.getKeyEnable()].get())
        player.setAppTitle(this.guiMain.Controls[player.getKeyAppTitle()].get())
        player.setRole(this.guiMain.Controls[player.getKeyRole()].get())
        player.setBattleType(this.guiMain.Controls[player.getKeyBattleType()].get())
    }
    getJobOrder(){
        return this.guiMain.Controls["configJobOrder"].get()
    }
    setJobOrder( order ){
        this.guiMain.Controls["configJobOrder"].set(order)
    }

    getGuiValueDelayForClick(){
        return this.guiMain.Controls["delayForClickConfigEdit"].get()
    }

    getGuiValueDelayForChangeWindow(){
        return this.guiMain.Controls["delayForChangeWindowConfigEdit"].get()
    }

    getGuiValueDelayForSkip(){
        return this.guiMain.Controls["delayForSkipConfigEdit"].get()
    }
    getGuiValueDelayForReboot(){
        return this.guiMain.Controls["delayForRebootConfigEdit"].get()
    }

    started(){
        this.statusPaused:=false
        this.guiMain.Controls["GuiStopButton"].show()
        this.guiMain.Controls["GuiPauseButton"].show()
        this.guiMain.Controls["GuiStartButton"].hide()
    }

    pauseByGui(){
        if( this.statusPaused = false ){
            this.statusPaused:= true
            this.guiMain.Controls["GuiPauseButton"].hide()
            this.guiMain.Controls["GuiResumeButton"].show()
            pause
        }
    }

    resumeByGui(){
        if( this.statusPaused = true ){
            this.statusPaused:= false
            this.guiMain.Controls["GuiPauseButton"].show()
            this.guiMain.Controls["GuiResumeButton"].hide()
            pause
        }
    }
    stopped(){
        this.guiMain.Controls["GuiStopButton"].hide()
        this.guiMain.Controls["GuiPauseButton"].hide()
        this.guiMain.Controls["GuiResumeButton"].hide()
        this.guiMain.Controls["GuiStartButton"].show()
    }
    Activate(CtrlHwnd, GuiEvent, EventInfo, ErrLevel:="") {
        MsgBox % "You've really done it now.`r`nCtrlHwnd= " CtrlHwnd "`r`nGuiEvent = " GuiEvent "`r`nEventInfo = " EventInfo "`r`nErrLevel = " ErrLevel
    }

    TestRoutine(){
        MsgBox % "You've activated the test subroutine!"
    }
}

