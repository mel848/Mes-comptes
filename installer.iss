; Installateur Windows de MesComptes
; Il installe l'icône et un raccourci qui ouvre l'appli dans sa propre fenêtre Edge
; (Edge est nécessaire pour la dictée vocale et la lecture des photos).
#define AppUrl "https://mel848.github.io/Mes-comptes/"
#define Edge "{commonpf32}\Microsoft\Edge\Application\msedge.exe"

[Setup]
AppName=MesComptes
AppVersion=1.0
AppPublisher=MesComptes
DefaultDirName={autopf}\MesComptes
DisableProgramGroupPage=yes
DisableDirPage=yes
PrivilegesRequired=lowest
OutputDir=output
OutputBaseFilename=MesComptes-Setup
SetupIconFile=icon.ico
UninstallDisplayIcon={app}\icon.ico
WizardStyle=modern

[Languages]
Name: "fr"; MessagesFile: "compiler:Languages\French.isl"

[Files]
Source: "icon.ico"; DestDir: "{app}"

[Icons]
Name: "{autodesktop}\MesComptes"; Filename: "{#Edge}"; Parameters: "--app={#AppUrl}"; IconFilename: "{app}\icon.ico"; Comment: "Mes comptes bancaires"
Name: "{autoprograms}\MesComptes"; Filename: "{#Edge}"; Parameters: "--app={#AppUrl}"; IconFilename: "{app}\icon.ico"; Comment: "Mes comptes bancaires"

[Run]
Filename: "{#Edge}"; Parameters: "--app={#AppUrl}"; Description: "Ouvrir MesComptes"; Flags: nowait postinstall skipifsilent
