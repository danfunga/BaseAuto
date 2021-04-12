#include %A_ScriptDir%\src\util\AutoLogger.ahk
#include %A_ScriptDir%\src\util\MC_GameController.ahk

#include %A_ScriptDir%\src\mode\GameStarterMode.ahk
#include %A_ScriptDir%\src\mode\LeagueRunningMode.ahk
#include %A_ScriptDir%\src\mode\RealTimeBattleMode.ahk
#include %A_ScriptDir%\src\mode\RankingBattleMode.ahk
#include %A_ScriptDir%\src\mode\FriendsBattleMode.ahk
#include %A_ScriptDir%\src\mode\HomrunDerbyMode.ahk

Class BaseballAuto{
    __NEW(){
        this.init()
    }

    logger:= new AutoLogger( "시 스 템" )
    gameController := new MC_GameController()
    typePerMode := Object()

    init(){
        this.startMode:= new GameStarterMode( this.gameController )

        this.typePerMode["리그"]:=[]
        this.typePerMode["리그"].Push(new GameStarterMode( this.gameController ) ) 
        this.typePerMode["리그"].Push(new LeagueRunningMode( this.gameController ) ) 

        this.typePerMode["대전"]:=[]
        this.typePerMode["대전"].Push(new GameStarterMode( this.gameController ) ) 
        this.typePerMode["대전"].Push(new RealTimeBattleMode( this.gameController ) ) 

        this.typePerMode["랭대"]:=[]
        this.typePerMode["랭대"].Push(new GameStarterMode( this.gameController ) ) 
        this.typePerMode["랭대"].Push(new RankingBattleMode( this.gameController ) ) 

        this.typePerMode["친구"]:=[]
        this.typePerMode["친구"].Push(new GameStarterMode( this.gameController ) ) 
        this.typePerMode["친구"].Push(new FriendsBattleMode( this.gameController ) ) 

        this.typePerMode["홈런"]:=[]
        this.typePerMode["홈런"].Push(new GameStarterMode( this.gameController ) ) 
        this.typePerMode["홈런"].Push(new HomrunDerbyMode( this.gameController ) ) 

        this.logger.log("BaseballAuto Ready !")
    }

    start(){
        global BaseballAutoGui, baseballAutoConfig, globalCurrentPlayer, globalContinueFlag
        BaseballAutoGui.saveGuiConfigs()
        this.currentEnablePlayers:=this.loadPlayerConfig()

        if ( ! this.started ){
            this.started:=true
            this.running:=true
            this.logger.log("BaseballAuto Started!!")

            BaseballAutoGui.started()
            while( this.running = true ){ 
                if ( this.currentEnablePlayers.length() = 0 ){
                    this.running:=false
                    this.logger.log("가능한 AppPlayer가 없습니다.")
                }

                for playerIndex, player in this.currentEnablePlayers{
                    globalCurrentPlayer:=player

                    if( globalCurrentPlayer.needToStop()){
                        this.stopPlayer(playerIndex)                 
                        continue
                    }

                    globalCurrentPlayer.setCheck()
                    this.gameController.setActiveId(player.getAppTitle())
                    globalContinueFlag:=false

                    loopCount:=0
                    while( this.running = true ){
                        localChecker:=0
                        if not ( this.gameController.checkAppPlayer() ){
                            this.logger.log("Application Title을 확인하세요 변경 후 save ")
                            this.stopPlayer(playerIndex)                           
                            break
                        } 

                        modeList:= this.typePerMode[globalCurrentPlayer.getRole()]
                        for index, gameMode in modeList ; Enumeration is the recommended approach in most cases.
                        {
                            gameMode.setPlayer(player) 
                            localChecker+=gameMode.checkAndRun()
                        } 
                        if( globalCurrentPlayer.getRole() ="리그")
                            this.gameController.sleep(2)

                        ; this.logger.log( player.getAppTitle() " checker count=" localChecker)
                        if ( !player.needToStay() ){ 
                            ; this.logger.log( "AUTO_PLAYING 확인. " globalCurrentPlayer.getAppTitle())
                            break
                        }else{
                            ; Stay 를 벗어 나게 해주자
                            if ( localChecker = 0 ){
                                if( globalCurrentPlayer.getRole() ="리그"){
                                    if( loopCount = 80 || loopCount = 90){
                                        this.logger.log("ERROR : 어딘지 모르니 일단 뒤로가기!!!")
                                        this.startMode.setPlayer(player)
                                        this.startMode.goBackward()
                                    } 
                                    if ( loopCount > 90 ){
                                        this.logger.log("ERROR : 갇혀 있으면 다른애들이 불쌍하다.. 풀어주자")
                                        player.setUnknwon()
                                    }
                                }else{
                                    if ( loopCount > 180 ){
                                        this.logger.log("ERROR : 갇혀 있으면 다른애들이 불쌍하다.. 풀어주자")
                                        player.setUnknwon()
                                    }
                                }
                                loopCount+=1
                            } else{
                                loopCount:=0
                            }
                        }
                    } 
                    globalCurrentPlayer.setCheckDone()
                } 
            }
        }else{ 
            this.logger.log("BaseballAuto Already Started!!")
        }
        this.logger.log("BaseballAuto Done!!")
        this.stop()
    }
    loadPlayerConfig(){
        global baseballAutoConfig
        curruntPlayers:=Array()
        for index, player in baseballAutoConfig.enabledPlayers
        {
            if not ( player.getAppTitle() = ""){
                curruntPlayers.Push(player.clone())
            }else{
                this.logger.log( "ERROR : " index " 번째 설정의 값이 비었습니다" )
            }
        }
        return curruntPlayers
    }

    stopPlayer(index){
        this.currentEnablePlayers.remove(index)
        if( this.currentEnablePlayers.length() = 0 )
            this.running:=false
    }

    tryStop(){
        this.logger.log("try to stop!")
        this.running := false
    }
    stop(){
        global BaseballAutoGui
        if ( this.started ){
            this.started:=false
            this.logger.log("BaseballAuto Stopped!!")
            BaseballAutoGui.stopped()

        }else{
            this.logger.log("BaseballAuto Already Stopped!!")
        }
    }
    setWantToResult(){
        for index,player in this.currentEnablePlayers
        {
            player.setWantToWaitResult() 
        }
    }
    reload(){
        this.logger.log(" reload Call")
    }

}
