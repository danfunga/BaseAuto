Class ActiveImageSearcher{

    pathPrefix:="\Resource\Image\"
    percentage:=30
    currentTargetTitle:=""

    __NEW( _logger ){
        global DEFAULT_APP_ID
        this.logger :=_logger
        this.currentTargetTitle:=DEFAULT_APP_ID
    }
    possible(){
        return WinExist(this.currentTargetTitle)
    }
    setActiveId( targetId ){
        this.currentTargetTitle:=targetId
    }
    funcSearchImage( ByRef intPosX, Byref intPosY, target ) {
        CoordMode, Pixel, Screen

        ; this.logger.debug( target "을 찾고 있습니다." )
        WinGetPos, winX, winY, winW, winH, % this.currentTargetTitle			
        ImageSearch, oX, oY, winX, winY, winX+winW, winY+winH, % "*" this.percentage " " A_ScriptDir this.pathPrefix target		
        If( ErrorLevel = 0 ){
            intPosX := oX - winX
            intPosY := oY - winY
            ; this.logger.log( target "을 찾았습니다. X=" intPosX ", Y=" intPosY )
            return true
        }else If(Errorlevel = 2){		
            ; this.logger.debug( "ERROR ---" target "파일자체가 존재하지 않습니다." )
            return false
        }
        return false
    }

}