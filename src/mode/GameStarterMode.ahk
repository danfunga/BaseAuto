#include %A_ScriptDir%\src\mode\0.DefulatGameMode.ahk

Class GameStarterMode extends AutoGameMode{

    __NEW( controller )
    {
        base.__NEW("게임실행", controller)
    }

    initMode(){
        this.addAction(this.skipAndroidAds)
        this.addAction(this.checkGameDown)
        this.addAction(this.checkWorngLoginPage)
        this.addAction(this.skipPopupAndAds)
    }

    checkGameDown(){
        if ( this.gameController.searchImageFolder("게임실행모드\Button_GameIcon") ){
            this.continueControl()
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
            this.continueControl() 
            this.logger.log("안드로이드 광고를 클릭합니다.") 
            if( this.gameController.searchAndClickFolder("게임실행모드\Button_AdroidAds") ){
                return 1
            } 
        }
        return 0
    }

    checkWorngLoginPage(){        
        if ( this.gameController.searchImageFolder("1.공통\화면_잘못들옴") ){
            this.continueControl()
            this.logger.log("이상한 page에 들어왔으면 ESC를 누릅시다.") 
            ; 이걸로 인해 무한 루프가 안되도록 0을 리턴하자
            this.goBackward()
        }
        return 0
    }
    skipPopupAndAds(){
        result:=0
        if ( this.gameController.searchImageFolder("게임실행모드\Button_NoMoreAds") ){
            this.continueControl()
            this.logger.log("팝업 광고 등을 취소합니다..") 
            if ( this.gameController.searchAndClickFolder("게임실행모드\Button_NoMoreAds") = true ){
                result+=1
                result+=this.skipPopupAndAds()			
            }		
        }
        return result
    }

}