; German forum: http://www.purebasic.fr/german/viewtopic.php?t=830
; Author: DarkDragon
; Date: 28. May 2006
; OS: Windows
; Demo: Yes

;ConsoleSpezific 
Procedure ConvertColor(Color.l) 
  r = Red(Color) 
  g = Green(Color) 
  b = Blue(Color) 
  If r>192 :r=255:ElseIf r>32:r=128:EndIf 
  If g>192 :g=255:ElseIf g>32:g=128:EndIf 
  If b>192 :b=255:ElseIf b>32:b=128:EndIf 
  If r=  0 And g=  0   And b=  0 : ProcedureReturn 0  : EndIf 
  If r=  0 And g=  0   And b=128 : ProcedureReturn 1  : EndIf 
  If r=  0 And g=128   And b=  0 : ProcedureReturn 2  : EndIf 
  If r=  0 And g=128   And b=128 : ProcedureReturn 3  : EndIf 
  If r=128 And g=  0   And b=  0 : ProcedureReturn 4  : EndIf 
  If r=128 And g=  0   And b=128 : ProcedureReturn 5  : EndIf 
  If r=128 And g=128   And b=  0 : ProcedureReturn 6  : EndIf 
  If r=128 And g=128   And b=128 : ProcedureReturn 7  : EndIf 
  If r=  0 And g=  0   And b=255 : ProcedureReturn 9  : EndIf 
  If r=  0 And g=255   And b=  0 : ProcedureReturn 10 : EndIf 
  If r=  0 And g=255   And b=255 : ProcedureReturn 11 : EndIf 
  If r=255 And g=  0   And b=  0 : ProcedureReturn 12 : EndIf 
  If r=255 And g=  0   And b=255 : ProcedureReturn 13 : EndIf 
  If r=255 And g=255   And b=  0 : ProcedureReturn 14 : EndIf 
  If r=255 And g=255   And b=255 : ProcedureReturn 15 : EndIf 
EndProcedure 

;|||||||||||||||||||| 
#HTML_FONT_COLOR = 2 
#HTML_FONT_SIZE = 4 
#HTML_FONT_FACE = 8 

Procedure MyPrint(String.s) 
  Shared My_X, My_Y, My_SizeY 
  
  Print(String.s) 
EndProcedure 

Procedure MyPrintN(String.s) 
  Shared My_X, My_Y, My_SizeY 
  
  PrintN(String.s) 
EndProcedure 

Procedure MyChangeFont(Flag, Value) 
  Shared My_X, My_Y, My_SizeY 
  
  Select Flag 
    Case #HTML_FONT_COLOR 
      ConsoleColor(ConvertColor(Value), 0) 
  EndSelect 
EndProcedure 

;-HTML_Renderer 
Procedure HexVal(a$) 
  a$=Trim(UCase(a$)) 
  If Asc(a$)='$' 
    a$=Trim(Mid(a$,2,Len(a$)-1)) 
  EndIf 
  result=0 
  *adr.byte=@a$ 
  For i=1 To Len(a$) 
    result<<4 
    Select *adr\B 
      Case '0' 
      Case '1':result+1 
      Case '2':result+2 
      Case '3':result+3 
      Case '4':result+4 
      Case '5':result+5 
      Case '6':result+6 
      Case '7':result+7 
      Case '8':result+8 
      Case '9':result+9 
      Case 'A':result+10 
      Case 'B':result+11 
      Case 'C':result+12 
      Case 'D':result+13 
      Case 'E':result+14 
      Case 'F':result+15 
      Default:i=Len(a$) 
    EndSelect 
    *adr+1 
  Next 
  ProcedureReturn result 
EndProcedure 

Procedure HTMLColorCode(color.s) 
  Protected color2.s, k.l 
  For k=Len(color.s) To 1 Step -1 
    color2.s + Mid(color.s, k, 1) 
  Next 
  ProcedureReturn HexVal(color2) 
EndProcedure 

Structure HTML_Tag 
  name.s 
  prop.s 
EndStructure 

Structure HTML_Font 
  Color.l 
EndStructure 

Global NewList Tag.HTML_Tag() 

Procedure.s GetProperity(PropName.s, Prop.s) ; Will filter the value of each properity(e.g. <... name="this or" color="this will be the result" ...>) 
  Protected i.l, char.b, cur.b, cap.l 
  result.s = "" 
  Start = FindString(LCase(Prop), LCase(PropName), 0) 
  If Start > 0 
    For i=Start-1 To Len(Prop)-1 
      cur = PeekB(@Prop+i) 
      If cap = 0 
        If cur = '"' Or cur = 39 
          cap = 1 
        EndIf 
      Else 
        If cur = '"' Or cur = 39 
          Break 
        Else 
          result + Chr(cur) 
        EndIf 
      EndIf 
    Next 
  EndIf 
  ProcedureReturn result 
