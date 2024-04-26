#include %A_ScriptDir%\src\mode\0.DefulatGameMode.ahk

Class ReceiveRewardMode extends AutoGameMode{

    __NEW( controller )
    {
        base.__NEW("보상받기", controller)
    }

    initForThisPlayer(){
        this.receiveFriendsPoint:=false
        this.receiveDailyReward:=false
        this.receiveFruntReward:=false
    }

    initMode(){

        this.addAction(this.isMainWindow,this.selectTeamManageButtonWithDelay)
        this.addAction(this.isTeamManageWindow,this.selectFruntButtonWithDelay)
        this.addAction(this.checkFruntAdPopup)
        this.addAction(this.isFruntManageWindow,this.selectReceiveFruntMoney)
        this.addAction(this.isFruntManageWindow,this.selectOuterHelper)
        this.addAction(this.isFruntManageWindow,this.activeFront)

        this.addAction(this.isMainWindow,this.selectFriendButton)
        this.addAction(this.selectFriendsList)
        this.addAction(this.receiveAndSendFriendPoint)
        this.addAction(this.startReceiveReward)
        this.addAction(this.receiveRewardLoop)
        this.addAction(this.checkPopup)
        this.addAction(this.skipMVPWindow)
        this.addAction(this.checkAndGoHome) 
    }

    selectTeamManageButtonWithDelay(){
        if( this.checkWantToModeQuit() ){
            return 0
        }  
        if( this.clickCommonTeamManageButton() ){
            this.gameController.waitDelayForClick()
        }else{
            return 0
        }
    }

    selectFruntButtonWithDelay(){
        if( this.checkWantToModeQuit() ){
            return 0
        }
        if( this.clickCommonFruntManageButton() ){
            this.gameController.waitDelayForClick()
        }else{
            return 0
        }
    }
    checkFruntAdPopup(){
        loop ,3
        {
            if ( this.gameController.searchImageFolder("보상모드\화면_프런트_광고") ){
                this.logger.log("광고를 없애자..")
                this.goBackward()
            }else{
                return 0
            }
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
    selectFriendButton(){ 
        if( this.checkWantToModeQuit() ){
            return 0
        }
        if ( this.receiveFriendsPoint ){
            return 0
        }
        this.logger.log(this.player.getAppTitle() "우정포인트 받기를 시작합니다")
        if ( this.gameController.searchAndClickFolder("보상모드\버튼_친구") ){
            this.gameController.waitDelayForChangeWindow()
            return 1
        } 
    }

    selectFriendsList(){
        if ( this.gameController.searchImageFolder("0.기본UI\5.친구_Base") ){		
            this.continueControl()
            this.logger.log("친구 목록을 선택합니다") 
            if ( this.gameController.searchAndClickFolder("보상모드\버튼_친구목록") ){
                this.gameController.waitDelayForChangeWindow()
                return 1
            }		 
        }
        return 0		
    }
    receiveAndSendFriendPoint(){
        if ( this.gameController.searchImageFolder("보상모드\화면_친구목록") ){		
            this.continueControl()
            this.logger.log("친구 목록 화면입니다") 
            if ( this.gameController.searchAndClickFolder("보상모드\버튼_보상받고보내기") ){
                this.gameController.waitDelayForClick()
                this.logger.log("보내기 받기를 눌렀습니다.") 
                this.checkPopup()

                this.moveMainPageForNextJob()
                return 1
            }else{
                if ( this.gameController.searchImageFolder("보상모드\화면_보상없음") ){		
                    this.logger.log("받을 보상이 없는것 같습니다.") 
                    this.moveMainPageForNextJob()
                }
            }
            this.receiveFriendsPoint:=true
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
    selectPeace(counter:=0){
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
            if( this.checkWantToModeQuit() ){
                return 0
            }
            this.logger.log(this.player.getAppTitle() "도전과제로 이동합니다.")
            this.continueControl()
            if ( this.gameController.searchAndClickFolder("0.기본UI\0.메인화면_버튼_도전과제_팀별") ){
                this.gameController.waitDelayForChangeWindow()
                return 1
            }else{
                this.logger.log(this.player.getAppTitle() "도전 과제 팀별을 못찾으면 보상을 못받아..")
                this.stopControl()
            }
        }
        return 0
    }

    receiveRewardLoop(){
        if ( this.gameController.searchImageFolder("0.기본UI\4.도전과제_Base") ){			
            this.continueControl()
            this.logger.log(this.player.getAppTitle() "일일 미션처리 부터 시작합니다.")

            if ( this.gameController.searchImageFolder("보상모드\화면_일일미션") ){			
                if ( this.gameController.searchAndClickFolder("보상모드\버튼_보상받고보내기") ){
                    this.gameController.waitDelayForLoading()
                    this.logger.log("일일 보상 모두 받기를 수행합니다.") 
                    this.checkPopup()
                    return 1
                }else{
                    this.logger.log("일일 보상 없음") 
                }
                this.logger.log("주간 미션으로 이동") 
                this.gameController.searchAndClickFolder("보상모드\버튼_주간미션")
                this.gameController.waitDelayForChangeWindow()
            }
            if ( this.gameController.searchImageFolder("보상모드\화면_주간미션") ){				
                if ( this.gameController.searchAndClickFolder("보상모드\버튼_보상받고보내기") ){
                    this.gameController.waitDelayForLoading()
                    this.logger.log("주간 보상 모두 받기를 수행합니다.") 
                    this.checkPopup()
                    return 1
                } else{
                    this.logger.log("주간 보상 없음") 
                }
                this.logger.log("앰블럼으로 이동") 
                this.gameController.searchAndClickFolder("보상모드\버튼_앰블럼")
                this.gameController.waitDelayForChangeWindow()
            }
            if ( this.gameController.searchImageFolder("보상모드\화면_앰블럼") ){
                pieceCount:=0
                completeCount:=0
                loop 10{
                    ; 먼저 앰블럼 생서(5/5)
                    if ( this.gameController.searchAndClickFolder("보상모드\버튼_보상받고보내기") ){
                        this.logger.log("앰블럼 제작 - " A_INDEX) 
                        this.checkPopup()
                    }else if ( this.gameController.searchAndClickFolder("보상모드\버튼_앰블럼생성") ){ 
                        if ( this.gameController.searchImageFolder("보상모드\버튼_앰블럼생성\선택" ) ){
                            if ( this.gameController.searchAndClickFolder("보상모드\버튼_앰블럼생성\선택\0먼저") ){
                                this.logger.log("한개도 없는걸 먼저 선택")
                                if( this.gameController.searchAndClickFolder("보상모드\버튼_앰블럼생성\선택\확인") ){
                                    pieceCount++
                                    this.logger.log("앰블럼 획득 - " pieceCount)
                                }
                            }else if ( this.gameController.searchAndClickFolder("보상모드\버튼_앰블럼생성\선택\1까지") ){
                                this.logger.log("1개짜리 선택")								
                                if( this.gameController.searchAndClickFolder("보상모드\버튼_앰블럼생성\선택\확인") ){
                                    pieceCount++
                                    this.logger.log("앰블럼 획득 - " pieceCount)
                                }
                            }else if ( this.gameController.searchAndClickFolder("보상모드\버튼_앰블럼생성\선택\2이상") ){
                                this.logger.log("2 이상뿐이냐?")
                                if( this.gameController.searchAndClickFolder("보상모드\버튼_앰블럼생성\선택\확인") ){
                                    pieceCount++
                                    this.logger.log("앰블럼 획득 - " pieceCount)
                                }
                            }
                            this.checkPopup()
                        }else{
                            pieceCount++
                            this.logger.log("앰블럼 획득 - " pieceCount)
                        }
                    }else if( this.gameController.searchImageFolder("보상모드\화면_보상없음") ){
                        this.logger.log("더이상 제작 불가능") 
                        break
                    }
                } 
            }
            this.checkPopup()
            this.receiveDailyReward:=true
            this.player.addResult()
            this.moveMainPageForNextJob()
            this.stopControl()
            return 0
        }
        return 0
    }

}

