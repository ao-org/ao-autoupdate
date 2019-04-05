VERSION 5.00
Object = "{48E59290-9880-11CF-9754-00AA00C00908}#1.0#0"; "MSINET.ocx"
Object = "{3B7C8863-D78F-101B-B9B5-04021C009402}#1.2#0"; "RICHTX32.OCX"
Object = "{55473EAC-7715-4257-B5EF-6E14EBD6A5DD}#1.0#0"; "VBALPROGBAR6.OCX"
Begin VB.Form frmLauncher 
   BackColor       =   &H80000010&
   BorderStyle     =   0  'None
   Caption         =   "Form1"
   ClientHeight    =   6000
   ClientLeft      =   6585
   ClientTop       =   3720
   ClientWidth     =   7500
   Icon            =   "frmLauncher.frx":0000
   LinkTopic       =   "Form1"
   ScaleHeight     =   6000
   ScaleWidth      =   7500
   ShowInTaskbar   =   0   'False
   StartUpPosition =   2  'CenterScreen
   Begin InetCtlsObjects.Inet InetGithubReleases 
      Left            =   240
      Top             =   5400
      _ExtentX        =   1005
      _ExtentY        =   1005
      _Version        =   393216
   End
   Begin InetCtlsObjects.Inet InetGithubAutoupdate 
      Left            =   0
      Top             =   5160
      _ExtentX        =   1005
      _ExtentY        =   1005
      _Version        =   393216
   End
   Begin RichTextLib.RichTextBox RichTextBoxLog 
      Height          =   1190
      Left            =   1945
      TabIndex        =   0
      Top             =   2970
      Width           =   3600
      _ExtentX        =   6350
      _ExtentY        =   2090
      _Version        =   393217
      BackColor       =   0
      BorderStyle     =   0
      Enabled         =   -1  'True
      ReadOnly        =   -1  'True
      Appearance      =   0
      TextRTF         =   $"frmLauncher.frx":C84A
      BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
         Name            =   "Terminal"
         Size            =   6
         Charset         =   255
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
   End
   Begin vbalProgBarLib6.vbalProgressBar ProgressBar1 
      Height          =   300
      Left            =   1260
      TabIndex        =   2
      Top             =   4440
      Width           =   5025
      _ExtentX        =   8864
      _ExtentY        =   529
      Picture         =   "frmLauncher.frx":C8CB
      BackColor       =   0
      ForeColor       =   16777152
      Appearance      =   0
      BorderStyle     =   0
      BarColor        =   16777215
      BarForeColor    =   12648384
      BarPicture      =   "frmLauncher.frx":C8E7
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
   Begin VB.Image BtnJugarBots 
      Height          =   375
      Left            =   5760
      Top             =   3720
      Width           =   1335
   End
   Begin VB.Image BtnWorldEditor 
      Height          =   375
      Left            =   5160
      Top             =   5040
      Width           =   1335
   End
   Begin VB.Image BtnAoSetup 
      Height          =   375
      Left            =   5760
      Top             =   3000
      Width           =   1335
   End
   Begin VB.Image BtnClose 
      Height          =   255
      Left            =   6870
      Top             =   360
      Width           =   255
   End
   Begin VB.Image LblEnglish 
      Height          =   375
      Left            =   3950
      Top             =   2310
      Width           =   1335
   End
   Begin VB.Image LblSpanish 
      Height          =   375
      Left            =   2200
      Top             =   2310
      Width           =   1335
   End
   Begin VB.Image BtnGame 
      Height          =   375
      Left            =   3090
      Top             =   5040
      Width           =   1335
   End
   Begin VB.Image BtnServer 
      Height          =   375
      Left            =   980
      Top             =   5040
      Width           =   1330
   End
   Begin VB.Label LblVersion 
      BackColor       =   &H80000013&
      BackStyle       =   0  'Transparent
      Caption         =   "Version"
      BeginProperty Font 
         Name            =   "Palatino Linotype"
         Size            =   12
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H000000C0&
      Height          =   375
      Left            =   360
      TabIndex        =   1
      Top             =   360
      Width           =   975
   End
End
Attribute VB_Name = "frmLauncher"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Private Declare Sub Sleep Lib "kernel32.dll" (ByVal dwMilliseconds As Long)
Dim Directory As String, bDone As Boolean, dError As Boolean, F As Integer

Dim SizeInMb As Double
Dim JsonObject As Object

Private Language As String
Private JsonLanguage As Object

