; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
; Nom du projet : Gadget Helpers Macros
; Nom du fichier : Gadget Helpers Macros.pbi
; Version du fichier : 0.0.0
; Programmation : En cours
; Programmé par : Guillaume Saumure
; Alias : Guimauve
; Courriel : gsaumure79@videotron.ca
; Date : 23-09-2011
; Mise à jour : 23-09-2011
; Code PureBasic : 4.60
; Plateforme : Windows, Linux, MacOS X
; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

Macro GadgetDown(GadgetID)
  
  GadgetY(GadgetID) + GadgetHeight(GadgetID)
  
EndMacro

Macro GadgetRight(GadgetID)

  GadgetX(GadgetID) + GadgetWidth(GadgetID)
  
EndMacro

Macro SearchGadget(SearchID, x, y, Width, Height)
  
 TextGadget(SearchID, (x), (y), Width, Height, "", #PB_Text_Center)
 StringGadget(SearchID + 1, (x) + (Width) + 4, (y), Width, Height, "")
 
EndMacro

Macro ResizeSearchGadget(SearchID, x, y, Width, Height)
  
 ResizeGadget(SearchID, (x), (y), Width, Height)
 ResizeGadget(SearchID + 1, (x) + (Width) + 4, (y), Width, Height)
 
EndMacro

Procedure DisableDependentGadget(FirstGadget, LastGadget)
  
  If GetGadgetState(FirstGadget) = #True
    DisableGadget = #False
  Else
    DisableGadget = #True
  EndIf
  
  For GadgetID = FirstGadget + 1 To LastGadget
    DisableGadget(GadgetID, DisableGadget)
  Next
    
EndProcedure

; <<<<<<<<<<<<<<<<<<<<<<<<<<
; <<<<< FIN DU FICHIER <<<<<
; <<<<<<<<<<<<<<<<<<<<<<<<<<
; IDE Options = PureBasic 4.60 RC 1 (Linux - x64)
; CursorPosition = 40
; FirstLine = 7
; Folding = -
; EnableXP