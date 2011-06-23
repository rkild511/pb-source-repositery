; German forum: 
; Author: Mischa (updated for PB4.00 by blbltheworm)
; Date: 17. December 2002
; OS: Windows
; Demo: No

Procedure MetaFileDraw(metafile.s,dc,x,y,b,h)
 If metafile
  WmfRect.RECT
  WmfRect\left=x
  WmfRect\top=y
  WmfRect\right=x+b-1
  WmfRect\bottom=y+h-1
  hmf = GetEnhMetaFile_(metafile)
  If hmf<>0
    PlayEnhMetaFile_(dc,hmf,WmfRect)
    DeleteEnhMetaFile_(hmf)
  Else
    hmf = GetMetaFile_(metafile)
    If hmf=0
      size=FileSize(metafile)-22
      ReadFile(1,metafile)
        FileSeek(1,22)
        *buffer=AllocateMemory(size)
        ReadData(1,*buffer,size)
      CloseFile(1)
    Else
      bytes = GetMetaFileBitsEx_(hmf, bytes,0)
      *buffer=AllocateMemory(bytes)
      GetMetaFileBitsEx_(hmf,bytes,*buffer)
    EndIf
    hemf = SetWinMetaFileBits_(size,*buffer,dc,0)
    PlayEnhMetaFile_(dc,hemf,WmfRect)
    DeleteEnhMetaFile_(hemf)
    DeleteMetaFile_(hmf)
  EndIf
 EndIf
EndProcedure

Procedure LoadAndSet()
  metafile.s=OpenFileRequester("Load Metafile", "", "Meta-File|*.wmf;*.emf", 0)
  dc=StartDrawing(ImageOutput(1))
    For k=0 To 250
      c.f+0.5:FrontColor(RGB(100+c,100,255-c))
      Line(0, k, 250, 0)
    Next
    MetaFileDraw(metafile,dc,0,0,250,250)
  StopDrawing()
  StartDrawing(WindowOutput(0))
    DrawImage(ImageID(1), 100, 50)
  StopDrawing()   
EndProcedure


hwnd=OpenWindow(0, 100, 100, 450, 400, "Metafiles", #PB_Window_SystemMenu)
id=CreateImage(1, 250, 250) 
CreateGadgetList(hwnd)
ButtonGadget(1, 150, 325, 150, 25, "Load Metafile")


Repeat
  EventID = WaitWindowEvent()
  If EventID = #PB_Event_Gadget
    Select EventGadget()
      Case 1:LoadAndSet()
    EndSelect
  EndIf
Until EventID = #PB_Event_CloseWindow

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; DisableDebugger