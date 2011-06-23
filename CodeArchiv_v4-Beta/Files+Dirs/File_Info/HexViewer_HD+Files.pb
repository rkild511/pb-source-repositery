; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=1387&highlight=
; Author: Rings (updated for PB3.92+ by Lars & Andre, updated for PB4.00 by blbltheworm & Andre)
; Date: 17. June 2003
; OS: Windows
; Demo: No

; *** Hexviewer for Hardisks and files ***

; uses Danilos ToolbarPro library, get it from www.PureArea.net !

#Window_0 = 0 

#MenuBar_2 = 0 
#MENU_FileOpen = 1 
#MENU_Save  = 2 
#MENU_HDISK_C  = 3 
#MENU_Search  = 4 
#MENU_Replace  = 5 
#MENU_Back  = 6 
#MENU_Forward  = 7 
#MENU_HELP=8 

#PositionText=9 
#StatusText=10 

#DriveGadgets=100 
#HexGadget=200 
#AsciiGadget=62 
#AdressGadget=30 

#Suchen=14 
#Filtern=15 


Global Filename.s 
Global LIHwnd.l 
Global FHandle.l 
Global Buffer.l 
Global Offset.l 
Global FLen.l 

Procedure SROpenFile(AFilename.s) 
  FHandle=CreateFile_(@AFilename.s,#GENERIC_READ|#GENERIC_WRITE ,#FILE_SHARE_READ|#FILE_SHARE_WRITE,#Null,#OPEN_EXISTING,#FILE_ATTRIBUTE_NORMAL,0 ) 
  If FHandle 
    Buffer=AllocateMemory(512) 
    Offset=0 
    ProcedureReturn FHandle 
  EndIf 
EndProcedure 

Procedure SRGetData(NewPosition) 
  Count=0 
  Result=SetFilePointer_(FHandle,NewPosition,0,#FILE_BEGIN ) 
  Result=ReadFile_(FHandle,Buffer,512,@Count,0) 
  ProcedureReturn Count 
EndProcedure 
Procedure SRGetDataNext() 
  Count=0 
  Result=ReadFile_(FHandle,Buffer,512,@Count,0) 
  ProcedureReturn Count 
EndProcedure 

Procedure SRGetFilepointer() 
  ProcedureReturn SetFilePointer_(FHandle,0,0,#FILE_CURRENT  ) 
EndProcedure 

Procedure SRGetDataPrevious() 
  Count=0 
  Result=SetFilePointer_(FHandle,-1024,0,#FILE_CURRENT ) 
  Result=ReadFile_(FHandle,Buffer,512,@Count,0) 
  ProcedureReturn Count 
EndProcedure 

Procedure SRCloseFile(FHandle1) 
  If FHandle1<>0 
    FreeMemory(Buffer) 
    CloseHandle_(FHandle1) 
    FHandle=0 
    ProcedureReturn FHandle1 
  Else 
    ProcedureReturn -1 
  EndIf    
EndProcedure 


Procedure Open_Window_0() 
  hwnd=OpenWindow(#Window_0, 252, 113, 620, 580, "PB Hexeditor",  #PB_Window_SystemMenu | #PB_Window_TitleBar ) 
  ;hWnd = OpenWindow(0,100,100,0,0,#WS_POPUP,"Icon-Show") 
  If hwnd 
    If CreateGadgetList(WindowID(#Window_0)) 
      
      AnfangYLabels=36 
      
      CreateTB(0,hwnd,24,24,#TBpro_TRANSPARENT|#TBpro_BORDER) 
      SetTBimage(0,0,#TBpro_NORMAL) 
      SetTBimage(0,0,#TBpro_HOT) 
      SetTBimage(0,0,#TBpro_DISABLED) 
      AddTBsysIcons()    
      AddTBbutton(#MENU_FileOpen , #TBpro_FILEOPEN,0);Fileopen 
      AddTBbutton(#MENU_HDISK_C , #TBpro_NETCONNECT,#TBpro_DropdownBUTTON);Diskette 
      AddTBbutton(#MENU_Save, #TBpro_FILESAVE,0);speichern 
      DisableTBbutton(#MENU_Save , 1 ) 
      AddTBseparator(10 ) 
      AddTBbutton(#MENU_Back , #TBpro_BACK,0);search 
      AddTBbutton(#MENU_Forward , #TBpro_FORWARD,0);search 
      AddTBseparator(10 ) 
      AddTBbutton(#MENU_Search , #TBpro_FIND,0);search 
      AddTBbutton(#MENU_Replace , #TBpro_REPLACE,0);search 
      DisableTBbutton(#MENU_Replace , 1 ) 
      
      AddTBseparator(330 ) 
      AddTBbutton(#MENU_HELP, #TBpro_HELP,0);Help 
      
      hGadget=TextGadget(#StatusText,10,0,300,30,"Status:OKay!") 
      AddTBgadget( hGadget, 260, 0 ) 
      
      
      SetTBbuttonTooltip(#MENU_FileOpen ,"Opens a file to examine") 
      SetTBbuttonTooltip(#MENU_Save ,"Save Block") 
      SetTBbuttonTooltip(#MENU_HDISK_C ,"Opens a Harddisk to examine") 
      
      SetTBbuttonTooltip(#MENU_Search,"search for a given pattern") 
      SetTBbuttonTooltip(#MENU_Replace,"search and replace for a given pattern") 
      
      
      UpdateTB() 
      
      If CreatePopupMenu(0) 
        For I=1 To 26 
          Parameter.s=Chr(64+I)+":" 
          Select GetDriveType_(Parameter) 
            Case 0;      Result = Translator("Unknown") 
            Case 1;      Result = Translator("No root dir") 
            Case 2      ;Result = Translator("Removable") 
              MenuItem(#DriveGadgets+I, Parameter) 
            Case 3  ;Result = Translator("Drive Fixed") 
              MenuItem(#DriveGadgets+I, Parameter) 
            Case 4    ;  Result = Translator("Remote") 
            Case 5    ;  Result = Translator("CDROM") 
              MenuItem(#DriveGadgets+I, Parameter) 
            Case 6     ; Result = Translator("Ram disk") 
            Default     ; Result = Translator("Unknown") 
          EndSelect 
        Next I 
      EndIf 
      
      
      Abstand=80 
      AnfangY=20+AnfangYLabels 
      YSize=15 
      HexBreite=22 
      
      
      LoadFont(1,"Times New Roman",8) 
      LoadFont(1,"Courier New",12) 
      
      SetGadgetFont(#PB_Default ,FontID(1)) 
      
      TextGadget(0,1,AnfangYLabels,Abstand-5,YSize,"Adress", #PB_Text_Right);|#PB_Text_Border) 
      TextGadget(0,Abstand+20,AnfangYLabels,336,YSize,"HEX-DATA", 0);|#PB_Text_Border) 
      TextGadget(#PositionText,300,AnfangYLabels,80,YSize,"") 
      
      TextGadget(0,420,AnfangYLabels,180,YSize,"ASCII-DATA", #PB_Text_Center);|#PB_Text_Border) 
      
      P=#HexGadget 
      s=#AsciiGadget 
      StartDrawing(WindowOutput(#Window_0)) 
      For I=0 To 31 
        StringGadget(#AdressGadget+I,0,I*(YSize+1)+AnfangY,Abstand-5,YSize,Hex((P-100)), #PB_String_BorderLess|#PB_Text_Right|#PB_String_ReadOnly) 
        For T=0 To 15 
          P+1 
          ; hwnd=StringGadget(P, Abstand + (T*HexBreite),I*(YSize+1)+AnfangY,20,YSize,"FF",#PB_String_BorderLess |#PB_String_UpperCase  ) 
          ;hwnd=TextGadget(P, Abstand + (T*HexBreite),I*(YSize+1)+AnfangY,20,YSize,"",0) 
          DrawText( Abstand + (T*HexBreite),I*(YSize+1)+AnfangY,"FF") 
          
        Next T 
        StringGadget(#AsciiGadget+I,435,I*(YSize+1)+AnfangY,165,YSize,"", #PB_String_BorderLess) 
      Next I    
      StopDrawing() 
      AddKeyboardShortcut(#Window_0, 1,     #PB_Shortcut_Up ) 
      AddKeyboardShortcut(#Window_0, 2,     #PB_Shortcut_Down ) 
      
    EndIf 
  EndIf 
EndProcedure 

Procedure FillHex(Startadress,Anzahl) 
  Shared Buffer 
  P=#HexGadget 
  
  AnfangYLabels=36 
  Abstand=80 
  AnfangY=20+AnfangYLabels 
  YSize=15 
  HexBreite=22 
  
  
  
  StartDrawing(WindowOutput(#Window_0)) 
  DrawingMode(0) 
  Box(Abstand,AnfangY,(16*HexBreite),32*(YSize+1),$FFFFFF) 
  DrawingMode(1) 
  FrontColor(RGB(0,0,0)) 
  For I=0 To 31 
    SetGadgetText(#AdressGadget+I,Hex(Startadress+(I*16))) 
    ascii.s="" 
    For T=0 To 15 
      Newoffset= P - #HexGadget 
      P+1 
      
      If Buffer<>0 And P <=Anzahl+#HexGadget 
        Wert=PeekB(Buffer + Newoffset) 
        ;    SetGadgetText(P,Right("00"+Hex(Wert),2)) 
        DrawText( Abstand + (T*HexBreite),I*(YSize+1)+AnfangY,Right("00"+Hex(Wert),2)) 
      Else 
        
        ;     SetGadgetText(P," ") 
        DrawText( Abstand + (T*HexBreite),I*(YSize+1)+AnfangY,"  ") 
        
        
        Wert=-1;Random(255) 
      EndIf 
      
      If Wert>-1 And Wert<256 
        ascii.s=ascii.s+Chr(Wert) 
      Else 
        ascii.s=ascii.s+" " 
      EndIf 
    Next T 
    SetGadgetText(#AsciiGadget+I,ascii) 
  Next I    
  StopDrawing() 
  If FHandle<>0 
    SetGadgetText(#PositionText, "Pos="+StrU(SRGetFilepointer()-512,2) ) 
  EndIf 
EndProcedure 


Open_Window_0() 
FillHex(0,0) 
Repeat 
  ;-MAINEVENT 
  event = WaitWindowEvent() 
  EM    = EventMenu() 
  EVT   = EventType() 
  GD    = EventGadget() 

  ;  Debug Str(Event)+":"+Str(EVT)+":"+Str(EM) 
  If event=#PB_Event_Menu 
    If EM>#DriveGadgets And EM <#DriveGadgets+26 
      Beep_(100,100) 
      SRCloseFile(FHandle) 
      
      Filename.s="\\.\"+Chr(EM-36)+":" 
      If SROpenFile(Filename.s) 
        Offset=0 
        FLen.l=-2 
        SRGetData(Offset) 
        Beep_(100,100) 
        FillHex(Offset,512) 
        SetGadgetText(#StatusText,"HardDisk drive C:") 
      EndIf 
      EM=0 
    EndIf 

    Select GD 
      Case #MENU_HELP 
        MessageRequester("Info about","PureBasic-Hexeditor(viewer) by Siegfried Rings",0) 
      Case #MENU_Search 
        Search.s=InputRequester("PB-Hexeditor","Type in String To search For",Search.s) 
        Beep_(100,100) 
      Case #MENU_FileOpen 
        Filename.s=OpenFileRequester("Choose File to examine", DefaultFile$, "*.*",0 ) 
        If Filename<>"" 
          DefaultFile$=Filename 
          SRCloseFile(FHandle) 
          If SROpenFile(Filename.s) 
            FLen.l=FileSize(Filename.s) 
            Offset=0 
            SRGetData(Offset) 
            Beep_(100,100) 
            FillHex(Offset,FLEN) 
            SetGadgetText(#StatusText,"File="+Filename.s) 
          EndIf 
        EndIf 
        EM=0 
      Case #MENU_HDISK_C  
        DisplayPopupMenu(0, WindowID(#Window_0)) 
        
      Case #MENU_Back  
        If FHandle<>0 
          If Offset<= 512 
            Offset=0 
            FillHex(Offset,Result) 
          Else 
            Result=SRGetDataPrevious() 
            If Result<>0 
              Offset=SRGetFilepointer();-512 
              FillHex(Offset-512,Result) 
            EndIf  
          EndIf 
        EndIf  
      Case #MENU_Forward  
        
        If FHandle<>0 
          Result=SRGetDataNext() 
          If Result>0 
            Offset=SRGetFilepointer();-512 
            FillHex(Offset-512,Result) 
          EndIf 
        EndIf 
    EndSelect 
    If GD>=#HexGadget And GD<=#HexGadget+512 
      If EVT=#PB_EventType_Change          
        Len=Len(GetGadgetText(GD)) 
        If Len>2 
          Beep_(100,100) 
          SetGadgetText(GD,Left(GetGadgetText(GD),2)) 
        EndIf 
      EndIf 
    EndIf 
  EndIf 
  
Until Event = #PB_Event_CloseWindow 
SRCloseFile(FHandle) 
End

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = --
; DisableDebugger
