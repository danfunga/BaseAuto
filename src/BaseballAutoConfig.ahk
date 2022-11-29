#include %A_ScriptDir%\src\util\IniController.ahk
#include %A_ScriptDir%\src\player\BaseballAutoPlayer.ahk
class BaseballAutoConfig{

    __NEW( configFileName ){
        this.configFile := new IniController( configFileName )

        This.players := []
        This.enabledPlayers:=Array()        
        this.standaloneEnabledModeMap:={}
        
        for index, value in BaseballAutoPlayer.AVAILABLE_MODES
        {
           if( value = "등반" or value="로얄"){
                continue
            }
            if( value = "리그" or value = "홈런" or value = "랭대" or value = "히스" or value = "친구" or value = "보상"){
                this.standaloneEnabledModeMap[value]:=true 
            }else{
                this.standaloneEnabledModeMap[value]:=false
            } 
        }
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

        This.players := []
        This.enabledPlayers:= Array()

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
            } 
            if( player.getEnabled() ){
                this.enabledPlayers.push(player)
            }
            ; msgbox % "player " A_Index " Enabled : " player["ENABLE"] " Title: " player["TITLE"] " Role : "player["ROLE"]
            this.players.Push( player)
        }

        for index, value in BaseballAutoPlayer.AVAILABLE_MODES
        { 
            if( value = "등반" or value="로얄"){
                continue
            }
            loadValue := this.configFile.loadValue("STANDALONE_ENABLED_MODE", value )
            if( loadValue != "" ){
                this.standaloneEnabledModeMap[value]:=loadValue 
            } 
        } 
    }
    loadConfig(){
        global baseballAutoGui
        loadedJobOrder:=this.configFile.loadValue("GLOBAL_CONFIG","JobOrder")
        if( loadedJobOrder = ""){
            loadedJobOrder:="리그,실대,홈런,랭대,히스,스테,타홀,클협,친구,보상"
        }
        baseballAutoGui.setJobOrder(loadedJobOrder)

        loadedUseEquip:=this.configFile.loadValue("GLOBAL_CONFIG","UseEquip")
        if( loadedUseEquip = ""){
            loadedUseEquip:=0
        }
        baseballAutoGui.setUsingEquipment(loadedUseEquip)

        loadedUseBooster:=this.configFile.loadValue("GLOBAL_CONFIG","UseBooster")
        if( loadedUseBooster = ""){
            loadedUseBooster:=0
        }
        baseballAutoGui.setUseBooster(loadedUseBooster)
        for index, targetPlayer in this.enabledPlayers
        {
            targetPlayer.setStandAloneModeOrder(loadedJobOrder)
            targetPlayer.setStandAloneModeEnableMap(this.standaloneEnabledModeMap)
        }
    }

    saveConfig(){
        global baseballAutoGui
        PLAYER_KEY:="PLAYERS_CONFIG"
        for index, element in this.players
        {
            this.configFile.saveValue(PLAYER_KEY,element.getKeyEnable(), element.getEnabled()) 
            this.configFile.saveValue(PLAYER_KEY,element.getKeyAppTitle(), element.getAppTitle()) 
            this.configFile.saveValue(PLAYER_KEY,element.getKeyRole(), element.getRole()) 
            this.configFile.saveValue(PLAYER_KEY,element.getKeyBattleType(), element.getBattleType()) 
        }
         for index, value in BaseballAutoPlayer.AVAILABLE_MODES
        { 
             if( value = "등반" or value="로얄"){
                continue
            }
            this.configFile.saveValue("STANDALONE_ENABLED_MODE",value,this.standaloneEnabledModeMap[value]) 
        }
        this.configFile.saveValue("GLOBAL_CONFIG","JobOrder",baseballAutoGui.getJobOrder())
        this.configFile.saveValue("GLOBAL_CONFIG","UseEquip",baseballAutoGui.getUsingEquipment()) 
        this.configFile.saveValue("GLOBAL_CONFIG","UseBooster",baseballAutoGui.getUseBooster()) 
    }

    savePlayerResult( player ){
        this.configFile.saveValue("PLAYERS_CONFIG",player.getKeyResult(), player.getResult()) 
    }
}

