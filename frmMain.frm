VERSION 5.00
Object = "{48E59290-9880-11CF-9754-00AA00C00908}#1.0#0"; "MSINET.ocx"
Object = "{3B7C8863-D78F-101B-B9B5-04021C009402}#1.2#0"; "RICHTX32.OCX"
Object = "{55473EAC-7715-4257-B5EF-6E14EBD6A5DD}#1.0#0"; "VBALPROGBAR6.OCX"
Begin VB.Form frmMain 
   BackColor       =   &H00C00000&
   BorderStyle     =   0  'None
   ClientHeight    =   3600
   ClientLeft      =   -60
   ClientTop       =   -165
   ClientWidth     =   6780
   ClipControls    =   0   'False
   ControlBox      =   0   'False
   Icon            =   "frmMain.frx":0000
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   3600
   ScaleWidth      =   6780
   ShowInTaskbar   =   0   'False
   StartUpPosition =   2  'CenterScreen
   Begin vbalProgBarLib6.vbalProgressBar ProgressBar1 
      Height          =   450
      Left            =   240
      TabIndex        =   2
      Top             =   2160
      Width           =   6345
      _ExtentX        =   11192
      _ExtentY        =   794
      Picture         =   "frmMain.frx":0CCA
      BackColor       =   4194368
      ForeColor       =   0
      BorderStyle     =   0
      BarPicture      =   "frmMain.frx":0CE6
      BarPictureMode  =   0
      BackPictureMode =   0
      ShowText        =   -1  'True
      Text            =   "[0% Completado]"
      BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
   End
   Begin InetCtlsObjects.Inet Inet1 
      Left            =   6120
      Top             =   120
      _ExtentX        =   1005
      _ExtentY        =   1005
      _Version        =   393216
   End
   Begin RichTextLib.RichTextBox RichTextBox1 
      Height          =   1095
      Left            =   120
      TabIndex        =   1
      Top             =   240
      Width           =   6630
      _ExtentX        =   11695
      _ExtentY        =   1931
      _Version        =   393217
      BackColor       =   0
      BorderStyle     =   0
      ReadOnly        =   -1  'True
      TextRTF         =   $"frmMain.frx":669A
   End
   Begin VB.Label Label1 
      BackStyle       =   0  'Transparent
      Caption         =   "Este programa actualizar� tu aplicacion a la nueva versi�n. Para empezar clickea en buscar actualizaciones"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H00000000&
      Height          =   375
      Left            =   240
      TabIndex        =   0
      Top             =   1440
      Width           =   6495
   End
   Begin VB.Image Image1 
      Height          =   630
      Left            =   4200
      Top             =   2880
      Width           =   2385
   End
   Begin VB.Image Image2 
      Height          =   630
      Left            =   240
      Top             =   2880
      Width           =   3615
   End
End
Attribute VB_Name = "frmMain"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private Const GWL_EXSTYLE = -20
Private Const WS_EX_LAYERED = &H80000
Private Const WS_EX_TRANSPARENT As Long = &H20&
Private Declare Sub Sleep Lib "kernel32.dll" (ByVal dwMilliseconds As Long)
Dim Directory As String, bDone As Boolean, dError As Boolean, F As Integer
Dim SizeInMb As Double
Rem Programado por Shedark

