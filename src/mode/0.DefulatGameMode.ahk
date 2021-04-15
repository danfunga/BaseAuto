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