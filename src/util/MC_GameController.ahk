#include %A_ScriptDir%\src\util\AutoLogger.ahk
; #include %A_ScriptDir%\src\util\ActiveImageSearcher.ahk
#include %A_ScriptDir%\src\util\InActiveImageSearcher.ahk
#include %A_ScriptDir%\src\util\InActiveInputController.ahk
; #include %A_ScriptDir%\src\player\BaseballAutoPlayer.ahk

class MC_GameController{
    logger:= new AutoLogger( "Controll" ) 
    extensions:="png,bmp"

    __NEW(){
        global DEFAULT_APP_ID
        ; this.imageSearcher := new ActiveImageSearcher( this.logger )
        this.imageSearcher := new InActiveImageSearcher( this.logger ) 
        this.controller := new InActiveInputController( this.logger ) 
        this.currentTargetTitle:=DEFAULT_APP_ID
    }
    setActiveId(title){
        this.currentTargetTitle:=title
        this.imageSearcher.setActiveId(title)
        this.controller.setActiveId(title)
    }
    checkAppPlayer(){
        return this.imageSearcher.possible()
    }
    searchImageFolder( targetFolder, needLog=true) {

        if ( this.internalSearchImageFolder( targetFolder, fileName, posX, posY ) ){
            this.logger.debug( fileName "가 존재합니다. X=" posX ", Y=" posY )
            return true
        }else{
            if( needLog ){
                this.logger.debug( "폴더 [ " targetFolder " ]에 존재하는 이미지가 없습니다." )
            }
            return false
        } 
    }

    internalSearchImageFolder( targetFolder, ByRef fileName, ByRef posX, ByRef posY ) {
        IfNotExist, %A_ScriptDir%\Resource\Image\%targetFolder%
        {
            this.logger.debug( "ERROR : 폴더 [ " targetFolder " ]자체가 존재하지 않습니다." )
            return false
        }

        this.imageSearcher.prepare()
        findResult:=false 
        Loop, %A_ScriptDir%\Resource\Image\%targetFolder%\*
        {
            if A_LoopFileExt in % this.extensions
            {
                fileName=%targetFolder%\%A_LoopFileName%
                If( this.imageSearcher.funcSearchImage( posX, posY, fileName) = true ) { 
                    findResult:=true
                    break
                } 
            }
        } 
        this.imageSearcher.done()
        return findResult
        ; return false
    }

    searchAndClickFolder( targetFolder, relateX:=0, relateY:=0 , boolDelay:=true , clickTitle:=false ) {
        if ( this.internalSearchImageFolder( targetFolder, fileName, imgX, imgY ) ){ 
            targetX:=imgX+relateX
            targetY:=imgY+relateY
            this.logger.debug( fileName "를 클릭합니다. X=" imgX ", Y=" imgY ", ResultX=" targetX ", ResultY=" targetY " Title = " clickTitle)
            if( relateX >0 or relateY >0){
                this.click( targetX, targetY, boolDelay, clickTitle )		
            }else{
                this.randomClick(targetX, targetY, 0, 10, boolDelay, clickTitle)
            } 
            Return true

        }else{
            this.logger.debug( "폴더 [ " targetFolder " ]에 존재하는 이미지가 없어 클릭을 못합니다." )
            return false
        } 
    }

    click( positionX, positionY, needDelay , clickTitle=false){
        this.controller.click(positionX, positionY, clickTitle)
        if( needDelay ){
            this.waitDelayForClick()
        }
    }

    ;waitDelayForClick(){
     ;   global baseballAutoConfig 
      ;  this.sleep(baseballAutoConfig.delaySecForClick)
    ;}

    waitDelayForClick(extra := ""){
        global baseballAutoConfig

        if (extra != ""){
            this.logger.log(" " extra " 초 추가 대기")
            this.sleep(extra)
        }

        this.sleep(baseballAutoConfig.delaySecForClick)
    }

    waitDelayForLoading(){
        global baseballAutoConfig 
        this.sleep(baseballAutoConfig.delaySecChangeWindow/2)
    }

    waitDelayForChangeWindow(){
        global baseballAutoConfig 
        this.logger.log( "화면 딜레이(" baseballAutoConfig.delaySecChangeWindow " 초) 기다립니다." )
        this.sleep(baseballAutoConfig.delaySecChangeWindow)
    }
    waitDelayForSkip(){
        global baseballAutoConfig 
        this.sleep(baseballAutoConfig.delaySecSkip)
    }
    waitDelayForReboot(){
        global baseballAutoConfig 
        this.logger.log( baseballAutoConfig.delaySecReboot "를 기다립니다." )
        this.sleep(baseballAutoConfig.delaySecReboot)
    }

    randomClick( positionX, positionY , randomStart:=0, randomEnd:=15 , needDelay:=true , clickTitle:=false){
        Random, randFirst, randomStart, randomEnd
        Random, randSecond, randomStart, randomEnd

        targetX:=positionX+randFirst
        targetY:=positionY+randSecond
        this.logger.debug( "Before X=" positionX " Y=" positionY " Apply X=" targetX ", Y=" targetY " Click title = " clickTitle )
        ; ToolTip, % "TargetX = " positionX ", targetY= "positionY
        ; MouseMove %positionX%, %positionY%
        this.click( targetX, targetY, needDelay, clickTitle )		
    }

    sleep( secSleep ){
        msec:=secSleep*1000
        Sleep, %msec%
    }
    clickESC(){
        this.controller.postClickESC()
        this.waitDelayForClick() 
    }
    ;이미지 찾을때까지 대기후 클릭
    ; delay & 횟수가 필요
    waitingImageAndClickFolder( targetFolder , checkLimitCount:= 60, sleepDelay:= 2) {
        Loop %checkLimitCount%
        {
            If ( this.searchAndClickFolder( targetFolder ) = true ) {
                return true
            }
            this.sleep( sleepDelay )

            ; if( A_Index > checkLimitCount ){
            ; return false
            ; }
        }
        return false
    }
    clickUntilImageFound( targetFolder, posX,posY, limitCount:=5, sleepDelay:= 3) {

        Loop %limitCount%
        {
            if( this.searchImageFolder( targetFolder ) ){
                return true
            }else{
                this.randomClick( posX, posY )			
            }
            this.sleep( sleepDelay ) 
        }
        return false
    }
    clickRatioPos( ratioX, ratioY, maxSize:=40 , needDelay:=true) {
        WinGetPos, winX, winY, winW, winH, % this.currentTargetTitle	
        targetX:= winW * ratioX 
        targetY:= winH * ratioY 
        ; MouseMove, %targetX%, %targetY%
        ; ToolTip, % "WinW = " winW ", WinH = " winH ", TargetX = " targetX ", targetY= "targetY
        this.logger.debug( "특정 비율을 클릭합니다.(화면) WinW=" winW ", WinH=" winH ", WinX" winX " , WinY" winY)
        this.logger.debug( "특정 비율을 클릭합니다. RatioX=" ratioX ", RatioY=" ratioY ", ResultX=" targetX ", ResultY=" targetY )
        this.randomClick(targetX, targetY, 0, maxSize, needDelay)
    }
}