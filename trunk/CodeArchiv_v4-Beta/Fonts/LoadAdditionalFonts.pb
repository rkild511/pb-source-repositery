; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=1651&highlight=
; Author: GPI (updated for PB4.00 by blbltheworm)
; Date: 08. July 2003
; OS: Windows
; Demo: No

#Dir_Font = 0

Procedure LoadAdditionalFonts(Dir$) 
  ExamineDirectory(#Dir_Font,"Style\","*.TTF") 
  While NextDirectoryEntry(#Dir_Font) 
    AddFontResource_("Style\"+DirectoryEntryName(#Dir_Font)) 
  Wend 
  ExamineDirectory(#Dir_Font,"Style\","*.FON") 
  While NextDirectoryEntry(#Dir_Font) 
    AddFontResource_("Style\"+DirectoryEntryName(#Dir_Font)) 
  Wend 
  SendMessage_(#HWND_BROADCAST,#WM_FONTCHANGE,0,0) 
EndProcedure 

Procedure UnLoadAdditionalFonts(Dir$) 
  ExamineDirectory(#Dir_Font,"Style\","*.TTF") 
  While NextDirectoryEntry(#Dir_Font) 
    RemoveFontResource_("Style\"+DirectoryEntryName(#Dir_Font)) 
  Wend 
  ExamineDirectory(#Dir_Font,"Style\","*.FON") 
  While NextDirectoryEntry(#Dir_Font) 
    RemoveFontResource_("Style\"+DirectoryEntryName(#Dir_Font)) 
  Wend 
  SendMessage_(#HWND_BROADCAST,#WM_FONTCHANGE,0,0) 
EndProcedure  

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
