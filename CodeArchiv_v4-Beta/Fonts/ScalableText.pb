; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=3336&highlight=
; Author: Mischa (updated for PB4.00 by blbltheworm)
; Date: 04. January 2004
; OS: Windows
; Demo: No


; Nur 'ne kleine Demonstration was man mit Emf (Enhanced Metafile) so machen kann. 

#winMain=0

Global TextObject1,TextObject2 

Procedure CreateTextObject(text.s,font,color,align) 
  tdc=CreateEnhMetaFile_(0,0,0,0) 
    SelectObject_(tdc,font) 
    SetBkMode_(tdc,#TRANSPARENT) 
    SetTextColor_(tdc,color) 
    DrawText_(tdc,text,-1,rect.RECT,#DT_CALCRECT) 
    DrawText_(tdc,text,-1,rect.RECT,align) 
  emfhandle=CloseEnhMetaFile_(tdc) 
  ProcedureReturn emfhandle 
EndProcedure 


Procedure ReDrawText(emf,x,y,w,h,dc) 
  set.RECT\left=x:set\top=y:set\right=w:set\bottom=h 
  PlayEnhMetaFile_(dc,emf,set) 
EndProcedure 

Procedure ImageReCreate(w,h) 
  CreateImage(0,w,h) 
  dc=StartDrawing(ImageOutput(0)) 
    Box(0,0,w,h,GetSysColor_(#COLOR_BTNFACE)) 
    ReDrawText(TextObject1,0,0,w,h/2,dc) 
    ReDrawText(TextObject2,w,h,0,h/2,dc) 
  StopDrawing() 
EndProcedure 

Procedure Callback(WindowID, Message, wParam, lParam) 
  Result = #PB_ProcessPureBasicEvents 
  If Message=#WM_SIZE 
    w = WindowWidth(#winMain) 
    h = WindowHeight(#winMain) 
    ImageReCreate(w,h) 
    SetGadgetState(0,ImageID(0)) 
    ResizeGadget(0,#PB_Ignore,#PB_Ignore,w,h) 
  EndIf 
  ProcedureReturn Result 
EndProcedure 


hwnd=OpenWindow(#winMain,0,0,400,300,"ScaleText",#PB_Window_SystemMenu|#PB_Window_ScreenCentered|#PB_Window_SizeGadget) 
CreateGadgetList(hwnd) 
CreateImage(0,400,300) 
font1=LoadFont(0,"Times New Roman",20) 
font2=LoadFont(1,"Arial",20,#PB_Font_Italic|#PB_Font_Bold) 

Restore text:Read Line.s:Repeat:text.s+Line+Chr(13)+Chr(10):Read Line:Until Line="End" 

TextObject1=CreateTextObject(text.s,font1,RGB(0,0,160),#DT_CENTER) 
TextObject2=CreateTextObject(text.s,font2,RGB(160,0,0),#DT_CENTER) 
ImageReCreate(400,300) 
ImageGadget(0,0,0,WindowWidth(#winMain),WindowHeight(#winMain),ImageID(0)) 

SetWindowCallback(@Callback()) 
Repeat:Until WaitWindowEvent()=#PB_Event_CloseWindow 
DeleteEnhMetaFile_(TextObject1) 
DeleteEnhMetaFile_(TextObject2) 
End 

DataSection 
  text: 
  Data.s "Skalierbarer Text Demonstration" 
  Data.s "-------------------------------" 
  Data.s "Dieses Beispiel zeigt eine simple Methode," 
  Data.s "wie man Textblöcke ohne viel Aufwand auf" 
  Data.s "ein gewünschtes Maß bringen kann, ohne das" 
  Data.s "es zu einem ungewünschten Qualitätsverlust" 
  Data.s "kommt. Mischa" 
  Data.s " " 
  Data.s "Bitte das Fenster vergrößern/verkleinern" 
  Data.s "und die Skalierung beurteilen." 
  Data.s "End" 
EndDataSection

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
