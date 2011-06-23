; English forum: http://www.purebasic.fr/english/viewtopic.php?t=14118&highlight=
; Author: HeXor (updated for PB 4.00 by Andre)
; Date: 28. February 2005
; OS: Windows
; Demo: Yes


; Loading a FSH file from memory (data block).
; FSH is a Furcadia SHape file, from the game named Furcadia. 
; Basically it's a file that stores XY values and one image. 

Restore Start 
Read Length.l 

*buffer = AllocateMemory(Length) 
For i = 0 To Length - 1 
  Read byte.b 
  PokeB(*buffer + i, byte) 
Next i 

Id.l = CatchImage(0, *buffer) 
If OpenWindow(0, 1, 1, 32, 32, "", #PB_Window_SystemMenu) 
  CreateGadgetList(WindowID(0)) 
  ImageGadget(0, 1, 1, ImageWidth(0), ImageHeight(0), ID) 
  
  Repeat 
  
  Until WindowEvent() = #PB_Event_CloseWindow 
  
EndIf 
FreeMemory(*buffer) 
End 




DataSection 
  Start: 
  Data.l 766 
  Data.b 0, 0, 1, 0, 1, 0, 32, 32 
  Data.b 16, 0, 0, 0, 0, 0, -24, 2 
  Data.b 0, 0, 22, 0, 0, 0, 40, 0 
  Data.b 0, 0, 32, 0, 0, 0, 64, 0 
  Data.b 0, 0, 1, 0, 4, 0, 0, 0 
  Data.b 0, 0, -128, 2, 0, 0, 0, 0 
  Data.b 0, 0, 0, 0, 0, 0, 0, 0 
  Data.b 0, 0, 0, 0, 0, 0, 0, 0 
  Data.b 0, 0, 0, 0, -128, 0, 0, -128 
  Data.b 0, 0, 0, -128, -128, 0, -128, 0 
  Data.b 0, 0, -128, 0, -128, 0, -128, -128 
  Data.b 0, 0, -128, -128, -128, 0, -64, -64 
  Data.b -64, 0, 0, 0, -1, 0, 0, -1 
  Data.b 0, 0, 0, -1, -1, 0, -1, 0 
  Data.b 0, 0, -1, 0, -1, 0, -1, -1 
  Data.b 0, 0, -1, -1, -1, 0, 0, 0 
  Data.b 0, 0, 0, 0, 0, 0, 0, 0 
  Data.b 0, 0, 0, 0, 0, 0, 0, 0 
  Data.b 0, 0, 0, 0, -69, -69, -69, -80 
  Data.b 0, 0, 0, 0, 0, 0, 0, 0 
  Data.b 0, 0, 11, -69, -18, -52, -52, -52 
  Data.b -52, -52, -18, -18, -32, 0, 0, 0 
  Data.b 0, 11, -71, -103, -18, -52, -52, -52 
  Data.b -52, -52, -18, -18, -32, 0, 0, 0 
  Data.b 0, -69, -112, 0, 14, -52, -52, -52 
  Data.b -52, -52, -18, -18, -32, 0, 0, 0 
  Data.b 11, -103, 0, 0, 0, -52, -52, 0 
  Data.b 0, 9, -101, 0, 0, 0, 0, 0 
  Data.b -71, 0, 0, 0, 0, 12, -52, -64 
  Data.b 0, 0, 9, -80, 0, 0, 0, 11 
  Data.b -112, 0, 0, 0, 0, 0, -52, -52 
  Data.b 0, 0, 0, -101, 0, 0, 0, -69 
  Data.b -112, 0, 0, 0, 0, 0, 12, -52 
  Data.b -64, 0, 0, -101, -80, 0, 0, -71 
  Data.b 0, 0, 0, 0, 0, 0, 0, -52 
  Data.b -52, 0, 0, 9, -80, 0, 11, -112 
  Data.b 0, 0, 0, 0, 0, 0, 0, 12 
  Data.b -52, -64, 0, 0, -101, 0, 14, -18 
  Data.b 0, 0, 0, 0, 0, -52, -64, 0 
  Data.b -52, -52, -32, 0, -101, 0, 14, -18 
  Data.b 0, 0, 0, 0, 0, -52, -64, 0 
  Data.b 0, -52, -18, 0, -101, 0, -66, -18 
  Data.b 0, 0, 0, 0, 0, -52, -64, 0 
  Data.b 0, 12, -18, -32, 9, -80, -66, -18 
  Data.b 0, 0, 0, 0, 0, -52, -64, 0 
  Data.b 0, 0, -18, -18, 9, -80, -66, -18 
  Data.b 0, 0, 0, 0, 0, -52, -64, 0 
  Data.b 0, 0, 14, -18, -23, -80, -66, -18 
  Data.b 0, 0, 0, 0, 0, -52, -52, -52 
  Data.b -52, -52, -18, -18, -23, -80, -66, -18 
  Data.b 0, 0, 0, 0, 0, -52, -52, -52 
  Data.b -52, -52, -18, -18, -23, -80, -66, -18 
  Data.b 0, 0, 0, 0, 0, -52, -64, 0 
  Data.b 0, 0, 0, 0, 9, -80, -66, -18 
  Data.b 0, 0, 0, 0, 0, -52, -64, 0 
  Data.b 0, 0, 0, 0, 9, -80, 14, -18 
  Data.b 0, 0, 0, 0, 0, -52, -64, 0 
  Data.b 0, 0, 0, 0, -101, 0, 14, -18 
  Data.b 0, 0, -18, 0, 0, -52, -64, 0 
  Data.b 0, 0, 0, 0, -101, 0, 14, -18 
  Data.b 0, 14, -18, -32, 0, -52, -64, 0 
  Data.b 0, 0, 0, 0, -101, 0, 14, -18 
  Data.b 0, -18, -18, -18, 0, -52, -64, 0 
  Data.b 0, 0, 0, 9, -80, 0, 14, -18 
  Data.b -98, -18, -18, -18, -32, -52, -64, 0 
  Data.b 0, 0, 0, -101, -80, 0, 14, -18 
  Data.b -18, -18, 0, -18, -18, -52, -64, 0 
  Data.b 0, 0, 0, -101, 0, 0, 14, -18 
  Data.b -18, -32, 0, 14, -18, -52, -64, 0 
  Data.b 0, 0, 9, -80, 0, 0, 14, -18 
  Data.b -18, -103, 0, 0, -18, -52, -64, 0 
  Data.b 0, 9, -101, 0, 0, 0, 14, -18 
  Data.b -32, -69, -112, 0, 14, -52, -64, 0 
  Data.b 0, -101, -80, 0, 0, 0, 14, -18 
  Data.b -32, 11, -71, -103, 14, -52, -64, 9 
  Data.b -103, -69, 0, 0, 0, 0, 0, -18 
  Data.b 0, 0, 11, -69, -103, -52, -103, -101 
  Data.b -69, 0, 0, 0, 0, 0, 0, 0 
  Data.b 0, 0, 0, 0, -69, -69, -69, -80 
  Data.b 0, 0, 0, 0, 0, 0, -1, -16 
  Data.b 31, -1, -1, -128, 3, -1, -2, 0 
  Data.b 0, 7, -4, 0, 0, 7, -8, 0 
  Data.b 0, 7, -16, 0, 0, 31, -32, 0 
  Data.b 0, 15, -64, 0, 0, 7, -128, 0 
  Data.b 0, 3, -128, 0, 0, 3, 0, 0 
  Data.b 0, 1, 0, 0, 0, 1, 0, 0 
  Data.b 0, 1, 0, 0, 0, 0, 0, 0 
  Data.b 0, 0, 0, 0, 0, 0, 0, 0 
  Data.b 0, 0, 0, 0, 0, 0, 0, 0 
  Data.b 0, 0, 0, 0, 0, 0, 0, 0 
  Data.b 0, 1, 0, 0, 0, 1, 0, 0 
  Data.b 0, 1, -128, 0, 0, 1, -128, 0 
  Data.b 0, 3, -128, 0, 0, 7, -128, 0 
  Data.b 0, 15, -128, 0, 0, 31, -128, 0 
  Data.b 0, 63, -124, 0, 0, 127, -50, 0 
  Data.b 0, -1, -1, -128, 3, -1 
EndDataSection 

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -