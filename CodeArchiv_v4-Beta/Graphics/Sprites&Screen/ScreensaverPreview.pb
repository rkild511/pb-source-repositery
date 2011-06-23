; English forum: http://www.purebasic.fr/english/viewtopic.php?t=8891&highlight=
; Author: eddy (updated for PB4.00 by blbltheworm)
; Date: 29. December 2003
; OS: Windows
; Demo: No

; Note: need to be compiled to an executable first...
; Hinweis: muss erst zu einem Executable kompiliert werden...

; Screensaver Preview... 3rd edition

;------------------- 
;-Preview Destructor 
;------------------- 

Procedure PreviewAutoDestruction(window, message, wParam, lParam) 
   Shared WM_DestroyPreview 
    
   Result = #PB_ProcessPureBasicEvents 
   Select message 
      Case #WM_CLOSE 
         DestroyWindow_(window) 
         End 
      Case WM_DestroyPreview 
         End 
   EndSelect 
   ProcedureReturn Result 
EndProcedure 

;------------------- 
;-Preview 
;------------------- 

Procedure Preview(preview) 
      
   ; ------------------------ 
   ; preview image 
   ; ------------------------ 
   UseGadgetList(preview) 
      
      GetClientRect_(preview,@rc.rect)    
      CreateImage(1,rc\right,rc\bottom) 
         StartDrawing(ImageOutput(1)) 
            For y=0 To ImageHeight(1) 
               Line(0,y,ImageWidth(1),1,RGB($FF*y/ImageHeight(1),$CC*y/ImageHeight(1),0)) 
            Next 
         StopDrawing() 
      ImageGadget(1,0,0,0,0,ImageID(1))  

   CloseGadgetList() 


   ; ------------------------ 
   ; close previous previews 
   ; ------------------------ 
   Shared WM_DestroyPreview 
   WM_DestroyPreview=RegisterWindowMessage_(@"PREVIEW AUTO DESTRUCTION") 
   SendMessage_(#HWND_BROADCAST,WM_DestroyPreview,0,0)    

   ; ------------------------ 
   ; the empty child window will receive all messages 
   ; wait end of preview... 
   ; ------------------------        
   SetParent_(OpenWindow(0,0,0,0,0,"CHILD WINDOW",#PB_Window_Invisible),preview)    
   SetWindowCallback(@PreviewAutoDestruction()) 
    
   Repeat 
      WaitWindowEvent() 
   ForEver    
EndProcedure 

;------------------- 
;-Main Program 
;------------------- 
FirstParam.s    =ProgramParameter() 
command.s       =LCase(Left(ReplaceString(FirstParam,"-","/"),2)) 
ParentWindow.l  =Val(StringField(FirstParam,2,":")) | Val(ProgramParameter()) 
        
Select command      
   Case "/p" 
      Preview(ParentWindow) 
   Case "/c" 
      ;Config(ParentWindow)      
   Default 
      ;Saver() 
EndSelect 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
