#include %A_ScriptDir%\src\mode\0.DefulatGameMode.ahk

Class PennatRaceMode extends AutoGameMode{

    __NEW( controller )
    {
        base.__NEW("패 넌 트", controller)
    }

    initMode(){
        this.addAction(this.isMainWindow,this.selectBattleMode)
        this.addAction(this.isBattleWindow,this.selectPannetRaceMode) 
        this.addAction(this.isPannetRaceModeWindow,this.startPannetRaceMode) 
        this.addAction(this.playPennantRaceGame)

        this.addAction(this.skipGameResultWindow)
        this.addAction(this.afterSkipMVPWindow,this.checkModeRunMore)
        this.addAction(this.skipCommonPopup)
        this.addAction(this.checkLocalModePopup)
        this.addAction(this.isAutoModePlayingWindow, this.checkPlaying)
        this.addAction(this.checkPennantRaceClose)
        this.addAction(this.checkAndGoHome) 
        this.addAction(this.checkAndStopStartLimitCount)
    }

    selectBattleMode(){
        if ( this.clickCommonBattleButton() ){
            this.logger.log(this.player.getAppTitle() "대전을 선택합니다.")
            return 1
        }else{
            this.logger.log(this.player.getAppTitle() "대전 버튼을 찾지 못했습니다.")
            return 0
        }
    }

    selectPannetRaceMode(){
        if ( this.gameController.searchAndClickFolder("0.기본UI\2.대전모드_버튼_패넌트레이스") ){
            this.logger.log("패넌트레이스 모드를 선택합니다")
            return 1
        }else{
            this.logger.log("패넌트 레이스 버튼을 찾지 못했습니다.")
        }
    }

    startPannetRaceMode(){ 
        ; 종료 요청이 있는지 확인한다.
        if( this.checkWantToModeQuit() ){
            return 0
        } 

        if( this.checkPennantRaceDone() ){
            return 1
        }

        if( this.checkPennantRaceNotReady() ){
            return 1
        }

        if( this.gameController.searchImageFolder("패넌트레이스모드\버튼_패넌트레이스_연속경기") ){
            return this.playPennantRaceGame()
        }else{
            this.logger.log("패넌트레이스 플레이화면으로 이동")
            if ( this.clickCommonStartButton() ){
                return 1
            }
        }
    }

    checkPennantRaceDone(){ 
        if ( this.gameController.searchImageFolder("패넌트레이스모드\화면_오늘돌았음" ) ){
            this.player.addResult()
            if( this.player.appRole == "단독" ){
                if( this.player.needToStopBattle() ){
                    this.logger.log("패넌트레이스를 이미 돌았습니다. - 빠져라")
                    this.stopControl()
                    return true
                }else{
                    if( this.player.getRemainBattleCount() = "무한" ){
                        this.logger.log( "돌 수 없을 때까지 돌게 됩니다.") 
                    }else{
                        this.logger.log( this.player.getRemainBattleCount() " 번 더 돌겠습니다.") 
                    } 
                    return false
                }
            }else{
                this.logger.log("패넌트레이스를 이미 돌았습니다.")
                this.stopControl() 
                return true
            } 
        }
    }

    checkPennantRaceNotReady(){
        if ( this.gameController.searchImageFolder("패넌트레이스모드\화면_아직_안열림" ) ){ 
            this.stopControl() 
            return true
        }
        return false 
    }

    playPennantRaceGame(){
        localCounter:=0
        if( this.gameController.searchAndClickFolder("패넌트레이스모드\버튼_패넌트레이스_연속경기") ){
            this.logger.log("연속 경기를 돌겠습니다.")
            localCounter++
        }
        if( this.gameController.searchImageFolder("패넌트레이스모드\화면_연속경기") ){
            this.logger.log("연속 경기 확인을 누릅니다.")
            if ( this.clickNextAndConfirmButton() ){
                localCounter++
            }
        }
        return localCounter
    }

    checkLocalModePopup(counter:=0){
        localCounter:=counter
        if ( this.gameController.searchImageFolder("패넌트레이스모드\화면_패넌트레이스_보상" ) ){
            this.logger.log("패넌트레이스 보상을 수령합니다.")
            if( this.clickNextAndConfirmButton() ) {
                if( localCounter > 5 ) {
                    return localCounter
                }
                localCounter++
                this.checkLocalModePopup(localCounter)
            }else{
                this.logger.log("공통 확인이 없어서 ESC.")
                this.gameController.clickESC()
            }
        }
        return localCounter
    }

    checkPlaying(){
        this.continueControl()
        this.logger.log("패넌트레이스진행중..")
        this.gameController.waitDelayForLoading()
        return 1

    }

    checkPennantRaceClose(){
        if ( this.gameController.searchImageFolder("패넌트레이스모드\화면_패너트레이스_종료" ) ){
            this.logger.log("패넌트레이스 종료")
            if( this.checkLocalModePopup(0) > 0){
                return 0
            }
            this.continueControl()
            ; if( this.gameController.searchAndClickFolder("랭대모드\화면_랭대종료\버튼_확인" ) ){
            this.stopControl() 
            ; return 1
            ; }
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
                ; this.unsetEquipment()
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
