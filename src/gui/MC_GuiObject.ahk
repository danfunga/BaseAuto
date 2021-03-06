﻿class MC_GuiObj
{
    __new(Name) {
        This.Name := Name
        This.Title := "MC - " Name
        This.Controls := Object()
        This.DataControls := Object()
        Gui, % This.Name ":+LastFound"
        This.Hwnd := WinExist()
        This.SetMargins(), This.SetFont()
    }

    Add(CtrlType, CtrlText:="", Options:="", Label:="", DataControl:=1) 
    {
        if(Label="")
            Label := RegExReplace(CtrlText, "[^A-z0-9_]")
        else Label := RegExReplace(Label, "[^A-z0-9_]")

        Gui, % This.Name ":Default"

        if( options = "T" ){		
            options:="xp+10 yp+20 h15"
        }else if( options = "B" ){
            if( CtrlType = "Edit"){
                options:="xp y+2 wp hp"
            }else if(CtrlType ="ComboBox"){
                options:="xp y+2 wp"
            }
            else{
                options:="xp y+10 wp hp"
            }
        }

        if(CtrlType="ListView")
            This.Controls[Label] := new LV_GuiCtrlObj(This, CtrlType, CtrlText, Options, Label)
        else 
            This.Controls[Label] := new GuiCtrlObj(This, CtrlType, CtrlText, Options, Label)

        if(DataControl=1)
            This.DataControls[Label] := This.Controls[Label]
    }

    addGroupBox( CtrlText, posX, posY, width, height,Label:="", newPos:=true ){
        if(Label="")
            Label := RegExReplace(CtrlText, "[^A-z0-9_]")
        else Label := RegExReplace(Label, "[^A-z0-9_]")

        Gui, % This.Name ":Default"

        if( newPos ){
            Options=% "x" posX " y" posY " w" width " h" height	" +section"
        }else{
            Options=% "xp+" posX " yp+" posY " w" width " h" height	" +section"
        }		

        This.Controls[Label] := new GuiCtrlObj(This, "GroupBox", CtrlText, Options, Label)
    }

    AddTextField(CtrlType, LabelText, FieldText:="", Width:="", TextOptions:="", FieldOptions:="", DataControl:=1) {
        ; This.Add("Text", LabelText, "+Section w" Width " " TextOptions,, DataControl)
        This.Add(CtrlType, FieldText, "w" Width " " FieldOptions, LabelText, DataControl)
    }

    ClearContents() { 
        for Name, CtrlObj in This.DataControls
            CtrlObj.SetText()
    }

    CheckForContents() { 
        for Name, CtrlObj in This.DataControls
            if(CtrlObj.GetText()!="")
            return 1
        return 0
    }

    Activate() { 
        WinActivate % "ahk_id " This.Hwnd
    }

    Show(Options:="") {
        if(This.GuiX!="" and This.GuiY!="")
            Gui, % This.Name ":Show", % Options " x" This.GuiX " y" This.GuiY, % This.Title
        else
            Gui, % This.Name ":Show", % Options, % This.Title
    }

    Hide() {
        Gui, % This.Name ":Hide"
    }

    Minimize() { 
        WinMinimize % "ahk_id " This.Hwnd
    }

    SetTitle(NewTitle:="") {
        This.Title := "MC - " This.Name
        This.Title := This.Title NewTitle
        Gui, % This.Name ":Show",, % This.Title
        return
    }
    getTitle(){
        return this.Title	
    }

    getName(){
        return this.Name
    }

    SetMargins(X:=4, Y:=4) {
        Gui, % This.Name ":Margin", %X%, %Y%
    }

    SetFont(Size:=10, Font:="", Options:="") {
        Gui, % This.Name ":Font", s%Size% %Options%, %Font%
    }

    SetOptions(Options) { 
        Gui, % This.Name ":" Options
    }

    SetCoords(X, Y) { 
        This.GuiX := X
        This.GuiY := Y
    }

    SetPos(X, Y) {
        DetectHiddenWindows, On
        WinMove, % "ahk_id " This.Hwnd,, % x, % y
        DetectHiddenWindows, Off
    }

}

class GuiCtrlObj {
    __new(Parent, CtrlType, CtrlText, Options, Label) {
        This.Parent := Parent
        This.Type := CtrlType
        This.Text := CtrlText
        This.Label := Label
        This.Options := Options " Hwnd" This.Label "Hwnd"
        This.Install()
    }

