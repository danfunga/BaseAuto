#include %A_ScriptDir%\src\mode\0.DefulatGameMode.ahk

Class RankingBattleMode extends AutoGameMode{

    __NEW( controller )
    {
        base.__NEW("랭킹대전", controller)
    }

    initMode(){
        this.addAction(this.isMainWindow,this.selectBattleMode)
        this.addAction(this.isBattleWindow,this.selectRankingBattle) 
        this.addAction(this.isRankingBattleWindow,this.startRankingBattle)

        this.addAction(this.playRankingBattle)
        this.addAction(this.checkSlowAndChance)

        this.addAction(this.skipGameResultWindow)
        this.addAction(this.afterSkipMVPWindow,this.checkModeRunMore)

        this.addAction(this.skipCommonPopup)
        this.addAction(this.checkLocalModePopup)
        this.addAction(this.isAutoModePlayingWindow, this.checkPlaying)
        this.addAction(this.checkRankingClose)
        this.addAction(this.checkAndGoHome) 
    }

    selectBattleMode(){
        if ( this.clickCommonBattleButton() ){
            this.logger.log(this.player.getAppTitle() "랭킹 대전을 위해 대전을 선택합니다.")
            return 1
        }else{
            this.logger.log(this.player.getAppTitle() "대전 버튼을 찾지 못했습니다.")
            return 0
        }
    }

    selectRankingBattle(){
        if ( this.gameController.searchAndClickFolder("0.기본UI\2.대전모드_버튼_랭킹대전") ){
            this.logger.log("랭킹 대전을 선택합니다")
            return 1
        }else{
            this.logger.log("랭킹 대전을 찾지 못했습니다")
        }
    } 
    startRankingBattle(){ 
        if( this.checkWantToModeQuit() ){
            return 0
        } 
        if ( this.gameController.searchImageFolder("랭대모드\화면_볼없음" ) ){
            this.logger.log("볼이 없군요")
            this.unsetEquipment()
            this.stopControl() 
            return 1
        }

        ; if ( this.gameController.searchImageFolder("랭대모드\화면_상대있음") ){
            this.checkAndSetBattleEquips()

            this.logger.log("랭킹 대전 준비 화면으로 넘어갑니다.")
            if ( this.clickCommonStartButton() ){
                return 1
            }
        ; }
    }
    checkAndSetBattleEquips(){
        global baseballAutoConfig
        if( baseballAutoConfig.usingRankingBattleEquipment() ){
            this.logger.log("랭킹 대전 장비를 사용합니다.")
            this.setBattleModeEquipment(true)
        }else{
            this.logger.log("랭킹 대전 장비를 사용하지 않습니다.")
            this.setBattleModeEquipment(false)
        }        
    }   

    ransleep(min, max)
    {
        Random, rand, min, max
        sleep, rand
    }

    playRankingBattle(){
        if ( this.gameController.searchImageFolder("랭대모드\화면_랭킹대전준비") ){
            this.logger.log("도전과제 부스터를 사용하지 않습니다.")
            if ( this.gameController.searchAndClickFolder("1.공통\버튼_도전과제부스터\부스터_사용") ){
                this.gameController.waitDelayForLoading()
            }
            this.continueControl()
            this.logger.log("경기를 시작합니다")
            if ( this.clickCommonStartButton() ){
                this.logger.log("6초 기다립니다")
                this.gameController.sleep(6)
                return 1
            }
        }
        return 0
    }

    checkSlowAndChance(counter:=0){
        localCounter:=counter
        if ( this.gameController.searchImageFolder("1.공통\화면_찬스" ) ){
            this.logger.log("찬스는 하지 않겠다")
            if( this.gameController.searchAndClickFolder("1.공통\화면_찬스\버튼_취소" ) ){
                if( localCounter > 5 )
                    return localCounter
                localCounter++
                this.checkSlowAndChance(localCounter)
            }
        }
        if( this.gameController.searchAndClickFolder("1.공통\버튼_빠르게" ) ){
            this.logger.log("빠르게 빠르게..")
            localCounter++
            return localCounter
        }
        return localCounter
    }

    checkLocalModePopup(counter:=0){
        localCounter:=counter
        if ( this.gameController.searchImageFolder("랭대모드\화면_팝업체크" ) ){
            this.logger.log("주말,상대교체,드링크, 승급등의 팝업을 무시합니다.")
            if( this.gameController.searchAndClickFolder("랭대모드\화면_팝업체크\버튼_확인" ) ){
                if( localCounter > 5 ){
                    return localCounter
                }
                localCounter++
                this.checkLocalModePopup(localCounter)
            }else{
                this.gameController.postClickESC()
            }
        }
        return localCounter
    }

    checkPlaying(){
        this.continueControl()
        this.logger.log("자동 진행중..")
        this.gameController.waitDelayForLoading()
        return 1

    }

    checkRankingClose(){
        if ( this.gameController.searchImageFolder("랭대모드\화면_랭대종료" ) ){
            this.logger.log("종료 팝업인지 확인")
            if( this.checkLocalModePopup(0) > 0){
                return 0
            }
            this.continueControl()
            this.logger.log("랭대를 다 돌았습니다. ")
            if( this.gameController.searchAndClickFolder("랭대모드\화면_랭대종료\버튼_확인" ) ){
                this.stopControl() 
                return 1
            }
        }

        return 0
    }

    checkModeRunMore(){
        this.player.addResult()
        if( this.checkWantToModeQuit() ){
            return 0
        }else{

            if( this.player.needToStopBattle() ){
                this.logger.log( "다 돌아 종료 하겠습니다.") 
                this.unsetEquipment()
                this.stopControl()
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
