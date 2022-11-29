#include %A_ScriptDir%\src\mode\0.DefulatGameMode.ahk

Class ReceiveRewardMode extends AutoGameMode{

    __NEW( controller )
    {
        base.__NEW("보상받기", controller)
    }

    initForThisPlayer(){
        this.receiveFriendsPoint:=false
        this.receiveDailyReward:=false
    }

    initMode(){
        this.addAction(this.isMainWindow,this.selectFriendButton)
        this.addAction(this.selectFriendsList)
        this.addAction(this.receiveAndSendFriendPoint)
        this.addAction(this.startReceiveReward)
        this.addAction(this.receiveRewardLoop)
        this.addAction(this.checkPopup)
        this.addAction(this.skipMVPWindow)
        this.addAction(this.checkAndGoHome) 
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
            return 1
        } 

        if ( this.gameController.searchAndClickFolder("보상모드\버튼_친구") ){
            return 1
        }else if(this.gameController.searchAndClickFolder("보상모드\버튼_커뮤니티") ){
            if ( this.gameController.searchAndClickFolder("보상모드\버튼_친구") ){
                this.gameController.sleep(2)
                return 1
            }

        }

    }

    selectFriendsList(){
        if ( this.gameController.searchImageFolder("0.기본UI\5.친구_Base") ){		
            this.continueControl()
            this.logger.log("친구 목록을 선택합니다") 
            if ( this.gameController.searchAndClickFolder("보상모드\버튼_친구목록") ){
                this.gameController.sleep(2)
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
                this.gameController.sleep(1)
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
				this.gameController.sleep(3)
                if ( this.gameController.searchAndClickFolder("보상모드\버튼_보상받고보내기") ){
                    this.logger.log("주간 보상 모두 받기를 수행합니다.") 
                    this.checkPopup()
                    return 1
                } else{
                    this.logger.log("주간 보상 없음") 
                }
                this.logger.log("앰블럼으로 이동") 
                this.gameController.searchAndClickFolder("보상모드\버튼_앰블럼")
				this.gameController.sleep(3)
            }
            if ( this.gameController.searchImageFolder("보상모드\화면_앰블럼") ){
                pieceCount:=0
                completeCount:=0
                loop 10{
                    if ( this.gameController.searchAndClickFolder("보상모드\버튼_앰블럼생성") ){ 
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
                            if ( this.gameController.searchAndClickFolder("보상모드\버튼_보상받고보내기") ){
                                completeCount++
                                this.logger.log("앰블럼 제작 - " completeCount) 
                                this.checkPopup()
                            } 
                        }else{
                            pieceCount++
                            this.logger.log("앰블럼 획득 - " pieceCount)
                        }
                    }else if( this.gameController.searchImageFolder("보상모드\화면_보상없음") ){
                        this.logger.log("더이상 제작 불가능") 
                        break
                    }else if ( this.gameController.searchAndClickFolder("보상모드\버튼_보상받고보내기") ){
                        this.logger.log("앰블럼 제작 - " A_INDEX) 
                        this.checkPopup()
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

