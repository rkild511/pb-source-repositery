; English forum: http://www.purebasic.fr/english/viewtopic.php?t=7356
; Author: fsw (updated for PB4.00 by blbltheworm)
; Date: 27. August 2003
; OS: Windows
; Demo: No

; CustomImageGadget by Franco 
; 
; This code 'is ripped out' from: 
; 
;/ CustomButtons 
;/    GPI - 28.07.2003 
;/ 
;/ Works only with BMP, not with ICO! 
;/ 
;/ Original Custom Buttons by freedimension 

;- 

Structure CustomImage 
  hwnd.l 
  normal.l 
EndStructure 
Global NewList CImage_.CustomImage() 

Procedure CustomImageGadget(id.l,x.l,y.l,w.l,h.l,Image.l) 
  ResetList(CImage_()) 
  AddElement(CImage_()) 
  CImage_()\normal  = CreatePatternBrush_(Image) 
  CImage_()\hwnd=ButtonGadget(id,x,y,w,h,"",#BS_OWNERDRAW) 
  ProcedureReturn CImage_()\hwnd 
EndProcedure  

Procedure FillImageGadgets(lParam) 
    *dis.DRAWITEMSTRUCT = lParam 
    If *dis\CtlType=#ODT_BUTTON 
      ResetList(CImage_()) 
      ok=#False 
      Repeat 
        If NextElement(CImage_()) 
          If CImage_()\hwnd=*dis\hwndItem 
            pic=CImage_()\normal 
            FillRect_(*dis\hDC, *dis\rcItem, pic) 
            Result=#True 
            ok=#True 
          EndIf 
        Else 
          ok=#True 
        EndIf 
      Until ok 
    EndIf 
EndProcedure 

Procedure Callback(WindowID, Message, wParam, lParam) 
  Result = #PB_ProcessPureBasicEvents 
  If Message = #WM_DRAWITEM 
    FillImageGadgets(lParam) 
  EndIf 
  ProcedureReturn Result 
EndProcedure 
  
OpenWindow(1, 10, 150, 200, 80, "Button OwnerDraw", #PB_Window_TitleBar|#PB_Window_SystemMenu) 
SetWindowCallback(@Callback()) 

CreateGadgetList(WindowID(1)) 

LoadImage(1, "..\..\graphics\gfx\map.bmp")
LoadImage(2, "..\..\graphics\gfx\pb.bmp")
LoadImage(3, "..\..\graphics\gfx\lightcircle.bmp")
CustomImageGadget(1,  5, 5, 32, 32, ResizeImage(1,32,32)) 
CustomImageGadget(2, 55, 5, 32, 32, ResizeImage(2,32,32)) 
CustomImageGadget(3,110, 5, 32, 32, ResizeImage(3,32,32)) 

state=1 
DisableGadget(3,state) 

Repeat 
  event = WaitWindowEvent() 
  If event=#PB_Event_Gadget 
    If EventType()=#PB_EventType_LeftClick 
      Debug "Pressed ImageGadget:"+Str(EventGadget()) 
    EndIf 
  EndIf 
Until event = #PB_Event_CloseWindow 


; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; EnableXP
