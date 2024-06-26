﻿#include %A_ScriptDir%\src\mode\0.DefulatGameMode.ahk

Class LeagueUpgradeMode extends AutoGameMode{

    __NEW( controller )
    {
        base.__NEW("등반모드", controller)
    }

    initMode(){
        this.addAction(this.closeGame)
        this.addAction(this.isMainWindow, this.selectLeagueButton) 
        this.addAction(this.checkLimitInning)
        this.addAction(this.skippLeagueSchedule)
        this.addAction(this.closeGame)
        this.addAction(this.skippBattleHistory)
        this.addAction(this.choicePlayType)
        this.addAction(this.checkSpeedUp)
        this.addAction(this.closeGame)
        this.addAction(this.checkLimitInning)
        this.addAction(this.skippPlayLineupStatus)
        this.addAction(this.closeGame)
        this.addAction(this.skippChanceStatus)
        this.addAction(this.activateAutoPlay)
        this.addAction(this.closeGame)
        this.addAction(this.skipCommonPopup)
        this.addAction(this.checkLocalModePopup)
        this.addAction(this.closeGame)
        this.addAction(this.checkAutoPlayEnding)
        this.addAction(this.skipGameResultWindow)
        this.addAction(this.closeGame)
        this.addAction(this.skipMVPWindow)
        this.addAction(this.checkTotalLeagueEnd)
        this.addAction(this.closeGame)
        this.addAction(this.selectNextLeage)
        this.addAction(this.selectPostSeason)
        this.addAction(this.closeGame) 
        this.addAction(this.skipAndroidAds)
        this.addAction(this.closeGame)
        this.addAction(this.checkGameDown)
        this.addAction(this.closeGame)
        this.addAction(this.skipPopupAndAds)
        this.addAction(this.closeGame)
        this.addAction(this.checkAndGoHome) 
    }
    checkLimitInning(){
        if ( this.gameController.searchImageFolder("등반모드\화면_한계이닝\점수판") ){ 
            if ( this.gameController.searchImageFolder("등반모드\화면_한계이닝") ){ 
                if not (this.giveUpFlag){
                    this.giveUpFlag:=true
                    this.logger.log(this.player.getAppTitle() " 등반을 포기하겠습니다.")
                }
            }else{
                if(this.giveUpFlag){
                    this.giveUpFlag:=false
                    this.logger.log(this.player.getAppTitle() " 등반을 계속합니다.")
                }
            } 
        }
    }
    selectLeagueButton(){
        if ( this.gameController.searchAndClickFolder("0.기본UI\0.메인화면_버튼_리그_팀별") ){
            this.logger.log(this.player.getAppTitle() " 등반을 위해 리그를 돌겠습니다.")
            return 1
        }else{
            this.logger.log(this.player.getAppTitle() " 리그를 버튼을 찾지 못하였습니다.")
            return 0
        }			
    }

    skippLeagueSchedule(){
        if ( this.gameController.searchImageFolder("0.기본UI\1.리그모드_Base") ){

            this.logger.log("경기 일정 화면을 넘어갑니다.") 
            this.continueControl()

            if ( this.gameController.searchImageFolder("리그모드\화면_볼없음") ){
                this.logger.log("리그 볼을 모두 소비하였습니다. 10분 취침") 
                this.gameController.sleep(600)
                return 1
            }
            ; 단독 모드의 리그를 빼고 진행하자.                
            if ( this.player.getWaitingResult() ){
                if ( this.gameController.searchImageFolder("1.공통\버튼_게임시작") ){
                    this.giveUpFlag:=false
                    this.logger.log(this.player.getAppTitle() " 정상 종료를 요청을 확인했습니다.")
                    this.player.setWantToWaitResult(false)
                    this.stopControl()
                }else if( this.gameController.searchAndClickFolder("1.공통\버튼_이어하기") ){
                    this.logger.log("정상 요청이지만 이어하기를 수행했습니다.")
                    this.gameController.sleep(10)
                    return 1
                }
            }else{ 
                if ( this.gameController.searchImageFolder("1.공통\버튼_게임시작") ){
                    this.giveUpFlag:=false
                    if( this.player.getRemainBattleCount() = 0 ){
                        this.stopControl()
                        return 0
                    }
                }
                if ( this.clickCommonStartButton() ){ 
                    return 1
                }else if( this.gameController.searchAndClickFolder("1.공통\버튼_이어하기") ){
                    this.logger.log("경기가 이어합니다. 10초 기다립니다.")
                    this.gameController.sleep(10)				
                    return 1
                }
            }		 
        }
        return 0		
    }		
    closeGame(){
        if( this.autoFlag ){
            if ( this.gameController.searchImageFolder("등반모드\화면_종료플래그") ){
                if (this.giveUpFlag){
                    this.logger.log("이번 경기를 포기하고 종료 하지 않습니다. 24회인가..")
                    return 1
                }
                if( this.quitCom2usBaseball() ){
                    this.continueControl() 
                }else{
                    this.logger.log("직접 클릭한다... 젭알..")
                    this.gameController.randomClick(435, 11, 0, 10, true)

                    if ( this.gameController.searchImageFolder("등반모드\화면_종료플래그") ){ 
                        this.logger.log("설마 아직도...?")
                        if( this.quitCom2usBaseball() ){
                            this.continueControl() 
                        }
                    }
                }
            }
        }
    }
    selectNextLeage(){
        if ( this.gameController.searchImageFolder("등반모드\화면_다음시즌") ){
            this.continueControl()
            if( this.gameController.searchAndClickFolder("등반모드\화면_다음시즌\버튼_다음시즌") ){
                this.logger.log("다음 시즌을 선택합니다.")
                if( this.gameController.searchAndClickFolder("등반모드\화면_다음시즌\버튼_확인") ){
                    this.gameController.sleep(2)				
                    return 1
                }
            }else{
                if( this.gameController.searchAndClickFolder("등반모드\화면_다음시즌\버튼_기존시즌") ){
                    this.logger.log("기존 시즌이 왜 선택되어야 하나 ㅠㅠ.")
                    if( this.gameController.searchAndClickFolder("등반모드\화면_다음시즌\버튼_확인") ){
                        this.gameController.sleep(2)				
                        return 1
                    }
                }else{
                    this.logger.log("일단 멈춰 놓고... 이미지 넣자")
                    this.stopControl()
                }
            }
        }
    }
    skippBattleHistory(){
        if ( this.gameController.searchImageFolder("리그모드\화면_상대전적") ){
            this.logger.log("전적 화면을 넘어갑니다.")
            this.continueControl()

            if ( this.gameController.searchAndClickFolder("1.공통\버튼_게임시작") ){
                this.giveUpFlag:=false
                this.logger.log("경기가 시작 됩니다. 10초 기다립니다.")
                this.gameController.sleep(10)
                return 1
            }
        }
        return 0
    }	
    choicePlayType(){
        if ( this.gameController.searchImageFolder("리그모드\Window_ChoicePlayType") ){
            this.continueControl()

            this.logger.log("수비 방식을 선택합니다.") 
            if ( this.gameController.searchAndClickFolder("리그모드\Window_ChoicePlayType\Button_OnlyDepence") ){
                this.gameController.sleep(2)
                return 1
            } 
        }
        return 0		
    }

    skippPlayLineupStatus(before:=0){
        result:=before 
        if( this.gameController.searchAndClickFolder("리그모드\Button_skipBeforePlay") = true ){				
            this.logger.log(this.player.getAppTitle() " 라인업 등을 넘어갑니다.") 
            result+=1
            if( result < 4 )
                result+=this.skippPlayLineupStatus(result)	 
            return result
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
            this.continueControl()
            this.logger.log(this.player.getAppTitle() " 무조건 우승이다.") 
            if ( this.gameController.searchImageFolder("리그모드\화면_리그_완전종료") ){
                ; this.stopAndQuitConrol()
                this.sendESCUntilConfirm()
                return 1
            }
            return 0				
        }
    }
    selectPostSeason(){
        if ( this.gameController.searchImageFolder("등반모드\버튼_포스트시즌") ){
            this.continueControl()
            this.logger.log("포스트 시즌을 선택합니다.") 
            if( this.gameController.searchAndClickFolder("등반모드\버튼_포스트시즌") ){
                if( this.gameController.searchAndClickFolder("등반모드\버튼_포스트시즌\버튼_다음") ){
                    return 1
                }
                return 1
            }
        }
        return 0

    }
    sendESCUntilConfirm(){
        while( true ){
            if ( this.gameController.searchImageFolder("등반모드\화면_여기까지") ){
                break 
            }else{
                this.goBackward()
                ; this.gameController.clickESC() 
                ; this.logger.log(this.player.getAppTitle() " 뒤로가기 - ESC ") 
                ; this.gameController.clickESC() 
                ; this.gameController.sleep(1)
            }
        }
    }
    checkLocalModePopup(counter:=0){
        localCounter:=counter
        if ( this.gameController.searchImageFolder("등반모드\화면_팝업체크" ) ){
            this.logger.log("팝업 제거")
            if( this.gameController.searchAndClickFolder("등반모드\화면_팝업체크\버튼_확인" ) ){
                if( localCounter > 5 ){
                    return localCounter
                }
                localCounter++
                this.checkLocalModePopup(localCounter)
            }
        }
        return localCounter
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
                    this.releaseControl()
                    this.autoFlag:=true
                    return 1
                }
            }else{
                ;this.logger.log(this.player.getAppTitle() " 자동 게임이 진행 중인것으로 보입니다.") 
                this.releaseControl()
                this.autoFlag:=true
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
            this.autoFlag:=false
            this.logger.log("경기가 종료 되었습니다.") 
            if( this.gameController.searchAndClickFolder("리그모드\화면_결과_타구장" ) ){
                this.logger.log("경기 종료를 확인했습니다.") 
                this.player.addResult()
                this.continueControl() 
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
                this.autoFlag:=false 
                this.gameController.sleep(4)			
                if ( this.gameController.searchImageFolder("리그모드\화면_결과_플레이오프") ){								
                    this.logger.log("플레이 오프 경기가 종료 된거 같습니다")
                    if( this.gameController.searchAndClickFolder("리그모드\화면_결과_플레이오프" ) ){
                        this.gameController.sleep(3)			
                        if ( this.gameController.searchImageFolder("리그모드\화면_결과_플레이오프") ){
                            this.logger.log("오류 인거 같으니 넘어가준다.") 
                            this.releaseControl()
                            return 0
                        }else{
                            this.logger.log("플레이 오프 경기가 종료 된거 같습니다")
                            this.player.addResult()
                            this.continueControl()
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

    checkGameDown(){
        if ( this.gameController.searchImageFolder("게임실행모드\Button_GameIcon") ){
            this.continueControl()
            this.logger.log("2초후 컴프야 게임을 실행합니다.: 15초 wait ")
            this.gameController.sleep(2)
            if( this.gameController.searchAndClickFolder("게임실행모드\Button_GameIcon") ){
                this.gameController.sleep(2)
                if ( this.gameController.searchImageFolder("게임실행모드\Button_GameIcon") ){
                    this.logger.log("시작이 왜 안됐나요... ")
                    if( this.gameController.searchAndClickFolder("게임실행모드\Button_GameIcon") ){
                        this.gameController.sleep(13) 
                    }
                }else{
                    this.gameController.sleep(13) 
                } 
                return 1
            } 
        }
        return 0
    }

    skipAndroidAds(){

        if ( this.gameController.searchImageFolder("게임실행모드\Button_AdroidAds") ){
            this.continueControl() 
            this.logger.log("안드로이드 광고를 클릭합니다.") 
            if( this.gameController.searchAndClickFolder("게임실행모드\Button_AdroidAds") ){
                return 1
            } 
        }
        return 0
    }
    skipPopupAndAds(){
        result:=0
        if ( this.gameController.searchImageFolder("게임실행모드\Button_NoMoreAds") ){
            this.continueControl()
            this.logger.log("팝업 광고 등을 취소합니다..") 
            if ( this.gameController.searchAndClickFolder("게임실행모드\Button_NoMoreAds") = true ){
                result+=1
                result+=this.skipPopupAndAds()			
            }		
        }
        return result
    }

}