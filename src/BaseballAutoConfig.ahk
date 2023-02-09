#include %A_ScriptDir%\src\util\IniController.ahk
#include %A_ScriptDir%\src\player\BaseballAutoPlayer.ahk
class BaseballAutoConfig{

    __NEW( configFileName ){
        this.configFile := new IniController( configFileName )

        ; 플레이어 설정
        This.players := []
        This.enabledPlayers:=Array() 

        ; 단독 모드 설정
        this.standaloneEnabledModeMap:={}
        this.standAloneModeOrderString:=""

        ; 장비 설정
        this.usingEquipmentForRankingBattleFlag:=false
        this.usingBoostItemFlag:=false
        this.usingStageModeEquipmentFlag:=false
        this.usingAutofrontActive:=false

        ; 딜레이 설정
        this.delaySecForClick:=2
        this.delaySecChangeWindow:=5
        this.delaySecSkip:=0.1
        this.delaySecReboot:=60

        this.initConfig()
    }
    getDefaultPlayer(){
        return this.players[1]
    }
    getLastGuiPosition( ByRef posX, ByRef posY)
    {
        posX:= this.configFile.loadValue("GUI_POSITION", "MAIN_X")
        posY:= this.configFile.loadValue("GUI_POSITION", "MAIN_Y")
        ; ToolTip, "posX " %posX% "  posY" %posY% 
        if ( posX = "" ) 
            posX:=1150
        if ( posY = "" ) 
            posY:=0
    }
    setLastGuiPosition( posX, posY)
    {
        this.configFile.saveValue("GUI_POSITION", "MAIN_X", posx)
        this.configFile.saveValue("GUI_POSITION", "MAIN_Y", posy)
    }

    initConfig(){
        ; init 단독 모드 활성화 상태
        for index, value in BaseballAutoPlayer.AVAILABLE_MODES
        { 
            if( value = "등반" or value="로얄"){
                continue
            }
            loadValue := this.configFile.loadValue("STANDALONE_ENABLED_MODE", value )
            if( loadValue != "" ){
                this.standaloneEnabledModeMap[value]:=loadValue 
            } else{
                if( value = "리그" or value = "홈런" or value = "랭대" or value = "히스" or value = "친구" or value = "보상"){
                    this.standaloneEnabledModeMap[value]:=true 
                }else{
                    this.standaloneEnabledModeMap[value]:=false
                } 
            }
        } 
        ; 단독 모드 순서 
        this.setStandAloneModeOrderString(this.configFile.loadValue("GLOBAL_CONFIG","JobOrder")) 

        PLAYER_KEY:="PLAYERS_CONFIG"
        loop, 2
        {
            player := new BaseballAutoPlayer(A_Index)
            playerEnabled:= this.configFile.loadValue(PLAYER_KEY, player.getKeyEnable() )
            playerRole:= this.configFile.loadValue(PLAYER_KEY, player.getKeyRole() )
            playerTitle:= this.configFile.loadValue(PLAYER_KEY, player.getKeyAppTitle() )
            playerBattleType:= this.configFile.loadValue(PLAYER_KEY, player.getKeyBattleType() )
            playerResultType:= this.configFile.loadValue(PLAYER_KEY, player.getKeyResult() )

            player.setEnabled(playerEnabled)
            player.setAppTitle(playerTitle)
            player.setRole(playerRole) 
            player.setBattleType(playerBattleType)
            player.setResult(playerResultType)
            if( A_Index = 1 )
            { 
                player.setEnabled(true)
                if( playerTitle = "" )
                    player.setAppTitle("nox1")
                if( playerRole = "" )
                    player.setRole("단독")

                if (playerBattleType="")	
                    player.setBattleType("전체")

                ; Main Static 설정
                for index, value in BaseballAutoPlayer.AVAILABLE_MODES
                { 
                    readValue:= this.configFile.loadValue("PLAYERS_STAISTICS", value )
                    if( readValue = "")
                        readValue:=0
                    player.countPerMode[value]:=readValue 
                } 
            } 
            player.setStandAloneModeOrder(this.standAloneModeOrderString)
            player.setStandAloneModeEnableMap(this.standaloneEnabledModeMap)

            if( player.getEnabled() ){
                this.enabledPlayers.push(player)
            }
            this.players.Push( player)
        }
        this.setUsingEquipmentForRankingBattleFlag( this.configFile.loadValue("GLOBAL_CONFIG","UseRankingBattleEquipment") )
        this.setUsingBoostItemFlag( this.configFile.loadValue("GLOBAL_CONFIG","UseBooster") )
        this.setUsingStageModeEquipmentFlag( this.configFile.loadValue("GLOBAL_CONFIG","UseStageModeEquipment") )
        this.setFrontAutoActive( this.configFile.loadValue("GLOBAL_CONFIG","UseAutoFrontActive") )

        this.setDelySecForClick( this.configFile.loadValue("DELAY_CONFIG","clickDelay") )
        this.setDelaySecChangeWindow( this.configFile.loadValue("DELAY_CONFIG","changeWindowDelay") )
        this.setDelaySecSkip( this.configFile.loadValue("DELAY_CONFIG","skipDelay") )
        this.setDelaySecReboot( this.configFile.loadValue("DELAY_CONFIG","rebootDelay") )
    }

