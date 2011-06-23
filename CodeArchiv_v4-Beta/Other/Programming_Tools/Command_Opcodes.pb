; English forum: http://www.purebasic.fr/english/viewtopic.php?t=8978&highlight=
; Author: Danilo (updated for PB 4.00 by Andre)
; Date: 03. January 2004
; OS: Windows
; Demo: Yes


; a sort of Pascals elaborate typing system converted to PB....
Enumeration 
  #add : #neg : #mul : #divd : #remd : #div2 : #rem2 : #eqli : #neqi : #lssi 
  #leqi: #gtri: #geqi: #dupl : #swap : #andb : #orb  : #load : #stor : #hhalt 
  #wri : #wrc : #wrl : #rdi  : #rdc  : #rdl  : #eol  : #ldc  : #ldla : #ldl 
  #ldg : #stl : #stg : #move : #copy : #addc : #mulc : #jump : #jumpz: #call 
  #adjs: #sets: #exit 

  #lastopcode 
EndEnumeration 

DataSection 
  instructions: 
    Data$ "add" ,"neg" , "mul","divd","remd","div2", "rem2","eqli", "neqi","lssi" 
    Data$ "leqi","gtri","geqi","dupl","swap","andb", "orb" ,"load", "stor","hhalt" 
    Data$ "wri" ,"wrc" , "wrl", "rdi", "rdc","rdl" , "eol" , "ldc", "ldla","ldl" 
    Data$ "ldg" ,"stl" , "stg","move","copy","addc", "mulc","jump","jumpz","call" 
    Data$ "adjs","sets","exit" 
EndDataSection 

Procedure Init() 
  Global Dim instr.s(#lastopcode-1) 
  Restore instructions 
  For a = 0 To #lastopcode-1 
    Read A$ 
    instr(a)=A$ 
  Next a 
EndProcedure 


Init() 

Debug instr(#mul) 
Debug instr(#copy) 
Debug instr(#exit) 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
