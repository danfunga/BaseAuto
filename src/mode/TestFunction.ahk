; #include %A_ScriptDir%\src\util\MC_GameController.ahk

#include %A_ScriptDir%\src\player\BaseballAutoPlayer.ahk

Class MC_ScanWindow {

    static widthToScan=330
    static heightToScan=50

    KEY_ESC:=27
    KEY_F:=70
    KEY_C:=67
    KEY_S:=83
    __NEW(name){
        This.Name := Name 
        This.Title:= "ScanWindow-" name
        This.Controls := Object()
        Gui, % This.Name ":+LastFound"
        This.Hwnd := WinExist()
        this.clicked:=false
        this.initWindow()
    }

    initWindow(){
        Gui, % This.Name ":Default"
        Gui, % This.Name ":Margin", 4, 4
        Gui, % This.Name ":Font", s , 
        Gui , -Border +Resize -Caption +AlwaysOnTop
        Gui, % This.Name ":Show", % "w" MC_ScanWindow.widthToScan " h" MC_ScanWindow.heightToScan , % This.Title
        WinSet, Transparent, 70, % This.Title

        OnMessage(0x201, this.onMouseClick.Bind(this))
        OnMessage(0x200, this.onMouseMove.Bind(this))
        onMessage(0x100,this.onKeyDown.Bind(this))
    } 
    onKeyDown( wParam, lParam, msg, hwnd){
        ; ToolTip, % " wParam:" wParam " lParam:" lParam " msg:" msg " hwnd:" hwnd
        if ( hwnd != this.Hwnd){
            return
        }
        if ( wParam = this.KEY_ESC ){
            this.closeGui(this)
        } else if (wParam = this.KEY_F){
            ToolTip, "F Input"
        } 
    }
    closeGui(){
        Gui, % This.Name ":Default"
        Gui, Destroy 
    }
    ; onCloseWindow( wParam, lParam, msg, hwnd){
    ;     ToolTip, "I'SUPER Die"
    ;     if ( hwnd != this.Hwnd){
    ;         return
    ;     }        

    ;     ; ToolTip, % " wParam:" wParam " lParam:" lParam " msg:" msg " hwnd:" hwnd
    ;     ToolTip, "I'm Die"
    ; }

    onMouseMove( wparam, lParam, msg, hwnd ){	
        global baseballAutoConfig

        if ( hwnd != this.Hwnd){
            return
        } 

        if ( wParam = 1 ){
            PostMessage, 0XA1, 2,,, % This.Title
            return
        }else{ 
            if( this.clicked ){
                CoordMode, Pixel, Screen

                this.clicked:=false
                WinGetPos, posX, posY, winWidth, winHeight, % this.Title
                posX+=6
                winWidth-=12
                winHeight-=6
                WinGetPos, posX1, posY1, winWidth1, winHeight1, % baseballAutoConfig.getDefaultPlayer().getAppTitle()
                tooltip, % "PosX:" posX " posY:" posY " winWidth:" winWidth " winHeight:" winHeight "`n" "PosX:" posX1 " posY:" posY1 " winWidth:" winWidth1 " winHeight:" winHeight1
            }	
        }
        ; if( GetKeyState (LButton ) ){

        ; }

    }
    onMouseClick( wParam, lParam, msg, hwnd){
        if ( hwnd != this.Hwnd){
            return
        }
        this.clicked:=true 
    }

}

!F6::

    player := new BaseballAutoPlayer(4)
    ; role:="리그"
    ; stringArray:=["리그","대전","랭대","홈런","친구","일꾼","기타"]
    ; msg
    ; if( !BaseballAutoPlayer.hasValue( role, BaseballAutoPlayer.AVAILABLE_ROLES) ){
        msgbox % BaseballAutoPlayer.ASSIST_MODE_ARRAY.length()
        
    ; }else{
    ;     MsgBox, % "찾았다"
    ; }
    ; find:=false
    ; for index, value in stringArray
    ; {
    ;     if( value = role){
    ;         find:=true
    ;     }
    ; }
    ; if( !find ){
    ;     MsgBox, % "이거 안들어가 : " role            
    ; }
    ; if role not in stringArray
    ; {
    ;     { 
    ;         MsgBox, % "이거 안들어가 : " role            
    ;     }
    ; }  

    player.setRole("바보")
    ; IfExist, A_ScriptDir
    ; globalCurrentPlayer.setStay()
    ; targetX:=178
    ; targetY:=63
    ; MouseMove, %targetX%, %targetY%

    ; CoordMode, Pixel, Screen

    ; MouseMove, 758, 286
    ; msgbox "TEST"
    ; targetX:=758
    ; targetY:=286
    ; MouseMove, %targetX%, %targetY%

    ; BaseballAutoGui.updateStatus("player1Status","TEst")

