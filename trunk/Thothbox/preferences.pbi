Procedure LoadPreferences()
  If OpenPreferences(#prg_name$+".prefs")
    gp\useProxy=ReadPreferenceInteger("useProxy", #False)
    gp\proxy\host=ReadPreferenceString("proxyHost", "")
    gp\proxy\port=ReadPreferenceInteger("proxyPort", 80)
    gp\proxy\login=ReadPreferenceString("proxyLogin", "")
    gp\proxy\password=ReadPreferenceString("proxyPassword", "")
    ClosePreferences()
  EndIf
  If gp\useProxy=#True
    SetGadgetState(#gdt_usePoxy, #PB_Checkbox_Checked)
    DisableGadget(#gdt_poxyHost,0)
    DisableGadget(#gdt_poxyPort,0)
    DisableGadget(#gdt_poxyLogin,0)
    DisableGadget(#gdt_poxyPassword,0)
  Else
    SetGadgetState(#gdt_usePoxy,#PB_Checkbox_Unchecked)
    DisableGadget(#gdt_poxyHost,1)
    DisableGadget(#gdt_poxyPort,1)
    DisableGadget(#gdt_poxyLogin,1)
    DisableGadget(#gdt_poxyPassword,1)
  EndIf
  
  SetGadgetText(#gdt_poxyHost,gp\proxy\host)
  SetGadgetState(#gdt_poxyPort,gp\proxy\port)
  SetGadgetText(#gdt_poxyLogin,gp\proxy\login)
  SetGadgetText(#gdt_poxyPassword,gp\proxy\password)
EndProcedure

Procedure SavePreferences()
  If CreatePreferences(#prg_name$+".prefs")
    WritePreferenceInteger("useProxy", gp\useProxy)
    WritePreferenceString("proxyHost", gp\proxy\host)
    WritePreferenceInteger("proxyPort", gp\proxy\port)
    WritePreferenceString("proxyLogin", gp\proxy\login)
    WritePreferenceString("proxyPassword", gp\proxy\password)
    ClosePreferences()
  EndIf
  
  
EndProcedure
; IDE Options = PureBasic 4.60 Beta 3 (Windows - x86)
; CursorPosition = 16
; Folding = -
; EnableXP