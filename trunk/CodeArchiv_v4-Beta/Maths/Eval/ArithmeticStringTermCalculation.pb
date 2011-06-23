; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=2321&highlight=
; Author: NoOneKnows (updated for PB4.00 by blbltheworm)
; Date: 17. September 2003
; OS: Windows
; Demo: Yes

;/****************************************************/; 
;/**   Arithmetic Term-String Calculation V 1.2.0   **/; 
;/**       by NoOneKnows <Torsten_Mail@Gmx.de>      **/; 
;/****************************************************/; 

;Funtktionsweise / Beschreibung: 
;_______________________________________________________________________________________________ 
; 
;Procedure EnableFunctionCalculation(bool.b) 
;                * Ermöglicht den Einsatz von Funktionen (z.B. 'Sqr') 
;                  Standardmäßig ist dies aus Performance-Gründen ausgeschalten 
;                  (kleiner Performance-Einbruch) 
;   bool.b       - 0 für falsch und <> 0 für wahr 

;Procedure EnableConstantCalculation(bool.b) 
;                * Ermöglicht den Einsatz von vordifinierten Konstanten 
;                  (führt zu geringfügigen Performance-Einbruch) 
;   bool.b       - 0 für falsch und <> 0 für wahr 


;CalculateF.f(expression$) / CalculateL.l(expression$) 
;   expression$  - eine arithmetischer Ausruck in Form eines Strings 
;                  z.B. "(1 + 3) * (4 - 7)" oder "9^(-2)*(4.5+8.1)" 
;                  Leerzeichen sind erlaubt, müssen jedoch nicht verwendet werden. 
;                  Erlaubte Operatoren sind '+', '-', '*', '/' und '^' (zum potenzieren), sowie 
;                  Funktionen (Sqr, Sin, ASin, Cos, ACos, Tan, ATan, Int, Abs, LogTen, Log) 
;                  Ausßerdem können belibig runde Klammern gesetzt werden. Es wird jedoch 
;                  nicht geprüft, ob die Klammersetzung plausibel ist. 
;   Rückgabe     - Zurück gibt die Funktion das Ergebnis als Float bzw. Long-Wert 
; 
;CreateSyntaxTree(*tree.SyntaxTree, expression$) 
;   *tree        - ein SyntaxTree, in den der SyntaxBaum abgelegt wird. Praktisch 
;                  für Funktionen, bei denen sich nur einzelne Parameter ändern und 
;                  und keine Operanten. Die Werte des zurückgegebenen SyntaxTree 
;                  können gefahrlos verändert werden. Ist *tree\root = 0, dann konnte 
;                  der Baum nicht erstellt werden 
;   expression$  - siehe CalculateX()  
; 
;CalculateSyntaxTreeF.f(*tree.SyntaxTree) / CalculateSyntaxTreeL.l(*tree.SyntaxTree) 
;   *tree        - ein zuvor mit CreateSyntaxTree() erstellter SyntaxTree. Er wird einfach 
;                  nur ausgerechnet 
;   Rückgabe     - Das Ergebnis in Form eines Float oder Long-Werts 
; 
;GetCalculationError.l() 
;   Rückgabe     - Gibt zurück ob ein Fehler aufgetreten ist (ungleich 0) 
;                  (siehe #CALC_ERR_???) 
;_______________________________________________________________________________________________ 
; 
; 
;Anmerkung: 
;Ohne viel Aufwand können auch weitere Operatoren, Funktionen und Konstanten hinzugefügt werden. 
;die Programmlogik braucht nicht angepasst zu werden. Um zum Beispiel einen neuen Operator 
;hinzuzufügen, einfach den Weg einer vorhanden Operator-Konstante (z.B. #OP_PLUS) verfolgen und 
;jeweils dort die neue Operator-Konstante mit den neuen Werten einfügen. Nur beim Operator 
;muß zusätzlich noch die Funktion Calc_GetContent() verändert werden 
; 
;Funktionen sind relativ langsam, da sie erst über einen ReplaceString wirksam werden 
;statt 'Sqr(2)' kann jedoch auch '1~(2)' geschrieben werden. Dann wird EnableFunctionCalculation() 
;überflüssig. '~' steht quasi als Funktionsoperator, während der Ausdruck davor, dem Funktions-Code 
;entspricht (siehe Funktions-Konstanten), entspricht der Wert dahinter dem zu verarbeitenden Wert 


;-*** D E C L A R E *** 

;Operanten-Codes 
#OP_UNKNOWN         = -1 
#OP_NONE            = 0 
#OP_PLUS            = 1 
#OP_MINUS           = 2 
#OP_MULT            = 3 
#OP_DIV             = 4 
#OP_POT             = 5 
#OP_FUNC            = 6 

;Funktions-Codes 
#FUNC_SQR           = 1 
#FUNC_SIN           = 2 
#FUNC_ASIN          = 3 
#FUNC_COS           = 4 
#FUNC_ACOS          = 5 
#FUNC_TAN           = 6 
#FUNC_ATAN          = 7 
#FUNC_INT           = 8 
#FUNC_ABS           = 9 
#FUNC_LOG10         = 10 
#FUNC_LOG           = 11 

;Konstanten 
#CONST_PI           = "3.1415926"   ;PI 
#CONST_E            = "2.7182818"   ;Eulersche Zahl 

;Error-Codes 
#CALC_ERR_NONE          = 0         ;kein Fehler 
#CALC_ERR_SYNTAX        = 1         ;Allgemeiner Syntax-Fehler (fehlender Wert) 
#CALC_ERR_DIVNULL       = 2         ;Division / 0 aufgetreten 
#CALC_ERR_OPNOTFOUND    = 3         ;Operant nicht gefunden 
#CALC_ERR_FUNCNOTFOUND  = 4         ;Funktion nicht gefunden 

#PRIORITY_STEP      = 4             ;entspricht der höchsten Prioritätsstufe der Operanten 
#MAX_TREENODES      = 100           ;Maximale Anzahl an SyntaxBaum-Knoten 

#OPERAND            = 1 
#VALUE              = 2 

Structure SyntaxTreeNode 
    *parent.SyntaxTreeNode 
    *child.SyntaxTreeNode[2] 
    operand.l 
    prior.l 
    Value.f 
EndStructure 

Structure SyntaxTree 
    *root.SyntaxTreeNode 
    node.SyntaxTreeNode[#MAX_TREENODES] 
    remark$ ;frei verwendbar 
EndStructure 

;-*** C O D E *** 

;--    Private 

Procedure.l Calc_Modulo(a.l, b.l) 
    ProcedureReturn a - a / b * b 
EndProcedure 

Procedure Calc_SetOperand(operand$, *node.SyntaxTreeNode) 
    Shared priorMod.l 

    While PeekB(@operand$) = 41 ;Left(operand$, 1) = ")" 
        operand$ = Mid(operand$, 2, Len(operand$)) 
        priorMod - #PRIORITY_STEP 
    Wend 

    While PeekB(@operand$ + Len(operand$) - 1) = 40 ;Right(operand$, 1) = "(" 
        operand$ = Left(operand$, Len(operand$) - 1) 
        changePrior.l + #PRIORITY_STEP 
    Wend 

    Select operand$ 
        Case "+" 
            *node\operand = #OP_PLUS 
            *node\prior = priorMod + 1 
        Case "-" 
            *node\operand = #OP_MINUS 
            *node\prior = priorMod + 1 
        Case "*" 
            *node\operand = #OP_MULT 
            *node\prior = priorMod + 2 
        Case "/" 
            *node\operand = #OP_DIV 
            *node\prior = priorMod + 2 
        Case "^" 
            *node\operand = #OP_POT 
            *node\prior = priorMod + 3 
            
            
        Case "~" 
            *node\operand = #OP_FUNC 
            ;ACHTUNG: Funktionen müssen IMMMER die höchste Priorität besitzen 
            *node\prior = priorMod + 4 
        Default 
            *node\operand = #OP_UNKNOWN 
    EndSelect 
    
    priorMod + changePrior 
EndProcedure 

Procedure.s Calc_GetContent(*expression, type.l, *pos.LONG) 
    *pointer.BYTE = *expression + *pos\l 

    If type = #VALUE 
        ;(-x) Ausrdrücke zulassen 
        If PeekB(*pointer) = 45 ; '-' 
            *pointer + 1 
        EndIf 

        ;) + - * / ^ ~ \0 
        ;Ascii-Wert eines neuen Operators hier mit einfügen 
        While (*pointer\b < 97 Or *pointer\b > 122) And *pointer\b <> 41 And *pointer\b <> 42 And *pointer\b <> 43  And *pointer\b <> 45 And *pointer\b <> 47 And *pointer\b <> 94 And *pointer\b <> 126 And *pointer\b <> 0 
            *pointer + 1 
        Wend 
    Else 
        ;0-9 . 
        While (*pointer\b < 48 Or *pointer\b > 57) And *pointer\b <> 46 And *pointer\b <> 0 
            *pointer + 1 
        Wend 
        ;(-x) Ausrdrücke zulassen 
        If PeekB(*pointer - 1) = 45 And PeekB(*pointer - 2) = 40 ; '(-' 
            *pointer - 1 
        EndIf 
    EndIf 

    ret$ = PeekS(*expression + *pos\l, (*pointer - *expression) - *pos\l) 

    If *pointer\b 
        *pos\l = *pointer - *expression 
    Else 
        *pos\l = -1 
    EndIf 

    ProcedureReturn ret$ 
EndProcedure 

Procedure Calc_InsertNodeAsParent(*nodeTarget.SyntaxTreeNode, *nodeInsert.SyntaxTreeNode) 
    child.l 

    If *nodeTarget\parent 
        If *nodeTarget\parent\child[0] = *nodeTarget 
            child = 0 
        ElseIf *nodeTarget\parent\child[1] = *nodeTarget 
            child = 1 
        EndIf 
        *nodeTarget\parent\child[child] = *nodeInsert 
        *nodeInsert\parent = *nodeTarget\parent 
    EndIf 
    *nodeTarget\parent = *nodeInsert 
    *nodeInsert\child[0] = *nodeTarget 
EndProcedure 

Procedure Calc_InsertNodeAsChild(*nodeTarget.SyntaxTreeNode, child.l, *nodeInsert.SyntaxTreeNode) 
    If *nodeTarget\child[child] 
        *nodeChild.SyntaxTreeNode = *nodeTarget\child[child] 
        *nodeChild\parent = *nodeInsert 
        *nodeInsert\child[0] = *nodeTarget\child[child] 
    EndIf 

    *nodeTarget\child[child] = *nodeInsert 
    *nodeInsert\parent = *nodeTarget 
EndProcedure 

Procedure.f Calc_GetNodeValueF(*node.SyntaxTreeNode) 
    Shared calculationErrorOccured.b 
    result.f 

    If *node 
        If *node\operand 
            valueOne.f = Calc_GetNodeValueF(*node\child[0]) 
            valueTwo.f = Calc_GetNodeValueF(*node\child[1]) 
            Select *node\operand 
                Case #OP_PLUS 
                    result = valueOne + valueTwo 
                Case #OP_MINUS 
                    result = valueOne - valueTwo 
                Case #OP_MULT 
                    result = valueOne * valueTwo 
                Case #OP_DIV 
                    result = valueOne / valueTwo 
                    If valueTwo = 0 And calculationErrorOccured = 0 
                        calculationErrorOccured = #CALC_ERR_DIVNULL 
                    EndIf 
                Case #OP_POT 
                    result = Pow(valueOne, valueTwo) 
                    
                Case #OP_FUNC 
                    Select valueOne ;steht für den Funktionstyp 
                        Case #FUNC_SQR 
                            result = Sqr(valueTwo) 
                        Case #FUNC_SIN 
                            result = Sin(valueTwo) 
                        Case #FUNC_ASIN 
                            result = ASin(valueTwo) 
                        Case #FUNC_COS 
                            result = Cos(valueTwo) 
                        Case #FUNC_ACOS 
                            result = ACos(valueTwo) 
                        Case #FUNC_TAN 
                            result = Tan(valueTwo) 
                        Case #FUNC_ATAN 
                            result = ATan(valueTwo) 
                        Case #FUNC_INT 
                            result = Int(valueTwo) 
                        Case #FUNC_ABS 
                            result = Abs(valueTwo) 
                        Case #FUNC_LOG10 
                            result = Log10(valueTwo) 
                        Case #FUNC_LOG 
                            result = Log(valueTwo) 
                        Default 
                            calculationErrorOccured = #CALC_ERR_FUNCNOTFOUND 
                    EndSelect 
                    
                Case #OP_UNKNOWN 
                    calculationErrorOccured = #CALC_ERR_OPNOTFOUND 
            EndSelect 
            ProcedureReturn result 
        Else 
            ProcedureReturn *node\Value 
        EndIf 
    Else 
        calculationErrorOccured = 1 
    EndIf 
EndProcedure 

Procedure Calc_ConsoleOutSyntaxNode(*node.SyntaxTreeNode, level.l) 
    ;für Debugging und Veranschaulischungszwecke 
    Shared isFunction.b 

    If *node 
    
        If  *node\operand 
            If *node\operand = #OP_PLUS 
                PrintN(Space(level * 2) + "+") 
            ElseIf *node\operand = #OP_MINUS 
                PrintN(Space(level * 2) + "-") 
            ElseIf *node\operand = #OP_MULT 
                PrintN(Space(level * 2) + "*") 
            ElseIf *node\operand = #OP_DIV 
                PrintN(Space(level * 2) + "/") 
            ElseIf *node\operand = #OP_POT 
                PrintN(Space(level * 2) + "^") 
            ElseIf *node\operand = #OP_FUNC 
                isFunction = 1 
            EndIf 
        Else 
            If isFunction 
                Print(Space((level-1) * 2)) 
                Select *node\Value 
                    Case #FUNC_SQR 
                        PrintN("SQR") 
                    Case #FUNC_SIN 
                        PrintN("SIN") 
                    Case #FUNC_ASIN 
                        PrintN("ASIN") 
                    Case #FUNC_COS 
                        PrintN("COS") 
                    Case #FUNC_ACOS 
                        PrintN("ACOS") 
                    Case #FUNC_TAN 
                        PrintN("TAN") 
                    Case #FUNC_ATAN 
                        PrintN("ATAN") 
                    Case #FUNC_INT 
                        PrintN("INT") 
                    Case #FUNC_ABS 
                        PrintN("ABS") 
                    Case #FUNC_LOG10 
                        PrintN("LOGTEN") 
                    Case #FUNC_LOG 
                        PrintN("LOG") 
                EndSelect 
            Else 
                PrintN(Space(level * 2) + StrF(*node\Value)) 
            EndIf 
        EndIf 
        
        If *node\child[0] 
            Calc_ConsoleOutSyntaxNode(*node\child[0], level + 1) 
            isFunction = 0 
        EndIf 
        If *node\child[1] 
            Calc_ConsoleOutSyntaxNode(*node\child[1], level + 1) 
        EndIf 
    EndIf 
EndProcedure 

Procedure Calc_ConsoleOutSyntaxTree(*tree.SyntaxTree) 
    ;für Debugging und Veranschaulischungszwecke 
    Calc_ConsoleOutSyntaxNode(*tree\root, 0) 
EndProcedure 

;--    Public 

Procedure CreateSyntaxTree(*tree.SyntaxTree, expression$) 
    Shared priorMod.l, functionCalculationEnabled.b, constantCalculationEnabled.b 

    priorMod = 0 
    nodeCount.l = 0 
    Position.l = 0 
    
    *nodeLastValue.SyntaxTreeNode 
    *nodeCurrentValue.SyntaxTreeNode 
    *nodeLastOperand.SyntaxTreeNode 
    *nodeCurrentOperand.SyntaxTreeNode 

    expression$ = LCase(ReplaceString(expression$, " ", "")) 

    While Left(expression$, 1) = "(" 
        expression$ = Mid(expression$, 2, Len(expression$)) 
        priorMod + #PRIORITY_STEP 
    Wend 
    While Right(expression$, 1) = ")" 
        expression$ = Left(expression$, Len(expression$) - 1) 
    Wend 
    
    If functionCalculationEnabled 
        expression$ = ReplaceString(expression$, "sqr",   Str(#FUNC_SQR) + "~") 
        expression$ = ReplaceString(expression$, "asin",  Str(#FUNC_ASIN) + "~") 
        expression$ = ReplaceString(expression$, "sin",   Str(#FUNC_SIN) + "~") 
        expression$ = ReplaceString(expression$, "acos",  Str(#FUNC_ACOS) + "~") 
        expression$ = ReplaceString(expression$, "cos",   Str(#FUNC_COS) + "~") 
        expression$ = ReplaceString(expression$, "atan",  Str(#FUNC_ATAN) + "~") 
        expression$ = ReplaceString(expression$, "tan",   Str(#FUNC_TAN) + "~") 
        expression$ = ReplaceString(expression$, "int",   Str(#FUNC_INT) + "~") 
        expression$ = ReplaceString(expression$, "abs",   Str(#FUNC_ABS) + "~") 
        expression$ = ReplaceString(expression$, "logten",Str(#FUNC_LOG10) + "~") 
        expression$ = ReplaceString(expression$, "log",   Str(#FUNC_LOG) + "~") 
    EndIf 
    
    If constantCalculationEnabled 
        expression$ = ReplaceString(expression$, "pi", #CONST_PI) 
        expression$ = ReplaceString(expression$, "e",  #CONST_E) 
    EndIf 
    
    ;Debug expression$ 

    Repeat 
        nodeCount + 1 
        
        If Calc_Modulo(nodeCount, 2) ;Wert 
            node$ = Calc_GetContent(@expression$, #VALUE, @Position) 
            *tree\node[nodeCount]\Value = ValF(node$) 
            *nodeCurrentValue = *tree\node[nodeCount] 
            ;Debug node$ 
            
            If nodeCount > 1 
                Calc_InsertNodeAsChild(*nodeLastOperand, 1, *nodeCurrentValue) 
            EndIf 

            *nodeLastValue = *nodeCurrentValue 
        Else ;Operator 
            node$ = Calc_GetContent(@expression$, #OPERAND, @Position) 
            Calc_SetOperand(node$, *tree\node[nodeCount]) 
            
            *nodeCurrentOperand = *tree\node[nodeCount] 
            ;Debug node$ + " :: " + Str(*nodeCurrentOperand\prior) 

            If *nodeLastOperand 
                If *nodeCurrentOperand\prior > *nodeLastOperand\prior 
                    Calc_InsertNodeAsChild(*nodeLastOperand, 1, *nodeCurrentOperand) 
                ElseIf *nodeCurrentOperand\prior = *nodeLastOperand\prior 
                    Calc_InsertNodeAsParent(*nodeLastOperand, *nodeCurrentOperand) 
                Else 
                    *node.SyntaxTreeNode = *nodeLastOperand 
                    While *node\parent And *node\prior > *nodeCurrentOperand\prior 
                        *node = *node\parent 
                    Wend 
                    
                    If *node\prior = *nodeCurrentOperand\prior 
                        Calc_InsertNodeAsParent(*node, *nodeCurrentOperand) 
                    ElseIf *node\prior < *nodeCurrentOperand\prior 
                        Calc_InsertNodeAsChild(*node, 1, *nodeCurrentOperand) 
                    Else 
                        Calc_InsertNodeAsParent(*node, *nodeCurrentOperand) 
                    EndIf 
                EndIf 
            Else 
                Calc_InsertNodeAsParent(*nodeLastValue, *nodeCurrentOperand) 
            EndIf 
            
            *nodeLastOperand = *nodeCurrentOperand 
        EndIf 
        
    Until Position = -1 

    If *nodeLastOperand 
        While *nodeLastOperand\parent 
            *nodeLastOperand = *nodeLastOperand\parent 
        Wend 
        *tree\root = *nodeLastOperand 
    ElseIf nodeCount = 1 
        *tree\root = *nodeLastValue 
    Else 
        *tree\root = 0 
    EndIf 

EndProcedure 

Procedure.f CalculateSyntaxTreeF(*tree.SyntaxTree) 
    Shared calculationErrorOccured.b 
    calculationErrorOccured = 0 

    If *tree\root 
        result.f = Calc_GetNodeValueF(*tree\root) 
    Else 
        ;Fehler auslösen 
        calculationErrorOccured = 1 
        result.f = 0 / result 
    EndIf 
    
    ProcedureReturn result 
EndProcedure 

Procedure.l CalculateSyntaxTreeL(*tree.SyntaxTree) 
    Shared calculationErrorOccured.b 
    calculationErrorOccured = 0 

    If *tree\root 
        result.l = Calc_GetNodeValueF(*tree\root) 
    Else 
        ;Fehler auslösen 
        calculationErrorOccured = 1 
    EndIf 
    
    ProcedureReturn result 
EndProcedure 

Procedure.l CalculateL(expression$) 
    Shared calculationErrorOccured.b 
    calculationErrorOccured = 0 

    tree.SyntaxTree 
    CreateSyntaxTree(@tree, expression$) 

    If tree\root 
        result.l = Calc_GetNodeValueF(tree\root) 
    Else 
        ;Fehler auslösen 
        calculationErrorOccured = 1 
    EndIf 
    
    ProcedureReturn result 
EndProcedure 

Procedure.f CalculateF(expression$) 
    Shared calculationErrorOccured.b 
    calculationErrorOccured = 0 

    tree.SyntaxTree 
    CreateSyntaxTree(tree, expression$) 

    If tree\root  
        ;Shared-Variable und If-Abfrage ist nur für das Beispiel und kann rausgenommen werden 
        Shared outputSyntaxTree.b 
        If outputSyntaxTree 
            Calc_ConsoleOutSyntaxTree(tree) 
        EndIf 

        result.f = Calc_GetNodeValueF(tree\root) 
    Else 
        ;Fehler auslösen 
        calculationErrorOccured = 1 
        result.f = 0 / result 
    EndIf 
    
    ProcedureReturn result 
EndProcedure 

Procedure.l GetCalculationError() 
    Shared calculationErrorOccured.b 
    ProcedureReturn calculationErrorOccured 
EndProcedure 

Procedure EnableFunctionCalculation(bool.b) 
    Shared functionCalculationEnabled.b 
    functionCalculationEnabled = bool 
EndProcedure 

Procedure EnableConstantCalculation(bool.b) 
    Shared constantCalculationEnabled.b 
    constantCalculationEnabled = bool 
EndProcedure 

;-*** B E I S P I E L E *** 
;--  Nr. 1 'Rechenbeispiel' 

EnableFunctionCalculation(1) 
EnableConstantCalculation(1) 

OpenConsole() 
PrintN("Beispiel 1 'Rechenbeispiel ' (Return zum fortfahren)") 
PrintN(StrF(CalculateF("7 / 1 + 2 + 3 * 10 / 5 + 1 * 4 * 3 + 9 - 10 / 5"))) 
PrintN(StrF(           7 / 1 + 2 + 3 * 10 / 5 + 1 * 4 * 3 + 9 - 10 / 5  )) 
;Input() 
PrintN(StrF(CalculateF("(7 / (1 + 2 + (3) * 10) / 5 + (1 * (4 * 3 + 9)) - 10 / 5)"))) 
PrintN(StrF(           (7 / (1 + 2 + (3) * 10) / 5 + (1 * (4 * 3 + 9)) - 10 / 5)  )) 

PrintN(StrF(CalculateF("2 + 3 ^ 4 * 5"))) 
PrintN(StrF(           2 + Pow(3, 4) * 5  )) 

PrintN(StrF(CalculateF("(4 - 2) ^ 8 + (9 * 3)"))) 
PrintN(StrF(       Pow((4 - 2), 8) + (9 * 3)  )) 

PrintN(StrF(CalculateF("(2 + 8) * (4 + 9)"))) 
PrintN(StrF(           (2 + 8) * (4 + 9)  )) 

PrintN(StrF(CalculateF("2 * (-3)"))) 

PrintN(Str(CalculateL("10 / 5"))) 
PrintN("Calculation-Error = " + Str(GetCalculationError())) 

PrintN(Str(CalculateL("10 / 0"))) 
PrintN("Calculation-Error = " + Str(GetCalculationError())) 


;Wurzel aus 2: 
PrintN(StrF(          Sqr(2)    )) 
PrintN(StrF(CalculateF("2 ^ 0.5"))) 
PrintN(StrF(CalculateF("SQR(2)"))) 
;Falsche Klammersetzung: 
PrintN(StrF(CalculateF("1 + 3) + 7) * 2)"))) 
;Division durch Null: 
PrintN(StrF(CalculateF("7 / 0"))) 
;was ist das? 
PrintN(StrF(CalculateF("hallo?"))) 

Input() 

;--  Nr. 2 'Math. Funktion' 
;ist performance schonend, da der SyntaxBaum nur einmal erstellt wird 
ClearConsole() 
PrintN("Beispiel 2 'Mathematische Funktion' (Return zum fortfahren)") 
;diese Methode spart unheimlich viel Performance (teilweise 100 bis 1000mal schneller 
;als wenn bei jeder Berechnung ein neuer Syntax-Baum erstellt wird) 

myFunction.SyntaxTree\remark$ =  "f(x) = 3x^2 + 8x + 4" 
CreateSyntaxTree(myFunction, "3 * 0 ^ 2 + 8 * 0 + 4") 
;                  Node-IDs:  1 2 3 4 5 6 7 8 9 0 11 
;                                 X           X 
PrintN(myFunction\remark$) 
x.f = -5 
While x < 5 
    myFunction\node[3]\Value = x 
    myFunction\node[9]\Value = x 
    PrintN("x = " + RSet(StrF(x), 4, "0") + RSet(StrF(CalculateSyntaxTreeF(myFunction)), 20)) 
    x + 0.5 
Wend 

Input() 

;--  Nr. 3 'Consolen-Rechner' 
#CONSOLE_INPUTLINE = 24 

Procedure MiniConsoleCalculator() 
    Shared outputSyntaxTree.b 

    outputSyntaxTree = 1 
    gOutputSyntaxTree = 1 
    input$ = "" 
    prompt$ = "> " 
    refresh.b 

    ClearConsole() 
    ConsoleColor(7, 0) 
    PrintN("Beispiel 3 'Consolen-Rechner' (Return zum beenden)") 


    ConsoleLocate(0, #CONSOLE_INPUTLINE) 
    Print(prompt$) 
    lenPrompt = Len(prompt$) 
    x.l = lenPrompt 

    Repeat 
        Delay(25) 
        inkey$ = Inkey() 
        If Len(inkey$) 
            refresh = 0 
            If Asc(inkey$) >= 32 And Asc(inkey$) <> 255 And Len(input$) < 77 
                Print(Left(inkey$, 1)) 
                input$ = Left(input$, x - lenPrompt) + Left(inkey$, 1) + Mid(input$, x + 1 - lenPrompt, Len(input$)) ;+ " " 
                x + 1 

                refresh = 1 
            ElseIf Asc(inkey$) = 8 
                If x > Len(prompt$) 
                    x - 1 
                    input$ = Left(input$, x - lenPrompt) + Mid(input$, x + 2 - lenPrompt, Len(input$)) ;+ " " 
                EndIf 

                refresh = 1 
            ElseIf Asc(inkey$) = 13 
                ProcedureReturn 
            ElseIf Asc(inkey$) = 255 
                Value.l = PeekB(@inkey$ + 1) 
                Select Value 
                    Case 83 ;delete 
                        input$ = Left(input$, x - lenPrompt) + Mid(input$, x + 2 - lenPrompt, Len(input$)) 
                        refresh = 1 
                    
                    Case 71 ;home 
                        x = lenPrompt 
                    Case 79 ;end 
                        x = lenPrompt + Len(input$) 
                        
                    Case 75 
                        If x > lenPrompt : x - 1 : EndIf 
                    Case 77 
                        If x < 79 And x < lenPrompt + Len(input$) 
                            x + 1 
                        EndIf 
                EndSelect 
            EndIf 
            If refresh 
                ClearConsole() 
                result.f = CalculateF(input$) 
                ConsoleLocate(0, #CONSOLE_INPUTLINE - 1) 
                If GetCalculationError() = #CALC_ERR_SYNTAX 
                    Print("= Syntax-Error" + Space(65)) 
                ElseIf GetCalculationError() = #CALC_ERR_DIVNULL 
                    Print("= Division / 0" + Space(65)) 
                ElseIf GetCalculationError() = #CALC_ERR_OPNOTFOUND 
                    Print("= Operator, Function or Constant not found" + Space(37)) 
                Else 
                    Print("= " + StrF(result) + Space(77 - Len(StrF(result)))) 
                EndIf 
                ConsoleLocate(0, #CONSOLE_INPUTLINE) 
                Print(prompt$ + input$ + Space(79 - lenPrompt - Len(input$))) 
            EndIf 
            ConsoleLocate(x, #CONSOLE_INPUTLINE) 
        EndIf 
        
    ForEver 

EndProcedure 

MiniConsoleCalculator() 

CloseConsole() 


; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = ---
