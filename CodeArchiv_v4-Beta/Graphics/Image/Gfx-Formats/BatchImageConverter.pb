; English forum: http://www.purebasic.fr/english/viewtopic.php?t=8755&highlight=
; Author: DriakTravo (with help of Danilo, updated for PB4.00 by blbltheworm)
; Date: 16. December 2003
; OS: Windows
; Demo: Yes


; A program that will mass convert entire images into a different size and format.
; It can read BMP, JPG, JPEG, PNG, TGA and convert to BMP+JPG.

; 2nd version:
; You can select a save location and instead of the debugger, it uses the console.
; Also the Done message is different. 

Enumeration 1 
  #BMP 
  #JPG 
EndEnumeration 

UseJPEGImageDecoder() 
UsePNGImageDecoder() 
UseTGAImageDecoder() 

UseJPEGImageEncoder() 


ImagePath.s = PathRequester("Choose images to convert", "C:/")  
If ImagePath = "" 
  End 
EndIf 

SavePath.s = PathRequester("Choose a place to save", "C:/Converted Images/")  

OpenWindow(1, 415, 168, 135, 161, "Size and Type", #PB_Window_TitleBar ) 
  CreateGadgetList(WindowID(1)) 
  OptionGadget(1, 30, 20, 55, 15, "BMP") : SetGadgetState(1,1) 
  OptionGadget(2, 30, 40, 55, 15, "JPG") 

  StringGadget(5, 10, 65, 80, 20, "",#PB_String_Numeric) : SetGadgetText(5,"100") 
  StringGadget(6, 10, 90, 80, 20, "",#PB_String_Numeric) : SetGadgetText(6,"100") 

  TextGadget(7, 90, 70, 100, 15, "Width") 
  TextGadget(8, 90, 95, 100, 15, "Height") 

  ButtonGadget(9, 10, 120, 110, 15, "OK") 
  ButtonGadget(10, 10, 140, 110, 15, "Cancel") 

Repeat 
  Select WaitWindowEvent() 
    Case #PB_Event_Gadget 
      Select EventGadget() 
        Case 9 
          CloseWindow = 1 
        Case 10 
          End 
      EndSelect 
  EndSelect 
Until CloseWindow = 1 

ImageW = Val(GetGadgetText(5)) 
ImageH = Val(GetGadgetText(6)) 

If GetGadgetState(1) 
  FileType = #BMP 
ElseIf GetGadgetState(2) 
  FileType = #JPG 
EndIf 

Global NewList Files.s() 

Restore ImageTypes 

For a = 1 To 5 
  Read A$ 
  ExamineDirectory(1,ImagePath,"*."+A$) 
  Repeat 
    NextFile = NextDirectoryEntry(1) 
    If NextFile = 1 
      AddElement(Files()) 
      Files() = DirectoryEntryName(1) 
      CountFiles + 1 
    EndIf 
  Until NextFile = 0 
Next a 
OpenConsole() 
If CountList(Files()) 

  ForEach Files() 
    A$ = Files()  

    If LoadImage(1,ImagePath+A$) 
      ResizeImage(1,ImageW,ImageH) 

      A$ = ReplaceString(A$,".","_",1,Len(A$)-Len(GetExtensionPart(A$))-1) 
      If FileType = #BMP          
        SaveImage(1,SavePath+A$+".BMP",#PB_ImagePlugin_BMP,0) 
        ClearConsole() 
        ConsoleColor(10,0) 
        PrintN("Converted: ") 
        ConsoleColor(11,0) 
        PrintN("Converted: "+A$+".BMP") 
        PrintN("") 
        ConsoleColor(12,0) 
        PrintN("Image: ") 
        ConsoleColor(13,0) 
        FileDone + 1 
        PrintN(Str(FileDone)+"/"+Str(CountFiles)) 
      ElseIf FileType = #JPG  
        SaveImage(1,SavePath+A$+".JPG",#PB_ImagePlugin_JPEG,10) 
        ClearConsole() 
        ConsoleColor(10,0) 
        PrintN("Converted: ") 
        ConsoleColor(11,0) 
        PrintN("Converted: "+A$+".BMP") 
        PrintN("") 
        ConsoleColor(12,0) 
        PrintN("Image: ") 
        ConsoleColor(13,0) 
        FileDone + 1 
        PrintN(Str(FileDone)+"/"+Str(CountFiles)) 
      EndIf 
    EndIf 
  Next 
  CloseConsole() 
  MessageRequester("Success!","Success! Images saved in: "+SavePath) 
EndIf 
DataSection 
  ImageTypes: 
    Data.s "BMP","JPG","JPEG","PNG","TGA" 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; EnableXP
