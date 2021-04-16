#include %A_ScriptDir%\src\mode\0.DefulatGameMode.ahk

Class FriendsBattleMode extends AutoGameMode{

    ; receiveFlag:=false
    __NEW( controller ){
        base.__NEW("친구대전", controller)
    }

    checkAndRun(){
        counter:=0

        counter+=this.isMainWindow( this.selectBattleMode )
        counter+=this.isBattleWindow( this.selectFriendsBattle ) 	

        counter+=this.isFriendsBattleWindow( this.selectTopFriends ) 	
        counter+=this.isFriendsBattleWindow( this.startFriendsBattle ) 	

        counter+=this.playFriendsBattle( ) 

        counter+=this.checkPlaying( )

        counter+=this.skipGameResultWindow()
        counter+=this.afterSkipMVPWindow(this.checkModeRunMore )

        counter+=this.skipCommonPopup( )
        counter+=this.checkLocalModePopup( )
        counter+=this.receiveReward( ) 	

        counter+=this.checkAndGoHome(counter)

        ; this.logger.log("나는 친구대전" counter)
        return counter
    }

    selectBattleMode(){
        if ( this.gameController.searchAndClickFolder("0.기본UI\0.메인화면_버튼_대전_팀별") ){
            this.logger.log(this.player.getAppTitle() "친구 대전 을 시작합니다")
            return 1
        }else{
            this.logger.log(this.player.getAppTitle() "대전 버튼을 찾지 못했습니다.")
            return 0
        }
    }

    selectFriendsBattle(){
        this.logger.log("친구 대전을 선택합니다") 
        if ( this.gameController.searchAndClickFolder("0.기본UI\2.대전모드_버튼_친구대전") ){
            return 1
        }		 
    }		

    selectTopFriends(){
        if ( this.gameController.searchAndClickFolder("친구대전\버튼_탑대상",0,30) ){
            this.logger.log("젤 위 대상을 선택합니다") 
            return 1
        }else{
            return 0
        }
    }

    startFriendsBattle(){
        if ( this.gameController.searchImageFolder("친구대전\화면_대상선택상태") ){		
            this.logger.log("친구 대전을 시작합니다") 
            if ( this.gameController.searchAndClickFolder("1.공통\버튼_게임시작") ){ 
                return 1
            }		 
        }else{
            this.logger.log("친구가 더이상 없어 시작하지 않습니다.") 
            this.player.setBye()
            return 0
        }
    }

    playFriendsBattle(){
        if ( this.gameController.searchImageFolder("친구대전\화면_친구대전준비") ){		
            this.player.setStay()
            this.logger.log("친구대전 경기를 시작합니다") 
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
        if ( this.gameController.searchImageFolder("친구대전\화면_팝업체크" ) ){		
            this.logger.log("팝업을 제거합니다. 보상을 안받았나.") 
            if( this.gameController.searchAndClickFolder("친구대전\화면_팝업체크\버튼_확인" ) ){
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
        if ( this.player.getWaitingResult() ){
            this.logger.log( "종료 요청이 확인되었습니다.") 
            this.receiveFlag:=true
            this.player.setWantToResult(false)
            this.player.setBye() 
            return 1
        }else{

            if( this.player.needToStopBattle() ){
                this.logger.log( "다 돌아 종료 하겠습니다.") 
                this.receiveFlag:=true
                this.player.setBye()
            }else{
                if( this.player.getRemainBattleCount() = "무한" ){
                    this.logger.log( "친구대전을 계속 돌겠다니.... 이건 잘못된 선택입니다.") 
                }else{
                    this.logger.log( this.player.getRemainBattleCount() " 번 더 돌겠습니다.") 
                } 
                this.player.setFree()
            }
            return 1
        }
    } 

    receiveReward(){
        ; 스타가 있을수 있을니 일단 계속 받게 하자..
        this.receiveFlag:=true
        if( this.receiveFlag ){ 
            if ( this.gameController.searchImageFolder("친구대전\버튼_모두받기" ) ){		
                this.logger.log("보상을 수령합니다.") 
                if( this.gameController.searchAndClickFolder("친구대전\버튼_모두받기" ) ){
                    this.gameController.searchAndClickFolder("친구대전\버튼_모두받기\버튼_확인" )
                    return 1
                }
            }
            this.receiveFlag:=false
        }
        return 0 
    }

}