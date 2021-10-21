﻿#include %A_ScriptDir%\src\mode\0.DefulatGameMode.ahk

Class HomrunRoyalMode extends AutoGameMode{

    __NEW( controller )
    {
        base.__NEW("홈런로얄", controller)
    }

    initMode(){
        this.addAction(this.isMainWindow,this.selectSpecialMode)
        this.addAction(this.isSpecialWindow,this.selectHomrunRoyal)
        this.addAction(this.isHomerunRoyalWindow,this.startHomerunRoyal)
		
		this.addAction(this.playHomerunRoyal)

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
        if ( this.gameController.searchAndClickFolder("0.기본UI\0.메인화면_버튼_스페셜_팀별") ){
            this.logger.log(this.player.getAppTitle() "홈런로얄이 위해 스페셜 버튼을 클릭합니다.")
            return 1
        }else{
            this.logger.log(this.player.getAppTitle() "스페셜 버튼을 못찾았습니다")
            return 0
        }
    }

    selectHomrunRoyal(){
        this.logger.log("홈런 로얄를 선택합니다") 
        if ( this.gameController.searchAndClickFolder("0.기본UI\3.스페셜모드_버튼_홈런로얄") ){
            return 1
        }else{
            this.logger.log(this.player.getAppTitle() "홈런로얄이 안열렸나 봅니다")		
            this.stopControl()
            return 0
        }		 
    }		

    startHomerunRoyal(){
        if( this.checkWantToModeQuit() ){
            return 0
        }
        if(this.checkHomerunDerbyClose()){ 
            return 1
        }else{
            this.logger.log("홈런 로얄를 시작합니다") 
            if ( this.gameController.searchAndClickFolder("홈런로얄모드\버튼_로비입장") ){ 
                this.logger.log("6초 기다립니다") 
                this.gameController.sleep(6)
                return 1
            }		 
        }
        return 0		
    }
	playHomerunRoyal(){
		if ( this.gameController.searchImageFolder("홈런로얄모드\화면_홈런로얄로비" ) ){		
            this.logger.log("홈런 로얄 로비입니다.") 
            if( this.gameController.searchAndClickFolder("홈런로얄모드\버튼_플레이볼" ) ){
                 this.logger.log("6초 기다립니다") 
                this.gameController.sleep(6)
				return 1
            }			
        }
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
        if ( this.player.getWaitingResult() ){
            this.logger.log( "종료 요청이 확인되었습니다.") 
            this.player.setWantToWaitResult(false)
            this.stopControl() 
            return 1
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
        if ( this.gameController.searchImageFolder("홈런로얄모드\화면_볼없음" ) ){		 
            this.logger.log("볼이 없거나 닫혔습니다.")
            this.stopControl()
            return 1
        }
        return 0 
    }

}