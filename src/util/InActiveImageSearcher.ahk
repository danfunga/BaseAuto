#SingleInstance, Force

#include %A_ScriptDir%\src\external\Gdip_all.ahk
#include %A_ScriptDir%\src\external\Gdip_ImageSearch.ahk
; #include %A_ScriptDir%\src\util\AutoLogger.ahk

Class InActiveImageSearcher{

    pathPrefix:="\Resource\Image\"
    percentage:=30
    currentHwnd:=""

    __NEW( _logger ){
        global DEFAULT_APP_ID
        this.logger :=_logger
        this.currentHwnd:=WinExist(DEFAULT_APP_ID)
    }
    possible(){
        return this.currentHwnd
    }
    setActiveId( targetId ){
        this.currentHwnd:=WinExist(targetId)
    }
    prepare(){
        this.pToken:=Gdip_Startup() 
        this.pBitmapHayStack:=Gdip_BitmapFromhwnd(this.currentHwnd) 
    }
    done(){
        Gdip_DisposeImage(this.pBitmapHayStack)
        Gdip_Shutdown(this.pToken)
    }
    funcSearchImage( ByRef intPosX, ByRef intPosY, target, fullSet:=false) {
        ; target:=% A_ScriptDir this.pathPrefix target
        if( fullSet ){
            this.prepare()
        }
        findResult:=false 
        pBitmapNeedle:=Gdip_CreateBitmapFromFile(A_ScriptDir this.pathPrefix target)         
        ; Sleep, 1000
        if Gdip_ImageSearch( this.pBitmapHayStack,pBitmapNeedle, resultList ,0,0,0,0,this.percentage,0x000000,1,1) { 
            StringSplit, LISTArray, resultList, `, 
            intPosX:=LISTArray1 
            intPosY:=LISTArray2
            ; this.logger.log( target "을 찾았습니다. X=" intPosX ", Y=" intPosY )
            findResult:=true
            Gdip_DisposeImage(pBitmapNeedle)
        }
        else {
            ; this.logger.log( target "을 찾지 못했습니다." )
            findResult:=false
            Gdip_DisposeImage(pBitmapNeedle)
        }
        if( fullSet){
            this.done()
        }
        return findResult
    }
}