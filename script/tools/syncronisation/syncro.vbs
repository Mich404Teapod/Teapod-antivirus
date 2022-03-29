  Option Explicit
Dim oExec,fso,teapod,Temp,Voice
Set teapod = CreateObject("wscript.Shell")
Set fso = CreateObject("Scripting.FileSystemObject") 
Temp = teapod.ExpandEnvironmentStrings("%Temp%")
Set Voice = CreateObject("SAPI.SpVoice")

x=MsgBox "voulez vous activer la syncronisation ?" ,vbYesNo+vbSystemModal, "TeapodAntivirusSystem"
if x=vbYes Then
  teapod.run "syncro.ps1"
  teapod.run "script.ps3"
else
  y=inputbox "votre avis:" ,vbQuestion, "Teapod"
End If