Private Sub BtnGame_Click()
    BtnGame.Picture = LoadPicture(App.Path & "\Graficos\BotonJuegoClick_" & JsonLanguage.Item("lang_abbreviation") & ".jpg")
    BtnGame.Enabled = False
    
    Call Analizar("Client")
    BtnGame.Enabled = True
End Sub

Private Sub BtnJugarBots_Click()
    Call Analizar("FronBot")
End Sub

Private Sub BtnWorldeditor_Click()
    Call Analizar("Worldeditor")
End Sub

Private Sub BtnClose_Click()
    End
End Sub

Private Sub BtnServer_Click()
    BtnServer.Picture = LoadPicture(App.Path & "\Graficos\BotonServidorClick_" & JsonLanguage.Item("lang_abbreviation") & ".jpg")
    BtnServer.Enabled = False
    
    Call Analizar("Server")
    BtnServer.Enabled = True
End Sub

Private Sub BtnAoSetup_Click()
    Call Analizar("AOSetup")
End Sub

Private Sub LblEnglish_Click()
    Call WriteVar(App.Path & "\ConfigAutoupdate.ini", "ConfigAutoupdate", "language", "english")
    Call LaunchPopUpBeforeClose
End Sub

Private Sub LblSpanish_Click()
    Call WriteVar(App.Path & "\ConfigAutoupdate.ini", "ConfigAutoupdate", "language", "spanish")
    Call LaunchPopUpBeforeClose
End Sub

Private Sub LaunchPopUpBeforeClose()
    If MsgBox(JsonLanguage.Item("close_before_change_language"), vbYesNo) = vbYes Then
        End
    End If
End Sub

Private Sub Form_Load()
    LblVersion.Caption = GetVar(App.Path & "\ConfigAutoupdate.ini", "ConfigAutoupdate", "version")
    Call SetLanguageApplication
    Call CheckIfIEVersionIsCompatible
    Call CheckIfRunningLastVersionAutoupdate

    BtnServer.Picture = LoadPicture(App.Path & "\Graficos\BotonServidor_" & JsonLanguage.Item("lang_abbreviation") & ".jpg")
    BtnGame.Picture = LoadPicture(App.Path & "\Graficos\BotonJuego_" & JsonLanguage.Item("lang_abbreviation") & ".jpg")
    'BtnWorldEditor.Picture = LoadPicture(App.Path & "\Graficos\BotonWorldeditor_" & JsonLanguage.Item("lang_abbreviation") & ".jpg")
    BtnAoSetup.Picture = LoadPicture(App.Path & "\Graficos\BotonSetup_" & JsonLanguage.Item("lang_abbreviation") & ".jpg")
    BtnJugarBots.Picture = LoadPicture(App.Path & "\Graficos\BotonJugarBots_" & JsonLanguage.Item("lang_abbreviation") & ".jpg")
    
    frmLauncher.Picture = LoadPicture(App.Path & "\Graficos\AU_Main_" & JsonLanguage.Item("lang_abbreviation") & ".jpg")
    
    ProgressBar1.Value = 0
    ProgressBar1.Text = JsonLanguage.Item("completed")
End Sub

