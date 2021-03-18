﻿#include %A_ScriptDir%\src\util\AutoLogger.ahk

class InActiveInputController{

    currentTargetTitle:=""
    __NEW( logger ){
        global DEFAULT_APP_ID
        this.logger :=logger
        this.currentTargetTitle:=DEFAULT_APP_ID
    }
    setActiveId(targetId){
        this.currentTargetTitle:=targetId
    }

    click( x, y ) {
        ; WinGetPos, winX, winY, winW, winH, % this.currentTargetTitle
        px:=x
        ; px:=x-winX
        py:=y
        ; py:=y-winy
        this.fixedClick(px, py ) 
    }

    fixedClick( posX, posY ){
        ; global BooleanDebugMode
        ; if( BooleanDebugMode = true ){
        ; this.logger.log(" fixed Click Position " posX ", " posY ) 
        ; } 
        lParam:= posX|posY<< 16 
        ; LD player
        ; PostMessage, 0x201, 1, %lParam%, TheRender, % this.currentTargetTitle ;WM_LBUTTONDOWN
        ; sleep, 50	
        ; PostMessage, 0x202, 0, %lParam%, TheRender, % this.currentTargetTitle ;WM_LBUTTONUP       

        PostMessage, 0x201, 1, %lParam%, , % this.currentTargetTitle ;WM_LBUTTONDOWN
        sleep, 50	
        PostMessage, 0x202, 0, %lParam%, , % this.currentTargetTitle ;WM_LBUTTONUP       
    }
}
