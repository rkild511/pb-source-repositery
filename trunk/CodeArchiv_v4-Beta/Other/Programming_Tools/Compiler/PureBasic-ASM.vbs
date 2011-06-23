set fs=CreateObject("Scripting.FileSystemObject") 
Set Args=WScript.Arguments 
If Args.Count>0 then 
   file_name = Args(Args.Count-1) 
   file_path = Left(file_name,InstrRev(file_name,"\")) 
   base_name = fs.GetBaseName(file_name) 
   Set ws=CreateObject("WScript.Shell") 
   double_quote="""" 
   appfile = double_quote+"C:\Program Files\PureBasic\Compilers\PBCompiler.exe "+ double_quote 
   userfile = double_quote+file_name+double_quote 
   temp=appfile+userfile+" /INLINEASM /COMMENTED /CONSOLE /EXE " 
   temp=temp+double_quote+file_path+base_name+".EXE"+double_quote 
   ret = ws.Run(temp,0,"TRUE") 
   If (fs.FileExists("C:\Program Files\PureBasic\Compilers\PureBasic.asm")) then 
      fs.CopyFile "C:\Program Files\PureBasic\Compilers\PureBasic.asm",file_path+base_name +".asm" 
   End If 
End If 

