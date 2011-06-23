; English forum: http://www.purebasic.fr/english/viewtopic.php?t=7698
; Author: blueb (updated for PB 4.00 by Andre)
; Date: 29. September 2003
; OS: Windows
; Demo: Yes


; Works For the Tsunami Record Manager - TRMPRO.DLL and TRM.DLL (free version) 
; Version 3.3 ... 2002-09-02 
; the demo sample data and the Tsunami.DLL can be downloaded from: http://www.trm-ug.com 

Structure TsunamiStructure 
    op.l        ; Tsunami operation number 
    file.l      ; Tsunami file handle 
    dataptr.l   ; Address of data buffer 
    datalen.l   ; Length of data buffer 
    keyptr.l    ; Address of key buffer 
    keylen.l    ; Length of key buffer 
    keyno.l     ; Key number 
EndStructure 

Define.TsunamiStructure Tsu 

  #CASE_SENSITIVE = 1 
  #NO_DUPLICATES  = 2 
  #NO_COMPRESSION = 4 
  #BINARY_KEY     = 8 
; 
  #KEY_ONLY = 16384 
;  
  #REBUILD_IDS = 2 

;The following EQUATES (constants) represent the Tsunami 
; operation codes (Op) used with the pointer-based APIs... 

#Tsu_Accelerate        = 32 
#Tsu_Close             =  1 
#Tsu_CloseAll          = 28 
#Tsu_Count             = 17 
#Tsu_Create            = 14 
#Tsu_CurrKeyPos        = 45 
#Tsu_Delete            =  4 
#Tsu_FileIsOpen        = 16 
#Tsu_FileMaxIncr       = 41 
#Tsu_FileSize          = 18 
#Tsu_Flush             = 27 
#Tsu_FlushAll          = 29 
#Tsu_GetByKeyPos       = 44 
#Tsu_GetDirect         = 23 
#Tsu_GetEqual          =  5 
#Tsu_GetEqualOrGreater =  9 
#Tsu_GetEqualOrLess    = 11 
#Tsu_GetFileDef        = 36 
#Tsu_GetFileVer        = 25 
#Tsu_GetFirst          = 12 
#Tsu_GetGreater        =  8 
#Tsu_GetLast           = 13 
#Tsu_GetLess           = 10 
#Tsu_GetNext           =  6 
#Tsu_GetPosition       = 22 
#Tsu_GetPrev           =  7 
#Tsu_Insert            =  2 
#Tsu_Integrity         = 37 
#Tsu_Open              =  0 
#Tsu_Rebuild           = 38 
#Tsu_Recover           = 39 
#Tsu_SetEncryptionKey  = 40 
#Tsu_SetKeyPath        = 30 
#Tsu_StepFirst         = 33 
#Tsu_StepLast          = 34 
#Tsu_StepNext          = 24 
#Tsu_StepPrev          = 35 
#Tsu_TimeOut           = 31 
#Tsu_Update            =  3 
#Tsu_Version           = 26 
;End of Tsunami Include Information 

If OpenLibrary(0, "TRM.DLL") = 0 
    MessageRequester("Error", "Sorry, Can't find the Database Engine", 0) 
    End 
EndIf 

;- Window Constants 
#FORM1 = 0 

;- Gadget Constants 
#BTN_QUIT = 0 
#BTN_FIRST = 1 
#BTN_PREV = 2 
#BTN_NEXT = 3 
#BTN_LAST = 4 
#ACCTNO = 5 
#LNAME = 6 
#FNAME = 7 
#MI = 8 
#STREET = 9 
#CITY = 10 
#STATE = 11 
#ZIP = 12 
#sACCTNO = 13 
#sLNAME = 14 
#sFNAME = 15 
#sMI = 16 
#sSTREET = 17 
#sCITY = 18 
#sSTATE = 19 
#sZIP = 20 
#lHEADING = 21 


;- Global Declarations 
Global FontID1.l 
Global FontID2.l 

