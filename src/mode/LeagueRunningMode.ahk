﻿#include %A_ScriptDir%\src\util\AutoLogger.ahk
#include %A_ScriptDir%\src\util\MC_GameController.ahk

Class LeagueRunningMode{

    logger:= new AutoLogger( "리그모드" ) 
    modeStatus:= "START"
    __NEW( controller ){
        this.gameController :=controller
    }

    checkAndRun(){

        this.startLeagueInMainWindow() 	
        this.skippLeagueSchedule()
        this.skippBattleHistory()
        this.choicePlayType()
        this.skippPlayLineupStatus()
        this.activateAutoPlay()		
        this.checkAutoPlayEnding()
        this.skipLevelUpOrPopUp()
        this.checkGameResultWindow()
        this.checkMVPWindow()
    }
    startLeagueInMainWindow(){
        if ( this.gameController.searchImageFolder("리그모드\Window_Main") ){		
            this.logger.log("리그를 돌겠습니다.")
            ; Loop상 일단 클리만 수행한다.
            this.gameController.searchAndClickFolder("리그모드\Button_league")
            ; if( this.gameController.searchAndClickFolder("리그모드\Button_league")  ){
            ; this.skippLeagueSchedule()
            ; }
        }
    }
    skippLeagueSchedule(){
        if ( this.gameController.searchImageFolder("리그모드\화면_경기일정") ){
            this.logger.log("일정 화면을 넘어갑니다.")			
            ; Loop상 일단 클리만 수행한다.
            this.gameController.searchAndClickFolder("리그모드\Button_PlayStart")
            ; if ( this.gameController.searchAndClickFolder("리그모드\Button_PlayStart") ){
            ; this.skippBattleHistory()				
            ; }
        }
    }		
    skippBattleHistory(){
        if ( this.gameController.searchImageFolder("리그모드\화면_상대전적") ){
            this.logger.log("전적 화면을 넘어갑니다.")
            if ( this.gameController.searchAndClickFolder("리그모드\Button_PlayStart") ){
                this.logger.log("경기가 시작 됩니다. 15초 기다립니다.")
                this.gameController.sleep(15)
            }				
        }		
    }	
    choicePlayType(){
        if ( this.gameController.searchImageFolder("리그모드\Window_ChoicePlayType") ){
            this.logger.log("전체 플레이 방식을 선택합니다.") 
            this.gameController.searchAndClickFolder("리그모드\Window_ChoicePlayType\Button_FullPlay")
        }
    }

    skippPlayLineupStatus(){
        if ( this.gameController.searchImageFolder("리그모드\Button_skipBeforePlay") ){
            this.logger.log("라인업 등을 넘어갑니다.") 
            if( this.gameController.searchAndClickFolder("리그모드\Button_skipBeforePlay") = true ){
                this.skippPlayLineupStatus()			
            }		
        }
    }
    activateAutoPlay(){
        if ( this.gameController.searchImageFolder("리그모드\WIndow_GameStop") ){
            ; if ( this.gameController.searchImageFolder("리그모드\WIndow_GameStop\check_Stop") ){
            ; 자동 중 다시 자동 play를 하지 말아라...
            this.gameController.sleep(3)			
            if ( this.gameController.searchImageFolder("리그모드\WIndow_GameStop") ){
                this.logger.log("자동 방식을 활성화 합니다.") 
                this.gameController.clickRatioPos(0.76, 0.097, 20)
                this.gameController.sleep(2)			
                if ( this.gameController.searchImageFolder("리그모드\WIndow_GameStop") != true ){
                    return true
                }
            }
        }
    } 
    checkAutoPlayEnding(){
        if( this.gameController.searchImageFolder("리그모드\화면_결과_타구장" ) ){		
            this.logger.log("경기 종료를 확인했습니다.") 
            ; this.gameController.sleep(10)
            this.gameController.searchAndClickFolder("리그모드\화면_결과_타구장" ) 
        }
    }
    skipLevelUpOrPopUp(){
        if( this.gameController.searchImageFolder("리그모드\화면_결과_레벨업_성장" ) ){		
            this.logger.log("레벨업이나 성장을 무시합니다.") 
            this.gameController.searchAndClickFolder("리그모드\버튼_결과_레벨업_성장_X" ) 
        }		
    }
    checkGameResultWindow(){
        if( this.gameController.searchImageFolder("리그모드\화면_결과_경기결과" ) ){		
            this.logger.log("경기 결과를 확인했습니다.") 
            this.gameController.searchAndClickFolder("리그모드\버튼_결과_다음_확인" ) 
        }			
    }
    checkMVPWindow(){
        if( this.gameController.searchImageFolder("리그모드\화면_결과_MVP" ) ){		
            this.logger.log("MVP 를 확인했습니다.") 
            ; this.gameController.sleep(10)
            this.gameController.searchAndClickFolder("리그모드\버튼_결과_다음_확인" ) 
        }			
    }

	/*
	checkAutoPlayEnding(){
		loop 
		{
			if( this.gameController.searchImageFolder("리그모드\화면_결과_타구장" ) ){		
				; 타구장 결과
				this.logger.log("경기 종료를 확인했습니다.")        
				break	
			}else{
				this.logger.log("경기 종료를 기다립니다.")        
				this.gameController.sleep(10)
			}
			
			if( A_index > 12 ){
				this.logger.log("2분 경과 다른 상태를 체크 합니다.")        				
				return
			}
		}
		
		; if( GuiBoolScreenShotResult = true )
			; funcCaptureSubScreen( "reward" )
			; fPrintStatus("전투 완료가 확인되었습니다.")				
	}
    */
}