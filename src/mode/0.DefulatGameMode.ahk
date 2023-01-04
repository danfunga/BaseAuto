; #SingleInstance, Force
; SendMode Input
; SetWorkingDir, %A_ScriptDir%

#include %A_ScriptDir%\src\util\AutoLogger.ahk

Class AutoGameMode{

    moveHomeChecker:=0
    returnFlag:=false

    __NEW( modeName, controller )
    {
        this.logger:= new AutoLogger( modeName ) 
        this.gameController :=controller
        this.actionList:=[]
        this.initMode()
    }
    initMode(){
    }

    setPlayer( _player )
    {
        this.player:=_player
        this.returnFlag:=false
        this.initForThisPlayer()
    }
    initForThisPlayer(){
    }
    addAction( firstMethod, secondMethod:="" ){
        if( secondMethod = ""){
            this.actionList.push( [firstMethod] )
        }else{
            this.actionList.push( [firstMethod,secondMethod] )
        }
        this.actionList.push( [this.defaultActionDelay] ) 
    }
    checkAndRun()
    {
        global AUTO_RUNNING

        counter:=0
        for index, method in this.actionList
        {

            if( this.returnFlag or AUTO_RUNNING=false){
                this.logger.log("모드를 종료합니다") 
                return counter
            }

            methodLength:=method.Length()
            if( methodLength = 1 ){
                if( method[1].name = "AutoGameMode.checkAndGoHome") {
                    counter+=method[1].call(this, counter)
                }else{
                    counter+=method[1].call(this)
                } 
            }else if ( methodLength = 2 ){
                counter+=method[1].call(this, method[2])
            }
        }
        return counter 
    } 
    defaultActionDelay(){
        this.gameController.waitDelayForSkip()
    }

    isMainWindow( callback ){
        if ( this.gameController.searchImageFolder("0.기본UI\0.메인화면_Base") ){ 
            this.continueControl()
            return callback.Call(this)
        }
        return 0
    }
    ;-------------------------------
    ; 대전 화면
    ;-------------------------------
    isBattleWindow( callback ){
        if ( this.gameController.searchImageFolder("0.기본UI\2.대전모드_Base") ){		
            this.continueControl()
            return callback.Call(this)
        }
        return 0		
    }
    clickCommonBattleButton(){
        return this.gameController.searchAndClickFolder("0.기본UI\0.메인화면_버튼_대전_팀별")
    }
    ;-------------------------------
    ; 대전 화면 : 1. 랭킹대전
    ;-------------------------------
    isRankingBattleWindow( callback ){
        if ( this.gameController.searchImageFolder("0.기본UI\2-1.랭킹대전_Base") ){
            this.continueControl()
            return callback.Call(this)
        }
        return 0		
    }
    ;-------------------------------
    ; 대전 화면 : 2. 친구대전
    ;-------------------------------
    isFriendsBattleWindow( callback ){
        if ( this.gameController.searchImageFolder("0.기본UI\2-2.친구대전_Base") ){
            this.continueControl()
            return callback.Call(this)
        }
        return 0		
    }
    ;-------------------------------
    ; 대전 화면 : 3. 실시간 대전
    ;-------------------------------
    isRealtimeBattleWindow( callback ){
        if ( this.gameController.searchImageFolder("0.기본UI\2-3.실시간대전_Base") ){
            this.continueControl()
            return callback.Call(this)
        }
        return 0		
    }
    ;-------------------------------
    ; 스페셜 모드 화면
    ;-------------------------------
    isSpecialWindow( callback ){
        if ( this.gameController.searchImageFolder("0.기본UI\3.스페셜모드_Base") ){		
            this.continueControl()
            return callback.Call(this)
        }
        return 0		
    }
    commonSelectSpecialMode(){
        this.logger.log(this.player.getAppTitle() "스페셜 버튼을 클릭합니다.")
        if(this.clickCommonSpecialButton()){
            this.continueControl() 
            return 1
        }else{
            this.logger.log(this.player.getAppTitle() "스페셜 버튼을 찾지 못했습니다.")
            return 0
        }
    }
    clickCommonSpecialButton(){
        return this.gameController.searchAndClickFolder("0.기본UI\0.메인화면_버튼_스페셜_팀별")
    }

    ;-------------------------------
    ; 스페셜 모드 화면 : 1. 홈런더비
    ;-------------------------------
    isHomerunDerbyWindow( callback ){
        if ( this.gameController.searchImageFolder("0.기본UI\3-1.홈런더비_Base") ){		 
            this.continueControl()
            return callback.Call(this)
        }
        return 0		
    }
    ;-------------------------------
    ; 스페셜 모드 화면 : 2. 홈런로얄
    ;-------------------------------
    isHomerunRoyalWindow( callback ){
        if ( this.gameController.searchImageFolder("0.기본UI\3-2.홈런로얄_Base") ){		 
            this.continueControl()
            return callback.Call(this)
        }
        return 0		
    }

    ;-------------------------------
    ; 스페셜 모드 화면 : 3. 스테이지
    ;-------------------------------
    isStageWindow( callback ){
        if ( this.gameController.searchImageFolder("0.기본UI\3-3.스테이지모드_Base") ){		 
            this.continueControl()
            return callback.Call(this)
        }
        return 0
    } 

    ;-------------------------------
    ; 스페셜 모드 화면 : 4. 히스토리
    ;-------------------------------
    isHistoryModeWindow( callback ){
        if ( this.gameController.searchImageFolder("0.기본UI\3-4.히스토리모드_Base") ){		 
            this.continueControl()
            return callback.Call(this)
        }
        return 0		
    }
    ;-------------------------------
    ; 스페셜 모드 화면 : 5. 타이틀홀드
    ;-------------------------------
    isTitleHolderModeWindow( callback ){
        if ( this.gameController.searchImageFolder("0.기본UI\3-5.타이틀홀더모드_Base") ){		 
            this.continueControl()
            return callback.Call(this)
        }
        return 0
    }

    isClubWindow(callback){
        if ( this.gameController.searchImageFolder("0.기본UI\6.클럽모드_Base") ){		 
            this.continueControl()
            return callback.Call(this)
        }
        return 0
    }

    isClubBattleWindow(callback){
        if ( this.gameController.searchImageFolder("0.기본UI\6-1.클럽대전_Base") ){		 
            this.continueControl()
            return callback.Call(this)
        }
        return 0
    }
    isClubTogetherWindow(callback){
        if ( this.gameController.searchImageFolder("0.기본UI\6-2.클럽협동전_Base") ){		 
            this.continueControl()
            return callback.Call(this)
        }
        return 0
    }

    clickCommonClubButton(){
        return this.gameController.searchAndClickFolder("0.기본UI\0.메인화면_버튼_클럽_팀별")
    }

    clickCommonClubBattleButton(){
        return this.gameController.searchAndClickFolder("0.기본UI\6.클럽모드_버튼_클럽대전")
    }
    clickCommonClubTogetherButton(){
        return this.gameController.searchAndClickFolder("0.기본UI\6.클럽모드_버튼_클럽협동전")
    }

    isAutoModePlayingWindow( callback){
        if( this.gameController.searchImageFolder("1.공통\화면_자동진행중" ) ){
            this.continueControl()
            return callback.Call(this)
        }
        return 0
    }

    isGameResultWindow( callback ){
        if ( this.gameController.searchImageFolder("1.공통\화면_경기_결과" ) ){	
            this.logger.log("경기 결과를 확인했습니다.") 	
            this.continueControl()
            return callback.Call(this)
        }
        return 0 
    } 

    isMVPWindow( callback ){
        if ( this.gameController.searchImageFolder("1.공통\화면_MVP" ) ){		
            this.logger.log("MVP 를 확인했습니다.") 
            return callback.Call(this)
        }
        return 0 
    }

    skipGameResultWindow(){
        if ( this.gameController.searchImageFolder("1.공통\화면_경기_결과" ) ){
            this.logger.log("경기 결과화면입니다..") 
            this.continueControl()
            if( this.gameController.searchAndClickFolder("1.공통\버튼_다음_확인" ) ){ 
                return 1
            }
        }
        return 0 
    }
    skipMVPWindow(){
        if ( this.gameController.searchImageFolder("1.공통\화면_MVP" ) ){
            this.logger.log("MVP 화면입니다.") 
            this.continueControl()
            if( this.gameController.searchAndClickFolder("1.공통\버튼_다음_확인" ) ){ 
                this.logger.log("MVP 화면을 넘어갑니다") 
                return 1
            }
        }
        return 0 
    }	

    afterSkipGameResultWindow( callback ){
        if( this.skipGameResultWindow() ){
            callback.Call(this)
            return 1
        }
        return 0
    }
    afterSkipMVPWindow( callback ){
        if( this.skipMVPWindow() ){
            callback.Call(this)
            return 1
        }
        return 0
    }
    skipCommonPopup(){
        if ( this.gameController.searchImageFolder("1.공통\화면_팝업스킵" ) ){
            this.logger.log("팝업을 무시합니다.") 
            if ( this.gameController.searchAndClickFolder("1.공통\버튼_팝업스킵" ) ){
                return 1
            }
        }
        return 0 
    } 

    clickCommonStartButton(){
        return this.gameController.searchAndClickFolder("1.공통\버튼_게임시작")
    }
    clickNextAndConfirmButton(){
        return this.gameController.searchAndClickFolder("1.공통\버튼_다음_확인" ) 
    }

    checkWantToModeQuit(){
        if ( this.player.getWaitingResult() ){
            this.logger.log( "종료 요청이 확인되었습니다.") 
            this.player.setWantToWaitResult(false)
            this.unsetEquipment()
            this.stopControl() 
            return true
        }else{
            return false
        }
    }
    unsetEquipment(){
        this.setBattleModeEquipment(false)

        ; if ( this.gameController.searchImageFolder("1.공통\화면_장비없음") ){
        ;     this.logger.log("착용 중인 장비가 없습니다.")
        ; }else if( this.gameController.searchAndClickFolder("1.공통\버튼_장비착용") ){
        ;     this.logger.log("장비를 해제 하겠습니다.")
        ;     if(this.gameController.searchImageFolder("1.공통\버튼_장비착용\화면_모두해제")){
        ;         this.logger.log("장비가 없는데 여긴 왜 들어왔을까요 - 확인하세요")
        ;     }
        ;     this.gameController.searchAndClickFolder("1.공통\버튼_장비착용\버튼_모두해제") 
        ;     this.gameController.searchAndClickFolder("1.공통\버튼_장비착용\버튼_장비닫기") 
        ; }
    }

    checkAndGoHome( searchCounter ){ 
        if( searchCounter = 0 ){
            this.moveHomeChecker++
            if( this.moveHomeChecker > 2 ){ 
                return this.moveMainPageForCheck()
            }
        }
    }
    ; 갈수 있는 곳이 없을때 홈이 갈수 있는지 보는 기능
    moveMainPageForCheck(){
        this.moveHomeChecker:= 0
        if ( this.gameController.searchImageFolder("1.공통\버튼_홈으로" ) ){
            this.logger.log("다음 임무를 위해 시작 화면으로 갑니다.") 
            if( this.gameController.searchAndClickFolder("1.공통\버튼_홈으로" ) ){
                this.gameController.waitDelayForChangeWindow()
                return 1
            }
        }
    }
    
    moveMainPageForNextJob(){
        if ( this.gameController.searchImageFolder("1.공통\버튼_홈으로" ) ){
            this.logger.log("다음 임무를 위해 시작 화면으로 갑니다.") 
            if( this.gameController.searchAndClickFolder("1.공통\버튼_홈으로" ) ){
                this.gameController.waitDelayForChangeWindow()
                return 1
            }
        }
        this.logger.log("홈 버튼을 정상적으로 찾지 못합니다.") 
        this.logger.log("무식하게 ESC를 3번 트라이 할겁니다.") 
        loop 3
        {
            if not ( this.gameController.searchImageFolder("0.기본UI\0.메인화면_Base") ){ 
                this.goBackward()
                this.gameController.waitDelayForChangeWindow()
            }else{
                return 1
            }
        }
        return 0
    } 

    stopControl(){
        this.player.setBye()
        this.returnFlag:=true
        ; 왠지 맞지 않지만 정상 동작을 위해 넣는다.
        this.gameController.waitDelayForClick() 
        this.moveMainPageForNextJob()
    }
    stopThisMode(){
        this.player.setRealFree()
        this.returnFlag:=true
        this.gameController.waitDelayForClick() 
        this.moveMainPageForNextJob()
    }
    releaseControl(){
        this.player.setFree()
    }
    continueControl(){
        this.player.setStay()
        this.autoFlag:=false
    }
    stopAndQuitConrol(){
        this.returnFlag:=true
        this.autoFlag:=false
        return this.player.setRealFree()
    }

    goBackward(){
        this.logger.log(this.player.getAppTitle() " 뒤로가기 - ESC ") 
        this.gameController.clickESC() 
    }
    quitCom2usBaseball(){
        if( this.gameController.searchAndClickFolder("1.공통\버튼_컴프야탭닫기",0,0,false,true) ){
            this.logger.log("컴프야를 강제 종료 했습니다.")
            this.releaseControl()
            return true
        } else{
            this.logger.log("ERROR: 컴프야를 종료 못하니 앱플레이어를 강제로 재시작해봅니다.")
            result:=this.restartAppPlayer()
            this.gameController.setActiveId(this.player.getAppTitle())
            return result
        }
    }
    setAutoMode( mode:=true ){
        success:=false
        ; while(success == false){
        if( mode ){
            if ( this.gameController.searchImageFolder("1.공통\모드_자동모드\버튼_자동상태") ){
                this.logger.log("자동모드 체크 ==> 자동입니다. ") 
                success:=true
            }else if ( this.gameController.searchAndClickFolder("1.공통\모드_자동모드\버튼_자동아님") ){
                this.logger.log("자동모드 체크 ==> 자동으로 변경합니다.") 
                success:=true
            }else{
                this.logger.log("자동으로 변경을 실패했습니다.") 
            }
        }else{
            if ( this.gameController.searchImageFolder("1.공통\모드_자동모드\버튼_자동아님") ){
                this.logger.log("자동모드 체크 ==> 자동이 아닙니다.") 
                success:=true
            }else if ( this.gameController.searchAndClickFolder("1.공통\모드_자동모드\버튼_자동상태") ){
                this.logger.log("자동모드 체크 ==> 자동을 끕니다.") 
                success:=true
            }else{
                this.logger.log("자동을 끄는것을 실패했습니다.") 
            }
        }
        ; }
    }

    setBattleModeEquipment( mode:=true ){
        success:=false
        if( mode ){
            if ( this.gameController.searchImageFolder("1.공통\모드_장비착용\화면_장비착용중") ){
                this.logger.log("대전장비 체크 ==> 착용 중입니다.") 
                success:=true
            }else if ( this.gameController.searchImageFolder("1.공통\모드_장비착용\화면_장비착용아님") ){ 
                this.logger.log("대전장비 체크 ==> 착용을 시작합니다.") 
                this.logger.log("장비 관리에 들어갑니다.")
                if ( this.gameController.searchAndClickFolder("1.공통\모드_장비착용\버튼_장비버튼") ){
                    if ( this.gameController.searchImageFolder("1.공통\모드_장비착용\화면_장비관리") ){
                        batter1:=false ,batter2:=false ,batter3:=false , batter4:=false ,batter5:=false 
                        pitcher1:=false ,pitcher2:=false ,pitcher3:=false , pitcher4:=false ,pitcher5:=false 
                        Loop, 6
                        {
                            if ( A_Index <= 3){
                                if( !batter1 ){
                                    if ( this.gameController.searchAndClickFolder("1.공통\모드_장비착용\화면_장비관리\장비선택\장비_타자_1") ){
                                        batter1:=true
                                        continue
                                    }
                                }
                                if( !batter2 ){
                                    if ( this.gameController.searchAndClickFolder("1.공통\모드_장비착용\화면_장비관리\장비선택\장비_타자_2") ){
                                        batter2:=true
                                        continue
                                    }
                                }
                                if( !batter3 ){
                                    if ( this.gameController.searchAndClickFolder("1.공통\모드_장비착용\화면_장비관리\장비선택\장비_타자_3") ){
                                        batter3:=true
                                        continue
                                    }
                                }
                                if( !batter4 ){
                                    if ( this.gameController.searchAndClickFolder("1.공통\모드_장비착용\화면_장비관리\장비선택\장비_타자_4") ){
                                        batter4:=true
                                        continue
                                    }
                                }
                                if( !batter5 ){
                                    if ( this.gameController.searchAndClickFolder("1.공통\모드_장비착용\화면_장비관리\장비선택\장비_타자_5") ){
                                        batter5:=true
                                        continue
                                    }
                                }
                                continue 
                            }else{
                                if( !pitcher1 ){
                                    if ( this.gameController.searchAndClickFolder("1.공통\모드_장비착용\화면_장비관리\장비선택\장비_투수_1") ){
                                        pitcher1:=true
                                        continue
                                    }
                                }
                                if( !pitcher2 ){
                                    if ( this.gameController.searchAndClickFolder("1.공통\모드_장비착용\화면_장비관리\장비선택\장비_투수_2") ){
                                        pitcher2:=true
                                        continue
                                    }
                                }
                                if( !pitcher3 ){
                                    if ( this.gameController.searchAndClickFolder("1.공통\모드_장비착용\화면_장비관리\장비선택\장비_투수_3") ){
                                        pitcher3:=true
                                        continue
                                    }
                                }
                                if( !pitcher4 ){
                                    if ( this.gameController.searchAndClickFolder("1.공통\모드_장비착용\화면_장비관리\장비선택\장비_투수_4") ){
                                        pitcher4:=true
                                        continue
                                    }
                                }
                                if( !pitcher5 ){
                                    if ( this.gameController.searchAndClickFolder("1.공통\모드_장비착용\화면_장비관리\장비선택\장비_투수_5") ){
                                        pitcher5:=true
                                        continue
                                    }
                                }
                                continue 
                            }
                        }
                        if( this.gameController.searchAndClickFolder("1.공통\모드_장비착용\화면_장비관리\버튼_닫기") ){
                            success:=true
                            this.logger.log("장비를 착용 하였습니다.") 
                        }
                    }
                }
            }
        }else{
            if ( this.gameController.searchImageFolder("1.공통\모드_장비착용\화면_장비착용중") ){
                this.logger.log("대전장비 체크 ==> 해제를 시작합니다.") 
                this.logger.log("장비 관리에 들어갑니다.")
                if ( this.gameController.searchAndClickFolder("1.공통\모드_장비착용\버튼_장비버튼") ){
                    if ( this.gameController.searchImageFolder("1.공통\모드_장비착용\화면_장비관리") ){

                        this.gameController.searchAndClickFolder("1.공통\모드_장비착용\화면_장비관리\버튼_모두해제")

                        if(this.gameController.searchImageFolder("1.공통\모드_장비착용\화면_장비관리\화면_해제상태") ){
                            if( this.gameController.searchAndClickFolder("1.공통\모드_장비착용\화면_장비관리\버튼_닫기") ){
                                success:=true
                                this.logger.log("장비를 정상적으로 해제 하였습니다.") 
                            }
                        } else{
                            if( this.gameController.searchAndClickFolder("1.공통\모드_장비착용\화면_장비관리\버튼_닫기") ){
                                this.logger.log("모두 해제 버튼이 정상적으로 안되는거 같네요") 
                            }
                        }
                    }
                }

            }else if ( this.gameController.searchImageFolder("1.공통\모드_장비착용\화면_장비착용아님") ){ 
                this.logger.log("대전장비 체크 ==> 이미 해제 상태입니다.") 
                success:=true
            } 
        }

        if( !success ){
            if( mode ){
                this.logger.log("장비 착용을 실패했습니다.") 
            }else{
                this.logger.log("장비 해제를 실패했습니다.") 
            }
        }
    }

    restartAppPlayer(){
        WinGetClass, targetClassName , % this.player.getAppTitle() 		 
        if ( InStr(targetClassName ,"LDPlayer" ) ){
            popupTitle:="ahk_class LDPlayerMsgFrame"
        }else if ( InStr(targetClassName ,"Qt5QWindowIcon" ) ){
            popupTitle:="ahk_class Qt5QWindowIcon"
        }else{
            popupTitle:="MEmu"
        }
        this.logger.log( "앱 플레이어의 강제 재기동을 수행합니다. " ) 
        this.gameController.setActiveId(this.player.getAppTitle())
        if( this.gameController.searchAndClickFolder("1.공통\버튼_앱강제종료",0,0,true,true) ){
            this.gameController.setActiveId(popupTitle)
            if ( this.gameController.searchImageFolder("1.공통\버튼_앱강제종료\화면_재시작확인") ){
                this.logger.log("재기동을 선택합니다.") 
                if( this.gameController.searchAndClickFolder("1.공통\버튼_앱강제종료\화면_재시작확인\버튼_재시작",0,0,false,true ) ){ 
                    this.logger.log( "리붓 딜레이 만큼 기다립니다.") 
                    this.gameController.waitDelayForReboot()
                    this.gameController.setActiveId(this.player.getAppTitle())
                    this.releaseControl()
                    return true
                }
            }else{
                this.logger.log("재시작이 활성화 안됩니다. 이거 설정해주세요") 
                this.gameController.setActiveId(this.player.getAppTitle())
                return false
            }
        }else{
            this.logger.log("앱플레이어의 X 버튼을 못찾습니다.") 
            this.gameController.setActiveId(this.player.getAppTitle())
            return false
        }
    }

}