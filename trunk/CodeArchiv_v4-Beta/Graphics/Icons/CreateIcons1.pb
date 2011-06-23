; English forum: http://www.purebasic.fr/english/viewtopic.php?t=7478&highlight=
; Author: freak (updated for PB 4.00 by freak)
; Date: 07. September 2003 
; OS: Windows
; Demo: No

; Since it is not possible, to create or paint Icon with the PureBasic Image 
; commands, i created 2 little procedures to still make this possible. 
; 
; Since it is not possible to draw directly on a Icon at all with Windows API, 
; my procedures just copy the icon data to usual PB Images, where you 
; can then modify them, and create a new Icon out of them. You can use the 
; same #Image number for the icon when you recreate it, so you don't 
; waste any recources. All stuff is freed correctly. 
; 
; Use the SplittIcon() function, to modify an existing icon, by extracting the 
; 2 different Images out of them, And later combine them again with 
; CreateIcon() 
; 
; As shown below, CreateIcon() can also be used to create a new Icon out 
; out of 2 Images. 
; 
; Here we go: 


; This Function creates 2 new Images out of the Icon. 
; The Image specified in 'Image.l' will hold the Icon Image, and 
; the one in 'Mask.l' will hold the Icon AND Mask. This is a Black&White 
; Bitmap image, where all white parts are transparent in the Icon. 
; All numbers here are PB #Image numbers. 
Procedure SplittIcon(Icon.l, Image.l, Mask.l) 
  If CreateImage(Image, ImageWidth(Icon), ImageHeight(Icon)) 
      DC.l = StartDrawing(ImageOutput(Image)) 
      DrawIconEx_(DC, 0, 0, ImageID(Icon), 0, 0, 0, 0, 2) 
    StopDrawing() 
  EndIf 
  
  If CreateImage(Mask, ImageWidth(Icon), ImageHeight(Icon)) 
    DC.l = StartDrawing(ImageOutput(Mask)) 
      DrawIconEx_(DC, 0, 0, ImageID(Icon), 0, 0, 0, 0, 1) 
    StopDrawing() 
  EndIf 
EndProcedure 


; This Function creates a new Icon, out of the Images specified in Image and Mask. 
; Both must be of the same size, and the Mask may only contain black and white. 
Procedure.l CreateIcon(Icon.l, Image.l, Mask.l) 
  Protected *Bitmap.LONG 
  
  If CreateImage(Icon, ImageWidth(Image), ImageHeight(Image)) 
    *Bitmap = IsImage(Icon) 

    DeleteObject_(*Bitmap\l) 
    
    NewIcon.ICONINFO 
    NewIcon\fIcon = #True 
    NewIcon\hbmMask = ImageID(Mask) 
    NewIcon\hbmColor = ImageID(Image) 
    *Bitmap\l = CreateIconIndirect_(@NewIcon)    
    ProcedureReturn ImageID(Icon) 
  EndIf 
  
  ProcedureReturn 0 
EndProcedure 


;- Another example... 
#Icon  = 0 
#Image = 1 
#Mask  = 2 

Font.l = LoadFont(0, "Times", 8) 

If OpenWindow(0, 0, 0, 100, 50, "Icon", #PB_Window_SystemMenu|#PB_Window_ScreenCentered) 
  If CreateGadgetList(WindowID(0)) 

    ; Create and draw the Icon Image: 
    CreateImage(#Image, 16, 16)    
    StartDrawing(ImageOutput(#Image))      
      DrawingMode(1) 
      FrontColor($FF0000) 
      DrawingFont(Font) 
      DrawText(2, 2, "PB")      
    StopDrawing() 
     
    ; See the result: 
    ImageGadget(1, 20, 20, 32, 32, ImageID(#Image)) 
     
    ; Create and draw the mask. Everything that is white 
    ; will be transparent, everything black will be displayed. 
    ; so we just draw the same as above in black on a white background. 
    CreateImage(#Mask, 16, 16)    
    StartDrawing(ImageOutput(#Mask)) 
      Box(1, 1, 14, 14, $FFFFFF) 
      FrontColor($000000)      
      DrawingMode(1)      
      DrawingFont(Font) 
      DrawText(2, 2, "PB")    
    StopDrawing() 
     
    ; Yet another test: 
    ImageGadget(2, 60, 20, 32, 32, ImageID(#Mask)) 
     
    ; Now we make our new #Icon out of these 2... 
    CreateIcon(#Icon, #Image, #Mask) 
     
    ; And place it in the systray. 
    AddSysTrayIcon(0, WindowID(0), ImageID(#Icon)) 
     

    Repeat 
    Until WaitWindowEvent() = #PB_Event_CloseWindow 
  EndIf 
EndIf 
End 

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -
; EnableXP