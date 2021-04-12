class BaseballAutoPlayer{
    static AVAILABLE_ROLES:=["리그","일꾼","단독","실대","랭대","홈런","친구","보상"]
    static AVAILABLE_MODES:=["리그","실대","랭대","홈런","친구","보상"]
    static AVAILABLE_PLAY_TYPE:=["전체","공격","수비"]

    static NEXT_PLAYER_STATUS:=["Unknwon","자동중","리그종료","끝","다음임무"]
    static STOP_PLAYER_STATUS:=["끝","완료"]
    
    ; 기본 모드든에 대한 설정 
    static COUNT_PER_MODE := { "랭대":-1, "홈런":-1, "친구":40, "실대":2,"리그":-1 }

    ; 일꾼 모드 설정
    static COUNT_PER_ASSIST_MODE := { "랭대":-1, "홈런":-1, "친구":40, "실대":2, "보상":1 }    
    static ASSIST_MODE_ARRAY:=["실대","홈런","랭대","친구","보상"]
    static ASSIST_MODE_ENDLESS:=false

    ; 단독 모드 설정
    static COUNT_PER_ALONE_MODE := { "리그":5, "랭대":-1, "홈런":-1, "친구":10, "실대":1,"보상":1 }    
    static ALONE_MODE_ARRAY:=["리그","홈런","랭대","친구","보상"]


 
    __NEW( index , title:="(Main)", enabled:=false, role:="리그" ){
        this.index:=index
        this.appTitle:=title
        this.enabled:=enabled
        this.appRole:=role 
        this.appMode:=role
        this.watingResult:=false
        this.status:="Unknwon"
        this.battleType:="전체"
        this.result:=0
        this.currentBattleRemainCount:=0
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

    getRemainBattleCount(){
        if( this.currentBattleRemainCount < 0 ){
            return "무한"
        }else{
            return this.currentBattleRemainCount
        }
    }

    needToStopBattle(){
        if( this.currentBattleRemainCount < 0 ){
            return false
        }else{
            if( this.this.currentBattleRemainCount = 0 ){
                return true
            }else{
                this.currentBattleRemainCount--    
                if(this.currentBattleRemainCount<= 0){
                    return true
                }else{
                    return false
                }                
            }            
        }
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
        if( this.appRole ="일꾼" or this.appRole="단독"){            
            if( this.setMode("next") ){
                this.setStatus("다음임무")                   
            }else{
                this.setStatus("끝")     
            }
        }else{
            this.setStatus("끝")         
        }        
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
        this.setMode(role)
    }

    setMode( targetMode ){ 
        if( this.appRole ="일꾼" ){
            if( targetMode = "일꾼" ){
                targetMode:=BaseballAutoPlayer.ASSIST_MODE_ARRAY[1]
            }else{
                if( targetMode = "next" ){
                    currentIndex:=this.getIndex(this.appMode,BaseballAutoPlayer.ASSIST_MODE_ARRAY)
                    currentIndex++
                    if( currentIndex > BaseballAutoPlayer.ASSIST_MODE_ARRAY.length() ){
                        if( BaseballAutoPlayer.ASSIST_MODE_ENDLESS ){
                            currentIndex:=1
                        }else{
                            return false
                        }                        
                    }
                    targetMode:=BaseballAutoPlayer.ASSIST_MODE_ARRAY[currentIndex]                                           
                }
            }       
            this.appMode:=targetMode
            this.currentBattleRemainCount:=BaseballAutoPlayer.COUNT_PER_ASSIST_MODE[this.appMode]
            return true
        }else if( this.appRole ="단독" ){
            if( targetMode = "단독" ){
                targetMode:=BaseballAutoPlayer.ALONE_MODE_ARRAY[1]
            }else{
                if( targetMode = "next" ){
                    currentIndex:=this.getIndex(this.appMode,BaseballAutoPlayer.ALONE_MODE_ARRAY)
                    currentIndex++
                    if( currentIndex > BaseballAutoPlayer.ALONE_MODE_ARRAY.length() ){
                        currentIndex:=1
                    }
                    targetMode:=BaseballAutoPlayer.ALONE_MODE_ARRAY[currentIndex]                                           
                }
            }       
            this.appMode:=targetMode
            this.currentBattleRemainCount:=BaseballAutoPlayer.COUNT_PER_ALONE_MODE[this.appMode]
            return true
        }       
        else{
            this.appMode:=this.appRole
            this.currentBattleRemainCount:=BaseballAutoPlayer.COUNT_PER_MODE[this.appMode]
        }
    }
    getMode(){
        return this.appMode
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
    getIndex( target, stringArray){
        result:=0
        for index, value in stringArray
        {
            if( value = target){
                result:=index
                break
            }
        }
        return result
    }
}