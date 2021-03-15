﻿#include %A_ScriptDir%\src\gui\MC_GuiObject.ahk
; #include %A_ScriptDir%\src\gui\MC_MacroGui.ahk

Class BaseballAutoGui{
    width:=330
    maxGroupWidth := this.width-20

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
        ; this.guiMain.Show(  )			
        ; this.guiMain.Show( "w" this.width . " h" . totalHeight )			
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
        mainHeight+=this.initButtonWindow(mainHeight)
        mainHeight+=this.initLogWindow(mainHeight)		

        this.totalHeight:=mainHeight+this.initConfigWindow(mainHeight)+5
        return mainHeight
    }

    initConfigButton( _height ){
        currentWindowHeight:=15
        ; option:=% "xs+5 ys+20 disabled"

        this.guiMain.Add("Button", "Save", "x" this.maxGroupWidth -35 " y0", "RoleSaveButton",0)
        this.guiMain.Add("Button", "Clear", "x" this.maxGroupWidth -85 " y0", "StatClearButton",0)
        ; this.guiMain.Add("Button", "pass", "x" this.maxGroupWidth -30 " y+10", "RolePassButton",0)
        ; this.guiMain.Add("Button", "OK", "x" this.maxGroupWidth -30 " y+10", "RoleAllowButton",0)
        this.guiMain.Controls["RoleSaveButton"].BindMethod(this.roleSaveByGui.Bind(this))
        this.guiMain.Controls["StatClearButton"].BindMethod(this.clearStatsByGui.Bind(this))
        ; this.guiMain.Controls["RolePassButton"].BindMethod(this.rolePassByGui.Bind(this))
        ; this.guiMain.Controls["RoleAllowButton"].BindMethod(this.roleAllowByGui.Bind(this))
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

        for index, player in baseballAutoConfig.players
        {
            guiType:="ComboBox"
            guiTitle:="리그|기타"
            guiLable:=player.getKeyRole() 
            if ( index = 1 )
                option:="xs+110 ys+15 +Center w50"
            else
                option:="xp y+2 wp"

            this.guiMain.Add(guiType, guiTitle, option, guiLable,0)
            this.guiMain.Controls[guiLable].select(player.getRole())
        }
        for index, player in baseballAutoConfig.players
        {
            guiType:="ComboBox"
            guiTitle:="수비|공격|전체"
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

        this.guiMain.Add("Button", "설정", "w60 h30 X+5 ", "GuiConfigButton", 0)
        this.guiMain.Add("Button", "W", "w20 h30 X+5 ", "GuiWaitResultButton", 0)

        this.guiMain.Controls["GuiConfigButton"].BindMethod(this.configByGui.Bind(this))
        this.guiMain.Controls["GuiWaitResultButton"].BindMethod(this.waitingResultByGui.Bind(this))

        return currentWindowHeight

    }
    updateStatusColor( statusLabel, status , changeColor:=false ){
        if( changeColor ){			
            this.guiMain.Controls[statusLabel].SetOptions("+cRed")		
        }else{
            this.guiMain.Controls[statusLabel].SetOptions("+cBlack")		
        }
        this.guiMain.Controls[statusLabel].setText(status)	
    }
    updateStatus( statusLabel, status ){		
        this.guiMain.Controls[statusLabel].setText(status)	
    }
    initLogWindow(_height){
        currentWindowHeight=200
        ; this.guiMain.Add("Edit", "Logs", "Readonly xp y+5 w" this.maxGroupWidth-1 " h" currentWindowHeight-30 , "GuiLoggerLogging",0)
        this.guiMain.Add("logEdit", "Logs", "Readonly x10 y" _height+5 " w" this.maxGroupWidth-1 " h" currentWindowHeight-5 , "GuiLoggerLogging",0)
        ; this.guiMain.addGroupBox("Logs", 10, _height , this.maxGroupWidth, currentWindowHeight , , true )

        ; this.guiMain.Add("Text", "GoodDay", "x+15 	yp w100", "GuiLoggerSubTitle",0)

        return currentWindowHeight+5
    }

    guiLog( title, subTitle, logMessage ){
        currentLog:=this.guiMain.Controls["GuiLoggerLogging"].get()
        this.guiMain.Controls["GuiLoggerLogging"].set( logMessage currentLog )
    }
    initConfigWindow(_height){
        currentWindowHeight=80
        this.guiMain.addGroupBox("Config", 10, _height , this.maxGroupWidth, currentWindowHeight , , true )

        this.guiMain.Add("CheckBox", "Pushbullet ", "xs+5 ys+20 h10", "configPushbulletEnabled",0)
        this.guiMain.Add("CheckBox", "SchreenShot Error ", "xp y+10", "configScreenShotOnError",0)

        return currentWindowHeight
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
        }           
    }
    roleSaveByGui(){
        global baseballAutoConfig

        baseballAutoConfig.enabledPlayers:=[]
        for index,player in baseballAutoConfig.players
        {
            this.getGuiInfo(player) 
            if( player.getEnabled() ){
                baseballAutoConfig.enabledPlayers.push(player)
            }
        }

        baseballAutoConfig.saveConfig()
        ToolTip, Role Saved
        Sleep , 500
        ToolTip
        ; ToolTip, % "Enabled Players " baseballAutoConfig.enabledPlayers.length()

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
        global baseballAutoConfig
        ToolTip, 모든 경기가 종료되길 체크 합니다.
        Sleep , 1000
        ToolTip
        baseballAutoConfig.setWantToResult()	
    }
    getGuiInfo(player){
        player.setEnabled(this.guiMain.Controls[player.getKeyEnable()].get())
        ; ToolTip % player.getKeyEnable()
        ; ToolTip % this.guiMain.Controls[player.getKeyAppTitle()].get()
        player.setAppTitle(this.guiMain.Controls[player.getKeyAppTitle()].get())
        player.setRole(this.guiMain.Controls[player.getKeyRole()].get())
        player.setBattleType(this.guiMain.Controls[player.getKeyBattleType()].get())
    }

    started(){
        ; msgbox % "Started " this.BoolPaused
        this.statusPaused:=false

        this.guiMain.Controls["GuiStopButton"].show()
        this.guiMain.Controls["GuiPauseButton"].show()		
        ; this.guiMain.Controls["GuiResumeButton"].show()		
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

; ACTIVE_ID:="(Hard)"
; BooleanDebugMode:=true

; baseballAuto := new BaseballAuto()
; baseballAutoGui := new BaseballAutoGui()