Private Sub Analizar()
    Dim versionNumberLocal As String, versionNumberMaster As String
    Dim applicationToUpdate As String, repository As String, githubAccount As String
    Dim responseGithub As String, urlEndpointUpdate As String, fileToExecuteAfterUpdated As String
    Dim JsonObject As Object
    
    githubAccount = GetVar(App.Path & "\ConfigAutoupdate.ini", "ApplicationToUpdate", "githubAccount")
    Call CheckIfRunningLastVersionAutoupdate(githubAccount)
    
    Call addConsole("Buscando Actualizaciones �\_(O.O)_/�", 255, 255, 255, True, False)
    Call Reproducir_WAV(App.Path & "\Wav\Revision.wav", SND_FILENAME)
    
    applicationToUpdate = GetVar(App.Path & "\ConfigAutoupdate.ini", "ApplicationToUpdate", "application")
    repository = GetVar(App.Path & "\ConfigAutoupdate.ini", "ApplicationToUpdate", "repository")
    urlEndpointUpdate = "https://api.github.com/repos/" & githubAccount & "/" & repository & "/releases/latest"
    responseGithub = Inet1.OpenURL(urlEndpointUpdate)

    Set JsonObject = JSON.parse(responseGithub)
    versionNumberMaster = JsonObject.Item("tag_name")
    versionNumberLocal = GetVar(App.Path & "\ConfigAutoupdate.ini", "ApplicationToUpdate", "version")
    
    Call addConsole("Estoy configurado para actualizar tu " & applicationToUpdate, 100, 200, 40, True, False)   '>> Informacion
    
    If versionNumberMaster = versionNumberLocal Then
        Call addConsole("Tu version de Argentum Online Libre esta actualizada, no hace falta actualizar, entra y juga =D.", 149, 100, 210, True, False)
    ElseIf Not versionNumberMaster = versionNumberLocal Then
        If MsgBox("Se descargar� la nueva version, �Continuar?", vbYesNo) = vbYes Then
            ProgressBar1.Visible = True
            
            Call addConsole("Iniciando, se descargar�n actualizaciones.", 200, 200, 200, True, False)   '>> Informacion
            
            ProgressBar1.Max = JsonObject.Item("assets").Item(1).Item("size")
            SizeInMb = BytesToMegabytes(JsonObject.Item("assets").Item(1).Item("size"))
            
            Inet1.AccessType = icUseDefault
            Inet1.URL = JsonObject.Item("assets").Item(1).Item("browser_download_url")
            Directory = App.Path & "\Updates\" & JsonObject.Item("assets").Item(1).Item("name")
            bDone = False
            dError = False
                
            frmMain.Inet1.Execute , "GET"
            
            Do While bDone = False
            DoEvents
            Loop
                
            If dError Then Exit Sub
            Call addConsole("Instalando actualizacion... unos momentos mas por favor ", 50, 90, 220, True, False)
            UnZip Directory, App.Path & "\"
            Kill Directory
            
            Call WriteVar(App.Path & "\ConfigAutoupdate.ini", "ApplicationToUpdate", "version", CStr(versionNumberMaster))
            Call addConsole(applicationToUpdate & " actualizado correctamente.", 66, 255, 30, True, False)
            Call addConsole("Comentarios de la actualizacion: " & JsonObject.Item("body") & ".", 200, 200, 200, True, False)
            Call Reproducir_WAV(App.Path & "\Wav\Actualizado.wav", SND_FILENAME)
            ProgressBar1.Value = 0
            
        ElseIf vbNo Then
            Call addConsole("Se cancelo la actualizacion.", 255, 0, 0, True, False)
        End If
    End If

    If MsgBox("�Deseas Jugar?", vbYesNo) = vbYes Then
        fileToExecuteAfterUpdated = GetVar(App.Path & "\ConfigAutoupdate.ini", "ApplicationToUpdate", "fileToExecuteAfterUpdated")
        Call ShellExecute(Me.hWnd, "open", App.Path & "\" & fileToExecuteAfterUpdated, "", "", 1)
        End
     Else
        End
    End If

End Sub

Public Function BytesToMegabytes(Bytes As Double) As Double
   'This function gives an estimate to two decimal
   'places.  For a more precise answer, format to
   'more decimal places or just return dblAns
 
  Dim dblAns As Double
  dblAns = (Bytes / 1024) / 1024
  BytesToMegabytes = Format(dblAns, "###,###,##0.00")
  
End Function

Private Sub CheckIfRunningLastVersionAutoupdate(githubAccount)
    Dim responseGithub As String, versionNumberMaster As String, versionNumberLocal As String
    Dim JsonObject As Object

    responseGithub = Inet1.OpenURL("https://api.github.com/repos/" & githubAccount & "/ao-autoupdate/releases/latest")
    Set JsonObject = JSON.parse(responseGithub)
    
    versionNumberMaster = JsonObject.Item("tag_name")
    versionNumberLocal = GetVar(App.Path & "\ConfigAutoupdate.ini", "ConfigAutoupdate", "version")
    
    If Not versionNumberMaster = versionNumberLocal Then
        Call addConsole("El actualizador esta desactualizado, por favor descarga la ultima version desde http://www.ArgentumOnline.org. Este programa se cerrara en 10 segundos", 200, 200, 200, True, False)   '>> Informacion
        Call addConsole("Tu version: " & versionNumberLocal & " - Version Actual:" & versionNumberMaster, 200, 200, 26, True, False)   '>> Informacion
        Sleep 10000
        End
    End If
End Sub

Private Sub Form_Load()
    ProgressBar1.Picture = LoadPicture(App.Path & "\Graficos\AU_BarraVacia.jpg")
    Image2.Picture = LoadPicture(App.Path & "\Graficos\AU_Buscar_N.jpg")
    Image1.Picture = LoadPicture(App.Path & "\Graficos\AU_Salir_N.jpg")
    frmMain.Picture = LoadPicture(App.Path & "\Graficos\AU_Main.jpg")
    ProgressBar1.Value = 0
End Sub

Private Sub Form_MouseMove(Button As Integer, Shift As Integer, X As Single, Y As Single)
    Image2.Picture = LoadPicture(App.Path & "\Graficos\AU_Buscar_N.jpg")
    Image1.Picture = LoadPicture(App.Path & "\Graficos\AU_Salir_N.jpg")
End Sub

Private Sub Image1_Click()
    Image1.Picture = LoadPicture(App.Path & "\Graficos\AU_Salir_A.jpg")
End
End Sub

Private Sub Image1_MouseDown(Button As Integer, Shift As Integer, X As Single, Y As Single)
    Image1.Picture = LoadPicture(App.Path & "\Graficos\AU_Salir_A.jpg")
End Sub

Private Sub Image1_MouseMove(Button As Integer, Shift As Integer, X As Single, Y As Single)
    Image1.Picture = LoadPicture(App.Path & "\Graficos\AU_Salir_I.jpg")
End Sub

Public Function GetIEVersion()
    Dim FileSystemObject As New FileSystemObject
    Dim Version As String
    
    Version = FileSystemObject.GetFileVersion("c:\windows\system32\ieframe.dll")
    GetIEVersion = Version
End Function

Public Function CheckIfIEVersionIsCompatible()
    Dim IEVersion As String
    Dim IEVersionArray() As String

    IEVersion = GetIEVersion
    IEVersionArray() = Split(IEVersion, ".")

    If CInt(IEVersionArray(0)) < 10 Then
        MsgBox ("Tu version de Internet Explorer " & IEVersionArray(0) & " no es compatible. Necesitas Internet Explorer 11 o una version superior para poder utilizar el actualizador.")
        MsgBox ("Si utilizas Windows XP o no podes actualizar Internet Explorer a la version 11 o superior, por favor lee el siguiente post para la instalacion del juego: https://www.reddit.com/r/argentumonlineoficial/comments/9ywcvb/instalacion_windows_xp_importante/")
        End
    End If
End Function

Private Sub Image2_Click()
    Image2.Enabled = False
    Image2.Picture = LoadPicture(App.Path & "\Graficos\AU_Buscar_A.jpg")

    Call CheckIfIEVersionIsCompatible
    Call Analizar
End Sub

Private Sub Image2_MouseDown(Button As Integer, Shift As Integer, X As Single, Y As Single)
    Image2.Picture = LoadPicture(App.Path & "\Graficos\AU_Buscar_A.jpg")
End Sub

Private Sub Image2_MouseMove(Button As Integer, Shift As Integer, X As Single, Y As Single)
    Image2.Picture = LoadPicture(App.Path & "\Graficos\AU_Buscar_I.jpg")
End Sub

Private Sub Inet1_StateChanged(ByVal State As Integer)
    Dim Percentage As Long
    Select Case State
        Case icError
            Call addConsole("Error en la conexi�n, descarga abortada.", 255, 0, 0, True, False)
            bDone = True
            dError = True
        Case icResponseCompleted
            Dim vtData As Variant
            Dim tempArray() As Byte
            
            Call addConsole("Descarga iniciada.", 100, 255, 130, True, False)
            
            Open Directory For Binary Access Write As #1
                vtData = Inet1.GetChunk(1024, icByteArray)
                DoEvents
                
                Do While Not Len(vtData) = 0
                    tempArray = vtData
                    Put #1, , tempArray
                    
                    vtData = Inet1.GetChunk(1024, icByteArray)

                    ProgressBar1.Value = ProgressBar1.Value + Len(vtData) * 2
                    
                    Percentage = (ProgressBar1.Value / ProgressBar1.Max) * 100
                    ProgressBar1.Text = "[" & Percentage & "% de " & SizeInMb & " MBs descargados.]"
                    
                    DoEvents
                Loop
            Close #1
            
            Call addConsole("Descarga finalizada", 0, 255, 0, True, False)

            ProgressBar1.Value = 0
            
            bDone = True
        Case icRequesting
            'Call addConsole("Buscando ultima version disponible", 0, 76, 0, True, False)
        Case icConnecting
            'Call addConsole("Obteniendo numero de la ultima actualizacion �\_(O.O)_/�", 0, 255, 0, True, False)
        Case 1 'icHostResolvingHost
            'Call addConsole("Resolviendo host... por favor espere", 0, 130, 0, True, False)
        Case icRequestSent
            'Call addConsole("Seguimos resolviendo host..", 110, 230, 20, True, False)
        Case icReceivingResponse
            'Call addConsole("Escuchamos una se�al, vamos a comprobar que tengas la ultima version.", 100, 190, 200, True, False)
        Case icConnected
            'Call addConsole("Nos conectamos, ya vamos a empezar a bajar... paciencia =P ", 200, 90, 220, True, False)
        Case icResponseReceived
            'Call addConsole("Recibimos respuesta", 250, 140, 10, True, False)
        Case icHostResolved
            'Call addConsole("Lo hicimos resolvimos el host.", 110, 30, 20, True, False)
        Case Else
            Call addConsole("Error al querer buscar la actualizacion, por favor intente mas tarde o contactanos http://www.argentumonline.org", 255, 0, 0, True, False)
    End Select
End Sub

Private Sub Form_Unload(Cancel As Integer)
End
End Sub

Private Function LeerInt(ByVal Ruta As String) As Integer
    F = FreeFile
    Open Ruta For Input As F
    LeerInt = Input$(LOF(F), #F)
    Close #F
End Function

Private Sub GuardarInt(ByVal Ruta As String, ByVal data As Integer)
    F = FreeFile
    Open Ruta For Output As F
    Print #F, data
    Close #F
End Sub
