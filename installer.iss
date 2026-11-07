; Installateur Windows de MesComptes
; L'appli est copiée sur le PC et s'ouvre dans sa propre fenêtre Edge
; (Edge est nécessaire pour la dictée vocale). Pas besoin de GitHub Pages.

[Setup]
AppName=MesComptes
AppVersion=1.3
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
Source: "index.html"; DestDir: "{app}"; Flags: ignoreversion
Source: "manifest.json"; DestDir: "{app}"; Flags: ignoreversion
Source: "icon-192.png"; DestDir: "{app}"; Flags: ignoreversion
Source: "icon-512.png"; DestDir: "{app}"; Flags: ignoreversion
Source: "icon.ico"; DestDir: "{app}"; Flags: ignoreversion

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
  { Pas d'Edge : on prend Google Chrome (la dictée y marche aussi) }
  if RegQueryStringValue(HKCU, 'SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\chrome.exe', '', EdgeExe) and Essaye(RemoveQuotes(EdgeExe)) then Exit;
  EdgeExe := '';
  if RegQueryStringValue(HKLM, 'SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\chrome.exe', '', EdgeExe) and Essaye(RemoveQuotes(EdgeExe)) then Exit;
  EdgeExe := '';
  if IsWin64 then
    if Essaye(ExpandConstant('{commonpf64}\Google\Chrome\Application\chrome.exe')) then Exit;
  if Essaye(ExpandConstant('{commonpf32}\Google\Chrome\Application\chrome.exe')) then Exit;
  if Essaye(ExpandConstant('{localappdata}\Google\Chrome\Application\chrome.exe')) then Exit;
  EdgeExe := '';
end;

{ Adresse locale de l'appli : file:///C:/Users/.../MesComptes/index.html }
function AdresseAppli(): String;
var
  S: String;
begin
  S := ExpandConstant('{app}\index.html');
  StringChangeEx(S, '\', '/', True);
  StringChangeEx(S, ' ', '%20', True);
  Result := 'file:///' + S;
end;

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
    Result := '--app="' + AdresseAppli() + '"'
  else
    Result := '"' + ExpandConstant('{app}\index.html') + '"';
end;
