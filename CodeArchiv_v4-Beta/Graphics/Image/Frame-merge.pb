; German forum: 
; Author: Robert Gerlach (updated for PB4.00 by blbltheworm)
; Date: 01. February 2003
; OS: Windows
; Demo: Yes


; Fügt viele gleichgroße Bilder zu einem Bildstreifen zusammen

Global zfile.s

Global NewList qfiles.s()

OpenWindow(0,0,0,290,130,"FrameMerge",#PB_Window_SystemMenu | #PB_Window_ScreenCentered)

CreateGadgetList(WindowID(0))

StringGadget(0,43,5,174,20,"quell-bilder.bmp")
StringGadget(1,43,30,174,20,"ziel-bild.bmp")
ButtonGadget(2,230,5,50,20,"Browse")
ButtonGadget(3,230,30,50,20,"Browse")
TextGadget(4,1,7,38,20,"Quellen:",#PB_Text_Right)
TextGadget(5,1,32,38,20,"Ziel:",#PB_Text_Right)
ButtonGadget(6,110,75,70,23,"Merge")
TextGadget(7,0,55,290,18,"! Alle Quellbilder müssen die gleiche Größe haben !",#PB_Text_Center)
ProgressBarGadget(8,5,105,280,20,0,100,#PB_ProgressBar_Smooth)







Procedure mergefiles()

    qfilecount = CountList(qfiles())

    FirstElement(qfiles())
    If LoadImage(0,qfiles())

      w = ImageWidth(0) ;... Größe bestimmen
      h = ImageHeight(0)
      CreateImage(1,w*qfilecount,h) ; Entsprechend großes Zielbild erstellen (Breite * Bildanzahl)

      StartDrawing(ImageOutput(1))
         DrawImage(ImageID(0),0,0) ; Gleich das erste Bild reinmalen
      StopDrawing()
            
      FreeImage(0)
    prozent = 100 / qfilecount
    SetGadgetState(8,prozent)
    Else
      MessageRequester("Huch","Konnte Bild " + qfiles() + " nicht öffnen.",0)
    EndIf
 
    i = 2
    ; Ab dem zweiten Bild jetzt alle anderen reinmalen
    While NextElement(qfiles())
        
      If LoadImage(0,qfiles())
        
        StartDrawing(ImageOutput(1))
          DrawImage(ImageID(0),w*i-w,0)
        StopDrawing()

        prozent = i * 100 / qfilecount
        SetGadgetState(8,prozent) ; ProgressBar updaten
        
        FreeImage(0)
      Else
        MessageRequester("Huch","Konnte Bild " + qfiles() + " nicht öffnen.",0)
      EndIf
     
      i + 1
    Wend     
     
    SaveImage(1,zfile) ; Das ganze abspeichern

SetGadgetState(8,0)
EndProcedure 








Repeat
event = WaitWindowEvent()
If event = #PB_Event_Gadget

Select EventGadget()
Case 2
qfile.s = OpenFileRequester("Öffnen","C:\", "BMP-Bilder *.bmp|*.bmp|Alle Dateien *.*|*.*",0,#PB_Requester_MultiSelection)

FileName.s = qfile

; Liste löschen
ClearList(qfiles())

; Alle Dateinamen ins Stringgadget
Repeat
AddElement(qfiles())
qfiles() = FileName

FileName = NextSelectedFileName()
Until FileName = "" 
SetGadgetText(0,qfile+" ...")




;*-------------------------------------


Case 3
zfile.s = OpenFileRequester("Öffnen","C:\", "BMP-Bilder *.bmp|*.bmp|Alle Dateien *.*|*.*",0)
SetGadgetText(1,zfile)


;*------------------------------------


Case 6
  
  threadid=CreateThread(@mergefiles(),0)


EndSelect

EndIf
Until event = #PB_Event_CloseWindow

End 


; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; EnableXP
; Executable = D:\PureBasic\EigeneProgramme\framemerge.exe