    Install() {
        if This.Type="Text" 
            Gui, Add, Text, % "0x200 " This.Options, % This.Text
        else if This.Type="Picture"
            Gui, Add, Picture, % This.Options, % This.Text
        else if This.Type="Edit"
            Gui, Add, Edit, % This.Options, % This.Text
        else if This.Type="logEdit"
        {
            Gui, font, s7, Verdana
            Gui, Add, Edit, % This.Options 
            Gui, font, 
        }
        else if This.Type="ComboBox"
            Gui, Add, ComboBox, % This.Options, % This.Text
        else if This.Type="Button"
            Gui, Add, Button, % This.Options, % This.Text
        else if This.Type="ListView"
            Gui, Add, ListView, % This.Options " -LV0x10 -Multi +AltSubmit", % This.Text
        else if This.Type="ListBox"
            Gui, Add, ListBox, % This.Options, % This.Text
        else if This.Type="CheckBox"
            Gui, Add, CheckBox, % This.Options, % This.Text			
        else if This.Type="Picture"
            Gui, Add, Picture, % This.Options, % This.Text			
        else if This.Type="GroupBox"
        {
            Gui, font,CRed 
            Gui, Add, GroupBox, % This.Options, % This.Text			
            Gui, font, 
        }

        HwndRef := This.Label "Hwnd"
        This.Hwnd := %HwndRef%
    }

    BindMethod(Binding) {
        GuiControl, +G, % This.Hwnd, % Binding
    }
    Get(){		
        GuiControlGet, value, , % this.hwnd
        return value
    }
    Set( value){		
        GuiControl, , % this.hwnd, % value
    }

    GetText() {
        ControlGetText, T,, % "ahk_id " This.Hwnd
        return T
    }

    hide(){
        GuiControl, hide, % this.hwnd

    }

    show(){
        GuiControl, show, % this.hwnd
    }
    SetText(T:="") {
        ControlSetText,, % T, % "ahk_id " This.Hwnd
    }
    select(Select:="") { 
        if(Select!="")
            GuiControl, Choose, % This.Hwnd, % Select 
    }
    SetSelect(Set, Select:="") {
        if IsObject(Set)
            Set := Set.Call()
        GuiControl,, % This.Hwnd, % "|" Set
        if(Select!="")
            GuiControl, Choose, % This.Hwnd, % Select 
    }

    ShowDropDown() { 
        Control, ShowDropDown,,, % "ahk_id " This.Hwnd
    }

    HideDropDown() { 
        Control, HideDropDown,,, % "ahk_id " This.Hwnd
    }

    Focus() {
        ControlFocus,, % "ahk_id " This.Hwnd
    }

    IsFocused() { 
        ControlGetFocus, RetVal, % "ahk_id " This.Parent.Hwnd
        Gui, % This.Parent.Name ":Default"
        GuiControlGet, RetVal2, Hwnd, % RetVal
        if(RetVal2=This.Hwnd)
            return 1
        return 0
    }

    SetOptions(Option) {
        GuiControl, %Option%, % This.Hwnd
    }

    Restyle(BGColor:="", TextColor:="", FontOptions:="", Text:="") {
        if(BGColor="") { 
            This.SetColor()
            This.Parent.SetFont(,, "Normal")
            GuiControl, Font, % This.Hwnd
            return
        }

        This.SetColor(BGColor, TextColor)
        This.SetText(Text)

        This.Parent.SetFont(,, FontOptions)
        GuiControl, Font, % This.Hwnd
        This.Parent.SetFont(,, "Normal")
    }

    SetColor(Background:="", Foreground:="") {
        if(Background="" and Foreground="")
            CtlColors.Detach(This.Hwnd)
        else CtlColors.Change(This.Hwnd, Background, Foreground)
        }
}

class LV_GuiCtrlObj extends GuiCtrlObj
{
    __call(Method, Params*) { 
        Gui, % This.Parent.Name ":Default"
    }

    LV_Add(Options, Cols*) {
        LV_Add(Options, Cols*)
    }

    LV_ModifyCol(Col, Options) { 
        LV_ModifyCol(Col, Options)
    }

    LV_GetText(Row, Col) { 
        LV_GetText(RetVal, Row, Col)
        return RetVal
    }

    LV_Modify(Row, OptionCols*) { ; have to do it like this, otherwise can't set only options because it expects 3 params (see SetIcons() in payments)
        LV_Modify(Row, OptionCols*)
    }

    LV_Select(Row) {
        if(Row=0) { 
            LV_Modify(1, "Select"), LV_Modify(1, "Focus"), LV_Modify(1, "-Select"), LV_Modify(1, "-Focus")
            return
        } else LV_Modify(Row, "Select"), LV_Modify(Row, "Focus") 
    }

    LV_GetCount(Options:="") { 
        return LV_GetCount(Options)
    }

    LV_LookupRow(LookupValue, Col) {
        Loop % This.LV_GetCount() { 
            FoundText := This.LV_GetText(A_Index, Col)
            if(LookupValue=FoundText)
                return A_Index
        }
        return 0
    }

    LV_Delete(Row:="") { 
        if(Row=0 or Row="")
            LV_Delete()
        else LV_Delete(Row)
        }

    LV_ImageSetup(Size) { 
        This.LVImageList := IL_Create(Size)
        LV_SetImageList(This.LVImageList)
    }

    LV_ImageAdd(File, Index:="") { 
        IL_Add(This.LVImageList, File, Index)
    }
}