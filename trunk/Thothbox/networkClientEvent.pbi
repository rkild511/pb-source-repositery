; Client Event4 support by DarkPlayer, PureFan
;http://www.purebasic.fr/english/viewtopic.php?f=12&t=42559&hilit=Disconnect
;EnableExplicit

CompilerIf #PB_Compiler_OS = #PB_OS_Linux ;{
  #FIONREAD     = $541B
 
  #__FD_SETSIZE = 1024
  #__NFDBITS    = 8 * SizeOf(LONG)
 
  Macro __FDELT(d)
    ((d) / #__NFDBITS)
  EndMacro
 
  Macro __FDMASK(d)
    (1 << ((d) % #__NFDBITS))
  EndMacro
 
  Structure FD_SET
    fds_bits.l[#__FD_SETSIZE / #__NFDBITS]
  EndStructure
 
  Procedure.i __FD_SET(d.i, *set.FD_SET)
    If d >= 0 And d < #__FD_SETSIZE
      *set\fds_bits[__FDELT(d)] | __FDMASK(d)
    EndIf
  EndProcedure
 
  Procedure.i __FD_ISSET(d.i, *set.FD_SET)
    If d >= 0 And d < #__FD_SETSIZE
      ProcedureReturn *set\fds_bits[__FDELT(d)] & __FDMASK(d)
    EndIf
  EndProcedure
 
  Procedure.i __FD_ZERO(*set.FD_SET)
    FillMemory(*set, SizeOf(FD_SET), 0, #PB_Byte)
  EndProcedure
 
 
  #FD_SETSIZE = #__FD_SETSIZE
  #NFDBITS    = #__NFDBITS
 
  Macro FD_SET(fd, fdsetp)
    __FD_SET(fd, fdsetp)
  EndMacro
 
  Macro FD_ISSET(fd, fdsetp)
    __FD_ISSET(fd, fdsetp)
  EndMacro
 
  Macro FD_ZERO(fdsetp)
    __FD_ZERO(fdsetp)
  EndMacro
 
  ; Returns the minimum value for NFDS
  Procedure.i _NFDS(*set.FD_SET)
    Protected I.i, J.i
   
    For I = SizeOf(FD_SET)/SizeOf(LONG) - 1 To 0 Step -1
      If *set\fds_bits[I]
       
        For J = (#__NFDBITS - 1) To 0 Step -1
          If *set\fds_bits[I] & (1 << J)
            ProcedureReturn I * #__NFDBITS + J + 1
          EndIf
        Next
       
      EndIf
    Next
   
    ProcedureReturn 0
  EndProcedure
  ;}
CompilerEndIf

CompilerIf #PB_Compiler_OS = #PB_OS_MacOS ;{
  #IOC_OUT  = $40000000 ;(__uint32_t)
  Macro _IOR(g,n,t)
    _IOC(#IOC_OUT, (g), (n), (t))
  EndMacro
  #IOCPARM_MASK = $1fff
  Macro _IOC(inout,group,num,len)
    ((inout) | (((len) & #IOCPARM_MASK) << 16) | ((group) << 8) | (num))
  EndMacro
  #FIONREAD = _IOR('f', 127, SizeOf(LONG))
 
  #__DARWIN_FD_SETSIZE = 1024
  #__DARWIN_NBBY       = 8
  #__DARWIN_NFDBITS    = SizeOf(LONG) * #__DARWIN_NBBY
 
  Structure FD_SET
    fds_bits.l[ (#__DARWIN_FD_SETSIZE + #__DARWIN_NFDBITS - 1) / #__DARWIN_NFDBITS ]
  EndStructure
 
  Procedure.i __DARWIN_FD_SET(fd.i, *p.FD_SET)
    If fd >= 0 And fd < #__DARWIN_FD_SETSIZE
      *p\fds_bits[fd / #__DARWIN_NFDBITS] | (1 << (fd % #__DARWIN_NFDBITS))
    EndIf
  EndProcedure
 
  Procedure.i __DARWIN_FD_ISSET(fd.i, *p.FD_SET)
    If fd >= 0 And fd < #__DARWIN_FD_SETSIZE
      ProcedureReturn *p\fds_bits[fd / #__DARWIN_NFDBITS] & (1 << (fd % #__DARWIN_NFDBITS))
    EndIf
  EndProcedure
 
  Procedure.i __DARWIN_FD_ZERO(*p.FD_SET)
    FillMemory(*p, SizeOf(FD_SET), 0, #PB_Byte)
  EndProcedure
 
  #FD_SETSIZE = #__DARWIN_FD_SETSIZE
 
  Macro FD_SET(n, p)
    __DARWIN_FD_SET(n, p)
  EndMacro
 
  Macro FD_ISSET(n, p)
    __DARWIN_FD_ISSET(n, p)
  EndMacro
 
  Macro FD_ZERO(p)
    __DARWIN_FD_ZERO(p)
  EndMacro
 
  ; Returns the minimum value for NFDS
  Procedure.i _NFDS(*p.FD_SET)
    Protected I.i, J.i
   
    For I = SizeOf(FD_SET)/SizeOf(LONG) - 1 To 0 Step -1
      If *p\fds_bits[I]
       
        For J = (#__DARWIN_NFDBITS - 1) To 0 Step -1
          If *p\fds_bits[I] & (1 << J)
            ProcedureReturn I * #__DARWIN_NFDBITS + J + 1
          EndIf
        Next
       
      EndIf
    Next
   
    ProcedureReturn 0
  EndProcedure
  ;}
CompilerEndIf

CompilerIf #PB_Compiler_OS = #PB_OS_Windows ;{
  ; #FIONREAD is already defined
  ; FD_SET is already defined
 
  Macro FD_ZERO(set)
    set\fd_count = 0
  EndMacro
 
  Procedure.i FD_SET(fd.i, *set.FD_SET)
    If *set\fd_count < #FD_SETSIZE
      *set\fd_array[ *set\fd_count ] = fd
      *set\fd_count + 1
    EndIf
  EndProcedure
 
  Procedure.i FD_ISSET(fd.i, *set.FD_SET)
    Protected I.i
    For I = *set\fd_count - 1 To 0 Step -1
      If *set\fd_array[I] = fd
        ProcedureReturn #True
      EndIf
    Next
   
    ProcedureReturn #False
  EndProcedure
 
  Procedure.i _NFDS(*set.FD_SET)
    ProcedureReturn *set\fd_count
  EndProcedure
  ;}
CompilerEndIf
 
 
CompilerIf Defined(TIMEVAL, #PB_Structure) = #False ;{
  Structure TIMEVAL
    tv_sec.l
    tv_usec.l
  EndStructure ;}
CompilerEndIf

Procedure.i Hook_NetworkClientEvent(Connection.i)
  Protected Event.i = NetworkClientEvent(Connection)
  If Event
    ProcedureReturn Event
  EndIf
 
  Protected hSocket.i = ConnectionID(Connection)
  Protected tv.timeval, readfds.fd_set, RetVal.i, Length.i
  tv\tv_sec  = 0 ; Dont even wait, just query status
  tv\tv_usec = 0
 
  FD_ZERO(readfds)
  FD_SET(hSocket, readfds)
 
  ; Check if there is something new
  RetVal = select_(_NFDS(readfds), @readfds, #Null, #Null, @tv)
  If RetVal < 0 ; Seems to be an error
    ProcedureReturn #PB_NetworkEvent_Disconnect
  ElseIf RetVal = 0 Or Not FD_ISSET(hSocket, readfds) ; No data available
    ProcedureReturn 0
  EndIf
 
  ; Check if data is available?
  CompilerIf #PB_Compiler_OS = #PB_OS_Windows
    RetVal = ioctlsocket_(hSocket, #FIONREAD, @Length)
  CompilerElse
    RetVal = ioctl_(hSocket, #FIONREAD, @Length)
  CompilerEndIf
  If RetVal Or Length = 0 ; Not successful to query for data available OR no data available ? This seems to be an error!
    ProcedureReturn #PB_NetworkEvent_Disconnect
  EndIf
 
  ProcedureReturn 0
EndProcedure

Macro NetworkClientEvent(Connection)
  Hook_NetworkClientEvent(Connection)
EndMacro
; IDE Options = PureBasic 4.60 Beta 3 (Windows - x86)
; Folding = -----
; EnableXP