EndProcedure 

Procedure.s FindLastTag(Name.s, PropName.s) 
  If LastElement(Tag()) 
    Repeat 
      If LCase(Tag()\name) = LCase(Name) 
        result.s = GetProperity(PropName, Tag()\prop) 
        Break 
      EndIf 
    Until PreviousElement(Tag()) = 0 
    LastElement(Tag()) 
  EndIf 
  ProcedureReturn result.s 
EndProcedure 

Procedure IsTag(Name.s) 
  If LastElement(Tag()) 
    Repeat 
      If LCase(Tag()\name) = LCase(Name) 
        result = 1 
        Break 
      EndIf 
    Until PreviousElement(Tag()) = 0 
    LastElement(Tag()) 
  EndIf 
  ProcedureReturn result 
EndProcedure 

Procedure.s ReplaceTag(Code.s, Tag.s, Rep.s) 
  Protected char.b, k.l, value.s 
  Start = -1 
  Stop = 0 
  For k=0 To Len(Code)-1 
    char.b = PeekB(@Code+k) 
    If char = '<' 
      Start = k 
      Stop = 0 
      value.s = "" 
    ElseIf char = '>' And Start <> -1 
      Stop = k+1 
      If LCase(Trim(value)) = LCase(Tag) 
      Code.s = Left(Code, Start)+Rep+Right(Code, Len(Code)-Stop) 
      k = Start 
      EndIf 
      Start = -1 
      Stop = 0 
    ElseIf Start <> -1 And Stop = 0 
      value.s + Chr(char) 
    EndIf 
  Next 
  ProcedureReturn Code.s 
EndProcedure 

Procedure ConsoleHTML(Code.s) 
  Protected size.l, k.l, tag_mode.l, cap_name.l, tag.s, char.b, Font.HTML_Font 
  size = Len(Code) 
  Code = ReplaceString(ReplaceTag(Code, "br", Chr(1)), "  ", " ") 
  For k=0 To size-1 
    char.b = PeekB(@Code+k) 
    If char = '<' 
      tag_mode = 1 
      LastElement(Tag()) 
      AddElement(Tag()) 
    ElseIf char = '>' 
      ;Here we will check if it is a </...> tag 
      If tag_mode = 1 
        tag.s = Trim(Tag()\name) 
        
        If PeekB(@tag) = '/' 
          tag = Trim(Right(tag, Len(tag)-1)) 
          DeleteElement(Tag()) 
          If LastElement(Tag()) 
            Repeat 
              If LCase(Tag()\name) = LCase(tag) 
                DeleteElement(Tag()) 
                Break 
              EndIf 
            Until PreviousElement(Tag()) = 0 
          EndIf 
        EndIf 
      EndIf 
      
      ;Refresh the current values 
      Font\Color = HTMLColorCode(Trim(RemoveString(FindLastTag("font", "color"), "#"))) 
      ;Font\Size  = Val(FindLastTag("font", "size")) 
      
      MyChangeFont(#HTML_FONT_COLOR, Font\Color) 
      
      ;Set the modes to 0 
      tag_mode = 0 
      cap_name = 0 
    Else 
      If tag_mode = 1 
        
        If cap_name = 0 
          If char = ' ' 
            tag.s = Trim(Tag()\name) 
            
            ;Here we will check if it is a </...> tag 
            If PeekB(@tag) = '/' 
              tag = Trim(Right(tag, Len(tag)-1)) 
              DeleteElement(Tag()) 
              If LastElement(Tag()) 
                Repeat 
                  If LCase(Tag()\name) = LCase(tag) 
                    DeleteElement(Tag()) 
                    Break 
                  EndIf 
                Until PreviousElement(Tag()) = 0 
              EndIf 
            EndIf 
            
            cap_name = 1 
          Else 
            Tag()\name + Chr(char) 
          EndIf 
        Else 
          Tag()\prop + Chr(char) 
        EndIf 
        
      Else 
        
        If char = 1 : MyPrintN("") : ElseIf char >= 32 And char <= 128 
        MyPrint(Chr(char)) 
        EndIf 
        
      EndIf 
    EndIf 
  Next 
EndProcedure 

Code.s = "<html>" 
Code.s + "<font color="+Chr(34)+"#0000FF"+Chr(34)+">Blau<br> Blau<br>"+#LF$ 
Code.s + "<font color="+Chr(34)+"#FF0000"+Chr(34)+">Rot<br> Rot</font>(Blau alte<br>Farbe)</font>"+#LF$ 
Code.s + "</html>" 

OpenConsole() 

ConsoleHTML(Code.s) 

PrintN("") 
Input() 
CloseConsole()

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = --
; EnableXP