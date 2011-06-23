; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=2956&highlight=
; Author: Hurga (slightly modified by Andre, updated for PB4.00 by blbltheworm)
; Date: 28. November 2003
; OS: Windows
; Demo: No


  ; Needed to get the actual directory for loading the html file
  path.s = Space(1000)
  GetCurrentDirectory_(1000,@path)

  ; Der Code basiert grundlegend auf Teilen, die ich aus dem Codearchiv habe. 
  ; der Rest ist Coded bei Hurga 
  ; Ich habe versucht, aus dem WebGadget einen einfahcen HIlfe-Browser zu schreiben. 
  ; Ich hätte gerne noch ne Suchfunktion eingebaut, habe dazu aber nichts gefunden. 
  ; zum testen solltet ihr ein htm(l) File in der Procedure OpenHelpWindow und name$ angeben. 
  
  Enumeration 
    #Help_Win 
    #Help_Toolbar 
    #Help_Home 
    #Help_back 
    #Help_forward 
    #Help_copy 
    #Help_Paste 
    #Help_Project 
    #Help_Browser 
    #Help_Find 
    #Help_findButton 
  EndEnumeration 
  Enumeration 1 
    #OLECMDID_OPEN          
    #OLECMDID_NEW          
    #OLECMDID_SAVE          
    #OLECMDID_SAVEAS          
    #OLECMDID_SAVECOPYAS    
    #OLECMDID_PRINT          
    #OLECMDID_PRINTPREVIEW    
    #OLECMDID_PAGESETUP      
    #OLECMDID_SPELL          
    #OLECMDID_PROPERTIES      
    #OLECMDID_CUT            
    #OLECMDID_COPY            
    #OLECMDID_PASTE            
    #OLECMDID_PASTESPECIAL    
    #OLECMDID_UNDO            
    #OLECMDID_REDO              
    #OLECMDID_SELECTALL        
    #OLECMDID_CLEARSELECTION  
    #OLECMDID_ZOOM              
    #OLECMDID_GETZOOMRANGE      
    #OLECMDID_UPDATECOMMANDS    
    #OLECMDID_REFRESH            
    #OLECMDID_STOP              
    #OLECMDID_HIDETOOLBARS    
    #OLECMDID_SETPROGRESSMAX    
    #OLECMDID_SETPROGRESSPOS    
    #OLECMDID_SETPROGRESSTEXT    
    #OLECMDID_SETTITLE            
    #OLECMDID_SETDOWNLOADSTATE  
    #OLECMDID_STOPDOWNLOAD    
    #OLECMDID_ONTOOLBARACTIVATED 
    #OLECMDID_FIND              
    #OLECMDID_DELETE            
    #OLECMDID_HTTPEQUIV        
    #OLECMDID_HTTPEQUIV_DONE    
    #OLECMDID_ENABLE_INTERACTION 
    #OLECMDID_ONUNLOAD          
    #OLECMDID_PROPERTYBAG2      
    #OLECMDID_PREREFRESH        
    #OLECMDID_SHOWSCRIPTERROR 
    #OLECMDID_SHOWMESSAGE      
    #OLECMDID_SHOWFIND        
    #OLECMDID_SHOWPAGESETUP    
    #OLECMDID_SHOWPRINT        
    #OLECMDID_CLOSE          
    #OLECMDID_ALLOWUILESSSAVEAS 
    #OLECMDID_DONTDOWNLOADCSS 
    #OLECMDID_UPDATEPAGESTATUS 
    #OLECMDID_PRINT2 
    #OLECMDID_PRINTPREVIEW2 
    #OLECMDID_SETPRINTTEMPLATE 
    #OLECMDID_GETPRINTTEMPLATE 
  EndEnumeration 
  Enumeration 
    #OLECMDEXECOPT_DODEFAULT    
    #OLECMDEXECOPT_PROMPTUSER    
    #OLECMDEXECOPT_DONTPROMPTUSER 
    #OLECMDEXECOPT_SHOWHELP    
  EndEnumeration 
  
  
  
  Procedure OpenHelpWindow(name$) 
    Shared path
    width.l = 768 
    height.l = 532 
    name$ = "file://"+path+"\Test.html" 

    If OpenWindow(#Help_Win, 100, 100, width, height, "Offline WebBrowser", #PB_Window_SystemMenu | #PB_Window_MinimizeGadget | #PB_Window_SizeGadget | #PB_Window_MaximizeGadget) 
      If CreateGadgetList(WindowID(#Help_Win))  
        ToolBarId.l=CreateToolBar(#Help_Toolbar,WindowID(#Help_Win)) 
        GetClientRect_(ToolBarId,rect.RECT) 
        ToolBarHeight=rect\bottom+GetSystemMetrics_(#SM_CYEDGE) 
        ToolBarStandardButton(#Help_Home,#PB_ToolBarIcon_New) 
        ToolBarSeparator() 
        ToolBarStandardButton(#Help_back,#PB_ToolBarIcon_Undo) 
        ToolBarStandardButton(#Help_forward,#PB_ToolBarIcon_Redo) 
        ToolBarSeparator() 
        ToolBarStandardButton(#Help_copy,#PB_ToolBarIcon_Copy) 
        ToolBarStandardButton(#Help_Paste,#PB_ToolBarIcon_Paste) 
        ToolBarStandardButton(#Help_Project,#PB_ToolBarIcon_Properties) 
        
        ToolBarToolTip(#Help_Toolbar,#Help_Home,"") 
        ToolBarToolTip(#Help_Toolbar,#Help_back,"") 
        ToolBarToolTip(#Help_Toolbar,#Help_forward,"") 
        ToolBarToolTip(#Help_Toolbar,#Help_copy,"") 
        ToolBarToolTip(#Help_Toolbar,#Help_Paste,"") 
        ToolBarToolTip(#Help_Toolbar,#Help_Project,"") 
        
        WebGadget(#Help_Browser, 0, 30, width, height - 30, name$) 
      Else 
        ProcedureReturn #False 
      EndIf 
    Else 
      ProcedureReturn #False 
    EndIf 
    ProcedureReturn #True 
  EndProcedure 
  
  Procedure RefreshHelpWindow(width.l, height.l) 
    Protected CLWidth.l 
    ;Überprüfung auf Breite der ComboBox 
    CLWidth = 320 
    MinClWidth = 100 
    If width - 325 < 150 : CLWidth = width - 155 : EndIf 
    If CLWidth < MinClWidth : width = MinClWidth + 155 : EndIf 
    ;Überprüfung auf Höhe des WebGadgets 
    MinWGHeight = 40 
    If height - 48 < MinWGHeight : height = MinWGHeight + 48 : EndIf 
    ResizeWindow(#Help_Win,#PB_Ignore,#PB_Ignore,width, height) 
    ;    ResizeGadget(#Help_find, width - CLWidth - 5, -1, CLWidth, -1) 
    ResizeGadget(#Help_Browser,#PB_Ignore,#PB_Ignore, width, height - 48) 
  EndProcedure 
  
  
  width.l = 768 
  height.l = 532 
  OpenHelpWindow("") ; eigentlich der Name der Hilfspage 
  
  sNum.l = -1 
  Repeat 
    EventID.l = WaitWindowEvent() 
    
    If WindowHeight(#Help_Win) <> height Or WindowWidth(#Help_Win) <> width 
      width = WindowWidth(#Help_Win) 
      height = WindowHeight(#Help_Win) 
      RefreshHelpWindow(width, height) 
    EndIf 
    
    ; URL überprüfen 
    a$ = GetGadgetText(#Help_Browser) 
    ; wenn in der url vorkommt, Toolbarbutton Project aktivieren 
    If StringField(a$, 2, ".") = "dba" 
      DisableToolBarButton(#Help_Win,#Help_Project, 0) 
    Else 
      DisableToolBarButton(#Help_Win,#Help_Project, 1) 
    EndIf 
    
    Select EventID 
      Case #PB_Event_Menu 
        Select EventMenu() 
          Case #Help_Home 
            ; Mainpage aufrufen 
          Case #Help_back 
            SetGadgetState(#Help_Browser, #PB_Web_Back) 
          Case #Help_forward 
            SetGadgetState(#Help_Browser, #PB_Web_Forward) 
          Case #Help_copy 
            ; Kopieren Inhalt ins Clipboard 
          Case #Help_Paste 
            help_tofind$ = InputRequester("Search For...", "Input Item to search for", "") 
            WebObject.IWebBrowser2 = GetWindowLong_(GadgetID(#Help_Browser), #GWL_USERDATA) 
            WebObject\ExecWB(#OLECMDID_COPY, #OLECMDEXECOPT_DONTPROMPTUSER, 0, 0) 
            ; Kopiere INhalt ins Clipboard und füge in Quelltext ein 
        EndSelect 
    EndSelect 
  Until EventID = #PB_Event_CloseWindow 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; EnableXP
; DisableDebugger
