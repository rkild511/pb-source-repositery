; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=2097&highlight=
; Author: Smash (updated for PB 4.00 by Andre)
; Date: 25. August 2003
; OS: Windows
; Demo: Yes


;========= 
; @ Smash 
;========= 
; 
;        Hier steht tats�chlich ein brauchbarer Text. 
; 
;################################################################ 
Titel.s= "T��t V��s����ss�����" 
info.s= "" 
info01.s = "D�� P���Bs�� E��t�� ����� ��� ��� P���Bs�� P���������s����� ��t������t" 
info02.s = "��� �t ����� s�������� F�t���s, ��� ��t� ���� ��s������ ������." 
info03.s = "E� ���� ����� �䁆t���� ������ ��� ���t��s����tt���s E��t�����," 
info04.s = "��� W��t���䌘��� �t�. ��t��st�t���. E�� V�s������ D�s����� �st �����ts ��������." 
info05.s = "U�� ��t�t ��� ���� ���� T��t V��s����ss�����." 

info.s= Chr(13)+Chr(10)+ info01 + Chr(13)+Chr(10) 
info.s= info.s + info02 + Chr(13)+Chr(10) 
info.s= info.s + info03 + Chr(13)+Chr(10) 
info.s= info.s + info04 + Chr(13)+Chr(10)+ Chr(13)+Chr(10) 
info.s= info.s + info05 + Chr(13)+Chr(10) 

;################################################################ 
;-entschluesseln 
Procedure.s Maximum(code.s) 
  von.w = 127 
  zu.w  = 97 
  String$ = code.s              
  For a = 0 To 25 
    If a = 18 ; schlie�e diese beiden Zeichen aus (�=145) (�=146) 
      a = a+2 ; siehe  Tools `ASCII Table� 
    EndIf      
    von$ = Chr(von.w+a) 
    zu$ = Chr(zu.w+a) 
    String$ = ReplaceString (String$,von$,zu$ ) 
  Next a 
  Result.s = String$ 
  ProcedureReturn Result 
EndProcedure 

info.s = Maximum(info.s) 
Titel.s = Maximum(Titel.s) 

;################################################################ 

If OpenWindow(1, 153, 164, 430, 314, Titel.s, #PB_Window_ScreenCentered | #PB_Window_TitleBar) 
  If CreateGadgetList(WindowID(1)) 
    StringGadget(50,  10, 10, 410, 250,"", #ES_MULTILINE|#WS_VSCROLL |#PB_String_ReadOnly) 
    ButtonGadget(21, 340, 270, 80, 35, "OK") 
    SetGadgetText(50,info) 
  EndIf 
EndIf 

;################################################################ 
Repeat 
    Select WindowEvent() 
; ------------------ 
      Case #PB_Event_CloseWindow   ; ALT+F4 
            End          

      Case #PB_Event_Gadget 
        Select EventGadget() 
           Case 21 
              CloseWindow(1) 
              End 
        EndSelect 
; ------------------ 
    EndSelect 
Delay (3) 
ForEver 
;################################################################
; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; EnableXP
