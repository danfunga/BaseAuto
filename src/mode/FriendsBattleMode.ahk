﻿#include %A_ScriptDir%\src\mode\0.DefulatGameMode.ahk

Class FriendsBattleMode extends AutoGameMode{

    __NEW( controller ){
        base.__NEW("친구대전", controller)
    }

    checkAndRun(){
        counter:=0

        counter+=this.isMainWindow( this.selectBattleMode )
        counter+=this.isBattleWindow( this.selectFriendsBattle ) 	

        counter:= this.selectTopFriends( )
        counter+=this.startFriendsBattle( )
        counter+=this.playFriendsBattle( ) 

        counter+=this.checkPlaying( )

        counter+=this.isGameResultWindow( this.clickNextAndConfirmButton )
        counter+=this.checkMVPWindow( )

        counter+=this.checkPopup( ) 
        counter+=this.receiveReward( ) 	

        counter+=this.checkAndGoHome(counter)

        ; this.logger.log("나는 친구대전" counter)
        return counter
    }

    selectBattleMode(){
        this.logger.log(this.player.getAppTitle() "친구 대전 을 시작합니다")
        if ( this.gameController.searchAndClickFolder("0.기본UI\0.메인화면_버튼_대전_팀별") ){
            return 1
        }
    }
    selectFriendsBattle(){
        this.logger.log("친구 대전을 선택합니다") 
        if ( this.gameController.searchAndClickFolder("0.기본UI\2.대전모드_버튼_친구대전") ){
            return 1
        }		 
    }		

    selectTopFriends(){
        if ( this.gameController.searchImageFolder("친구대전\버튼_탑대상") ){		
            this.player.setStay()
            this.logger.log("젤 위 대상을 선택합니다") 
            if ( this.gameController.searchAndClickFolder("친구대전\버튼_탑대상",0,30) ){
                return 1
            }		 
        }
        return 0
    }

    startFriendsBattle(){
        if ( this.gameController.searchImageFolder("0.기본UI\2-2.친구대전_Base") ){		 
            if ( this.gameController.searchImageFolder("친구대전\화면_대상선택상태") ){		
                this.player.setStay()
                this.logger.log("친구 대전을 시작합니다") 
                if ( this.gameController.searchAndClickFolder("1.공통\버튼_게임시작") ){ 
                    return 1
                }		 
            }else{
                this.logger.log("친구가 없어서 시작하지 않습니다.") 
                this.player.setBye()
                return 0
            }
        }
        return 0		
    }

    playFriendsBattle(){
        if ( this.gameController.searchImageFolder("친구대전\화면_친구대전준비") ){		
            this.player.setStay()
            this.logger.log("친구대전 경기를 시작합니다") 
            if ( this.gameController.searchAndClickFolder("1.공통\버튼_게임시작") ){
                this.logger.log("5초 기다립니다") 
                this.gameController.sleep(5)
                return 1
            }		 
        }
        return 0		
    } 

    checkPopup(counter:=0){
        localCounter:=counter
        if ( this.gameController.searchImageFolder("1.공통\버튼_팝업스킵" ) ){		
            if( this.gameController.searchAndClickFolder("1.공통\버튼_팝업스킵" ) ){
                if( localCounter > 5 ){
                    return localCounter
                }
                localCounter++ 
                this.checkPopup(localCounter)
            }
        }

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


    checkMVPWindow(){
        if ( this.gameController.searchImageFolder("1.공통\화면_MVP" ) ){		
            this.logger.log("MVP 를 확인했습니다.") 
            if( this.clickNextAndConfirmButton() ){
                this.player.addResult()
                if( this.player.needToStopBattle() ){
                    this.logger.log("친구대전을 다 돌았습니다.") 
                    this.player.setBye()
                }else{
                    if( this.player.getRemainBattleCount() = "무한" ){
                        this.logger.log("친구대전을 계속 돌겠다니.... 이건 잘못된 선택입니다." )
                    }else{
                        this.logger.log("친구대전을 " this.player.getRemainBattleCount() "번 더 돕니다." ) 
                    } 
                    this.player.setFree()
                }
                return 1
            }
        }
        return 0 
    }

    receiveReward(){
        if ( this.gameController.searchImageFolder("친구대전\버튼_모두받기" ) ){		
            this.logger.log("받아라!! 보상 없어질라") 
            if( this.gameController.searchAndClickFolder("친구대전\버튼_모두받기" ) ){
                this.gameController.searchAndClickFolder("친구대전\버튼_모두받기\버튼_확인" )
                return 1
            }
        }
        return 0 
    }

}