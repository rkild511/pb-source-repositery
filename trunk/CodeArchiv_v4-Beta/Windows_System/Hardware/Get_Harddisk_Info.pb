; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=1388&highlight=
; Author: Rings
; Date: 17. June 2003
; OS: Windows
; Demo: No


; Retrieve harddisk`s modell,serial,firmware (Windows only)
; updated on 27. August 2003 -  "[]" brackets in structures
Structure IDEREGS 
    bFeaturesReg.b 
    bSectorCountReg.b 
    bSectorNumberReg.b 
    bCylLowReg.b 
    bCylHighReg.b 
    bDriveHeadReg.b 
    bCommandReg.b 
    bReserved.b 
EndStructure 
Structure SENDCMDINPARAMS 
    cBufferSize.l 
    irDriveRegs.IDEREGS 
    bDriveNumber.b 
    bReserved.b[3] 
    dwReserved.l[4]
EndStructure 

Structure  DRIVERSTATUS 
    bDriveError.b 
    bIDEStatus.b 
    bReserved.b[2]
    dwReserved.l[2]
EndStructure 
Structure  SENDCMDOUTPARAMS 
    cBufferSize.l 
    DStatus.DRIVERSTATUS      
    bBuffer.b[512]
EndStructure 


#DFP_RECEIVE_DRIVE_DATA = $7C088 

bin.SENDCMDINPARAMS 
bout.SENDCMDOUTPARAMS 



Procedure.s ChangeHighLowByte(Instring.s) 
  ;Change BIG-Little Endian 
  sdummy.s="" 
  L=Len(Instring) 
  For I=1 To L Step 2 
  If (I+1)<=L 
    sdummy.s=sdummy.s + Mid(Instring,I+1,1)+Mid(Instring,I,1)  
  EndIf 
  Next I 
  ProcedureReturn sdummy.s 
EndProcedure 


mvarCurrentDrive=0 ;If you have more hard-disks change it here 

hdh = CreateFile_("\\.\PhysicalDrive" + Str(mvarCurrentDrive),#GENERIC_READ | #GENERIC_WRITE, #FILE_SHARE_READ | #FILE_SHARE_WRITE,0, #OPEN_EXISTING, 0, 0) 
If hdh  
        bin\bDriveNumber = mvarCurrentDrive 
        bin\cBufferSize = 512 
        
        If (mvarCurrentDrive & 1) 
          bin\irDriveRegs\bDriveHeadReg = $B0 
        Else 
          bin\irDriveRegs\bDriveHeadReg = $A0 
        EndIf 
        bin\irDriveRegs\bCommandReg = $EC 
        bin\irDriveRegs\bSectorCountReg = 1 
        bin\irDriveRegs\bSectorNumberReg = 1 
    
       br=0 
       Result=DeviceIoControl_( hdh, #DFP_RECEIVE_DRIVE_DATA, bin, SizeOf(SENDCMDINPARAMS), bout, SizeOf(SENDCMDOUTPARAMS), @br, 0) 
       If br>0 
        hddfr = 55:hddln = 40          : 
        Modell.s=ChangeHighLowByte(PeekS(@bout\bBuffer[0]+hddfr-1 ,hddln  ) ) 
        hddfr = 21:hddln = 20          : 
        Serial.s=Trim(ChangeHighLowByte(PeekS(@bout\bBuffer[0]+hddfr-1 ,hddln  ) )) 
        hddfr = 47:hddln = 8          
        Firmware.s=ChangeHighLowByte(PeekS(@bout\bBuffer[0]+hddfr-1 ,hddln  ) ) 
        MessageRequester("Info about your harddisk","vendor(Modell)="+Modell.s + Chr(13) +"serial="+Serial.s+ Chr(13)+"Firmwareversion="+Firmware ,0) 
       EndIf 
Else 
  Beep_(100,100) 
EndIf 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
