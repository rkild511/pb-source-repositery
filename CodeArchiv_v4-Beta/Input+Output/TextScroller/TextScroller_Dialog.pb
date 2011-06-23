; English forum: 
; Author: Unknown (updated for PB4.00 by blbltheworm)
; Date: 30. March 2003
; OS: Windows
; Demo: No

#TM_DRAW=1


Global spt.PAINTSTRUCT,src.RECT,hinst,ypos

hinst=GetModuleHandle_(0)

ypos=350

Global Dim scroll.s(5)
scroll(0) = "here is some scrolling text in a"
scroll(1) = "dialog window with purebasic!"
scroll(2) = ""
scroll(3) = "here is some more scrolling text!!"
scroll(4) = "bye............"

;Dialog Procedure
Procedure Dialogproc(hdlg,msg,wparam,lparam)
  Select msg

    Case #WM_INITDIALOG
      GetClientRect_(hdlg,@src)
      src\right=(src\right)/2
      
      SetTimer_(hdlg,#TM_DRAW,15,#Null)

      hdc=GetDC_(hdlg)
      SetBkMode_(hdc,#TRANSPARENT)
      retval=1

    Case #WM_TIMER
      ypos-1
      If ypos=-100 : ypos=350 : EndIf
      
      InvalidateRect_(hdlg,@src,#True)

      retval=1

    Case #WM_PAINT
      hdc=BeginPaint_(hdlg,@spt)

      For s=0 To 4  
        TextOut_(hdc,10,ypos+yinc,scroll(s),Len(scroll(s)))
        yinc+20
      Next 
      
      EndPaint_(hdlg,@spt)
      retval=1

    Case #WM_CLOSE
      EndDialog_(hdlg,1)
      retval=1

    Default
      retval=0

  EndSelect
  ProcedureReturn retval
EndProcedure

;Show dialog (Modal)
DialogBoxIndirectParam_(hinst,?dialogdata,0,@Dialogproc(),0)

End

;DIALOG TEMPLATE (Modal)
DataSection
dialogdata:
Data.b 193,0,200,20, 0,0,0,1, 0,0, 100,0, 43,0, 112,1, 217,0
Data.b 0,0, 0,0, 87,0,105,0,110,0,100,0,111,0,119,0,49,0,0,0, 1,0, 77,0,83,0,32,0,83,0,97,0,110,0,115,0,32,0,83,0,101,0,114,0,105,0,102,0,0,0
EndDataSection


; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -