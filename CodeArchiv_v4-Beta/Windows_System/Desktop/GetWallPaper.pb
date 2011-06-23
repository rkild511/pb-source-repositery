; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=5177&highlight=
; Author: RayMan1970
; Date: 14. August 2004
; OS: Windows
; Demo: No

Procedure.s GetWallpaper()
  #SPI_GETDESKWALLPAPER = 115
  
  FileName.s = Space(260)
  
  SystemParametersInfo_(#SPI_GETDESKWALLPAPER, Len( FileName ),FileName ,0)
  
  ProcedureReturn  FileName
  
EndProcedure

Debug ( GetWallpaper() )
; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -