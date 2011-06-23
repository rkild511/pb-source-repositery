; English forum:
; Author: Paul Leischow (updated for PB4.00 by blbltheworm)
; Date: 14. July 2002
; OS: Windows
; Demo: Yes


img=LoadImage(0,"..\..\Gfx\PureBasic.bmp")
width=ImageWidth(0)
height=ImageHeight(0)
CreateImage(1,width,height)


StartDrawing(ImageOutput(1))
  DrawImage(img,0,0)  
  If CreateFile(0,"Image.tga")
    For tmp=1 To 12
      Read header
      WriteByte(0,header)
    Next    
    WriteWord(0,width)
    WriteWord(0,height)    
    WriteByte(0,24)
    WriteByte(0,32)
  
    For y=0 To height-1
      For x=0 To width-1
        color=Point(x,y)        
        WriteByte(0,Blue(color))
        WriteByte(0,Green(color))
        WriteByte(0,Red(color))
      Next 
    Next
    
    CloseFile(0)
  EndIf 
StopDrawing()

MessageRequester("Done","BMP has been saved as TGA",0)
End


DataSection
  Data.l 0,0,2,0,0,0,0,16,0,0,0,0
EndDataSection

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; DisableDebugger