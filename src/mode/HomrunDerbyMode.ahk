#include %A_ScriptDir%\src\util\AutoLogger.ahk

Class HomrunDerbyMode{

    logger:= new AutoLogger( "홈런더비" ) 
    
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
        counter+=this.selectHomrunDerby( )
        counter+=this.startHomerunDerby( )
        counter+=this.skipPlayerProfile( )

        counter+=this.checkPlaying( )
        counter+=this.checkMVPWindow( )
        counter+=this.checkPopup( )
        counter+=this.checkHomerunDerbyClose( )

        if( counter = 0 ){
            counter+=this.moveMainPageForNextJob()
        }
        ; this.logger.log("나는 홈런대전" counter)
        return counter
    }

    startSpecialMode(){
        if ( this.gameController.searchImageFolder("0.기본UI\0.메인화면_Base") ){
            this.logger.log(this.player.getAppTitle() "홈런더비를 시작합니다")
            this.player.setStay()
            if ( this.gameController.searchAndClickFolder("0.기본UI\0.메인화면_버튼_스페셜_팀별") ){
                return 1
            }
        }
        return 0
    }

    selectHomrunDerby(){
        if ( this.gameController.searchImageFolder("0.기본UI\3.스페셜모드_Base") ){		
            this.player.setStay()
            this.logger.log("홈런 더비를 선택합니다") 
            if ( this.gameController.searchAndClickFolder("0.기본UI\3.스페셜모드_버튼_홈런더비") ){
                return 1
            }		 
        }
        return 0		
    }		

    startHomerunDerby(){
        if ( this.gameController.searchImageFolder("0.기본UI\3-1.홈런더비_Base") ){		 
            if(this.checkHomerunDerbyClose()){
                return 1
            }else{
                this.player.setStay()
                this.logger.log("홈런 더비를 시작합니다") 
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
        if ( this.gameController.searchAndClickFolder("홈런더비모드\화면_투수프로필") ){		 
            this.player.setStay()
            this.logger.log("홈런 더비 프로필 클릭 합니다~") 
            this.gameController.sleep(1)
            this.logger.log("홈런 더비 시작 하자!!") 
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
        if ( this.gameController.searchImageFolder("홈런더비모드\화면_팝업체크" ) ){		
            this.logger.log("팝업을 제거합니다. 보상을 안받았나.") 
            if( this.gameController.searchAndClickFolder("홈런더비모드\화면_팝업체크\버튼_확인" ) ){
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
        if ( this.gameController.searchImageFolder("홈런더비모드\화면_진행중" ) ){		
            this.player.setStay()
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

    checkMVPWindow(){
        if ( this.gameController.searchImageFolder("1.공통\화면_MVP" ) ){		
            this.player.setStay()
            this.logger.log("홈런더비 종료를 확인했습니다.") 
            if( this.gameController.searchAndClickFolder("1.공통\버튼_다음_확인" ) ){
                this.player.addResult()
                if( this.player.needToStopBattle() ){
                    this.logger.log("홈런더비를 횟수만큼 다 돌았습니다.") 
                    this.player.setBye()
                }else{
                    if( this.player.getRemainBattleCount() = "무한" ){
                        this.logger.log("홈런 볼을 다 쓸때까지 돕니다." )
                    }else{
                        this.logger.log("홈런 더비를 " this.player.getRemainBattleCount() "번 더 돕니다." ) 
                    }                    
                    this.player.setFree()
                }
                return 1
            }
        }
        return 0 
    } 

    checkHomerunDerbyClose(){
        if ( this.gameController.searchImageFolder("홈런더비모드\화면_볼없음" ) ){		 
            this.logger.log("볼이 없는거 보니 홈런더비 다 돌았네요. ..")
            this.player.setBye()
            return 1
        }
        return 0 
    }

    moveMainPageForNextJob(){
        if ( this.gameController.searchImageFolder("1.공통\버튼_홈으로" ) ){		
            this.logger.log("다음 임무를 위해 시작 화면으로 갑니다.") 
            if( this.gameController.searchAndClickFolder("1.공통\버튼_홈으로" ) ){
                this.logger.log("무한 루프는 안된다") 
                return 1
            }
        }
    }
}