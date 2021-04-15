#include %A_ScriptDir%\src\util\AutoLogger.ahk
Class StageMode{
    logger:= new AutoLogger( "스테이지모드" ) 
    
    __NEW( controller )
    {
        this.gameController :=controller
    }

    setPlayer( _player )
    {
        this.player:=_player
    }

    checkAndRun()
    {
        counter:=0

        counter+=this.startSpecialMode( )
        counter+=this.selectStageMode( )
        counter+=this.selectStageLevel( )
        counter+=this.startStageMode( )

        counter+=this.skipPlayerProfile( )
        counter+=this.checkPlaying( )
        counter+=this.checkGameResultWindow( )
        counter+=this.checkMVPWindow( )
        counter+=this.checkPopup( )
        counter+=this.checkStageModeClose( )

        if( counter = 0 ){
            counter+=this.moveMainPageForNextJob()
        }
        return counter
    }

    startSpecialMode(){
        if ( this.gameController.searchImageFolder("0.기본UI\0.메인화면_Base") ){
            this.logger.log(this.player.getAppTitle() "스테이지모드를 시작합니다!")
            this.player.setStay()
            if ( this.gameController.searchAndClickFolder("0.기본UI\0.메인화면_버튼_스페셜_팀별") ){
                return 1
            }
        }
        return 0
    }

    selectStageMode(){
        if ( this.gameController.searchImageFolder("0.기본UI\3.스페셜모드_Base") ){		
            this.player.setStay()
            this.logger.log("스테이지 모드를 선택합니다~") 
            if ( this.gameController.searchAndClickFolder("0.기본UI\3.스페셜모드_버튼_스테이지모드") ){
                return 1
            }		 
        }
        return 0		
    }

    selectStageLevel(){
        if ( this.gameController.searchImageFolder("0.기본UI\3-3.스테이지모드_Base") ){		
            this.player.setStay()
            this.logger.log("입장합니다") 
            if ( this.gameController.searchAndClickFolder("스테이지모드\화면_입장") ){
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
                this.player.setStay()
                this.logger.log("스테이지 모드를 시작합니다~")
                if ( this.gameController.searchAndClickFolder("1.공통\버튼_게임시작") ){ 
                    this.logger.log("고고변 받아봤자 캡틴 안나옴ㅋ")
                }
                if ( this.gameController.searchAndClickFolder("1.공통\버튼_게임시작") ){ 
                    this.logger.log("6초 기다립니다") 
                    this.gameController.sleep(6)
                    return 1
                }		 
            }
        }
        return 0		
    }

    skipPlayerProfile(){
        if ( this.gameController.searchAndClickFolder("스테이지모드\화면_투수프로필") ){		 
            this.player.setStay()
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
            this.player.setStay()
            this.logger.log("고고변을 향하여..")
            
        } 
        return 0 
    }

    checkGameResultWindow(){
        if ( this.gameController.searchImageFolder("1.공통\화면_경기_결과" ) ){		
            this.logger.log("경기 결과화면입니다..") 
            this.player.setStay()
            if( this.gameController.searchAndClickFolder("1.공통\버튼_다음_확인" ) ){ 
                return 1
            }
        }
        return 0 
    }

    checkMVPWindow(){
        if ( this.gameController.searchImageFolder("1.공통\화면_MVP" ) ){		
            this.player.setStay()
            this.logger.log("스테이지모드 종료를 확인했습니다.") 
            if( this.gameController.searchAndClickFolder("1.공통\버튼_다음_확인" ) ){
                this.player.addResult()
                if( this.player.needToStopBattle() ){
                    this.logger.log("스테이지모드를 횟수만큼 다 돌았습니다.") 
                    this.player.setBye()
                }else{
                    if( this.player.getRemainBattleCount() = "무한" ){
                        this.logger.log("스테이지 볼을 다 쓸때까지 돕니다." )
                    }else{
                        this.logger.log("스테이지 모드를 " this.player.getRemainBattleCount() "번 더 돕니다." ) 
                    }                    
                    this.player.setFree()
                }
                return 1
            }
        }
        return 0 
    } 

    checkStageModeClose(){
        if ( this.gameController.searchImageFolder("스테이지모드\화면_볼없음" ) ){		 
            this.logger.log("볼이 없는거 보니 스테이지모드 다 돌았네요. ..")
            this.player.setBye()
            return 1
        }
        return 0 
    }

    moveMainPageForNextJob(){
        if ( this.gameController.searchImageFolder("1.공통\버튼_홈으로" ) ){		
            this.logger.log("다음 임무를 위해 시작 화면으로 갑니다.") 
            if( this.gameController.searchAndClickFolder("1.공통\버튼_홈으로" ) ){
                this.logger.log("무한 루프는 안된다.") 
                return 1
            }
        }
    }


}
