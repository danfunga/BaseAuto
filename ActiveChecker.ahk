﻿#SingleInstance, Force
Menu, Tray, Icon, %A_ScriptDir%\Resource\Image\black.png
#include %A_ScriptDir%\src\util\AutoLogger.ahk
#include %A_ScriptDir%\src\util\MC_GameController.ahk

myController := new MC_GameController()
logger:= new AutoLogger( "CHECKER","checker" )
myAutoTitle := "MC - baseball"
managerTitle := "ahk_class LDRemoteLoginFrame"
managerPopupTitle := "ahk_class MessageBoxWindow"
Looping_:=true

restartAppPlayer(){
    global myController, managerTitle, logger, managerPopupTitle, Looping_
    logger.log("[큰일] App player를 재기동 해야 겠습니다.")

    myController.setActiveId(managerTitle)
    if ( not (myController.checkAppPlayer())) {
        logger.log("Checker: 매니저가 실행 중이지 않습니다. 난 의미가 없습니다.")
        Looping_:=false
        return false
    }
    logger.log("Checker: 매니저로 종료를 진행합니다.")
    if (myController.searchAndClickFolder("1.공통\버튼_앱강제종료\버튼_LD매니저_종료")) {
        logger.log("Checker: 종료 버튼을 눌렀습니다.") 
        myController.setActiveId(managerPopupTitle)
        if (myController.searchImageFolder("1.공통\버튼_앱강제종료\버튼_LD매니저_종료\화면_알림확인")) {
            logger.log("Checker: 알림 팝업이 떴어요.") 
            if (myController.searchAndClickFolder("1.공통\버튼_앱강제종료\버튼_LD매니저_종료\화면_알림확인\버튼_확인")) {
                logger.log("Checker: 확인을 눌렀고, 종료를 기다립니다..(3초)") 
                myController.sleep(3)
                myController.setActiveId(managerTitle)
                logger.log("Checker:매니저로 다시 실행을 해봅니다.")
                if (myController.searchAndClickFolder("1.공통\버튼_앱강제종료\버튼_LD매니저_종료\화면_알림확인\버튼_확인\버튼_실행")) {
                    logger.log("Checker: 자 다시 실행 버튼을 눌렀습니다. 리붓 딜레이 대기합니다.")
                    myController.sleep(15)
                    return true
                }
            }
        }
    }else{ 
        logger.log("Checker: 혹시.. 대기중일 수 있다. 실행이 대기중일수 있다.")
        if (myController.searchAndClickFolder("1.공통\버튼_앱강제종료\버튼_LD매니저_종료\화면_알림확인\버튼_확인\버튼_실행")) {
            logger.log("Checker: 자 다시 실행 버튼을 눌렀습니다. 리붓 딜레이 대기합니다.")
            myController.waitDelayForReboot()
            logger.log("Checker: 매니저로 정상 재기동이 되었기를 ...")
            return true
        }
    }
}
logger.log("Checker: 동작을 시작합니다.")
while(Looping_){
    ; Auto TItle로 Set하고
    myController.setActiveId(myAutoTitle)     
    autoHandle:=myController.checkAppPlayer()
    if ( autoHandle ){ 
        result := DllCall("IsHungAppWindow", "ptr", autoHandle)
        if (result) {
            logger.log("Checker: Auto가 응답 없음 상태입니다.")           
            if( restartAppPlayer() ){ 
                Menu, Tray, Icon, %A_ScriptDir%\Resource\Image\green.png
                myController.setActiveId(myAutoTitle)
                logger.log("Checker: 종료 했을 수도 있으니 Auto 시작 단축키 고") 
                Send,^{F9}
            }else{
                Menu, Tray, Icon, %A_ScriptDir%\Resource\Image\red.png
            }
        } else {
            ; 정상 일때 로그를 안남기겠으.
            ; logger.log("Checker: Auto가 정상 상태입니다.")
        }
    } else {
        logger.log("Checker: Auto가 없으니 저도 죽을래요.")
        Looping_:=false
    } 
    myController.sleep(60)
}
return

