#include %A_ScriptDir%\src\util\AutoLogger.ahk
Class LeagueRunningMode{

    logger:= new AutoLogger( "리그모드" ) 
    moveHomeChecker:=0

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
        counter+=this.startLeagueInMainWindow( ) 	
        counter+=this.skippLeagueSchedule( )
        counter+=this.skippBattleHistory( )
        counter+=this.choicePlayType( )
        counter+=this.checkSpeedUp()
        counter+=this.skippPlayLineupStatus(0)		
        counter+=this.checkSpeedUp()	
        counter+=this.skippChanceStatus( )		
        counter+=this.activateAutoPlay( )				
        counter+=this.skipLevelUpOrPopUp()
        counter+=this.checkAutoPlayEnding() 
        counter+=this.checkGameResultWindow()
        counter+=this.checkMVPWindow()
        counter+=this.checkTotalLeagueEnd()

        if( counter = 0 ){
            this.moveHomeChecker++
            if( this.moveHomeChecker >= 2 && this.moveHomeChecker <= 5 ){ 
                counter+=this.moveMainPageForNextJob()
            }
        }
        return counter
    }

    startLeagueInMainWindow()
    {

        if ( this.gameController.searchImageFolder("0.기본UI\0.메인화면_Base") ){		
            if( this.player.getRole() = "단독" ){
                if( this.player.getRemainBattleCount() = 0 ){
                    this.player.setBye()
                    return 1
                }
            }
            this.logger.log(this.player.getAppTitle() " 리그를 돌겠습니다.")
            this.player.setStay()
            if ( this.gameController.searchAndClickFolder("0.기본UI\0.메인화면_버튼_리그_팀별") ){
                return 1
            }			
        }
        return 0		
    }
    skippLeagueSchedule(){
        if ( this.gameController.searchImageFolder("0.기본UI\1.리그모드_Base") ){
            this.logger.log("경기 일정 화면을 넘어갑니다.") 
            this.player.setStay()
            if ( this.gameController.searchImageFolder("리그모드\화면_도전과제_상태\초과1단계") ){
                if ( this.gameController.searchImageFolder("리그모드\화면_도전과제_상태\화면_리그경기") ){
                    this.logger.log("초과 1단계 이상을 달성했습니다.")
                    this.player.setNeedSkip(true)
                }else{
                    this.logger.log("이미 포스트 시즌입니다.")
                    this.player.setPostSeason()
                } 
            }else{
                this.player.setNeedSkip(false)
            }

            if ( this.gameController.searchImageFolder("리그모드\화면_볼없음") ){
                this.logger.log("리그 볼을 모두 소비하였습니다.")

                if( this.player.getRole() = "리그"){
                    this.player.setFree()
                }else{
                    this.player.setBye()
                    return 0 
                }
                return 1
            }

            if ( this.player.getWaitingResult() ){
                if ( this.gameController.searchImageFolder("1.공통\버튼_게임시작") ){
                    this.logger.log(this.player.getAppTitle() " 정상 종료를 요청을 확인했습니다.")
                    this.logger.log(this.player.getAppTitle() " 바이 바이.")
                    this.player.setBye()
                }else if( this.gameController.searchAndClickFolder("1.공통\버튼_이어하기") ){
                    this.logger.log("정상 요청이지만 이어하기를 수행했습니다.")
                    this.gameController.sleep(15)				
                    return 1
                }
            }else{ 
                if ( this.gameController.searchImageFolder("1.공통\버튼_게임시작") ){
                    if( this.player.getRemainBattleCount() = 0 ){
                        this.player.setBye()
                        return 0
                    }
                }
                if ( this.gameController.searchAndClickFolder("1.공통\버튼_게임시작") ){
                    return 1
                }else if( this.gameController.searchAndClickFolder("1.공통\버튼_이어하기") ){
                    this.logger.log("경기가 이어합니다. 15초 기다립니다.")
                    this.gameController.sleep(15)				
                    return 1
                }
            }		 
        }
        return 0		
    }		

    skippBattleHistory(){
        if ( this.gameController.searchImageFolder("리그모드\화면_상대전적") ){
            this.logger.log("전적 화면을 넘어갑니다.")
            this.player.setStay()
            if ( this.gameController.searchAndClickFolder("1.공통\버튼_게임시작") ){
                this.logger.log("경기가 시작 됩니다. 15초 기다립니다.")
                this.gameController.sleep(15)
                return 1
            }
        }
        return 0		
    }	
    choicePlayType(){
        if ( this.gameController.searchImageFolder("리그모드\Window_ChoicePlayType") ){
            this.player.setStay()
            if ( this.player.getBattleType() = "수비" ) {
                this.logger.log("수비 방식을 선택합니다.") 
                if ( this.gameController.searchAndClickFolder("리그모드\Window_ChoicePlayType\Button_OnlyDepence") ){
                    this.gameController.sleep(2)
                    return 1
                }
            } else if( this.player.getBattleType() = "공격" ){
                this.logger.log("공격 방식을 선택합니다.") 
                if ( this.gameController.searchAndClickFolder("리그모드\Window_ChoicePlayType\Button_OnlyOppence") ){
                    this.gameController.sleep(2)
                    return 1
                }
            }else{
                this.logger.log("전체 플레이 방식을 선택합니다.") 
                if ( this.gameController.searchAndClickFolder("리그모드\Window_ChoicePlayType\Button_FullPlay") ){
                    this.gameController.sleep(2)
                    return 1
                }
            } 
        }
        return 0		
    }

    skippPlayLineupStatus(before){
        result:=before
        if ( this.gameController.searchImageFolder("리그모드\Button_skipBeforePlay") ){
            this.logger.log(this.player.getAppTitle() " 라인업 등을 넘어갑니다.") 
            if( this.gameController.searchAndClickFolder("리그모드\Button_skipBeforePlay") = true ){				
                this.gameController.sleep(1)
                result+=1
                if( result > 4 )
                    return result
                result+=this.skippPlayLineupStatus(result)			
            }					
        } 
        return result
    }
    skippChanceStatus(){
        if ( this.gameController.searchImageFolder("1.공통\화면_찬스") ){
            this.logger.log(this.player.getAppTitle() " 찬스상황 등을 넘어갑니다.") 
            if( this.gameController.searchAndClickFolder("1.공통\화면_찬스\버튼_취소") ){
                return 1
            }			
        }		
    }
    checkTotalLeagueEnd(){
        if ( this.gameController.searchImageFolder("리그모드\화면_리그_완전종료") ){
            this.logger.log(this.player.getAppTitle() " 리그가 종료 되었습니다. 우승했길....") 
            this.player.setRealFree()
        }
        return 0				
    }

    activateAutoPlay(){
        global baseballAutoConfig
        if ( this.gameController.searchImageFolder("리그모드\화면_게임정지상태") ){

            this.gameController.sleep(2)			
            if ( this.gameController.searchImageFolder("리그모드\화면_게임정지상태") ){
                this.logger.log("자동 방식을 활성화 합니다.") 
                WinGetPos, , , winW, winH, % this.player.getAppTitle
                if( winW < 630 )
                    this.gameController.clickRatioPos(0.744, 0.114, 10)
                else
                    this.gameController.clickRatioPos(0.76, 0.097, 20)

                this.gameController.sleep(2)			
                if ( this.gameController.searchImageFolder("리그모드\화면_게임정지상태") != true ){
                    this.logger.log(this.player.getAppTitle() " 자동 게임이 시작되었습니다.") 
                    this.player.setFree()
                    return 1
                }
            }else{
                ;this.logger.log(this.player.getAppTitle() " 자동 게임이 진행 중인것으로 보입니다.") 
                this.player.setFree()
                return 1
            }

        }
        return 0		
    } 
    checkSpeedUp(before:=0){
        result:=before 
        if ( this.gameController.searchAndClickFolder("1.공통\버튼_빠르게" ) = true){
            this.logger.log("자동은 빠르게 ") 
            if ( this.gameController.searchImageFolder("1.공통\화면_자동이닝설정") ){
                this.logger.log("자동 이닝 관련 팝업이 나와 버렸습니다... 아 타이밍") 
                if ( this.gameController.searchAndClickFolder("1.공통\화면_자동이닝설정\버튼_X" ) = true){
                    if(result >3 ){
                        return result
                    }
                    result+=this.checkSpeedUp()
                }
            }		
            result++
            return result
        }
        return result		
    }
    checkAutoPlayEnding(){
        if ( this.gameController.searchImageFolder("리그모드\화면_결과_타구장" ) ){		
            this.logger.log("경기가 종료 되었습니다.") 
            if( this.gameController.searchAndClickFolder("리그모드\화면_결과_타구장" ) ){
                this.logger.log("경기 종료를 확인했습니다.") 
                this.player.addResult()
                this.player.setStay()
                if( this.player.getRole() = "단독" ){
                    if( this.player.needToStopBattle() ){
                        this.logger.log("리그를 횟수만큼 돌았습니다.") 
                    }else{
                        if( this.player.getRemainBattleCount() = "무한" ){
                            this.logger.log("볼을 모두 사용할 때까지 돕니다" )
                        }else{
                            this.logger.log("리그 " this.player.getRemainBattleCount() "번 더 돕니다." ) 
                        } 
                    }
                }

                return 1
            }			
        }else{
            if ( this.gameController.searchImageFolder("리그모드\화면_결과_플레이오프") ){ 
                this.gameController.sleep(4)			
                if ( this.gameController.searchImageFolder("리그모드\화면_결과_플레이오프") ){								
                    this.logger.log("플레이 오프 경기가 종료 된거 같습니다")
                    if( this.gameController.searchAndClickFolder("리그모드\화면_결과_플레이오프" ) ){
                        this.gameController.sleep(3)			
                        if ( this.gameController.searchImageFolder("리그모드\화면_결과_플레이오프") ){
                            this.logger.log("오류 인거 같으니 넘어가준다.") 
                            this.player.setFree()
                            return 0
                        }else{
                            this.logger.log("플레이 오프 경기가 종료 된거 같습니다")
                            this.player.addResult()
                            this.player.setStay()
                            if( this.player.getRole() = "단독" ){
                                if( this.player.needToStopBattle() ){
                                    this.logger.log("리그를 횟수만큼 돌았습니다.") 
                                }else{
                                    if( this.player.getRemainBattleCount() = "무한" ){
                                        this.logger.log("볼을 모두 사용할 때까지 돕니다" )
                                    }else{
                                        this.logger.log("리그 " this.player.getRemainBattleCount() "번 더 돕니다." ) 
                                    } 
                                }
                            } 
                            return 1
                        }				
                    }
                }
            } 
        }
        return 0
    }
    skipLevelUpOrPopUp(){
        if ( this.gameController.searchImageFolder("1.공통\화면_팝업스킵" ) ){		
            this.logger.log("레벨업이나 성장을 팝업등을 무시합니다.") 
            this.player.setStay()
            if ( this.gameController.searchAndClickFolder("1.공통\버튼_팝업스킵" ) ){
                return 1
            }
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
            this.logger.log("MVP 화면입니다.") 
            this.player.setStay()
            if( this.gameController.searchAndClickFolder("1.공통\버튼_다음_확인" ) ){ 
                this.logger.log("MVP 화면을 넘어갑니다") 
                return 1
            }
        }
        return 0 
    }	

    moveMainPageForNextJob(){
        if ( this.gameController.searchImageFolder("1.공통\버튼_홈으로" ) ){		
            this.logger.log("다음 임무를 위해 시작 화면으로 갑니다.") 
            if( this.gameController.searchAndClickFolder("1.공통\버튼_홈으로" ) ){
                this.moveHomeChecker:= 0
                this.logger.log("나도 가끔 홈으로 간다") 
                return 1
            }
        }
    }
}