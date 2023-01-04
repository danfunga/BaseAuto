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

    click( x, y , clickTitle=false) {
        ; WinGetPos, winX, winY, winW, winH, % this.currentTargetTitle
        px:=x
        ; px:=x-winX
        py:=y
        ; py:=y-winy
        this.fixedClick(px, py , clickTitle) 
    }

    fixedClick( posX, posY , clickTitle=false){
        ; global BooleanDebugMode
        ; if( BooleanDebugMode = true ){
        ; this.logger.log(" fixed Click Position " posX ", " posY ) 
        ; } 
        WinGetClass, target , % this.currentTargetTitle              
        if ( InStr(target ,"LDPlayer" ) && !clickTitle )
        {           
            lParam:= posX|posY-35<< 16 
            PostMessage, 0x201, 1, %lParam%, TheRender, % this.currentTargetTitle ;WM_LBUTTONDOWN
            sleep, 50	
            PostMessage, 0x202, 0, %lParam%, TheRender, % this.currentTargetTitle ;WM_LBUTTONUP       
        }
        else{
            lParam:= posX|posY<< 16 
            PostMessage, 0x201, 1, %lParam%, , % this.currentTargetTitle ;WM_LBUTTONDOWN
            ; sleep, 50	
            PostMessage, 0x202, 0, %lParam%, , % this.currentTargetTitle ;WM_LBUTTONUP       

        }
        
    }

    postClickESC( ){
        WinGetClass, target , % this.currentTargetTitle              
        if ( InStr(target ,"LDPlayer" ) )
        {           
            PostMessage, 0x100, 27, 65537, TheRender, % this.currentTargetTitle ;WM_LBUTTONDOWN
            sleep, 50	
            PostMessage, 0x101, 27, 65537, TheRender, % this.currentTargetTitle ;WM_LBUTTONUP       
        }
        else{
            PostMessage, 0x100, 27, 65537, , % this.currentTargetTitle ;WM_LBUTTONDOWN
            sleep, 50	
            PostMessage, 0x101, 27, 65537, , % this.currentTargetTitle ;WM_LBUTTONUP                   
        }        
    }
}
