unit UConfigIni;

interface

uses System.IniFiles, IWSystem, System.SysUtils, System.Classes;

type
  TConfigIni = class
  private
    class function Ler(ASection, AIdent, ADefault: string): string; overload;
    class function Ler(ASection, AIdent: string; ADefault: Integer): Integer; overload;
  public
    class function Servidor: string;
    class function Usuario: string;
    class function Senha: string;
    class function Database: string;
    class function CharSet: string;
    class function CaminhoImagens: string;
  end;

implementation

{ TConfigIni }

class function TConfigIni.CaminhoImagens: string;
begin
  Result := gsAppPath + TConfigIni.Ler('Parametros', 'Imagens', 'Imagens\');
end;

class function TConfigIni.CharSet: string;
begin
  Result := TConfigIni.Ler('Sistema', 'CharSet', 'ISO8859_1');
end;

class function TConfigIni.Database: string;
begin
  Result := TConfigIni.Ler('Sistema', 'Database', '');
end;

class function TConfigIni.Ler(ASection, AIdent: string; ADefault: Integer): Integer;
var
  Ini: TIniFile;
begin
  Ini := TIniFile.Create(gsAppPath + 'Config.ini');
  try
    Result := Ini.ReadInteger(ASection, AIdent, ADefault);
  finally
    FreeAndNil(Ini);
  end;
end;

class function TConfigIni.Ler(ASection, AIdent, ADefault: string): string;
var
  Ini: TIniFile;
begin
  Ini := TIniFile.Create(gsAppPath + 'Config.ini');
  try
    Result := Ini.ReadString(ASection, AIdent, ADefault);
  finally
    FreeAndNil(Ini);
  end;
end;

class function TConfigIni.Senha: string;
begin
  Result := TConfigIni.Ler('Sistema', 'Senha', '');
end;

class function TConfigIni.Servidor: string;
begin
  Result := TConfigIni.Ler('Sistema', 'Servidor', 'localhost');
end;

class function TConfigIni.Usuario: string;
begin
  Result := TConfigIni.Ler('Sistema', 'Usuario', '');
end;

end.
