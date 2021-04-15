; #SingleInstance, Force
; SendMode Input
; SetWorkingDir, %A_ScriptDir%

#include %A_ScriptDir%\src\util\AutoLogger.ahk

Class AutoGameMode{

    moveHomeChecker:=0
    
    __NEW( modeName, controller )
    {
        this.logger:= new AutoLogger( modeName ) 
        this.gameController :=controller
    }

    setPlayer( _player )
    {
        this.player:=_player
    }

    isMainWindow( script ){
        if ( this.gameController.searchImageFolder("0.기본UI\0.메인화면_Base") ){ 
            this.player.setStay()
            return script.Call(this)
        }
        return 0
    }
    isBattleWindow( script ){
        if ( this.gameController.searchImageFolder("0.기본UI\2.대전모드_Base") ){		
            this.player.setStay()
            return script.Call(this)
        }
        return 0		
    }	
    isGameResultWindow( script ){
        if ( this.gameController.searchImageFolder("1.공통\화면_경기_결과" ) ){	
            this.logger.log("경기 결과를 확인했습니다.") 	
            this.player.setStay()
            return script.Call(this)
        }
        return 0 
    }
    clickNextAndConfirmButton(){
        if( this.gameController.searchAndClickFolder("1.공통\버튼_다음_확인" ) ){
            return 1
        } 
    }

    checkAndGoHome( searchCounter ){
        if( searchCounter = 0 ){
            this.moveHomeChecker++
            if( this.moveHomeChecker >= 2 && this.moveHomeChecker <= 5 ){ 
                return this.moveMainPageForNextJob()
            }
        }
    }
    moveMainPageForNextJob(){
        if ( this.gameController.searchImageFolder("1.공통\버튼_홈으로" ) ){		
            this.logger.log("다음 임무를 위해 시작 화면으로 갑니다.") 
            if( this.gameController.searchAndClickFolder("1.공통\버튼_홈으로" ) ){
                this.moveHomeChecker:= 0
                return 1
            }
        }
        return 0
    } 
}