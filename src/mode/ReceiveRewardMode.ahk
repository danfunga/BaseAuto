#include %A_ScriptDir%\src\util\AutoLogger.ahk

Class ReceiveRewardMode{

    logger:= new AutoLogger( "보상받기" ) 
    closeChecker:=0

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

        counter+=this.startReceiveFriendsShip( ) 	
        counter+=this.selectFriendsList( )
        counter+=this.receiveAndSendFriendPoint()

        counter+=this.startReceiveReward( )
        counter+=this.receiveRewardLoop( )

        counter+=this.checkPopup()

        if( counter = 0 ){
            counter+=this.moveMainPageForNextJob()
        }
        ; this.logger.log("나는 보상모드 " counter)
        return counter
    }

    startReceiveFriendsShip(){
        if ( this.gameController.searchImageFolder("0.기본UI\0.메인화면_Base") ){
            this.logger.log(this.player.getAppTitle() "우정포인트 받기를 시작합니다")
            this.player.setStay()
            if ( this.gameController.searchAndClickFolder("보상모드\버튼_친구") ){
                return 1
            }
        }
        return 0
    }

    selectFriendsList(){
        if ( this.gameController.searchImageFolder("0.기본UI\5.친구_Base") ){		
            this.player.setStay()
            this.logger.log("친구 목록을 선택합니다") 
            if ( this.gameController.searchAndClickFolder("보상모드\버튼_친구목록") ){
                return 1
            }		 
        }
        return 0		
    }
    receiveAndSendFriendPoint(){
        if ( this.gameController.searchImageFolder("보상모드\화면_친구목록") ){		
            this.player.setStay()
            this.logger.log("친구 목록 화면입니다") 
            if ( this.gameController.searchAndClickFolder("보상모드\버튼_보상받고보내기") ){
                this.logger.log("보내기 받기를 눌렀습니다.") 
                this.checkPopup()
                
                this.moveMainPageForNextJob()
                this.gameController.sleep(3)
                return 1
            }else{
                if ( this.gameController.searchImageFolder("보상모드\화면_보상없음") ){		
                    this.logger.log("받을 보상이 없는것 같습니다.") 
                    this.moveMainPageForNextJob()
                    this.gameController.sleep(3)
                    
                }
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

        if ( this.gameController.searchImageFolder("보상모드\화면_팝업체크" ) ){		
            this.logger.log("OK.") 
            if( this.gameController.searchAndClickFolder("보상모드\화면_팝업체크\버튼_확인" ) ){
                if( localCounter > 5 ){
                    return localCounter
                }
                localCounter++ 
                this.checkPopup(localCounter)
            }			
        }
        return localCounter
    }

    startReceiveReward(){
        if ( this.gameController.searchImageFolder("0.기본UI\0.메인화면_Base") ){
            this.logger.log(this.player.getAppTitle() "도전과제로 이동합니다.")
            this.player.setStay()
            if ( this.gameController.searchAndClickFolder("0.기본UI\0.메인화면_버튼_도전과제_팀별") ){
                return 1
            }
        }
        return 0
    }

    receiveRewardLoop(){
        if ( this.gameController.searchImageFolder("0.기본UI\4.도전과제_Base") ){
            this.player.setStay()
            this.logger.log(this.player.getAppTitle() "일일 미션처리 부터 시작합니다.")

            if ( this.gameController.searchImageFolder("보상모드\화면_일일미션") ){
                if ( this.gameController.searchAndClickFolder("보상모드\버튼_보상받고보내기") ){
                    this.logger.log("일일 보상 모두 받기를 수행합니다.") 
                    this.checkPopup()
                    return 1
                }else{
                    this.logger.log("일일 보상 없음") 
                }
                this.logger.log("주간 미션으로 이동") 
                this.gameController.searchAndClickFolder("보상모드\버튼_주간미션")
            }
            if ( this.gameController.searchImageFolder("보상모드\화면_주간미션") ){
                if ( this.gameController.searchAndClickFolder("보상모드\버튼_보상받고보내기") ){
                    this.logger.log("주간 보상 모두 받기를 수행합니다.") 
                    this.checkPopup()
                    return 1
                } else{
                    this.logger.log("주간 보상 없음") 
                }
                this.logger.log("앰블럼으로 이동") 
                this.gameController.searchAndClickFolder("보상모드\버튼_앰블럼")
            }
            if ( this.gameController.searchImageFolder("보상모드\화면_앰블럼") ){
                loop 5 {
                    if ( this.gameController.searchAndClickFolder("보상모드\버튼_보상받고보내기") ){
                        this.logger.log("앰블럼 제작 - " A_INDEX) 
                        this.checkPopup()
                    }else{
                        if ( this.gameController.searchImageFolder("보상모드\화면_보상없음") ){
                            this.logger.log("더이상 제작 불가능")                 
                            this.moveMainPageForNextJob()
                            this.player.setBye()
                            break
                        }
                    } 
                } 

            }
            return 0
        }
        return 0
    }
    moveMainPageForNextJob(){
        if ( this.gameController.searchImageFolder("1.공통\버튼_홈으로" ) ){		
            if( this.gameController.searchAndClickFolder("1.공통\버튼_홈으로" ) ){
                this.logger.log("홈화면으로 이동") 
                return 1
            }
        }
    }
}