FontID1 = LoadFont(1, "Arial Narrow", 11, #PB_Font_Bold) 
FontID2 = LoadFont(2, "Arial Bold", 14, #PB_Font_Underline) 

; Open the database file 
      FileName$="TRMDEMO.DAT" ;Find the Tsunami DEMO file and place in this directory! 
      Tsu\op = #tsu_Open 
      Tsu\keyptr = @FileName$ 
      Tsu\keylen = Len(FileName$) 
      Tsu\keyno = 0 ; single user 
      Result = CallFunction(0, "trm_udt", @Tsu) 
            
If result <> 0 
    MessageRequester("Error", "Sorry, Can't find the data file", 0) 
    End 
EndIf 
      
; Locate the first record        
      Recd$=Space(200) ; Must be at least as large as Tsunami record (in this case 200 bytes) 
      Tsu\op = #tsu_GetFirst 
      Tsu\dataptr = @Recd$ 
      Tsu\datalen = Len(Recd$) 
      Tsu\keyno = 1 ;Current index number 
      Result = CallFunction(0, "trm_udt", @Tsu) 
; ----------------------------------- 

Procedure.s RefreshData(Recd$) 
; Parses the 200 byte record string - (there is 92 bytes of 'dead space' after the ZIP code field) 

        ACCTNO.s = Trim(Mid(Recd$,  1,  6))  ; from byte position 1...to byte position 6 
        LNAME.s = Trim(Mid(Recd$,  7,  24))  ; etc. 
        FNAME.s = Trim(Mid(Recd$,  31,  18))  
        MI.s = Trim(Mid(Recd$,  49,  1)) 
        STREET.s = Trim(Mid(Recd$,  50,  30)) 
        CITY.s = Trim(Mid(Recd$,  80, 16)) 
        STATE.s = Trim(Mid(Recd$,  96,  2)) 
        ZIP.s = Trim(Mid(Recd$,  98,  10)) 
        ;not necessary...only for demonstration purposes 
        DEADSPACE.s = Trim(Mid(Recd$,  108,  92)) 
        

        SetGadgetText(#sACCTNO, ACCTNO) 
        SetGadgetText(#sLNAME, LNAME) 
        SetGadgetText(#sFNAME, FNAME) 
        SetGadgetText(#sMI, MI) 
        SetGadgetText(#sSTREET, STREET) 
        SetGadgetText(#sCITY, CITY) 
        SetGadgetText(#sSTATE, STATE) 
        SetGadgetText(#sZIP, ZIP) 
   ProcedureReturn Recd$ 
EndProcedure 
; ---------------------------------------- 

Procedure Open_FORM1() 
  If OpenWindow(#FORM1, 0, 0, 430, 320, "PureBasic - Tsunami Test #1", #PB_Window_SystemMenu | #PB_Window_TitleBar | #PB_Window_ScreenCentered | #PB_Window_WindowCentered) 
    If CreateGadgetList(WindowID(0)) 
      ButtonGadget(#BTN_QUIT, 330, 270, 80, 30, "Quit") 
      ButtonGadget(#BTN_FIRST, 170, 270, 30, 30, "<<") 
      SetGadgetFont(#BTN_FIRST, FontID1) 
      ButtonGadget(#BTN_PREV, 200, 270, 30, 30, "<") 
      SetGadgetFont(#BTN_PREV, FontID1) 
      ButtonGadget(#BTN_NEXT, 230, 270, 30, 30, ">") 
      SetGadgetFont(#BTN_NEXT, FontID1) 
      ButtonGadget(#BTN_LAST, 260, 270, 30, 30, ">>") 
      SetGadgetFont(#BTN_LAST, FontID1) 
      TextGadget(#ACCTNO, 80, 70, 70, 20, "Account No:", #PB_Text_Right) 
      TextGadget(#LNAME, 80, 95, 70, 20, "Last Name:", #PB_Text_Right) 
      TextGadget(#FNAME, 80, 120, 70, 20, "First Name:", #PB_Text_Right) 
      TextGadget(#MI, 80, 140, 70, 20, "MI:", #PB_Text_Right) 
      TextGadget(#STREET, 80, 170, 70, 20, "Street:", #PB_Text_Right) 
      TextGadget(#CITY, 80, 195, 70, 20, "City:", #PB_Text_Right) 
      TextGadget(#STATE, 80, 220, 70, 20, "State:", #PB_Text_Right) 
      TextGadget(#ZIP, 80, 245, 70, 20, "Zip:", #PB_Text_Right) 
      StringGadget(#sACCTNO, 160, 65, 140, 25, "") 
      StringGadget(#sLNAME, 160, 90, 140, 25, "") 
      StringGadget(#sFNAME, 160, 115, 140, 25, "") 
      StringGadget(#sMI, 160, 140, 140, 25, "") 
      StringGadget(#sSTREET, 160, 165, 140, 25, "") 
      StringGadget(#sCITY, 160, 190, 140, 25, "") 
      StringGadget(#sSTATE, 160, 215, 140, 25, "") 
      StringGadget(#sZIP, 160, 240, 140, 25, "") 
      TextGadget(#lHEADING, 75, 15, 290, 40, "View 'TRMDemo.Dat' File", #PB_Text_Center) 
      SetGadgetFont(#lHEADING, FontID2) 
    EndIf 
  EndIf 
EndProcedure 
; ------------------------------------------------- 


Open_FORM1() 
RefreshData(Recd$) ; Display Record #1 


;- Message Loop 
;  ----------------------------------------------- 
Repeat 
  
  Event = WaitWindowEvent() 
  
  If Event = #PB_Event_Gadget 

    GadgetID = EventGadget() 
    
    If GadgetID = #BTN_QUIT 
        CloseLibrary(0) 
        End ; Quit 
            
    ElseIf GadgetID = #BTN_FIRST        ; Goto first record 
          
          Tsu\op = #tsu_GetFirst 
          Tsu\dataptr = @Recd$ 
          Tsu\datalen = Len(Recd$) 
          Tsu\keyno = 1 ;Current index number 
          Result = CallFunction(0, "trm_udt", @Tsu) 
          RefreshData(Recd$) 
      
    ElseIf GadgetID = #BTN_PREV         ; Goto previous record 
          
          Tsu\op = #tsu_GetPrev 
          Tsu\dataptr = @Recd$ 
          Tsu\datalen = Len(Recd$) 
          Tsu\keyno = 1 ;Current index number 
          Result = CallFunction(0, "trm_udt", @Tsu) 
          RefreshData(Recd$) 

     ElseIf GadgetID = #BTN_NEXT         ; Goto next record 
          
          Tsu\op = #tsu_GetNext 
          Tsu\dataptr = @Recd$ 
          Tsu\datalen = Len(Recd$) 
          Tsu\keyno = 1 ;Current index number 
          Result = CallFunction(0, "trm_udt", @Tsu) 
          RefreshData(Recd$) 
      
    ElseIf GadgetID = #BTN_LAST         ; Goto last record 
          
          Tsu\op = #tsu_GetLast 
          Tsu\dataptr = @Recd$ 
          Tsu\datalen = Len(Recd$) 
          Tsu\keyno = 1 ;Current index number 
          Result = CallFunction(0, "trm_udt", @Tsu) 
          RefreshData(Recd$) 

    EndIf 
    
  EndIf 
  
Until Event = #PB_Event_CloseWindow 

CloseLibrary(0) 
End 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; EnableXP