    loadConfig(){
        global baseballAutoGui 

        ; baseballAutoGui.setJobOrder(this.standAloneModeOrderString)
        ; baseballAutoGui.setUsingEquipment(this.usingEquipmentFlag)
        ; baseballAutoGui.setUseBooster(this.usingBoostItemFlag)
        ; baseballAutoGui.setUseStageEquip(this.usingStageModeEquipmentFlag)
    }

    setStandAloneModeOrderString( value ){
        if(value =""){
            value:="리그,실대,홈런,랭대,히스,스테,타홀,클협,친구,보상"
        }
        this.standAloneModeOrderString:=value
    }
    getStandAloneModeOrderString(){
        return this.standAloneModeOrderString
    }
    setUsingEquipmentForRankingBattleFlag( value ){
        if(value =""){
            value:=false
        }
        this.usingEquipmentForRankingBattleFlag:=value
    }
    usingRankingBattleEquipment(){
        return this.usingEquipmentForRankingBattleFlag
    }

    setUsingBoostItemFlag( value ){
        if(value =""){
            value:=false
        }
        this.usingBoostItemFlag:=value
    }
    setUsingStageModeEquipmentFlag( value ){
        if(value =""){
            value:=false
        }
        this.usingStageModeEquipmentFlag:=value
    }

    setFrontAutoActive( value ){
        if(value =""){
            value:=false
        }
        this.usingAutofrontActive:=value
    }
    getFrontAutoActive(){
        return this.usingAutofrontActive
    }
   

    setDelySecForClick(value){
        if(value =""){
            value:=2
        }
        this.delaySecForClick:=value
    }
    setDelaySecChangeWindow(value){
        if(value =""){
            value:=5
        }
        this.delaySecChangeWindow:=value
    }
    setDelaySecSkip(value){
        if(value =""){
            value:=0.1
        }
        this.delaySecSkip:=value
    }
    setDelaySecReboot(value){
        if(value =""){
            value:=60
        }
        this.delaySecReboot:=value
    }

    saveConfigFile(){
        PLAYER_KEY:="PLAYERS_CONFIG"
        for index, element in this.players
        {
            this.configFile.saveValue(PLAYER_KEY,element.getKeyEnable(), element.getEnabled()) 
            this.configFile.saveValue(PLAYER_KEY,element.getKeyAppTitle(), element.getAppTitle()) 
            this.configFile.saveValue(PLAYER_KEY,element.getKeyRole(), element.getRole()) 
            this.configFile.saveValue(PLAYER_KEY,element.getKeyBattleType(), element.getBattleType()) 
        }
        for index, value in this.standaloneEnabledModeMap
        { 
            this.configFile.saveValue("STANDALONE_ENABLED_MODE",index,this.standaloneEnabledModeMap[index]) 
        }

        this.configFile.saveValue("GLOBAL_CONFIG","JobOrder",this.standAloneModeOrderString)
        this.configFile.saveValue("GLOBAL_CONFIG","UseRankingBattleEquipment",this.usingEquipmentForRankingBattleFlag) 
        this.configFile.saveValue("GLOBAL_CONFIG","UseBooster",this.usingBoostItemFlag) 
        this.configFile.saveValue("GLOBAL_CONFIG","UseStageModeEquipment",this.usingStageModeEquipmentFlag) 
        this.configFile.saveValue("GLOBAL_CONFIG","UseAutoFrontActive",this.usingAutofrontActive) 

        this.configFile.saveValue("DELAY_CONFIG","clickDelay",this.delaySecForClick) 
        this.configFile.saveValue("DELAY_CONFIG","changeWindowDelay",this.delaySecChangeWindow) 
        this.configFile.saveValue("DELAY_CONFIG","skipDelay",this.delaySecSkip) 
        this.configFile.saveValue("DELAY_CONFIG","rebootDelay",this.delaySecReboot) 
    }

    savePlayerResult( player ){
        this.configFile.saveValue("PLAYERS_CONFIG",player.getKeyResult(), player.getResult()) 
    }

    savePlayerStatistic( player , mode , value){
        this.configFile.saveValue("PLAYERS_STAISTICS",mode, value) 
    }
}

