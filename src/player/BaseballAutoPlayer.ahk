#include %A_ScriptDir%\src\util\AutoLogger.ahk

class BaseballAutoPlayer{
    static logger:= new AutoLogger( "Player" ) 

    ; static AVAILABLE_ROLES:=["리그","일꾼","단독","실대","랭대","홈런","로얄","친구","보상","스테","히스","등반","클협","타홀"]
    static AVAILABLE_ROLES:=["리그","일꾼","단독","실대","랭대","홈런","로얄","친구","보상","스테","히스","등반","타홀"]
    static AVAILABLE_MODES:=["리그","홈런","랭대","히스","스테","타홀","클협", "친구","보상", "실대","등반","로얄"]
    ; static AVAILABLE_MODES:=["리그","실대","랭대","홈런","로얄","친구","보상","히스","스테","등반","클협","타홀"]
    static AVAILABLE_PLAY_TYPE:=["전체","공격","수비"]
    static STASTICS_KEY_MAP:={}
    static STASTICS_TITLE_KEY_MAP:={}

    static NEXT_PLAYER_STATUS:=["Unknwon","자동중","리그종료","끝","다음임무"]
    static STOP_PLAYER_STATUS:=["끝","리그종료"]

    ; 기본 모드든에 대한 설정 
    static COUNT_PER_MODE := { "랭대":-1, "홈런":-1, "친구":40, "실대":2,"리그":-1, "스테":-1, "타홀":-1, "클협":-1,"등반":-1 }

    ; 일꾼 모드 설정
    static COUNT_PER_ASSIST_MODE := { "랭대":-1,"히스":-1, "홈런":-1, "친구":40, "실대":2, "보상":1 } 
    static ASSIST_MODE_ARRAY:=["홈런","랭대","히스","친구","보상"]
    static ASSIST_MODE_ENDLESS:=false

    ; 1번 돌때 도는 횟수

    static COUNT_PER_ALONE_MODE:={ "리그":5, "실대":1,"랭대":-1,"홈런":-1,"히스":-1, "스테":3,"클협":-1, "타홀":-1,"친구":10, "보상":1 } 
    static DEFULAT_LOOP_COUNT_PER_DAY :={ "리그":-1, "실대":1,"랭대":-1,"홈런":-1,"히스":-1, "스테":3,"클협":2, "타홀":-1,"친구":-1, "보상":-1 } 
    ; 친구대전을 계속 돌 필요 없으니
    ; 사이클 횟수
    LOOP_PER_ALONE_MODE :={} 
    ALONE_MODE_ENABLED_MAP:={ "리그":true, "실대":false,"랭대":true,"홈런":true,"히스":true, "스테":false,"클협":false, "타홀":false,"친구":true, "보상":true } 
    ALONE_MODE_ARRAY:=["리그","실대","홈런","랭대","히스","스테","타홀","친구","보상"] 

