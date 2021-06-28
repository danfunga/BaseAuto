#include %A_ScriptDir%\src\mode\0.DefulatGameMode.ahk

Class StageMode extends AutoGameMode{

    __NEW( controller )
    {
        base.__NEW("스테이지", controller)
    }

    initMode(){

        this.addAction(this.startSpecialMode)
        this.addAction(this.selectStageMode)
        this.addAction(this.selectStageLevel)
        this.addAction(this.startStageMode)
		this.addAction(this.playStageMode)


        this.addAction(this.skipPlayerProfile)
        this.addAction(this.checkPlaying)
        this.addAction(this.checkGameResultWindow)
        this.addAction(this.checkMVPWindow)

        this.addAction(this.checkPopup)
        this.addAction(this.checkStageModeClose)
        this.addAction(this.checkAndGoHome) 
    }

    startSpecialMode(){
        if ( this.gameController.searchImageFolder("0.기본UI\0.메인화면_Base") ){
            this.logger.log(this.player.getAppTitle() "스테이지모드를 시작합니다!")
            this.continueControl()
            if ( this.gameController.searchAndClickFolder("0.기본UI\0.메인화면_버튼_스페셜_팀별") ){
                return 1
            }
        }
        return 0
    }

    selectStageMode(){
        if ( this.gameController.searchImageFolder("0.기본UI\3.스페셜모드_Base") ){		
            this.continueControl()
            this.logger.log("스테이지 모드를 선택합니다~") 
            if ( this.gameController.searchAndClickFolder("0.기본UI\3.스페셜모드_버튼_스테이지모드") ){
                return 1
            }		 
        }
        return 0		
    }

    selectStageLevel(){
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
        if ( this.gameController.searchImageFolder("0.기본UI\3-3.스테이지모드_Base") ){		 
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
        return 0		
    }
	playStageMode(){
        if ( this.gameController.searchImageFolder("스테이지모드\화면_대전준비") ){		 
            if(this.checkStageModeClose()){
                return 1
            }else{
                this.continueControl()
                this.logger.log("스테이지 모드를 시작합니다~")
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
            this.gameController.sleep(1)
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

    checkGameResultWindow(){
        if ( this.gameController.searchImageFolder("1.공통\화면_경기_결과" ) ){		
            this.logger.log("경기 결과화면입니다..") 
            this.continueControl()
            if( this.gameController.searchAndClickFolder("1.공통\버튼_다음_확인" ) ){ 
                return 1
            }
        }
        return 0 
    }

    checkMVPWindow(){
        if ( this.gameController.searchImageFolder("1.공통\화면_MVP" ) ){		
            this.continueControl()
            this.logger.log("스테이지모드 종료를 확인했습니다.") 
            if( this.gameController.searchAndClickFolder("1.공통\버튼_다음_확인" ) ){
                this.player.addResult()
                if( this.player.needToStopBattle() ){
                    this.logger.log("스테이지모드를 횟수만큼 다 돌았습니다.") 
                    this.stopControl()
                }else{
                    if( this.player.getRemainBattleCount() = "무한" ){
                        this.logger.log("스테이지 볼을 다 쓸때까지 돕니다." )
                    }else{
                        this.logger.log("스테이지 모드를 " this.player.getRemainBattleCount() "번 더 돕니다." ) 
                    }
                    this.releaseControl()
                }
                return 1
            }
        }
        return 0 
    } 

    checkStageModeClose(){
        if ( this.gameController.searchImageFolder("스테이지모드\화면_볼없음" ) ){		 
            this.logger.log("볼이 없는거 보니 스테이지모드 다 돌았네요. ..")			
            this.stopControl()
            return 1
        }
        return 0 
    }

}
