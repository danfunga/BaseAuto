﻿#include %A_ScriptDir%\src\util\AutoLogger.ahk
#include %A_ScriptDir%\src\util\MC_GameController.ahk

#include %A_ScriptDir%\src\mode\GameStarterMode.ahk
#include %A_ScriptDir%\src\mode\LeagueRunningMode.ahk
#include %A_ScriptDir%\src\mode\RealTimeBattleMode.ahk
#include %A_ScriptDir%\src\mode\RankingBattleMode.ahk
#include %A_ScriptDir%\src\mode\FriendsBattleMode.ahk
#include %A_ScriptDir%\src\mode\HomrunDerbyMode.ahk
#include %A_ScriptDir%\src\mode\HomrunRoyalMode.ahk
#include %A_ScriptDir%\src\mode\HistoryMode.ahk

#include %A_ScriptDir%\src\mode\ReceiveRewardMode.ahk
#include %A_ScriptDir%\src\mode\StageMode.ahk
#include %A_ScriptDir%\src\mode\TitleHolderMode.ahk
#include %A_ScriptDir%\src\mode\LeagueUpgradeMode.ahk
#include %A_ScriptDir%\src\mode\PennantRaceMode.ahk
#include %A_ScriptDir%\src\mode\ClubTogetherMode.ahk


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

        this.typePerMode["실대"]:=[]
        this.typePerMode["실대"].Push(new GameStarterMode( this.gameController ) ) 
        this.typePerMode["실대"].Push(new RealTimeBattleMode( this.gameController ) ) 

        this.typePerMode["랭대"]:=[]
        this.typePerMode["랭대"].Push(new GameStarterMode( this.gameController ) ) 
        this.typePerMode["랭대"].Push(new RankingBattleMode( this.gameController ) ) 

        this.typePerMode["친구"]:=[]
        this.typePerMode["친구"].Push(new GameStarterMode( this.gameController ) ) 
        this.typePerMode["친구"].Push(new FriendsBattleMode( this.gameController ) ) 

        this.typePerMode["홈런"]:=[]
        this.typePerMode["홈런"].Push(new GameStarterMode( this.gameController ) ) 
        this.typePerMode["홈런"].Push(new HomrunDerbyMode( this.gameController ) ) 

        this.typePerMode["로얄"]:=[]
        this.typePerMode["로얄"].Push(new GameStarterMode( this.gameController ) ) 
        this.typePerMode["로얄"].Push(new HomrunRoyalMode( this.gameController ) ) 

        this.typePerMode["보상"]:=[]
        this.typePerMode["보상"].Push(new GameStarterMode( this.gameController ) ) 
        this.typePerMode["보상"].Push(new ReceiveRewardMode( this.gameController ) ) 

        this.typePerMode["스테"]:=[]
        this.typePerMode["스테"].Push(new GameStarterMode( this.gameController ) ) 
        this.typePerMode["스테"].Push(new StageMode( this.gameController ) ) 

        this.typePerMode["타홀"]:=[]
        this.typePerMode["타홀"].Push(new GameStarterMode( this.gameController ) ) 
        this.typePerMode["타홀"].Push(new TitleHolderMode( this.gameController ) ) 

        this.typePerMode["클협"]:=[]
        this.typePerMode["클협"].Push(new GameStarterMode( this.gameController ) ) 
        this.typePerMode["클협"].Push(new ClubTogetherMode( this.gameController ) ) 

        this.typePerMode["히스"]:=[]
        this.typePerMode["히스"].Push(new GameStarterMode( this.gameController ) ) 
        this.typePerMode["히스"].Push(new HistoryMode( this.gameController ) ) 

        this.typePerMode["등반"]:=[]
        this.typePerMode["등반"].Push(new GameStarterMode( this.gameController ) ) 
        this.typePerMode["등반"].Push(new LeagueUpgradeMode( this.gameController ) ) 

        this.typePerMode["패넌"]:=[]
        this.typePerMode["패넌"].Push(new GameStarterMode( this.gameController ) ) 
        this.typePerMode["패넌"].Push(new PennatRaceMode( this.gameController ) ) 

        this.logger.log("BaseballAuto Ready !")
    }

    start(){
        global BaseballAutoGui, baseballAutoConfig, globalCurrentPlayer, globalContinueFlag, AUTO_RUNNING
        BaseballAutoGui.saveGuiConfigs()
        ; 데이터 불일치가 일어 나더라도 기존 설정 값이 변경 되지 않도록 Copy를 유지한다.
        ; this.currentEnablePlayers:=baseballAutoConfig.enabledPlayers
        this.currentEnablePlayers:=this.loadPlayerConfig() 

        if ( ! this.started ){
            this.started:=true
            AUTO_RUNNING:=true
            this.logger.log("BaseballAuto Started!!")

            for playerIndex, player in this.currentEnablePlayers{
                player.initPlayerMode()
            }

            BaseballAutoGui.started()
            while( AUTO_RUNNING ){ 
                if ( this.currentEnablePlayers.length() = 0 ){
                    AUTO_RUNNING:=false
                    this.logger.log("가능한 AppPlayer가 없습니다.")
                }

                for playerIndex, player in this.currentEnablePlayers{
                    globalCurrentPlayer:=player

                    player.setCheck()
                    this.gameController.setActiveId(player.getAppTitle())

                    loopCount:=0
                    while( AUTO_RUNNING = true ){ 
                        localChecker:=0
                        ; 외부적 요인에 의해 재기동이 되더라도 정상 동작위해 Handle Update
                        this.gameController.setActiveId(player.getAppTitle())

                        if not ( this.gameController.checkAppPlayer() ){
                            this.logger.log("Application Title을 확인하세요 변경 후 save ")
                            this.stopPlayer(playerIndex) 
                            break
                        } 

                        modeList:= this.typePerMode[player.getMode()]
                        for index, gameMode in modeList 
                        {
                            gameMode.setPlayer(player) 
                            localChecker+=gameMode.checkAndRun()
                        } 

                        if ( AUTO_RUNNING = false )
                            break

                        if( player.needToStop()){
                            ; this.logger.log( "STOP " this.getPlayerResult(player)) 
                            this.stopPlayer(playerIndex) 
                            break
                        }else if( player.needToNextPlayer() and this.currentEnablePlayers.length() > 1 ){
                            break
                        }else{
                            ; 조작권을 쥐고 있을 경우                     
                            if ( localChecker = 0 ){
                                loopCount++
                                if( player.getMode() ="리그"){

                                    if( loopCount!=0 and mod(loopCount,30) = 0 ){
                                        this.logger.log(player.getAppTitle() "[" player.getMode() "] 이미지 없음 " loopCount "회")
                                    } 
                                    this.gameController.sleep(2) 

                                    if( loopCount = 90 or loopCount = 120){
                                        this.logger.log("ERROR : 어딘지 모르니 일단 뒤로가기!!!")
                                        this.startMode.setPlayer(player)
                                        this.startMode.goBackward()
                                    } 
                                    if ( loopCount > 130 ){
                                        this.logger.log("ERROR : 갇혀 있으면 다른애들이 불쌍하다.. 이녀석을 강제...로...")
                                        if( this.startMode.quitCom2usBaseball()){
                                            this.logger.log("자~ 재기동을 시켜 버렸다... 어떻게 하나 보자")
                                            player.setUnknwon()
                                            loopCount:=0
                                        }else{
                                            this.setStatus("끝")
                                        }
                                    }
                                }else{
                                    if( loopCount!=0 and mod(loopCount,30) = 0 ){
                                        this.logger.log(player.getAppTitle() "[" player.getMode() "] 이미지 없음 " loopCount "회")
                                    }
                                    if( loopCount = 90 or loopCount = 120){
                                        this.logger.log("ERROR : 어딘지 모르니 일단 뒤로가기!!!")
                                        this.startMode.setPlayer(player)
                                        this.startMode.goBackward()
                                    } 

                                    if ( loopCount > 130 ){
                                        this.logger.log("ERROR : 갇혀 있으면 다른애들이 불쌍하다.. 이녀석을 강제...로...")
                                        if( this.startMode.quitCom2usBaseball()){
                                            this.logger.log("자~ 재기동을 시켜 버렸다... 어떻게 하나 보자") 
                                            player.setUnknwon()
                                            loopCount:=0
                                        }else{
                                            this.setStatus("끝")
                                        }
                                    }
                                } 
                            } else{
                                loopCount:=0
                            }
                        }
                    } 
                    player.setCheckDone()
                } 
            }
        }else{ 
            this.logger.log("BaseballAuto Already Started!!")
            return
        }
        this.stop()
    }
    loadPlayerConfig(){
        global baseballAutoConfig
        curruntPlayers:=Array()
        for index, player in baseballAutoConfig.enabledPlayers
        {
            if not ( player.getAppTitle() = ""){
                curruntPlayers.Push(this.objectFullClone(player))
            }else{
                this.logger.log( "ERROR : " index " 번째 설정의 값이 비었습니다" )
            }
        }
        return curruntPlayers
    }
    objectFullClone( target ){
        newObject := target.Clone()
        for key,value in newObject
        {
            if ( isObject(value) ){
                newObject[key]:= this.objectFullClone(value)
            }
        }
        return newObject
    }

    stopPlayer(index){
        global AUTO_RUNNING
        this.currentEnablePlayers.remove(index)
        if( this.currentEnablePlayers.length() = 0 )
            AUTO_RUNNING:=false
    }

    tryStop(){
        global AUTO_RUNNING
        this.logger.log("try to stop!")
        AUTO_RUNNING := false
    }
    getPlayerResult( targetPlayer ){
        targetCounterPerMode:=targetPlayer.getCountPerMode() 
        result:=""
        for key,value in targetCounterPerMode
        {
            result:= result "`n`t" key " : " value " 회"
        }
        return targetPlayer.getAppTitle() " Runs :" result

    }
    stop(){
        global BaseballAutoGui, globalCurrentPlayer, AUTO_RUNNING
        if ( this.started ){
            this.started:=false
            ; for playerIndex, player in this.currentEnablePlayers{
            ;     this.logger.log( this.getPlayerResult(player)) 
            ; }
            AUTO_RUNNING:=false
            this.logger.log("BaseballAuto Stopped!!")
            BaseballAutoGui.stopped()

        }else{
            this.logger.log("BaseballAuto Already Stopped!!")
        }
    }
    setWantToResult( want:=true ){
        for index,player in this.currentEnablePlayers
        {
            player.setWantToWaitResult(want) 
        }
    }
    reload(){
        this.logger.log(" reload Call")
    }

}
