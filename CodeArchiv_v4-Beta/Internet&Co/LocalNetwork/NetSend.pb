; www.purearea.net
; Author: Rings (updated for PB4.00 by blbltheworm)
; Date: 27. November 2002
; OS: Windows
; Demo: No

;NetSend
; Another Snippet by Siegfried Rings (C) 2002 CodeGuru
; This one retrieves all usernames from local Network
; and can send a message to them(Works only NT,2000 or XP , Nor Win9x, ME tested)

#Button1=1
#Button2=2
#ListViewGadget=3
#String1=4
#Text1=5
#Text2=6

Structure SERVER_INFO_101
  dwPlatformId.l
  lpszServerName.l
  dwVersionMajor.l
  dwVersionMinor.l
  dwType.l
  lpszComment.l
EndStructure

Structure WKSTA_INFO_100
  wki100_platform_id.l  ;Indicates level to use for get platform-specific info.
  wki100_computername.l;Contains name of local computer in Unicode
  wki100_langroup.l;Contains domain computer belongs to in Unicode
  wki100_ver_major.l;Holds Major version number of OS on local computer
  wki100_ver_minor.l;Holds Minor version number of OS on local computer
EndStructure

#MAX_PREFERRED_LENGTH              = -1
#SV_TYPE_ALL =$FFFFFFFF
#NERR_SUCCESS                      = 0
#ERROR_MORE_DATA                   = 234

Procedure GetServerList()
  ClearGadgetItemList(#ListViewGadget)
  se101.SERVER_INFO_101
  nStructSize = SizeOf(SERVER_INFO_101)
  RetCode = NetServerEnum_(0, 101, @bufptr, #MAX_PREFERRED_LENGTH, @dwEntriesread, @dwTotalentries, #SV_TYPE_ALL, 0, @dwResumehandle)
  If RetCode = #NERR_SUCCESS And RetCode <> #ERROR_MORE_DATA
    ;Loop through And the Data in the memory
    For i = 0 To dwEntriesread - 1
      CopyMemory( bufptr + (nStructSize * i),@se101, nStructSize)
      Buffer.s=Space(512)
      Result=WideCharToMultiByte_(#CP_ACP ,0,se101\lpszServerName,255,@Buffer.s,512,0,0)
      AddGadgetItem(#ListViewGadget, -1,Buffer)
    Next
  EndIf
  NetApiBufferFree_(bufptr)
EndProcedure

Procedure.s GetLocalSystemName()
  twkstaInfo100.WKSTA_INFO_100
  lwkstaInfo100.l
  nStructSize=SizeOf(WKSTA_INFO_100)
  Result= NetWkstaGetInfo_(0, 100, @lwkstaInfo100)
  If Result=0
    CMResult=CopyMemory( lwkstaInfo100,@twkstaInfo100, nStructSize)
    Buffer.s=Space(512)
    Result=WideCharToMultiByte_(#CP_ACP ,0,twkstaInfo100\wki100_computername,-1,@Buffer.s,512,0,0)
    ProcedureReturn Trim(Buffer)
  Else
    ProcedureReturn "DAMM :("
  EndIf
EndProcedure

Procedure NTSendMessage(NTFrom.s,NTTo.s,NTMessage.s)
  Buffer1 = AllocateMemory(Len(NTTo)*2)
  Result=MultiByteToWideChar_(#CP_ACP ,0,NTTo,-1,Buffer1,Len(NTTo)*2)
  
  Buffer2 = AllocateMemory(Len(NTFrom)*2)
  Result=MultiByteToWideChar_(#CP_ACP ,0,NTFrom,-1,Buffer2,Len(NTFrom)*2)
  
  buf.s="MeineNachricht"
  buflen.l=Len(NTMessage)
  
  Buffer3 = AllocateMemory(Len(NTMessage)*2)
  Result=MultiByteToWideChar_(#CP_ACP ,0,NTMessage.s,-1,Buffer3,buflen*2)
  
  Result=NetMessageBufferSend_(0,Buffer1,Buffer2,Buffer3,buflen*2)
  FreeMemory(-1)
  
EndProcedure

Localname.s=GetLocalSystemName()
;-Main
WindowID = OpenWindow(0, 200, 200, 400,120, "Send NT-Message  Local:"+Localname.s, #PB_Window_SystemMenu     );+GetLocalSystemName())
If WindowID
  If CreateGadgetList(WindowID)
    StringGadget(#String1,130,20,265,40,"This is a Testmessage",#PB_Text_Center)
    ButtonGadget(#Button1,130,100,100,19,"SEND")
    ButtonGadget(#Button2,230,100,100,19,"Refresh")
    ListViewGadget(#ListViewGadget,2,20,120,100)
    TextGadget(#Text1,2,1,100,16,"Users")
    TextGadget(#Text2,120,1,100,16,"Message")
    GetServerList()
    
    Repeat
      EventID = WaitWindowEvent()
      If EventID = #PB_Event_Gadget
        GadgetID=EventGadget()
        Select GadgetID
        Case #Button1
          pos=GetGadgetState(#ListViewGadget)
          If pos>-1
            NTTo.s=GetGadgetItemText(#ListViewGadget,pos,0)
            
            NTSendMessage(Localname,NTTo.s,GetGadgetText(#String1))
          Else
            Beep_(100,50)
          EndIf
        Case #Button2
          GetServerList()
        EndSelect
      EndIf
    Until EventID = #PB_Event_CloseWindow
  EndIf
EndIf

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; EnableXP
; Executable = C:\PureBasic\NetSend.exe