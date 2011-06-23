; English forum: http://www.purebasic.fr/english/viewtopic.php?t=14358&highlight=
; Author: Kale (updated for PB 4.00 by Andre)
; Date: 13. March 2005
; OS: Windows
; Demo: Yes


; Append a string to a exe like this: 
; (the string can be read again with the example StringReader.pb)

;=========================================================================== 
;-CONSTANTS 
;=========================================================================== 

#APP_NAME = "String Appender v1.0" 

Enumeration 
    #WINDOW_ROOT 
    #STATUSBAR_ROOT 
    #STRING_STRING 
    #TEXT_FILE 
    #BUTTON_FILE 
    #BUTTON_APPEND 
EndEnumeration 

;=========================================================================== 
;-GLOBAL FLAGS / VARIABLES / STRUCTURES / ARRAYS 
;=========================================================================== 

Global File.s 

;=========================================================================== 
;-PROCEDURES 
;=========================================================================== 

;Handle an error 
Procedure HandleError(Result, Text.s) 
    If Result = 0 : MessageRequester("Error", Text, #PB_MessageRequester_Ok) : End : EndIf 
EndProcedure 

;handle opening a file 
Procedure OpenFileForAppending() 
    File = OpenFileRequester(#APP_NAME, "", "Executable (*.exe) | *.exe", 0) 
    SetGadgetText(#TEXT_FILE, File) 
EndProcedure 

;handle appending the string 
Procedure AppendString() 
    StringToAppend.s = GetGadgetText(#STRING_STRING) 
    StringLength.l = Len(StringToAppend) 
    If File <> "" 
        HandleError(OpenFile(1, File), "Could not open " + File) 
        LengthOfFile.l = Lof(1) 
        *FileStart.l = AllocateMemory(LengthOfFile + StringLength + 4) ; + 4 at the end is the long holding the size info. 
        If *FileStart 
            ReadData(1, *FileStart, LengthOfFile) 
            CloseFile(1) 
            CopyMemory(@StringToAppend, *FileStart + LengthOfFile, StringLength) 
            PokeL(*FileStart + LengthOfFile + StringLength, StringLength) 
            HandleError(CreateFile(1, GetPathPart(File) + "File with appended string.exe"), "File could not be created.") 
            WriteData(1, *FileStart, LengthOfFile + StringLength + 4) 
            CloseFile(1) 
        Else 
            MessageRequester("Error", "Memory could not be allocated.") 
        EndIf 
    Else 
        MessageRequester("Error", "Please Select a file.") 
    EndIf 
EndProcedure 

;=========================================================================== 
;-GEOMETRY 
;=========================================================================== 

HandleError(OpenWindow(#WINDOW_ROOT, 0, 0, 400, 280, #APP_NAME, #PB_Window_SystemMenu | #PB_Window_ScreenCentered), "Main window could not be created.") 
HandleError(CreateGadgetList(WindowID(#WINDOW_ROOT)), "Gadget list for the main window could not be created.") 
    StringGadget(#STRING_STRING, 5, 5, 390, 200, "Type string to be appended here.", #ES_MULTILINE | #ES_AUTOVSCROLL | #WS_VSCROLL | #ESB_DISABLE_BOTH) 
    TextGadget(#TEXT_FILE, 5, 210, 305, 45, "", #PB_Text_Border) 
    ButtonGadget(#BUTTON_FILE, 315, 210, 80, 21, "Select File") 
    ButtonGadget(#BUTTON_APPEND, 315, 235, 80, 21, "Append String") 
    HandleError(CreateStatusBar(#STATUSBAR_ROOT, WindowID(#WINDOW_ROOT)), "Statusbar could not be created.") 
    
;=========================================================================== 
;-MAIN LOOP 
;=========================================================================== 

Repeat 
    EventID.l = WaitWindowEvent() 
    Select EventID 
        Case #PB_Event_Gadget 
            Select EventGadget() 
                Case #BUTTON_FILE 
                    OpenFileForAppending() 
                Case #BUTTON_APPEND 
                    AppendString() 
            EndSelect 
    EndSelect 
Until EventID = #PB_Event_CloseWindow 
End 
; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -