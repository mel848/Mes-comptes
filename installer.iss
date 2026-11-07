; Installateur Windows de MesComptes
; Il installe l'icône et un raccourci qui ouvre l'appli dans sa propre fenêtre Edge
; (Edge est nécessaire pour la dictée vocale et la lecture des photos).
; L'emplacement d'Edge est cherché automatiquement (il varie selon les PC).
#define AppUrl "https://mel848.github.io/Mes-comptes/"

[Setup]
AppName=MesComptes
AppVersion=1.1
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
Name: "{autodesktop}\MesComptes"; Filename: "{code:LanceurExe}"; Parameters: "{code:LanceurParams}"; IconFilename: "{app}\icon.ico"; Comment: "Mes comptes bancaires"
Name: "{autoprograms}\MesComptes"; Filename: "{code:LanceurExe}"; Parameters: "{code:LanceurParams}"; IconFilename: "{app}\icon.ico"; Comment: "Mes comptes bancaires"

[Run]
Filename: "{code:LanceurExe}"; Parameters: "{code:LanceurParams}"; Description: "Ouvrir MesComptes"; Flags: nowait postinstall skipifsilent

[Code]
var
  EdgeExe: String;
  EdgeCherche: Boolean;

function Essaye(Chemin: String): Boolean;
begin
  Result := (Chemin <> '') and FileExists(Chemin);
  if Result then EdgeExe := Chemin;
end;

function LireAppPath(Racine: Integer): Boolean;
var
  P: String;
begin
  Result := False;
  if RegQueryStringValue(Racine, 'SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\msedge.exe', '', P) then
    Result := Essaye(RemoveQuotes(P));
end;

procedure TrouverEdge();
begin
  if EdgeCherche then Exit;
  EdgeCherche := True;
  EdgeExe := '';
  if LireAppPath(HKCU) then Exit;
  if LireAppPath(HKLM) then Exit;
  if IsWin64 then
  begin
    if LireAppPath(HKLM64) then Exit;
    if Essaye(ExpandConstant('{commonpf64}\Microsoft\Edge\Application\msedge.exe')) then Exit;
  end;
  if Essaye(ExpandConstant('{commonpf32}\Microsoft\Edge\Application\msedge.exe')) then Exit;
  if Essaye(ExpandConstant('{localappdata}\Microsoft\Edge\Application\msedge.exe')) then Exit;
end;

{ Si Edge est introuvable, on ouvre l'appli dans le navigateur par défaut }
function LanceurExe(Param: String): String;
begin
  TrouverEdge();
  if EdgeExe <> '' then
    Result := EdgeExe
  else
    Result := ExpandConstant('{win}\explorer.exe');
end;

function LanceurParams(Param: String): String;
begin
  TrouverEdge();
  if EdgeExe <> '' then
    Result := '--app={#AppUrl}'
  else
    Result := '{#AppUrl}';
end;
