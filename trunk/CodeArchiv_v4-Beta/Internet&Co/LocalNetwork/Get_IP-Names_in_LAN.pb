; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=834&highlight=
; Author: PWS32 (updated for PB4.00 by blbltheworm)
; Date: 02. May 2003
; OS: Windows
; Demo: No


Structure SERVER_INFO_101 
dwPlatformId.l 
lpszServerName.l 
dwVersionMajor.l 
dwVersionMinor.l 
dwType.l 
lpszComment.l 
EndStructure 

#MAX_PREFERRED_LENGTH = -1 
#SV_TYPE_ALL          = $FFFFFFFF 
#NERR_SUCCESS         = 0 
#ERROR_MORE_DATA      = 234 
#MainWindow           = 100 
#MMTB                 = 200 
Global MMTextBox 

Procedure Message (M.s) 
  WriteMessage.s 
  WriteMessage +Chr(13)+Chr(10)+M 
  SetGadgetText(#MMTB,GetGadgetText(#MMTB) + WriteMessage ) 
  SendMessage_(MMTextBox,$00B6,0,10000) 

EndProcedure 

Procedure.s GetIPbyName (NameIP.s) 
  TheIPAdress.s 
    pHostinfo = gethostbyname_(NameIP) 
    If pHostinfo = 0 
      TheIPAdress = "Unable to resolve domain name" 
    Else 
      CopyMemory (pHostinfo, hostinfo.HOSTENT, SizeOf(HOSTENT)) 
      If hostinfo\h_addrtype <> #AF_INET 
        MessageRequester("Info","A non-IP address was returned",0) 
      Else 
        While PeekL(hostinfo\h_addr_list+AdressNumber*4) 
          ipAddress = PeekL(hostinfo\h_addr_list+AdressNumber*4) 
          TheIPAdress = StrU(PeekB(ipAddress),0)+"."+StrU(PeekB(ipAddress+1),0)+"."+StrU(PeekB(ipAddress+2),0)+"."+StrU(PeekB(ipAddress+3),0) 
          AdressNumber+1 
        Wend 
      EndIf 
    EndIf 
  ProcedureReturn TheIPAdress 
EndProcedure 

Procedure GetLANList() 
  IPResult.s 
  se101.SERVER_INFO_101 
  nStructSize = SizeOf(SERVER_INFO_101) 
  RetCode = NetServerEnum_(0, 101, @bufptr, #MAX_PREFERRED_LENGTH, @dwEntriesread, @dwTotalentries, #SV_TYPE_ALL, 0, @dwResumehandle) 
  If RetCode = #NERR_SUCCESS And RetCode <> #ERROR_MORE_DATA 
    For i = 0 To dwEntriesread - 1 
      CopyMemory( bufptr + (nStructSize * i),@se101, nStructSize) 
      Buffer.s=Space(512) 
      Result=WideCharToMultiByte_(#CP_ACP ,0,se101\lpszServerName,255,@Buffer.s,512,0,0) 
      IPResult = GetIPbyName (Buffer) 
      Message ("No : "+ Str(i+1) + "  " + Buffer + " --> " + IPResult) 
    Next 
  Else 
    MessageRequester("Info","Failed",0) 
  EndIf 
  NetApiBufferFree_(bufptr) 
  SendMessage_(MMTextBox,$00B6,0,30) 
EndProcedure 

If InitNetwork() =0
  MessageRequester("Info","Network can't be initialized",0) 
  End
EndIf 

hWnd   = OpenWindow(#MainWindow, 100, 150, 300, 250, " Name > IP", #PB_Window_SystemMenu ) 

If CreateGadgetList(WindowID(#MainWindow)) 
  ButtonGadget(1, 1, 224,  WindowWidth(#MainWindow)-1,26, "Get Name and IP") 
  MMTextBox=StringGadget(#MMTB,  0, 2, WindowWidth(#MainWindow)-1,WindowHeight(#MainWindow)-30 ,"Name > IP by P.Spisla 2003 ",#ES_MULTILINE|#ES_AUTOVSCROLL|#WS_VSCROLL|#PB_String_ReadOnly) 
  Message("--------------------------------------------") 
EndIf 

;GetLANList() 


Repeat 
  Select WaitWindowEvent() 
  Case #PB_Event_Gadget 
    Select EventGadget() 
    Case 1 
      Message ("Examine the Network, please wait !") 
      GetLANList() 
      Message ("End of List") 
    EndSelect 
  Case #PB_Event_CloseWindow 
    End 
  EndSelect 
ForEver 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
