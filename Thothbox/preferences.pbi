Procedure LoadPreferences()
  If OpenPreferences(#prg_name$+".prefs")
    gp\language=ReadPreferenceString("language", "français.lng")
    gp\server=ReadPreferenceString("server", "http://localhost/thothbox.php")
    gp\useProxy=ReadPreferenceInteger("useProxy", #False)
    gp\proxy\host=ReadPreferenceString("proxyHost", "")
    gp\proxy\port=ReadPreferenceInteger("proxyPort", 80)
    gp\proxy\login=ReadPreferenceString("proxyLogin", "")
    gp\proxy\password=ReadPreferenceString("proxyPassword", "")
    ClosePreferences()
  EndIf
  EndProcedure
  
  Procedure SavePreferences()
  If CreatePreferences(#prg_name$+".prefs")
    WritePreferenceString("language", gp\language)
    WritePreferenceString("server", gp\server)
    WritePreferenceInteger("useProxy", gp\useProxy)
    WritePreferenceString("proxyHost", gp\proxy\host)
    WritePreferenceInteger("proxyPort", gp\proxy\port)
    WritePreferenceString("proxyLogin", gp\proxy\login)
    WritePreferenceString("proxyPassword", gp\proxy\password)
    ClosePreferences()
  EndIf
  
  
EndProcedure
  
  
Procedure InitLanguageGadget()
   If ExamineDirectory(0, GetCurrentDirectory()+"languages\", "*.*")  
    Define n.l=-1
    While NextDirectoryEntry(0)
      If DirectoryEntryType(0) = #PB_DirectoryEntry_File
        n+1
        AddGadgetItem(#gdt_prefsLanguage,n,DirectoryEntryName(0))
        Debug DirectoryEntryName(0)
        If DirectoryEntryName(0)=gp\language
          Debug"SELECT"
          SetGadgetState(#gdt_prefsLanguage,n)
        EndIf
        
      EndIf
    Wend
    FinishDirectory(0)
  EndIf
EndProcedure  
  
Procedure InitGadgets()  
  
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
  
  SetGadgetText(#gdt_prefsServer,gp\server)
  SetGadgetText(#gdt_poxyHost,gp\proxy\host)
  SetGadgetState(#gdt_poxyPort,gp\proxy\port)
  SetGadgetText(#gdt_poxyLogin,gp\proxy\login)
  SetGadgetText(#gdt_poxyPassword,gp\proxy\password)
  InitLanguageGadget()
EndProcedure


; IDE Options = PureBasic 4.60 Beta 3 (Windows - x86)
; Folding = -
; EnableXP