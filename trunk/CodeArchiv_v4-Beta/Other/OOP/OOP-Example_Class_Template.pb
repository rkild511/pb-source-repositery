; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=2008&highlight=
; Author: NoOneKnows (updated for PB 4.00 by Andre)
; Date: 17. August 2003
; OS: Windows
; Demo: Yes


; Include file for OOP-Example_Class_Test.pb file !!

#CLASSCALL_CREATE = 1 
#CLASSCALL_DELETE = 2 
#CLASSCALL_PRINT  = 11 

;{- OBJECT 

    Structure Object 
        class.l 
        b.b[100] ;dient als Puffer, um aus einem "Object" jede belibige andere Klasse zu erstellen, 
                 ;evtl müßte der Wert in Klammer erhöht werden 
    EndStructure 

    Global NewList xclClassObject.Object() 

    Declare.l Object(*obj.Object, classCall.l) 
    Declare   DeleteObject(*obj.Object) 
    Declare.l NewObject(class.l) 
    Declare   DeleteRawObject(*obj.Long) 

    ;Klassenprozedur 
    Procedure.l Object(*obj.Object, classCall.l) 
        Select classCall 
            Case #CLASSCALL_CREATE 
                AddElement(xclClassObject()) 
                xclClassObject()\class = @Object() 
                ProcedureReturn xclClassObject() 
            Case #CLASSCALL_DELETE 
                DeleteRawObject(@*obj) 
      EndSelect 
    EndProcedure 

    Procedure DeleteRawObject(*obj.Long) 
        If *obj\l 
            If FirstElement(xclClassObject()) 
                Repeat 
                    If *obj\l = xclClassObject() 
                        DeleteElement(xclClassObject()) 
                        *obj\l = 0 
                    EndIf 
                Until NextElement(xclClassObject()) = 0 
            EndIf 
            
        EndIf 
    EndProcedure 
    
    Procedure DeleteObject(*obj.Object) ;genügt um ein Objeckt zu löschen, der Pointer wird jedoch nicht auf 0 gesetzt 
        If *obj And *obj\class 
            CallFunctionFast(*obj\class, *obj, #CLASSCALL_DELETE) 
        EndIf 
    EndProcedure 
    
    Procedure DeleteRefObject(*obj.Long) ;hier wird auch der Pointer zurückgesetzt (ist sicherer!) 
        If PeekL(*obj\l) And *obj\l 
            CallFunctionFast(PeekL(*obj\l), *obj\l, #CLASSCALL_DELETE) 
            *obj\l = 0 
        EndIf 
    EndProcedure 
    
    Procedure.l NewObject(class.l) 
        If class 
            ProcedureReturn CallFunctionFast(class, 0, #CLASSCALL_CREATE) 
        Else 
            ProcedureReturn 0 
        EndIf 
    EndProcedure 

;}- 

;{- CLASS MyClassTemplate 

    Structure ClassMyClassTemplate 
        class.l ;ist in jeder Klasse Pflicht, da es den Klassentyp festlegt 
        ;es folgen Eigenschaften / Variablen 
    EndStructure 
    
    Global NewList xclClassMyClassTemplate.ClassMyClassTemplate() 
    
    Declare.l ClassMyClassTemplate(*obj.Object, classCall.l) 
    Declare   DeleteObjectMyClassTemplate(*obj.Long) 
    Declare.l NewMyClassTemplate() 
    
    ;Klassenprozedur 
    Procedure.l ClassMyClassTemplate(*obj.Object, classCall.l) 
        Select classCall 
            Case #CLASSCALL_CREATE 
                AddElement(xclClassMyClassTemplate()) 
                xclClassMyClassTemplate()\class = @ClassMyClassTemplate() 
                ProcedureReturn xclClassMyClassTemplate() 
            Case #CLASSCALL_DELETE 
                If *obj 
                    DeleteObjectMyClassTemplate(@*obj) 
                EndIf 
        EndSelect 
    EndProcedure 
    
    ;quasi Destruktor 
    Procedure DeleteObjectMyClassTemplate(*obj.Long) 
        If *obj\l 
            If FirstElement(xclClassMyClassTemplate()) 
                Repeat 
                    If *obj\l = xclClassMyClassTemplate() 
                        DeleteElement(xclClassMyClassTemplate()) 
                        *obj\l = 0 
                    EndIf 
                Until NextElement(xclClassMyClassTemplate()) = 0 
            EndIf 
            
        EndIf 
    EndProcedure 
    
    ;quasi Konstruktor 
    Procedure.l NewMyClassTemplate() 
        ClassMyClassTemplate(0, #CLASSCALL_CREATE) 
        
        ;Initialisierungscode 
        ;z.B.: xclClassMyClassTemplate()\parameter = parameter 
        
        ProcedureReturn xclClassMyClassTemplate() 
    EndProcedure 
    
    ;Klassenmethoden: 
    ;Procedure cmctDoSomething(*obj.ClassMyClassTemplate) 
    ;    ;... 
    ;EndProcedure 

;}- 

;{- CLASS Text 

    Structure ClassText 
        class.l 
        text$ 
    EndStructure 
    
    Global NewList xclClassText.ClassText() 
    
    Declare.l ClassText(*obj.Object, classCall.l) 
    Declare   DeleteObjectText(*obj.Long) 
    Declare.l NewText(text$) 
    
    Declare   cTxtPrintN(*obj.ClassText) 
    
    Procedure.l ClassText(*obj.Object, classCall.l) 
        Select classCall 
            Case #CLASSCALL_CREATE 
                AddElement(xclClassText()) 
                xclClassText()\class = @ClassText() 
                ProcedureReturn xclClassText() 
            Case #CLASSCALL_DELETE 
                If *obj 
                    ;Debug *obj 
                    DeleteObjectText(@*obj) 
                    ;Debug "nach DeleteObjectText " + Str(*obj) 
                EndIf 
            Case #CLASSCALL_PRINT 
                cTxtPrintN(*obj) 
        EndSelect 
    EndProcedure 
    
    Procedure DeleteObjectText(*obj.Long) 
        If *obj\l 
            ;Debug "search for " + Str(*obj\l) 
            If FirstElement(xclClassText()) 
                Repeat 
                    If *obj\l = xclClassText() 
                        ;Debug "found" 
                        DeleteElement(xclClassText()) 
                        *obj\l = 0 
                    EndIf 
                Until NextElement(xclClassText()) = 0 
            EndIf 
            
        EndIf 
    EndProcedure 
    
    Procedure.l NewText(text$) 
        ClassText(0, #CLASSCALL_CREATE) 
        
        xclClassText()\text$ = text$ 
        
        ProcedureReturn xclClassText() 
    EndProcedure 
    
    Procedure cTxtSetText(*obj.ClassText, text$) 
        *obj\text$ = text$ 
    EndProcedure 
    
    Procedure cTxtPrint(*obj.ClassText) 
        Print(*obj\text$) 
    EndProcedure 
    
    Procedure cTxtPrintN(*obj.ClassText) 
        PrintN(*obj\text$) 
    EndProcedure 
    
;}- 
    
    
;Vererbung    
    
;{- CLASS ColorText : CLASS Text 
    
    Structure ClassColorText 
        class.l 
        text$ ;Klasseneigenschaften von Class text müssen exakt übernommen werden danach kann beliebig angefügt werden 
        
        ;Neue Eigenschaften 
        fcolor.b 
        bcolor.b 
    EndStructure 
    
    Global NewList xclClassColorText.ClassColorText() 
    
    Declare.l ClassColorText(*obj.Object, classCall.l) 
    Declare   DeleteObjectColorText(*obj.Long) 
    Declare.l NewColorText(text$, fcolor.b, bcolor.b) 
    
    Declare   cClrTxtPrintN(*obj.ClassColorText) 
    
    Procedure.l ClassColorText(*obj.Object, classCall.l) 
        Select classCall 
            Case #CLASSCALL_CREATE 
                AddElement(xclClassColorText()) 
                xclClassColorText()\class = @ClassColorText() 
                ProcedureReturn xclClassColorText() 
            Case #CLASSCALL_DELETE 
                If *obj 
                    DeleteObjectColorText(@*obj) 
                EndIf 
            Case #CLASSCALL_PRINT 
                cClrTxtPrintN(*obj) 
        EndSelect 
    EndProcedure 
    
    Procedure DeleteObjectColorText(*obj.Long) 
        If *obj\l 
            If FirstElement(xclClassColorText()) 
                Repeat 
                    If *obj\l = xclClassColorText() 
                        DeleteElement(xclClassColorText()) 
                        *obj\l = 0 
                    EndIf 
                Until NextElement(xclClassColorText()) = 0 
            EndIf 
            
        EndIf 
    EndProcedure 
    
    Procedure.l NewColorText(text$, fcolor.b, bcolor.b) 
        ClassColorText(0, #CLASSCALL_CREATE) 
        
        xclClassColorText()\text$ = text$ 
        xclClassColorText()\fcolor = fcolor 
        xclClassColorText()\bcolor = bcolor 
        
        ProcedureReturn xclClassColorText() 
    EndProcedure 
    

    Procedure cClrTxtPrintN(*obj.ClassColorText) 
        ConsoleColor(*obj\fcolor, *obj\bcolor) 
        cTxtPrintN(*obj) ;Funktion der übergeordnete Klasse aufrufen 
        ConsoleColor(7, 0) ;Wieder Standardfarbe setzen 
    EndProcedure 
    
;}- 
    
    
;ist von der Logik näher an OOP als die Klasse zuvor, da hier ClassText direkt als Pointer in die Struktur mit aufgenommen wird 
;von der Handhabung zwar etwas umständlicher, aber unnötige Fehler bei der Änderung der Basis-Klasse werden hier vermieden 
;{- CLASS AlternativeColorText : CLASS Text 
    
    Structure ClassAlternativeColorText 
        class.l 
        *ClassText.ClassText 
        
        ;Neue Eigenschaften 
        fcolor.b 
        bcolor.b 
    EndStructure 
    
    Global NewList xclClassAlternativeColorText.ClassAlternativeColorText() 
    
    Declare.l ClassAlternativeColorText(*obj.Object, classCall.l) 
    Declare   DeleteObjectAlternativeColorText(*obj.Long) 
    Declare.l NewAlternativeColorText(text$, fcolor.b, bcolor.b) 
    
    Declare   cAltClrTxtPrintN(*obj.ClassAlternativeColorText) 
    
    Procedure.l ClassAlternativeColorText(*obj.Object, classCall.l) 
        Select classCall 
            Case #CLASSCALL_CREATE 
                AddElement(xclClassAlternativeColorText()) 
                xclClassAlternativeColorText()\class = @ClassAlternativeColorText() 
                ProcedureReturn xclClassAlternativeColorText() 
            Case #CLASSCALL_DELETE 
                If *obj 
                    DeleteObjectAlternativeColorText(@*obj) 
                EndIf 
            Case #CLASSCALL_PRINT 
                cAltClrTxtPrintN(*obj) 
        EndSelect 
    EndProcedure 
    
    Procedure DeleteObjectAlternativeColorText(*obj.Long) 
        If *obj\l 
            If FirstElement(xclClassAlternativeColorText()) 
                Repeat 
                    If *obj\l = xclClassAlternativeColorText() 
                        
                        DeleteObjectText(@xclClassAlternativeColorText()\ClassText) 
                        
                        DeleteElement(xclClassAlternativeColorText()) 
                        *obj\l = 0 
                    EndIf 
                Until NextElement(xclClassAlternativeColorText()) = 0 
            EndIf 
            
        EndIf 
    EndProcedure 
    
    Procedure.l NewAlternativeColorText(text$, fcolor.b, bcolor.b) 
        ClassAlternativeColorText(0, #CLASSCALL_CREATE) 
        
        xclClassAlternativeColorText()\ClassText = NewText(text$) 
        xclClassAlternativeColorText()\fcolor = fcolor 
        xclClassAlternativeColorText()\bcolor = bcolor 
        
        ProcedureReturn xclClassAlternativeColorText() 
    EndProcedure 
    
    Procedure cAltClrTxtPrintN(*obj.ClassAlternativeColorText) 
        ConsoleColor(*obj\fcolor, *obj\bcolor) 
        cTxtPrintN(*obj\ClassText) ;Funktion der übergeordnete Klasse aufrufen 
        ConsoleColor(7, 0) ;Wieder Standardfarbe setzen 
    EndProcedure 
    
;}- 
    
;-Klassenübergreifende Funktionen 

Procedure PrintTextN(*obj.Object) 
    If *obj And *obj\class 
        CallFunctionFast(*obj\class, *obj, #CLASSCALL_PRINT) 
    EndIf 
EndProcedure 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -----
