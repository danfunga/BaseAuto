#SingleInstance, Force
#include %A_ScriptDir%\src\BaseballAutoConfig.ahk
#include %A_ScriptDir%\src\BaseballAuto.ahk
#include %A_ScriptDir%\src\BaseballAutoGui.ahk

Menu, Tray, Icon, %A_ScriptDir%\Resource\Image\white.png
DEFAULT_APP_ID:="main"

BooleanDebugMode:=true

baseballAutoConfig :=new BaseballAutoConfig( "main.ini" )
baseballAutoGui := new BaseballAutoGui("baseball")
baseballAuto := new BaseballAuto()
baseballAutoConfig.loadConfig()
baseballAutoConfig.getLastGuiPosition( positionX, positionY )
baseballAutoGui.show( positionX , positionY )

return

baseballGuiClose:
    {
        global baseballAutoGui, baseballAutoConfig
        title := baseballAutoGui.getTitle() 
        WinGetPos, posx, posy, width, height, %title% 
        baseballAutoConfig.setLastGuiPosition(posx, posy)

        ExitApp
    }

^F9::
    baseballAuto.start()
return 

^F10::
    baseballAutoConfig.saveConfig()
    baseballAuto.stop()
return 

^F12:: 
    WinActivate BaseAuto.ahk
    Send, ^s

    global baseballAuto
    baseballAuto.reload()
    Reload
return 

#include src\mode\TestFunction.ahk

