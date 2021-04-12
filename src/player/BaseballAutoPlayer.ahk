class BaseballAutoPlayer{
    static AVAILABLE_ROLES:=["리그","대전","랭대","홈런","친구"]
    static AVAILABLE_PLAY_TYPE:=["전체","공격","수비"]

    static NEXT_PLAYER_STATUS:=["Unknwon","자동중","리그종료","끝" ]
    static STOP_PLAYER_STATUS:=["끝","완료"]

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
    needToNextPlayer(){
        return this.hasValue(this.status,BaseballAutoPlayer.NEXT_PLAYER_STATUS) 
    }
    needToStop(){
        return this.hasValue(this.status,BaseballAutoPlayer.STOP_PLAYER_STATUS) 
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
        if not ( this.hasValue( role, BaseballAutoPlayer.AVAILABLE_ROLES)) 
        { 
            role:=BaseballAutoPlayer.AVAILABLE_ROLES[1]
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
        if not ( this.hasValue( _battleType, BaseballAutoPlayer.AVAILABLE_PLAY_TYPE)) 
        { 
            _battleType:=BaseballAutoPlayer.AVAILABLE_PLAY_TYPE[1]
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
    hasValue( target, stringArray){
        result:=false
        for index, value in stringArray
        {
            if( value = target){
                result:=true
                break
            }
        }
        return result
    }
}