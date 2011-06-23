; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=1301&highlight=
; Author: Manne (updated for PB4.00 by blbltheworm)
; Date: 10. June 2003
; OS: Windows
; Demo: No


; Werte local oder remote aus der Registry lesen
; Liest REG-SZ oder REG_DWORD local und remote. 

lRetVal.l         ;used To hold Return value For all API calls 

sRemMachName.s    ;used by RegConnectRegistry 
lTopLevelKey.l    ;used by RegConnectRegistry 
lHKeyhandle.l     ;used by RegConnectRegistry & RegOpenKeyEx 

sKeyName.s        ;used by RegOpenKeyEx 
lhkey.l           ;used by RegOpenKeyEx & RegQueryValueEx & RegCloseKey 

sValueName.s      ;used by RegQueryValueEx 
vValue.s          ;used by RegQueryValueEx 
msg.s             ; used to hold errormessage 

; #REG_SZ = 1 
; #REG_DWORD = 4 
; 
; #HKEY_CLASSES_ROOT = $80000000 
; #HKEY_CURRENT_USER = $80000001 
; #HKEY_LOCAL_MACHINE = $80000002 
; #HKEY_USERS = $80000003 
; 
#ERROR_NONE = 0 
; #ERROR_BADDB = 1 
; #ERROR_BADKEY = 2 
; #ERROR_CANTOPEN = 3 
; #ERROR_CANTREAD = 4 
; #ERROR_CANTWRITE = 5 
; #ERROR_OUTOFMEMORY = 6 
; #ERROR_INVALID_PARAMETER = 7 
; #ERROR_ACCESS_DENIED = 8 
; #ERROR_INVALID_PARAMETERS = 87 
; #ERROR_NO_MORE_ITEMS = 259 
; 
; #KEY_ALL_ACCESS = $3F 
; 
; #REG_OPTION_NON_VOLATILE = 0 

Procedure.l SetValueEx(topKey.l, sKeyName.s, sValueName.s, lType.l, vValue.s) 
    lValue.l 
    sValue.s 
    Select lType 
        Case #REG_SZ 
            sValue = vValue 
            size.l = Len(sValue) 
            RegCreateKey_(topKey,sKeyName,@hKey) 
            SetValueEx = RegSetValueEx_(hKey, sValueName, 0, #REG_SZ, @sValue, size) 
        Case #REG_DWORD 
            lValue = Val(vValue) 
            SetValueEx = RegSetValueEx_(hKey, @sValueName, 0, #REG_DWORD, @lValue, 4) 
        EndSelect 
        ProcedureReturn SetValueEx 
EndProcedure 

Procedure.l QueryValueEx(lhkey.l, szValueName.s) 
    Define.l cch, lrc, lType, lValue 
    Define.s sValue
    Shared vValue 
    cch = 255 
    sValue = Space(255) 
    
    ;Determine the size And type of Data To be Read 
    lrc = RegQueryValueEx_(lhkey, szValueName, 0, @lType, 0, @cch) 
        
    Select lType 
        ;For strings 
        Case #REG_SZ 
            lrc = RegQueryValueEx_(lhkey, szValueName, 0, @lType, @sValue, @cch) 
            If lrc = #ERROR_NONE 
                vValue = Left(sValue, cch-1) 
            Else 
                vValue = "Empty" 
            EndIf 
        ;For DWORDS 
        Case #REG_DWORD 
            lrc = RegQueryValueEx_(lhkey, szValueName, 0, @lType, @lValue, @cch) 
            If lrc = #ERROR_NONE 
              vValue = Str(lValue) 
            EndIf 
        Default 
            ;all other Data types not supported 
            lrc = -1 
    EndSelect 
    ProcedureReturn lrc 
EndProcedure 

; PureBasic Visual Designer v3.70a 

;- Window Constants 
; 
#Window_0 = 0 

;- Gadget Constants 
; 
#Gadget_0 = 0 
#Gadget_1 = 1 
#Gadget_2 = 2 
#Gadget_3 = 3 
#Gadget_4 = 4 
#Gadget_5 = 5 
#Gadget_6 = 6 
#Gadget_7 = 7 
#Gadget_8 = 8 
#Gadget_9 = 9 
#Gadget_10 = 10 
#Gadget_11 = 11 

Procedure Open_Window_0() 
  If OpenWindow(#Window_0, 476, 326, 287, 300, "RegConnectRegistry Sample",  #PB_Window_SystemMenu | #PB_Window_SizeGadget | #PB_Window_TitleBar ) 
    If CreateGadgetList(WindowID(#Window_0)) 
      TextGadget(#Gadget_0, 11, 18, 117, 20, "Remote machine name:") 
      StringGadget(#Gadget_1, 130, 16, 140, 20, "") 
      Frame3DGadget(#Gadget_2, 10, 46, 260, 60, "Select Top Level Key to Open") 
      OptionGadget(#Gadget_3, 20, 60, 160, 20, "HKEY_LOCAL_MACHINE") 
      OptionGadget(#Gadget_4, 20, 80, 140, 20, "HKEY_USERS") 
      TextGadget(#Gadget_5, 10, 110, 130, 20, "SubKey you wish to query:") 
      StringGadget(#Gadget_6, 10, 130, 260, 20, "") 
      TextGadget(#Gadget_7, 10, 158, 190, 20, "Value under SubKey you wish to query:") 
      StringGadget(#Gadget_8, 10, 181, 260, 20, "") 
      TextGadget(#Gadget_9, 10, 210, 190,20, "Result:") 
      StringGadget(#Gadget_10, 10, 230, 260, 20, "") 
      ButtonGadget(#Gadget_11, 170, 260, 100, 30, "Query Value") 
      
    EndIf 
  EndIf 
EndProcedure 

Open_Window_0() 
SetGadgetState(#Gadget_3, 1) 
SetGadgetText(#Gadget_1, "Admin") 
SetGadgetText(#Gadget_6, "SOFTWARE\Microsoft\Windows NT\CurrentVersion") 
SetGadgetText(#Gadget_8, "RegisteredOwner") 

Repeat 
  
  Event = WaitWindowEvent() 
  
  If Event = #PB_Event_Gadget 
    
    ;Debug "WindowID: " + Str(EventWindowID()) 
    
    GadgetID = EventGadget() 
    
    If GadgetID = #Gadget_11 
      
      If GetGadgetState(#Gadget_3) = #True 
        lTopLevelKey = #HKEY_LOCAL_MACHINE 
      EndIf 
      If  GetGadgetState(#Gadget_4) = #True 
        lTopLevelKey = #HKEY_USERS 
      EndIf 
      
      sRemMachName = GetGadgetText(#Gadget_1) 
      sKeyName = GetGadgetText(#Gadget_6) 
      sValueName = GetGadgetText(#Gadget_8) 
      
      lRetVal = RegConnectRegistry_(sRemMachName, lTopLevelKey, @lHKeyhandle) 
      lRetVal = RegOpenKeyEx_(lHKeyhandle, sKeyName, 0, #KEY_ALL_ACCESS, @lhkey) 
      lRetVal = QueryValueEx(lhkey, sValueName) 
      RegCloseKey_(lhkey) 
      
      If lRetVal = 0 
        SetGadgetText(#Gadget_10, vValue) 
      Else 
        msg = "An Error occured, Return value = " + Str(lRetVal) 
        SetGadgetText(#Gadget_10, msg) 
      EndIf 
                  
    EndIf 
    
  EndIf 
  
Until Event = #PB_Event_CloseWindow 

End 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; EnableXP
