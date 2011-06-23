; English forum: http://www.purebasic.fr/english/viewtopic.php?t=7196&highlight=
; Author: Inner
; Date: 11. August 2003
; OS: Windows
; Demo: No


; It's _VERY_ basic encryption but it works, don't forget to replace the strings that are marked with <> 

; You'll need this SDK 
; http://www.mirrors.wiretapped.net/security/cryptography/apps/pgp/PGP/sdk/PGPsdk_1_7_2_Win32.zip 

#PGPLIB=0 
#PGPLIBRARYNAME$="<show me the way to>\PGP_SDK.dll" 

#kPGPMatchDefault = 1 
#kPGPMatchEqual = 1        ;/* searched val == supplied val */ 
#kPGPMatchGreaterOrEqual = 2 ;/* searched val >= supplied val */ 
#kPGPMatchLessOrEqual = 3    ;/* searched val <= supplied val */ 
#kPGPMatchSubString = 4      ;/* searched val is contained in supplied val */ 


; ----------------------------------------------------------------------------- 
; 
; ----------------------------------------------------------------------------- 
Procedure PGPsdkInit() 
    ProcedureReturn CallCFunction(#PGPLIB,"PGPsdkInit") 
EndProcedure 
; ----------------------------------------------------------------------------- 
; 
; ----------------------------------------------------------------------------- 
Procedure PGPsdkCleanup() 
    ProcedureReturn CallCFunction(#PGPLIB,"PGPsdkCleanup") 
EndProcedure 
; ----------------------------------------------------------------------------- 
; 
; ----------------------------------------------------------------------------- 
Procedure PGPGetSDKVersion(version.l) 
    ProcedureReturn CallCFunction(#PGPLIB,"PGPGetSDKVersion",version) 
EndProcedure 
; ----------------------------------------------------------------------------- 
; 
; ----------------------------------------------------------------------------- 
Procedure PGPOpenDefaultKeyRings(context.l,openflags.l,keys.l) 
    ProcedureReturn CallCFunction(#PGPLIB,"PGPOpenDefaultKeyRings",context,openflags,keys) 
EndProcedure 
; ----------------------------------------------------------------------------- 
; 
; ----------------------------------------------------------------------------- 
Procedure PGPNewContext(clientapiversion.l,context.l) 
    ProcedureReturn CallCFunction(#PGPLIB,"PGPNewContext",clientapiversion,context) 
EndProcedure 
; ----------------------------------------------------------------------------- 
; 
; ----------------------------------------------------------------------------- 
Procedure PGPNewUserIDStringFilter(context.l,userid.s,match.l,filter.l) 
    ProcedureReturn CallCFunction(#PGPLIB,"PGPNewUserIDStringFilter",context.l,userid.s,match.l,filter.l) 
EndProcedure 
; ----------------------------------------------------------------------------- 
; 
; ----------------------------------------------------------------------------- 
Procedure PGPFilterKeySet(keys.l,filter.l,foundUserKeys.l) 
    ProcedureReturn CallCFunction(#PGPLIB,"PGPFilterKeySet",keys,filter,foundUserKeys) 
EndProcedure 
; ----------------------------------------------------------------------------- 
; 
; ----------------------------------------------------------------------------- 
Procedure PGPNewFileSpecFromFullPath(context.l,infile.s,infileref.l) 
    ProcedureReturn CallCFunction(#PGPLIB,"PGPNewFileSpecFromFullPath",context,infile,infileref) 
EndProcedure 
; ----------------------------------------------------------------------------- 
; 
; ----------------------------------------------------------------------------- 
Procedure PGPOEncryptToKeySet(context.l,founduserkeys.l) 
    ProcedureReturn CallCFunction(#PGPLIB,"PGPOEncryptToKeySet",context,founduserkeys) 
EndProcedure 
; ----------------------------------------------------------------------------- 
; 
; ----------------------------------------------------------------------------- 
Procedure PGPOInputFile(context.l,infileref.l) 
    ProcedureReturn CallCFunction(#PGPLIB,"PGPOInputFile",context,infileref) 
EndProcedure 
; ----------------------------------------------------------------------------- 
; 
; ----------------------------------------------------------------------------- 
Procedure PGPOOutputFile(context.l,outfileref.l) 
    ProcedureReturn CallCFunction(#PGPLIB,"PGPOOutputFile",context,outfileref) 
EndProcedure 
; ----------------------------------------------------------------------------- 
; 
; ----------------------------------------------------------------------------- 
Procedure PGPOLastOption(context.l) 
    ProcedureReturn CallCFunction(#PGPLIB,"PGPOLastOption",PGPOLastOption) 
EndProcedure 
; ----------------------------------------------------------------------------- 
; 
; ----------------------------------------------------------------------------- 
Procedure PGPEncode(context.l,keyset.l,infile.l,outfile.l,lastoption.l) 
    ProcedureReturn CallCFunction(#PGPLIB,"PGPEncode",context,keyset,infile,outfile,lastoption) 
EndProcedure 
; ----------------------------------------------------------------------------- 
; 
; ----------------------------------------------------------------------------- 
Procedure PGPFreeFileSpec(fileref.l) 
    ProcedureReturn CallCFunction(#PGPLIB,"PGPFreeFileSpec",fileref) 
EndProcedure 
; ----------------------------------------------------------------------------- 
; 
; ----------------------------------------------------------------------------- 
Procedure PGPFreeFilter(filter.l) 
    ProcedureReturn CallCFunction(#PGPLIB,"PGPFreeFilter",filter) 
EndProcedure 
; ----------------------------------------------------------------------------- 
; 
; ----------------------------------------------------------------------------- 
Procedure PGPFreeKeySet(userkey.l) 
    ProcedureReturn CallCFunction(#PGPLIB,"PGPFreeKeySet",userkey) 
EndProcedure 
; ----------------------------------------------------------------------------- 
; 
; ----------------------------------------------------------------------------- 
Procedure PGPFreeContext(context.l) 
    ProcedureReturn CallCFunction(#PGPLIB,"PGPFreeContext",context) 
EndProcedure 

; ----------------------------------------------------------------------------- 
; 
; ----------------------------------------------------------------------------- 

If(OpenLibrary(#PGPLIB,#PGPLIBRARYNAME$)<>0) 
    Debug("ALERT PGP LIBRARY OPENED") 

    err=PGPsdkInit()      
    Debug(err) 

    keys.l 
    context.l 
    version.l 
    filter.l 
    foundUserKeys.l 

    infile.s="<INSERT YOUR SOURCE FILE>" 
    infileref.l 
    outfile.s="<INSERT YOUR DESTINATION FILE>" 
    outfileref.l    

    If(err=0);#kPGPError_NoErr) 
        userid.s="<INSERT YOUR ID HERE!>" 
        err=PGPGetSDKVersion(@version) 
        If(err<>0) 
            Goto exit 
        EndIf 
        err=PGPNewContext(version,@context) 
        If(err<>0) 
            Goto exit 
        EndIf 
        err=PGPOpenDefaultKeyRings(context,1,@keys) 
        If(err<>0) 
            Goto exit 
        EndIf 
        err=PGPNewUserIDStringFilter(context,userid,#kPGPMatchSubString,@filter)        
        If(err<>0) 
            Goto exit 
        EndIf 
        err=PGPFilterKeySet(keys,filter,@foundUserKeys)        
        If(err<>0) 
            Goto exit 
        EndIf 
        err=PGPNewFileSpecFromFullPath(context,infile,@infileref) 
        If(err<>0) 
            Goto exit 
        EndIf 
        err=PGPNewFileSpecFromFullPath(context,outfile,@outfileref) 
        If(err<>0) 
            Goto exit 
        EndIf 
        pgpo_keyset.l=PGPOEncryptToKeySet(context,foundUserKeys) 
        pgpo_infile.l=PGPOInputFile(context,infileref) 
        pgpo_outfile.l=PGPOOutputFile(context,outfileref) 
        pgpo_lastopt.l=PGPOLastOption(context) 
        err=PGPEncode(context,pgpo_keyset,pgpo_infile,pgpo_outfile,-1) 
        If(err<>0) 
            Goto exit 
        EndIf 
        ; ----------------------------------------------------------------------------- 
        ; Time to get the heck out of dodge! 
        ; ----------------------------------------------------------------------------- 
    exit: 
        If(infileref<>0) 
            PGPFreeFileSpec(infileref) 
        EndIf 
        If(outfileref<>0) 
            PGPFreeFileSpec(outfileref) 
        EndIf 
        If(filter<>0) 
            PGPFreeFilter(filter)        
        EndIf 
        If(foundUserKeys<>0) 
            PGPFreeKeySet(foundUserKeys) 
        EndIf 
        If(keys<>0) 
            PGPFreeKeySet(keys) 
        EndIf 
        If(context<>0) 
            PGPFreeContext(context) 
        EndIf 
        
    EndIf 
    PGPsdkCleanup() 
    CloseLibrary(#PGPLIB) 
Else 
    Debug("ALERT PGP OPEN LIBRARY FAILURE") 
EndIf 
 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = ---
