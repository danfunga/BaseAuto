#include %A_ScriptDir%\src\util\AutoLogger.ahk
Class StageMode{
    logger:= new AutoLogger( "�����������" ) 
    
    __NEW( controller )
    {
        this.gameController :=controller
    }

    setPlayer( _player )
    {
        this.player:=_player
    }

    checkAndRun()
    {
        counter:=0

        counter+=this.startSpecialMode( )
        counter+=this.selectStageMode( )
        counter+=this.selectStageLevel( )
        counter+=this.startStageMode( )

        counter+=this.skipPlayerProfile( )
        counter+=this.checkPlaying( )
        counter+=this.checkGameResultWindow( )
        counter+=this.checkMVPWindow( )
        counter+=this.checkPopup( )
        counter+=this.checkStageModeClose( )

        if( counter = 0 ){
            counter+=this.moveMainPageForNextJob()
        }
        return counter
    }

    startSpecialMode(){
        if ( this.gameController.searchImageFolder("0.�⺻UI\0.����ȭ��_Base") ){
            this.logger.log(this.player.getAppTitle() "����������带 �����մϴ�!")
            this.player.setStay()
            if ( this.gameController.searchAndClickFolder("0.�⺻UI\0.����ȭ��_��ư_�����_����") ){
                return 1
            }
        }
        return 0
    }

    selectStageMode(){
        if ( this.gameController.searchImageFolder("0.�⺻UI\3.����ȸ��_Base") ){		
            this.player.setStay()
            this.logger.log("�������� ��带 �����մϴ�~") 
            if ( this.gameController.searchAndClickFolder("0.�⺻UI\3.����ȸ��_��ư_�����������") ){
                return 1
            }		 
        }
        return 0		
    }

    selectStageLevel(){
        if ( this.gameController.searchImageFolder("0.�⺻UI\3-3.�����������_Base") ){		
            this.player.setStay()
            this.logger.log("�����մϴ�") 
            if ( this.gameController.searchAndClickFolder("�����������\ȭ��_����") ){
                return 1
            }		 
        }
        return 0	
    }

    startStageMode(){
        if ( this.gameController.searchImageFolder("0.�⺻UI\3-3.�����������_Base") ){		 
            if(this.checkStageModeClose()){
                return 1
            }else{
                this.player.setStay()
                this.logger.log("�������� ��带 �����մϴ�~")
                if ( this.gameController.searchAndClickFolder("1.����\��ư_���ӽ���") ){ 
                    this.logger.log("��� �޾ƺ��� ĸƾ �ȳ��Ȥ�")
                }
                if ( this.gameController.searchAndClickFolder("1.����\��ư_���ӽ���") ){ 
                    this.logger.log("6�� ��ٸ��ϴ�") 
                    this.gameController.sleep(6)
                    return 1
                }		 
            }
        }
        return 0		
    }

    skipPlayerProfile(){
        if ( this.gameController.searchAndClickFolder("�����������\ȭ��_����������") ){		 
            this.player.setStay()
            this.logger.log("�������� ��� ������ Ŭ�� �մϴ�~") 
            this.gameController.sleep(1)
            this.logger.log("�������� ��� ���� ����!!") 
            this.gameController.clickRatioPos(0.5, 0.6, 80)
        }
        return 0		
    }

    checkPopup(counter:=0){
        localCounter:=counter
        if ( this.gameController.searchImageFolder("1.����\��ư_�˾���ŵ" ) ){		
            if( this.gameController.searchAndClickFolder("1.����\��ư_�˾���ŵ" ) ){
                if( localCounter > 5 ){
                    return localCounter
                }
                localCounter++ 
                this.checkPopup(localCounter)
            }
        }
        ; ���� �Ʒ� ����
        if ( this.gameController.searchImageFolder("�����������\ȭ��_�˾�üũ" ) ){		
            this.logger.log("�˾��� �����մϴ�. ������ �ȹ޾ҳ�.") 
            if( this.gameController.searchAndClickFolder("�����������\ȭ��_�˾�üũ\��ư_Ȯ��" ) ){
                if( localCounter > 5 ){
                    return localCounter
                }
                localCounter++ 
                this.checkPopup(localCounter)
            }			
        }
        return localCounter
    }

    checkPlaying(){
        if ( this.gameController.searchImageFolder("�����������\ȭ��_������" ) ){		
            this.player.setStay()
            this.logger.log("����� ���Ͽ�..")
            
        } 
        return 0 
    }

    checkGameResultWindow(){
        if ( this.gameController.searchImageFolder("1.����\ȭ��_���_���" ) ){		
            this.logger.log("��� ���ȭ���Դϴ�..") 
            this.player.setStay()
            if( this.gameController.searchAndClickFolder("1.����\��ư_����_Ȯ��" ) ){ 
                return 1
            }
        }
        return 0 
    }

    checkMVPWindow(){
        if ( this.gameController.searchImageFolder("1.����\ȭ��_MVP" ) ){		
            this.player.setStay()
            this.logger.log("����������� ���Ḧ Ȯ���߽��ϴ�.") 
            if( this.gameController.searchAndClickFolder("1.����\��ư_����_Ȯ��" ) ){
                this.player.addResult()
                if( this.player.needToStopBattle() ){
                    this.logger.log("����������带 Ƚ����ŭ �� ���ҽ��ϴ�.") 
                    this.player.setBye()
                }else{
                    if( this.player.getRemainBattleCount() = "����" ){
                        this.logger.log("�������� ���� �� �������� ���ϴ�." )
                    }else{
                        this.logger.log("�������� ��带 " this.player.getRemainBattleCount() "�� �� ���ϴ�." ) 
                    }                    
                    this.player.setFree()
                }
                return 1
            }
        }
        return 0 
    } 

    checkStageModeClose(){
        if ( this.gameController.searchImageFolder("�����������\ȭ��_������" ) ){		 
            this.logger.log("���� ���°� ���� ����������� �� ���ҳ׿�. ..")
            this.player.setBye()
            return 1
        }
        return 0 
    }

    moveMainPageForNextJob(){
        if ( this.gameController.searchImageFolder("1.����\��ư_Ȩ����" ) ){		
            this.logger.log("���� �ӹ��� ���� ���� ȭ������ ���ϴ�.") 
            if( this.gameController.searchAndClickFolder("1.����\��ư_Ȩ����" ) ){
                this.logger.log("���� ������ �ȵȴ�.") 
                return 1
            }
        }
    }


}
