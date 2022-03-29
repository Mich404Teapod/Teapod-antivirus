  Option Explicit
Dim oExec,fso,teapod,Temp,Voice
Set teapod = CreateObject("wscript.Shell")
Set fso = CreateObject("Scripting.FileSystemObject") 
Temp = ws.ExpandEnvironmentStrings("%Temp%")
Set Voice = CreateObject("SAPI.SpVoice")

x=MsgBox "voulez vous activer la syncronisation ?" ,vbYesNo+vbSystemModal, "TeapodAntivirusSystem"
if x=vbYes Then
  teapod.run "syncro.ps1"
  teapod.run "script.ps3"
'**************************************************************************************************
'Appel au programme principal ou on peut intégrer la barre de progression
Call MonProgramme() 
'**************************************************************************************************
Sub MonProgramme()
	Dim Command,Command2,Res,LogFile,StrCommand,Argum,startlog,MsgTitre,Titre,MsgAttente
	MsgTitre = "Traceroute d'une URL © Hackoo © 2013"
	StrCommand = "Tracert"
	Argum = InputBox("Taper l'adresse d'une URL pour déterminer son itinéraire avec la commande DOS "& DblQuote("Tracert"),MsgTitre,"www.developpez.com")
	StrCommand = "Tracert"
	LogFile = StrCommand & "Log.txt"
	If fso.FileExists(LogFile) Then fso.DeleteFile LogFile
	Command = "Cmd /c "& StrCommand & " " & Argum &" >> "&LogFile&""
	Titre = "La Traceroute vers "& DblQuote(Argum) &" est en cours ..."
	MsgAttente = "Veuillez patientez !"
	Call CreateProgressBar(Titre,MsgAttente)'Creation de barre de progression
	Voice.Speak "Please Wait a While !"
	Call LancerProgressBar()'Lancement de la barre de progression
      Res = teapod.Run(Command,0,True)'Exécution de la Commande
	Call Formater(LogFile)'Pour formater et remplacer les caractères spéciaux unicode dans le LogFile
	Call FermerProgressBar()'Fermeture de barre de progression
	Voice.Speak "Process of TraceRoute is completed !"
      teapod.popup "La TraceRoute vers "& DblQuote(Argum) &" est terminé ","2",MsgTitre,64
      teapod.popup Formater(LogFile),"5",MsgTitre,64
	Command2 = "Cmd /c Start "&LogFile&""
      startlog = teapod.Run(Command2,0,False)
