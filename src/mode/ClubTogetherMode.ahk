#include %A_ScriptDir%\src\mode\0.DefulatGameMode.ahk

Class ClubTogetherMode extends AutoGameMode{

    __NEW( controller )
    {
        base.__NEW("클럽협동", controller)
    }

    initMode(){
        this.addAction(this.isMainWindow,this.selectClubMode)
        this.addAction(this.isClubWindow,this.selectClubTogether)
        this.addAction(this.isClubTogetherWindow,this.startClubTogetherMode)
        this.addAction(this.checkAndSelectCaptain)
        this.addAction(this.playClubTogetherGame)

        this.addAction(this.checkPlaying)
        this.addAction(this.skipGameResultWindow)
        this.addAction(this.afterSkipMVPWindow,this.checkModeRunMore)

        this.addAction(this.skipCommonPopup)
        this.addAction(this.checkLocalModePopup)
        this.addAction(this.receiveReward)
        this.addAction(this.checkClubTogetherModeClose)
        this.addAction(this.checkAndGoHome) 
    }


    selectClubMode(){
        if ( this.gameController.searchAndClickFolder("0.기본UI\0.메인화면_버튼_클럽_팀별") ){
            this.logger.log(this.player.getAppTitle() "클럽협동전을 시작합니다")
            return 1
        }else{
            this.logger.log(this.player.getAppTitle() "클럽 버튼을 찾지 못했습니다.")
            return 0
        }
    }

    selectClubTogether(){
        if ( this.gameController.searchAndClickFolder("0.기본UI\6.클럽모드_버튼_클럽협동전") ){
            this.logger.log(this.player.getAppTitle() "클럽협동전을 선택합니다.")
            return 1
        }else{
            this.logger.log(this.player.getAppTitle() "클럽 협동 버튼을 찾지 못했습니다.")
            return 0
        }

    }

    startClubTogetherMode(){ 
        ; 종료 요청이 있는지 확인한다.
        if( this.checkWantToModeQuit() ){
            return 0
        } 

        if( this.checkClubTogetherNotReady() ){
            return 1
        }

        if( this.checkClubTogetherDone() ){
            return 1
        }

        if( this.gameController.searchImageFolder("\버튼_클럽협동전_연속경기") ){
            return this.playClubTogetherGame()
        }else{
            this.logger.log("클럽협동전 플레이화면으로 이동")
            if ( this.clickCommonStartButton() ){
                return 1
            }
        }
    }

    checkClubTogetherNotReady(){
        if ( this.gameController.searchImageFolder("클럽협동전\화면_아직_안열림" ) ){ 
            this.stopControl() 
            return true
        }
        return false 
    }

    checkAndSelectCaptain(){
        if( this.gameController.searchAndClickFolder("클럽협동전\버튼_캡틴_필요")){
            ;캡틴 선정 클릭
            this.logger.log("캡틴 선택이 필요하다.") 
            this.logger.log("1번 타자를 선택합니다.")
            ;캡틴 선택
            if ( this.gameController.searchAndClickFolder("클럽협동전\버튼_캡틴_선발타자",10,-30) ){
                this.logger.log("선택하기를 누릅니다.")
                this.gameController.searchAndClickFolder("클럽협동전\버튼_캡틴_선택하기")
                return 1
            }else{
                return 0
            }
        }else{
            this.logger.log("이미 캡틴이 선택되어 있습니다.")
            return 1
        }
    }

    checkClubTogetherDone(){ 
        if ( this.gameController.searchImageFolder("클럽협동전\화면_오늘돌았음" ) ){
            this.player.addResult()
            if( this.player.appRole == "단독" ){
                if( this.player.needToStopBattle() ){
                    this.logger.log("클럽협동전을 이미 돌았습니다. - 빠져라")
                    this.stopControl()
                    return true
                }else{
                    if( this.player.getRemainBattleCount() = "무한" ){
                        this.logger.log( "돌 수 없을 때까지 돌게 됩니다.") 
                    }else{
                        this.logger.log( this.player.getRemainBattleCount() " 번 더 돌겠습니다.") 
                    } 
                    return false
                }
            }else{
                this.logger.log("클럽협동전을 이미 돌았습니다.")
                this.stopControl() 
                return true
            } 
        }
    }

    playClubTogetherGame(){
        localCounter:=0
        if( this.gameController.searchAndClickFolder("클럽협동전\버튼_연속경기") ){
            this.logger.log("연속 경기를 돌겠습니다.")
            localCounter++
        }
        if( this.gameController.searchImageFolder("클럽협동전\화면_연속경기") ){
            this.logger.log("연속 경기 확인을 누릅니다.")
            if ( this.clickNextAndConfirmButton() ){
                localCounter++
            }
        }
        return localCounter
    }

    skipPlayerProfile(){
        if ( this.gameController.searchAndClickFolder("클럽협동전\화면_투수프로필") ){		 
            this.continueControl()
            this.logger.log("스테이지 모드 프로필 클릭 합니다~") 
            this.gameController.sleep(1)
            this.logger.log("스테이지 모드 시작 하자!!") 
            this.gameController.clickRatioPos(0.5, 0.6, 80)
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
        ; 아직 아래 없음
        if ( this.gameController.searchImageFolder("클럽협동전\화면_팝업체크" ) ){		
            this.logger.log("팝업을 제거합니다. 보상을 안받았나.") 
            if( this.gameController.searchAndClickFolder("클럽협동전\화면_팝업체크\버튼_확인" ) ){
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
        if ( this.gameController.searchImageFolder("클럽협동전\화면_진행중" ) ){		
            this.continueControl()
            this.logger.log("고고변을 향하여..")

        } 
        return 0 
    }

    checkGameResultWindow(){
        if ( this.gameController.searchImageFolder("1.공통\화면_경기_결과" ) ){		
            this.logger.log("경기 결과화면입니다..") 
            this.continueControl()
            if( this.gameController.searchAndClickFolder("1.공통\버튼_다음_확인" ) ){ 
                return 1
            }
        }
        return 0 
    }

    checkMVPWindow(){
        if ( this.gameController.searchImageFolder("1.공통\화면_MVP" ) ){		
            this.continueControl()
            this.logger.log("클럽협동전 종료를 확인했습니다.") 
            if( this.gameController.searchAndClickFolder("1.공통\버튼_다음_확인" ) ){
                this.player.addResult()
                if( this.player.needToStopBattle() ){
                    this.logger.log("클럽협동전를 횟수만큼 다 돌았습니다.") 
                    this.releaseControl()
                }else{
                    if( this.player.getRemainBattleCount() = "무한" ){
                        this.logger.log("스테이지 볼을 다 쓸때까지 돕니다." )
                    }else{
                        this.logger.log("스테이지 모드를 " this.player.getRemainBattleCount() "번 더 돕니다." ) 
                    }
                    this.releaseControl()
                }
                return 1
            }
        }
        return 0 
    } 

    checkClubTogetherModeClose(){
        if ( this.gameController.searchAndClickFolder("클럽협동전\화면_아이템획득" ) ){		 
            this.logger.log("클럽협동전 다 돌았네요...")
            this.releaseControl()
            return 1
        }
        return 0 
    }

    checkModeRunMore(){
        this.player.addResult()
        if ( this.player.getWaitingResult() ){
            this.logger.log( "종료 요청이 확인되었습니다.") 
            this.player.setWantToWaitResult(false)
            this.releaseControl() 
            return 1
        }else{

            if( this.player.needToStopBattle() ){
                this.logger.log( "다 돌아 종료 하겠습니다.") 
                this.releaseControl()
            }else{
                if( this.player.getRemainBattleCount() = "무한" ){
                    this.logger.log( "돌 수 없을 때까지 돌게 됩니다.") 
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
