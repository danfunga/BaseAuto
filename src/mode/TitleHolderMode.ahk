#include %A_ScriptDir%\src\mode\0.DefulatGameMode.ahk

Class TitleHolderMode extends AutoGameMode{

    __NEW( controller )
    {
        base.__NEW("타이틀", controller)
    }

    initMode(){
        this.addAction(this.isMainWindow,this.commonSelectSpecialMode)
        this.addAction(this.isSpecialWindow,this.selectTitleHoldMode)
        this.addAction(this.isTitleHolderModeWindow,this.checkPlayerSelected)
        this.addAction(this.isTitleHolderModeWindow,this.enterTitleHolderMode)
        this.addAction(this.confirmTitleHoldWarnning)
        this.addAction(this.selectBatterType)
        this.addAction(this.confirmTitleHoldWarnning)
        this.addAction(this.isTitleHolderModeWindow,this.startTitleHolderMode)
        this.addAction(this.playTitleHolderMode)

        this.addAction(this.isAutoModePlayingWindow, this.waitPlaying)
        this.addAction(this.skipGameResultWindow)
        this.addAction(this.afterSkipMVPWindow,this.checkModeRunMore)

        this.addAction(this.skipCommonPopup)
        this.addAction(this.checkTitleHolderLeagueEnd)
        this.addAction(this.skipTitleHolderModeReward)

        this.addAction(this.checkTitleHodlerModeClosed)
        this.addAction(this.checkPopup) 
        this.addAction(this.checkAndGoHome) 
    }

    selectTitleHoldMode(){
        if( this.checkWantToModeQuit() ){
            return 0
        }
        this.continueControl()
        this.logger.log("타이틀 홀더 모드를 선택합니다") 
        if ( this.gameController.searchAndClickFolder("0.기본UI\3.스페셜모드_버튼_타이틀홀드모드") ){
            this.gameController.waitDelayForChangeWindow()
            return 1
        }		 
    }
    checkPlayerSelected(){
        if ( this.gameController.searchAndClickFolder("타이틀홀더모드\화면_플레이어없음") ){
            this.logger.log("플레이어 선택이 필요하다.") 
            this.logger.log("1번 타자를 선택합니다.") 
            if ( this.gameController.searchAndClickFolder("타이틀홀더모드\버튼_1번타자",20,-30) ){ 
                this.logger.log("확인을 누릅니다.") 
                if( !this.clickNextAndConfirmButton() ){
                    this.logger.log("왜 확인 버튼이 안되느뇨...") 
                }
                return 1
            }else{
                return 0
            }
        }else{
            this.logger.log("이미 플레이어가 선택 되어 있습니다.") 
            return 1
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
            this.logger.log("타이틀 홀드 입장하기를 선택합니다.")
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
            if ( this.gameController.searchAndClickFolder("타이틀홀더모드\버튼_교타자") ){ 
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
                this.logger.log("타이틀 홀드 모드를 플레이합니다")
                this.setAutoMode(true)
                if ( this.clickCommonStartButton() ){ 
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

    waitPlaying(){
        this.logger.log("자동 진행 중 화면으로 보입니다.")
        this.gameController.waitDelayForLoading()
        return 1 
    } 

    checkTitleHodlerModeClosed(){
        if ( this.gameController.searchImageFolder("타이틀홀더모드\화면_볼없음" ) ){		 
            this.logger.log("볼이 없거나 시작이 불가능합니다.")
            this.stopControl()
            return 1
        }
        return 0 
    }

    checkTitleHolderLeagueEnd(){
        if ( this.gameController.searchImageFolder("타이틀홀더모드\화면_리그종료") ){
            this.logger.log(this.player.getAppTitle() " 타이틀 홀더 모드 리그가 종료 되었습니다.") 
            return this.clickNextAndConfirmButton() 
        }
        return 0				
    }
    skipTitleHolderModeReward(){
        if ( this.gameController.searchImageFolder("타이틀홀더모드\화면_종료보상") ){
            this.logger.log(this.player.getAppTitle() "보상을 스킵합니다.") 
            return this.clickNextAndConfirmButton() 
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
