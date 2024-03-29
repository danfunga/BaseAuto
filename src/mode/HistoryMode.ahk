﻿#include %A_ScriptDir%\src\mode\0.DefulatGameMode.ahk

Class HistoryMode extends AutoGameMode{

    ; receiveFlag:=false
    __NEW( controller ){
        base.__NEW("히스토리", controller)
    }
    initMode(){
        this.addAction(this.isMainWindow,this.commonSelectSpecialMode)
        this.addAction(this.isSpecialWindow,this.selectHistoryMode)
        this.addAction(this.isHistoryModeWindow,this.selectLastHistory)
        this.addAction(this.isHistoryModeWindow,this.startHistoryMode)
        this.addAction(this.setupAutoMode)		
        this.addAction(this.playHistoryMode)

        this.addAction(this.skipGameResultWindow)
        this.addAction(this.afterSkipMVPWindow,this.checkModeRunMore)

        this.addAction(this.checkPlaying)
        this.addAction(this.skipCommonPopup)
        this.addAction(this.checkLocalModePopup)
        this.addAction(this.checkAndGoHome) 
    }

    selectHistoryMode(){
        this.logger.log("히스토리 모드를 선택합니다.") 
        if ( this.gameController.searchAndClickFolder("0.기본UI\3.스페셜모드_버튼_히스토리모드") ){
            return 1
        }		 
    }		

    selectLastHistory(){
        if( this.checkWantToModeQuit() ){
            return 0
        }
        if ( this.gameController.searchAndClickFolder("히스토리모드\버튼_마지막") ){
            this.logger.log("가장 아래를 선택합니다.") 
            return 1
        }else{
            return 0
        }
    }

    startHistoryMode(){
        if ( this.gameController.searchImageFolder("히스토리모드\버튼_마지막\화면_마지막_선택") ){		 
            if ( this.gameController.searchAndClickFolder("1.공통\버튼_게임시작") ){ 
                this.logger.log("히스토리 모드를 시작합니다.")
                return 1
            }

        }else{
            this.logger.log("왜 선택이 제대로 안되는 거지.. 일단 멈춘다.") 
            this.stopControl()
            return 0
        }		
    }
    setupAutoMode(){

        if ( this.gameController.searchImageFolder("히스토리모드\화면_볼없음") ){
            this.gameController.searchAndClickFolder("히스토리모드\화면_볼없음\버튼_확인")
            this.logger.log("히스토리 볼을 모두 소비하였습니다.")
            this.stopControl()
            return 0 			
        }
        if ( this.gameController.searchImageFolder("히스토리모드\화면_히스토리준비") ){		
            this.continueControl()
            this.setAutoMode(true)			
        }	
    }
    playHistoryMode(){

        if ( this.gameController.searchImageFolder("히스토리모드\화면_히스토리준비") ){		
            this.continueControl()
            this.logger.log("히스토리 모드를 시작합니다") 

            if ( this.gameController.searchAndClickFolder("1.공통\버튼_게임시작") ){
                this.logger.log("10초 기다립니다") 
                this.gameController.sleep(10)
                return 1
            }		 
        }
        return 0		
    } 

    checkLocalModePopup(counter:=0){
        localCounter:=counter 
        if ( this.gameController.searchImageFolder("히스토리모드\화면_팝업체크" ) ){		
            this.logger.log("히스토리 모드 팝업 체크..") 
            if( this.gameController.searchAndClickFolder("히스토리모드\화면_팝업체크\버튼_확인" ) ){
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
        this.gameController.sleep(2) 
        return 0 
    } 

    checkModeRunMore(){
        this.player.addResult()
        if( this.checkWantToModeQuit() ){
            return 0
        }else{

            if( this.player.needToStopBattle() ){
                this.logger.log( "다 돌아 종료 하겠습니다.") 
                this.receiveFlag:=true
                this.stopControl()
            }else{
                if( this.player.getRemainBattleCount() = "무한" ){
                    this.logger.log( "히스토리 볼을 다 소비 할때까지 돕니다.") 
                }else{
                    this.logger.log( this.player.getRemainBattleCount() " 번 더 돌겠습니다.") 
                } 
                if( this.player.appRole != "단독" )
                    this.releaseControl() 
            }
            return 1
        }
    } 
}