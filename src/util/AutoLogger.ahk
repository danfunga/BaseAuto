Class AutoLogger{

    baseDirectory:="Logs"

    __NEW( module , modulePath = "" ){
        this.module:=module
        this.directory:=modulePath

        FileCreateDir, % This.baseDirectory
        if( modulePath != "" ){
            tempDir := % This.baseDirectory "\" this.directory
            FileCreateDir, % tempDir
            this.directory:=tempDir
        }else{
            this.directory:=this.baseDirectory
        }

        this.debug("AutoLogger init....")
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
    }

    debug( content ){ 
        FormatTime, sFileName, %A_NOW%, MM월dd일
        FormatTime, TimeString, %A_NOW%, HH:mm:ss

        formattedContent:=% "[" TimeString "][" this.module "]: " content "`n"
        FileAppend, %formattedContent%, % this.directory "\log(" sFileName ").txt", UTF-8
    }

}