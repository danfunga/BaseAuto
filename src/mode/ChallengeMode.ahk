#include %A_ScriptDir%\src\mode\0.DefulatGameMode.ahk

Class ChallengeMode extends AutoGameMode{

    __NEW( controller )
    {
        base.__NEW("챌린지모드", controller)
    }

    initMode(){
        this.addAction(this.isMainWindow,this.commonSelectSpecialMode)
        this.addAction(this.isSpecialWindow,this.selectChallenge)
        this.addAction(this.isChallengeWindow,this.selectRound)
        this.addAction(this.isChallengeWindow,this.startChallenge)

        this.addAction(this.skipBattleHistory)
        this.addAction(this.checkPlaying)



        this.addAction(this.skipGameResultWindow)
        this.addAction(this.afterSkipMVPWindow,this.checkModeRunMore)

        this.addAction(this.skipCommonPopup)
        this.addAction(this.checkAndGoHome)     
    }

    selectChallenge(){
        this.logger.log("sellectChallenge") 
        if ( this.gameController.searchAndClickFolder("0.기본UI\3.스페셜모드_버튼_챌린지") ){
            return 1
        }else{
            this.logger.log(this.player.getAppTitle() "Challenge Button Not Found")
            return 0
        }		 
    }	

    selectRound(){
        this.logger.log("라운드에 진입합니다")
        if ( this.gameController.searchAndClickFolder("챌린지모드\버튼_라운드플레이") ){
            return 1
        }else{
            this.logger.log(this.player.getAppTitle() "RoundPlay Button Not Found")
            return 0
        }
    }

    startChallenge(){
        if( this.checkWantToModeQuit() ){
            return 0
        }
        if(this.checkChallengeClose()){ 
            return 1
        }else{
            this.logger.log("챌린지를 시작합니다") 
            if ( this.clickCommonStartButton() ){ 
                this.startingLoopLimit:=0
                this.logger.log("6초 기다립니다") 
                this.gameController.sleep(6)
                return 1
            }		 
        }
        return 0		
    }

    skipBattleHistory(){
        if ( this.gameController.searchImageFolder("챌린지모드\화면_상대전적") ){
            global baseballAutoGui
            this.logger.log("전적 화면을 넘어갑니다.")

            this.gameController.sleep(1)
            this.continueControl() 

            if ( this.clickCommonStartButton() ){
                this.logger.log("경기가 시작 됩니다. 15초 기다립니다.")
                this.gameController.sleep(15)
                return 1
            }
        }
        return 0
    }

    checkPlaying(){
        ;if ( this.gameController.searchImageFolder("챌린지모드\화면_진행중" ) ){}
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

    checkAndGoHome(){
        if ( this.gameController.searchImageFolder("챌린지모드\화면_볼없음" ) ){		 
            this.logger.log("볼이 없는거 보니 챌린지 다 돌았네요. ..")
            this.stopControl()
            return 1
        }
        return 0 
    }

}