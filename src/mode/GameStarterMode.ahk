#include %A_ScriptDir%\src\mode\0.DefulatGameMode.ahk

Class GameStarterMode extends AutoGameMode{

    __NEW( controller )
    {
        base.__NEW("게임실행", controller)
    }

    checkAndRun(){
        counter:=0
        counter+=this.skipAndroidAds()
        counter+=this.checkGameDown()
        counter+=this.skipPopupAndAds()
        return counter
    }
    
    checkGameDown(){
        if ( this.gameController.searchImageFolder("게임실행모드\Button_GameIcon") ){
            this.player.setStay()
            this.logger.log("컴프야 게임을 실행합니다.: 15초 wait ")
            if( this.gameController.searchAndClickFolder("게임실행모드\Button_GameIcon") ){
                this.gameController.sleep(15)					
                return 1
            } 
        }
        return 0
    }

    skipAndroidAds(){

        if ( this.gameController.searchImageFolder("게임실행모드\Button_AdroidAds") ){
            this.player.setStay() 
            this.logger.log("안드로이드 광고를 클릭합니다.") 
            if( this.gameController.searchAndClickFolder("게임실행모드\Button_AdroidAds") ){
                return 1
            } 
        }
        return 0
    }
    skipPopupAndAds(){
        result:=0
        if ( this.gameController.searchImageFolder("게임실행모드\Button_NoMoreAds") ){
            this.player.setStay()
            this.logger.log("팝업 광고 등을 취소합니다..") 
            if ( this.gameController.searchAndClickFolder("게임실행모드\Button_NoMoreAds") = true ){
                result+=1
                result+=this.skipPopupAndAds()			
            }		
        }
        return result
    }
    goBackward(){

        this.gameController.clickESC()
        this.logger.log(this.player.getAppTitle() " 뒤로가기 - ESC ") 
        this.gameController.sleep(3)
    
    }
}