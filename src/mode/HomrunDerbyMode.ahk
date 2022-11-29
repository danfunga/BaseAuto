#include %A_ScriptDir%\src\mode\0.DefulatGameMode.ahk

Class HomrunDerbyMode extends AutoGameMode{

    __NEW( controller )
    {
        base.__NEW("홈런더비", controller)
    }

    initMode(){
        this.addAction(this.isMainWindow,this.selectSpecialMode)
        this.addAction(this.isSpecialWindow,this.selectHomrunDerby)
        this.addAction(this.isHomerunDerbyWindow,this.startHomerunDerby)

        this.addAction(this.skipPlayerProfile)
        this.addAction(this.checkPlaying)
        this.addAction(this.skipGameResultWindow)
        this.addAction(this.afterSkipMVPWindow,this.checkModeRunMore)

        this.addAction(this.skipCommonPopup)
        this.addAction(this.checkLocalModePopup)
        this.addAction(this.checkHomerunDerbyClose)
        this.addAction(this.checkPopupClose) 
        this.addAction(this.checkAndGoHome) 
    }

    selectSpecialMode(){ 
        if ( this.clickCommonSpecialButton()  ){
            this.logger.log(this.player.getAppTitle() "홈런더비를 위해 스페셜 버튼을 클릭했습니다.")
            return 1
        }else{
            this.logger.log(this.player.getAppTitle() "스페셜 버튼을 못찾았습니다")
            return 0
        }
    }

    selectHomrunDerby(){
        this.logger.log("홈런 더비를 선택합니다") 
        if ( this.gameController.searchAndClickFolder("0.기본UI\3.스페셜모드_버튼_홈런더비") ){
            return 1
        }else{
            this.logger.log(this.player.getAppTitle() "홈런더비 버튼을 못찾았습니다")
            return 0
        }		 
    }		

    startHomerunDerby(){
        if( this.checkWantToModeQuit() ){
            return 0
        }
        if(this.checkHomerunDerbyClose()){ 
            return 1
        }else{
            this.logger.log("홈런 더비를 시작합니다") 
            if ( this.gameController.searchAndClickFolder("1.공통\버튼_게임시작") ){ 
                this.logger.log("6초 기다립니다") 
                this.gameController.sleep(6)
                return 1
            }		 
        }
        return 0		
    }
    skipPlayerProfile(){
        if ( this.gameController.searchAndClickFolder("홈런더비모드\화면_투수프로필") ){		 
            this.continueControl()
            this.logger.log("홈런 더비 프로필 클릭 합니다~") 
            this.gameController.sleep(1)
            this.logger.log("홈런 더비 시작 하자!!") 
            this.gameController.clickRatioPos(0.5, 0.6, 80)
        }
        return 0		
    }

    checkLocalModePopup(counter:=0){
        localCounter:=counter 
        ; 아직 아래 없음
        if ( this.gameController.searchImageFolder("홈런더비모드\화면_팝업체크" ) ){		
            this.logger.log("팝업을 제거합니다. 보상을 안받았나.") 
            if( this.gameController.searchAndClickFolder("홈런더비모드\화면_팝업체크\버튼_확인" ) ){
                if( localCounter > 5 ){
                    return localCounter
                }
                localCounter++ 
                this.checkLocalModePopup(localCounter)
            }			
        }
        return localCounter
    }
    checkPopupClose(){ 
        ; 아직 아래 없음
        if ( this.gameController.searchImageFolder("홈런더비모드\화면_종료팝업" ) ){		
            this.logger.log("그만돌아야 하는 팝업이 떴습니다.") 
            if( this.gameController.searchAndClickFolder("홈런더비모드\화면_종료팝업\버튼_확인" ) ){
                this.stopControl()
                return 1
            }			
        }
        return 0
    }

    checkPlaying(){
        if ( this.gameController.searchImageFolder("홈런더비모드\화면_진행중" ) ){		
            this.continueControl()
            this.logger.log("더비 랜덤 클릭 맞좀 봐라.") 
            Loop, 200
            {
                if ( this.gameController.searchImageFolder("홈런더비모드\화면_진행중" ) ){
                    this.gameController.clickRatioPos(0.5, 0.6, 80,false)
                    Random, msec, 380, 740
                    Sleep, %msec%
                }else{
                    this.logger.log("더비 랜덤 클릭 끝~~ 1개는 쳤을껄?") 
                    break
                }
            }
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

    checkHomerunDerbyClose(){
        if ( this.gameController.searchImageFolder("홈런더비모드\화면_볼없음" ) ){		 
            this.logger.log("볼이 없는거 보니 홈런더비 다 돌았네요. ..")
            this.stopControl()
            return 1
        }
        return 0 
    }

}