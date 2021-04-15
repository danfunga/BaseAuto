#include %A_ScriptDir%\src\mode\0.DefulatGameMode.ahk

Class RankingBattleMode extends AutoGameMode{

    __NEW( controller )
    {
        base.__NEW("랭킹대전", controller)
    }

    checkAndRun()
    {
        counter:=0
        counter+=this.startBattleMode( )
        counter+=this.selectRankingBattle( )
        counter+=this.startRankingBattle( )
        counter+=this.playRankingBattle( )
        counter+=this.checkSlowAndChance( )

        counter+=this.checkGameResultWindow( )
        counter+=this.checkMVPWindow( )
        counter+=this.checkPopup( )
        counter+=this.checkPlaying( )
        counter+=this.checkRankingClose( )

        counter+=this.checkAndGoHome(counter)


        ; this.logger.log("나는 랭킹대전" counter)
        return counter
    }

    selectBattleMode()
    {
        if ( this.gameController.searchImageFolder("0.기본UI\0.메인화면_Base") ){
            this.logger.log(this.player.getAppTitle() "랭킹 대전 을 시작합니다")
            this.player.setStay()
            if ( this.gameController.searchAndClickFolder("0.기본UI\0.메인화면_버튼_대전_팀별") ){
                return 1
            }
        }
        return 0
    }

    setBattleEquips(){
      global Equips
      if(Equips==1){
          if ( this.gameController.searchImageFolder("0.기본UI\2-1.랭킹대전_Base") ){
          this.player.setStay()
          if ( this.gameController.searchAndClickFolder("랭대모드\화면_장비착용\장비없음") ){
            this.logger.log("대전 장비를 착용합니다")
              Loop, 6
              {
                this.gameController.searchAndClickFolder("랭대모드\화면_장비착용\장비")
                this.ransleep(200,500)
              }
              this.gameController.searchAndClickFolder("랭대모드\화면_장비착용\장비\닫기")
             return 1
          }
        }
      }
      return 0
    }

    unsetBattleEquips(){
      if ( this.gameController.searchImageFolder("0.기본UI\2-1.랭킹대전_Base") ){
          if ( this.gameController.searchAndClickFolder("랭대모드\화면_장비착용\장비있음") ){
            this.logger.log("대전 장비를 해제합니다.")
            this.gameController.searchAndClickFolder("랭대모드\화면_장비착용\해제")
            this.gameController.searchAndClickFolder("랭대모드\화면_장비착용\장비\닫기")
             return 1
          }
      }
      return 0
    }

    ransleep(min, max)
    {
      Random, rand, min, max
      sleep, rand
    }

    selectRankingBattle(){
        if ( this.gameController.searchImageFolder("0.기본UI\2.대전모드_Base") ){
            this.player.setStay()
            this.logger.log("랭킹 대전을 선택합니다")
            if ( this.gameController.searchAndClickFolder("0.기본UI\2.대전모드_버튼_랭킹대전") ){
                return 1
            }
        }
        return 0
    }
    startRankingBattle(){
        if ( this.gameController.searchImageFolder("0.기본UI\2-1.랭킹대전_Base") ){

            if ( this.gameController.searchImageFolder("랭대모드\화면_상대있음") ){
                this.setBattleEquips()
                this.player.setStay()
                this.logger.log("랭킹 대전을 시작합니다")
                if ( this.gameController.searchAndClickFolder("1.공통\버튼_게임시작") ){
                    return 1
                }
            }else{
                this.logger.log("상대가 없는거 보니 다 돌았습니다.")
                this.unsetBattleEquips()
                this.player.setBye()
                return 1
            }
        }
        return 0
    }
    playRankingBattle(){
        if ( this.gameController.searchImageFolder("랭대모드\화면_랭킹대전준비") ){
            this.logger.log("도전과제 부스터를 사용하지 않습니다.")
            if ( this.gameController.searchAndClickFolder("1.공통\버튼_도전과제부스터\부스터_사용") ){
                this.gameController.sleep(3)
            }
            this.player.setStay()
            this.logger.log("경기를 시작합니다")
            if ( this.gameController.searchAndClickFolder("1.공통\버튼_게임시작") ){
                this.logger.log("4초 기다립니다")
                this.gameController.sleep(4)
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

        if ( this.gameController.searchImageFolder("랭대모드\화면_팝업체크" ) ){
            this.logger.log("주말 팝업인가.")
            if( this.gameController.searchAndClickFolder("랭대모드\화면_팝업체크\버튼_확인" ) ){
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
        if ( this.gameController.searchImageFolder("랭대모드\화면_자동중" ) ){
            this.player.setStay()
            this.gameController.sleep(2)
            return 1
        }
        return 0
    }

    checkRankingClose(){
        if ( this.gameController.searchImageFolder("랭대모드\화면_랭대종료" ) ){
            this.player.setStay()
            this.logger.log("랭대는 다 돌거나 갱신한다. ")
            if( this.gameController.searchAndClickFolder("랭대모드\화면_랭대종료\버튼_확인" ) ){
                this.player.setFree()
                return 1
            }
        }
        return 0
    }
    checkGameResultWindow(){
        if ( this.gameController.searchImageFolder("1.공통\화면_경기_결과" ) ){
            this.logger.log("경기 결과를 확인했습니다.")
            this.player.setStay()
            if( this.gameController.searchAndClickFolder("1.공통\버튼_다음_확인" ) ){
                return 1
            }
        }
        return 0
    }
    checkMVPWindow(){
        if ( this.gameController.searchImageFolder("1.공통\화면_MVP" ) ){
            this.logger.log("MVP 를 확인했습니다.")
            if( this.gameController.searchAndClickFolder("1.공통\버튼_다음_확인" ) ){
                this.player.addResult()
                if( this.player.needToStopBattle() ){
                    this.logger.log("랭킹대전을 횟수만큼 돌았습니다.")
                    this.unsetBattleEquips()
                    this.player.setBye()
                }else{
                    if( this.player.getRemainBattleCount() = "무한" ){
                        this.logger.log("상대가 없을 때까지 돕니다." )
                    }else{
                        this.logger.log("랭킹대전을 " this.player.getRemainBattleCount() "번 더 돕니다." )
                    }
                    this.player.setFree()
                }
                return 1
            }
        }
        return 0
    }
    
}
