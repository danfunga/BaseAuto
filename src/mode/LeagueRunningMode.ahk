#include %A_ScriptDir%\src\mode\0.DefulatGameMode.ahk

Class LeagueRunningMode extends AutoGameMode{

    __NEW( controller )
    {
        base.__NEW("리그모드", controller)
    }
    initForThisPlayer(){
        this.frontLoopProtectCount:=0
    }
    initMode(){
        ; this.addAction(this.isMainWindow,this.selectTeamManageButtonWithDelay)
        this.addAction(this.isMainWindow,this.selectFruntButtonWithDelay)
        this.addAction(this.isFruntManageWindow,this.selectReceiveFruntMoney)
        this.addAction(this.isFruntManageWindow,this.selectOuterHelper)
        this.addAction(this.isFruntManageWindow,this.activeFront)
        this.addAction(this.isMainWindow, this.selectLeagueButton)
        this.addAction(this.skippLeagueSchedule)
        this.addAction(this.skippBattleHistory)
        this.addAction(this.choicePlayType)
        this.addAction(this.checkSpeedUp)
        this.addAction(this.skippPlayLineupStatus)
        this.addAction(this.checkSpeedUp)
        this.addAction(this.skippChanceStatus)
        this.addAction(this.activateAutoPlay)
        this.addAction(this.skipCommonPopup)
        this.addAction(this.checkAutoPlayEnding)
        this.addAction(this.skipGameResultWindow)
        this.addAction(this.skipMVPWindow)
        this.addAction(this.checkTotalLeagueEnd)
        this.addAction(this.checkAndGoHome) 
        this.addAction(this.checkAndStopStartLimitCount)
    }

    ; selectTeamManageButtonWithDelay(){
    ;     if ( this.gameController.searchImageFolder("0.기본UI\화면_프런트_대기중") ){ 
    ;         if( baseballAutoConfig.getFrontAutoActive() ){
    ;             this.logger.log("프런트 대기중이니 활성화를 합니다.") 

    ;             if( this.clickCommonTeamManageButton() ){
    ;                 this.gameController.waitDelayForClick()
    ;                 return 1
    ;             } 
    ;         } else{
    ;             this.logger.log("프런트 대기중이나 설정 OFF입니다.") 
    ;         }
    ;     }
    ;     return 0
    ; }
    selectFruntButtonWithDelay(){
        if( this.clickCommonFruntManageButton() ){
            this.gameController.waitDelayForClick()
        }else{
            return 0
        }
    }
    selectReceiveFruntMoney(){
        this.logger.log("정기 운영비를 수령합니다.")
        if ( this.gameController.searchAndClickFolder("보상모드\버튼_정기운영비수령") ){
            this.gameController.waitDelayForClick()
        }else{
            this.logger.log("시간이 안되었거나... 팝업 상태 인가요")
        }
    }
    selectOuterHelper(){
        this.logger.log("외부 자문을 선택합니다.")
        if ( this.gameController.searchAndClickFolder("보상모드\버튼_외부자문임명") ){
            this.gameController.waitDelayForClick()
            if ( this.gameController.searchAndClickFolder("보상모드\버튼_외부자문임명\버튼_선택") ){
                if ( this.gameController.searchImageFolder("보상모드\버튼_외부자문임명\버튼_선택\화면_자문선택") ){
                    if( this.clickNextAndConfirmButton() ){
                        this.gameController.waitDelayForClick()
                        this.logger.log("외부 자문을 선택했습니다.")
                    }
                }
                this.gameController.clickESC() 
            }else{
                this.logger.log("가능한 외부 자문이 없습니다.")
                this.gameController.clickESC()
            }
        }else{
            this.logger.log("이미 외부 자문이 있습니다.")
        }
    }
    activeFront(){
        global baseballAutoConfig
        if( baseballAutoConfig.getFrontAutoActive() ){
            this.logger.log("프런트를 활성화를 진행하겠습니다.")
            if ( this.gameController.searchAndClickFolder("보상모드\버튼_프론트활성화") ){
                if ( this.gameController.searchImageFolder("보상모드\버튼_프론트활성화\화면_활성화확인") ){
                    if( this.clickNextAndConfirmButton() ){
                        this.logger.log("프런트를 활성화 했습니다.")
                        this.gameController.sleep(2)
                        this.gameController.clickESC()
                    }
                }else{
                    this.logger.log("프런트 활성화 확인 화면이 안나오네요.. 고치던가 하세요")
                    this.gameController.clickESC()
                }
            }else{
                this.logger.log("프런트가 이미 활성화 되어 있거나, 운영비가 부족합니다.")
            }
        }else{
            this.logger.log("프런트 옵션이 꺼져있어 활성화 시키지 않습니다.")
        }
        this.moveMainPageForNextJob()
    }

    selectLeagueButton(){
        if( this.player.getRole() = "단독" ){
            this.logger.log(this.player.getAppTitle() " 리그 시작전 모드 종료를 체크 합니다. RemainCounter=" this.player.getRemainBattleCount())
            if( this.player.getRemainBattleCount() = 0 ){
                this.stopControl()
                return 0
            }
        }
        if ( this.gameController.searchAndClickFolder("0.기본UI\0.메인화면_버튼_리그_팀별") ){
            this.logger.log(this.player.getAppTitle() " 리그를 돌겠습니다.")
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

            if( this.gameController.searchAndClickFolder("1.공통\버튼_이어하기") ){                
                this.startingLoopLimit:=0
                this.logger.log("이어하기는 정상 종료, 리그 종료와 무관하게 수행합니다.")
                this.gameController.sleep(10)
                return 1
            }else{
                this.logger.log("이어하기가 아닙니다.")
            }

            if ( this.gameController.searchImageFolder("리그모드\화면_볼없음") ){
                this.logger.log("리그 볼을 모두 소비하였습니다.")

                if( this.player.getRole() = "리그"){
                    this.releaseControl()
                }else{
                    this.stopControl()
                    return 0 
                }
                return 1

            }

            if( this.checkWantToModeQuit() ){
                return 0
            }else{
                if( this.player.getRole() = "단독" ){
                    this.logger.log(this.player.getAppTitle() " 모드 종료를 체크 합니다. RemainCounter=" this.player.getRemainBattleCount())
                    if( this.player.getRemainBattleCount() = 0 ){
                        this.stopControl()
                        return 0
                    } 
                }
            }
            if ( this.clickCommonStartButton() ){
                this.startingLoopLimit:=0
                return 1
            }		 
        }
        return 0		
    }		

    skippBattleHistory(){
        if ( this.gameController.searchImageFolder("리그모드\화면_상대전적") ){
            global baseballAutoGui
            this.logger.log("전적 화면을 넘어갑니다.")

            this.gameController.sleep(1)
            this.continueControl() 
            if (baseballAutoGui.getUseBooster()=true) {
                this.logger.log("도전과제 부스터를 사용합니다.")
                if ( this.gameController.searchAndClickFolder("1.공통\버튼_도전과제부스터\부스터_미사용") ){
                    this.logger.log("부스터 활성 시켰습니다.") 
                }else{
                    this.logger.log("이미 도전과제 부스터가 활성화 되어 있습니다.")
                }
            } else {
                this.logger.log("도전과제 부스터를 사용하지 않습니다.")
                if ( this.gameController.searchAndClickFolder("1.공통\버튼_도전과제부스터\부스터_사용") ){
                    this.logger.log("부스터 해제 했습니다.")
                }
            }

            if ( this.clickCommonStartButton() ){
                this.logger.log("경기가 시작 됩니다. 15초 기다립니다.")
                this.gameController.sleep(15)
                return 1
            }
        }
        return 0
    }	
    choicePlayType(){
        if ( this.gameController.searchImageFolder("리그모드\Window_ChoicePlayType") ){
            this.continueControl()
            if ( this.player.getBattleType() = "수비" ) {
                this.logger.log("수비 방식을 선택합니다.") 
                if ( this.gameController.searchAndClickFolder("리그모드\Window_ChoicePlayType\Button_OnlyDepence") ){
                    return 1
                }
            } else if( this.player.getBattleType() = "공격" ){
                this.logger.log("공격 방식을 선택합니다.") 
                if ( this.gameController.searchAndClickFolder("리그모드\Window_ChoicePlayType\Button_OnlyOppence") ){
                    return 1
                }
            }else{
                this.logger.log("전체 플레이 방식을 선택합니다.") 
                if ( this.gameController.searchAndClickFolder("리그모드\Window_ChoicePlayType\Button_FullPlay") ){
                    return 1
                }
            } 
        }
        return 0		
    }

    skippPlayLineupStatus(before:=0){
        result:=before
        if( this.gameController.searchAndClickFolder("리그모드\Button_skipBeforePlay") = true ){				
            this.startingLoopLimit:=0
            this.logger.log("라인업 등을 넘어갑니다.") 
            result+=1
            if( result > 4 )
                return result
            result+=this.skippPlayLineupStatus(result)			
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
            if( this.stopAndQuitConrol() ){
                ; 종료를 원한다면 종료 시켜 준다.
                return this.quitCom2usBaseball()
            }
        }
        return 0				
    }

    activateAutoPlay(){
        global baseballAutoConfig
        if ( this.gameController.searchImageFolder("리그모드\화면_게임정지상태") ){

            this.gameController.waitDelayForLoading()
            if ( this.gameController.searchImageFolder("리그모드\화면_게임정지상태") ){
                this.logger.log("자동 방식을 활성화 합니다.") 
                WinGetPos, , , winW, winH, % this.player.getAppTitle
                ; 0.80-.0.75 변경 이상하게 카메라가 바귄다.
                this.gameController.clickRatioPos(0.75, 0.10, 20)

                this.gameController.waitDelayForLoading()
                if ( this.gameController.searchImageFolder("리그모드\화면_게임정지상태") != true ){
                    this.logger.log(this.player.getAppTitle() " 자동 게임이 시작되었습니다.") 
                    this.releaseControl()
                    return 1
                }
            }else{
                ;this.logger.log(this.player.getAppTitle() " 자동 게임이 진행 중인것으로 보입니다.") 
                this.releaseControl()
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
                this.gameController.waitDelayForLoading()			
                if ( this.gameController.searchImageFolder("리그모드\화면_결과_플레이오프") ){								
                    this.logger.log("플레이 오프 경기가 종료 된거 같습니다")
                    if( this.gameController.searchAndClickFolder("리그모드\화면_결과_플레이오프" ) ){
                        this.gameController.waitDelayForLoading()			
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

}