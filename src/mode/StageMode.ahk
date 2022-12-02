#include %A_ScriptDir%\src\mode\0.DefulatGameMode.ahk

Class StageMode extends AutoGameMode{

    __NEW( controller )
    {
        base.__NEW("스테이지", controller)
    }

    initMode(){
        this.addAction(this.isMainWindow,this.commonSelectSpecialMode)
        this.addAction(this.isSpecialWindow,this.selectStageMode)
        this.addAction(this.isStageWindow,this.selectStageLevel)
        this.addAction(this.isStageWindow,this.startStageMode)
        this.addAction(this.playStageMode)

        this.addAction(this.skipPlayerProfile)
        this.addAction(this.checkPlaying)
        this.addAction(this.skipGameResultWindow)
        this.addAction(this.afterSkipMVPWindow,this.checkModeRunMore)

        this.addAction(this.skipCommonPopup)
        this.addAction(this.checkStageModeClose)
        this.addAction(this.checkPopup) 
        this.addAction(this.checkAndGoHome) 
    }

    selectStageMode(){
        this.continueControl()
        this.logger.log("스테이지 모드를 선택합니다~") 
        if ( this.gameController.searchAndClickFolder("0.기본UI\3.스페셜모드_버튼_스테이지모드") ){
            return 1
        }		 
    }

    selectStageLevel(){ 
        if( this.checkWantToModeQuit() ){
            return 0
        } 
        if ( this.gameController.searchImageFolder("0.기본UI\3-3.스테이지모드_Base") ){		
            this.continueControl()
            this.logger.log("입장합니다")
            this.setStageEquips()
            if ( this.gameController.searchAndClickFolder("스테이지모드\화면_입장") ){
                return 1
            }		 
        }
        return 0	
    }

    setStageEquips(){
        global baseballAutoGui

        if(baseballAutoGui.getUseStageEquip()=1){

        } else {
            this.logger.log("장비 착용이 설정 되어 있지 않습니다.")
            this.unsetStageEquips()
        }
        return 0
    }

    unsetStageEquips(){
        if ( this.gameController.searchImageFolder("0.기본UI\3-3.스테이지모드_Base") ){
            if ( this.gameController.searchAndClickFolder("랭대모드\화면_장비착용\장비있음") ){
                this.logger.log("스테 장비를 해제합니다.")
                this.gameController.searchAndClickFolder("랭대모드\화면_장비착용\해제")
                this.gameController.searchAndClickFolder("랭대모드\화면_장비착용\장비\닫기")
                return 1
            }
        }
        return 0
    }

    startStageMode(){
        if( this.checkWantToModeQuit() ){
            return 0
        }
        if(this.checkStageModeClose()){
            return 1
        }else{
            this.continueControl()
            this.logger.log("스테이지 모드를 준비합니다~")
            if ( this.gameController.searchAndClickFolder("1.공통\버튼_게임시작") ){ 
                return 1
            } 
        }
    }
    playStageMode(){
        if( this.checkWantToModeQuit() ){
            return 0
        }
        if ( this.gameController.searchImageFolder("스테이지모드\화면_대전준비") ){		 
            if(this.checkStageModeClose()){
                return 1
            }else{
                this.continueControl()
                this.logger.log("스테이지 모드를 시작합니다~")

                this.setAutoMode(true)
                if ( this.gameController.searchAndClickFolder("1.공통\버튼_게임시작") ){ 
                    this.logger.log("고고변 받아봤자 캡틴 안나옴ㅋ")
                    this.logger.log("6초 기다립니다.")
                    this.gameController.sleep(6)
                    return 1
                } 
            }

        }
        return 0		
    }

    skipPlayerProfile(){
        if ( this.gameController.searchAndClickFolder("스테이지모드\화면_투수프로필") ){		 
            this.continueControl()
            this.logger.log("스테이지 모드 프로필 클릭 합니다~") 
            this.gameController.waitDelayForLoading()
            this.logger.log("스테이지 모드 시작 하자!!") 
            this.gameController.clickRatioPos(0.5, 0.6, 80)
        }
        return 0		
    }

    checkPopup(counter:=0){
        localCounter:=counter
        if ( this.gameController.searchImageFolder("1.공통\버튼_팝업스킵" ) ){		
            if( this.gameController.searchAndClickFolder("1.공통\버튼_팝업스킵" ) ){
                if( localCounter > 5 ){
                    return localCounter
                }
                localCounter++ 
                this.checkPopup(localCounter)
            }
        }
        ; 아직 아래 없음
        if ( this.gameController.searchImageFolder("스테이지모드\화면_팝업체크" ) ){		
            this.logger.log("팝업을 제거합니다. 보상을 안받았나.") 
            if( this.gameController.searchAndClickFolder("스테이지모드\화면_팝업체크\버튼_확인" ) ){
                if( localCounter > 5 ){
                    return localCounter
                }
                localCounter++ 
                this.checkPopup(localCounter)
            }			
        }
        return localCounter
    }

    checkPlaying(){
        if ( this.gameController.searchImageFolder("스테이지모드\화면_진행중" ) ){		
            this.continueControl()
            this.logger.log("고고변을 향하여..")
        } 
        return 0 
    }

    checkStageModeClose(){
        if ( this.gameController.searchImageFolder("스테이지모드\화면_볼없음" ) ){		 
            this.logger.log("볼이 없는거 보니 스테이지모드 다 돌았네요. ..")
            if( this.player.appRole == "단독" ){
                this.stopControl()
            }else{
                this.logger.log( "스테이지 모드는 10초간 볼 찰동안 기다립니다.") 
                this.releaseControl()
                this.gameController.sleep(10)
            } 
            return 1
        }
        return 0 
    }

    checkModeRunMore(){
        this.player.addResult()
        if( this.checkWantToModeQuit() ){
            return 0
        }else{
            if( this.player.appRole == "단독" ){
                if( this.player.needToStopBattle() ){
                    this.logger.log( "다 돌아 종료 하겠습니다.") 
                    this.stopControl()
                }else{
                    if( this.player.getRemainBattleCount() = "무한" ){
                        this.logger.log( "돌 수 없을 때까지 돌게 됩니다.") 
                    }else{
                        this.logger.log( this.player.getRemainBattleCount() " 번 더 돌겠습니다.") 
                    } 
                }
            }else{
                if( this.player.needToStopBattle() ){
                    this.logger.log( "다 돌아 종료 하겠습니다.") 
                    this.releaseControl()
                }else{
                    if( this.player.getRemainBattleCount() = "무한" ){
                        this.logger.log( "돌 수 없을 때까지 돌게 됩니다.") 
                    }else{
                        this.logger.log( this.player.getRemainBattleCount() " 번 더 돌겠습니다.") 
                    } 
                }
                this.releaseControl()
            }
            return 1
        }
    }
}
