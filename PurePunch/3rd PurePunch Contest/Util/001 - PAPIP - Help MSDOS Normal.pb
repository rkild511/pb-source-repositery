;*****************************************************************************
;*
;* PurePunch Contest #3
;* Pour l'Aide cliquez une fois pour executer Double cliquez sur une ligne
;* Name     : "Help EXE MSDOS Normal"
;* Author   : PAPIPP
;* Category : UTIL
;* Date     : 17 / 07 / 09
;*
;*****************************************************************************
;----0---_____1____----2-----_____3____-----4----_____5____-----6----_____7____-
;2345678901234567890123456789012345678901234567890123456789012345678901234567890
Ci$="CMD COMP DATE LABEL":Macro M:Macro:EndMacro:M AGI:AddGadgetItem:EndMacro
:#W0=0:#L0=0:#L1=1:#G=2:M MR:MessageRequester:EndMacro::M RPS:ReadProgramString
 EndMacro:ci$+"MORE PAUSE SORT TIME" :Procedure OW0():
 If OpenWindow(#W0, 0, 0, 800, 600, "Dbl Clic"):ListViewGadget(#L0,0,0,800,300)
:EditorGadget(#L1,0,300,800,300,2048):EndIf:EndProcedure:Procedure AF(Gd,Cm$)
:prg=RunProgram("cmd","/C "+CM$,"",30):As$=Space($FFFF):ClearGadgetItems(Gd)
:If prg:As$=RPS(prg):OemToChar_(@as$,@as$):AGI(gd,-1,Cm$+":"+As$)
:While ProgramRunning(prg):As$ =RPS(prg):OemToChar_(@as$,@as$):AGI(Gd,-1, As$)
:Wend:EndIf:EndProcedure:OW0():Font1 = LoadFont(#PB_Any, "Courier New",8)
:SetGadgetFont(#L0, FontID(Font1)):SetGadgetFont(#L1, FontID(Font1))
:AF(#L0,"Help "):Repeat:WWE = WaitWindowEvent():Select WWE:Case 13100
:EG=EventGadget():ET=EventType():If EG = #L0:EL.l=GetGadgetState(#L0)
:EL$= GetGadgetItemText(#L0, El):Ps= FindString(el$," ", 1):CMD$=Mid(el$,1,ps-1)
If ET=0:cmd$="Help "+CMD$:AF(#L1,CMD$):EndIf:If ET=2:If FindString(Ci$,cmd$,0)=0
 :AF(#L1, "HELP "+CMD$):rs=MR ("EXECUTION DE "+CMD$,"Exécutez-vous cette Cmd",4)
 If rs=6:T$=InputRequester("EXEC "+cmd$,"Complétez la commande",cmd$+" ")
 cmd$=T$ :AF(#L1,CMD$):EndIf:Else: MR("Interdit",cmd$+" bloque le prg",0)
 EndIf:EndIf:EndIf:Case 16:EW = EventWindow():If EW = #W0:CloseWindow(#W0)
:Break:EndIf:EndSelect:ForEver 
; IDE Options = PureBasic 4.31 (Windows - x86)
; CursorPosition = 11
; Folding = -
; DisableDebugger