return

!F7::
    ; globalCurrentPlayer.setUnknwon()
    globalCurrentPlayer.addResult()
    ; WinGetPos, winX, winY, winW, winH, (Hard)			
    ; msgbox % "Winx=" winX " winY=" winY " winW=" winW " winH=" winH

return 

^F6::
    WinGetClass, target , LDsub
    MsgBox, %target%
    ; testWindow := new MC_ScanWindow("OK")
    ; testWindow := new MC_ScanWindow("OK2")
    ; widthToScan=200
    ; heightToScan=50
    ; scanWinTitle:="scanWindow"
    ; gui , 2:-Border +Resize -Caption +AlwaysOnTop
    ; gui , 2:color, 0xFFFFFF

    ; ; Gui, 2:Add, Text, w100 h100 vClickAbleText , 
    ; ; Gui, 2:Show, w100  , catcherWindow
    ; Gui, 2:Show, % "w" widthToScan " h" heightToScan , %scanWinTitle%
    ; WinSet, Transparent, 70, %scanWinTitle%

    ; OnMessage(0x201, "myMouseDown")
    ; OnMessage(0x200, "myMouseMove")
Return

; myMouseMove( wparam, lParam, msg, hwnd ){	
;     WinGetTitle, title, ahk_id %hwnd%

;     global UnRelease, scanWinTitle
;     if( wParam = 1 ){
;         ; MouseGetPos ,,,, Target
;         if ( title = scanWinTitle ){
;             tooltip % "뭔지 보자 " wparam " lParam" lParam " msg" msg " hwnd" hwnd " target=" target " Same :" title 
;             PostMessage, 0XA1, 2,,, %scanWinTitle%
;         }
;         ; tooltip % "뭔지 보자 " wparam "  lParam" lParam "  msg" msg "  hwnd" hwnd " target=" target " Same :" title 
;         ; PostMessage, 0XA1, 2,,, catcherWindow			
;         return
;         ; MouseGetPos, mouseX, mouseY
;         ; topLeftX := mouseX
;         ; topLeftY := mouseY - heightToScan
;         ; WinMove, catcherWindow, , % topLeftX+2, % topLeftY-2

;     }else{
;         if( UnRelease ){
;             UnRelease:=false
;             MouseGetPos ,,,, Target
;             tooltip, % "Release " wparam lparam	 " target:" Target " wintitle:" scanWinTitle
;         }	
;     }
;     ; if( GetKeyState (LButton ) ){

;     ; }

; }
; myMouseDown( wParam, lParam, msg, hwnd){
;     global UnRelease
;     UnRelease:=true
;     WinGetTitle, title, ahk_id %hwnd%
;     tooltip, % "클릭 " wparam lparam	 " target" title " wintitle:" scanWinTitle
; }

; 2GuiSize:
; GuiControl Move, ClickAbleText, % "H" A_GuiHeight-20 " W" A_GuiWidth-20	
; tooltip, "????"
; return

; gui , 2:color, 0xFF44AA
; gui , 2:show, w%widthToScan% h%heightToScan%,OcrPreviewWindow
; sleep, 200
; WinSet, Transparent, 50, OcrPreviewWindow
; onMessage(0x200, "WM_MOUSEMOVE")

; return

; WM_MOUSEMOVE(wpram, lparam, msg, hwnd)
; {
; if wparam =1 ; LButton
; PostMessage, 0xA1, 2,,, A
; 
