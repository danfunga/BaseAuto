﻿#include %A_ScriptDir%\src\mode\0.DefulatGameMode.ahk

Class TitleHolderMode extends AutoGameMode{

    __NEW( controller )
    {
        base.__NEW("타이틀", controller)
    }

    initMode(){
        this.addAction(this.isMainWindow,this.selectSpecialMode)
        this.addAction(this.isSpecialWindow,this.selectTitleHoldMode)
        this.addAction(this.isTitleHolderModeWindow,this.checkPlayerSelected)
        this.addAction(this.isTitleHolderModeWindow,this.selectFirstMan)
        this.addAction(this.isTitleHolderModeWindow,this.enterTitleHolderMode)
        this.addAction(this.confirmTitleHoldWarnning)
        this.addAction(this.selectBatterType)
        this.addAction(this.confirmTitleHoldWarnning)
        this.addAction(this.isTitleHolderModeWindow,this.startTitleHolderMode)
        this.addAction(this.playTitleHolderMode)

        this.addAction(this.checkPlaying)
        this.addAction(this.skipGameResultWindow)
        this.addAction(this.afterSkipMVPWindow,this.checkModeRunMore)

        this.addAction(this.skipCommonPopup)
        this.addAction(this.checkTitleHodlerModeClosed)
        this.addAction(this.checkPopup) 
        this.addAction(this.checkAndGoHome) 
    }

    selectSpecialMode(){
        this.logger.log(this.player.getAppTitle() "타이틀홀드 시작합니다!")
        this.continueControl()
        if ( this.gameController.searchAndClickFolder("0.기본UI\0.메인화면_버튼_스페셜_팀별") ){
            return 1
        }
    }

    selectTitleHoldMode(){
        if( this.checkWantToModeQuit() ){
            return 0
        }
        this.continueControl()
        this.logger.log("타이틀 홀더 모드를 시작합니다.~") 
        if ( this.gameController.searchAndClickFolder("0.기본UI\3.스페셜모드_버튼_타이틀홀드모드") ){
            this.logger.log("여기는 로딩이 긴거 같아 좀 쉬었다가.") 
            this.gameController.sleep(3)
            return 1
        }		 
    }
    checkPlayerSelected(){
        if ( this.gameController.searchAndClickFolder("타이틀홀더모드\화면_플레이어없음") ){
            this.logger.log("플레이어 선택이 필요하다.") 
        }else{
            this.logger.log("이미 플레이어가 선택 된것으로 보인다.") 
            return 1
        } 
    }
    selectFirstMan(){
        this.logger.log("1번 타자를 선택합니다.") 
        if ( this.gameController.searchAndClickFolder("타이틀홀더모드\버튼_1번타자",20,-30) ){ 
            this.clickNextAndConfirmButton() 
            return 1
        }else{
            return 0
        }
    }
    enterTitleHolderMode(){
        if( this.checkWantToModeQuit() ){
            return 0
        }
        if(this.checkTitleHodlerModeClosed()){
            return 1
        }else{
            this.continueControl()
            this.logger.log("타이틀 홀드 모드에 들어갑니다~")
            if ( this.gameController.searchAndClickFolder("타이틀홀더모드\버튼_모드_입장하기") ){ 
                return 1
            } 
        }
    }

    confirmTitleHoldWarnning(){
        if ( this.gameController.searchImageFolder("타이틀홀더모드\화면_시작경고") ){		 
            this.clickNextAndConfirmButton() 
            return 1
        }
        return 0		
    }
    selectBatterType(){
        if ( this.gameController.searchImageFolder("타이틀홀더모드\화면_유형선택") ){		 
            if ( this.gameController.searchAndClickFolder("타이틀홀더모드\버튼_장타자") ){ 
                this.clickNextAndConfirmButton()
                return 1
            } 
        }
        return 0
    }

    startTitleHolderMode(){
        if( this.checkWantToModeQuit() ){
            return 0
        }
        if(this.checkTitleHodlerModeClosed()){
            return 1
        }else{
            this.continueControl()
            this.logger.log("타이틀 홀드 모드를 준비합니다~")
            return this.clickCommonStartButton() 
        }
    }

    playTitleHolderMode(){
        if ( this.gameController.searchImageFolder("타이틀홀더모드\화면_타이틀홀더모드_준비") ){		 
            if(this.checkTitleHodlerModeClosed()){
                return 1
            }else{
                this.continueControl()
                this.logger.log("타이틀 홀드 모드를 시작합니다~")

                this.setAutoMode(true)
                if ( this.clickCommonStartButton() ){ 
                    this.logger.log("시작해볼까?")
                    this.logger.log("6초 기다립니다.")
                    this.gameController.sleep(6)
                    return 1
                } 
            }
        }
        return 0		
    }

    checkPopup(counter:=0){
        localCounter:=counter
        ; 여기다 넣어 버렸다. X를 자동으로 안하려면..
        if( this.skipCommonPopup() ){
            if( localCounter > 5 ){
                return localCounter
            }
            localCounter++ 
            this.checkPopup(localCounter)
        }       
        ; 아직 아래 없음
        if ( this.gameController.searchImageFolder("타이틀홀더모드\화면_팝업체크" ) ){		
            this.logger.log("팝업을 제거합니다. 보상을 안받았나.") 
            if( this.gameController.searchAndClickFolder("타이틀홀더모드\화면_팝업체크\버튼_확인" ) ){
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
        this.gameController.sleep(2) 
        return 0 
    }     

    checkTitleHodlerModeClosed(){
        if ( this.gameController.searchImageFolder("타이틀홀더모드\화면_볼없음" ) ){		 
            this.logger.log("볼이 없는거 보니 타이틀홀더모드 다 돌았네요. ..")
            this.stopControl()
            return 1
        }
        return 0 
    }
    checkModeRunMore(){
        this.player.addResult()
        if( this.checkWantToModeQuit() ){
            return 0
        }else{
            if( this.player.needToStopBattle() ){
                this.logger.log( "다 돌아 종료 하겠습니다.") 
                this.stopControl()
            }else{
                if( this.player.getRemainBattleCount() = "무한" ){
                    this.logger.log( "돌 수 없을 때까지 돌게 됩니다.") 
                }else{
                    this.logger.log( this.player.getRemainBattleCount() " 번 더 돌겠습니다.") 
                } 
                if( this.player.appRole != "단독" )
                    this.releaseControl()
            }
            return 1
        }
    }
}