Private Sub SetLanguageApplication(Optional LanguageSelection As String)
    Dim JsonLanguageString As String
    
    If LanguageSelection = "" Then
        Language = GetVar(App.Path & "\ConfigAutoupdate.ini", "ConfigAutoupdate", "language")
    Else
        Language = LanguageSelection
    End If
    
    JsonLanguageString = FileToString(App.Path & "\Languages\" & Language & ".json")
    Set JsonLanguage = JSON.parse(JsonLanguageString)
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
        Dim windowsXpTutorial As String
        windowsXpTutorial = GetVar(App.Path & "\ConfigAutoupdate.ini", "Links", "windowsXpTutorial")
        MsgBox (Replace(JsonLanguage.Item("error_ie"), "VAR_IEVersion", IEVersionArray(0)))
        MsgBox (JsonLanguage.Item("error_windows_xp") & windowsXpTutorial)
        End
    End If
End Function

Private Function FileToString(strFilename As String) As String
    IFile = FreeFile
    Open strFilename For Input As #IFile
        FileToString = StrConv(InputB(LOF(IFile), IFile), vbUnicode)
    Close #IFile
End Function

Private Sub CheckIfRunningLastVersionAutoupdate()
    Dim responseGithub As String, versionNumberMaster As String, versionNumberLocal As String
    Dim githubAccount As String
    
    githubAccount = GetVar(App.Path & "\ConfigAutoupdate.ini", "ConfigAutoupdate", "githubAccount")

    responseGithub = InetGithubAutoupdate.OpenURL("https://api.github.com/repos/" & githubAccount & "/ao-autoupdate/releases/latest")
    Set JsonObject = JSON.parse(responseGithub)
    
    versionNumberMaster = JsonObject.Item("tag_name")
    versionNumberLocal = GetVar(App.Path & "\ConfigAutoupdate.ini", "ConfigAutoupdate", "version")
    
    If Not versionNumberMaster = versionNumberLocal Then
        MsgBox (JsonLanguage.Item("launcher_outdated"))
        MsgBox (JsonLanguage.Item("your_version") & " " & versionNumberLocal & " " & JsonLanguage.Item("last_version") & " " & versionNumberMaster)
        End
    End If
End Sub

Private Function CheckIfApplicationIsUpdated(ApplicationToUpdate As String) As Boolean
    Dim versionNumberLocal As String, versionNumberMaster As String
    Dim repository As String, githubAccount As String
    Dim responseGithub As String, urlEndpointUpdate As String, fileToExecuteAfterUpdated As String
    Dim applicationName As String
    
    githubAccount = GetVar(App.Path & "\ConfigAutoupdate.ini", ApplicationToUpdate, "githubAccount")
    applicationName = GetVar(App.Path & "\ConfigAutoupdate.ini", ApplicationToUpdate, "application")
    
    Call addConsole(JsonLanguage.Item("looking_for_upgrades"), 255, 255, 255, True, False)
    Call addConsole(JsonLanguage.Item("configured_to") & applicationName, 100, 200, 40, True, False)   '>> Informacion
    
    Call Reproducir_WAV(App.Path & "\Wav\Revision_" & JsonLanguage.Item("lang_abbreviation") & ".wav", SND_FILENAME)
    
    repository = GetVar(App.Path & "\ConfigAutoupdate.ini", ApplicationToUpdate, "repository")
    urlEndpointUpdate = "https://api.github.com/repos/" & githubAccount & "/" & repository & "/releases/latest"
    
    responseGithub = InetGithubReleases.OpenURL(urlEndpointUpdate)

    Set JsonObject = JSON.parse(responseGithub)
    versionNumberMaster = JsonObject.Item("tag_name")
    versionNumberLocal = GetVar(App.Path & "\ConfigAutoupdate.ini", ApplicationToUpdate, "version")

    If versionNumberMaster = versionNumberLocal Then
        CheckIfApplicationIsUpdated = True
    ElseIf Not versionNumberMaster = versionNumberLocal Then
        CheckIfApplicationIsUpdated = False
    End If
    
End Function

Private Sub Analizar(ApplicationToUpdate As String)
    Dim SubDirectoryApp As String
    Dim IsApplicationUpdated As Boolean
    Dim CancelUpdate As Boolean
    
    IsApplicationUpdated = CheckIfApplicationIsUpdated(ApplicationToUpdate)
    SubDirectoryApp = GetVar(App.Path & "\ConfigAutoupdate.ini", ApplicationToUpdate, "folderToExtract")
    
    If IsApplicationUpdated = True Then
        Call addConsole(JsonLanguage.Item("up_to_date"), 149, 100, 210, True, False)
    Else
        If MsgBox(JsonLanguage.Item("download_continue"), vbYesNo) = vbYes Then
            ProgressBar1.Visible = True
            
            Call addConsole(JsonLanguage.Item("starting"), 200, 200, 200, True, False)   '>> Informacion
            
            ProgressBar1.Max = JsonObject.Item("assets").Item(1).Item("size")
            SizeInMb = BytesToMegabytes(JsonObject.Item("assets").Item(1).Item("size"))
            
            InetGithubAutoupdate.AccessType = icUseDefault
            InetGithubAutoupdate.URL = JsonObject.Item("assets").Item(1).Item("browser_download_url")
            Directory = App.Path & "\Updates\" & JsonObject.Item("assets").Item(1).Item("name")
            bDone = False
            dError = False
                
            InetGithubAutoupdate.Execute , "GET"
            
            Do While bDone = False
                DoEvents
            Loop
                
            If dError Then Exit Sub
            
            Call addConsole(JsonLanguage.Item("one_more_moment"), 50, 90, 220, True, False)
            UnZip Directory, App.Path & "\" & SubDirectoryApp
            Kill Directory
            
            Call WriteVar(App.Path & "\ConfigAutoupdate.ini", ApplicationToUpdate, "version", CStr(JsonObject.Item("tag_name")))
            
            Call addConsole(ApplicationToUpdate & JsonLanguage.Item("update_succesful"), 66, 255, 30, True, False)
            Call addConsole(JsonLanguage.Item("comments_update") & JsonObject.Item("body") & ".", 200, 200, 200, True, False)
            Call Reproducir_WAV(App.Path & "\Wav\Actualizado_" & JsonLanguage.Item("lang_abbreviation") & ".wav", SND_FILENAME)
            ProgressBar1.Value = 0
            
        ElseIf vbNo Then
            Call addConsole(JsonLanguage.Item("download_canceled"), 255, 0, 0, True, False)
            CancelUpdate = True
        End If
    End If
    
    If CancelUpdate = False Then
        If MsgBox(Replace(JsonLanguage.Item("open_app"), "VAR_Program", ApplicationToUpdate), vbYesNo) = vbYes Then
            fileToExecuteAfterUpdated = GetVar(App.Path & "\ConfigAutoupdate.ini", ApplicationToUpdate, "fileToExecuteAfterUpdated")
            
            If LenB(SubDirectoryApp) > 0 Then
                Call ShellExecute(Me.hWnd, "open", App.Path & "\" & SubDirectoryApp & "\" & fileToExecuteAfterUpdated, "", "", 1)
            Else
                Call ShellExecute(Me.hWnd, "open", App.Path & "\" & fileToExecuteAfterUpdated, "", "", 1)
            End If
            
            'End
        End If
    End If

End Sub


Private Sub InetGithubAutoupdate_StateChanged(ByVal State As Integer)
    Dim Percentage As Long
    Select Case State
        Case icError
            Call addConsole(JsonLanguage.Item("error_connection"), 255, 0, 0, True, False)
            bDone = True
            dError = True
        Case icResponseCompleted
            Dim vtData As Variant
            Dim tempArray() As Byte
            Call addConsole(JsonLanguage.Item("download_started"), 100, 255, 130, True, False)
            
            Open Directory For Binary Access Write As #1
                vtData = InetGithubAutoupdate.GetChunk(1024, icByteArray)
                DoEvents
                
                Do While Not Len(vtData) = 0
                    tempArray = vtData
                    Put #1, , tempArray
                    
                    vtData = InetGithubAutoupdate.GetChunk(1024, icByteArray)

                    ProgressBar1.Value = ProgressBar1.Value + Len(vtData) * 2
                    
                    Percentage = (ProgressBar1.Value / ProgressBar1.Max) * 100
                    ProgressBar1.Text = "[" & Percentage & "% de " & SizeInMb & " MBs.]"
                    
                    DoEvents
                Loop
            Close #1
            
            Call addConsole(JsonLanguage.Item("download_finished"), 0, 255, 0, True, False)

            ProgressBar1.Value = 0
            
            bDone = True
        Case icRequesting
            'Call addConsole("Buscando ultima version disponible", 0, 76, 0, True, False)
        Case icConnecting
            'Call addConsole("Obteniendo numero de la ultima actualizacion ¯\_(O.O)_/¯", 0, 255, 0, True, False)
        Case 1 'icHostResolvingHost
            'Call addConsole("Resolviendo host... por favor espere", 0, 130, 0, True, False)
        Case icRequestSent
            'Call addConsole("Seguimos resolviendo host..", 110, 230, 20, True, False)
        Case icReceivingResponse
            'Call addConsole("Escuchamos una señal, vamos a comprobar que tengas la ultima version.", 100, 190, 200, True, False)
        Case icConnected
            'Call addConsole("Nos conectamos, ya vamos a empezar a bajar... paciencia =P ", 200, 90, 220, True, False)
        Case icResponseReceived
            'Call addConsole("Recibimos respuesta", 250, 140, 10, True, False)
        Case icHostResolved
            'Call addConsole("Lo hicimos resolvimos el host.", 110, 30, 20, True, False)
        Case Else
            Dim WebpageAolibre As String
            WebpageAolibre = GetVar(App.Path & "\ConfigAutoupdate.ini", "Links", "webpage")
            Call addConsole(JsonLanguage.Item("error_connection") & WebpageAolibre, 255, 0, 0, True, False)
    End Select
End Sub
