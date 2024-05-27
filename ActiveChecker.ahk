#SingleInstance, Force
#Persistent

Menu, Tray, Icon, %A_ScriptDir%\Resource\Image\black.png
#include %A_ScriptDir%\src\util\AutoLogger.ahk
#include %A_ScriptDir%\src\util\MC_GameController.ahk
#include %A_ScriptDir%\src\external\Gdip_all.ahk

myController := new MC_GameController()
logger:= new AutoLogger( "CHECKER","checker" )
myAutoTitle := "MC - baseball"버튼_팝업스킵
managerTitle := "ahk_class LDRemoteLoginFrame"
managerPopupTitle := "ahk_class MessageBoxWindow"
Looping_:=true
; gdipAvailable_:=true
debuging_:=false

SetTrayBadge(Number) {
    global logger

    pToken:=Gdip_Startup() 
    if( not pToken){ 
        logger.log("GDIP이 정상 동작 하지 않는다.") 
        Menu, Tray, Icon, %A_ScriptDir%\Resource\Image\green.png
        logger.log("GDIP이 정상 동작 하지 않아 녹색으로만 변경")
        return
    }
    IconSize := 16

    ; 기본 아이콘 생성
    pBitmap := Gdip_CreateBitmap(IconSize, IconSize)
    G := Gdip_GraphicsFromImage(pBitmap)
    Gdip_SetSmoothingMode(G, 4)

    Red := 255 - Round((Min(Number, 10) / 10) * 255) ; 1에서 10까지의 숫자를 0에서 255로 변환하여 빨간색의 R 채널 조절
    Color := (255 << 24) | (255 << 16) |(Red << 8)|Red 

    hBrush := Gdip_BrushCreateSolid(Color)
    Gdip_FillRoundedRectangle(G, hBrush, 0, 0, IconSize, IconSize,5)
    Gdip_DeleteBrush(hBrush)

    Font = Arial
    if( Number > 99 ){
        Options = c00000000 r4 s7 Bold Centre vCenter y2
    }else{
        Options = c00000000 r4 s10 Bold Centre vCenter y2
    }

    Gdip_TextToGraphics(G, Number, Options, Font,IconSize,IconSize)

    ; 아이콘으로 변환
    hIcon := Gdip_CreateHICONFromBitmap(pBitmap)
    Menu, Tray, Icon, % "HICON:" hIcon

    ; 리소스 해제
    Gdip_DeleteGraphics(G) 
    DeleteObject(hIcon)
    Gdip_DisposeImage(pBitmap)

    Gdip_Shutdown(pToken)
}

restartAppPlayer(){
    global myController, managerTitle, logger, managerPopupTitle, Looping_
    logger.log("[큰일] App player를 재기동 해야 겠습니다.")

    myController.setActiveId(managerTitle)
    if ( not (myController.checkAppPlayer())) {
        logger.log("매니저가 실행 중이지 않습니다. 난 의미가 없습니다.")
        return false
    }
    logger.log("매니저로 종료를 진행합니다.")
    if (myController.searchAndClickFolder("1.공통\버튼_앱강제종료\버튼_LD매니저_종료")) {
        logger.log("종료 버튼을 눌렀습니다. (2초)") 
        myController.sleep(2)
        myController.setActiveId(managerPopupTitle)
        if (myController.searchImageFolder("1.공통\버튼_앱강제종료\버튼_LD매니저_종료\화면_알림확인")) {
            logger.log("알림 팝업이 떴어요.") 
            if (myController.searchAndClickFolder("1.공통\버튼_앱강제종료\버튼_LD매니저_종료\화면_알림확인\버튼_확인")) {
                logger.log("확인을 눌렀고, 종료를 기다립니다..(3초)") 
                myController.sleep(3)
                myController.setActiveId(managerTitle)
                logger.log("Checker:매니저로 다시 실행을 해봅니다.")
                if (myController.searchAndClickFolder("1.공통\버튼_앱강제종료\버튼_LD매니저_종료\화면_알림확인\버튼_확인\버튼_실행")) {
                    logger.log("자 다시 실행 버튼을 눌렀습니다. 리붓 딜레이 대기합니다.")
                    myController.sleep(15)
                    return true
                }
            }
        }
    }else{ 
        logger.log("혹시.. 대기중일 수 있다. 실행이 대기중일수 있다.")
        if (myController.searchAndClickFolder("1.공통\버튼_앱강제종료\버튼_LD매니저_종료\화면_알림확인\버튼_확인\버튼_실행")) {
            logger.log("자 다시 실행 버튼을 눌렀습니다. 리붓 딜레이 대기합니다.")
            myController.waitDelayForReboot()
            logger.log("매니저로 정상 재기동이 되었기를 ...")
            return true
        }
    }
    return false
}

logger.log("ActiveChecker가 시작됩니다..")
SetTimer, CheckAppStatus, 60000 ; 60 seconds

CheckAppStatus:
    if (debuging_) {
        logger.log("체크 시작.")
    } 
    myController.setActiveId(myAutoTitle) 
    autoHandle := myController.checkAppPlayer()
    if (autoHandle) { 
        result := DllCall("IsHungAppWindow", "ptr", autoHandle)
        if (result) {
            logger.log("Auto가 응답 없음 상태입니다.") 
            errorcounter++
            SetTrayBadge(errorcounter) 
            if (restartAppPlayer()) { 
                myController.setActiveId(myAutoTitle)
                logger.log("종료 했을 수도 있으니 Auto 시작 단축키 누릅니다") 
                Send,^{F9}
            }
        } else {
            ; 정상 일때 로그를 안남기겠으.
            if (debuging_) {
                logger.log("디버깅: Auto가 정상 상태입니다.")
            }
        }
    } else {
        if(needToQuit){
            logger.log("종료가 확인되었습니다. 종료합니다.")
            ExitApp
        }else{
            needToQuit := true
            logger.log("Auto가 없으니 1분후에 다시 확인하고 종료합니다.")
        } 
    } 
    if (debuging_) {
        logger.log("디버깅: 60초 후에 봅시다") 
    }
return