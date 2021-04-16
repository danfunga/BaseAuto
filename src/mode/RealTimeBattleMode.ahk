#include %A_ScriptDir%\src\mode\0.DefulatGameMode.ahk

Class RealTimeBattleMode extends AutoGameMode{

    __NEW( controller )
    {
        base.__NEW("실대모드", controller)
    }


    checkAndRun()
    {
        counter:=0
        counter+=this.startLeagueInMainWindow( ) 	
        counter+=this.selectRealTimeBattle( )
        counter+=this.startRealTImeBattle( )
        counter+=this.playStartRealTimeBattle( ) 
        counter+=this.runBunt( )
        counter+=this.runStrike( )
        counter+=this.skippBeforeGameStart( ) 
        counter+=this.skippPlayLineupStatus( )
        counter+=this.runBunt( )
        counter+=this.runStrike( )
        counter+=this.checkPopup( )
        counter+=this.checkGameResultWindow( )
        
        counter+=this.checkAndGoHome(counter)
        return counter
    }

    startLeagueInMainWindow()
    {
        if ( this.gameController.searchImageFolder("0.기본UI\0.메인화면_Base") ){		
            this.logger.log(this.player.getAppTitle() "실시간 배틀을 시작합니다")
            this.player.setStay()
            if ( this.gameController.searchAndClickFolder("0.기본UI\0.메인화면_버튼_대전_팀별") ){
                return 1
            }			
        }
        return 0		
    }
    selectRealTimeBattle(){
        if ( this.gameController.searchImageFolder("0.기본UI\2.대전모드_Base") ){		
            this.player.setStay()
            this.logger.log("실시간 대전을 선택합니다") 
            if ( this.gameController.searchAndClickFolder("0.기본UI\2.대전모드_버튼_실시간대전") ){
                return 1
            }		 
        }
        return 0		
    }		

    startRealTimeBattle(){
        if ( this.gameController.searchImageFolder("0.기본UI\2-3.실시간대전_Base") ){		
            if( this.checkWantToModeQuit() ){
                return 0
            }

            this.player.setStay()
            this.logger.log("실시간 대전을 시작합니다") 
            if ( this.gameController.searchAndClickFolder("실시간대전\버튼_실시간대전_시작") ){
                if( this.checkPopup() ){
                    return 0
                }
                this.logger.log("15초 기다립니다") 
                this.gameController.sleep(15)
                return 1
            }	
        }
        return 0		
    }

    playStartRealTimeBattle(){
        if ( this.gameController.searchImageFolder("실시간대전\버튼_경기시작") ){		
            this.player.setStay()
            this.logger.log("경기를 시작합니다") 
            if ( this.gameController.searchAndClickFolder("실시간대전\버튼_경기시작") ){
                return 1
            }		 
        }
        return 0		
    } 

    runBunt(){
        if ( this.gameController.searchAndClickFolder("실시간대전\실행_번트") ){
            this.gameController.sleep(3)
            return 1
        }
        return 0		
    }

    runStrike(count:=0){
        loopCount:=count 
        if ( this.gameController.searchAndClickFolder("실시간대전\실행_속구",0,0,false) ){
            this.gameController.sleep(0.3)
            loopCount++
            if( loopCount > 10 ){
                return loopCount
            }
            return this.runStrike(loopCount)
        }
        return loopCount
    }

    skippBeforeGameStart(){
        if ( this.gameController.searchImageFolder("실시간대전\버튼_라인업") ){
            this.player.setStay()
            this.logger.log(this.player.getAppTitle() " 라인업 클릭 -> 후 클릭 3번") 
            if( this.gameController.searchAndClickFolder("실시간대전\버튼_라인업") = true ){				
                this.gameController.sleep(1)
                loop 3
                {
                    this.gameController.clickRatioPos(0.5, 0.6, 50)
                    this.gameController.sleep(1)
                }
                return 1			 
            }

        }
        return 0 
    }

    skippPlayLineupStatus(){
        if ( this.gameController.searchImageFolder("실시간대전\버튼_스킵스킵") ){
            this.player.setStay()
            this.logger.log(this.player.getAppTitle() " - 스킵합니다") 
            if( this.gameController.searchAndClickFolder("실시간대전\버튼_스킵스킵",0,0,false) = true ){				
                return 1			 
            } 
        }
        return 0 
    }
    checkPopup(){
        if ( this.gameController.searchImageFolder("실시간대전\화면_매칭취소" ) ){		
            this.logger.log("팝업이 떴네.") 
            if( this.gameController.searchAndClickFolder("실시간대전\화면_매칭취소\버튼_확인" ) ){
                return 1
            }			
        }
        return 0

    }

    checkGameResultWindow(){
        if ( this.gameController.searchImageFolder("1.공통\화면_경기_결과" ) ){		
            this.logger.log("실시간 대전 종료를 확인했습니다.") 
            this.player.setStay()
            if( this.gameController.searchAndClickFolder("1.공통\버튼_다음_확인" ) ){

                this.player.addResult()
                if( this.player.needToStopBattle() ){
                    this.logger.log("실시간대전을 다 돌았습니다.") 
                    this.player.setBye()
                }else{
                    if( this.player.getRemainBattleCount() = "무한" ){
                        this.logger.log("계속 해서 돕니다. 이건 잘못된 선택입니다." )
                    }else{
                        this.logger.log("실시간대전을 " this.player.getRemainBattleCount() "번 더 돕니다." ) 
                    }
                    this.player.setFree()                    
                }
                return 1
            }
        }
        return 0 
    }

    skippChanceStatus(){
        if ( this.gameController.searchImageFolder("리그모드\화면_찬스상황") ){
            this.logger.log(this.player.getAppTitle() " 찬스상황 등을 넘어갑니다.") 
            if( this.gameController.searchAndClickFolder("리그모드\화면_찬스상황\Button_취소") ){
                return 1
            }			
        }		
    }    
}