    __NEW( index , title:="nox1", enabled:=false, role:="단독" ){
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
        this.countPerMode := { "리그":0, "실대":0,"랭대":0,"홈런":0,"히스":0, "스테":0,"클협":0, "타홀":0,"친구":0, "보상":0, "로얄":0, "등반":0,"클협":0 } 
        this.initTodayLoopCount( false )
    } 
    initTodayLoopCount( needUpdate:=true){ 
        global baseballAutoGui
        for key in BaseballAutoPlayer.DEFULAT_LOOP_COUNT_PER_DAY
        { 
            this.LOOP_PER_ALONE_MODE[key]:=BaseballAutoPlayer.DEFULAT_LOOP_COUNT_PER_DAY[key] 
            if( needUpdate ) {
                if( this.ALONE_MODE_ENABLED_MAP[key] ) {
                    baseballAutoGui.statsticsHighlight(key, false)
                }
            }
        }
    }
    setCurrentModeResult(modeName, value){
        global baseballAutoGui, baseballAutoConfig
        if ( value ="" ){
            value:=0
        }
        this.countPerMode[modeName]:=value

        baseballAutoConfig.savePlayerStatistic(player,modeName,value)
        baseballAutoGui.updateStatus( BaseballAutoPlayer.STASTICS_KEY_MAP[modeName], value)
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
    getCountPerMode(){
        return this.countPerMode
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

    getResult(){
        return this.result
    }
    addResult(){ 
        this.setResult( this.result + 1)
        if( this.index = 1){ 
            this.setCurrentModeResult(this.appMode, this.countPerMode[this.appMode]+1) 
        }
    } 

    getRemainBattleCount(){
        if( this.currentBattleRemainCount < 0 ){
            return "무한"
        }else{
            return this.currentBattleRemainCount
        }
    }

    ; 도는것을 확인했을때 Call
    needToStopBattle(){ 
        if( this.currentBattleRemainCount = 0 ){
            return true
        } else if( this.currentBattleRemainCount < 0 ){
            return false
        }else{
            this.currentBattleRemainCount-- 
            if(this.currentBattleRemainCount<= 0){
                this.currentBattleRemainCount:=0
                return true
            }else{
                return false
            } 
        } 
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

    setWantToWaitResult( want:=true){
        if( want ){
            if( this.appRole ="일꾼" or this.appRole="단독"){ 
                this.logger.log(this.appTitle "의 [" this.appMode "] 모드의 스킵을 요청합니다. ")
            }else{
                this.logger.log(this.appTitle "의 [" this.appMode "] 모드의 종료를 요청합니다.")
            }
        }
        this.watingResult:=want
    }
    getWaitingResult(){
        return this.watingResult
    }
    setCheck(){
        this.setStatusColor(1)
    }
    setCheckDone(){
        global baseballAutoGui
        this.setStatusColor(0)
        baseballAutoGui.statsticsHighlight(this.appMode, false)
    }
    setStay(){
        this.setStatus("조작중")
    }
    setBye(){
        if( this.appRole ="일꾼" or this.appRole="단독"){ 
            if( this.setMode("next") ){
                this.setStatus("다음임무") 
            }else{
                this.setStatus( this.appMode " 종료")  
            }
        }else{
            this.setStatus( this.appRole " 종료") 
        } 
    }
    setRealFree(){
        if( this.appRole ="일꾼" or this.appRole="단독"){ 
            ; 리그모드일테니깐 리그를 못돌게 하자
            this.LOOP_PER_ALONE_MODE[this.appMode]:=0
            this.logger.log( "[" this.appRole "][" this.appMode "] 는 이제 돌지 않습니다.")
            if( this.appMode ="리그 "){
                this.setResultColor(3)
            }
            if( this.setMode("next") ){
                this.setStatus("다음임무")
                return true
            }else{
                this.setStatus( this.appMode " 종료")                
                return false
            }
        }else{
            this.setStatus( this.appRole " 종료")
            return false
        }
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

    setMode( targetMode ){
        global baseballAutoGui
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
                    this.logger.log(this.appTitle "가 [" this.appRole "][" targetMode "] 모드로 동작합니다.. ")
                }
            } 
            this.appMode:=targetMode
            this.currentBattleRemainCount:=BaseballAutoPlayer.COUNT_PER_ASSIST_MODE[this.appMode]
            return true
        }else if( this.appRole = "단독" ){
            if( this.logger.isDayChanged() ){ 
                this.initTodayLoopCount(true)
                this.logger.log("Loop 횟수를 초기화 합니다.")
            }
            if( targetMode = "단독" ){ 
                ; First Mode init
                targetMode:=this.ALONE_MODE_ARRAY[1]
                currentIndex:=1

                for key in BaseballAutoPlayer.DEFULAT_LOOP_COUNT_PER_DAY
                { 
                    if( this.ALONE_MODE_ENABLED_MAP[key] = false or this.LOOP_PER_ALONE_MODE[key] = 0 ) {
                        baseballAutoGui.disableHighlight(key)
                    }else{
                        baseballAutoGui.statsticsHighlight(key, false)
                    }
                } 
            }else{
                if( targetMode = "next" ){
                    if( this.LOOP_PER_ALONE_MODE[this.appMode] > 0 ){
                        ; 횟수 -1 을 진행                                                                      
                        this.LOOP_PER_ALONE_MODE[this.appMode]-- 
                    }

                    if( this.LOOP_PER_ALONE_MODE[this.appMode] = 0 ){
                        ; 더이상 돌 필요 없을 경우 
                        baseballAutoGui.disableHighlight(this.appMode)
                    }else{
                        ; 이번에 끝난 경우 
                        baseballAutoGui.statsticsHighlight(this.appMode, false)
                    }
                    currentIndex:=this.getIndex(this.appMode, this.ALONE_MODE_ARRAY)
                    currentIndex++ 
                    if( currentIndex > this.ALONE_MODE_ARRAY.length() ){
                        currentIndex:=1
                    }

                    if( this.ALONE_MODE_ARRAY.length() = 0 ){
                        this.setStatus("끝") 
                        return false
                    }
                }
            } 
            while(true){
                nextMode:=this.ALONE_MODE_ARRAY[currentIndex] 
                if( this.ALONE_MODE_ENABLED_MAP[nextMode]=false or this.LOOP_PER_ALONE_MODE[nextMode] = 0){
                    ; 여기서 체크는 중복일듯 하다 ==> 없애고 추후 확인 필요.
                    ; baseballAutoGui.disableHighlight(nextMode)
                    currentIndex++ 
                    if( currentIndex > this.ALONE_MODE_ARRAY.length() ){
                        currentIndex:=1
                    }
                    ; this.ALONE_MODE_ARRAY.remove(currentIndex)
                }else{
                    break
                }
            } 
            this.appMode:=this.ALONE_MODE_ARRAY[currentIndex] 
            this.currentBattleRemainCount:=BaseballAutoPlayer.COUNT_PER_ALONE_MODE[this.appMode]
            baseballAutoGui.statsticsHighlight(this.appMode, true)
            this.logger.log("[" this.appRole "][" this.appMode "] 모드로 동작하려 합니다.")
            if ( this.LOOP_PER_ALONE_MODE[this.appMode] = -1){
                loopString :="무한"
            }else{
                loopString :=% this.LOOP_PER_ALONE_MODE[this.appMode] "회"
            }
            if ( this.currentBattleRemainCount = -1){
                thisTimeRepeatString :="돌수 있을 때까지 "
            }else{
                thisTimeRepeatString :=% this.currentBattleRemainCount "번"
            }
            this.logger.log("loop: " loopString ", Count: " thisTimeRepeatString ) 
            return true
        } 
        else{
            this.appMode:=this.appRole
            this.logger.log(this.appTitle "가 [" this.appMode "] 모드로 동작합니다.")
            this.currentBattleRemainCount:=BaseballAutoPlayer.COUNT_PER_MODE[this.appMode]
        }
    }
    initPlayerMode(){
        ; if(this.appRole = "일꾼" or this.appRole = "단독"){
        this.logger.log( this.getAppTitle() " 실제 모드로 초기화 합니다.")
        this.setMode(this.appRole)
        ; }        
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
    setStandAloneModeOrder(arrayString ){
        ; MsgBox, % "called : "  this.ALONE_MODE_ARRAY
        ; targetString:="red,green,blue"
        StringSplit, tempArray,arrayString, `,
        this.ALONE_MODE_ARRAY:=[]
        loop %tempArray0%
        {
            this.ALONE_MODE_ARRAY.push(tempArray%A_Index%) 
        }

    }
    setStandAloneModeEnableMap(enableMap){
        for key in enableMap
        { 
            this.ALONE_MODE_ENABLED_MAP[key]:=enableMap[key] 
        }

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