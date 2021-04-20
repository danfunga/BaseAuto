; #SingleInstance, Force
; SendMode Input
; SetWorkingDir, %A_ScriptDir%

#include %A_ScriptDir%\src\util\AutoLogger.ahk

Class AutoGameMode{

    moveHomeChecker:=0
    returnFlag:=false

    __NEW( modeName, controller )
    {
        this.logger:= new AutoLogger( modeName ) 
        this.gameController :=controller
        this.actionList:=[]
        this.initMode()
    }
    initMode(){
    }

    setPlayer( _player )
    {
        this.player:=_player
        this.returnFlag:=false
        this.initForThisPlayer()
    }
    initForThisPlayer(){
    }
    addAction( firstMethod, secondMethod:="" ){
        if( secondMethod = ""){
            this.actionList.push( [firstMethod] )
        }else{
            this.actionList.push( [firstMethod,secondMethod] )
        }
    }
    checkAndRun()
    {
        global AUTO_RUNNING

        counter:=0
        for index, method in this.actionList
        {

            if( this.returnFlag or AUTO_RUNNING=false){
                this.logger.log("모드를 종료합니다") 
                return counter
            }

            methodLength:=method.Length()
            if( methodLength = 1 ){
                if( method[1].name = "AutoGameMode.checkAndGoHome") {
                    counter+=method[1].call(this, counter)
                }else{
                    counter+=method[1].call(this)
                } 
            }else if ( methodLength = 2 ){
                counter+=method[1].call(this, method[2])
            }
        }
        return counter 
    } 

    isMainWindow( callback ){
        if ( this.gameController.searchImageFolder("0.기본UI\0.메인화면_Base") ){ 
            this.player.setStay()
            return callback.Call(this)
        }
        return 0
    }
    isBattleWindow( callback ){
        if ( this.gameController.searchImageFolder("0.기본UI\2.대전모드_Base") ){		
            this.player.setStay()
            return callback.Call(this)
        }
        return 0		
    }	
    isSpecialWindow( callback ){
        if ( this.gameController.searchImageFolder("0.기본UI\3.스페셜모드_Base") ){		
            this.player.setStay()
            return callback.Call(this)
        }
        return 0		
    }
    isHomerunDerbyWindow( callback ){
        if ( this.gameController.searchImageFolder("0.기본UI\3-1.홈런더비_Base") ){		 
            this.player.setStay()
            return callback.Call(this)
        }
        return 0		
    }

    isRankingBattleWindow( callback ){
        if ( this.gameController.searchImageFolder("0.기본UI\2-1.랭킹대전_Base") ){
            this.player.setStay()
            return callback.Call(this)
        }
        return 0		
    }
    isFriendsBattleWindow( callback ){
        if ( this.gameController.searchImageFolder("0.기본UI\2-2.친구대전_Base") ){
            this.player.setStay()
            return callback.Call(this)
        }
        return 0		
    }

    isGameResultWindow( callback ){
        if ( this.gameController.searchImageFolder("1.공통\화면_경기_결과" ) ){	
            this.logger.log("경기 결과를 확인했습니다.") 	
            this.player.setStay()
            return callback.Call(this)
        }
        return 0 
    } 

    isMVPWindow( callback ){
        if ( this.gameController.searchImageFolder("1.공통\화면_MVP" ) ){		
            this.logger.log("MVP 를 확인했습니다.") 
            return callback.Call(this)
        }
        return 0 
    }

    skipGameResultWindow(){
        if ( this.gameController.searchImageFolder("1.공통\화면_경기_결과" ) ){		
            this.logger.log("경기 결과화면입니다..") 
            this.player.setStay()
            if( this.gameController.searchAndClickFolder("1.공통\버튼_다음_확인" ) ){ 
                return 1
            }
        }
        return 0 
    }
    skipMVPWindow(){
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

    afterSkipGameResultWindow( callback ){
        if( this.skipGameResultWindow() ){
            callback.Call(this)
            return 1
        }
        return 0
    }
    afterSkipMVPWindow( callback ){
        if( this.skipMVPWindow() ){
            callback.Call(this)
            return 1
        }
        return 0
    }
    skipCommonPopup(){
        if ( this.gameController.searchImageFolder("1.공통\화면_팝업스킵" ) ){		
            this.logger.log("레벨업이나 성장을 팝업등을 무시합니다.") 
            ; this.player.setStay()
            if ( this.gameController.searchAndClickFolder("1.공통\버튼_팝업스킵" ) ){
                return 1
            }
        }
        return 0 
    } 

    clickNextAndConfirmButton(){
        if( this.gameController.searchAndClickFolder("1.공통\버튼_다음_확인" ) ){
            return 1
        } 
    }
    checkWantToModeQuit(){
        if ( this.player.getWaitingResult() ){
            this.logger.log( "종료 요청이 확인되었습니다.") 
            this.player.setWantToWaitResult(false)
            this.player.setBye() 
            this.returnFlag:=true
            return true
        }else{
            return false
        }
    }

    checkAndGoHome( searchCounter ){ 
        if( searchCounter = 0 ){
            this.moveHomeChecker++
            if( this.moveHomeChecker >= 2 ){ 
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