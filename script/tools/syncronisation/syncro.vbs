Option Explicit
Dim teapod, x, y
Set teapod = CreateObject("wscript.shell")

x=MsgBox "voulez vous activer la syncronisation ?" ,vbYesNo+vbSystemModal, "TeapodAntivirusSystem"
if x=vbYes Then
  teapod.run "syncro.ps1"
  teapod.run "script.ps3"
else
  y=inputbox "votre avis:" ,vbQuestion, "Teapod"
