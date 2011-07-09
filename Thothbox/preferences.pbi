Procedure LoadPreferences()
  If OpenPreferences(#prg_name$+".prefs")
    
    ClosePreferences()
  EndIf
EndProcedure

Procedure SavePreferences()
  If CreatePreferences(#prg_name$+".prefs")
    
    ClosePreferences()
  EndIf
EndProcedure
; IDE Options = PureBasic 4.60 Beta 3 (Windows - x86)
; CursorPosition = 1
; Folding = -
; EnableXP