Class AutoLogger{

    baseDirectory:="Logs"

    __NEW( module , modulePath = "" ){
        this.module:=module
        this.directory:=modulePath
        this.checkDay:=""

        FormatTime, todayString, %A_NOW%, MM월dd일
        ; this.checkDay:=todayString

        FileCreateDir, % This.baseDirectory
        if( modulePath != "" ){
            tempDir := % This.baseDirectory "\" this.directory
            FileCreateDir, % tempDir
            this.directory:=tempDir
        }else{
            this.directory:=this.baseDirectory
        }
        this.dayChanged:=false
    }
    isDayChanged(){
        if( this.dayChanged ){
            this.dayChanged:=false
            return true
        }else{
            return false
        }
    }    
    log( content , boolIsDebug:=false) { 
        FormatTime, sFileName, %A_NOW%, MM월dd일
        FormatTime, TimeString, %A_NOW%, HH:mm:ss

        formattedContent:=% "[" TimeString "][" this.module "]: " content "`n"

        FileAppend, %formattedContent%, % this.directory "\log(" sFileName ").txt",UTF-8 

        global BaseballAutoGui
        formattedContent:="[" TimeString "][" this.module "]: " content "`n"

        if( BaseballAutoGui != "" ){
            BaseballAutoGui.guiLog( this.module, "How", formattedContent)
        }

        if( this.module = "Player"){
            if( this.checkDay != sFileName ){ 
                this.checkDay:=sFileName
                this.dayChanged:=true
                ; this.log( "지난 로그파일을 정리하겠습니다.")

                todayString = %A_NOW%
                EnvAdd, todayString, -4, Days

                loop 30
                {
                    EnvAdd, todayString, -1, Days
                    FormatTime, targetFileName, %todayString%, MM월dd일
                    
                    if FileExist(this.directory "\log(" targetFileName ").txt")
                    {
                        FileDelete, % this.directory "\log(" targetFileName ").txt"
                        this.log( "지난 로그 파일 [ \log(" targetFileName ").txt] 을 지웠습니다.")
                    }else{
                        Break
                    }
                
                }
            }
        }

    }

    debug( content ){ 
        FormatTime, sFileName, %A_NOW%, MM월dd일
        FormatTime, TimeString, %A_NOW%, HH:mm:ss

        formattedContent:=% "[" TimeString "][" this.module "]: " content "`n"
        FileAppend, %formattedContent%, % this.directory "\log(" sFileName ").txt", UTF-8
    }

}