End Sub
'****************************************************************************************************
Sub CreateProgressBar(Titre,MsgAttente)
      Dim teapod,fso,f,f2,ts,ts2,Ligne,i,fread,LireTout,NbLigneTotal,Temp,PathOutPutHTML,fhta,oExec
	Set ws = CreateObject("wscript.Shell")
	Set fso = CreateObject("Scripting.FileSystemObject")
	Set f = fso.GetFile(WScript.ScriptFullName)
	Set ts = f.OpenAsTextStream(1,-2)
	Set fread = Fso.OpenTextFile(f,1)
	LireTout = fread.ReadAll
	NbLigneTotal = fread.Line 
      Temp = teapod.ExpandEnvironmentStrings("%Temp%")
	PathOutPutHTML = Temp & "Barre.hta"
	Set fhta = fso.OpenTextFile(PathOutPutHTML,2,True)
	fso.CreateTextFile Temp & "loader.gif"
	Set f2 = fso.GetFile(Temp & "loader.gif")
	Set ts2 = f2.OpenAsTextStream(2,-2)
	for i=1 to NbLigneTotal - 1
		ts.skipline
	Next
	Do
		Ligne = ts.readline
		For i=2 to Len(Ligne) step 2
			ts2.write chr( "&h" & mid(Ligne,i,2))
		Next
	loop until ts.AtEndOfStream
	ts.Close
	ts2.Close
	fhta.WriteLine "<HTML>"
	fhta.WriteLine "<HEAD>" 
	fhta.WriteLine "<Title>" & Titre & "</Title>" 
	fhta.WriteLine "<HTA:APPLICATION"
	fhta.WriteLine "ICON = ""Cmd.exe"" "
	fhta.WriteLine "BORDER=""THIN"" "
	fhta.WriteLine "INNERBORDER=""NO"" "
	fhta.WriteLine "MAXIMIZEBUTTON=""NO"" "
	fhta.WriteLine "MINIMIZEBUTTON=""NO"" "
	fhta.WriteLine "SCROLL=""NO"" "
	fhta.WriteLine "SYSMENU=""NO"" "
	fhta.WriteLine "SELECTION=""NO"" " 
	fhta.WriteLine "SINGLEINSTANCE=""YES"">"
	fhta.WriteLine "</HEAD>" 
	fhta.WriteLine "<BODY text=""white""><CENTER><DIV><SPAN ID=""ProgressBar""></SPAN>"
	fhta.WriteLine "<span><marquee DIRECTION=""LEFT"" SCROLLAMOUNT=""3"" BEHAVIOR=ALTERNATE><font face=""Comic sans MS"">" & MsgAttente &" "& Titre & "</font></marquee></span></DIV></CENTER></BODY></HTML>"
	fhta.WriteLine "<SCRIPT LANGUAGE=""VBScript""> "
	fhta.WriteLine "Set ws = CreateObject(""wscript.Shell"")"
	fhta.WriteLine "Temp = WS.ExpandEnvironmentStrings(""%Temp%"")"
	fhta.WriteLine "Sub window_onload()"
	fhta.WriteLine "    CenterWindow 320,90"
	fhta.WriteLine "    Self.document.bgColor = ""Orange"" "
	fhta.WriteLine "    image = ""<center><img src= "& Temp & "loader.gif></center>"" "
	fhta.WriteLine "    ProgressBar.InnerHTML = image"
	fhta.WriteLine " End Sub"
	fhta.WriteLine " Sub CenterWindow(x,y)"
	fhta.WriteLine "    Dim iLeft,itop"
	fhta.WriteLine "    window.resizeTo x,y"
	fhta.WriteLine "    iLeft = window.screen.availWidth/2 - x/2"
	fhta.WriteLine "    itop = window.screen.availHeight/2 - y/2"
	fhta.WriteLine "    window.moveTo ileft,itop"
	fhta.WriteLine "End Sub"
	fhta.WriteLine "</script>"
End Sub
'**********************************************************************************************
Sub LancerProgressBar()
      Set oExec = teapod.Exec("mshta.exe " & Temp & "Barre.hta")
End Sub
'**********************************************************************************************
Sub FermerProgressBar()
	oExec.Terminate
End Sub
'**********************************************************************************************
'Fonction pour ajouter les doubles quotes dans une variable
Function DblQuote(Str)
	DblQuote = Chr(34) & Str & Chr(34)
End Function
'**********************************************************************************************
'Fonction pour formater et remplacer les caractères spéciaux unicode dans le LogFile
Function Formater(File)
	Dim fso,fRead,fWrite,Text
	Set fso = CreateObject("Scripting.FileSystemObject")
	Set fRead = fso.OpenTextFile(File,1)
	Text = fRead.ReadAll
	fRead.Close
	Set fWrite = fso.OpenTextFile(File,2,True)
	Text = Replace(Text,"?","é")
	Text = Replace(Text,"ÿ"," ")
	Text = Replace(Text,"?","ê")
	Text = Replace(Text,"?","ç")
	Text = Replace(Text,"?","ô")
	Text = Replace(Text,"?","à")
	Text = Replace(Text,"?","è")
	Text = Replace(Text,"?","â")
	Text = Replace(Text,"?"," ")
	fWrite.WriteLine Text
	Formater = Text
End Function
else
  y=inputbox "votre avis:" ,vbQuestion, "Teapod"
