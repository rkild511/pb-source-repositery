; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=3783&postdays=0&postorder=asc&start=0
; Author: remi_meier (updated for PB 4.00 by Andre)
; Date: 23. February 2004
; OS: Windows
; Demo: No

; Hab hier mal nach http://www.akh-wien.ac.at/imc/mbm/SegmentierTutorial/Implementierung.html#SobelOp
; den Sobel-Operator geproggt. 

Enumeration
  #eing
  #ausg
  #window
  #windowstate
  #trackbar
  #button
  #text1
  #progb
EndEnumeration

UseJPEGImageDecoder()
UseTIFFImageDecoder()
UsePNGImageDecoder()
UseTGAImageDecoder()


synchtime=100
Global Dim matrix(3,3)

Procedure Absl(Value); - makes value always positiv
  If Value<0:Value=-Value:EndIf
  ProcedureReturn Value
EndProcedure

oeffnen:
datei.s=OpenFileRequester("Öffnen","","Bilddateien | *.bmp;*.BMP;*.tiff;*.jpg;*.jpeg;*.png;*.tga",0)
If datei
  If LoadImage(#eing,datei)=0 : Goto oeffnen : EndIf
Else
  End
EndIf

width=ImageWidth(#eing)
height=ImageHeight(#eing)

StartDrawing(ImageOutput(#eing))
Global Dim bild(width, height)
For x=1 To width
  For y=1 To height
    farbe=Point(x,y)
    bild(x,y)=Int((Red(farbe)+Green(farbe)+Blue(farbe))/3)
  Next
Next
StopDrawing()


CreateImage(#ausg,width,height)


OpenWindow(#windowstate,500,500,500,50,"Status",#PB_Window_SystemMenu|#PB_Window_WindowCentered)
CreateGadgetList(WindowID(#windowstate))
ProgressBarGadget(#progb,10,10,480,30,1,width*height/100,#PB_ProgressBar_Smooth)
SetActiveWindow(#windowstate)


zeit=timeGetTime_()
For y=2 To height-1
  For x=2 To width-1

    sobelysum=bild(x-1,y-1)+bild(x,y-1)<<1+bild(x+1,y-1)
    sobelysum2=bild(x-1,y+1)+bild(x,y+1)<<1+bild(x+1,y+1)
    sobelysum=Absl(sobelysum-sobelysum2)

    sobelxsum=bild(x-1,y-1)+bild(x-1,y)<<1+bild(x-1,y+1)
    sobelxsum2=bild(x+1,y-1)+bild(x+1,y)<<1+bild(x+1,y+1)
    sobelxsum=Absl(sobelxsum-sobelxsum2)

    StartDrawing(ImageOutput(#ausg))

    Plot(x-1,y-1,(sobelxsum+sobelysum)/5)

    StopDrawing()

    If synchtime<=timeGetTime_()-zeit
      SetGadgetState(#progb,Int((x+(y*width))/100))
      WindowEvent()
      zeit=timeGetTime_()
    EndIf
  Next
Next
CloseWindow(#windowstate)

speichern:
datei=SaveFileRequester("Speichern","","Bilder | *.bmp",0)
If datei
  If SaveImage(#ausg,RemoveString(datei,".bmp",1)+".bmp")=0 : Goto speichern : EndIf
Else
  End
EndIf

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -