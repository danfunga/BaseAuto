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
        
        ; LD player
        ; PostMessage, 0x201, 1, %lParam%, TheRender, % this.currentTargetTitle ;WM_LBUTTONDOWN
        ; sleep, 50	
        ; PostMessage, 0x202, 0, %lParam%, TheRender, % this.currentTargetTitle ;WM_LBUTTONUP       
        if InStr(this.currentTargetTitle ,"LD" )
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
        PostMessage, 0x100, 27, 65537, , % this.currentTargetTitle ;WM_LBUTTONDOWN
        PostMessage, 0x101, 27, 65537, , % this.currentTargetTitle ;WM_LBUTTONUP       
    }
}
