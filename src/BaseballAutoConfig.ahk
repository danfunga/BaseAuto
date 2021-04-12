#include %A_ScriptDir%\src\util\IniController.ahk
#include %A_ScriptDir%\src\player\BaseballAutoPlayer.ahk
class BaseballAutoConfig{

    __NEW( configFileName ){
        this.configFile := new IniController( configFileName )

        This.players := []
        This.enabledPlayers:=Array()
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
        loop, 4
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
                    player.setAppTitle("(Hard)")
                if( playerRole = "" )
                    player.setRole("리그")

                if (playerBattleType="")	
                    player.setBattleType("전체")
            }
            if( player.getEnabled() ){
                this.enabledPlayers.push(player)

            }
            ; msgbox % "player " A_Index " Enabled : " player["ENABLE"] " Title: " player["TITLE"] " Role : "player["ROLE"]
            this.players.Push( player)
        }
       
        

    }
    loadConfig(){
         global baseballAutoGui
        loadedJobOrder:=this.configFile.loadValue("GLOBAL_CONFIG","JobOrder")
        if( loadedJobOrder = ""){
            loadedJobOrder:="홈런,랭킹,친구"
        }
        baseballAutoGui.setJobOrder(loadedJobOrder)
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
        this.configFile.saveValue("GLOBAL_CONFIG","JobOrder",baseballAutoGui.getJobOrder())
        
    }
    savePlayerResult( player ){
        this.configFile.saveValue("PLAYERS_CONFIG",player.getKeyResult(), player.getResult()) 
    }
}

