Option Explicit
Dim obj, x, y
Set obj = CreateObject("wscript.shell")

x=MsgBox "voulez vous activer la syncronisation ?" ,vbYesNo+vbSystemModal, "TeapodAntivirusSystem"
if x=vbYes Then
  obj.run "script.bat"
else
  y=inputbox "votre avis:" ,vbQuestion, "Teapod"
