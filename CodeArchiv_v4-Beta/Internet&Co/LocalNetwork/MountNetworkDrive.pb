; www.purearea.net (Thanks to Rings!)
; Author: Rings
; Date: 24. September 2002
; OS: Windows
; Demo: No

;Connect/Disconnect shared networkdirectory as mapped drives
;PureBasic-Port 2002  by Siegfried Rings (CodeGuru)

#NO_ERROR = 0
#CONNECT_UPDATE_PROFILE = $1
; The following includes all the constants defined for NETRESOURCE,
; not just the ones used in this example\
#RESOURCETYPE_DISK = $1
#RESOURCETYPE_PRINT = $2
#RESOURCETYPE_ANY = $0
#RESOURCE_CONNECTED = $1
#RESOURCE_REMBERED = $3
#RESOURCE_GLOBALNET = $2
#RESOURCEDISPLAYTYPE_DOMAIN = $1
#RESOURCEDISPLAYTYPE_GENERIC = $0
#RESOURCEDISPLAYTYPE_SERVER = $2
#RESOURCEDISPLAYTYPE_SHARE = $3
#RESOURCEUSAGE_CONNECTABLE = $1
#RESOURCEUSAGE_CONTAINER = $2
; Error Constants:
#ERROR_ACCESS_DENIED = 5
#ERROR_ALREADY_ASSIGNED = 85
#ERROR_BAD_DEV_TYPE = 66
#ERROR_BAD_DEVICE = 1200
#ERROR_BAD_NET_NAME = 67
#ERROR_BAD_PROFILE = 1206
#ERROR_BAD_PROVIDER = 1204
#ERROR_BUSY = 170
#ERROR_CANCELLED = 1223
#ERROR_CANNOT_OPEN_PROFILE = 1205
#ERROR_DEVICE_ALREADY_REMBERED = 1202
#ERROR_EXTENDED_ERROR = 1208
#ERROR_INVALID_PASSWORD = 86
#ERROR_NO_NET_OR_BAD_PATH = 1203

Procedure ConnectDrive(Drive.s, Resource.s)
  NetR.NETRESOURCE
  ErrInfo.l
  MyPass.s
  MyUser.s
  NetR\dwScope = #RESOURCE_GLOBALNET
  NetR\dwType = #RESOURCETYPE_DISK
  NetR\dwDisplayType = #RESOURCEDISPLAYTYPE_SHARE
  NetR\dwUsage = #RESOURCEUSAGE_CONNECTABLE
  NetR\lpLocalName =@Drive.s; If undefined, Connect with no device
  NetR\lpRemoteName =@Resource.s; Your valid share
  
  ;NetR.lpComment = "Optional Comment"
  ;NetR.lpProvider =    ; Leave this undefined
  ; If the UserName and Password arguments are NULL, the user context
  ; for the process provides the default user name.
  ErrInfo = WNetAddConnection2_(NetR, MyPass, MyUser, #CONNECT_UPDATE_PROFILE)
  If ErrInfo = #NO_ERROR
    MessageRequester("Net Connection Successful!",   "Share Connected",0)
  Else
    MessageRequester("ERROR: " +Str( ErrInfo ), " - Net Connection Failed!" +"Share not Connected",0)
  EndIf
EndProcedure

Procedure DisconnectDrive(Drive.s)
  ErrInfo.l
  strLocalName.s
  strLocalName.s = Drive.s
  ErrInfo = WNetCancelConnection2_(strLocalName, #CONNECT_UPDATE_PROFILE, #False)
  If ErrInfo = #NO_ERROR
    MessageRequester ("Net Disconnection Successful!",   "Share Disconnected",0)
  Else
    MessageRequester( "ERROR: " +Str( ErrInfo )," - Net Disconnection Failed!"+"Share not Disconnected",0)
  EndIf
EndProcedure

ConnectDrive("X:","\\ServerName\ShareName")
DisConnectDrive("X:")

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -