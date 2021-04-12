#include %A_ScriptDir%\src\util\IniController.ahk
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
            player := new BaseAutoPlayer(A_Index)

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

class BaseAutoPlayer{

    __NEW( index , title:="(Main)", enabled:=false, role:="League" ){
        this.index:=index
        this.appTitle:=title
        this.enabled:=enabled
        this.appRole:=role 
        this.watingResult:=false
        this.status:="Unknwon"
        this.battleType:="전체"
        this.result:=0
        this.remainFriendsBattleCount:=40
        this.remainRealTimeBattleCount:=2
    } 
    getResult(){
        return this.result
    }
    addResult(){ 
        this.setResult( this.result + 1)
    } 
    setResult( result ){
        global baseballAutoGui, baseballAutoConfig
        if ( result ="" ){
            result:=0
        }
        this.result:=result

        baseballAutoConfig.savePlayerResult(this)
        baseballAutoGui.updateStatus( this.getKeyResult(), this.result)
    }
    setNeedSkip( needSkip:=false){
        if( needSkip )
            this.setResultColor(1)
        else
            this.setResultColor(0)
    }
    setPostSeason(){
        this.setResultColor(2)
    }
    setResultColor( changeColor:=0 ){
        global baseballAutoGui		
        baseballAutoGui.updateStatusColor( this.getKeyResult(), this.result, changeColor)	
    }

    getEnabled(){
        return this.enabled
    }
    getRemainFriendsBattleCount(){
        return this.remainFriendsBattleCount
    }
    needToStopFriendsBattle(){
        this.remainFriendsBattleCount--
        if(this.remainFriendsBattleCount<= 0){
            return true
        }Else
            return false
    }
    
    getRemainRealTimeBattleCount(){
        return this.remainRealTimeBattleCount
    }
    needToStopRealTimeBattle(){
        this.remainRealTimeBattleCount--
        if(this.remainRealTimeBattleCount<= 0){
            return true
        }Else
            return false
    }

    
    getAppTitle(){
        return this.appTitle
    }
    needToStay(){
        if( this.status = "Unknwon" or this.status ="자동중" or this.status ="리그종료" or this.status ="끝")
            return false
        else
            return true
    }
    needToStop(){
        if( this.status ="끝")
            return true
        else
            return false
        this.setStatusColor(2)
    }
    setWantToWaitResult(){
        this.watingResult:=true
    }
    getWaitingResult(){
        return this.watingResult
    }
    setCheck(){
        this.setStatusColor(1)
    }
    setCheckDone(){
        this.setStatusColor(0)
    }
    setStay(){
        this.setStatus("조작중")
    }
    setBye(){
        this.setStatus("끝")
    }
    setRealFree(){
        this.setStatus("리그종료")		
    }
    setFree(){
        this.setStatus("자동중")		
    }	

    setUnknwon(){
        this.setStatus("Unknwon")		
    }

    getStatus(){
        return this.status
    }
    setStatus( status ){
        global baseballAutoGui		
        this.status:=status
        baseballAutoGui.updateStatus( this.getKeyStatus(), this.status)
    }
    setStatusColor( changeColor:=0){
        global baseballAutoGui		
        baseballAutoGui.updateStatusColor( this.getKeyStatus(), this.status, changeColor)	
    }

    setEnabled( bool ){
        if( bool = true or bool="true" or bool=1)
            this.enabled:=true
        else
            this.enabled:=false
    }

    setAppTitle( title ){
        this.AppTitle:=title 
    }
    setRole( role ){
        if role not in 리그,대전,랭대,홈런,친구,일꾼,기타
        { 
            role:="리그"
        }
        this.appRole:=role
    }
    getRole(){
        return this.appRole
    }

    getBattleType(){
        return this.battleType

    }
    setBattleType( _battleType){
        if _battleType not in 수비,공격,전체
        {
            _battleType:="전체"
        }

        this.battleType:=_battleType
    }

    getKeyEnable(){
        return % "player" this.index "Enabled"
    }
    getKeyRole(){
        return % "player" this.index "Role"
    }
    getKeyResult(){
        return % "player" this.index "Result"
    }
    getKeyBattleType(){
        return % "player" this.index "BattleType"
    }
    getKeyAppTitle(){
        return % "player" this.index "AppTitle"
    }
    getKeyStatus(){
        return % "player" this.index "Status"
    }

    setWorkerNext(){

    }

    getWorkerRole(){

    }

}